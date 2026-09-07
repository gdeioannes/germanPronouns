import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M1 · A1.1 — *Erste Schritte* (First steps).
///
/// Can-do: greet and introduce yourself; say age, origin, languages, job;
/// count 0–100; ask and answer W-questions; order a drink.
/// Grammar: sein/haben, regular present, verb-second, W-questions,
/// der/die/das + ein/eine (nominative), plurals, nominative pronouns.
///
/// A1 session shape: ~3 minutes, 6 exchanges, pass 50 (the manifest default).
const _a1Session = SpeakingSession(durationMinutes: 3, minExchanges: 6);

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

final List<QuizContent> enDeAiM1Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m1_words_hello',
    title: 'Words: greetings & family',
    level: 'A1',
    mode: SpeakingMode.vocabDrill,
    session: _a1Session,
    topic:
        'My first 20 German words: greetings, courtesy phrases and family. '
        'Always demand the article with every noun.',
    material:
        'Words to drill (word = meaning):\n'
        'Hallo = hello · Tschüss = bye · Guten Morgen = good morning · '
        'Guten Abend = good evening · bitte = please · danke = thank you · '
        'Entschuldigung = excuse me · ja = yes · nein = no\n'
        'die Mutter = mother · der Vater = father · die Eltern = parents · '
        'der Bruder = brother · die Schwester = sister · das Kind = child · '
        'die Familie = family · der Freund = friend (m) · '
        'die Freundin = friend (f) · der Name = name',
    practisePoints: [
      'Recalling the word in both directions (English → German and back)',
      'The article der/die/das together with every noun',
      'Pronouncing greetings naturally, not letter by letter',
    ],
    scoringCriteria: [
      'the right word',
      'the right article with nouns',
      'understandable pronunciation',
    ],
    priorityErrors: ['wrong or missing article', 'mixed-up family words'],
    intro:
        'Your first exercise: a straight vocabulary drill your AI runs for '
        'you. It will ask each word both ways and repeat the ones you miss.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Learn the article as part of the word',
        text:
            'Never learn "Mutter", always "die Mutter" — German words come '
            'with their gender attached, and this drill insists on it.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_first_contact',
    title: 'First contact at the language café',
    level: 'A1',
    mode: SpeakingMode.conversation,
    session: _a1Session,
    topic:
        'You and I are strangers at a Berlin language café. We introduce '
        'ourselves: name, origin, languages, job or studies. After answering, '
        'I also ask YOU at least three W-questions back — insist on it.',
    practisePoints: [
      'ich bin / ich habe / ich heiße / ich komme aus',
      'W-questions: wer, was, wo, woher, wie',
      'The verb in second position in every statement',
    ],
    targetVocabulary: [
      'heißen',
      'kommen aus',
      'wohnen',
      'die Sprache',
      'der Beruf',
      'arbeiten',
    ],
    scoringCriteria: [
      'correct sein/haben forms',
      'verb in second position',
      'asking well-formed W-questions back',
    ],
    priorityErrors: [
      'verb not in second position',
      'wrong form of sein or haben',
    ],
    intro:
        'Your first conversation. The AI plays a friendly stranger — '
        'introduce yourself and make sure you ask questions back; asking is '
        'half the score.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Verb in second position',
        text:
            'German main clauses put the verb second, whatever comes first: '
            '"Ich heiße Anna." / "Aus Spanien komme ich." Both are fine — '
            '"Ich aus Spanien komme" is not.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_translate_v2',
    title: 'Translate: verb second, sein & haben',
    level: 'A1',
    mode: SpeakingMode.translationDrill,
    session: _a1Session,
    topic:
        'Ten short English sentences that all live or die on verb-second '
        'word order and the forms of sein and haben.',
    material:
        'Sentences to serve one at a time (accept any correct German):\n'
        '1. I am tired.\n'
        '2. My brother has a dog.\n'
        '3. Today I am in Berlin.\n'
        '4. Are you from Spain?\n'
        '5. She is a teacher.\n'
        '6. We have two children.\n'
        '7. My name is Tom.\n'
        '8. Where do you live?\n'
        '9. The child is three years old.\n'
        '10. On Monday I have time.',
    practisePoints: [
      'sein and haben in all singular forms',
      'Verb-second after a fronted time word (Heute bin ich…)',
      'Questions: verb first, subject second',
    ],
    scoringCriteria: [
      'correct verb form',
      'correct word order',
      'articles where needed',
    ],
    priorityErrors: ['verb pushed to third position', 'wrong auxiliary form'],
    intro:
        'A translation drill: your AI serves each English sentence, you say '
        'or type the German. It tells you right or wrong immediately and '
        're-serves your misses.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'warning',
        title: 'The trap in sentence 3 and 10',
        text:
            'Starting with "Heute" or "Am Montag" pushes the subject AFTER '
            'the verb: "Heute bin ich…", never "Heute ich bin…".',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_gender_casino',
    title: 'Game: the gender casino',
    level: 'A1',
    mode: SpeakingMode.wordGame,
    session: _a1Session,
    topic:
        'A betting game about noun genders. Keep it quick and playful; '
        'explain the pattern behind every noun I get wrong.',
    material:
        'Game rules:\n'
        '- You are the croupier. Each round, name one German noun from A1 '
        'vocabulary (family, café, everyday objects) WITHOUT its article.\n'
        '- I bet by calling der, die or das.\n'
        '- Right call = 10 points for me. Wrong = you keep the points and '
        'reveal the pattern if there is one (-e mostly die, -chen always '
        'das, -er often der…).\n'
        '- 10 rounds, then convert my points to the final score.',
    practisePoints: [
      'der/die/das for common A1 nouns',
      'Gender patterns: -e, -chen, -ung, -er',
      'Reacting fast without translating first',
    ],
    scoringCriteria: ['correct gender calls', 'using patterns, not luck'],
    priorityErrors: ['systematically wrong endings-based guesses'],
    intro:
        'A game: bet on the gender of nouns against your AI. Losing a round '
        'is fine — the croupier explains the pattern, and that explanation '
        'is the real prize.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Three patterns pay out',
        text:
            'Ends in -e? Usually die. Ends in -chen? Always das. Male person '
            'or -er tool? Usually der. That covers most of tonight\'s table.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_words_numbers',
    title: 'Words: numbers 0–100 & prices',
    level: 'A1',
    mode: SpeakingMode.vocabDrill,
    session: _a1Session,
    topic:
        'Numbers 0–100 out loud and as digits, then simple prices with '
        '"Das kostet … Euro". Mix directions: sometimes say the digit, '
        'sometimes I do.',
    material:
        'Drill sets:\n'
        '- Core numbers: 0–12 individually, then 13–19 (-zehn), then the '
        'tens (zwanzig, dreißig … hundert).\n'
        '- The swap rule: 21 = einundzwanzig (one-and-twenty), 45 = '
        'fünfundvierzig, 99 = neunundneunzig.\n'
        '- Prices to ask with "Was kostet das?": 2,50 € · 7 € · 19,90 € · '
        '64 € · 99 Cent.',
    practisePoints: [
      'Numbers 0–20 instantly',
      'The und-swap in 21–99 (einundzwanzig)',
      'Prices: Euro und Cent',
    ],
    scoringCriteria: [
      'the right number',
      'the und-swap order',
      'price phrasing',
    ],
    priorityErrors: ['English digit order in 21–99'],
    intro:
        'Numbers are pure drill material — perfect for your AI. It quizzes '
        '0–100 both ways and finishes with a round of prices.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Say the ones first',
        text:
            'German swaps two-digit numbers: 34 is vierunddreißig — '
            '"four-and-thirty". Hear the und? The small digit came first.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_read_dasbinich',
    title: 'Reading: Das bin ich',
    level: 'A1',
    mode: SpeakingMode.readingQa,
    session: _a1Session,
    topic:
        'A five-sentence self-introduction to read and answer questions '
        'about. Ask the questions in very simple German; accept short '
        'answers but reward full sentences.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Hallo! Ich heiße Lena und ich komme aus Österreich. Ich wohne '
        'jetzt in Hamburg und arbeite als Köchin in einem kleinen Café. '
        'Meine Familie ist groß: Ich habe zwei Brüder und eine Schwester. '
        'Am Sonntag koche ich für alle — das ist mein Hobby und mein Beruf!\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Woher kommt Lena?\n'
        '2. Wo wohnt sie jetzt?\n'
        '3. Was ist ihr Beruf?\n'
        '4. Wie viele Geschwister hat sie?\n'
        '5. Was macht sie am Sonntag — und warum ist das besonders?',
    practisePoints: [
      'Understanding a short A1 text without translating it',
      'Answering W-questions in full sentences',
      'sie-forms: sie kommt, sie wohnt, sie hat',
    ],
    scoringCriteria: [
      'correct information from the text',
      'full-sentence answers',
      'third-person verb forms',
    ],
    priorityErrors: ['ich-form used for Lena', 'answers off the text'],
    intro:
        'Your first reading. The AI shows you a short text, then asks about '
        'it — question 5 needs a little thinking, not just finding a word.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Answer about HER',
        text:
            'The text says "ich", but you answer about Lena: ich heiße → '
            'sie heißt, ich habe → sie hat. That -t is the whole exercise.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_story_family_photo',
    title: 'Tell it: the family photo',
    level: 'A1',
    mode: SpeakingMode.storytelling,
    session: _a1Session,
    topic:
        'You describe an imaginary family photo to me in 4–5 sentences '
        'first. Then I retell who is in it, from memory, in my own words.',
    material:
        'Story skeleton:\n'
        '- You invent a family photo: 4 people, their names, one detail '
        'each (age, job, or mood). Describe it to me slowly, twice if I ask.\n'
        '- Beat 1: I name who is in the photo (Das ist… / Das sind…).\n'
        '- Beat 2: I say one thing about each person (Er ist… / Sie hat…).\n'
        '- Beat 3: I say which person I like and why, very simply.\n'
        '- Required: sein in er/sie/wir forms, at least 4 family words with '
        'the right article.',
    practisePoints: [
      'Das ist / Das sind for pointing people out',
      'er/sie/wir forms of sein and haben',
      'Family vocabulary with articles',
    ],
    scoringCriteria: [
      'covering all four people',
      'correct third-person forms',
      'family words with correct articles',
    ],
    priorityErrors: ['er/sie mixed up', 'missing articles'],
    intro:
        'A memory-and-retell exercise: the AI paints a family photo in '
        'words, and you bring it back to life. It checks you covered '
        'everyone.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Das ist… / Das sind…',
        text:
            'One person: "Das ist mein Bruder." Several: "Das sind meine '
            'Eltern." The photo-pointing phrase carries the whole story.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_cafe_roleplay',
    title: 'Checkpoint: at the café',
    level: 'A1',
    mode: SpeakingMode.roleplay,
    session: _a1Session,
    topic:
        'You are the waiter in a Berlin café, I am the guest. I greet you, '
        'order a drink and something to eat, ask the price, and pay. '
        'Twist: you are OUT of the first two things I order — I must react '
        'and choose something else, politely.',
    targetVocabulary: [
      'Ich möchte…',
      'der Kaffee',
      'das Wasser',
      'der Kuchen',
      'Was kostet…?',
      'die Rechnung',
    ],
    practisePoints: [
      'Ordering with Ich möchte / Ich nehme',
      'Asking prices and understanding number answers',
      'Polite reactions: Schade! Dann nehme ich…',
    ],
    scoringCriteria: [
      'a complete order, price question and payment',
      'polite reaction to the twist',
      'verb-second in every sentence',
    ],
    priorityErrors: ['dropping into English under pressure', 'word order'],
    intro:
        'Mid-module checkpoint, as a scene: order at a café where nothing '
        'you want is available. Staying in German when plans collapse is '
        'exactly the skill.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The rescue phrase',
        text:
            '"Schade! Dann nehme ich einen Tee." — disappointment, pivot, '
            'new order, all in five words. Keep it ready.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_write_tandem',
    title: 'Write: hello, tandem partner',
    level: 'A1',
    mode: SpeakingMode.writing,
    session: _a1Session,
    topic:
        'A first written message to a new German tandem partner. Grade the '
        'text against the rubric in the material, sentence by sentence.',
    material:
        'Writing task:\n'
        '- Write me (your new tandem partner) 5 sentences about yourself: '
        'name, origin, home, job or studies, family or hobby.\n'
        '- End with one W-question for me.\n'
        'Rubric (grade against this):\n'
        '- Verb in second position in every statement (biggest weight).\n'
        '- Correct sein/haben forms.\n'
        '- At least three different topics covered.\n'
        '- The closing question is well-formed.',
    practisePoints: [
      'Verb-second in writing, where there is time to check',
      'sein/haben across topics',
      'Forming one clean W-question',
    ],
    scoringCriteria: [
      'word order',
      'verb forms',
      'coverage of the rubric points',
    ],
    priorityErrors: ['verb-second slips', 'missing question at the end'],
    intro:
        'Your first written German: five sentences and a question. Writing '
        'gives you time to check the verb is second — use it.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Check every sentence twice',
        text:
            'Read each sentence and point at the verb. Is it the second '
            'idea in the sentence? Then send. This one check catches most '
            'A1 writing mistakes.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m1_gate_interview',
    title: 'Module exam: the A1.1 interview',
    level: 'A1',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 4, minExchanges: 8),
    topic:
        'The closing interview for my first module. Eight questions across '
        'everything: introduction, family, numbers and prices, my daily '
        'basics, and one question where you point at an imaginary object '
        'and ask what it is (article required!).',
    practisePoints: [
      'sein/haben and regular present endings',
      'W-questions understood and answered fully',
      'Numbers and prices without hesitation',
      'Nouns with the right article',
    ],
    scoringCriteria: [
      'full-sentence answers',
      'verb in second position',
      'correct articles and verb forms',
    ],
    priorityErrors: [
      'verb not in second position',
      'wrong or missing article',
      'wrong sein/haben form',
    ],
    intro:
        'The module gate: an eight-question interview over everything in '
        'M1. Pass it and A1.2 unlocks. Retake it as often as you like — '
        'your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Full sentences win',
        text:
            '"Aus Italien." scores half; "Ich komme aus Italien." scores '
            'full. In the exam interview, always spend the whole sentence.',
      ),
    ],
  ),
];
