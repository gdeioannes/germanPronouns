import fs from 'node:fs';
const text = fs.readFileSync(process.argv[2], 'utf8').replace(/^﻿/, '');
function parse(t) {
  const rows = []; let row = [], f = '', q = false;
  for (let i = 0; i < t.length; i++) {
    const c = t[i];
    if (q) { if (c === '"') { if (t[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += c; }
    else if (c === '"') q = true;
    else if (c === ',') { row.push(f); f = ''; }
    else if (c === '\n') { row.push(f); rows.push(row); row = []; f = ''; }
    else if (c !== '\r') f += c;
  }
  if (f || row.length) { row.push(f); rows.push(row); }
  return rows;
}
const rows = parse(text); const head = rows.shift();
const ev = rows.filter(r => r.length >= head.length).map(r => {
  const o = Object.fromEntries(head.map((h, i) => [h, r[i]]));
  try { o.p = JSON.parse(o.string_props || '{}'); } catch { o.p = {}; }
  try { o.n = JSON.parse(o.numeric_props || '{}'); } catch { o.n = {}; }
  o.day = o.timestamp.slice(0, 10); return o;
}).sort((a, b) => a.timestamp < b.timestamp ? -1 : 1);

const users = new Map();
for (const e of ev) { if (!users.has(e.user_id)) users.set(e.user_id, []); users.get(e.user_id).push(e); }
const internal = new Set();
for (const [u, es] of users) {
  if (es.some(e => e.p.route === '/backoffice') ||
      es.some(e => ['30+', '8-30'].includes(e.p.days_since_first) && e.country_code === 'DE')) internal.add(u);
}
const ext = [...users].filter(([u]) => !internal.has(u));
const cnt = (arr, fn) => { const m = {}; for (const x of arr) { const k = fn(x); if (k == null) continue; m[k] = (m[k] || 0) + 1; } return Object.entries(m).sort((a, b) => b[1] - a[1]); };
const show = (t, e, n = 15) => console.log(`\n## ${t}\n` + e.slice(0, n).map(([k, v]) => `${String(v).padStart(5)}  ${k}`).join('\n'));
const pct = (a, b) => b ? `${a}/${b} (${Math.round(100 * a / b)}%)` : `${a}/0`;

console.log(`events ${ev.length}, range ${ev[0].timestamp} .. ${ev.at(-1).timestamp}`);
console.log(`user-days total ${users.size}, internal ${internal.size}, external ${ext.length}`);
show('external user-days per day', cnt(ext, ([, es]) => es[0].day).sort((a, b) => a[0] < b[0] ? -1 : 1), 40);
show('first source', cnt(ext, ([, es]) => es[0].p.source));
show('country', cnt(ext, ([, es]) => es[0].country_name || es[0].country_code), 25);
show('ui_lang (last seen)', cnt(ext, ([, es]) => es.at(-1).p.ui_lang || '(none)'));
show('OS', cnt(ext, ([, es]) => es[0].os_name));
const norm = r => r ? r.replace(/^\/(ar|tr|uk|fr|es)(?=\/|$)/, '') || '/' : r;
const grp = r => { r = norm(r); if (!r) return null;
  if (r.startsWith('/course/de_cert_a1/quiz/')) return '/quiz/*';
  if (/^\/course\/de_cert_a1\/book2\/[A-C]\d\.\d$/.test(r)) return '/book2/<level> (reader)';
  if (r.startsWith('/course/de_cert_a1/book2/')) return '/book2/<level>/<chapter> (book page)';
  if (r.startsWith('/b/')) return '/b/<code>'; if (r.startsWith('/play/quest')) return '/play/<quiz code>';
  if (r.startsWith('/forum/')) return '/forum/*'; if (r.startsWith('/words/')) return '/words/*';
  if (r.startsWith('/literature/')) return '/literature/*'; return r; };
show('landing page (first screen_view)', cnt(ext, ([, es]) => grp(es.find(e => e.event_name === 'screen_view')?.p.route)));
show('pages by distinct user-days', cnt(ext.flatMap(([, es]) => [...new Set(es.filter(e => e.event_name === 'screen_view').map(e => grp(e.p.route)))]), x => x), 25);
show('events by distinct user-days', cnt(ext.flatMap(([, es]) => [...new Set(es.map(e => e.event_name))]), x => x), 40);

const has = (es, n) => es.some(e => e.event_name === n);
const dl = ext.filter(([, es]) => has(es, 'book_download'));
const qs = ext.filter(([, es]) => has(es, 'quiz_started'));
const qc = ext.filter(([, es]) => has(es, 'quiz_completed'));
console.log('\n## segments (external user-days)');
console.log('downloaded a book   ', pct(dl.length, ext.length));
console.log('started a quiz      ', pct(qs.length, ext.length));
console.log('completed a quiz    ', pct(qc.length, ext.length));
const both = dl.filter(([, es]) => has(es, 'quiz_started')).length;
console.log('download AND quiz   ', pct(both, ext.length));
console.log('download only       ', pct(dl.length - both, ext.length));
console.log('quiz only           ', pct(qs.length - both, ext.length));
console.log('neither             ', pct(ext.length - dl.length - qs.length + both, ext.length));
console.log('of downloaders, also started quiz', pct(both, dl.length));
const sawBooks = ext.filter(([, es]) => es.some(e => norm(e.p.route) === '/books'));
console.log('saw /books -> downloaded', pct(sawBooks.filter(([, es]) => has(es, 'book_download')).length, sawBooks.length));
const sawHome = ext.filter(([, es]) => es.some(e => norm(e.p.route) === '/'));
console.log('saw home -> downloaded  ', pct(sawHome.filter(([, es]) => has(es, 'book_download')).length, sawHome.length));
console.log('saw home -> started quiz', pct(sawHome.filter(([, es]) => has(es, 'quiz_started')).length, sawHome.length));
const reader = ext.filter(([, es]) => es.some(e => grp(e.p.route) === '/book2/<level> (reader)'));
console.log('opened online reader ', pct(reader.length, ext.length), ' -> downloaded', pct(reader.filter(([, es]) => has(es, 'book_download')).length, reader.length));

const booksPer = dl.map(([, es]) => new Set(es.filter(e => e.event_name === 'book_download').map(e => e.p.book)).size);
show('distinct books per downloader', cnt(booksPer, x => x >= 12 ? '12 (all)' : x >= 6 ? '6-11' : x >= 3 ? '3-5' : String(x)));
show('downloads per book (distinct user-day x book)', cnt(dl.flatMap(([, es]) => [...new Set(es.filter(e => e.event_name === 'book_download').map(e => e.p.book))]), x => x).sort((a, b) => a[0] < b[0] ? -1 : 1), 20);
show('download from', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'book_download'), e => e.p.from));
const firstBook = cnt(dl, ([, es]) => es.find(e => e.event_name === 'book_download').p.book); show('first book downloaded', firstBook);
const dlEv = ev.filter(e => !internal.has(e.user_id) && e.event_name === 'book_download');
const seen = new Set(); let rep = 0; for (const e of dlEv) { const k = e.user_id + e.p.book; if (seen.has(k)) rep++; seen.add(k); }
console.log(`\nrepeat downloads of same book by same user-day: ${rep} of ${dlEv.length}`);

show('start_chosen how', cnt(ext.filter(([, es]) => has(es, 'start_chosen')), ([, es]) => es.find(e => e.event_name === 'start_chosen').p.how));
const ps = ext.filter(([, es]) => has(es, 'placement_start'));
console.log('\n## placement test: started', ps.length, ' finished', ps.filter(([, es]) => has(es, 'placement_done')).length, ' skipped', ps.filter(([, es]) => has(es, 'placement_skip')).length, ' neither(abandoned)', ps.filter(([, es]) => !has(es, 'placement_done') && !has(es, 'placement_skip')).length);
show('placement_done level', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'placement_done'), e => e.p.level));

