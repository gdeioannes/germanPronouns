import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M6 · B1.2 — *Erzählen & Begründen* (Narrate & justify).
///
/// Can-do: narrate past events in written style; summarize a story;
/// describe processes; justify decisions in connected speech.
/// Grammar: Präteritum (sein/haben/modals + strong verbs), Passiv
/// present/past (werden + Partizip II), relative clauses (nom/akk/dat),
/// als vs wenn, Plusquamperfekt intro, n-declension nouns.
///
/// B1 session shape: ~4 minutes, 8 exchanges, pass 60.
const _b1Session = SpeakingSession(durationMinutes: 4, minExchanges: 8);

const List<HelpMemoryTip> _praeteritumTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The Präteritum backbone',
    text:
        'Six verbs carry every past story: sein → **war**, haben → '
        '**hatte**, werden → **wurde**, können → **konnte**, müssen → '
        '**musste**, wollen → **wollte**. Endings: ich/er **–** (no '
        'ending!), du **-st**, wir/sie **-en**, ihr **-t**: ich war, du '
        'warst, er war, wir waren.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Strong verbs change the vowel',
    text:
        'Strong verbs build the Präteritum with a vowel change and no '
        '-te: gehen → **ging**, kommen → **kam**, sehen → **sah**, geben '
        '→ **gab**, nehmen → **nahm**, finden → **fand**, fahren → '
        '**fuhr**, schreiben → **schrieb**, bleiben → **blieb**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Sing the vowel families',
    text:
        'Strong verbs move in choirs: **ei → ie** (schreiben/schrieb, '
        'bleiben/blieb), **i/e → a** (finden/fand, sprechen/sprach, '
        'trinken/trank). Learn one family member and you get its '
        'siblings for free.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'No weak -te on strong verbs',
    text:
        'Never bolt a weak ending onto a strong verb: *gehte* and '
        '*kommte* do not exist — only **ging** and **kam**. And ich/er '
        'take no ending at all: ich **ging**, er **kam**, never *ich '
        'ginge* (that is a different mood entirely).',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'When she opened the door, she saw an old suitcase.',
    text: 'Als sie die Tür **öffnete**, **sah** sie einen alten Koffer.',
  ),
];

const List<HelpMemoryTip> _passiveTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'werden is the engine',
    text:
        'German passive always runs on werden + Partizip II. Present: '
        '„Das Brot **wird gebacken**" (is baked). Past: „Die Brücke '
        '**wurde gebaut**" (was built). Plural: „Die Briefe **wurden '
        'eingepackt**". The Partizip waits at the very end of the '
        'clause.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Name the doer with von + Dativ',
    text:
        'If the English names the doer, German attaches it with **von** '
        '+ Dativ: „Das Lied wurde **von den Kindern** gesungen" — the '
        'song was sung by the children. No doer named? Just leave it '
        'out: „Mein Fahrrad wurde gestohlen."',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'wird, not ist',
    text:
        'English *is baked* tempts you into *ist gebacken* — wrong verb. '
        'The process passive needs **wird**/**wurde**: „Das Brot **wird** '
        'jeden Morgen gebacken." ist + Partizip describes a finished '
        'state, not the action.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'The doer disappears',
    text:
        'Flip the sentence like a pancake: the old object becomes the '
        'new subject, the doer slides into a von-phrase or vanishes, and '
        'werden takes the verb slot. Object up, doer down, **werden** in '
        'the middle.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The museum was opened in May.',
    text: 'Das Museum **wurde** im Mai **eröffnet**.',
  ),
];

const List<HelpMemoryTip> _relativeTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The relative pronouns',
    text:
        'They look like der/die/das with two extras: Nominativ **der / '
        'die / das / die**, Akkusativ **den / die / das / die**, Dativ '
        '**dem / der / dem / denen**. Gender and number come from the '
        'noun in front; the verb goes to the end of the clause.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The case is local',
    text:
        'The relative pronoun takes its case from its OWN clause: „der '
        'Mann, **den** ich sah" (I saw him — accusative), „der Mann, '
        '**dem** ich half" (helfen takes dative). The main clause has no '
        'vote.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'n-declension nouns',
    text:
        'A small club of masculine nouns adds **-n/-en** in every case '
        'except nominative: der Junge → den **Jungen**, mit dem '
        '**Jungen**; also der Zeuge, der Kollege, der Herr, der Student. '
        '*mit der Junge* is a double error.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Ask the mini-question',
    text:
        'Before choosing the pronoun, ask inside the clause: wer? → '
        '**der/die/das**, wen? → **den**, wem? → **dem/denen**. „…, '
        '(wem half ich?) **dem** ich half."',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The man whom I helped rode a red bicycle.',
    text: 'Der Mann, **dem** ich half, fuhr ein rotes Fahrrad.',
  ),
];

