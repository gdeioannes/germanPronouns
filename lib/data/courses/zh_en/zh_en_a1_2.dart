import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// A1.2 — Everyday Life · 日常生活. Mandarin → English.
///
/// Big rocks: the present simple with **3rd-person `-s`** (Z13 — no agreement in
/// Chinese), **do/does** for questions & negation (Z14 — Chinese negates
/// directly and questions with 吗), plurals & countability (Z15), and the dummy
/// subjects `it`/`there` (Z19).

final QuizContent zhEnA12Present = zhEnFill(
  id: 'zh_en_a1_2_present',
  title: '一般现在时（I/you/we/they）',
  intro: '一般现在时表示习惯和事实。主语是 I/you/we/they 时，动词用原形。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '动词原形',
      text: 'I/you/we/they + 动词原形：I work、they live。下一课会学 he/she/it 加 -s。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我每天学习英语。', answer: 'I **study** English every day.'),
    CourseItem(prompt: '他们住在北京。', answer: 'They **live** in Beijing.'),
    CourseItem(prompt: '我们喜欢咖啡。', answer: 'We **like** coffee.'),
    CourseItem(prompt: '你说中文。', answer: 'You **speak** Chinese.'),
    CourseItem(prompt: '我在一家银行工作。', answer: 'I **work** at a bank.'),
    CourseItem(prompt: '他们七点起床。', answer: 'They **get** up at seven.'),
    CourseItem(prompt: '我们周末踢足球。', answer: 'We **play** football at weekends.'),
  ],
);

final QuizContent zhEnA12ThirdS = zhEnFill(
  id: 'zh_en_a1_2_third_s',
  title: '第三人称单数 -s',
  intro: '主语是 he / she / it（或单数名词）时，动词要加 -s。这是中文里没有的规则。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ He/She/It → 加 S（Z13）',
      text: '只有 he / she / it 这三类主语让动词加 -s：He like**s**、She work**s**。',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '拼写变化',
      text: '辅音+y → ies（study→studie**s**）；s/sh/ch/x/o 结尾 → es（watch→watch**es**，go→go**es**）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他每天学习英语。', answer: 'He **studies** English every day.'),
    CourseItem(prompt: '她住在上海。', answer: 'She **lives** in Shanghai.'),
    CourseItem(prompt: '我爸爸喜欢茶。', answer: 'My father **likes** tea.'),
    CourseItem(prompt: '她说三种语言。', answer: 'She **speaks** three languages.'),
    CourseItem(prompt: '他在医院工作。', answer: 'He **works** at a hospital.'),
    CourseItem(prompt: '这只猫喜欢鱼。', answer: 'The cat **likes** fish.'),
    CourseItem(prompt: '她六点起床。', answer: 'She **gets** up at six.'),
    CourseItem(prompt: '他看电视。', answer: 'He **watches** TV.'),
  ],
);

final QuizContent zhEnA12ListenDay = zhEnListen(
  id: 'zh_en_a1_2_listen_day',
  title: '听力：A typical day',
  passageTitle: "Lily's day",
  passage:
      'Lily is a nurse. She gets up at six o\'clock every morning. She has '
      'breakfast at half past six. She goes to work by bus. She works at a big '
      'hospital in the city. In the evening, she cooks dinner and reads a book. '
      'She goes to bed at ten.',
  passageTranslation:
      'Lily 是一名护士。她每天早上六点起床，六点半吃早饭。她坐公交车上班，'
      '在城里一家大医院工作。晚上她做晚饭、看书。她十点睡觉。',
  intro: '先听，再答题。注意听第三人称的 -s。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 听出 -s（Z13）',
      text: '主语是 she，所以每个动词都带 -s：get**s**、goe**s**、work**s**、read**s**。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: "What is Lily's job?",
      options: ['A teacher', 'A nurse', 'A driver'],
      correctIndex: 1,
      questionTranslation: 'Lily 的职业是什么？',
    ),
    ReadingQuestion(
      question: 'How does she go to work?',
      options: ['By car', 'By bus', 'On foot'],
      correctIndex: 1,
      questionTranslation: '她怎么去上班？',
    ),
    ReadingQuestion(
      question: 'When does she go to bed?',
      options: ['At eight', 'At nine', 'At ten'],
      correctIndex: 2,
      questionTranslation: '她几点睡觉？',
    ),
  ],
);

