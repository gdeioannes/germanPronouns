import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// B1.2 — Describing & Defining · 描述与定义 (HSK 3b). English → Mandarin.
///
/// Big rocks: relative clauses hang BEFORE the noun with 的 (Z19 — the parsing
/// flip), 是…的 spotlighting the details of past events (Z28), potential
/// complements V得/不C (Z21), and 如果…就 conditions (Z25). Reading strategy:
/// chunking characters into words (Z8).

final QuizContent enZhB12Relative1 = enZhFill(
  id: 'en_zh_b1_2_relative_1',
  title: 'The clause moves LEFT: V-的 + noun',
  intro:
      '"The book that I bought" flips in Chinese: 我买的书 — I-bought-的 book. '
      'The whole description parks before the noun, clipped on with 的.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Description first, noun last (Z19)',
      text: 'English: noun + that-clause. Chinese: clause + 的 + noun. '
          '喝咖啡的人 = the person who\'s drinking coffee — read up to 的, '
          'then meet the noun.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'No who/which/that',
      text: 'Chinese has no relative pronoun at all: the 的 does everything. '
          '我认识的老师 — the teacher (whom) I know.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'the book that I bought', answer: '我买**的**书', accepted: ['de'], hint: 'wǒ mǎi de shū'),
    CourseItem(prompt: 'the person who is drinking coffee', answer: '喝咖啡**的**人', accepted: ['de'], hint: 'hē kāfēi de rén'),
    CourseItem(prompt: 'the food (dish) that mum makes', answer: '妈妈做**的**菜', accepted: ['de'], hint: 'māma zuò de cài'),
    CourseItem(prompt: 'The book I bought is very interesting.', answer: '我买**的**书很有意思。', accepted: ['de'], hint: 'wǒ mǎi de shū hěn yǒuyìsi'),
    CourseItem(prompt: 'The person who speaks Chinese is my friend.', answer: '说中文**的**人是我的朋友。', accepted: ['de'], hint: 'shuō Zhōngwén de rén shì wǒ de péngyou'),
    CourseItem(prompt: 'the film we watched yesterday', answer: '我们昨天看**的**电影', accepted: ['de'], hint: 'wǒmen zuótiān kàn de diànyǐng'),
  ],
);

final QuizContent enZhB12Relative2 = enZhFill(
  id: 'en_zh_b1_2_relative_2',
  title: 'Longer 的-clauses',
  intro:
      'The 的-clause stretches: place, time and objects all ride along in '
      'front of the noun. Practice parsing from 的 backwards.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Find the 的, find the noun',
      text: 'In a long sentence, locate 的 + noun first, then read the '
          'description before it. 在北京工作的那个美国人 → that American / '
          'who works in Beijing.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'the American who works in Beijing', answer: '在北京工作**的**美国人', accepted: ['de'], hint: 'zài Běijīng gōngzuò de Měiguó rén'),
    CourseItem(prompt: 'the shirt I bought yesterday at the shop', answer: '我昨天在商店买**的**衬衫', accepted: ['de'], hint: 'wǒ zuótiān zài shāngdiàn mǎi de chènshān'),
    CourseItem(prompt: 'The tea my friend gave me is delicious. (给我 = gave me)', answer: '朋友给我**的**茶很好喝。', accepted: ['de'], hint: 'péngyou gěi wǒ de chá hěn hǎohē'),
    CourseItem(prompt: 'the students who are learning Chinese', answer: '学中文**的**学生', accepted: ['de'], hint: 'xué Zhōngwén de xuésheng'),
    CourseItem(prompt: 'Is the person who phoned you your teacher?', answer: '给你打电话**的**人是你的老师吗？', accepted: ['de'], hint: 'gěi nǐ dǎ diànhuà de rén shì nǐ de lǎoshī ma'),
  ],
);

