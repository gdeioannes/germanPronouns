// One topic. Its id is a Firestore document id, unknown at build time, so this
// route is the one page on the site that is not prerendered: adapter-static's
// fallback (404.html) carries the app shell, and the page fetches the topic in
// the browser.
export const prerender = false;
export const ssr = false;