final QuizContent zhEnA12DoQuestions = zhEnFill(
  id: 'zh_en_a1_2_do_questions',
  title: '一般疑问句：do / does',
  intro: '中文用「吗」提问，英语要在句首借一个助动词 do 或 does，主要动词用原形。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 借个 DO 来提问（Z14）',
      text: 'he/she/it 用 **Does**，其余用 **Do**。助动词已带信息，主要动词回原形：Does he **like**?（不是 likes）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '你喜欢咖啡吗？', answer: '**Do** you like coffee?'),
    CourseItem(prompt: '他住在这里吗？', answer: '**Does** he live here?'),
    CourseItem(prompt: '他们说英语吗？', answer: '**Do** they speak English?'),
    CourseItem(prompt: '她有一辆车吗？', answer: '**Does** she have a car?'),
    CourseItem(prompt: '你每天工作吗？', answer: '**Do** you work every day?'),
    CourseItem(prompt: '这趟公交车去机场吗？', answer: '**Does** this bus go to the airport?'),
  ],
);

final QuizContent zhEnA12Negation = zhEnFill(
  id: 'zh_en_a1_2_negation',
  title: '否定句：don\'t / doesn\'t',
  intro: '否定也要借助动词：don\'t（I/you/we/they）或 doesn\'t（he/she/it）。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 否定后动词回原形（Z14）',
      text: 'doesn\'t 后面动词用原形：He **doesn\'t like** tea（不是 doesn\'t likes）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我不喜欢茶。', answer: "I **don't** like tea."),
    CourseItem(prompt: '他不住在北京。', answer: "He **doesn't** live in Beijing."),
    CourseItem(prompt: '我们不看电视。', answer: "We **don't** watch TV."),
    CourseItem(prompt: '她不说法语。', answer: "She **doesn't** speak French."),
    CourseItem(prompt: '他们周日不工作。', answer: "They **don't** work on Sundays."),
    CourseItem(prompt: '它不工作了（坏了）。', answer: "It **doesn't** work."),
  ],
);

final QuizContent zhEnA12SpeakRoutine = zhEnSpeak(
  id: 'zh_en_a1_2_speak_routine',
  title: '开口说：我的一天',
  intro: '用一般现在时说说你的日常。听并跟读，注意重音。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '重读实词（Z8）',
      text: '英语一句话只重读关键词（GET up at SEVen），其余轻读。别每个音节都用力。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我早上七点起床。', answer: 'I get up at seven in the morning.'),
    CourseItem(prompt: '我七点半吃早饭。', answer: 'I have breakfast at half past seven.'),
    CourseItem(prompt: '我坐地铁上班。', answer: 'I go to work by subway.'),
    CourseItem(prompt: '我中午十二点吃午饭。', answer: 'I have lunch at twelve.'),
    CourseItem(prompt: '晚上我看电视。', answer: 'In the evening, I watch TV.'),
    CourseItem(prompt: '我十一点睡觉。', answer: 'I go to bed at eleven.'),
  ],
);

final QuizContent zhEnA12Frequency = zhEnFill(
  id: 'zh_en_a1_2_frequency',
  title: '频率副词 always … never',
  intro: '频率副词表示做某事的频繁程度：always > usually > often > sometimes > never。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '位置',
      text: '频率副词放在**实义动词前**、**be 动词后**：I **always** drink tea；She is **often** late。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我总是喝茶。', answer: 'I **always** drink tea.'),
    CourseItem(prompt: '她经常迟到。', answer: 'She is **often** late.'),
    CourseItem(prompt: '他们有时看电影。', answer: 'They **sometimes** watch films.'),
    CourseItem(prompt: '我从不吃肉。', answer: 'I **never** eat meat.'),
    CourseItem(prompt: '他通常步行去上班。', answer: 'He **usually** walks to work.'),
  ],
);