final QuizContent enZhB12SpeakPeople = enZhSpeak(
  id: 'en_zh_b1_2_speak_people',
  title: 'Speaking: describing people',
  intro:
      'Describe people aloud — feel the description stacking up BEFORE the '
      'person it describes.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Build left, land right',
      text: 'Say the description as one breath and land on the noun: '
          '穿红衣服的//那个人. The noun is the finish line (Z19).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Chuān hóng yīfu de nà ge rén shì shéi? — Who\'s that person in red?', answer: '穿红衣服的那个人是谁？'),
    CourseItem(prompt: 'Tā shì wǒ zuì hǎo de péngyou. — She\'s my best friend.', answer: '她是我最好的朋友。'),
    CourseItem(prompt: 'Wǒ xǐhuan ài xiào de rén. — I like people who love to laugh.', answer: '我喜欢爱笑的人。'),
    CourseItem(prompt: 'Zuótiān lái de nà wèi lǎoshī hěn yǒumíng. — The teacher who came yesterday is famous.', answer: '昨天来的那位老师很有名。'),
    CourseItem(prompt: 'Zhè shì wǒ zài Zhōngguó pāi de zhàopiàn. — These are photos I took in China.', answer: '这是我在中国拍的照片。'),
  ],
);

final QuizContent enZhB12ShiDe = enZhFill(
  id: 'en_zh_b1_2_shi_de',
  title: '是…的 — spotlighting the details',
  intro:
      'For past events, 是…的 spotlights when/where/how: 我是昨天来的 — it was '
      'YESTERDAY that I came. The event is known; the detail is the news.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚠️ Known event, new detail (Z28)',
      text: 'Use 是…的 when the happening is old news and you\'re asking or '
          'telling the circumstance: 你是怎么来的? (HOW did you come?) — not '
          'plain 了, which reports the event itself.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'The frame',
      text: '是 + [spotlighted detail + verb] + 的: 她是在北京学的中文, '
          '我们是坐飞机来的.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'It was yesterday that I came.', answer: '我**是**昨天来**的**。', accepted: ['shì…de', 'shi de'], hint: 'wǒ shì zuótiān lái de'),
    CourseItem(prompt: 'How did you get here? (by what means)', answer: '你是**怎么**来的？', accepted: ['zěnme'], hint: 'nǐ shì zěnme lái de'),
    CourseItem(prompt: 'We came by plane. (sit-plane come)', answer: '我们是**坐飞机**来的。', accepted: ['zuò fēijī'], hint: 'wǒmen shì zuò fēijī lái de'),
    CourseItem(prompt: 'It was in Beijing that she learned Chinese.', answer: '她是**在北京**学的中文。', accepted: ['zài Běijīng'], hint: 'tā shì zài Běijīng xué de Zhōngwén'),
    CourseItem(prompt: 'Who bought this tea? (spotlight WHO)', answer: '这个茶是**谁**买的？', accepted: ['shéi', 'shuí'], hint: 'zhè ge chá shì shéi mǎi de'),
    CourseItem(prompt: 'It was last year that they got to know each other.', answer: '他们是**去年**认识的。', accepted: ['qùnián'], hint: 'tāmen shì qùnián rènshi de'),
  ],
);

