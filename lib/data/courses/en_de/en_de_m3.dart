import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M3 — The Accusative. Theme: **Mio, das hungrige Monster** — a little monster
/// that eats the whole house. The verbs *fressen / essen / sehen / haben /
/// möchte* force every object into the accusative, so the joke and the grammar
/// are the same thing. One example world (Mio, Tom, the house) feeds all seven
/// quizzes. Source: docs/en_de/m3_accusative.md.

/// The shared accusative teaching, reused as the Help Memory across the module.
const List<HelpMemoryTip> _accusativeTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Only the masculine moves',
    text: 'Accusative = the direct object (Wen?/Was?). Only the masculine '
        'changes: der → **den**, ein → **einen**. **die** (f), **das** (n) and '
        'plural **die** stay identical.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'den for the masculi-n-e',
    text: 'The extra **-n** marks the masculine accusative: de**n**, eine**n**, '
        'ih**n**, kei**n**en.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Accusative pronouns',
    text: 'ich → **mich**, du → **dich**, er → **ihn**, sie → **sie**, es → '
        '**es**, wir → **uns**, ihr → **euch**, Sie → **Sie**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'See the contrast',
    text: 'Mio frisst **den** Tisch (m) — but **die** Lampe (f) and **das** Sofa '
        "(n) don't change at all.",
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'These always take accusative',
    text: '**durch, für, gegen, ohne, um** force the accusative every time — no '
        'motion rule, no exceptions.',
  ),
];

// 3.1 — accusative articles (only der → den). Each cue gives the nominative
// (der/die/das), the learner produces the accusative.
final QuizContent enDeM3Artikel = enDeFill(
  id: 'en_de_m3_artikel',
  title: 'Accusative articles',
  intro: 'The accusative is the direct object — the thing the action happens '
      'to (ask Wen? / Was?). Only the masculine article changes: der → den. '
      "Watch how die and das don't move.",
  tips: _accusativeTips,
  items: const [
    CourseItem(prompt: 'Mio eats the table. (der Tisch)', answer: 'Mio frisst **den** Tisch'),
    CourseItem(prompt: 'Mio eats the chair. (der Stuhl)', answer: 'Mio frisst **den** Stuhl'),
    CourseItem(prompt: 'Mio eats the lamp. (die Lampe)', answer: 'Mio frisst **die** Lampe'),
    CourseItem(prompt: 'Mio eats the banana. (die Banane)', answer: 'Mio frisst **die** Banane'),
    CourseItem(prompt: 'Mio eats the sofa. (das Sofa)', answer: 'Mio frisst **das** Sofa'),
    CourseItem(prompt: 'Mio eats the bed. (das Bett)', answer: 'Mio frisst **das** Bett'),
    CourseItem(prompt: 'Mio eats the shoes. (die Schuhe, pl)', answer: 'Mio frisst **die** Schuhe'),
    CourseItem(prompt: 'Mio eats the homework. (die Hausaufgaben, pl)', answer: 'Mio frisst **die** Hausaufgaben'),
  ],
);

// 3.2 — haben / möchte / essen + accusative (der/ein → den/einen).
final QuizContent enDeM3Haben = enDeFill(
  id: 'en_de_m3_haben',
  title: 'haben & möchte + accusative',
  intro: 'Verbs like haben, möchte, essen and kaufen take a direct object, so '
      'their object is accusative. The indefinite article changes the same way: '
      'ein → einen (only the masculine).',
  tips: _accusativeTips,
  items: const [
    CourseItem(prompt: 'Mio is so hungry. (der Hunger)', answer: 'Mio hat **einen** Hunger'),
    CourseItem(prompt: 'Mio wants a pizza. (die Pizza)', answer: 'Mio möchte **eine** Pizza'),
    CourseItem(prompt: 'Mio eats the chair. (der Stuhl)', answer: 'Mio frisst **den** Stuhl'),
    CourseItem(prompt: 'Mio eats the bread. (das Brot)', answer: 'Mio isst **das** Brot'),
    CourseItem(prompt: 'Mio buys an apple. (der Apfel)', answer: 'Mio kauft **einen** Apfel'),
    CourseItem(prompt: 'Mio sees the cake. (der Kuchen)', answer: 'Mio sieht **den** Kuchen'),
  ],
);