final QuizContent zhEnA12Plurals = zhEnFill(
  id: 'zh_en_a1_2_plurals',
  title: '名词复数 -s / -es / 不规则',
  intro: '英语可数名词的复数要变形。中文名词不变，全靠数量词，所以这里要特别留意。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 复数要变形（Z15）',
      text: '一般加 -s；s/sh/ch/x 后加 -es（box→box**es**）；辅音+y → ies（city→citie**s**）。',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '不规则复数',
      text: '背下来：child→children，man→men，woman→women，foot→feet，person→people，tooth→teeth。',
    ),
  ],
  items: const [
    CourseItem(prompt: '三本书', answer: 'three **books**'),
    CourseItem(prompt: '两个盒子', answer: 'two **boxes**'),
    CourseItem(prompt: '五个孩子', answer: 'five **children**'),
    CourseItem(prompt: '很多城市', answer: 'many **cities**'),
    CourseItem(prompt: '两个女人', answer: 'two **women**'),
    CourseItem(prompt: '一些番茄', answer: 'some **tomatoes**'),
    CourseItem(prompt: '三个人', answer: 'three **people**'),
    CourseItem(prompt: '两只脚', answer: 'two **feet**'),
  ],
);

final QuizContent zhEnA12ThereIt = zhEnFill(
  id: 'zh_en_a1_2_there_it',
  title: '存在句 there is/are 与虚主语 it',
  intro: '英语句子必须有主语。表示「有」用 there is/are；说天气、时间用虚主语 it。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 别丢主语（Z19）',
      text: '中文「下雨了」没有主语，但英语必须说 **It** is raining。「桌上有书」用 **There** is a book。',
    ),
  ],
  items: const [
    CourseItem(prompt: '桌子上有一本书。', answer: 'There **is** a book on the table.'),
    CourseItem(prompt: '公园里有很多树。', answer: 'There **are** many trees in the park.'),
    CourseItem(prompt: '下雨了。', answer: '**It** is raining.'),
    CourseItem(prompt: '现在三点。', answer: "**It** is three o'clock."),
    CourseItem(prompt: '冰箱里有一些牛奶。', answer: 'There **is** some milk in the fridge.'),
    CourseItem(prompt: '今天很冷。', answer: '**It** is cold today.'),
  ],
);

final QuizContent zhEnA12ReadLin = zhEnRead(
  id: 'zh_en_a1_2_read_lin',
  title: '阅读：A day in Lin\'s life',
  passageTitle: "Lin's day",
  passage:
      'Lin is a student in Beijing. On weekdays, she gets up at seven. She has '
      'breakfast with her family and then goes to school by bike. She has four '
      'classes in the morning. At lunchtime, she eats with her friends. In the '
      'afternoon, she studies in the library. She likes English and music. On '
      'Saturdays, she doesn\'t go to school. She plays basketball and watches '
      'films.',
  passageTranslation:
      'Lin 是北京的一名学生。工作日她七点起床，和家人一起吃早饭，然后骑自行车上学。'
      '上午她有四节课。午饭时间她和朋友一起吃饭。下午她在图书馆学习。她喜欢英语和音乐。'
      '周六她不上学，会打篮球、看电影。',
  intro: '读一段关于 Lin 一天的短文。留意所有第三人称动词的 -s。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '-s 无处不在',
      text: '主语都是 she：get**s**、ha**s**、goe**s**、like**s**、play**s**、watch**es**。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How does Lin go to school?',
      options: ['By bus', 'By bike', 'By car'],
      correctIndex: 1,
      questionTranslation: 'Lin 怎么去上学？',
    ),
    ReadingQuestion(
      question: 'Where does she study in the afternoon?',
      options: ['At home', 'In the library', 'In the park'],
      correctIndex: 1,
      questionTranslation: '她下午在哪里学习？',
    ),
    ReadingQuestion(
      question: 'What does she do on Saturdays?',
      options: ['She goes to school', 'She plays basketball', 'She works'],
      correctIndex: 1,
      questionTranslation: '她周六做什么？',
    ),
  ],
);