final QuizContent enZhB12ListenShide = enZhListen(
  id: 'en_zh_b1_2_listen_shide',
  title: 'Listening: 他是什么时候来的?',
  passageTitle: '新同学',
  passage:
      '小美："我们班有一个新同学，你见过他吗？"\n'
      '汤姆："见过。他是上个月来的。"\n'
      '小美："他是从哪儿来的？"\n'
      '汤姆："他是从加拿大来的，是坐飞机来的。"\n'
      '小美："他的中文说得怎么样？"\n'
      '汤姆："说得非常好！他是在家跟妈妈学的——他妈妈是中国人。"',
  passageTranslation:
      'Xiǎoměi: "Wǒmen bān yǒu yí ge xīn tóngxué, nǐ jiàn guo tā ma?"\n'
      'Tāngmǔ: "Jiàn guo. Tā shì shàng ge yuè lái de."\n'
      'Xiǎoměi: "Tā shì cóng nǎr lái de?"\n'
      'Tāngmǔ: "Tā shì cóng Jiānádà lái de, shì zuò fēijī lái de."\n'
      'Xiǎoměi: "Tā de Zhōngwén shuō de zěnmeyàng?"\n'
      'Tāngmǔ: "Shuō de fēicháng hǎo! Tā shì zài jiā gēn māma xué de — tā '
      'māma shì Zhōngguó rén."\n\n'
      'Xiaomei: "There\'s a new classmate in our class — have you met him?"\n'
      'Tom: "I have. He came last month."\n'
      'Xiaomei: "Where is he from?"\n'
      'Tom: "He\'s from Canada — he came by plane."\n'
      'Xiaomei: "How\'s his Chinese?"\n'
      'Tom: "Excellent! He learned it at home with his mum — his mum is '
      'Chinese."',
  intro:
      'Every answer in this dialogue is a 是…的 spotlight: when, from where, '
      'how, with whom. Catch each detail.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '从…来 = come from',
      text: '从 (from) is a coverb: 从加拿大来 — from-Canada come. Another '
          'scene-setter that stands before the verb (Z29).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '新同学是什么时候来的？',
      options: ['上个月', '昨天', '去年'],
      correctIndex: 0,
      questionTranslation: 'When did the new classmate come?',
    ),
    ReadingQuestion(
      question: '他是从哪儿来的？',
      options: ['加拿大', '英国', '美国'],
      correctIndex: 0,
      questionTranslation: 'Where is he from?',
    ),
    ReadingQuestion(
      question: '他的中文是跟谁学的？',
      options: ['跟老师', '跟妈妈', '跟朋友'],
      correctIndex: 1,
      questionTranslation: 'Who did he learn Chinese with?',
    ),
  ],
);

final QuizContent enZhB12Ruguo = enZhFill(
  id: 'en_zh_b1_2_ruguo',
  title: 'If…then: 如果…就',
  intro:
      '如果 A，B 就… — if A, then B. The 就 sits inside the second clause, '
      'right before its verb: 如果下雨，我们就不去.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Another pair to keep (Z25)',
      text: '如果 opens the condition, 就 answers it. 就 is an adverb: it must '
          'stand before the verb, never before the subject — 就我们不去 ✗.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'No tense gymnastics',
      text: 'English shifts tenses ("if it rains… we would…"); Chinese '
          'conditions stay bare: 如果…就 handles real and hypothetical alike '
          '(Z9).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'If it rains, (then) we won\'t go.', answer: '如果下雨，我们**就**不去。', accepted: ['jiù'], hint: 'rúguǒ xià yǔ, wǒmen jiù bú qù'),
    CourseItem(prompt: 'If you have time, (then) come to my place.', answer: '**如果**你有时间，就来我家吧。', accepted: ['rúguǒ'], hint: 'rúguǒ nǐ yǒu shíjiān, jiù lái wǒ jiā ba'),
    CourseItem(prompt: 'If it\'s too expensive, (then) I won\'t buy it.', answer: '如果太贵，我**就**不买。', accepted: ['jiù'], hint: 'rúguǒ tài guì, wǒ jiù bù mǎi'),
    CourseItem(prompt: 'If you don\'t understand, (then) ask the teacher.', answer: '如果听不懂，**就**问老师。', accepted: ['jiù'], hint: 'rúguǒ tīng bu dǒng, jiù wèn lǎoshī'),
    CourseItem(prompt: 'If tomorrow\'s weather is good, we\'ll (then) go to the park.', answer: '**如果**明天天气好，我们就去公园。', accepted: ['rúguǒ'], hint: 'rúguǒ míngtiān tiānqì hǎo, wǒmen jiù qù gōngyuán'),
  ],
);

