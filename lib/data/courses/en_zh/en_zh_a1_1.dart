import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// A1.1 — First Sounds & Tones · 声调入门 (HSK 1a). English → Mandarin.
///
/// Big rocks: the four tones (Z1) and tone sandhi (Z2), pinyin's tricky
/// letters (Z3/Z4), 是 linking nouns only (Z10 preview), questions that move
/// nothing (Z12), and characters entered through radicals (Z7). Named bridge:
/// no conjugation, no plurals, no gender — say it once, it never changes (Z9).

final QuizContent enZhA11Tones = enZhSpeak(
  id: 'en_zh_a1_1_tones',
  title: 'The four tones',
  intro:
      'In Mandarin, pitch is part of the word: mā, má, mǎ and mà are four '
      'different words. Listen and copy the melody exactly — the tone matters '
      'as much as the letters.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Tone gestures',
      text: '1st = sing it flat and high (a doctor\'s "aaah"). 2nd = rising '
          '"huh?". 3rd = a low, skeptical dip ("we-ell…"). 4th = a sharp '
          '"No!". Say the gesture, and the tone follows.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Tones are not optional (Z1)',
      text: 'English uses pitch for attitude; Mandarin uses it for identity. '
          '买 mǎi = buy, 卖 mài = sell — get the tone wrong and you say the '
          'opposite word.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'mā má mǎ mà — mother · hemp · horse · scold',
      answer: '妈，麻，马，骂',
    ),
    CourseItem(
      prompt: '1st tone (high & flat): mā gāo tiān sān',
      answer: '妈，高，天，三',
    ),
    CourseItem(
      prompt: '2nd tone (rising "huh?"): rén lái máng shéi',
      answer: '人，来，忙，谁',
    ),
    CourseItem(
      prompt: '3rd tone (the low dip): mǎ hǎo wǒ nǐ',
      answer: '马，好，我，你',
    ),
    CourseItem(
      prompt: '4th tone (sharp fall "No!"): mà shì qù dà',
      answer: '骂，是，去，大',
    ),
    CourseItem(
      prompt: 'Neutral tone (the 2nd syllable relaxes): māma xièxie wǒmen',
      answer: '妈妈，谢谢，我们',
    ),
    CourseItem(
      prompt: 'Māma mà mǎ. — Mum scolds the horse. (All one sound, mā-ma-mà-mǎ!)',
      answer: '妈妈骂马。',
    ),
  ],
);

final QuizContent enZhA11Pinyin = enZhSpeak(
  id: 'en_zh_a1_1_pinyin',
  title: 'Pinyin: the tricky letters',
  intro:
      'Pinyin uses the letters you know, but a few carry different sounds. '
      'Learn only where pinyin differs from English — the rest is free.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Don\'t read pinyin as English (Z3)',
      text: 'c = "ts" (cats), q = "ch" with a smile, x = soft "sh" with a '
          'smile, z = "ds" (kids), zh/ch/sh/r = tongue curled back. '
          '"Cài" is tsài, never "kai".',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'b d g: a puff of air, not a voice (Z4)',
      text: 'Mandarin b/d/g are gentle, unvoiced p/t/k; p/t/k add a strong '
          'puff of air. The contrast is the puff — bā vs pā.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'c = "ts": cài cǎo — vegetable, grass', answer: '菜，草'),
    CourseItem(prompt: 'q = "ch" + smile: qī qǐng qù — seven, please, go', answer: '七，请，去'),
    CourseItem(prompt: 'x = soft "sh" + smile: xièxie xiǎo xī — thanks, small, west', answer: '谢谢，小，西'),
    CourseItem(prompt: 'zh/ch/sh = tongue curled back: Zhōngguó chī shì', answer: '中国，吃，是'),
    CourseItem(prompt: 'r = a buzzy r, no lip rounding: rén rè Rìběn', answer: '人，热，日本'),
    CourseItem(prompt: 'z = "ds": zàijiàn zuò — goodbye, sit', answer: '再见，坐'),
    CourseItem(prompt: 'b vs p — the puff of air: bàba pà — dad, fear', answer: '爸爸，怕'),
    CourseItem(prompt: 'ü = say "ee", round your lips: nǚ lǜ qù — woman, green, go', answer: '女，绿，去'),
  ],
);