final QuizContent zhEnA12PrepTime = zhEnFill(
  id: 'zh_en_a1_2_prep_time',
  title: '时间介词 at / on / in',
  intro: '英语的时间介词很挑剔。用「由小到大」的规律来记。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 由小到大（Z24）',
      text: '**at** 用于具体时刻（at 7）；**on** 用于某天/日期（on Monday）；**in** 用于月份/年份/一天中的时段（in May, in 2024, in the morning）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '七点开始上课。', answer: 'The class starts **at** seven.'),
    CourseItem(prompt: '我周一有个会。', answer: 'I have a meeting **on** Monday.'),
    CourseItem(prompt: '我的生日在一月。', answer: 'My birthday is **in** January.'),
    CourseItem(prompt: '我早上学习。', answer: 'I study **in** the morning.'),
    CourseItem(prompt: '我晚上睡觉。', answer: 'I sleep **at** night.'),
    CourseItem(prompt: '我 2024 年来到这里。', answer: 'I came here **in** 2024.'),
  ],
);

final QuizContent zhEnA12Can = zhEnFill(
  id: 'zh_en_a1_2_can',
  title: '情态动词 can / can\'t',
  intro: 'can 表示能力（会、能）。后面直接跟动词原形，不加 to，也不加 -s。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'can + 原形',
      text: 'can 后面永远是动词原形：She **can play**（不是 can plays / can to play）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我会游泳。', answer: 'I **can** swim.'),
    CourseItem(prompt: '他不会开车。', answer: "He **can't** drive."),
    CourseItem(prompt: '你会说英语吗？', answer: '**Can** you speak English?'),
    CourseItem(prompt: '她会弹钢琴。', answer: 'She **can** play the piano.'),
    CourseItem(prompt: '我今天不能来。', answer: "I **can't** come today."),
  ],
);

final QuizContent zhEnA12SpeakEndings = zhEnSpeak(
  id: 'zh_en_a1_2_speak_endings',
  title: '发音：词尾辅音与 -s',
  intro: '中文音节大多以元音或 n/ng 结尾，所以英语的词尾辅音和 -s 最容易被丢掉。练习把它们「落地」。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 词尾要落地（Z4/Z5）',
      text: '读出结尾的辅音，别在后面加「-uh」：and 不是「an-duh」，desk 不是「de-si-ke」。',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '-s 的三种读音',
      text: 'book**s** /s/、dog**s** /z/、bus**es** /ɪz/。听出区别，也要读出来。',
    ),
  ],
  items: const [
    CourseItem(prompt: '词尾辅音', answer: 'and, desk, milk, world'),
    CourseItem(prompt: '-s 读 /s/', answer: 'books, cats, maps, cups'),
    CourseItem(prompt: '-s 读 /z/', answer: 'dogs, pens, boys, cars'),
    CourseItem(prompt: '-s 读 /ɪz/', answer: 'buses, boxes, watches'),
    CourseItem(prompt: '第三人称 -s', answer: 'He works, she plays, it goes.'),
    CourseItem(prompt: '一整句', answer: 'She likes cats and dogs.'),
  ],
);

final QuizContent zhEnA12TimePrices = zhEnFill(
  id: 'zh_en_a1_2_time_prices',
  title: '说时间与价格',
  intro: '怎么问时间、报时间、问价格。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '半点与几刻',
      text: 'half past three = 3:30；(a) quarter past three = 3:15；(a) quarter to nine = 8:45。问价格用 How much。',
    ),
  ],
  items: const [
    CourseItem(prompt: '现在几点？', answer: 'What **time** is it?'),
    CourseItem(prompt: '三点整。', answer: "It's **three** o'clock."),
    CourseItem(prompt: '三点半。', answer: "It's **half** past three."),
    CourseItem(prompt: '差一刻九点（8:45）。', answer: "It's a **quarter** to nine."),
    CourseItem(prompt: '多少钱？', answer: 'How **much** is it?'),
    CourseItem(prompt: '五块钱。', answer: "It's **five** yuan."),
  ],
);

