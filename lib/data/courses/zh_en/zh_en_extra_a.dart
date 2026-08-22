import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// The A-level "all quiz kinds" boost for the zh_en course: one inline
/// big-text cloze plus two external-AI speaking exercises (a mid-module
/// checkpoint and a closing conversation) per module, A1.1–A2.2. Chinese
/// teaching text, English targets — see `docs/zh_en_certification_plan.md`.

// ── A1.1 初次接触 ──────────────────────────────────────────────────────────

final QuizContent zhEnA11SpeakingMid = zhEnSpeaking(
  id: 'zh_en_a1_1_speaking_mid',
  title: '对话：第一次打招呼',
  level: 'A1.1',
  topic: 'A very simple first meeting: greet me, ask my name, where I am '
      'from and what I do. Speak very slowly and use only basic words.',
  practisePoints: [
    'Greetings: hello, how are you, nice to meet you',
    'Saying who I am with be: I am… / I\'m from…',
    'Saying my job with a/an: I\'m a student',
  ],
  scoringCriteria: [
    'Uses am/is/are correctly',
    'Never drops the subject pronoun (I, you, he…)',
    'Uses a/an before jobs',
  ],
  priorityErrors: [
    'missing be before adjectives ("he tall")',
    'missing a/an before professions',
    'he/she mixed up',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '模块中段检查点：在你自己的 AI 助手里进行一次最简单的英语见面对话。'
      '复制提示词，打开语音模式，说完后把分数输回这里。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '慢慢说，带上主语',
      text: '每句话都要有主语和 be：I am…, She is…（⚑Z12/Z20）。'
          '说得慢而完整，胜过说得快而缺词。',
    ),
  ],
);

final QuizContent zhEnA11BigText = zhEnBigText(
  id: 'zh_en_a1_1_bigtext',
  title: '整段填空：A new friend in class',
  passageTitle: 'A new friend',
  intro: '一段带空格的短文：在每个空里填上缺少的 be 动词、冠词或代词。先把全文读一遍。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '本模块大合体',
      text: 'be（am/is/are）、a/an 和必须写出的主语（⚑Z11、⚑Z12）：'
          '这段文字把模块的重点全部混在一起。',
    ),
  ],
  template:
      'Hello! My name {{0}} Li Ming and I {{1}} from Chengdu. I am {{2}} '
      'student in London. This {{3}} my classroom and that {{4}} my teacher, '
      'Mrs. Park. {{5}} is very kind. My friend Tom is {{6}} engineer from '
      'Leeds. We {{7}} good friends. Our school {{8}} small, but {{9}} is '
      'nice.',
  blanks: [
    inputBlank('is'),
    inputBlank('am', accepted: ["'m"]),
    inputBlank('a'),
    inputBlank('is'),
    inputBlank('is'),
    inputBlank('She', accepted: ['she']),
    inputBlank('an'),
    inputBlank('are', accepted: ["'re"]),
    inputBlank('is'),
    inputBlank('it'),
  ],
  passageTranslation:
      '你好！我叫李明，来自成都。我是伦敦的一名学生。这是我的教室，那位是我的老师'
      '——帕克太太。她非常和蔼。我的朋友 Tom 是一位来自利兹的工程师。我们是好朋友。'
      '我们的学校很小，但它很不错。',
);

final QuizContent zhEnA11SpeakingClose = zhEnSpeaking(
  id: 'zh_en_a1_1_speaking_close',
  title: '结业对话：我是谁',
  level: 'A1.1',
  topic: 'A friendly get-to-know-you interview: my name, my age, where I am '
      'from, my job, my family and my favourite colour. Very slow, very '
      'simple.',
  practisePoints: [
    'Introducing myself with be: name, age, origin',
    'My job and my family members with a/an',
    'Simple questions back: What\'s your name? Where are you from?',
    'this/that to point at things around me',
  ],
  scoringCriteria: [
    'Correct am/is/are for each subject',
    'Subject pronouns always present',
    'a/an used before jobs and singular nouns',
  ],
  targetVocabulary: [
    'student', 'teacher', 'family', 'brother', 'sister', 'favourite',
  ],
  priorityErrors: [
    'dropped be ("I student")',
    'missing a/an',
    '"has X years" instead of "is X years old"',
  ],
  mode: SpeakingMode.interview,
  intro: 'A1.1 模块的结业对话：一次关于你自己的简单采访。把提示词复制到带语音的 '
      'AI 助手里，开口说，然后把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '年龄用 be',
      text: 'I am twenty years old——英语里年龄是"是"出来的，不是"有"出来的。',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '大胆请对方重复',
      text: '"Can you repeat, please?" 是完全符合 A1 水平的句子，而且非常有用。',
    ),
  ],
);

