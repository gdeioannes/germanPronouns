#!/usr/bin/env node
// Posts to the site's Instagram account (@language.quiz) through the Graph API.
//
//   node tool/instagram.mjs --caption caption.txt slide1.jpg slide2.jpg ...
//       uploads the JPEGs to R2 (instagram/<date>/…), checks they are public,
//       prints the preview and stops: NOTHING is posted.
//   node tool/instagram.mjs --caption caption.txt slide1.jpg ... --yes
//       the same, then publishes (one image = single post, 2–20 = carousel).
//   node tool/instagram.mjs --whoami
//       read-only: account name, followers, posts.
//
// Instagram fetches the images itself, so they must be public JPEGs: they go
// to the R2 bucket served at https://media.languagequiz.org.
//
// Needs, in .env: INSTAGRAM_ACCESS_TOKEN (the never-expiring system-user
// token from the Meta app "languagequiz.org-IG", API setup with Unified
// login), INSTAGRAM_USER_ID, and the R2_* keys media-sync.mjs uses.
// The token is an EAA… token: it works on graph.facebook.com only.

import { readFileSync, existsSync } from 'node:fs';
import { basename, join } from 'node:path';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';

const root = join(import.meta.dirname, '..');
if (existsSync(join(root, '.env'))) process.loadEnvFile(join(root, '.env'));

const GRAPH = 'https://graph.facebook.com/v21.0';
const MEDIA_BASE = 'https://media.languagequiz.org';
const { INSTAGRAM_ACCESS_TOKEN: TOKEN, INSTAGRAM_USER_ID: IG } = process.env;
if (!TOKEN || !IG) {
	console.error('Missing INSTAGRAM_ACCESS_TOKEN or INSTAGRAM_USER_ID in .env.');
	process.exit(1);
}

async function graph(path, params = {}, method = 'GET') {
	const body = new URLSearchParams({ ...params, access_token: TOKEN });
	const url = method === 'GET' ? `${GRAPH}/${path}?${body}` : `${GRAPH}/${path}`;
	const res = await fetch(url, method === 'GET' ? {} : { method, body });
	const json = await res.json();
	if (json.error) throw new Error(`${path}: ${json.error.message}`);
	return json;
}

const args = process.argv.slice(2);

if (args.includes('--whoami')) {
	console.log(await graph(IG, { fields: 'username,name,followers_count,media_count' }));
	process.exit(0);
}

const yes = args.includes('--yes');
const ci = args.indexOf('--caption');
if (ci < 0) {
	console.error('Usage: node tool/instagram.mjs --caption caption.txt img1.jpg [img2.jpg …] [--yes]');
	process.exit(1);
}
const caption = readFileSync(args[ci + 1], 'utf8').trim();
const images = args.filter((a, i) => i !== ci && i !== ci + 1 && !a.startsWith('--'));
if (images.length < 1 || images.length > 20) throw new Error('Give 1 to 20 images.');
for (const f of images) if (!/\.jpe?g$/i.test(f)) throw new Error(`${f}: Instagram takes JPEG only.`);
if (caption.length > 2200) throw new Error(`Caption is ${caption.length} characters; the limit is 2,200.`);
if ((caption.match(/#/g) ?? []).length > 30) throw new Error('More than 30 hashtags.');

// 1. Upload to R2.
const s3 = new S3Client({
	region: 'auto',
	endpoint: `https://${process.env.R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
	credentials: { accessKeyId: process.env.R2_ACCESS_KEY_ID, secretAccessKey: process.env.R2_SECRET_ACCESS_KEY }
});
const day = new Date().toISOString().slice(0, 10);
const urls = [];
for (const [i, f] of images.entries()) {
	const key = `instagram/${day}/${String(i + 1).padStart(2, '0')}-${basename(f)}`;
	await s3.send(new PutObjectCommand({ Bucket: process.env.R2_BUCKET, Key: key, Body: readFileSync(f), ContentType: 'image/jpeg' }));
	const url = `${MEDIA_BASE}/${key}`;
	const head = await fetch(url, { method: 'HEAD' });
	if (!head.ok || !String(head.headers.get('content-type')).includes('jpeg')) throw new Error(`${url} is not public (${head.status}).`);
	urls.push(url);
}

// 2. Preview.
console.log(`\n${images.length === 1 ? 'Single post' : `Carousel of ${images.length}`} for @${(await graph(IG, { fields: 'username' })).username}:`);
urls.forEach((u, i) => console.log(`  ${i + 1}. ${u}`));
console.log(`\nCaption (${caption.length} chars):\n${caption}\n`);
if (!yes) {
	console.log('Preview only: nothing was posted. Add --yes to publish.');
	process.exit(0);
}

// 3. Publish: item containers → (carousel container) → wait until FINISHED → publish.
async function ready(id) {
	for (let i = 0; i < 30; i++) {
		const { status_code } = await graph(id, { fields: 'status_code' });
		if (status_code === 'FINISHED') return;
		if (status_code === 'ERROR' || status_code === 'EXPIRED') throw new Error(`Container ${id}: ${status_code}`);
		await new Promise((r) => setTimeout(r, 3000));
	}
	throw new Error(`Container ${id} not ready after 90 s.`);
}
let creation;
if (urls.length === 1) {
	creation = (await graph(`${IG}/media`, { image_url: urls[0], caption }, 'POST')).id;
} else {
	const children = [];
	for (const u of urls) children.push((await graph(`${IG}/media`, { image_url: u, is_carousel_item: 'true' }, 'POST')).id);
	for (const c of children) await ready(c);
	creation = (await graph(`${IG}/media`, { media_type: 'CAROUSEL', children: children.join(','), caption }, 'POST')).id;
}
await ready(creation);
const { id } = await graph(`${IG}/media_publish`, { creation_id: creation }, 'POST');
const { permalink } = await graph(id, { fields: 'permalink' });
console.log(`Published: ${permalink}`);