const List<HelpMemoryTip> _justifyTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'deshalb flips, nämlich hides',
    text:
        '**deshalb**/**daher** take position one and pull the verb next: '
        '„Deshalb **zog** ich um." **nämlich** never starts a clause — '
        'it tucks in after the verb: „Ich zog um, ich hatte **nämlich** '
        'einen neuen Job."',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'als vs wenn in the past',
    text:
        'One single completed moment takes **als**: „**Als** ich '
        'achtzehn war, …". Repeated past events take **wenn** (= '
        'whenever): „Immer **wenn** ich Zeit hatte, las ich." Once upon '
        'a time = als; every time = wenn.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'deshalb + subject is the classic slip',
    text:
        'English *therefore I moved* invites „deshalb ich zog um" — '
        'wrong. deshalb fills slot one, so the verb must come second: '
        '„deshalb **zog** ich um." Subject third, always.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'I had no time — that is why I stayed at home.',
    text: 'Ich hatte keine Zeit, **deshalb** blieb ich zu Hause.',
  ),
];

const List<HelpMemoryTip> _plusquamTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The past of the past',
    text:
        'Plusquamperfekt = **hatte/war** + Partizip II, for what had '
        'happened BEFORE the story: „Es **hatte geregnet**", „Ich **war '
        'gefahren**". Same haben/sein split as the Perfekt — movement '
        'and change take war.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'nachdem loves Plusquamperfekt',
    text:
        '„**Nachdem** es geregnet **hatte**, war die Straße nass." The '
        'nachdem-clause sits one tense further back than the main '
        'clause: Plusquamperfekt there, Präteritum in the main clause.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Not just another Perfekt',
    text:
        '„Ich habe das Fenster geöffnet" is Perfekt — the ordinary past. '
        'Background that came BEFORE the accident needs **hatte**: „Ich '
        '**hatte** das Fenster **geöffnet**, dann kam der Sturm."',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Three layers, three tenses',
    text:
        'A report stacks like a cake: bottom layer background '
        '(**Plusquamperfekt**), middle layer event (**Präteritum**), top '
        'layer damage (**Passiv**: wurde + Partizip II). Bake all three.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'It had rained, so the street was wet.',
    text:
        'Es **hatte geregnet**, deshalb war die Straße nass, und dann '
        'passierte es.',
  ),
];

