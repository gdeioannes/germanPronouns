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

/// sein, haben, verb-second and W-questions — the backbone of every
/// introduction in this module.
const List<HelpMemoryTip> _introTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'sein and haben — the full present',
    text:
        'sein: ich **bin**, du **bist**, er/sie/es **ist**, wir **sind**, '
        'ihr **seid**, sie/Sie **sind**. haben: ich **habe**, du **hast**, '
        'er/sie/es **hat**, wir **haben**, ihr **habt**, sie/Sie **haben**. '
        'These two carry half of A1 — know them cold.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The verb sits in position 2',
    text:
        'Whatever comes first, the finite verb is the second element: '
        '*Ich **wohne** in Berlin.* = *Jetzt **wohne** ich in Berlin.* '
        'Front a time word and the subject slides behind the verb — '
        'never *Jetzt ich wohne…*.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'W-questions: W-word, verb, subject',
    text:
        '**Wer** bist du? · **Was** machst du? · **Wo** wohnst du? · '
        '**Woher** kommst du? · **Wie** heißt du? The W-word takes slot 1, '
        'the verb stays glued in slot 2, the subject follows.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'No -ing, no am/is doing',
    text:
        'German has one present tense: *ich arbeite* covers both "I work" '
        'and "I am working". Never build *ich bin arbeiten* — drop the '
        'English -ing reflex at the door.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„I come from Spain and live in Berlin now."',
    text: 'Ich **komme** aus Spanien und **wohne** jetzt in Berlin.',
  ),
];

/// der/die/das, ein/eine and the gender patterns behind them.
const List<HelpMemoryTip> _articleTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Three genders, three articles',
    text:
        'Every noun is masculine (**der** Vater), feminine (**die** Mutter) '
        'or neuter (**das** Kind). Indefinite: **ein** Vater, **eine** '
        'Mutter, **ein** Kind — only the feminine gets its own form -e.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Learn the article as part of the word',
    text:
        'Never learn *Mutter*, always **die Mutter** — say the article '
        'every single time, and picture the word in a color if it helps '
        '(blue der, red die, green das).',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Endings that betray the gender',
    text:
        '-**e** is usually die (die Familie, die Sprache), -**chen** is '
        'always das (das Mädchen), -**ung** is always die (die Zeitung), '
        'male persons and many -**er** words are der (der Bruder, der '
        'Lehrer).',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Plural flips to die',
    text:
        'In the plural, every gender takes **die**: der Bruder → die '
        '**Brüder**, das Kind → die **Kinder**, die Schwester → die '
        '**Schwestern**. Die in the plural says nothing about the '
        'singular gender.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„The child has a brother and a sister."',
    text: '**Das** Kind hat **einen** Bruder und **eine** Schwester.',
  ),
];

/// Numbers 0–100, the und-swap and price talk.
const List<HelpMemoryTip> _numberTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The building blocks',
    text:
        '0–12 are one-offs: null, eins, zwei, drei, vier, fünf, sechs, '
        'sieben, acht, neun, zehn, elf, zwölf. 13–19 add -**zehn** '
        '(dreizehn, vierzehn…), the tens end in -**zig**: zwanzig, '
        'dreißig, vierzig … neunzig, then **hundert**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The und-swap: ones first',
    text:
        '21–99 say the small digit first: 21 = **ein**undzwanzig '
        '("one-and-twenty"), 45 = **fünf**undvierzig, 99 = '
        '**neun**undneunzig. Hear the *und*? The ones already went by.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Watch the irregular corners',
    text:
        '16 is **sechzehn** (no -s), 17 is **siebzehn** (no -en), 60 is '
        '**sechzig**, 70 is **siebzig**, and 30 is **dreißig** with ß, '
        'not -zig. And 21 starts with **ein**-, never *eins*-.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Prices read comma as Euro',
    text:
        '2,50 € is spoken „zwei Euro **fünfzig**" — the comma becomes '
        '*Euro*, the cents just follow. Ask with *Was kostet das?*, '
        'answer with *Das kostet…*.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„That costs twenty-four euros ninety."',
    text: 'Das kostet **vierundzwanzig** Euro **neunzig**.',
  ),
];

