// A reference table that is wider than its box would scroll sideways, which
// on a phone hides half the columns. This action measures the table and, only
// when it really does not fit, marks the box `stacked`: app.css then turns each
// row into a small card, every value labelled with its column heading. Tables
// that fit (most, once their cells may wrap) stay tables.
//
// The labels come from the table's own <thead>, so authored content needs
// nothing extra, and the prerendered HTML stays a plain table.

function label(table: HTMLTableElement): void {
	const heads = [...table.querySelectorAll('thead th')].map((th) => th.textContent?.trim() ?? '');
	for (const tr of table.querySelectorAll('tbody tr')) {
		[...tr.children].forEach((cell, i) => {
			if (heads[i]) cell.setAttribute('data-label', heads[i]);
			else cell.removeAttribute('data-label');
		});
	}
}

/** `use:fitTable={key}`: pass anything that changes when the table's content does. */
export function fitTable(box: HTMLElement, _key?: unknown) {
	let width = -1;

	function check(): void {
		const table = box.querySelector('table');
		box.classList.remove('stacked');
		if (!table || !box.clientWidth) return;
		if (table.scrollWidth > box.clientWidth + 1) box.classList.add('stacked');
	}
	function refresh(): void {
		const table = box.querySelector('table');
		if (table) label(table);
		check();
	}

	// Only a change of width can change the answer; the height changes with it.
	const observer = new ResizeObserver(() => {
		if (box.clientWidth === width) return;
		width = box.clientWidth;
		check();
	});
	observer.observe(box);
	// A folded <details> has nothing to measure until it opens.
	box.addEventListener('toggle', check);
	refresh();

	return {
		update() {
			refresh();
		},
		destroy() {
			observer.disconnect();
			box.removeEventListener('toggle', check);
		}
	};
}