final List<QuizContent> enDeAiM6Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m6_praet_ladder',
    title: 'Words: the Präteritum ladder',
    level: 'B1',
    mode: SpeakingMode.vocabDrill,
    session: _b1Session,
    passScore: 60,
    topic:
        'Strong-verb Präteritum, drilled as a ladder: infinitive up, '
        'Präteritum down, both directions, fast. After every 5 verbs, make '
        'me build one instant micro-sentence with a form I just drilled.',
    material:
        'Verb ladder to drill (infinitive = Präteritum, er/sie form):\n'
        'gehen = ging · kommen = kam · sehen = sah · geben = gab · '
        'nehmen = nahm · finden = fand · fahren = fuhr · schreiben = '
        'schrieb · lesen = las · sprechen = sprach · essen = aß · '
        'trinken = trank · laufen = lief · schlafen = schlief · '
        'bleiben = blieb · rufen = rief · treffen = traf · '
        'beginnen = begann · verlieren = verlor · wissen = wusste\n'
        'Plus the backbone: sein = war · haben = hatte · werden = wurde · '
        'können = konnte · müssen = musste · wollen = wollte\n'
        'Micro-sentence rule: after each block of 5, give me a subject and '
        'a verb from the block; I answer with one Präteritum sentence '
        '(Er ging gestern nach Hause).',
    practisePoints: [
      'Strong-verb vowel changes (gehen → ging, nehmen → nahm)',
      'war/hatte/wurde and the modal Präteritum forms',
      'No endings on ich/er in Präteritum (ich ging, not ich ginge)',
    ],
    scoringCriteria: [
      'the correct Präteritum form both directions',
      'well-formed micro-sentences',
      'increasing speed on repeats',
    ],
    priorityErrors: [
      'weak -te endings on strong verbs (gehte, kommte)',
      'Perfekt used where Präteritum was asked',
    ],
    intro:
        'Written and told stories in German run on the Präteritum, and '
        'the strong verbs form it by changing their vowel — gehen → ging, '
        'kommen → kam — with no ending on ich and er/sie/es.',
    tips: _praeteritumTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_fairy_tale',
    title: 'Tell it: a modern fairy tale',
    level: 'B1',
    mode: SpeakingMode.storytelling,
    session: _b1Session,
    passScore: 60,
    topic:
        'You hand me a scrambled Grimm-style story skeleton; I tell it as '
        'a flowing modern fairy tale, entirely in Präteritum, opening with '
        '"Es war einmal…". Interrupt only for tense slips.',
    material:
        'Story skeleton (present it scrambled, I must order it):\n'
        '- eine junge Programmiererin, die in einem grauen Hochhaus wohnte\n'
        '- ein sprechender Kaffeeautomat mit einem geheimen Wunsch\n'
        '- ein Chef, der nie Danke sagte\n'
        '- eine Reise in den Keller der Firma, wo etwas Seltsames wartete\n'
        '- ein Tausch: eine Woche Schweigen gegen einen echten Wunsch\n'
        '- ein Ende, in dem jemand etwas Wichtiges lernte\n'
        'Required forms:\n'
        '- Opening: Es war einmal…\n'
        '- Präteritum throughout (war, hatte, ging, sagte, wusste…).\n'
        '- At least 2 relative clauses (die Frau, die…; der Automat, '
        'den…).\n'
        '- One als-clause for a single past moment (Als sie den Keller '
        'öffnete, …).\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'es war einmal = once upon a time · eines Tages = one day · '
        'plötzlich = suddenly · als sie die Tür öffnete = when she opened '
        'the door · der Automat, der sprechen konnte = the machine that '
        'could talk · am Ende = in the end · sie lebten glücklich = they '
        'lived happily',
    practisePoints: [
      'Sustained Präteritum narration',
      'Relative clauses to introduce characters',
      'als for one-time past events',
    ],
    scoringCriteria: [
      'correct Präteritum forms across the tale',
      'at least two correct relative clauses',
      'a coherent story using every skeleton element',
    ],
    priorityErrors: [
      'Perfekt creeping into the narration',
      'wenn used where als belongs',
    ],
    intro:
        'Fairy tales are told in pure Präteritum — Es war einmal…, sie '
        'ging, sie fand — with als marking each single past moment and '
        'relative clauses introducing every character.',
    tips: [
      ..._praeteritumTips,
      HelpMemoryTip(
        kind: 'rule',
        title: 'als, not wenn',
        text:
            'A single completed moment in the past takes **als**: „**Als** '
            'sie den Keller öffnete…". wenn in the past means „whenever" '
            '— every time, not once upon a time.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_passive_shift',
    title: 'Translate: the passive shift',
    level: 'B1',
    mode: SpeakingMode.translationDrill,
    session: _b1Session,
    passScore: 60,
    topic:
        'Ten active English sentences that must come out as German '
        'passive — werden + Partizip II in the present, wurde + Partizip '
        'II in the past. Serve one at a time; re-serve my misses.',
    material:
        'Sentences to serve one at a time (read me only the English half; '
        'the German after = is the reference answer, other correct German '
        'passives are acceptable):\n'
        '1. The bridge was built in 1900. = Die Brücke wurde 1900 gebaut.\n'
        '2. German is spoken here. = Hier wird Deutsch gesprochen.\n'
        '3. The letter is being written right now. = Der Brief wird '
        'gerade geschrieben.\n'
        '4. The window was broken yesterday. = Das Fenster wurde gestern '
        'zerbrochen.\n'
        '5. The bread is baked every morning. = Das Brot wird jeden '
        'Morgen gebacken.\n'
        '6. My bike was stolen last week. = Mein Fahrrad wurde letzte '
        'Woche gestohlen.\n'
        '7. The house is being renovated. = Das Haus wird renoviert.\n'
        '8. The song was sung by all the children. = Das Lied wurde von '
        'allen Kindern gesungen.\n'
        '9. Dinner is served at seven. = Das Abendessen wird um sieben '
        'serviert.\n'
        '10. The museum was opened in May. = Das Museum wurde im Mai '
        'eröffnet.',
    practisePoints: [
      'Present passive: wird + Partizip II',
      'Past passive: wurde + Partizip II',
      'The agent with von + Dativ where the English names one',
    ],
    scoringCriteria: [
      'the correct form of werden',
      'the correct Partizip II at the end',
      'von-phrases with the right case',
    ],
    priorityErrors: [
      'ist + Partizip used instead of wird/wurde',
      'Partizip II not clause-final',
    ],
    intro:
        'The German passive is built with werden + Partizip II — wird '
        'gebaut for the present, wurde gebaut for the past — and the '
        'participle always waits at the end of the clause.',
    tips: _passiveTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_news_item',
    title: 'Reading: the local news item',
    level: 'B1',
    mode: SpeakingMode.readingQa,
    session: _b1Session,
    passScore: 60,
    topic:
        'A short newspaper item in narrative Präteritum. Keep everything '
        'at B1 — no rewording upwards. Question 5 asks me to hunt down a '
        'passive sentence and turn it back into an active one.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Aufregung im Stadtpark\n'
        'Am Dienstagmorgen entdeckte eine Joggerin im Stadtpark einen '
        'offenen Koffer, der voller alter Briefe war. Sie rief sofort die '
        'Polizei, die nach zwanzig Minuten kam. Die Briefe wurden von '
        'zwei Beamten vorsichtig eingepackt. Ein Sprecher der Stadt '
        'sagte, dass der Koffer wahrscheinlich seit Jahren in einem '
        'Gebüsch lag. Die Besitzerin, eine 90-jährige Frau aus dem '
        'Viertel, wurde noch am selben Tag gefunden. Sie freute sich '
        'sehr, denn die Briefe stammten von ihrem Mann. Der Koffer war '
        'vor langer Zeit bei einem Umzug verloren gegangen.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Was entdeckte die Joggerin, und wo?\n'
        '2. Wer kam nach zwanzig Minuten?\n'
        '3. Wie lange lag der Koffer wahrscheinlich im Gebüsch?\n'
        '4. Warum freute sich die Besitzerin so sehr?\n'
        '5. Finde einen Passivsatz im Text und mach daraus einen '
        'Aktivsatz. (Check my active version carefully.)',
    practisePoints: [
      'Reading narrative Präteritum fluently',
      'Spotting passive constructions in real text',
      'Re-activating a passive sentence with the right subject',
    ],
    scoringCriteria: [
      'correct information from the text',
      'a correctly re-activated passive sentence',
      'answers in the past tenses of the text',
    ],
    priorityErrors: [
      'answering in present tense about past events',
      'keeping wurde in the "active" version',
    ],
    intro:
        'Newspaper German narrates in Präteritum and reports actions in '
        'the passive — wurde eingepackt, wurde gefunden. To turn a '
        'passive back to active, promote the von-phrase to subject and '
        'give the verb its normal form.',
    tips: [
      ..._passiveTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Passive radar',
        text:
            'Scan for **wurde(n)** + a participle at the end — that is '
            'your passive. To re-activate it, promote the von-phrase (or '
            'invent a doer) to subject: „Zwei Beamte **packten** die '
            'Briefe **ein**."',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_passiv_game',
    title: 'Game: Was wird hier gemacht?',
    level: 'B1',
    mode: SpeakingMode.wordGame,
    session: _b1Session,
    passScore: 60,
    topic:
        'A profession-guessing game played entirely in the passive. First '
        'you mime professions in words, I guess; then we swap and you '
        'guess mine. Any non-passive clue sentence loses the round.',
    material:
        'Game rules:\n'
        '- Round type A (4 rounds): you describe a profession using ONLY '
        'passive sentences, never naming it — "Hier werden Haare '
        'geschnitten. Die Kunden werden gefragt, wie kurz." I guess the '
        'profession in German (der Friseur!).\n'
        '- Round type B (4 rounds): we swap. I describe a profession in '
        'passive sentences (at least 2 per round), you guess. If one of '
        'my clue sentences is not a correct passive, the round is void.\n'
        '- Scoring: type A — 10 points per profession I guess right. '
        'Type B — 10 points if my passives are correct AND you can guess, '
        '+5 bonus for a third correct passive clue.\n'
        '- 8 rounds total, then convert my points to the final score.',
    practisePoints: [
      'Present passive under game pressure (wird/werden + Partizip II)',
      'Profession vocabulary in both directions',
      'Partizip II placed clause-final every time',
    ],
    scoringCriteria: [
      'correct passive clue sentences',
      'right profession guesses',
      'variety of verbs across rounds',
    ],
    priorityErrors: [
      'active sentences smuggled in as clues',
      'wrong Partizip II forms',
    ],
    intro:
        'The present passive — wird/werden + Partizip II — is how German '
        'describes what gets done somewhere: Hier werden Haare '
        'geschnitten. Singular takes wird, plural werden, and the '
        'participle closes the sentence.',
    tips: [
      ..._passiveTips,
      HelpMemoryTip(
        kind: 'example',
        title: 'Here bread is baked — an obvious baker.',
        text:
            'Hier **wird** Brot **gebacken**. Der Teig **wird** sehr früh '
            'am Morgen **gemacht**.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_big_decision',
    title: 'The decision that changed things',
    level: 'B1',
    mode: SpeakingMode.conversation,
    session: _b1Session,
    passScore: 60,
    topic:
        'I narrate one life decision — real or invented — that changed '
        'things: what came before, the decision itself, what followed. I '
        'justify it with deshalb, daher and nämlich. You listen like a '
        'curious friend, then challenge exactly one of my justifications '
        'and make me defend it.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich entschied mich für … = I decided on … · deshalb zog ich um '
        '= that is why I moved · ich hatte nämlich keine Wahl = you see, '
        'I had no choice · vorher hatte ich … = before that I had … · '
        'ich bereue es nicht = I do not regret it · der wichtigste Grund '
        'war … = the most important reason was … · danach änderte sich '
        'alles = after that everything changed',
    practisePoints: [
      'Connected past narration (Präteritum and Perfekt mixed naturally)',
      'Justifying with deshalb/daher (verb right after) and nämlich',
      'Defending a reason under a follow-up challenge',
    ],
    targetVocabulary: [
      'die Entscheidung',
      'sich entscheiden für',
      'deshalb',
      'nämlich',
      'bereuen',
      'der Grund',
    ],
    scoringCriteria: [
      'a clear before–decision–after arc',
      'correct connector word order',
      'a real defence when challenged',
    ],
    priorityErrors: [
      'deshalb followed by subject instead of verb',
      'nämlich placed at the start of its clause',
    ],
    intro:
        'To justify in German, deshalb and daher open the clause and pull '
        'the verb into second position, while nämlich hides inside the '
        'clause after the verb — it can never stand first.',
    tips: _justifyTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_radio_news',
    title: 'Listen & retell: the radio miniature',
    level: 'B1',
    mode: SpeakingMode.listenRetell,
    session: _b1Session,
    passScore: 60,
    topic:
        'You read a 90-second radio-style news miniature aloud (voice '
        'mode), normal pace, once — twice only if I ask. Then I retell it '
        'in my own words in past tenses, and you check me with three '
        'detail questions.',
    material:
        'The piece to read aloud (write your own, but it must be):\n'
        '- A local-news miniature of about 90 seconds / 8–10 sentences, '
        'B1 vocabulary only.\n'
        '- Topic: a small, concrete event — a rescued animal, a reopened '
        'bridge, a record-breaking bake sale, a found treasure.\n'
        '- Written in narrative Präteritum with at least two passive '
        'sentences (wurde gerettet, wurde eröffnet…) and one relative '
        'clause.\n'
        'Then:\n'
        '- I retell the story in my own words (past tenses, not a '
        'word-for-word echo).\n'
        '- Ask me 3 detail questions about facts I did not mention.\n'
        '- Grade the retelling for coverage and tense control, the '
        'questions for accuracy.',
    practisePoints: [
      'Catching the who/what/when of spoken German',
      'Retelling in Präteritum and Perfekt, not quoting',
      'Holding details for the follow-up questions',
    ],
    scoringCriteria: [
      'main events covered in the retelling',
      'correct past-tense forms',
      'detail questions answered from memory',
    ],
    priorityErrors: [
      'retelling in present tense',
      'inventing details not in the piece',
    ],
    intro:
        'Radio news narrates in Präteritum and reports results in the '
        'passive — wurde gerettet, wurde eröffnet. Retelling means '
        'rebuilding the story in your own past-tense sentences, not '
        'echoing the original.',
    tips: [
      HelpMemoryTip(
        kind: 'rule',
        title: 'Retell in the narrative tenses',
        text:
            'A retelling stays in the past: backbone verbs in Präteritum '
            '(**war**, **hatte**, **kam**, **fand**), everyday actions '
            'happily in Perfekt („dann **hat** sie die Polizei '
            '**gerufen**"). Present tense breaks the news spell.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Listen for anchors, not words',
        text:
            'Grab the five anchors — **wer, was, wo, wann, Ergebnis** — '
            'and let the rest go. A retelling built on five anchors beats '
            'a broken word-for-word echo every time.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Passives you will hear',
        text:
            'News loves the past passive: **wurde gerettet** (was '
            'rescued), **wurde eröffnet** (was opened), **wurde '
            'gefunden** (was found). Hearing wurde + participle? Someone '
            'did something — you can retell it actively.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'On Tuesday a small dog was rescued from the river.',
        text:
            'Am Dienstag **wurde** ein kleiner Hund aus dem Fluss '
            '**gerettet**.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_accident_report',
    title: 'Write: the insurance report',
    level: 'B1',
    mode: SpeakingMode.writing,
    session: _b1Session,
    passScore: 60,
    topic:
        'An accident report for an insurance form, written in three '
        'tense layers: what had happened before (Plusquamperfekt), what '
        'happened (Präteritum), what was damaged (Passiv). Grade it '
        'against the rubric, layer by layer.',
    material:
        'Writing task:\n'
        '- Invent a small, harmless household or bicycle accident and '
        'write the report (8–10 sentences) for the insurance form.\n'
        '- Layer 1 — the background: at least 2 sentences in '
        'Plusquamperfekt about what had happened before (Ich hatte das '
        'Fenster geöffnet…, Es hatte geregnet…).\n'
        '- Layer 2 — the event: the accident itself in Präteritum.\n'
        '- Layer 3 — the damage: at least 2 passive sentences (Die Vase '
        'wurde zerbrochen. Das Fahrrad wurde beschädigt.).\n'
        'Rubric (grade against this):\n'
        '- Each layer present and in its tense (biggest weight).\n'
        '- Plusquamperfekt formed with hatte/war + Partizip II.\n'
        '- Sober report style: no du/ihr, no exclamation marks.\n'
        '- Clear time order, ideally with nachdem or als.',
    practisePoints: [
      'Plusquamperfekt for the pre-history',
      'Präteritum for the event line',
      'Passive for damage — the classic report voice',
    ],
    scoringCriteria: [
      'each tense layer correct and in place',
      'formed Plusquamperfekt (hatte/war + Partizip II)',
      'report register throughout',
    ],
    priorityErrors: [
      'Perfekt where Plusquamperfekt is required',
      'active sentences in the damage layer',
    ],
    intro:
        'The Plusquamperfekt — hatte/war + Partizip II — reaches one step '
        'further back than the story itself: first what had happened, '
        'then the event in Präteritum, then the damage in the passive.',
    tips: _plusquamTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_witness',
    title: 'Roleplay: the witness interview',
    level: 'B1',
    mode: SpeakingMode.roleplay,
    session: _b1Session,
    passScore: 60,
    topic:
        'You are a patient, very thorough police officer; I witnessed a '
        'silly bicycle incident (nobody hurt, much confusion). Take my '
        'statement: what happened, in what order, and exactly WHO was '
        'involved — push me to identify every person with a relative '
        'clause (der Mann, der…; die Frau, die…; der Junge, den…).',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich habe alles beobachtet = I saw everything · der Mann, der '
        'telefonierte = the man who was on the phone · die Frau, die ich '
        'sah = the woman I saw · der Junge, dem ich half = the boy I '
        'helped · sie stießen zusammen = they collided · zuerst … danach '
        '… = first … after that … · es passierte gegen zehn Uhr = it '
        'happened around ten o’clock',
    practisePoints: [
      'Relative clauses in nominative, accusative and dative',
      'Ordered past narration under questioning',
      'n-declension in action (der Junge → den Jungen)',
    ],
    targetVocabulary: [
      'der Zeuge',
      'der Unfall',
      'zusammenstoßen',
      'beobachten',
      'der Radfahrer',
      'passieren',
    ],
    scoringCriteria: [
      'correct relative pronouns for each case',
      'a consistent, ordered account',
      'past tenses held throughout',
    ],
    priorityErrors: [
      'wrong relative pronoun case (der Mann, den ich half)',
      'der Junge left undeclined (mit der Junge)',
    ],
    intro:
        'Relative clauses pin people down precisely — der Mann, der '
        'telefonierte; die Frau, die ich sah — and the pronoun takes its '
        'case from its own clause, not from the main sentence.',
    tips: _relativeTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_gate_narrate',
    title: 'Module exam: narrate and justify',
    level: 'B1',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 5, minExchanges: 9),
    passScore: 60,
    topic:
        'The closing exam of the module: a narrate-and-justify session '
        'across everything — retell a past event in Präteritum, describe '
        'how something is made in the passive, identify people with '
        'relative clauses, and justify two decisions with deshalb and '
        'nämlich. Mix the topics; keep me moving.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'es war einmal = once upon a time · als ich jung war = when I '
        'was young · hier wird Brot gebacken = bread is baked here · das '
        'Fenster wurde zerbrochen = the window was broken · der Mann, '
        'den ich sah = the man I saw · deshalb blieb ich zu Hause = that '
        'is why I stayed home · ich hatte nämlich keine Zeit = you see, '
        'I had no time · nachdem es geregnet hatte = after it had rained',
    practisePoints: [
      'Präteritum narration on demand',
      'Passive descriptions (wird/wurde + Partizip II)',
      'Relative clauses with the right pronoun case',
      'Justification connectors with correct word order',
    ],
    scoringCriteria: [
      'correct Präteritum forms in free narration',
      'well-built passive sentences',
      'relative pronoun cases',
      'connector word order (deshalb, nämlich)',
    ],
    priorityErrors: [
      'wrong or weak Präteritum forms',
      'broken passive construction',
      'relative pronoun in the wrong case',
    ],
    intro:
        'Everything M6 taught in one sitting: strong-verb Präteritum for '
        'stories, werden-passive for processes, case-correct relative '
        'clauses for people, and deshalb/nämlich with their strict word '
        'order for reasons.',
    tips: [
      HelpMemoryTip(
        kind: 'rule',
        title: 'The four gears of M6',
        text:
            'Stories run on **Präteritum** (ging, kam, war), processes on '
            '**wird/wurde + Partizip II**, people on **der/die/den/dem** '
            'clauses, reasons on **deshalb** (verb next!) and **nämlich** '
            '(after the verb). Hear the task, pick the gear.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'The three classic exam slips',
        text:
            'Weak endings on strong verbs (*gehte* → **ging**), ist '
            'instead of **wurde** in the passive, and „deshalb ich…" '
            'instead of „deshalb **blieb** ich…". Fix these three and '
            'your score jumps.',
      ),
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Shift before you speak',
        text:
            'Each task wants its own grammar — hear the task type, shift '
            'the gear FIRST, then speak. One silent second of gear choice '
            'saves ten seconds of self-repair.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'When I saw the man who was shouting, I called the police.',
        text:
            '**Als** ich den Mann sah, **der** laut rief, rief ich sofort '
            'die Polizei.',
      ),
    ],
  ),
];