final QuizContent enZhA11Greetings = enZhFill(
  id: 'en_zh_a1_1_greetings',
  title: 'Greetings & courtesy',
  intro:
      'Your first working Chinese: hello, thanks, sorry, goodbye. Type the '
      'characters with a pinyin keyboard — or answer in pinyin.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hanzi or pinyin — both count',
      text: 'You can type 你好 or "ni hao" (tone marks optional). Long-term, '
          'let your pinyin keyboard suggest the characters — choosing the '
          'right one is real reading practice.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '不客气 answers 谢谢',
      text: '谢谢 (thanks) → 不客气 (you\'re welcome). 对不起 (sorry) → 没关系 '
          '(no problem). Learn them as ping-pong pairs.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'hello', answer: '你好', accepted: ['nǐ hǎo'], hint: 'nǐ hǎo'),
    CourseItem(prompt: 'goodbye', answer: '再见', accepted: ['zàijiàn'], hint: 'zàijiàn'),
    CourseItem(prompt: 'thank you', answer: '谢谢', accepted: ['xièxie'], hint: 'xièxie'),
    CourseItem(prompt: 'you\'re welcome', answer: '不客气', accepted: ['bú kèqi', 'bu keqi'], hint: 'bú kèqi'),
    CourseItem(prompt: 'sorry', answer: '对不起', accepted: ['duìbuqǐ'], hint: 'duìbuqǐ'),
    CourseItem(prompt: 'no problem / it doesn\'t matter', answer: '没关系', accepted: ['méi guānxi'], hint: 'méi guānxi'),
    CourseItem(prompt: 'please', answer: '请', accepted: ['qǐng'], hint: 'qǐng'),
  ],
);

final QuizContent enZhA11Pronouns = enZhFill(
  id: 'en_zh_a1_1_pronouns',
  title: 'Pronouns 我 / 你 / 他 / 她',
  intro:
      'The people words. Good news: they never change form — no "I/me/my" '
      'gymnastics. 们 turns people-words plural.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The 们 plural',
      text: '我 I → 我们 we; 你 you → 你们 you all; 他 he → 他们 they. 们 works '
          'on people only — nouns themselves have no plural at all (Z9).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '他 and 她 sound the same',
      text: 'Both are tā. In speech, gender comes for free — only writing '
          'distinguishes 他 (he) from 她 (she).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I / me', answer: '我', accepted: ['wǒ'], hint: 'wǒ'),
    CourseItem(prompt: 'you', answer: '你', accepted: ['nǐ'], hint: 'nǐ'),
    CourseItem(prompt: 'he / him', answer: '他', accepted: ['tā'], hint: 'tā'),
    CourseItem(prompt: 'she / her', answer: '她', accepted: ['tā'], hint: 'tā'),
    CourseItem(prompt: 'we / us', answer: '我们', accepted: ['wǒmen'], hint: 'wǒmen'),
    CourseItem(prompt: 'you (plural)', answer: '你们', accepted: ['nǐmen'], hint: 'nǐmen'),
    CourseItem(prompt: 'they / them', answer: '他们', accepted: ['tāmen'], hint: 'tāmen'),
  ],
);

final QuizContent enZhA11Shi = enZhFill(
  id: 'en_zh_a1_1_shi',
  title: '是 — linking nouns (only!)',
  intro:
      '是 shì is "to be" between two nouns: 我是学生 — I am a student. It never '
      'changes form (no am/is/are!), and note: no "a/an" needed either.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'One form, forever',
      text: '我是, 你是, 他是, 我们是 — all just 是. No conjugation exists in '
          'Chinese (Z9). Negate with 不: 我不是老师.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 是 links NOUNS only (Z10 preview)',
      text: 'She is tall = 她很高 — no 是! Adjectives work like verbs in '
          'Chinese. 是 + adjective (她是高 ✗) is the classic English-speaker '
          'error. The next module drills this.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am a student.', answer: '我**是**学生。', accepted: ['shì'], hint: 'wǒ shì xuésheng'),
    CourseItem(prompt: 'He is Chinese.', answer: '他**是**中国人。', accepted: ['shì'], hint: 'tā shì Zhōngguó rén'),
    CourseItem(prompt: 'She is my friend.', answer: '她**是**我的朋友。', accepted: ['shì'], hint: 'tā shì wǒ de péngyou'),
    CourseItem(prompt: 'I am NOT a teacher.', answer: '我**不是**老师。', accepted: ['bú shì', 'bu shi'], hint: 'wǒ bú shì lǎoshī'),
    CourseItem(prompt: 'This is tea.', answer: '这**是**茶。', accepted: ['shì'], hint: 'zhè shì chá'),
    CourseItem(prompt: 'They are students. (no plural, no "are"!)', answer: '他们**是**学生。', accepted: ['shì'], hint: 'tāmen shì xuésheng'),
  ],
);