// ── A1.2 日常生活 ──────────────────────────────────────────────────────────

final QuizContent zhEnA12SpeakingMid = zhEnSpeaking(
  id: 'zh_en_a1_2_speaking_mid',
  title: '对话：我的一天',
  level: 'A1.2',
  topic: 'A slow, simple chat about my daily routine: when I get up, what I '
      'eat, my work or studies, and my week days.',
  practisePoints: [
    'Present simple in first person: I get up, I work, I have lunch',
    'Times and days with at/on/in',
    'Third person -s when I talk about my family',
  ],
  scoringCriteria: [
    'Correct present simple forms, especially the 3rd-person -s',
    'at/on/in used correctly with times and days',
    'Subject pronouns always present',
  ],
  priorityErrors: [
    'missing 3rd-person -s',
    'missing do/does in questions',
    'wrong time prepositions',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：用英语向 AI 助手讲讲你的一天。复制、开口、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '短句 + 完整',
      text: 'I get up at seven. I have breakfast. 主语 + 动词 + 时间，'
          '这个水平要的就是这三样（⚑Z13）。',
    ),
  ],
);

final QuizContent zhEnA12BigText = zhEnBigText(
  id: 'zh_en_a1_2_bigtext',
  title: '整段填空：A normal Tuesday',
  passageTitle: 'A normal Tuesday',
  intro: '完成短文：一般现在时（别忘了 -s！）、do/does 和时间介词。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '先看主语再动笔',
      text: '主语是 he/she 时动词要加 -s；是 I/we/they 时不加（⚑Z13）。'
          '钟点前面用 at。',
    ),
  ],
  template:
      'Li Ming {{0}} up at seven every day. He {{1}} a quick breakfast and '
      'goes to work {{2}} eight. He {{3}} in an office in the centre. His '
      'sister Xiaomei {{4}} in a hospital, so she always {{5}} up very '
      'early. {{6}} Tuesdays they have lunch together. Li Ming {{7}} like '
      'coffee, so he {{8}} tea. In the evening they {{9}} TV or read.',
  blanks: [
    inputBlank('gets'),
    inputBlank('has'),
    inputBlank('at'),
    inputBlank('works'),
    inputBlank('works'),
    inputBlank('gets'),
    inputBlank('On', accepted: ['on']),
    inputBlank("doesn't", accepted: ['does not']),
    inputBlank('drinks'),
    inputBlank('watch'),
  ],
  passageTranslation:
      '李明每天七点起床。他匆匆吃过早饭，八点去上班。他在市中心的一间办公室工作。'
      '他妹妹小美在医院工作，所以总是起得很早。每逢周二他们一起吃午饭。李明不喜欢'
      '咖啡，所以他喝茶。晚上他们看电视或看书。',
);

final QuizContent zhEnA12SpeakingClose = zhEnSpeaking(
  id: 'zh_en_a1_2_speaking_close',
  title: '结业对话：我的一周',
  level: 'A1.2',
  topic: 'An interview about my typical week: my routine from Monday to '
      'Sunday, my work or studies, my family\'s routines, and what I can do '
      '(languages, sports, cooking).',
  practisePoints: [
    'Present simple with correct 3rd-person -s',
    'Days, times and at/on/in',
    'Frequency adverbs: always, usually, sometimes, never',
    'can/can\'t for abilities',
  ],
  scoringCriteria: [
    'Present simple accuracy including questions with do/does',
    'Time expressions with the right preposition',
    'Frequency adverbs in the right position',
  ],
  targetVocabulary: [
    'get up', 'have breakfast', 'work', 'usually', 'never', 'can',
  ],
  priorityErrors: [
    'missing 3rd-person -s',
    'questions without do/does',
    'dropped subject pronouns',
  ],
  mode: SpeakingMode.interview,
  intro: 'A1.2 模块的结业对话：关于你一周生活的采访。复制、开口、把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '把测验里的句子搬来用',
      text: 'I usually get up at seven. I never work on Sundays. '
          '模块里练过的句子正是这里需要的。',
    ),
  ],
);