// 3.2a — warm-up big text (after the article quizzes): type the accusative
// article for each object Mio devours. der → den; die/das stay the same.
final QuizContent enDeM3BigTextWarmup = enDeBigText(
  id: 'en_de_m3_bigtext_warmup',
  title: 'Big text (warm-up): Mio beim Frühstück',
  passageTitle: 'Mio beim Frühstück',
  template:
      'Mio hat schon wieder Hunger! Zum Frühstück frisst Mio zuerst {{0}} Tisch, '
      'dann {{1}} Lampe und sogar {{2}} alte Sofa. „Noch nicht satt!", brummt '
      'es. Schnell nimmt Mio {{3}} Stuhl aus der Küche, {{4}} Banane von Tom und '
      'zum Schluss {{5}} Brot. Nur {{6}} Apfel auf dem Fenster bleibt übrig — '
      'aber nur, weil Mio ihn noch nicht gesehen hat.',
  blanks: [
    inputBlank('den', hint: 'der Tisch → Akkusativ'),
    inputBlank('die', hint: 'die Lampe → Akkusativ'),
    inputBlank('das', hint: 'das Sofa → Akkusativ'),
    inputBlank('den', hint: 'der Stuhl → Akkusativ'),
    inputBlank('die', hint: 'die Banane → Akkusativ'),
    inputBlank('das', hint: 'das Brot → Akkusativ'),
    inputBlank('den', hint: 'der Apfel → Akkusativ'),
  ],
  passageTranslation:
      'Mio is hungry yet again! For breakfast Mio first eats the table, then the '
      'lamp, and even the old sofa. "Still not full!" it growls. Quickly Mio '
      "grabs the chair from the kitchen, Tom's banana, and finally the bread. "
      'Only the apple on the windowsill is left over — but only because Mio '
      "hasn't spotted it yet.",
  intro: 'Type the accusative article for each thing Mio devours. Remember: only '
      'the masculine changes (der → den); die and das stay exactly the same.',
  tips: _accusativeTips,
);

// 3.3 — accusative pronouns (ich → mich, du → dich, er → ihn …).
final QuizContent enDeM3Pronomen = enDeFill(
  id: 'en_de_m3_pronomen',
  title: 'Accusative pronouns',
  intro: 'Pronouns take accusative forms when they are the object. The big one '
      'to remember is er → ihn (just like der → den, the masculine grows an -n).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The accusative pronouns',
      text: 'ich→mich, du→dich, er→ihn, sie→sie, es→es, wir→uns, ihr→euch, '
          'Sie→Sie.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'er → ih-n',
      text: 'Like der → den, the masculine pronoun gains an -n: er → ihn.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'In the story',
      text: 'Mio hört ihn nicht — "Mio doesn\'t hear him."',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The monster sees me. (ich)', answer: 'Das Monster sieht **mich**'),
    CourseItem(prompt: 'The monster sees you. (du)', answer: 'Das Monster sieht **dich**'),
    CourseItem(prompt: 'The monster sees him. (er)', answer: 'Das Monster sieht **ihn**'),
    CourseItem(prompt: 'The monster sees her. (sie)', answer: 'Das Monster sieht **sie**'),
    CourseItem(prompt: 'The monster sees it. (es)', answer: 'Das Monster sieht **es**'),
    CourseItem(prompt: 'The monster sees us. (wir)', answer: 'Das Monster sieht **uns**'),
    CourseItem(prompt: 'The monster sees you all. (ihr)', answer: 'Das Monster sieht **euch**'),
    CourseItem(prompt: 'The monster sees you. (formal, Sie)', answer: 'Das Monster sieht **Sie**'),
  ],
);