final QuizContent enZhA11Numbers = enZhFill(
  id: 'en_zh_a1_1_numbers',
  title: 'Numbers 0–99: the Lego system',
  intro:
      'Learn ten characters and you can count to 99: eleven is "ten-one" '
      '(十一), twenty-two is "two-ten-two" (二十二). It\'s arithmetic, not '
      'memorization.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Lego numbers',
      text: '11 = 十一 (10+1), 20 = 二十 (2×10), 35 = 三十五 (3×10+5). Every '
          'number to 99 is built from 一 to 十 — compare English\'s eleven, '
          'twelve, twenty…',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 二 vs 两',
      text: 'Counting uses 二 (èr): 一, 二, 三. But "two of something" uses '
          '两 (liǎng): 两百 two hundred, and later 两个人 two people.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'three', answer: '三', accepted: ['sān'], hint: 'sān'),
    CourseItem(prompt: 'seven', answer: '七', accepted: ['qī'], hint: 'qī'),
    CourseItem(prompt: 'nine', answer: '九', accepted: ['jiǔ'], hint: 'jiǔ'),
    CourseItem(prompt: 'ten', answer: '十', accepted: ['shí'], hint: 'shí'),
    CourseItem(prompt: 'eleven (ten-one)', answer: '十一', accepted: ['shí yī', 'shíyī'], hint: 'shí yī'),
    CourseItem(prompt: 'twenty-two (two-ten-two)', answer: '二十二', accepted: ['èr shí èr', 'èrshí\'èr'], hint: 'èr shí èr'),
    CourseItem(prompt: 'thirty-five', answer: '三十五', accepted: ['sān shí wǔ'], hint: 'sān shí wǔ'),
    CourseItem(prompt: 'ninety-nine', answer: '九十九', accepted: ['jiǔ shí jiǔ'], hint: 'jiǔ shí jiǔ'),
  ],
);

final QuizContent enZhA11SpeakIntro = enZhSpeak(
  id: 'en_zh_a1_1_speak_intro',
  title: 'Speaking: introduce yourself',
  intro: 'Your first conversation — listen and repeat, copying the tones.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Copy the melody, not just the sounds',
      text: 'Shadow the voice: hum the pitch pattern first, then add the '
          'consonants and vowels. Tone is half the word (Z1).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Nǐ hǎo! — Hello!', answer: '你好！'),
    CourseItem(prompt: 'Wǒ jiào Tāngmǔ. — My name is Tom.', answer: '我叫汤姆。'),
    CourseItem(prompt: 'Wǒ shì Yīngguó rén. — I\'m British.', answer: '我是英国人。'),
    CourseItem(prompt: 'Nǐ jiào shénme míngzi? — What\'s your name?', answer: '你叫什么名字？'),
    CourseItem(prompt: 'Hěn gāoxìng rènshi nǐ. — Nice to meet you.', answer: '很高兴认识你。'),
    CourseItem(prompt: 'Nǐ hǎo ma? — How are you?', answer: '你好吗？'),
    CourseItem(prompt: 'Wǒ hěn hǎo, xièxie. — I\'m fine, thanks.', answer: '我很好，谢谢。'),
  ],
);