final QuizContent enZhB12YouYue = enZhFill(
  id: 'en_zh_b1_2_you_yue',
  title: '又…又 / 越来越 / 越…越',
  intro:
      'Three describing frames: 又 A 又 B (both A and B), 越来越 A (more and '
      'more A), 越 A 越 B (the more A, the more B).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Three frames, one drawer',
      text: '又便宜又好吃 cheap AND tasty · 天气越来越热 hotter and hotter · '
          '越学越有意思 the more you study, the more interesting it gets.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'This dish is both cheap and tasty.', answer: '这个菜**又**便宜**又**好吃。', accepted: ['yòu…yòu', 'you'], hint: 'zhè ge cài yòu piányi yòu hǎochī'),
    CourseItem(prompt: 'The weather is getting hotter and hotter.', answer: '天气**越来越**热。', accepted: ['yuèláiyuè', 'yue lai yue'], hint: 'tiānqì yuèláiyuè rè'),
    CourseItem(prompt: 'The more I study Chinese, the more interesting it gets.', answer: '中文**越**学**越**有意思。', accepted: ['yuè…yuè', 'yue'], hint: 'Zhōngwén yuè xué yuè yǒuyìsi'),
    CourseItem(prompt: 'She is both tall and pretty.', answer: '她**又**高**又**漂亮。', accepted: ['yòu'], hint: 'tā yòu gāo yòu piàoliang'),
    CourseItem(prompt: 'His Chinese is getting better and better.', answer: '他的中文**越来越**好。', accepted: ['yuèláiyuè'], hint: 'tā de Zhōngwén yuèláiyuè hǎo'),
  ],
);

final QuizContent enZhB12Potential = enZhFill(
  id: 'en_zh_b1_2_potential',
  title: 'Can manage it? V + 得/不 + landing',
  intro:
      'Slide 得 or 不 between verb and landing to say whether the result is '
      'reachable: 听得懂 can understand, 听不懂 can\'t understand.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ The landing decides, 得/不 predicts (Z21)',
      text: '看得完 can finish reading it, 看不完 can\'t possibly finish. '
          'This beats 能 for ability tied to a RESULT: 我听不懂 ≈ "it won\'t '
          'land in my ears".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Questions pair both',
      text: '你听得懂听不懂? or 你听得懂吗? — either asks "can you follow?"',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I can understand (by listening).', answer: '我听**得**懂。', accepted: ['de'], hint: 'wǒ tīng de dǒng'),
    CourseItem(prompt: 'I can\'t understand (by listening).', answer: '我听**不**懂。', accepted: ['bu', 'bù'], hint: 'wǒ tīng bu dǒng'),
    CourseItem(prompt: 'Can you finish eating so much food? (eat-finish)', answer: '这么多菜，你吃**得**完吗？', accepted: ['de'], hint: 'zhème duō cài, nǐ chī de wán ma'),
    CourseItem(prompt: 'I can\'t see it (too far away). (look-register)', answer: '太远了，我看**不**见。', accepted: ['bu', 'bù'], hint: 'tài yuǎn le, wǒ kàn bu jiàn'),
    CourseItem(prompt: 'We can\'t buy it (too expensive → can\'t attain). (buy-起 = afford)', answer: '太贵了，我们买**不**起。', accepted: ['bu', 'bù'], hint: 'tài guì le, wǒmen mǎi bu qǐ'),
    CourseItem(prompt: 'Can you read (and understand) this book?', answer: '这本书你看**得**懂吗？', accepted: ['de'], hint: 'zhè běn shū nǐ kàn de dǒng ma'),
  ],
);

