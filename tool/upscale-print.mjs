#!/usr/bin/env node
// Print sharpness: every picture that prints under 300 dpi in the KDP edition
// (docs/rights/print-dpi-kdp.json, from tool/print-dpi.mjs --print) is
// enlarged with Real-ESRGAN (BSD licence, runs locally on the GPU) to the size
// 300 dpi needs, at most 4×.
//
//   node tool/upscale-print.mjs --esrgan <path to realesrgan-ncnn-vulkan.exe> [--below 200] [--only id,id]
// --below: only pictures under that many dpi (default 300).
//
// Photos: the print original static/img/photo/<id>.jpg is replaced; the file
// first goes to static/img/photo/orig/ (gitignored), and a photo already there
// is skipped, so the run resumes. AI word pictures (static/img/<id>.webp) are
// re-saved at the larger size (committed). The web copies of photos stay as they are.
// The upscaler can turn faces into masks: check the result before printing.
import { copyFileSync, existsSync, mkdirSync, readFileSync, rmSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import sharp from 'sharp';

sharp.cache(false);
const args = process.argv.slice(2);
const flag = (n) => (args.includes(n) ? args[args.indexOf(n) + 1] : null);
const esrgan = flag('--esrgan');
if (!esrgan || !existsSync(esrgan)) throw new Error('--esrgan <realesrgan-ncnn-vulkan.exe> is required');
const only = flag('--only')?.split(',');

// The lowest dpi each picture gets anywhere in the books.
const worst = new Map();
for (const r of JSON.parse(readFileSync('docs/rights/print-dpi-kdp.json', 'utf8'))) {
	if (r.dpi >= (Number(flag("--below")) || 300)) continue;
	const prev = worst.get(r.src);
	if (!prev || r.dpi < prev) worst.set(r.src, r.dpi);
}

mkdirSync('static/img/photo/orig', { recursive: true });
const tmp = join(tmpdir(), 'upscale-print');
mkdirSync(tmp, { recursive: true });
let done = 0;
for (const [src, dpi] of worst) {
	const id = src.replace(/^.*\//, '').replace(/\.(jpg|webp)$/, '');
	if (only && !only.includes(id)) continue;
	const photo = src.startsWith('/img/photo/');
	const file = `static${src}`;
	const backup = `static/img/photo/orig/${id}${photo ? '.jpg' : '.webp'}`;
	if (existsSync(backup)) continue;
	copyFileSync(file, backup);
	const meta = await sharp(file).metadata();
	const factor = Math.min(4, (300 / dpi) * 1.04);
	const width = Math.round(meta.width * factor);
	// Under 150 dpi a picture is blocky and Real-ESRGAN redraws the detail; from 150
	// on it is only soft, and a Lanczos enlargement with a light sharpen is enough
	// (and minutes faster on a 4000 px original).
	const ai = dpi < 150;
	const input = join(tmp, `${id}.png`);
	const output = join(tmp, `${id}-x4.png`);
	let big;
	if (ai) {
		await sharp(file).png().toFile(input);
		execFileSync(esrgan, ['-i', input, '-o', output, '-n', 'realesrgan-x4plus', '-s', '4'], { stdio: 'ignore' });
		big = sharp(output).resize({ width });
	} else big = sharp(readFileSync(file)).resize({ width, kernel: 'lanczos3' }).sharpen({ sigma: 0.8 });
	if (photo) await big.jpeg({ quality: 90, mozjpeg: true }).toFile(file + '.new');
	else await big.webp({ quality: 82 }).toFile(file + '.new');
	copyFileSync(file + '.new', file);
	rmSync(file + '.new');
	if (ai) {
		rmSync(input);
		rmSync(output);
	}
	done++;
	console.log(`${id}: ${dpi} dpi → ×${factor.toFixed(2)}, ${meta.width} → ${width} px${ai ? ' (Real-ESRGAN)' : ' (Lanczos)'}`);
}
console.log(`${done} pictures upscaled`);