// ── A2.1 过去与经历 ────────────────────────────────────────────────────────

final QuizContent zhEnA21SpeakingMid = zhEnSpeaking(
  id: 'zh_en_a2_1_speaking_mid',
  title: '对话：昨天',
  level: 'A2.1',
  topic: 'A simple chat about what I did yesterday and last weekend: where '
      'I went, what I ate, who I saw.',
  practisePoints: [
    'Past simple of regular verbs with a clear -ed',
    'Key irregulars: went, had, saw, ate, came',
    'Time expressions: yesterday, last week, two days ago',
  ],
  scoringCriteria: [
    'Correct past forms, regular and irregular',
    'did used correctly in questions and negatives',
    'Time expressions placed correctly (ago after the period)',
  ],
  priorityErrors: [
    'present used instead of past (Chinese verbs don\'t change — English '
        'ones must)',
    '"Did you went" — double past marking',
    'dropped -ed endings',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：把你的昨天讲给 AI 助手听。复制、开口、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑Z14 动词必须变形',
      text: '中文说"昨天我去"，动词不变；英语必须 went。'
          '先备好三句锚点：Yesterday I went to… I had lunch with… I watched…',
    ),
  ],
);

final QuizContent zhEnA21BigText = zhEnBigText(
  id: 'zh_en_a2_1_bigtext',
  title: '整段填空：A strange Monday',
  passageTitle: 'A strange Monday',
  intro: '用缺掉的过去式补全这个故事：规则动词、不规则动词、was/were 和 did。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '先通读再填',
      text: '整个故事先读一遍，再逐个决定：规则（-ed）？不规则？还是 was/were？',
    ),
  ],
  template:
      'Last Monday {{0}} a strange day. I {{1}} up late because my alarm '
      '{{2}} not work. I {{3}} breakfast in two minutes and ran to the bus '
      'stop, but the bus {{4}} early — I {{5}} it. So I walked to work and '
      '{{6}} at ten. My boss {{7}} not angry; the office was empty! Then I '
      'remembered: it was a holiday. I {{8}} home, {{9}} a big coffee and '
      'watched films all day.',
  blanks: [
    inputBlank('was'),
    inputBlank('got'),
    inputBlank('did'),
    inputBlank('had', accepted: ['ate']),
    inputBlank('left', accepted: ['came', 'was']),
    inputBlank('missed'),
    inputBlank('arrived'),
    inputBlank('was'),
    inputBlank('went', accepted: ['walked', 'came']),
    inputBlank('made', accepted: ['had']),
  ],
  passageTranslation:
      '上周一是奇怪的一天。闹钟没响，我起晚了。我两分钟吃完早饭，跑向公交站，'
      '可公交车提前走了——我没赶上。于是我步行去上班，十点才到。老板没有生气；'
      '办公室是空的！这时我才想起来：今天放假。我回到家，给自己冲了一大杯咖啡，'
      '看了一整天电影。',
);

final QuizContent zhEnA21SpeakingClose = zhEnSpeaking(
  id: 'zh_en_a2_1_speaking_close',
  title: '结业对话：我的故事',
  level: 'A2.1',
  topic: 'Tell me about your past: your childhood, your school, a trip you '
      'loved, and what you did last weekend. I will ask follow-up questions.',
  practisePoints: [
    'Past simple, regular and irregular, in connected sentences',
    'was/were and there was/were for descriptions',
    'Time expressions: when I was…, ago, last…',
    'Questions with did answered naturally',
  ],
  scoringCriteria: [
    'Past forms accuracy',
    'Story order with then, afterwards, in the end',
    'Understandable -ed pronunciation',
  ],
  targetVocabulary: [
    'went', 'was born', 'moved', 'met', 'ago', 'suddenly',
  ],
  priorityErrors: [
    'present instead of past',
    'double past after did/didn\'t',
    'dropped final consonants on -ed',
  ],
  mode: SpeakingMode.interview,
  intro: 'A2.1 模块的结业对话：一次关于你过去的采访。复制、开口、把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '一个故事三步走',
      text: '定场（When I was…）→ 讲事（I went, I saw）→ 收尾（In the end…）。'
          '任何往事都能套这个结构。',
    ),
  ],
);