final QuizContent enZhA11Ma = enZhFill(
  id: 'en_zh_a1_1_ma',
  title: 'Questions: 吗 and 呢',
  intro:
      'To ask a yes/no question, say the statement and add 吗 — nothing moves, '
      'nothing inverts. 呢 bounces a question back: 你呢? — and you?',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Statement + 吗 = question (Z12)',
      text: '你是学生。You are a student. → 你是学生吗？Are you a student? '
          'No inversion, no "do" — Chinese questions leave the sentence '
          'untouched.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '呢 = "and…?"',
      text: '我很好，你呢？ I\'m fine — and you? 呢 recycles the whole previous '
          'question in one syllable.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Are you a student?', answer: '你是学生**吗**？', accepted: ['ma'], hint: 'nǐ shì xuésheng ma'),
    CourseItem(prompt: 'Is he Chinese?', answer: '他是中国人**吗**？', accepted: ['ma'], hint: 'tā shì Zhōngguó rén ma'),
    CourseItem(prompt: 'How about you? (And you?)', answer: '你**呢**？', accepted: ['ne'], hint: 'nǐ ne'),
    CourseItem(prompt: 'Are you well?', answer: '你好**吗**？', accepted: ['ma'], hint: 'nǐ hǎo ma'),
    CourseItem(prompt: 'Is she your friend?', answer: '她是你的朋友**吗**？', accepted: ['ma'], hint: 'tā shì nǐ de péngyou ma'),
    CourseItem(prompt: 'And your mum?', answer: '你妈妈**呢**？', accepted: ['ne'], hint: 'nǐ māma ne'),
  ],
);

final QuizContent enZhA11ListenHello = enZhListen(
  id: 'en_zh_a1_1_listen_hello',
  title: 'Listening: 你好!',
  passageTitle: '小美的自我介绍',
  passage: '你好！我叫小美。我是中国人，我是学生。你呢？你叫什么名字？很高兴认识你！',
  passageTranslation:
      'Nǐ hǎo! Wǒ jiào Xiǎoměi. Wǒ shì Zhōngguó rén, wǒ shì xuésheng. Nǐ ne? '
      'Nǐ jiào shénme míngzi? Hěn gāoxìng rènshi nǐ!\n\n'
      'Hello! My name is Xiaomei. I\'m Chinese, and I\'m a student. And you? '
      'What\'s your name? Nice to meet you!',
  intro:
      'The script stays hidden — listen first, then answer. Play it as often '
      'as you like.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Catch the anchors',
      text: 'Listen for 叫 (called), 是…人 (nationality) and 学生 (student) — '
          'those three anchors answer everything here.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '她叫什么名字？',
      options: ['小美', '汤姆', '安娜'],
      correctIndex: 0,
      questionTranslation: 'What is her name?',
    ),
    ReadingQuestion(
      question: '小美是哪国人？',
      options: ['中国人', '英国人', '美国人'],
      correctIndex: 0,
      questionTranslation: 'What nationality is Xiaomei?',
    ),
    ReadingQuestion(
      question: '小美是学生吗？',
      options: ['是', '不是'],
      correctIndex: 0,
      questionTranslation: 'Is Xiaomei a student?',
    ),
  ],
);

final QuizContent enZhA11Names = enZhFill(
  id: 'en_zh_a1_1_names',
  title: 'Names & countries: 叫 / 姓 / …人',
  intro:
      '叫 jiào = to be called (given name), 姓 xìng = to be surnamed. '
      'Nationality is country + 人: 中国人 = China-person.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Country + 人 = nationality',
      text: '中国 China → 中国人 Chinese. 英国 Britain → 英国人 British. One '
          'pattern, every nationality — no -ish/-ese/-an endings to memorize.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Surname first',
      text: 'Chinese names put the family name first: 王小美 is Ms. WANG '
          'Xiaomei. Teachers are Surname + 老师: 王老师.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'My name is Tom. (given name)', answer: '我**叫**汤姆。', accepted: ['jiào'], hint: 'wǒ jiào Tāngmǔ'),
    CourseItem(prompt: 'My surname is Wang.', answer: '我**姓**王。', accepted: ['xìng'], hint: 'wǒ xìng Wáng'),
    CourseItem(prompt: 'I am British. (Britain-person)', answer: '我是**英国人**。', accepted: ['Yīngguó rén', 'yingguoren'], hint: 'wǒ shì Yīngguó rén'),
    CourseItem(prompt: 'He is American.', answer: '他是**美国人**。', accepted: ['Měiguó rén', 'meiguoren'], hint: 'tā shì Měiguó rén'),
    CourseItem(prompt: 'She is Chinese.', answer: '她是**中国人**。', accepted: ['Zhōngguó rén', 'zhongguoren'], hint: 'tā shì Zhōngguó rén'),
    CourseItem(prompt: 'I am called Anna.', answer: '我**叫**安娜。', accepted: ['jiào'], hint: 'wǒ jiào Ānnà'),
  ],
);

