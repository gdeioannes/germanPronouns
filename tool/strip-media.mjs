#!/usr/bin/env node
// Removes the files served from the R2 bucket (media-rule.mjs) from build/,
// so the GitHub Pages upload stays small. Runs in the deploy workflow after
// the build and after tool/media-sync.mjs has put the same files in the bucket.
//
// Does nothing unless PUBLIC_MEDIA_BASE is set: without a bucket the site must
// keep serving its own copies.

import { readdirSync, rmSync, statSync } from 'node:fs';
import { join, relative, sep } from 'node:path';
import { isRemoteMedia } from './media-rule.mjs';

const root = join(import.meta.dirname, '..');
const build = join(root, 'build');

if (!process.env.PUBLIC_MEDIA_BASE?.trim()) {
	console.log('PUBLIC_MEDIA_BASE is not set: build/ keeps its media.');
	process.exit(0);
}

let files = 0;
let bytes = 0;
function walk(dir) {
	for (const entry of readdirSync(dir, { withFileTypes: true })) {
		const path = join(dir, entry.name);
		if (entry.isDirectory()) walk(path);
		else if (isRemoteMedia(relative(build, path).split(sep).join('/'))) {
			bytes += statSync(path).size;
			rmSync(path);
			files++;
		}
	}
}
walk(build);
console.log(`Removed ${files} media files (${(bytes / 1e6).toFixed(0)} MB) from build/: served from ${process.env.PUBLIC_MEDIA_BASE}.`);
