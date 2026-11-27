#!/usr/bin/env node
// Uploads the heavy static files (recordings and PDFs, see media-rule.mjs) to
// the Cloudflare R2 bucket the site serves them from (src/lib/media.ts).
//
//   npm run media:sync              upload what is new or changed
//   npm run media:sync -- --dry     list it, upload nothing
//
// Only git-tracked files go up (never static/img/hd, print PDFs or other local
// leftovers). A file whose MD5 matches the bucket's ETag is skipped, so a run
// after a small change uploads a handful of files. Files deleted locally stay
// in the bucket: an old link keeps working, and storage is cheap.
//
// The deploy workflow runs this before tool/strip-media.mjs, so a pushed file
// is always in the bucket before the site stops carrying it.
//
// Needs, in .env or the environment (Cloudflare dashboard → R2 → Manage API
// tokens → "Object Read & Write" on the bucket):
//   R2_ACCOUNT_ID, R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_BUCKET

import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { ListObjectsV2Command, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { downloadName, isRemoteMedia } from './media-rule.mjs';

const root = join(import.meta.dirname, '..');
const dry = process.argv.includes('--dry');
const PARALLEL = 16;

loadDotEnv(join(root, '.env'));
const need = ['R2_ACCOUNT_ID', 'R2_ACCESS_KEY_ID', 'R2_SECRET_ACCESS_KEY', 'R2_BUCKET'];
const missing = need.filter((k) => !process.env[k]);
if (missing.length) {
	console.error(`Missing ${missing.join(', ')}: add them to .env (see .env.example).`);
	process.exit(1);
}
const bucket = process.env.R2_BUCKET;
const s3 = new S3Client({
	region: 'auto',
	endpoint: `https://${process.env.R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
	credentials: { accessKeyId: process.env.R2_ACCESS_KEY_ID, secretAccessKey: process.env.R2_SECRET_ACCESS_KEY }
});

// 1. What should be in the bucket: tracked files under static/ that the rule moves.
const tracked = execFileSync('git', ['ls-files', '-z', 'static'], { cwd: root, encoding: 'utf8', maxBuffer: 64 << 20 })
	.split('\0')
	.filter(Boolean)
	.map((f) => f.slice('static/'.length))
	.filter(isRemoteMedia)
	.filter((f) => existsSync(join(root, 'static', f)));

// 2. What is there: key → ETag (the MD5 of a single-part upload).
const remote = new Map();
let token;
do {
	const page = await s3.send(new ListObjectsV2Command({ Bucket: bucket, ContinuationToken: token }));
	for (const o of page.Contents ?? []) remote.set(o.Key, (o.ETag ?? '').replace(/"/g, ''));
	token = page.IsTruncated ? page.NextContinuationToken : undefined;
} while (token);

// 3. Upload the difference.
const todo = tracked.filter((f) => remote.get(f) !== md5(join(root, 'static', f)));
const mb = (n) => (n / 1e6).toFixed(1);
const bytes = todo.reduce((n, f) => n + readFileSync(join(root, 'static', f)).length, 0);
console.log(`${tracked.length} media files, ${remote.size} in the bucket, ${todo.length} to upload (${mb(bytes)} MB).`);
if (dry) {
	for (const f of todo.slice(0, 50)) console.log(`  ${f}`);
	if (todo.length > 50) console.log(`  … and ${todo.length - 50} more`);
	process.exit(0);
}

let done = 0;
let failed = 0;
const queue = [...todo];
await Promise.all(
	Array.from({ length: PARALLEL }, async () => {
		for (let f = queue.shift(); f; f = queue.shift()) {
			try {
				await upload(f);
			} catch (e) {
				failed++;
				console.error(`  failed ${f}: ${e.message}`);
			}
			if (++done % 500 === 0 || done === todo.length) console.log(`  ${done}/${todo.length}`);
		}
	})
);
if (failed) {
	console.error(`${failed} uploads failed; run again to retry them.`);
	process.exit(1);
}
console.log('Bucket up to date.');

async function upload(f) {
	const pdf = f.endsWith('.pdf');
	const name = downloadName(f);
	await s3.send(
		new PutObjectCommand({
			Bucket: bucket,
			Key: f,
			Body: readFileSync(join(root, 'static', f)),
			ContentType: pdf ? 'application/pdf' : 'audio/mpeg',
			// A day: a re-recorded story clip or a reprinted book shows up by tomorrow.
			CacheControl: 'public, max-age=86400',
			// A cross-origin `download` attribute is ignored, so the bucket says
			// "save this, under this name" and the reader stays on the page.
			ContentDisposition: pdf
				? `attachment; filename="${name.replace(/[^\x20-\x7e]|"/g, '_')}"; filename*=UTF-8''${encodeURIComponent(name)}`
				: undefined
		})
	);
}

function md5(path) {
	return createHash('md5').update(readFileSync(path)).digest('hex');
}

/** Minimal .env reader, as in the other tools. */
function loadDotEnv(path) {
	if (!existsSync(path)) return;
	for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
		const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/i);
		if (m && !(m[1] in process.env)) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
	}
}
