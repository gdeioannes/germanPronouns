// An EAN-13 barcode as SVG, for the ISBN on a book's back cover. The thirteen
// digits of an ISBN-13 are the EAN-13 digits, check digit included, so the
// printer's scanner reads the ISBN straight off the cover.

const L = ['0001101', '0011001', '0010011', '0111101', '0100011', '0110001', '0101111', '0111011', '0110111', '0001011'];
const G = L.map((p) => [...p].reverse().map((b) => (b === '1' ? '0' : '1')).join(''));
const R = L.map((p) => [...p].map((b) => (b === '1' ? '0' : '1')).join(''));
/** Which of the left six digits use the G pattern, by the first digit. */
const PARITY = ['LLLLLL', 'LLGLGG', 'LLGGLG', 'LLGGGL', 'LGLLGG', 'LGGLLG', 'LGGGLL', 'LGLGLG', 'LGLGGL', 'LGGLGL'];

/** The thirteen digits of an ISBN written with hyphens, or null when the check digit is wrong. */
export function isbnDigits(isbn: string): string | null {
	const digits = isbn.replace(/[^0-9]/g, '');
	if (digits.length !== 13) return null;
	const sum = [...digits.slice(0, 12)].reduce((s, d, i) => s + Number(d) * (i % 2 ? 3 : 1), 0);
	return (10 - (sum % 10)) % 10 === Number(digits[12]) ? digits : null;
}

/** The 95 modules of the symbol as a string of 0s and 1s. */
export function ean13Modules(digits: string): string {
	const first = Number(digits[0]);
	let bits = '101';
	for (let i = 1; i <= 6; i++) bits += (PARITY[first][i - 1] === 'G' ? G : L)[Number(digits[i])];
	bits += '01010';
	for (let i = 7; i <= 12; i++) bits += R[Number(digits[i])];
	return bits + '101';
}

/**
 * The barcode as an SVG string, `width` mm wide including quiet zones, with
 * the digits under it. Bars stay black on white whatever the cover colour.
 */
export function ean13Svg(isbn: string, width = 37.29): string | null {
	const digits = isbnDigits(isbn);
	if (!digits) return null;
	const modules = ean13Modules(digits);
	const quiet = 11; // modules of quiet zone either side
	const total = modules.length + quiet * 2;
	const unit = width / total;
	const barH = 22.85;
	const guard = (i: number) => i < 3 || (i >= 45 && i < 50) || i >= 92;
	let bars = '';
	for (let i = 0; i < modules.length; i++) {
		if (modules[i] !== '1') continue;
		const x = (quiet + i) * unit;
		bars += `<rect x="${x.toFixed(3)}" y="0" width="${unit.toFixed(3)}" height="${guard(i) ? barH + 1.65 : barH}"/>`;
	}
	const textY = barH + 3.2;
	const font = `font-family="Inter, Helvetica, Arial, sans-serif" font-size="2.6" text-anchor="middle"`;
	const groupX = (from: number, to: number) => ((quiet + from + quiet + to) / 2) * unit;
	const text =
		`<text x="${((quiet - 5) * unit).toFixed(2)}" y="${textY}" ${font}>${digits[0]}</text>` +
		`<text x="${groupX(3, 45).toFixed(2)}" y="${textY}" ${font} textLength="${(40 * unit).toFixed(2)}" lengthAdjust="spacing">${digits.slice(1, 7)}</text>` +
		`<text x="${groupX(50, 92).toFixed(2)}" y="${textY}" ${font} textLength="${(40 * unit).toFixed(2)}" lengthAdjust="spacing">${digits.slice(7)}</text>`;
	const label = `<text x="${(total * unit / 2).toFixed(2)}" y="-1.4" ${font} font-size="2.4">ISBN ${isbn}</text>`;
	const h = textY + 1.5;
	return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -4 ${width} ${h + 4}" width="${width}mm" height="${h + 4}mm"><rect x="0" y="-4" width="${width}" height="${h + 4}" fill="#fff"/><g fill="#000">${label}${bars}${text}</g></svg>`;
}