final QuizContent enZhB12ReadPeople = enZhRead(
  id: 'en_zh_b1_2_read_people',
  title: 'Reading: 我认识的人',
  passageTitle: '我认识的人',
  passage:
      '在北京，汤姆认识了很多有意思的人。'
      '住在他楼上的老爷爷每天早上在公园里打太极拳，他是三十年前从上海来的。'
      '在咖啡馆工作的那个女孩儿会说四种语言，她说得又快又好。'
      '教汤姆写汉字的王老师写的字漂亮得像画儿一样。'
      '汤姆觉得，认识的人越多，他的中文就越好，生活也越来越有意思。',
  passageTranslation:
      'Zài Běijīng, Tāngmǔ rènshi le hěn duō yǒuyìsi de rén. Zhù zài tā '
      'lóushàng de lǎo yéye měitiān zǎoshang zài gōngyuán li dǎ tàijíquán, tā '
      'shì sānshí nián qián cóng Shànghǎi lái de. Zài kāfēiguǎn gōngzuò de nà '
      'ge nǚháir huì shuō sì zhǒng yǔyán, tā shuō de yòu kuài yòu hǎo. Jiāo '
      'Tāngmǔ xiě Hànzì de Wáng lǎoshī xiě de zì piàoliang de xiàng huàr '
      'yíyàng. Tāngmǔ juéde, rènshi de rén yuè duō, tā de Zhōngwén jiù yuè '
      'hǎo, shēnghuó yě yuèláiyuè yǒuyìsi.\n\n'
      'In Beijing, Tom has gotten to know many interesting people. The old '
      'grandpa who lives upstairs does tai chi in the park every morning — he '
      'came from Shanghai thirty years ago. The girl who works at the café '
      'speaks four languages, fast and well. Teacher Wang, who teaches Tom to '
      'write characters, writes characters as beautiful as paintings. Tom '
      'finds that the more people he knows, the better his Chinese gets — and '
      'life keeps getting more interesting.',
  intro:
      'Four people, each introduced by a 的-clause. Parse each: find the 的, '
      'find the noun, then read the description before it.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Chunk, don\'t crawl (Z8)',
      text: '住在他楼上的|老爷爷 — split at the 的. Reading Chinese means '
          'grouping characters into words and clauses; the 的 is your best '
          'seam.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '住在楼上的老爷爷是从哪儿来的？',
      options: ['上海', '北京', '加拿大'],
      correctIndex: 0,
      questionTranslation: 'Where did the grandpa upstairs come from?',
    ),
    ReadingQuestion(
      question: '谁会说四种语言？',
      options: ['王老师', '在咖啡馆工作的女孩儿', '汤姆'],
      correctIndex: 1,
      questionTranslation: 'Who speaks four languages?',
    ),
    ReadingQuestion(
      question: '王老师教汤姆什么？',
      options: ['写汉字', '打太极拳', '做菜'],
      correctIndex: 0,
      questionTranslation: 'What does Teacher Wang teach Tom?',
    ),
  ],
);

final QuizContent enZhB12Separable = enZhFill(
  id: 'en_zh_b1_2_separable',
  title: 'Separable verbs: 见面, 帮忙',
  intro:
      'Some "verbs" are secretly verb + object: 见面 = see-face, 帮忙 = '
      'help-busy. They split open to take 了, durations — and never take '
      'another object.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 见面他 ✗ — meet WITH: 跟他见面',
      text: '面 already fills the object slot, so the person joins with 跟: '
          '我跟他见面. Same family: 帮他的忙, 睡了一个好觉, 唱了三首歌.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I\'m meeting (with) him tomorrow.', answer: '我明天**跟他**见面。', accepted: ['gēn tā'], hint: 'wǒ míngtiān gēn tā jiànmiàn'),
    CourseItem(prompt: 'Can you help me? (help my busy-ness)', answer: '你能帮**我的忙**吗？', accepted: ['wǒ de máng'], hint: 'nǐ néng bāng wǒ de máng ma'),
    CourseItem(prompt: 'I slept a good sleep. (split 睡觉)', answer: '我睡了一个好**觉**。', accepted: ['jiào'], hint: 'wǒ shuì le yí ge hǎo jiào'),
    CourseItem(prompt: 'We met (with each other) once. (split 见面 + 次)', answer: '我们见过一次**面**。', accepted: ['miàn'], hint: 'wǒmen jiàn guo yí cì miàn'),
    CourseItem(prompt: 'She sang three songs. (split 唱歌)', answer: '她唱了三首**歌**。', accepted: ['gē'], hint: 'tā chàng le sān shǒu gē'),
  ],
);