const qStart = {}, qDone = {};
for (const [u, es] of ext) { for (const e of es) { if (e.event_name === 'quiz_started') (qStart[e.p.quiz] ??= new Set()).add(u); if (e.event_name === 'quiz_completed') (qDone[e.p.quiz] ??= new Set()).add(u); } }
console.log('\n## quizzes: started -> completed (distinct user-days), top by starts');
for (const [q, s] of Object.entries(qStart).sort((a, b) => b[1].size - a[1].size).slice(0, 20)) console.log(`${String(s.size).padStart(4)} -> ${String(qDone[q]?.size || 0).padStart(3)}  ${q}`);
const typ = {}; for (const [u, es] of ext) for (const e of es) { if (e.event_name === 'quiz_started') ((typ[e.p.type] ??= { s: new Set(), d: new Set() }).s).add(u + e.p.quiz); if (e.event_name === 'quiz_completed') ((typ[e.p.type] ??= { s: new Set(), d: new Set() }).d).add(u + e.p.quiz); }
console.log('\n## by quiz type: user-quiz pairs started -> completed'); for (const [t, v] of Object.entries(typ)) console.log(`${t.padEnd(12)} ${pct(v.d.size, v.s.size)}`);
show('distinct quizzes started per quiz user', cnt(qs, ([, es]) => { const n = new Set(es.filter(e => e.event_name === 'quiz_started').map(e => e.p.quiz)).size; return n >= 6 ? '6+' : n >= 3 ? '3-5' : String(n); }));
show('distinct quizzes completed per quiz user', cnt(qs, ([, es]) => { const n = new Set(es.filter(e => e.event_name === 'quiz_completed').map(e => e.p.quiz)).size; return n >= 6 ? '6+' : n >= 3 ? '3-5' : String(n); }));
show('quiz level started (user-days)', cnt(qs.flatMap(([, es]) => [...new Set(es.filter(e => e.event_name === 'quiz_started').map(e => (e.p.quiz.match(/quest_([abc]\d)_(\d)/) || []).slice(1).join('.').toUpperCase()))]), x => x));

