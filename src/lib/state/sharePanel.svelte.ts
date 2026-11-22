// The share panel's switch. Every share button on the site opens the one
// panel mounted in the root layout (SharePanel.svelte): the message as it
// will arrive, and the ways to send it.

import { shareLink, type ShareWhere, type SharedScore } from '$lib/services/share';

export const sharePanel = $state({
	open: false,
	where: 'nav' as ShareWhere,
	/** The tagged link that is sent. */
	url: '',
	/** The words sent with it; the learner can change them in the panel. */
	text: '',
	/** The page's title, shown on the link's card. */
	title: '',
	props: {} as Record<string, string | number>
});

export function openShare(opts: {
	where: ShareWhere;
	/** The page to share, when it is not this one. */
	path?: string;
	/** A line to send with the link. Without one, the page's own title. */
	text?: string;
	/** A score to carry in the link ("a friend got 9 of 10"). */
	score?: SharedScore | null;
	props?: Record<string, string | number>;
}): void {
	sharePanel.where = opts.where;
	sharePanel.url = shareLink(opts.where, opts.path, opts.score);
	sharePanel.title = document.title;
	sharePanel.text = opts.text ?? document.title;
	sharePanel.props = opts.props ?? {};
	sharePanel.open = true;
}
