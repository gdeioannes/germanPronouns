#!/usr/bin/env node
// The second-language editions' front covers as pictures for the site (home,
// books): the book page's cover, rendered in that language, saved next to the
// English one as static/img/book-<cover>-front-<lang>.webp (640 px wide).
//   node tool/turkish/covers.mjs A1.1 [A1.2 …] [--lang ar] [--url http://localhost:5173]
import { existsSync } from 'node:fs';
import puppeteer from 'puppeteer-core';
import sharp from 'sharp';

const args = process.argv.slice(2);
const base = args.includes('--url') ? args[args.indexOf('--url') + 1] : 'http://localhost:5173';
const levels = args.filter((a) => /^[AB][12]\.[12]$/.test(a));
const LANG = args.includes('--lang') ? args[args.indexOf('--lang') + 1] : 'tr';
const chrome = [process.env.CHROME_PATH, 'C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe', '/usr/bin/google-chrome'].find((p) => p && existsSync(p));
if (!chrome) throw new Error('No Chrome or Edge found — set CHROME_PATH.');

const browser = await puppeteer.launch({ executablePath: chrome, headless: true });
const page = await browser.newPage();
await page.setViewport({ width: 1400, height: 1000, deviceScaleFactor: 2 });
for (const level of levels) {
	await page.goto(`${base}/course/de_cert_a1/book2/${level}?lang=${LANG}`, { waitUntil: 'load', timeout: 120_000 });
	await page.waitForSelector('main[data-ready="true"]', { timeout: 60_000 });
	await page.waitForFunction(() => document.documentElement.dataset.langReady === '1', { timeout: 60_000 });
	await page.evaluate(() => document.fonts.ready);
	// Laid out as printed (A4), and without the site's bars over the page.
	await page.emulateMediaType('print');
	await page.evaluate(() => document.querySelectorAll('.dl-bar, .chrome, .skip-link').forEach((e) => e.remove()));
	await page.evaluate(() => window.scrollTo(0, 0));
	await new Promise((r) => setTimeout(r, 1500));
	const cover = await page.$('section.page.cover');
	const png = await cover.screenshot({ type: 'png' });
	const out = `static/img/book-${level.toLowerCase().replace('.', '-')}-front-${LANG}.webp`;
	await sharp(png).resize({ width: 640 }).webp({ quality: 82 }).toFile(out);
	console.log(out);
}
await browser.close();
