import { error } from '@sveltejs/kit';
import { findChat, MATCH_CHATS } from '$lib/domain/matchChat';
import type { EntryGenerator, PageLoad } from './$types';

export const entries: EntryGenerator = () => MATCH_CHATS.map((c) => ({ id: c.id }));

export const load: PageLoad = ({ params }) => {
	if (!findChat(params.id)) error(404, 'No such match');
	return { id: params.id };
};
