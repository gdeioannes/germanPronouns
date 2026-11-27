// The weekly newsletter: builds one issue from the changelog and creates it in
// Brevo as a DRAFT campaign. It never sends to the list: the owner reads the
// draft in Brevo and presses send there.
//
//   node tool/newsletter.mjs                 this week's entries → a draft in Brevo
//   node tool/newsletter.mjs --since 2026-11-20   entries from that day on
//   node tool/newsletter.mjs --dry           no Brevo call: writes newsletter-preview.html
//   node tool/newsletter.mjs --test me@example.com   also mails the draft to that address
//                                            (it must be a contact in Brevo)
//   node tool/newsletter.mjs --send --expect 12   really sends to the list, but only if
//                                            the list has exactly that many subscribers
//
// The issue is src/lib/content/changelog.ts, which is already written for
// learners. The first FULL entries of the period (the highlighted ones, then
// the newest) are printed whole; the rest are listed by title with a link to
// What's new, so a busy week still makes a short email. Nothing new in the
// period means no issue.
//
// Needs BREVO_API_KEY (in .env, or a GitHub secret). The list and the sender
// are not secret and live here.

import { readFileSync, writeFileSync } from 'node:fs';

const LIST_ID = 5; // "Languagequiz Weekly Updates" in Brevo
const SENDER = { name: 'Language Quiz', email: 'newsletter@languagequiz.org' };
const SITE = 'https://languagequiz.org';
const API = 'https://api.brevo.com/v3';
/** How many entries an issue prints in full. */
const FULL = 5;

const args = process.argv.slice(2);
const flag = (name) => args.includes(name);
const value = (name) => (args.includes(name) ? args[args.indexOf(name) + 1] : undefined);

const DAY = 86_400_000;
const iso = (d) => d.toISOString().slice(0, 10);
const since = value('--since') ?? iso(new Date(Date.now() - 7 * DAY));

// -- the changelog -----------------------------------------------------------
// A TypeScript file holding one plain array: take the literal and read it.
function readChangelog() {
	const src = readFileSync('src/lib/content/changelog.ts', 'utf8');
	const start = src.indexOf('[', src.indexOf('export const changelog'));
	const end = src.lastIndexOf('];');
	if (start < 0 || end < 0) throw new Error('changelog.ts: the array was not found');
	return new Function(`return ${src.slice(start, end + 1)}`)();
}

const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
const pretty = (date) =>
	new Date(`${date}T12:00:00Z`).toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' });

// -- the email ---------------------------------------------------------------
// Tables and inline styles only: that is what mail programs draw reliably.
// The colours are the site's (navy, terracotta, ink).
function render(entries, more) {
	const rest = more.length
		? `
      <div style="padding:28px 28px 0;">
        <h2 style="margin:0 0 10px;font-size:17px;line-height:1.3;color:#1f3a5f;">Also this week</h2>
        <ul style="margin:0;padding:0 0 0 20px;font-size:15px;line-height:1.55;color:#2a2a28;">
          ${more.map((e) => `<li style="margin:0 0 4px;">${esc(e.title)}</li>`).join('')}
        </ul>
        <p style="margin:12px 0 0;font-size:15px;"><a href="${SITE}/changelog" style="color:#a24c26;font-weight:bold;">Read these on What's new</a></p>
      </div>`
		: '';
	const sections = entries
		.map((e) => {
			const link = e.link
				? `<p style="margin:12px 0 0;font-size:15px;"><a href="${SITE}${esc(e.link.href)}" style="color:#a24c26;font-weight:bold;">${esc(e.link.label)}</a></p>`
				: '';
			return `
      <div style="padding:24px 28px 0;">
        <p style="margin:0 0 4px;font-size:12px;letter-spacing:0.06em;text-transform:uppercase;color:#6e6458;">${pretty(e.date)}</p>
        <h2 style="margin:0 0 10px;font-size:20px;line-height:1.3;color:#1f3a5f;">${esc(e.title)}</h2>
        <ul style="margin:0;padding:0 0 0 20px;font-size:15px;line-height:1.55;color:#2a2a28;">
          ${e.items.map((i) => `<li style="margin:0 0 8px;">${esc(i)}</li>`).join('\n          ')}
        </ul>${link}
      </div>`;
		})
		.join('\n');

	return `<!doctype html>
<html lang="en">
<body style="margin:0;padding:0;">
<div style="margin:0;padding:32px 16px;background:#fafafa;font-family:Helvetica,Arial,sans-serif;color:#2a2a28;">
  <div style="max-width:560px;margin:0 auto;background:#ffffff;border:1px solid #e5e5e5;border-radius:8px;overflow:hidden;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="border-bottom:1px solid #e5e5e5;">
      <tr>
        <td style="padding:20px 28px;">
          <a href="${SITE}" style="text-decoration:none;color:#1f3a5f;">
            <img src="${SITE}/icons/Icon-192.png" width="40" height="40" alt="" style="vertical-align:middle;border:0;border-radius:9px;">
            <span style="vertical-align:middle;margin-left:10px;font-size:19px;font-weight:bold;color:#1f3a5f;">Language Quiz</span>
          </a>
        </td>
      </tr>
    </table>
    <div style="padding:28px 28px 0;">
      <h1 style="margin:0 0 8px;font-size:24px;line-height:1.25;color:#1f3a5f;">What's new this week</h1>
      <p style="margin:0;font-size:15px;line-height:1.55;color:#6e6458;">
        Everything that changed in the course and the books since ${pretty(since)}.
      </p>
    </div>
${sections}${rest}
    <div style="padding:28px;">
      <a href="${SITE}" style="display:inline-block;padding:13px 22px;background:#1f3a5f;color:#ffffff;font-size:16px;font-weight:bold;text-decoration:none;border-radius:6px;">Open the course</a>
      <a href="${SITE}/changelog" style="display:inline-block;margin-left:14px;font-size:15px;color:#a24c26;">All changes</a>
    </div>
    <div style="height:5px;background:#c9683b;font-size:0;line-height:0;">&nbsp;</div>
  </div>
  <p style="max-width:560px;margin:16px auto 0;font-size:12px;line-height:1.6;color:#6e6458;text-align:center;">
    You get this because you signed up at languagequiz.org.
    <a href="{{ unsubscribe }}" style="color:#6e6458;">Unsubscribe</a> ·
    <a href="{{ mirror }}" style="color:#6e6458;">Read in the browser</a> ·
    <a href="${SITE}/legal" style="color:#6e6458;">Imprint and privacy</a>
  </p>
</div>
</body>
</html>`;
}