final QuizContent enZhB12Weather = enZhFill(
  id: 'en_zh_b1_2_weather',
  title: 'Weather & seasons',
  intro:
      'Weather verbs act alone: 下雨 it\'s raining ("falls rain"), 刮风 it\'s '
      'windy — no "it" needed. Seasons: 春夏秋冬.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'No dummy "it" (Z28)',
      text: 'English props weather on "it"; Chinese just states the event: '
          '下雨了 raining, 下雪了 snowing, 刮风了 wind\'s up. Subjectless and '
          'proud.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'It\'s raining. (rain falls)', answer: '下雨', accepted: ['xià yǔ', 'xiàyǔ'], hint: 'xià yǔ'),
    CourseItem(prompt: 'It\'s snowing.', answer: '下雪', accepted: ['xià xuě'], hint: 'xià xuě'),
    CourseItem(prompt: 'spring', answer: '春天', accepted: ['chūntiān'], hint: 'chūntiān'),
    CourseItem(prompt: 'summer', answer: '夏天', accepted: ['xiàtiān'], hint: 'xiàtiān'),
    CourseItem(prompt: 'autumn', answer: '秋天', accepted: ['qiūtiān'], hint: 'qiūtiān'),
    CourseItem(prompt: 'winter', answer: '冬天', accepted: ['dōngtiān'], hint: 'dōngtiān'),
    CourseItem(prompt: 'The weather today is really good!', answer: '今天**天气**真好！', accepted: ['tiānqì'], hint: 'jīntiān tiānqì zhēn hǎo'),
  ],
);

final QuizContent enZhB12SpeakChunks = enZhSpeak(
  id: 'en_zh_b1_2_speak_chunks',
  title: 'Speaking: read in chunks, not characters',
  intro:
      'Chinese writes without spaces — fluent reading (and speaking) groups '
      'characters into words and phrases. Read each line as its chunks.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Chunk at 的 and the commas (Z8)',
      text: '我昨天买的|那本书|很有意思 — three chunks, three breaths. '
          'Character-by-character reading kills both speed and tone.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wǒ zuótiān mǎi de nà běn shū hěn yǒuyìsi. — The book I bought yesterday is really interesting.', answer: '我昨天买的那本书很有意思。'),
    CourseItem(prompt: 'Zhù zài lóushàng de yéye měitiān dǎ tàijíquán. — The grandpa upstairs does tai chi daily.', answer: '住在楼上的爷爷每天打太极拳。'),
    CourseItem(prompt: 'Rúguǒ míngtiān bú xià yǔ, wǒmen jiù qù gōngyuán. — If it doesn\'t rain tomorrow, we\'ll go to the park.', answer: '如果明天不下雨，我们就去公园。'),
    CourseItem(prompt: 'Tā shuō de huà wǒ dōu tīng de dǒng. — I can understand everything she says.', answer: '她说的话我都听得懂。'),
    CourseItem(prompt: 'Běijīng de qiūtiān yòu liángkuai yòu piàoliang. — Beijing\'s autumn is cool and beautiful.', answer: '北京的秋天又凉快又漂亮。'),
  ],
);