const code = ext.filter(([, es]) => es.some(e => e.p.source === 'book' || (e.p.route || '').startsWith('/b/') || (e.p.route||'').startsWith('/play/quest')));
console.log('\n## book-code users (came via printed/PDF code):', pct(code.length, ext.length));
show('  their countries', cnt(code, ([, es]) => es[0].country_name));
show('  book_page_used action', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'book_page_used'), e => e.p.action));
show('  codes used', cnt(code.flatMap(([, es]) => [...new Set(es.map(e => e.p.campaign).filter(Boolean))]), x => x), 20);
console.log('  code users who started a quiz', pct(code.filter(([, es]) => has(es, 'quiz_started')).length, code.length));

show('audience answer', cnt(ev.filter(e => !internal.has(e.user_id) && (e.event_name === 'book_audience' || e.event_name === 'book_audience_skipped')), e => e.event_name === 'book_audience' ? 'answered: ' + e.p.who : 'skipped'));
// Sharing (2026-11-22): taps by place and way out, then the visits shared links brought.
show('share_tap by where / how', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'share_tap'), e => `${e.p.where} / ${e.p.how}`));
{ const arrived = ext.filter(([, es]) => String(es[0].p.source || '').startsWith('share-'));
  show('visits brought by a shared link (first source)', cnt(arrived, ([, es]) => es[0].p.source));
  console.log('  of those, started a quiz', pct(arrived.filter(([, es]) => has(es, 'quiz_started')).length, arrived.length),
    '| downloaded a book', pct(arrived.filter(([, es]) => has(es, 'book_download')).length, arrived.length)); }
show('feedback_asked by ui_lang/kind', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'feedback_asked'), e => `${e.p.ui_lang || '-'} / ${e.p.kind}`));
show('book_download by ui_lang (since 11-19)', cnt(dlEv.filter(e => e.day >= '2026-11-19'), e => e.p.ui_lang || '-'));
show('promo shown by card', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'download_promo_shown'), e => e.p.card));
show('promo click by card', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'download_promo_click'), e => e.p.card));
show('other features (user-days)', cnt(ext.flatMap(([, es]) => [...new Set(es.map(e => { const r = norm(e.p.route) || ''; return r.startsWith('/play/wortbloecke') ? 'wortbloecke' : r.startsWith('/play/schreib-mir') ? 'schreib-mir' : r.startsWith('/play/ja-nein') ? 'ja-nein' : r.startsWith('/story') || r === '/stories' ? 'stories' : r.startsWith('/literature') ? 'literature' : r.startsWith('/words') ? 'words' : r.startsWith('/level-check') ? 'level-check' : r.includes('/worksheet') ? 'worksheet' : r.startsWith('/forum') ? 'forum' : null; }).filter(Boolean))]), x => x));

