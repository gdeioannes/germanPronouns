// The landing page sells one thing: the English → German course. It reads the
// real bundle at build time so the numbers on the page (levels, exercise
// counts) can never drift from the content — they are baked into the
// prerendered HTML, with no runtime fetch.

import { catalog, courseCard, loadCourse } from "$lib/content";
import type { PageLoad } from "./$types";

export const load: PageLoad = async () => {
  const id = catalog.defaultCourseId;
  const card = courseCard(id)!;
  const course = await loadCourse(id);

  const counts: Record<string, number> = {};
  for (const quiz of course.quizzes)
    counts[quiz.type] = (counts[quiz.type] ?? 0) + 1;

  // Sub-levels as authored in the nav (A1.1, A1.2, …) collapsed to the CEFR
  // letters a learner actually recognises.
  const subLevels = course.nav.groups
    .filter((g) => g.type === "questChain" && g.level)
    .map((g) => g.level as string);
  const levels = [...new Set(subLevels.map((l) => l.split(".")[0]))];

  return {
    card,
    firstQuizId: course.quizzes[0]?.id,
    total: course.quizzes.length,
    counts,
    levels,
    subLevelCount: subLevels.length,
  };
};