// 3.4 — accusative prepositions (durch, für, gegen, ohne, um).
final QuizContent enDeM3Praepositionen = enDeFill(
  id: 'en_de_m3_praepositionen',
  title: 'Accusative prepositions',
  intro: 'Five prepositions always force the accusative: durch, für, gegen, '
      'ohne, um. The preposition decides the case — no thinking required.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The "DOGFU" five',
      text: 'durch, ohne, gegen, für, um — always followed by the accusative.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'The contrast still holds',
      text: 'durch den Garten (m → den) but für die Katze (f, unchanged).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Even without motion',
      text: 'These five are accusative no matter what — unlike the two-way '
          'prepositions you meet later.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Mio runs through the garden. (der Garten)', answer: 'Mio rennt durch **den** Garten'),
    CourseItem(prompt: 'Mio runs into the tree. (der Baum)', answer: 'Mio läuft gegen **den** Baum'),
    CourseItem(prompt: 'Mio dances around the table. (der Tisch)', answer: 'Mio tanzt um **den** Tisch'),
    CourseItem(prompt: 'Mio never eats without the spoon. (der Löffel)', answer: 'Mio frisst nie ohne **den** Löffel'),
    CourseItem(prompt: 'Mio cooks a soup for the cat. (die Katze)', answer: 'Mio kocht eine Suppe für **die** Katze'),
  ],
);

// 3.5 — the big text: "Mios hungriger Tag". The inline "big text": at each
// marked phrase a dropdown picks the case. The doers (Mio, Tom) are Nominativ;
// everything Mio devours — and the object pronoun ihn, and den Garten after
// durch — is Akkusativ. den Tisch (m, changed) sits next to die Lampe / das
// Sofa (unchanged), so the contrast is right there in the text.
final QuizContent enDeM3Lesen = enDeBigText(
  id: 'en_de_m3_lesen',
  title: 'Big text: Mios hungriger Tag',
  passageTitle: 'Mios hungriger Tag',
  // Only about 60% of the case phrases are marked (the rest stay as prose) so
  // the story reads naturally. The marked spots mix the doer (Nominativ) with
  // the things Mio devours (Akkusativ) and a preposition case, and keep the
  // der→den contrast visible (den Tisch vs die Lampe).
  template:
      'Mio ist ein kleines, grünes Monster mit einem riesigen Bauch, und Mio '
      'hat immer Hunger — wirklich immer! Heute beginnt das Chaos schon am '
      'Morgen. Zum Frühstück frisst Mio den Tisch {{0}}, dann die Lampe {{1}} '
      'und sogar das alte Sofa. „Mmh, lecker!", brummt es zufrieden. Zum '
      'Mittagessen nimmt Mio die Banane von Tom, den Stuhl {{2}} aus der Küche '
      'und zum Nachtisch die Hausaufgaben — natürlich ohne ein einziges Wort '
      'der Entschuldigung. Da kommt Tom {{3}} nach Hause und sieht das Monster '
      '{{4}} mitten im Wohnzimmer. „Mio, nein! Nicht schon wieder!", ruft er '
      '{{5}} verzweifelt. Aber Mio hört ihn {{6}} überhaupt nicht. Es rülpst '
      'kurz, rennt durch den Garten {{7}}, springt über den Zaun und sucht '
      'schon das nächste Haus. Die armen Nachbarn ahnen noch nichts von ihrem '
      'Glück.',
  blanks: [
    caseBlank('Akkusativ'), // den Tisch (m → changed)
    caseBlank('Akkusativ'), // die Lampe (f → unchanged)
    caseBlank('Akkusativ'), // den Stuhl (m)
    caseBlank('Nominativ'), // Tom (the doer)
    caseBlank('Akkusativ'), // das Monster (object of sehen)
    caseBlank('Nominativ'), // er (the doer of rufen)
    caseBlank('Akkusativ'), // ihn (er → ihn)
    caseBlank('Akkusativ'), // den Garten (durch + Akk)
  ],
  passageTranslation:
      'Mio is a small, green monster with a huge belly, and Mio is always '
      'hungry — really always! Today the chaos begins first thing in the '
      'morning. For breakfast Mio eats the table, then the lamp, and even the '
      'old sofa. "Mmh, yummy!" it growls contentedly. For lunch Mio takes '
      "Tom's banana, the chair from the kitchen, and for dessert the homework "
      '— without a single word of apology, of course. Then Tom comes home and '
      'sees the monster in the middle of the living room. "Mio, no! Not '
      'again!" he shouts in despair. But Mio doesn\'t hear him at all. It burps '
      'briefly, runs through the garden, jumps over the fence, and is already '
      'looking for the next house. The poor neighbours have no idea how lucky '
      "they've been so far.",
  intro: 'Read the story and choose the case for each marked phrase. Only some '
      'phrases are marked. The doers (Tom, er) are Nominativ; everything Mio '
      'devours — and den Garten after durch — is Akkusativ.',
  tips: _accusativeTips,
);

