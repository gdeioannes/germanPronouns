// Which static files are served from the R2 bucket instead of GitHub Pages.
// Shared by the app (src/lib/media.ts), the upload (tool/media-sync.mjs) and
// the build trim (tool/strip-media.mjs), so the three can never disagree.
//
// Paths are relative to static/ with forward slashes: "audio/ab12.mp3".
// The recordings and the PDFs move; the audio manifests (small JSON, refreshed
// network-first) and the pictures stay on the site.

/** @param {string} path */
export function isRemoteMedia(path) {
	return /^audio\/.+\.mp3$/.test(path) || /^(books|workbooks)\/.+\.pdf$/.test(path);
}

/**
 * The name a PDF is saved under. A cross-origin link's `download="…"` is
 * ignored by browsers, so the bucket sends this in Content-Disposition.
 * Keep in step with CHARTS_FILENAME (content/charts.ts), pdfFilename()
 * (content/literature.ts) and the workbook page's download name.
 * @param {string} path
 */
export function downloadName(path) {
	const base = path.split('/').pop() ?? path;
	if (path === 'books/charts/german-grammar-charts.pdf') return 'German Grammar Charts - Language Quiz.pdf';
	if (path === 'books/literature/kafka_die_verwandlung.pdf') return 'Franz Kafka - Die Verwandlung.pdf';
	const wb = /^workbooks\/.+_([abc][12])_([12])\.pdf$/.exec(path);
	if (wb) return `German ${wb[1].toUpperCase()}.${wb[2]} workbook.pdf`;
	return base;
}
