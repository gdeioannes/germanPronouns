// Render check for single charts: measures overflow and saves a screenshot of each sheet.
//   node tool/charts/shot.mjs <outDir> tool/charts/src/NN-name.html [more files]
// Prints 'page scrollHeight/clientHeight' (must be equal) and every element whose content
// overflows its box; writes <outDir>/shot-NN-name.png. Look at the PNG: numbers alone are not a review.
import puppeteer from 'puppeteer-core';
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { pathToFileURL } from 'node:url';
const dir = process.argv[2], files = process.argv.slice(3);
const chrome = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const b = await puppeteer.launch({ executablePath: chrome, headless: 'new' });
const p = await b.newPage();
await p.setViewport({ width: 1200, height: 1000, deviceScaleFactor: 2 });
for (const f of files) {
	const name = f.split('/').pop().replace('.html', '');
	writeFileSync(dir + '/pv-' + name + '.html', '<!doctype html><html><head><meta charset="utf-8"></head><body>' + readFileSync(f, 'utf8') + '</body></html>');
	await p.goto(pathToFileURL(dir + '/pv-' + name + '.html').href, { waitUntil: 'networkidle0' });
	const m = await p.evaluate(() => {
		const page = document.querySelector('.page'), out = [];
		out.push('page ' + page.scrollHeight + '/' + page.clientHeight);
		document.querySelectorAll('.page *').forEach((el) => {
			if (getComputedStyle(el).display === 'inline' || el.closest('svg') || el.closest('.hd')) return;
			if (el.scrollWidth > el.clientWidth + 2 || el.scrollHeight > el.clientHeight + 3) out.push((el.className || el.tagName) + ': ' + el.textContent.trim().slice(0, 30) + ' [' + el.scrollWidth + '/' + el.clientWidth + ' ' + el.scrollHeight + '/' + el.clientHeight + ']');
		});
		const hd = document.querySelector('.hd'); if (hd.scrollWidth > hd.clientWidth + 1) out.push('HEADER WIDE ' + hd.scrollWidth + '/' + hd.clientWidth);
		return out;
	});
	console.log(name + '\n  ' + m.join('\n  '));
	await (await p.$('.sheet')).screenshot({ path: dir + '/shot-' + name + '.png' });
}
await b.close();
