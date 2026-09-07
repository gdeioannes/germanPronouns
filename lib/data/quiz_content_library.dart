import '../models/quiz_content.dart';
import 'article_content.dart';
import 'courses/de_cs/de_cs_content.dart';
import 'courses/de_es/de_es_content.dart';
import 'courses/en_de/en_de_content.dart';
import 'courses/en_de_ai/en_de_ai_content.dart';
import 'courses/en_es/en_es_content.dart';
import 'courses/en_zh/en_zh_content.dart';
import 'courses/en_zh_hanzi/en_zh_hanzi_content.dart';
import 'courses/es_de/es_de_content.dart';
import 'courses/es_en/es_en_content.dart';
import 'courses/zh_en/zh_en_content.dart';
import 'noun_article_content.dart';
import 'preposition_content.dart';
import 'pronoun_article_content.dart';
import 'pronoun_content.dart';
import 'quest_data.dart';

/// Every quiz as serializable [QuizContent], compiled into the app. This is
/// the static, build-time content that seeds the local database on first run
/// (and the shape a teacher exports back to a JSON asset to publish edits).
final List<QuizContent> allQuizContent = [
  pronounQuizContent,
  articleQuizContent,
  nounArticleQuizContent,
  pronounArticleQuizContent,
  prepositionQuizContent,
  // German Grammar in Detail — step-by-step grammar modules (M3, …).
  ...enDeGrammarContent,
  // Quest (CEFR A-level) quizzes — one ordered, streak-unlocked chain.
  ...questQuizContent,
  // Español → Alemán travel course quizzes.
  ...esDeContent,
  // German Emotions course (emotions & couple communication, es → de).
  ...esDeEmocionesContent,
  // Spanisch-Zertifikat A1–B2 (Deutsch → Spanisch).
  ...deEsContent,
  // Tschechisch entdecken — deep intro course (Deutsch → Tschechisch).
  ...deCsContent,
  // 英语认证 A1–C2 — Mandarin speakers learning English (zh → en).
  ...esEnContent,

  ...enEsContent,

  ...zhEnContent,
  // Certification Chinese · HSK — English speakers learning Mandarin (en → zh).
  ...enZhContent,
  // Hanzi Writing — draw the 1000 most common characters (en → zh).
  ...enZhHanziContent,
  // German with Your AI Coach — all-AI prompt course (en → de, A1–C2).
  ...enDeAiContent,
];
