#!/usr/bin/env node
// Prints a book v2 level (/course/<id>/book2/<level>):
//   node tool/gen-book2.mjs A1.1 --web     static/books/v2/<id>_<stem>.pdf, the free download (web photos)
//   node tool/gen-book2.mjs A1.1           …_print.pdf, the KDP interior (print originals, local only)
//   node tool/gen-book2.mjs A1.1 --cover --pages 131   …_cover.pdf, the KDP wrap cover
// Options: --url http://localhost:5173, --course de_cert_a1, --out <file>.
import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import puppeteer from 'puppeteer-core';

const root = fileURLToPath(new URL('..', import.meta.url));
const args = process.argv.slice(2);
const flag = (n, d) => (args.includes(n) ? args[args.indexOf(n) + 1] : d);
const level = args.find((a) => /^[ABC][12]\.[12]$/.test(a)) ?? 'A1.1';
const courseId = flag('--course', 'de_cert_a1');
const base = flag('--url', 'http://localhost:5173');
// --cover: the wraparound print cover (back + spine + front, 3 mm bleed). KDP white
// paper: 0.0572 mm per page, so --pages sets the spine.
const coverMode = args.includes('--cover');
// --web: the download edition, with the 1400 px photo copies (~20 MB instead of ~100).
const web = args.includes('--web');
const pages = Number(flag('--pages', 130));
const spine = Math.round(pages * 0.0572 * 10) / 10;
const chrome = [process.env.CHROME_PATH, 'C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe', '/usr/bin/google-chrome'].find((p) => p && existsSync(p));
if (!chrome) throw new Error('No Chrome or Edge found — set CHROME_PATH.');

const browser = await puppeteer.launch({ executablePath: chrome, headless: true });
const page = await browser.newPage();
const query = [coverMode ? `cover&spine=${spine}` : '', web ? '' : 'hd'].filter(Boolean).join('&');
await page.goto(`${base}/course/${courseId}/book2/${level}${query ? `?${query}` : ''}`, { waitUntil: 'load', timeout: 120_000 });
// The page reads its query in the browser; wait until it has.
await page.waitForSelector('main[data-ready="true"]', { timeout: 60_000 });
await new Promise((r) => setTimeout(r, 300));
await page.evaluate(async () => {
	await document.fonts.ready;
	await Promise.all([...document.images].map((img) => (img.complete ? null : new Promise((r) => { img.addEventListener('load', r, { once: true }); img.addEventListener('error', r, { once: true }); }))));
});
const pdf = coverMode
	? await page.pdf({ width: `${420 + spine + 6}mm`, height: '303mm', printBackground: true, timeout: 300_000 })
	: await page.pdf({ format: 'A4', printBackground: true, timeout: 300_000 });
await browser.close();
mkdirSync(`${root}static/books/v2`, { recursive: true });
const out = flag('--out', `${root}static/books/v2/${courseId}_${level.toLowerCase().replace('.', '_')}${coverMode ? '_cover' : web ? '' : '_print'}.pdf`);
writeFileSync(out, pdf);
console.log(`${out}  ${Math.round(pdf.length / 1024)} kB`);