/// Regular present endings and the jump from ich to er/sie/es.
const List<HelpMemoryTip> _thirdPersonTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The six regular endings',
    text:
        'ich -**e**, du -**st**, er/sie/es -**t**, wir -**en**, ihr -**t**, '
        'sie/Sie -**en**. So: ich wohn**e**, du wohn**st**, sie wohn**t**, '
        'wir wohn**en**, ihr wohn**t**, sie wohn**en**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'From ich to er/sie: swap -e for -t',
    text:
        'Retelling someone else, every ich-form shifts: ich heiße → sie '
        'heiß**t**, ich komme → er komm**t**, ich habe → sie **hat**, '
        'ich bin → er **ist**. That little -t is the whole trick.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Stems in -t / -d add an extra -e',
    text:
        'After a stem ending in -t or -d you slip in an -e so the ending '
        'is audible: du arbeit**e**st, er arbeit**e**t, ihr find**e**t.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Das ist… / Das sind…',
    text:
        'Pointing at people: one person **Das ist** mein Bruder, several '
        '**Das sind** meine Eltern. The photo-pointing phrase carries any '
        'family description.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: '„She lives in Hamburg and works in a café."',
    text: 'Sie **wohnt** in Hamburg und **arbeitet** in einem Café.',
  ),
];

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
        'Guten Tag = good day · Guten Abend = good evening · '
        'Gute Nacht = good night · bitte = please · danke = thank you · '
        'Entschuldigung = excuse me · ja = yes · nein = no\n'
        'die Mutter = mother · der Vater = father · die Eltern = parents · '
        'der Bruder = brother · die Schwester = sister · das Kind = child · '
        'die Familie = family · der Freund = friend (m) · '
        'die Freundin = friend (f) · der Name = name · '
        'die Großmutter = grandmother · der Großvater = grandfather',
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
        'Every German noun carries a gender — der, die or das — and the '
        'article is part of the word, not decoration. Drill your first '
        'greetings and family words with the article welded on from day one.',
    tips: _articleTips,
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
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich heiße ... = my name is ... · '
        'ich komme aus ... = I come from ... · '
        'ich wohne in ... = I live in ... · '
        'ich spreche Englisch und ein bisschen Deutsch = '
        'I speak English and a little German · '
        'ich arbeite als ... = I work as a ... · '
        'wie heißt du? = what is your name? · '
        'woher kommst du? = where are you from? · '
        'wo wohnst du? = where do you live? · '
        'was machst du beruflich? = what do you do for a living? · '
        'freut mich! = nice to meet you!',
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
        'A German introduction runs on three verbs — heißen, kommen, wohnen '
        '— plus sein and haben, with the verb always in second position. '
        'W-questions (wer, wo, woher, wie) put the question word first and '
        'keep the verb right behind it.',
    tips: _introTips,
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
        'Sentences to serve one at a time — read me only the English half; '
        'the German after „=" is the reference answer, and any other '
        'correct German is acceptable:\n'
        '1. I am tired. = Ich bin müde.\n'
        '2. My brother has a dog. = Mein Bruder hat einen Hund.\n'
        '3. Today I am in Berlin. = Heute bin ich in Berlin.\n'
        '4. Are you from Spain? = Kommst du aus Spanien?\n'
        '5. She is a teacher. = Sie ist Lehrerin.\n'
        '6. We have two children. = Wir haben zwei Kinder.\n'
        '7. My name is Tom. = Ich heiße Tom.\n'
        '8. Where do you live? = Wo wohnst du?\n'
        '9. The child is three years old. = Das Kind ist drei Jahre alt.\n'
        '10. On Monday I have time. = Am Montag habe ich Zeit.',
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
        'sein (ich bin, du bist, er ist…) and haben (ich habe, du hast, er '
        'hat…) are irregular and everywhere; and whenever a time word like '
        '„heute" opens the sentence, the verb still comes second, so the '
        'subject slides behind it: Heute bin ich…',
    tips: [
      ..._introTips,
      HelpMemoryTip(
        kind: 'warning',
        title: 'The trap in sentence 3 and 10',
        text:
            'Starting with **Heute** or **Am Montag** pushes the subject '
            'AFTER the verb: *Heute **bin ich**…*, never *Heute ich bin…*.',
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
        'Noun gender is not random: the ending often gives it away. Words '
        'in -e are mostly die, -chen is always das, -ung is always die, '
        'and male persons and -er tools lean der — bet on the pattern, '
        'not on luck.',
    tips: _articleTips,
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
        'Numbers to master (number = German):\n'
        'null = 0 · eins = 1 · zwei = 2 · drei = 3 · vier = 4 · fünf = 5 · '
        'sechs = 6 · sieben = 7 · acht = 8 · neun = 9 · zehn = 10 · '
        'elf = 11 · zwölf = 12\n'
        'dreizehn = 13 · sechzehn = 16 · siebzehn = 17 · zwanzig = 20 · '
        'dreißig = 30 · vierzig = 40 · sechzig = 60 · siebzig = 70 · '
        'hundert = 100\n'
        'einundzwanzig = 21 · fünfundvierzig = 45 · neunundneunzig = 99\n'
        'Drill sets:\n'
        '- Core numbers 0–12, then 13–19 (-zehn), then the tens up to '
        'hundert; the und-swap for 21–99 (einundzwanzig, one-and-twenty).\n'
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
        'German two-digit numbers run backwards: 34 is vierunddreißig, '
        '„four-and-thirty" — the ones come first, joined by und. Prices '
        'speak the comma as Euro: 2,50 € is „zwei Euro fünfzig".',
    tips: _numberTips,
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
        'The text speaks as „ich", but your answers talk ABOUT Lena — so '
        'every verb shifts to the er/sie form: ich heiße → sie heißt, ich '
        'habe → sie hat, ich bin → sie ist.',
    tips: _thirdPersonTips,
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
        'the right article.\n'
        '\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'das ist meine Mutter = this is my mother · '
        'das sind meine Eltern = these are my parents · '
        'er ist dreißig Jahre alt = he is thirty years old · '
        'sie hat braune Haare = she has brown hair · '
        'er arbeitet als Lehrer = he works as a teacher · '
        'sie ist sehr nett = she is very nice · '
        'ich mag meinen Bruder = I like my brother · '
        'links steht mein Vater = my father is standing on the left',
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
        'Describing people runs on two frames: „Das ist…" for one person, '
        '„Das sind…" for several, then er/sie-forms of sein and haben for '
        'the details — er ist alt, sie hat einen Hund.',
    tips: _thirdPersonTips,
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
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich möchte einen Kaffee = I would like a coffee · '
        'ich nehme ein Wasser = I will take a water · '
        'was kostet der Kuchen? = how much is the cake? · '
        'die Rechnung, bitte = the bill, please · '
        'schade! dann nehme ich einen Tee = '
        'what a pity! then I will take a tea · '
        'haben Sie auch Kuchen? = do you also have cake? · '
        'das macht zusammen ... = that comes to ... altogether · '
        'stimmt so = keep the change',
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
        'Ordering runs on two polite frames — „Ich möchte…" and „Ich '
        'nehme…" — plus „Was kostet…?" for the price; when your first '
        'choice is gone, „Schade! Dann nehme ich…" pivots you to a new '
        'order without leaving German.',
    tips: [
      ..._numberTips,
      HelpMemoryTip(
        kind: 'example',
        title: '„What a pity! Then I will take a tea." — the rescue phrase',
        text: 'Schade! Dann **nehme ich** einen Tee.',
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
        'The same verb-second rule that governs your speaking governs your '
        'writing — but on paper you can check it: find the verb in every '
        'sentence and make sure it is the second idea, with sein and haben '
        'in their correct irregular forms.',
    tips: [
      ..._introTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Check every sentence twice',
        text:
            'Read each sentence and point at the verb. Is it the **second** '
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
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich heiße ... und komme aus ... = my name is ... and I come '
        'from ... · '
        'ich bin ... Jahre alt = I am ... years old · '
        'ich habe zwei Geschwister = I have two siblings · '
        'ich spreche Englisch und Deutsch = I speak English and German · '
        'das ist ein Tisch = that is a table · '
        'das kostet zwanzig Euro = that costs twenty euros · '
        'ich arbeite als ... = I work as a ... · '
        'am Sonntag koche ich = on Sunday I cook',
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
        'The module gate bundles everything from M1: sein/haben and the '
        'regular endings, verb-second word order, W-questions, numbers and '
        'prices, and nouns with their articles — answered in full '
        'sentences, because „Ich komme aus Italien." scores where „Aus '
        'Italien." does not.',
    tips: [
      ..._introTips,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Full sentences win',
        text:
            '*Aus Italien.* scores half; *Ich **komme** aus Italien.* '
            'scores full. In the exam interview, always spend the whole '
            'sentence.',
      ),
    ],
  ),
];