final QuizContent enZhB12ListenWeather = enZhListen(
  id: 'en_zh_b1_2_listen_weather',
  title: 'Listening: 天气预报',
  passageTitle: '天气预报',
  passage:
      '大家好，现在播报明天的天气。'
      '北京明天是晴天，不刮风，白天二十八度，是个又暖和又舒服的日子。'
      '上海明天上午有小雨，下午雨就停了，二十五度。'
      '广州明天天气很热，三十四度，比今天热三度。'
      '哈尔滨的朋友要注意：明天下大雪，零下十度，出门的时候要多穿衣服。',
  passageTranslation:
      'Dàjiā hǎo, xiànzài bōbào míngtiān de tiānqì. Běijīng míngtiān shì '
      'qíngtiān, bù guā fēng, báitiān èrshíbā dù, shì ge yòu nuǎnhuo yòu '
      'shūfu de rìzi. Shànghǎi míngtiān shàngwǔ yǒu xiǎo yǔ, xiàwǔ yǔ jiù '
      'tíng le, èrshíwǔ dù. Guǎngzhōu míngtiān tiānqì hěn rè, sānshísì dù, bǐ '
      'jīntiān rè sān dù. Hā\'ěrbīn de péngyou yào zhùyì: míngtiān xià dà '
      'xuě, língxià shí dù, chūmén de shíhou yào duō chuān yīfu.\n\n'
      'Hello everyone, here is tomorrow\'s weather. Beijing: sunny, no wind, '
      '28 degrees in the day — a warm, comfortable day. Shanghai: light rain '
      'in the morning, stopping by afternoon, 25 degrees. Guangzhou: very '
      'hot, 34 degrees — three degrees hotter than today. Friends in Harbin, '
      'take note: heavy snow tomorrow, minus ten — dress warmly when you go '
      'out.',
  intro:
      'A weather forecast for four cities. Listen for city + weather + '
      'temperature — and one 比-comparison.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '度 = degrees, 零下 = below zero',
      text: '二十八度 28°, 零下十度 −10°. The 比-line: 比今天热三度 — hotter '
          'than today BY three degrees (the amount follows the adjective, '
          'Z24).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '北京明天天气怎么样？',
      options: ['晴天', '下雨', '下雪'],
      correctIndex: 0,
      questionTranslation: 'What is tomorrow\'s weather in Beijing?',
    ),
    ReadingQuestion(
      question: '上海的雨什么时候停？',
      options: ['上午', '下午', '晚上'],
      correctIndex: 1,
      questionTranslation: 'When does the rain in Shanghai stop?',
    ),
    ReadingQuestion(
      question: '哪个城市明天下大雪？',
      options: ['广州', '北京', '哈尔滨'],
      correctIndex: 2,
      questionTranslation: 'Which city gets heavy snow tomorrow?',
    ),
  ],
);

final QuizContent enZhB12DictDescribe = enZhDict(
  id: 'en_zh_b1_2_dict_describe',
  title: 'Dictation: descriptions',
  intro:
      'Type what you hear — 的-clauses, 是…的 spotlights and potential '
      'complements included.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Hear the clause seam',
      text: 'In 我昨天买的书, the tiny 的 splits clause from noun. Miss it '
          'and the IME will offer you nonsense — the seam is the meaning '
          '(Z19).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The book I bought is very interesting.', answer: '我买的书很有意思。'),
    CourseItem(prompt: 'It was in Beijing that she learned Chinese.', answer: '她是在北京学的中文。'),
    CourseItem(prompt: 'If it rains tomorrow, we won\'t go.', answer: '如果明天下雨，我们就不去。'),
    CourseItem(prompt: 'I can\'t understand (by listening).', answer: '我听不懂。'),
    CourseItem(prompt: 'The weather is getting hotter and hotter.', answer: '天气越来越热。'),
    CourseItem(prompt: 'This dish is both cheap and tasty.', answer: '这个菜又便宜又好吃。'),
  ],
);