// -- Brevo -------------------------------------------------------------------
async function brevo(path, body) {
	const res = await fetch(`${API}${path}`, {
		method: body === undefined ? 'GET' : 'POST',
		headers: { 'api-key': process.env.BREVO_API_KEY, 'content-type': 'application/json', accept: 'application/json' },
		body: body === undefined ? undefined : JSON.stringify(body)
	});
	const text = await res.text();
	if (!res.ok) throw new Error(`Brevo ${path}: ${res.status} ${text}`);
	return text ? JSON.parse(text) : {};
}

// -- run ---------------------------------------------------------------------
const all = readChangelog().filter((e) => e.date >= since);
// Highlights first, the file's own order (newest first) otherwise.
const ranked = [...all.filter((e) => e.highlight), ...all.filter((e) => !e.highlight)];
const entries = ranked.slice(0, FULL);
const more = ranked.slice(FULL);
if (!entries.length) {
	console.log(`Nothing in the changelog since ${since}: no issue this week.`);
	process.exit(0);
}

const html = render(entries, more);
const subject = `New in Language Quiz: ${entries[0].title}`;
console.log(`${all.length} changelog ${all.length === 1 ? 'entry' : 'entries'} since ${since}: ${entries.length} in full, ${more.length} by title`);
console.log(`Subject: ${subject}`);

if (flag('--dry')) {
	writeFileSync('newsletter-preview.html', html.replace('{{ unsubscribe }}', '#').replace('{{ mirror }}', '#'));
	console.log('Written: newsletter-preview.html (nothing sent to Brevo)');
	process.exit(0);
}

try {
	process.loadEnvFile('.env');
} catch {
	// No .env (CI): the key comes from the environment.
}
if (!process.env.BREVO_API_KEY) {
	console.error('BREVO_API_KEY is missing (.env or the environment).');
	process.exit(1);
}

// A real send names how many people it expects to reach, and stops before
// anything is created if the list says otherwise.
if (flag('--send')) {
	const list = await brevo(`/contacts/lists/${LIST_ID}`);
	const n = list.uniqueSubscribers ?? list.totalSubscribers;
	console.log(`List #${LIST_ID} "${list.name}": ${n} subscriber(s).`);
	if (String(n) !== value('--expect')) {
		console.error(`Not sent: --expect ${value('--expect') ?? '(missing)'} does not match ${n}.`);
		process.exit(1);
	}
}

const campaign = await brevo('/emailCampaigns', {
	name: `Weekly update ${iso(new Date())}`,
	subject,
	previewText: entries[0].items[0].slice(0, 120),
	sender: SENDER,
	replyTo: SENDER.email,
	htmlContent: html,
	recipients: { listIds: [LIST_ID] }
});
console.log(`Created in Brevo as a draft: campaign #${campaign.id}. Marketing → Campaigns.`);

const testTo = value('--test');
if (testTo) {
	await brevo(`/emailCampaigns/${campaign.id}/sendTest`, { emailTo: [testTo] });
	console.log(`Test sent to ${testTo}.`);
}

if (flag('--send')) {
	await brevo(`/emailCampaigns/${campaign.id}/sendNow`, {});
	console.log(`Sent to list #${LIST_ID}.`);
}