final QuizContent enZhA11ReadTom = enZhRead(
  id: 'en_zh_a1_1_read_tom',
  title: 'Reading: 我叫汤姆',
  passageTitle: '我叫汤姆',
  passage:
      '你好！我叫汤姆，我是英国人。我是学生，我学习中文。我的老师姓王，'
      '她是中国人。王老师很好。很高兴认识你！',
  passageTranslation:
      'Nǐ hǎo! Wǒ jiào Tāngmǔ, wǒ shì Yīngguó rén. Wǒ shì xuésheng, wǒ xuéxí '
      'Zhōngwén. Wǒ de lǎoshī xìng Wáng, tā shì Zhōngguó rén. Wáng lǎoshī hěn '
      'hǎo. Hěn gāoxìng rènshi nǐ!\n\n'
      'Hello! My name is Tom, and I\'m British. I\'m a student and I study '
      'Chinese. My teacher\'s surname is Wang; she\'s Chinese. Teacher Wang is '
      'very nice. Nice to meet you!',
  intro:
      'Your first Chinese text — meet Tom, the course\'s hero. Read the '
      'characters first; pinyin and English wait behind the info button.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Read for shapes you know',
      text: 'You already know 我, 是, 人, 好. Anchor on familiar characters '
          'and guess the rest from context — that\'s real Chinese reading.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆是哪国人？',
      options: ['英国人', '中国人', '美国人'],
      correctIndex: 0,
      questionTranslation: 'What nationality is Tom?',
    ),
    ReadingQuestion(
      question: '汤姆学习什么？',
      options: ['中文', '英文'],
      correctIndex: 0,
      questionTranslation: 'What does Tom study?',
    ),
    ReadingQuestion(
      question: '汤姆的老师姓什么？',
      options: ['王', '李', '张'],
      correctIndex: 0,
      questionTranslation: 'What is Tom\'s teacher\'s surname?',
    ),
  ],
);

final QuizContent enZhA11TonePairs = enZhSpeak(
  id: 'en_zh_a1_1_tone_pairs',
  title: 'Tone pairs & the 你好 rule',
  intro:
      'Real words come in tone pairs — and one pair changes: two 3rd tones in '
      'a row can\'t both dip, so the first one rises. 你好 is really ní hǎo.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Two dips can\'t dance (Z2)',
      text: '3rd + 3rd → 2nd + 3rd. 你好 nǐ hǎo → ní hǎo, 很好 hěn hǎo → hén '
          'hǎo. Pinyin still writes the original tones — your mouth makes the '
          'switch.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Drill in pairs',
      text: 'Words live as two-syllable teams. Practicing pairs (1+2, 2+4, '
          '3+3…) trains your ear faster than single syllables.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'nǐ hǎo → say "ní hǎo" — hello', answer: '你好'),
    CourseItem(prompt: 'hěn hǎo → say "hén hǎo" — very good', answer: '很好'),
    CourseItem(prompt: 'wǒ yě hěn hǎo — I\'m fine too (a sandhi chain!)', answer: '我也很好。'),
    CourseItem(prompt: '1st + 1st: fēijī — airplane', answer: '飞机'),
    CourseItem(prompt: '3rd + 1st, no change: lǎoshī — teacher', answer: '老师'),
    CourseItem(prompt: '4th + 4th: zàijiàn — goodbye', answer: '再见'),
    CourseItem(prompt: '1st + 2nd: Zhōngguó — China', answer: '中国'),
  ],
);

final QuizContent enZhA11Hanzi = enZhFill(
  id: 'en_zh_a1_1_hanzi',
  title: 'Characters: your first radicals',
  intro:
      'Characters aren\'t random pictures — they\'re built from parts. These '
      'eight parts (radicals) return inside hundreds of characters as meaning '
      'hints.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Meaning left, sound right (Z7)',
      text: 'About 80% of characters pair a meaning part with a sound part: '
          '妈 mā = 女 (woman, the meaning) + 马 mǎ (the sound). Learn '
          'components, not strokes.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Characters compose',
      text: '好 (good) = 女 woman + 子 child. 明 (bright) = 日 sun + 月 moon. '
          'Every character you learn makes the next one cheaper.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'person (two walking legs)', answer: '人', accepted: ['rén'], hint: 'rén'),
    CourseItem(prompt: 'mouth (an open box)', answer: '口', accepted: ['kǒu'], hint: 'kǒu'),
    CourseItem(prompt: 'sun / day', answer: '日', accepted: ['rì'], hint: 'rì'),
    CourseItem(prompt: 'moon / month', answer: '月', accepted: ['yuè'], hint: 'yuè'),
    CourseItem(prompt: 'water', answer: '水', accepted: ['shuǐ'], hint: 'shuǐ'),
    CourseItem(prompt: 'tree / wood', answer: '木', accepted: ['mù'], hint: 'mù'),
    CourseItem(prompt: 'woman', answer: '女', accepted: ['nǚ'], hint: 'nǚ'),
    CourseItem(prompt: 'fire', answer: '火', accepted: ['huǒ'], hint: 'huǒ'),
  ],
);

