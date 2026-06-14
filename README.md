# Germanquiz

A Flutter app for drilling German grammar: pronoun case endings, definite/
indefinite articles (der/die/das), and noun genders — built around quick,
repeatable fill-in-the-blank quizzes with streaks, scoring, and per-noun
detail panels.

## Features

- **Pronoun Quiz** — personal, reflexive, and possessive pronouns across
  accusative, dative, and genitive case, with a built-in reference ("Help
  Memory") of pronoun and article ending tables.
- **Artikel Quiz** — practice choosing `der`/`die`/`das` for German nouns.
- **Nouns & Articles** — a guided progression through ~30 themed noun
  categories (kitchen, animals, professions, weather, etc.), unlocked one at
  a time by reaching a 10-answer streak, finishing with an "All Nouns" final
  challenge.
- **Sentence context** — quiz questions are presented in example sentences,
  many with custom hand-written sentences per noun. Tap any recognized noun
  in a sentence to see its article, gender-colored display, English
  translation, and (where applicable) its plural ending in dictionary
  notation (e.g. `-e`, `¨-er`, `-n`).
- **Sentence Info panel** — a per-question grammar explanation (case,
  meaning, and reasoning behind the correct answer).
- **Word Library** — browse all nouns by category, with English meanings and
  gender coloring.
- **Progress tracking** — score, streak, answer history, and a per-category
  performance heatmap, persisted locally via `shared_preferences`.
- **Settings** — toggle English meanings, noun highlighting, gender colors,
  answer-typing mode, and active categories/cases per quiz.
- **PDF export** — export the Help Memory reference tables as a PDF.

## Project structure

```
lib/
  data/        # Static content: nouns, pronouns, articles, sentences,
                # plurals, and noun-category progression logic
  models/      # QuizConfig (per-quiz setup) and NounSettings (persisted
                # user preferences/progress)
  pages/       # Top-level pages (quizzes, word library, settings)
  widgets/     # Shared UI: QuizPage (core quiz UI), AppDrawer, fireworks
  theme/       # App-wide visual theme (color palette, fonts)
```

## Getting started

This is a standard Flutter project.

```bash
flutter pub get
flutter run
```

To check for issues without running the app:

```bash
flutter analyze
```

## Tech stack

- Flutter / Dart, Material 3
- `shared_preferences` for local persistence
- `google_fonts` (Source Serif 4 + Inter) for the app's editorial look
- `flutter_colorpicker` for gender color customization
- `pdf` / `printing` for exporting reference tables
