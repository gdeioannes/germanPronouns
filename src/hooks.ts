// Runs on the server and in the browser. A Turkish or Arabic address
// (/tr/…, /ar/…) is the same page as the bare one: the prefix only says
// which language it is written in (see $lib/i18n/paths.ts).

import type { Reroute } from '@sveltejs/kit';
import { stripLang } from '$lib/i18n/paths';

export const reroute: Reroute = ({ url }) => stripLang(url.pathname);