// A return = 30+ minutes of nothing, then activity. NOT 2+ session ids: the id lives in memory, so every reload makes a new one.
const T = e => Date.parse(e.timestamp.replace(' ', 'T') + 'Z');
const ret = ext.filter(([, es]) => es.some((e, i) => i > 0 && T(e) - T(es[i - 1]) > 30 * 60 * 1000));
console.log('\n## came back same day (30+ min gap):', pct(ret.length, ext.length));
// Since 2026-11-26: one quiz_left per unfinished visit (answered, seconds, lesson step) replaces lesson_step / quiz_progress / lesson_left.
show('quiz_left: lesson step reached / of (how)', cnt(ev.filter(e => !internal.has(e.user_id) && e.event_name === 'quiz_left' && e.n.lesson_of), e => `${e.p.quiz}: ${e.n.lesson}/${e.n.lesson_of} (${e.p.lesson_how}), answered ${e.n.answered}`), 30);
show('done_n (exercises finished so far, last event of the visitor-day)', cnt(ext, ([, es]) => es.at(-1).p.done_n || '(before the update)'));
show('days_since_first (external user-days)', cnt(ext, ([, es]) => es[0].p.days_since_first));
const dur = ext.map(([, es]) => (new Date(es.at(-1).timestamp.replace(' ', 'T') + 'Z') - new Date(es[0].timestamp.replace(' ', 'T') + 'Z')) / 60000).sort((a, b) => a - b);
console.log(`active span per user-day (min): median ${dur[dur.length >> 1].toFixed(1)}, p75 ${dur[Math.floor(dur.length * .75)].toFixed(1)}, p90 ${dur[Math.floor(dur.length * .9)].toFixed(1)}`);
show('span buckets', cnt(dur, d => d < 1 ? '<1 min' : d < 5 ? '1-5 min' : d < 20 ? '5-20 min' : d < 60 ? '20-60 min' : '60+ min'));
const single = ext.filter(([, es]) => es.filter(e => e.event_name === 'screen_view').length <= 1 && es.length <= 2).length;
console.log('one-page bounces:', pct(single, ext.length));
let dup = 0, tot = 0; const k2 = new Set(); for (const e of ev) if (e.event_name === 'quiz_started') { tot++; const k = e.user_id + e.p.quiz + e.timestamp; if (k2.has(k)) dup++; k2.add(k); }
console.log(`quiz_started exact double-fires: ${dup} of ${tot}`);
// by language group behaviour
console.log('\n## behaviour by ui_lang (user-days: n, downloaded, started quiz, completed quiz)');
const byL = {}; for (const x of ext) { const l = x[1].at(-1).p.ui_lang || '(none)'; (byL[l] ??= []).push(x); }
for (const [l, xs] of Object.entries(byL)) console.log(`${l.padEnd(7)} n=${String(xs.length).padStart(3)}  dl ${pct(xs.filter(([, es]) => has(es, 'book_download')).length, xs.length)}  quiz ${pct(xs.filter(([, es]) => has(es, 'quiz_started')).length, xs.length)}  done ${pct(xs.filter(([, es]) => has(es, 'quiz_completed')).length, xs.length)}`);
console.log('\n## behaviour by OS'); const byO = {}; for (const x of ext) (byO[x[1][0].os_name] ??= []).push(x);
for (const [l, xs] of Object.entries(byO)) console.log(`${l.padEnd(8)} n=${String(xs.length).padStart(3)}  dl ${pct(xs.filter(([, es]) => has(es, 'book_download')).length, xs.length)}  quiz ${pct(xs.filter(([, es]) => has(es, 'quiz_started')).length, xs.length)}  done ${pct(xs.filter(([, es]) => has(es, 'quiz_completed')).length, xs.length)}`);
