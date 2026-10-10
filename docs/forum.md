# Forum and "Report a problem"

A small forum on Firestore, read by anyone, written by signed-in learners, and a
flag button on every exercise that files a problem report with the exercise and
the question already filled in.

## What is where

| Piece | File |
| --- | --- |
| Vocabulary: boards, report subjects, titles, unread rule | `src/lib/domain/forum.ts` (+ `forum.test.ts`) |
| Firestore calls | `src/lib/services/forum.ts` |
| Inbox store: my topics, my name, unread replies, am I a moderator | `src/lib/state/forum.svelte.ts` |
| In-quiz panel | `src/lib/components/forum/ReportPanel.svelte` |
| Forum pages | `src/routes/forum/` (`+page`, `new/`, `[id]/`) |
| Rules and indexes | `firestore.rules`, `firestore.indexes.json` |

The quiz components each take an optional `onQuestion` callback and report the
question on screen (`QuestionRef`: number, total, text). For a shuffled drill the
number is the item's place in the authored list, so it points at one line of
content.

## Firestore

```
forum_threads/{id}             a topic — report, question, idea or general
forum_threads/{id}/posts/{id}  its replies
forum_profiles/{uid}           posting name + seen: { threadId: replyCount }
forum_admins/{uid}             exists ⇒ moderator
```

A report carries `courseId, quizId, quizTitle, level, questionNumber,
questionText, reportKind`. Status is `open → answered → fixed`, set by the author
or a moderator. `notify: false` is the learner's "don't notify me".

**Notifications are pull, not push.** There is no server to send mail. On each
visit a signed-in learner's own topics are fetched once; a topic whose
`replyCount` is above the `seen` count (and has `notify` on) shows as "New reply"
on the forum page, as a bell in the compact nav, and in the quiz's report panel.
Opening the topic marks it seen.

## One-time console setup

1. **Rules and indexes.** `npx firebase-tools login`, then
   `npx firebase-tools deploy --only firestore`. This publishes
   `firestore.rules` and creates the three composite indexes
   (category/updatedAt, quizId/updatedAt, authorUid/updatedAt). Without the
   indexes the filtered lists fail with `failed-precondition`; the browser
   console error carries a link that creates the missing one.
2. **Make yourself a moderator.** Firestore → `forum_admins` → add a document
   whose id is your uid (Authentication → Users), any content, e.g.
   `{ "role": "owner" }`. Moderators see Mark as / Delete on every topic.
3. Email-link sign-in and authorised domains are already set up for the
   progress sync; nothing new there.

## Sign-in return path

`account.sendLink(email, returnTo)` adds `?next=` to the emailed link, and the
`/signin` page sends the learner there instead of to settings. The report panel
and the forum pages pass their own path, so after signing in the learner is back
where they asked.

## Not done yet

- Email to the author or to you when a reply or report lands (needs Cloud
  Functions or a scheduled job; the data model already has what it would read).
- Editing a post after it is sent (rules allow it; no UI).
- Pagination past the first 30 topics; search.
- Deleting a topic leaves its posts as orphans (clients cannot delete a
  subcollection); a cleanup job can sweep them.