final QuizContent zhEnA12DictRoutine = zhEnDict(
  id: 'zh_en_a1_2_dict_routine',
  title: '听写：My routine',
  intro: '听句子并打出来。重点练习你听到但常漏写的 -s 和复数。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 写出每个 -s（Z13/Z15）',
      text: '注意：goe**s**、watch**es**、like**s**、class**es**——这些词尾正是最容易漏掉的。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我七点起床。', answer: 'I get up at seven.'),
    CourseItem(prompt: '她坐公交车上班。', answer: 'She goes to work by bus.'),
    CourseItem(prompt: '他晚上看电视。', answer: 'He watches TV in the evening.'),
    CourseItem(prompt: '他们有三节课。', answer: 'They have three classes.'),
    CourseItem(prompt: '我妈妈喜欢茶。', answer: 'My mother likes tea.'),
    CourseItem(prompt: '今天很冷。', answer: 'It is cold today.'),
  ],
);

final QuizContent zhEnA12ReadCafe = zhEnRead(
  id: 'zh_en_a1_2_read_cafe',
  title: '阅读：At the café',
  passageTitle: 'At the café',
  passage:
      'Tom and Anna are at a café. Tom wants a coffee and a piece of cake. Anna '
      'doesn\'t like coffee, so she has a cup of tea. The waiter is friendly. '
      '"What would you like to eat?" he asks. Anna orders a sandwich. Tom pays '
      'for everything. The coffee is three pounds and the tea is two pounds. '
      'They have a nice afternoon together.',
  passageTranslation:
      'Tom 和 Anna 在一家咖啡馆。Tom 想要一杯咖啡和一块蛋糕。Anna 不喜欢咖啡，'
      '所以她点了一杯茶。服务员很友好，问：「你想吃点什么？」Anna 点了一个三明治。'
      'Tom 付了全部的钱。咖啡三英镑，茶两英镑。他们一起度过了一个愉快的下午。',
  intro: '读一段咖啡馆里的对话短文。留意 doesn\'t 和「一块/一杯」的表达。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '量词 → 部分词（Z16）',
      text: '中文的量词在英语里变成 a **piece** of cake、a **cup** of tea——就像英语版的「一块」「一杯」。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What does Anna drink?',
      options: ['Coffee', 'Tea', 'Juice'],
      correctIndex: 1,
      questionTranslation: 'Anna 喝什么？',
    ),
    ReadingQuestion(
      question: 'Who pays?',
      options: ['Tom', 'Anna', 'The waiter'],
      correctIndex: 0,
      questionTranslation: '谁付钱？',
    ),
    ReadingQuestion(
      question: 'How much is the coffee?',
      options: ['Two pounds', 'Three pounds', 'Five pounds'],
      correctIndex: 1,
      questionTranslation: '咖啡多少钱？',
    ),
  ],
);

/// A1.2 in chain order (interleaved, ≤ 2 knowledge quizzes in a row).
final List<QuizContent> zhEnA1_2 = [
  zhEnA12Present,
  zhEnA12ThirdS,
  zhEnA12ListenDay,
  zhEnA12DoQuestions,
  zhEnA12Negation,
  zhEnA12SpeakRoutine,
  zhEnA12Frequency,
  zhEnA12Plurals,
  zhEnA12ThereIt,
  zhEnA12ReadLin,
  zhEnA12PrepTime,
  zhEnA12Can,
  zhEnA12SpeakEndings,
  zhEnA12TimePrices,
  zhEnA12DictRoutine,
  zhEnA12ReadCafe,
];