final QuizContent enZhA11DictHello = enZhDict(
  id: 'en_zh_a1_1_dict_hello',
  title: 'Dictation: first sentences',
  intro:
      'Listen and type what you hear. Switch your keyboard to Chinese (pinyin '
      'IME): type the pinyin, then pick the right characters — that\'s exactly '
      'how the HSK writing paper works.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Type pinyin, pick the character',
      text: 'On any phone or computer, add the Chinese (Simplified) pinyin '
          'keyboard. Typing "nihao" offers 你好 — choosing the right hanzi IS '
          'the writing skill.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Trust the tones you hear',
      text: 'The IME shows homophones: typing "shi" offers 是/十/时… Let the '
          'tone and context you heard guide the choice.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hello!', answer: '你好！'),
    CourseItem(prompt: 'My name is Anna.', answer: '我叫安娜。'),
    CourseItem(prompt: 'I am British.', answer: '我是英国人。'),
    CourseItem(prompt: 'Thank you!', answer: '谢谢！'),
    CourseItem(prompt: 'Goodbye!', answer: '再见！'),
    CourseItem(prompt: 'Are you a student?', answer: '你是学生吗？'),
  ],
);

final QuizContent enZhA11WhatWho = enZhFill(
  id: 'en_zh_a1_1_what_who',
  title: 'Question words 什么 / 谁',
  intro:
      '什么 = what, 谁 = who. The question word sits exactly where the answer '
      'will sit — nothing moves to the front.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ The question word stays put (Z12)',
      text: 'English fronts "what": WHAT do you buy? Chinese keeps it in the '
          'answer\'s slot: 你买**什么**？(you buy WHAT?). Answer: 你买茶 — '
          'same shape.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Swap-in trick',
      text: 'Take the answer sentence and swap the unknown for 什么/谁: '
          '她是我的老师 → 她是**谁**？',
    ),
  ],
  items: const [
    CourseItem(prompt: 'What\'s your name?', answer: '你叫**什么**名字？', accepted: ['shénme'], hint: 'nǐ jiào shénme míngzi'),
    CourseItem(prompt: 'Who is she?', answer: '她是**谁**？', accepted: ['shéi', 'shuí'], hint: 'tā shì shéi'),
    CourseItem(prompt: 'What is this?', answer: '这是**什么**？', accepted: ['shénme'], hint: 'zhè shì shénme'),
    CourseItem(prompt: 'Who is your teacher?', answer: '你的老师是**谁**？', accepted: ['shéi', 'shuí'], hint: 'nǐ de lǎoshī shì shéi'),
    CourseItem(prompt: 'What is that?', answer: '那是**什么**？', accepted: ['shénme'], hint: 'nà shì shénme'),
    CourseItem(prompt: 'Who is he?', answer: '他是**谁**？', accepted: ['shéi', 'shuí'], hint: 'tā shì shéi'),
  ],
);

/// A1.1 in chain order (interleaved sound / knowledge / listening / reading /
/// dictation, ≤ 2 knowledge quizzes in a row).
final List<QuizContent> enZhA1_1 = [
  enZhA11Tones,
  enZhA11Pinyin,
  enZhA11Greetings,
  enZhA11Pronouns,
  enZhA11Shi,
  enZhA11Numbers,
  enZhA11SpeakIntro,
  enZhA11Ma,
  enZhA11ListenHello,
  enZhA11Names,
  enZhA11ReadTom,
  enZhA11TonePairs,
  enZhA11Hanzi,
  enZhA11DictHello,
  enZhA11WhatWho,
];