// 3.6 — speak & repeat: "Mio im Restaurant".
final QuizContent enDeM3Sprechen = enDeSpeak(
  id: 'en_de_m3_sprechen',
  title: 'Speak: Mio im Restaurant',
  intro: 'Say each line aloud. Notice every order Mio places is an accusative '
      'object: einen Tisch, die Pizza, das Brot, einen Kuchen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen for the -n',
      text: 'einen Tisch / einen Kuchen — the masculine -n is the sound that '
          'marks the accusative.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'The joke',
      text: '"Ich möchte einen Tisch" — a table… to eat, not to sit at!',
    ),
  ],
  items: const [
    CourseItem(prompt: "Hello! I'd like a table.", answer: 'Guten Tag! Ich möchte einen Tisch.'),
    CourseItem(prompt: 'No, not to sit at — to eat!', answer: 'Nein, nicht zum Sitzen — zum Essen!'),
    CourseItem(prompt: "I'll take the pizza and the bread.", answer: 'Ich nehme die Pizza und das Brot.'),
    CourseItem(prompt: 'Do you have a cake?', answer: 'Haben Sie einen Kuchen?'),
    CourseItem(prompt: 'Thanks! I eat everything.', answer: 'Danke! Ich esse alles.'),
  ],
);

// 3.7 — dictation: der vs den by ear. The unstressed -n is the whole point.
final QuizContent enDeM3Diktat = enDeDict(
  id: 'en_de_m3_diktat',
  title: 'Dictation: der vs den by ear',
  intro: 'Listen and type each line. The masculine accusative -n (den, einen) '
      'is easy to miss by ear — train it here, next to the unchanging die/das.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Catch the -n',
      text: 'den (m) vs die/das — the only audible difference is that final -n. '
          'Listen for it.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Same world',
      text: 'These are the lines from Mio\'s hungry day — you have seen them '
          'written; now write what you hear.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Mio eats the table.', answer: 'Mio frisst den Tisch.'),
    CourseItem(prompt: 'Mio eats the lamp.', answer: 'Mio frisst die Lampe.'),
    CourseItem(prompt: 'Mio eats the sofa.', answer: 'Mio frisst das Sofa.'),
    CourseItem(prompt: 'Tom sees the monster.', answer: 'Tom sieht das Monster.'),
    CourseItem(prompt: 'Mio looks for an apple.', answer: 'Mio sucht einen Apfel.'),
  ],
);

/// M3 — The Accusative, in module order (forms → sentences → pronouns →
/// prepositions → reading → speaking → dictation).
final List<QuizContent> enDeM3 = [
  enDeM3Artikel,
  enDeM3Haben,
  enDeM3BigTextWarmup,
  enDeM3Pronomen,
  enDeM3Praepositionen,
  enDeM3Sprechen,
  enDeM3Diktat,
  enDeM3Lesen,
];
