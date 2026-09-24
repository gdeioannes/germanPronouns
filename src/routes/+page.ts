// The landing page sells one thing: the English → German course. It reads the
// real bundle and syllabus at build time so every number and level description
// on the page is the content's own — baked into the prerendered HTML, with no
// runtime fetch and nothing hand-maintained that could drift.

import { catalog, courseCard, loadCourse, loadSyllabus } from "$lib/content";
import type { PageLoad } from "./$types";

/** How a learner would describe each CEFR band to themselves. */
const BAND_NAMES: Record<string, string> = {
  A1: "Beginner",
  A2: "Elementary",
  B1: "Intermediate",
  B2: "Upper intermediate",
  C1: "Advanced",
  C2: "Mastery",
};

export const load: PageLoad = async () => {
  const id = catalog.defaultCourseId;
  const card = courseCard(id)!;
  const course = await loadCourse(id);
  const syllabus = await loadSyllabus(id);

  const counts: Record<string, number> = {};
  for (const quiz of course.quizzes)
    counts[quiz.type] = (counts[quiz.type] ?? 0) + 1;

  // Sub-levels as authored in the nav (A1.1, A1.2, …), grouped under the CEFR
  // letters a learner actually recognises.
  const subLevels = course.nav.groups
    .filter((g) => g.type === "questChain" && g.level)
    .map((g) => g.level as string);
  const letters = [...new Set(subLevels.map((l) => l.split(".")[0]))];

  const bands = letters.map((letter) => {
    const subs = subLevels.filter((l) => l.startsWith(letter + "."));
    const modules = subs.map((level) => {
      const module = syllabus?.modules.find((m) => m.level === level);
      return {
        level,
        title: module?.title ?? level,
        subtitle: module?.subtitle ?? "",
      };
    });
    const first = syllabus?.modules.find((m) => m.level === subs[0]);
    const quizzes = course.quizzes.filter((q) =>
      (q.level ?? "").startsWith(letter + "."),
    );
    return {
      letter,
      name: BAND_NAMES[letter] ?? letter,
      modules,
      canDo: (first?.canDo ?? []).slice(0, 2),
      count: quizzes.length,
      firstQuizId: quizzes[0]?.id ?? null,
    };
  });

  return {
    card,
    firstQuizId: course.quizzes[0]?.id,
    total: course.quizzes.length,
    counts,
    levels: letters,
    subLevelCount: subLevels.length,
    bands,
  };
};
