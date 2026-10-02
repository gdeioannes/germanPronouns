// The whole story-bible section is dev-only authoring reference: never
// prerendered, client-rendered, and each page pulls its content in behind
// import.meta.env.DEV so production bundles carry none of it.
export const prerender = false;
export const ssr = false;