final QuizContent enZhB12ReadSeasons = enZhRead(
  id: 'en_zh_b1_2_read_seasons',
  title: 'Reading: 北京的四季',
  passageTitle: '北京的四季',
  passage:
      '北京的四季很不一样。春天暖和，可是常常刮风。'
      '夏天又热又长，最热的时候有三十八度，白天出门的人都走得很快，'
      '因为大家都想快点儿回到凉快的家里。'
      '秋天是北京最漂亮的季节：天很蓝，路两边的树越来越黄，'
      '来公园拍照片的人也越来越多。'
      '冬天很冷，有时候下大雪。下雪的时候，孩子们玩得最高兴。'
      '汤姆最喜欢的季节是秋天。他说："如果你秋天来北京，就会爱上这个城市。"',
  passageTranslation:
      'Běijīng de sìjì hěn bù yíyàng. Chūntiān nuǎnhuo, kěshì chángcháng guā '
      'fēng. Xiàtiān yòu rè yòu cháng, zuì rè de shíhou yǒu sānshíbā dù, '
      'báitiān chūmén de rén dōu zǒu de hěn kuài, yīnwèi dàjiā dōu xiǎng kuài '
      'diǎnr huí dào liángkuai de jiā li. Qiūtiān shì Běijīng zuì piàoliang '
      'de jìjié: tiān hěn lán, lù liǎngbiān de shù yuèláiyuè huáng, lái '
      'gōngyuán pāi zhàopiàn de rén yě yuèláiyuè duō. Dōngtiān hěn lěng, '
      'yǒushíhou xià dà xuě. Xià xuě de shíhou, háizimen wán de zuì gāoxìng. '
      'Tāngmǔ zuì xǐhuan de jìjié shì qiūtiān. Tā shuō: "Rúguǒ nǐ qiūtiān lái '
      'Běijīng, jiù huì àishàng zhè ge chéngshì."\n\n'
      'Beijing\'s four seasons are very different. Spring is warm but often '
      'windy. Summer is hot and long — at its hottest it reaches 38 degrees, '
      'and people out in the daytime walk fast, because everyone wants to get '
      'back to a cool home. Autumn is Beijing\'s most beautiful season: the '
      'sky is blue, the trees along the roads turn more and more yellow, and '
      'more and more people come to the parks to take photos. Winter is cold, '
      'sometimes with heavy snow. When it snows, the children have the best '
      'time. Tom\'s favourite season is autumn. He says: "If you come to '
      'Beijing in autumn, you\'ll fall in love with this city."',
  intro:
      'Four seasons, packed with this module\'s frames: 又…又, 越来越, '
      '的-clauses and a closing 如果…就.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '最 = the most',
      text: '最热 hottest, 最漂亮 most beautiful, 最喜欢 favourite — 最 '
          'simply fronts the adjective. No "-est" forms to build.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '北京哪个季节最漂亮？',
      options: ['春天', '秋天', '冬天'],
      correctIndex: 1,
      questionTranslation: 'Which is Beijing\'s most beautiful season?',
    ),
    ReadingQuestion(
      question: '夏天最热的时候有多少度？',
      options: ['二十八度', '三十四度', '三十八度'],
      correctIndex: 2,
      questionTranslation: 'How hot does it get at the height of summer?',
    ),
    ReadingQuestion(
      question: '下雪的时候，谁玩得最高兴？',
      options: ['孩子们', '汤姆', '拍照片的人'],
      correctIndex: 0,
      questionTranslation: 'Who has the most fun when it snows?',
    ),
  ],
);

/// B1.2 in chain order.
final List<QuizContent> enZhB1_2 = [
  enZhB12Relative1,
  enZhB12Relative2,
  enZhB12SpeakPeople,
  enZhB12ShiDe,
  enZhB12ListenShide,
  enZhB12Ruguo,
  enZhB12YouYue,
  enZhB12Potential,
  enZhB12ReadPeople,
  enZhB12Separable,
  enZhB12Weather,
  enZhB12SpeakChunks,
  enZhB12ListenWeather,
  enZhB12DictDescribe,
  enZhB12ReadSeasons,
];
