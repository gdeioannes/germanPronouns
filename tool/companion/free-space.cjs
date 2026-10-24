// How much room each practice page (and each review's left page) has left, so extra exercises
// can be sized to fit:  node tool/companion/free-space.cjs B2.2 [--url http://localhost:5173]
// Prints one line per spread: id, page, free mm (negative = overflow). 1 mm ≈ 3.78 px.
const fs = require('node:fs');
const puppeteer = require('puppeteer-core');

const args = process.argv.slice(2);
const level = args.find((a) => /^[ABC][12]\.[12]$/.test(a));
const url = args.includes('--url') ? args[args.indexOf('--url') + 1] : 'http://localhost:5173';
const stem = level.toLowerCase().replace('.', '_');
const book = JSON.parse(fs.readFileSync(`${__dirname}/../../assets/content/companion/de_cert_a1/${stem}.json`, 'utf8'));
const chrome = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe']
	.find((p) => fs.existsSync(p));

(async () => {
	const browser = await puppeteer.launch({ executablePath: chrome, headless: true });
	const page = await browser.newPage();
	await page.setViewport({ width: 1200, height: 1600 });
	await page.emulateMediaType('print');
	await page.goto(`${url}/course/de_cert_a1/workbook/${level}?preview`, { waitUntil: 'networkidle0', timeout: 120000 });
	await new Promise((r) => setTimeout(r, 1500));
	const pages = await page.evaluate(() =>
		[...document.querySelectorAll('section.page.practise')].map((p) => {
			const r = p.getBoundingClientRect();
			const flow = p.querySelector('.flow');
			const last = flow?.lastElementChild;
			const bottom = last ? last.getBoundingClientRect().bottom : flow.getBoundingClientRect().top;
			const can = p.querySelector('.can-do');
			const pageEnd = r.bottom - parseFloat(getComputedStyle(p).paddingBottom);
			const limit = can ? can.getBoundingClientRect().top : pageEnd;
			// The I-can box sits at the bottom; when it is pushed past the page end, report the overflow.
			const over = can ? can.getBoundingClientRect().bottom - pageEnd : bottom - pageEnd;
			const free = over > 1 ? -over : limit - bottom;
			return { left: p.classList.contains('left'), free: Math.round((free / 3.78) * 10) / 10 };
		})
	);
	let i = 0;
	for (const s of book.spreads) {
		if (s.review) {
			const l = pages[i++], r = pages[i++];
			console.log(`${s.id.padEnd(22)} review-left  ${l.free} mm`);
			console.log(`${s.id.padEnd(22)} review-right ${r.free} mm`);
		} else {
			console.log(`${s.id.padEnd(22)} practise     ${pages[i++].free} mm`);
		}
	}
	await browser.close();
})();
