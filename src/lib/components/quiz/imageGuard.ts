// Action: calls `onFail` when an <img> cannot load — including one that had
// already failed in the prerendered page before hydration attached a handler.

export function imageGuard(node: HTMLImageElement, onFail: () => void) {
	const fail = () => onFail();
	if (node.complete && node.naturalWidth === 0) fail();
	node.addEventListener('error', fail);
	return {
		destroy() {
			node.removeEventListener('error', fail);
		}
	};
}