// ── A2.2 计划与数量 ────────────────────────────────────────────────────────

final QuizContent zhEnA22SpeakingMid = zhEnSpeaking(
  id: 'zh_en_a2_2_speaking_mid',
  title: '对话：我的计划',
  level: 'A2.2',
  topic: 'A chat about my plans: what I am doing this week, what I am going '
      'to do next weekend, and my plans for the summer.',
  practisePoints: [
    'Present continuous for what is happening now / this week',
    'going to for decided plans',
    'will for spontaneous promises and predictions',
  ],
  scoringCriteria: [
    'be + -ing formed correctly',
    'going to vs will chosen sensibly',
    'Time expressions: tomorrow, next week, this summer',
  ],
  priorityErrors: [
    'present simple used for right-now actions',
    'missing be before going to',
    'dropped subject pronouns',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：把你的计划讲给 AI 助手听。复制、开口、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '一个计划一句话',
      text: "This weekend I'm going to visit my parents. Next month I'm "
          'going to start a course. 计划 + going to，直接说。',
    ),
  ],
);

final QuizContent zhEnA22BigText = zhEnBigText(
  id: 'zh_en_a2_2_bigtext',
  title: '整段填空：Moving day plans',
  passageTitle: 'Moving day plans',
  intro: '完成短文：进行时、going to、will、比较级和 some/any。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '每个空问自己一句',
      text: '正在发生（-ing）？已定计划（going to）？当场承诺（will）？'
          '还是比较（-er / most）？',
    ),
  ],
  template:
      'Tom is {{0}} his boxes right now because he is {{1}} to move to '
      'Manchester next week. His new flat is {{2}} than his old one, and '
      'the rent is cheaper. "I {{3}} visit you in the summer," says Emma. '
      '"Great! It is the {{4}} city for music in the country," Tom says. '
      'He still needs {{5}} boxes for his books — he has too {{6}} of '
      'them. Tomorrow his friends {{7}} help him with the van, and then '
      'they are going to {{8}} pizza together. "Don\'t worry," says Li '
      'Ming, "moving day {{9}} be fun."',
  blanks: [
    inputBlank('packing'),
    inputBlank('going'),
    inputBlank('bigger'),
    inputBlank('will', accepted: ["'ll"]),
    inputBlank('best'),
    inputBlank('some'),
    inputBlank('many'),
    inputBlank('will'),
    inputBlank('eat', accepted: ['have', 'order']),
    inputBlank('will'),
  ],
  passageTranslation:
      'Tom 此刻正在打包箱子，因为下周他要搬去曼彻斯特。新公寓比旧的大，房租也更便宜。'
      '"夏天我会去看你的，"Emma 说。"太好了！那是全国音乐最棒的城市，"Tom 说。'
      '他还需要一些装书的箱子——书实在太多了。明天朋友们会开面包车来帮忙，'
      '然后他们要一起吃披萨。"别担心，"李明说，"搬家那天会很有意思的。"',
);

final QuizContent zhEnA22SpeakingClose = zhEnSpeaking(
  id: 'zh_en_a2_2_speaking_close',
  title: '结业对话：我的未来',
  level: 'A2.2',
  topic: 'An interview about my life now and my future: what I am doing '
      'these days, my plans for next year, and comparisons between my city '
      'and another city I like.',
  practisePoints: [
    'Present continuous for these days',
    'going to and will for plans and promises',
    'Comparatives and superlatives about places',
    'some/any with shopping and food',
  ],
  scoringCriteria: [
    'The three futures used sensibly',
    'Comparative forms correct (no "more better")',
    'Continuous formed with be + -ing',
  ],
  targetVocabulary: [
    'going to', 'bigger', 'the best', 'expensive', 'move', 'plan',
  ],
  priorityErrors: [
    'present simple for right-now actions',
    'double comparatives',
    'missing be in continuous or going to',
  ],
  mode: SpeakingMode.interview,
  intro: 'A2.2 模块——也是 A 级——的结业对话：你的现在与未来。复制、开口、'
      '把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '比较你的城市',
      text: 'My city is smaller than…, but the food is better. '
          '比较两座城市是展示本模块最自然的方式。',
    ),
  ],
);
