import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';
import 'zh_en_extra_a.dart';

/// A2.2 — Plans, Descriptions & Quantities · 计划与数量. Mandarin → English.
///
/// Big rock: the **future** (`will` / `be going to`) + present continuous +
/// comparatives/superlatives + countable/uncountable. Contrastive focus:
/// countability & quantifiers (Z15), classifiers → partitives (Z16), articles
/// (Z11), vowel length (Z6), intonation (Z9).

final QuizContent zhEnA22Continuous = zhEnFill(
  id: 'zh_en_a2_2_continuous',
  title: '现在进行时（此刻）',
  intro: '现在进行时（be + V-ing）表示此刻正在发生的动作，对应中文的「正在／在」。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'be + V-ing（Z18）',
      text: '中文的「在」= 英语的进行时：我在学习 = I **am studying**。别漏掉 be 或 -ing。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我正在学习英语。', answer: 'I am **studying** English now.'),
    CourseItem(prompt: '她正在打电话。', answer: 'She is **talking** on the phone.'),
    CourseItem(prompt: '他们正在看电视。', answer: 'They are **watching** TV.'),
    CourseItem(prompt: '外面在下雨。', answer: 'It is **raining** outside.'),
    CourseItem(prompt: '你在做什么？', answer: 'What are you **doing**?'),
    CourseItem(prompt: '我们正在等公交车。', answer: 'We are **waiting** for the bus.'),
    CourseItem(prompt: '他正在做晚饭。', answer: 'He is **cooking** dinner.'),
    CourseItem(prompt: '孩子们正在公园里玩。', answer: 'The children are **playing** in the park.'),
    CourseItem(prompt: '她正在写一封电子邮件。', answer: 'She is **writing** an email.'),
    CourseItem(prompt: '我现在正在听音乐。', answer: 'I am **listening** to music now.'),
    CourseItem(prompt: '她正在跑步。（run → 双写 n）', answer: 'She is **running**.'),
    CourseItem(prompt: '你在听我说话吗？', answer: 'Are you **listening** to me?'),
    CourseItem(prompt: '宝宝正在睡觉，小声点。', answer: 'The baby is **sleeping**, be quiet.'),
    CourseItem(prompt: '他们现在没在工作。', answer: 'They are not **working** now.'),
    CourseItem(prompt: '我正在给我妈妈做午饭。（make → making）', answer: 'I am **making** lunch for my mother.'),
  ],
);

final QuizContent zhEnA22GoingTo = zhEnFill(
  id: 'zh_en_a2_2_going_to',
  title: '将来计划：be going to',
  intro: 'be going to 表示已经计划好的打算。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'be going to + 原形',
      text: '表示计划：I\'m **going to** travel。going to 后面永远是动词原形。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我打算明天去购物。', answer: "I'm **going** to go shopping tomorrow."),
    CourseItem(prompt: '她打算学开车。', answer: "She's **going** to learn to drive."),
    CourseItem(prompt: '我们打算下周搬家。', answer: "We're **going** to move next week."),
    CourseItem(prompt: '你打算做什么？', answer: 'What are you **going** to do?'),
    CourseItem(prompt: '他们打算买一辆车。', answer: "They're **going** to buy a car."),
    CourseItem(prompt: '我打算今晚早点睡。', answer: "I'm **going** to sleep early tonight."),
    CourseItem(prompt: '他打算找一份新工作。', answer: "He's **going** to look for a new job."),
    CourseItem(prompt: '我们打算在家吃饭。', answer: "We're **going** to eat at home."),
    CourseItem(prompt: '她打算参观博物馆。', answer: "She's **going** to visit the museum."),
    CourseItem(prompt: '你们打算什么时候出发？', answer: 'When are you **going** to leave?'),
    CourseItem(prompt: '我不打算去那个派对。', answer: "I'm not **going** to go to the party."),
    CourseItem(prompt: '她打算今年学英语。', answer: "She's **going** to study English this year."),
    CourseItem(prompt: '看那些云，要下雨了。（有迹象的预测）', answer: "Look at those clouds — it's **going** to rain."),
    CourseItem(prompt: '我们打算在海边度假。', answer: "We're **going** to have a holiday by the sea."),
    CourseItem(prompt: '他们打算邀请多少人？', answer: 'How many people are they **going** to invite?'),
  ],
);

final QuizContent zhEnA22Will = zhEnFill(
  id: 'zh_en_a2_2_will',
  title: '将来预测与决定：will',
  intro: 'will 用于预测、临时决定和承诺，后接动词原形。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'will vs going to',
      text: 'will = 预测/临时决定/承诺；going to = 事先的计划。will 后接原形，常缩写为 \'ll。',
    ),
  ],
  items: const [
    CourseItem(prompt: '明天会下雨。', answer: 'It **will** rain tomorrow.'),
    CourseItem(prompt: '我会帮你。', answer: 'I **will** help you.'),
    CourseItem(prompt: '他也许会晚点到。', answer: 'He **will** probably be late.'),
    CourseItem(prompt: '我觉得他们会赢。', answer: 'I think they **will** win.'),
    CourseItem(prompt: '别担心，会没事的。', answer: "Don't worry, it **will** be fine."),
    CourseItem(prompt: '我一会儿给你打电话。（临时决定）', answer: 'I **will** call you later.'),
    CourseItem(prompt: '她不会同意的。', answer: "She **won't** agree."),
    CourseItem(prompt: '你以后会明白的。', answer: 'You **will** understand one day.'),
    CourseItem(prompt: '我保证我会来。', answer: 'I promise I **will** come.'),
    CourseItem(prompt: '今晚会很冷。', answer: 'It **will** be cold tonight.'),
    CourseItem(prompt: '我来开门。（临时决定）', answer: 'I **will** open the door.'),
    CourseItem(prompt: '你觉得他会来吗？', answer: 'Do you think he **will** come?'),
    CourseItem(prompt: '我们不会忘记你的帮助。', answer: "We **won't** forget your help."),
    CourseItem(prompt: '她明年就二十岁了。', answer: 'She **will** be twenty next year.'),
    CourseItem(prompt: '等一下，我马上回来。（临时决定）', answer: 'Wait, I **will** be right back.'),
  ],
);

final QuizContent zhEnA22SpeakPlans = zhEnSpeak(
  id: 'zh_en_a2_2_speak_plans',
  title: '开口说：我的周末计划',
  intro: '说说你的周末计划。听并跟读，注意语调。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 语调（Z9）',
      text: '英语用音调高低表达态度和句型，而不是声调。一般疑问句句尾升调，陈述句降调。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这个周末我打算去爬山。', answer: "This weekend, I'm going to go hiking."),
    CourseItem(prompt: '周六我要见朋友。', answer: "On Saturday, I'm meeting my friends."),
    CourseItem(prompt: '我们打算去看电影。', answer: "We're going to watch a film."),
    CourseItem(prompt: '周日我会在家休息。', answer: "On Sunday, I'll relax at home."),
    CourseItem(prompt: '你有什么计划？', answer: 'What are your plans?'),
  ],
);

final QuizContent zhEnA22Comparatives = zhEnFill(
  id: 'zh_en_a2_2_comparatives',
  title: '比较级：-er / more … than',
  intro: '比较两个事物用比较级 + than（相当于中文的「比」）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '短词 +er，长词 more',
      text: '单音节 +er（tall→taller）；多音节用 more（more expensive）。不规则：good→better，bad→worse。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他比我高。', answer: 'He is **taller** than me.'),
    CourseItem(prompt: '今天比昨天冷。', answer: 'Today is **colder** than yesterday.'),
    CourseItem(prompt: '这本书比那本更有意思。', answer: 'This book is more **interesting** than that one.'),
    CourseItem(prompt: '地铁比公交快。', answer: 'The underground is **faster** than the bus.'),
    CourseItem(prompt: '我的房间比你的大。', answer: 'My room is **bigger** than yours.'),
    CourseItem(prompt: '这家餐馆比那家好。', answer: 'This restaurant is **better** than that one.'),
    CourseItem(prompt: '英语比我想的容易。', answer: 'English is **easier** than I thought.'),
    CourseItem(prompt: '这条路比那条更危险。', answer: 'This road is more **dangerous** than that one.'),
    CourseItem(prompt: '他的中文比我的英语差。', answer: 'His Chinese is **worse** than my English.'),
    CourseItem(prompt: '夏天比冬天热。', answer: 'Summer is **hotter** than winter.'),
    CourseItem(prompt: '她比她姐姐年轻。', answer: 'She is **younger** than her sister.'),
    CourseItem(prompt: '这个问题比上一个更难。', answer: 'This question is more **difficult** than the last one.'),
    CourseItem(prompt: '我的手机比你的旧。', answer: 'My phone is **older** than yours.'),
    CourseItem(prompt: '今天的天气比昨天好。', answer: 'The weather today is **better** than yesterday.'),
    CourseItem(prompt: '坐飞机比坐火车贵。', answer: 'Flying is more **expensive** than taking the train.'),
  ],
);

final QuizContent zhEnA22Superlatives = zhEnFill(
  id: 'zh_en_a2_2_superlatives',
  title: '最高级：the -est / the most',
  intro: '三者以上的比较用最高级，前面几乎总是加 the。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚠️ 最高级前加 the（Z11）',
      text: '**the** tallest / **the** most expensive。不规则：good→the best，bad→the worst。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这是最好的餐厅。', answer: "It's the **best** restaurant."),
    CourseItem(prompt: '长江是中国最长的河。', answer: 'The Yangtze is the **longest** river in China.'),
    CourseItem(prompt: '他是班里最高的学生。', answer: 'He is the **tallest** student in the class.'),
    CourseItem(prompt: '这是最贵的一个。', answer: "It's the most **expensive** one."),
    CourseItem(prompt: '今天是最热的一天。', answer: "It's the **hottest** day."),
    CourseItem(prompt: '她是我最好的朋友。', answer: 'She is my **best** friend.'),
    CourseItem(prompt: '这是城里最古老的建筑。', answer: "It's the **oldest** building in the city."),
    CourseItem(prompt: '这是最漂亮的公园。', answer: "It's the most **beautiful** park."),
    CourseItem(prompt: '那是最糟糕的一天。', answer: 'That was the **worst** day.'),
    CourseItem(prompt: '他是队里最快的跑者。', answer: 'He is the **fastest** runner in the team.'),
    CourseItem(prompt: '这是我吃过的最好吃的菜。', answer: "It's the most **delicious** dish I have ever eaten."),
    CourseItem(prompt: '冬天是一年中最冷的季节。', answer: 'Winter is the **coldest** season of the year.'),
    CourseItem(prompt: '她是学校里最受欢迎的老师。', answer: 'She is the most **popular** teacher in the school.'),
    CourseItem(prompt: '这是最容易的办法。', answer: "It's the **easiest** way."),
    CourseItem(prompt: '那是我一生中最快乐的一天。', answer: 'That was the **happiest** day of my life.'),
  ],
);

final QuizContent zhEnA22ListenPlans = zhEnListen(
  id: 'zh_en_a2_2_listen_plans',
  title: '听力：Making plans',
  passageTitle: 'A phone message',
  passage:
      "Hi Sam, it's Kate. Are you free this Saturday? I'm going to have a small "
      'party at my flat. It starts at seven in the evening. Tom is going to '
      "bring some music and I'll cook some food. Can you bring some drinks? "
      'Please call me back and let me know. See you soon!',
  passageTranslation:
      '嗨 Sam，我是 Kate。这周六你有空吗？我打算在我家办一个小派对，晚上七点开始。'
      'Tom 会带些音乐来，我会做些吃的。你能带些饮料吗？请回个电话告诉我。回头见！',
  intro: '先听，再答题。留意 be going to 和时间地点。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '听将来计划',
      text: "I'm going to have a party、I'll cook——都是将来的安排。英式英语 flat = 公寓。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'When is the party?',
      options: ['Friday', 'Saturday evening', 'Sunday morning'],
      correctIndex: 1,
      questionTranslation: '派对什么时候？',
    ),
    ReadingQuestion(
      question: 'Where is it?',
      options: ["At Kate's flat", 'At a restaurant', "At Tom's"],
      correctIndex: 0,
      questionTranslation: '在哪里？',
    ),
    ReadingQuestion(
      question: 'What does Kate ask Sam to bring?',
      options: ['Food', 'Music', 'Drinks'],
      correctIndex: 2,
      questionTranslation: 'Kate 让 Sam 带什么？',
    ),
  ],
);

final QuizContent zhEnA22CountUncount = zhEnFill(
  id: 'zh_en_a2_2_count_uncount',
  title: '可数与不可数名词',
  intro: '英语名词分可数和不可数。不可数名词没有复数，也不用 a/an。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 不可数无复数（Z15）',
      text: 'information / water / money / advice / furniture 都不可数：别说 an information 或 advices。',
    ),
  ],
  items: const [
    CourseItem(prompt: '一些信息', answer: 'some **information**'),
    CourseItem(prompt: '三个苹果', answer: 'three **apples**'),
    CourseItem(prompt: '一些水', answer: 'some **water**'),
    CourseItem(prompt: '很多钱', answer: 'a lot of **money**'),
    CourseItem(prompt: '一些家具', answer: 'some **furniture**'),
    CourseItem(prompt: '很多书', answer: 'many **books**'),
    CourseItem(prompt: '一条建议（advice 不可数！）', answer: 'a piece of **advice**'),
    CourseItem(prompt: '两杯咖啡', answer: 'two **coffees**'),
    CourseItem(prompt: '一些米饭', answer: 'some **rice**'),
    CourseItem(prompt: '很多工作（不可数）', answer: 'a lot of **work**'),
    CourseItem(prompt: '一些新闻（news 不可数！）', answer: 'some **news**'),
    CourseItem(prompt: '两瓶果汁', answer: 'two bottles of **juice**'),
    CourseItem(prompt: '一些糖（不可数）', answer: 'some **sugar**'),
    CourseItem(prompt: '五个鸡蛋', answer: 'five **eggs**'),
    CourseItem(prompt: '一些音乐（不可数）', answer: 'some **music**'),
  ],
);

final QuizContent zhEnA22Quantifiers = zhEnFill(
  id: 'zh_en_a2_2_quantifiers',
  title: 'much / many / some / any',
  intro: '数量词要区分可数与不可数，还要看句子是肯定、否定还是疑问。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚠️ many 还是 much？（Z15）',
      text: 'many + 可数复数，much + 不可数；some 用于肯定，any 用于否定和疑问。',
    ),
  ],
  items: const [
    CourseItem(prompt: '你有多少钱？', answer: 'How **much** money do you have?'),
    CourseItem(prompt: '这里有多少人？', answer: 'How **many** people are here?'),
    CourseItem(prompt: '冰箱里有一些牛奶。', answer: 'There is **some** milk in the fridge.'),
    CourseItem(prompt: '有牛奶吗？', answer: 'Is there **any** milk?'),
    CourseItem(prompt: '我没有时间。', answer: "I don't have **any** time."),
    CourseItem(prompt: '我有很多朋友。', answer: 'I have a **lot** of friends.'),
    CourseItem(prompt: '他没有多少时间。', answer: "He doesn't have **much** time."),
    CourseItem(prompt: '你有问题吗？', answer: 'Do you have **any** questions?'),
    CourseItem(prompt: '我想要一些茶。', answer: 'I would like **some** tea.'),
    CourseItem(prompt: '你认识多少个单词？', answer: 'How **many** words do you know?'),
    CourseItem(prompt: '瓶子里没有多少水了。', answer: "There isn't **much** water in the bottle."),
    CourseItem(prompt: '要不要来点咖啡？（客气提议用 some）', answer: 'Would you like **some** coffee?'),
    CourseItem(prompt: '今天没有多少学生来。', answer: 'Not **many** students came today.'),
    CourseItem(prompt: '你包里有笔吗？', answer: 'Do you have **any** pens in your bag?'),
    CourseItem(prompt: '他花了太多钱。', answer: 'He spent too **much** money.'),
  ],
);

final QuizContent zhEnA22Partitives = zhEnFill(
  id: 'zh_en_a2_2_partitives',
  title: '部分词：a piece / a cup of …',
  intro: '要给不可数名词计数，就用「量词 + of」——这正是英语版的量词。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '量词 → 部分词（Z16）',
      text: '中文「三本书」的「本」在英语里对应 a piece of / a cup of / a pair of。用你已有的量词直觉。',
    ),
  ],
  items: const [
    CourseItem(prompt: '一块蛋糕', answer: 'a **piece** of cake'),
    CourseItem(prompt: '一杯茶', answer: 'a **cup** of tea'),
    CourseItem(prompt: '一双鞋', answer: 'a **pair** of shoes'),
    CourseItem(prompt: '一瓶水', answer: 'a **bottle** of water'),
    CourseItem(prompt: '一片面包', answer: 'a **slice** of bread'),
    CourseItem(prompt: '一条建议', answer: 'a **piece** of advice'),
    CourseItem(prompt: '一碗汤', answer: 'a **bowl** of soup'),
    CourseItem(prompt: '一杯（玻璃杯）水', answer: 'a **glass** of water'),
    CourseItem(prompt: '一盒巧克力', answer: 'a **box** of chocolates'),
    CourseItem(prompt: '一张纸', answer: 'a **sheet** of paper'),
    CourseItem(prompt: '一条面包', answer: 'a **loaf** of bread'),
    CourseItem(prompt: '一公斤苹果', answer: 'a **kilo** of apples'),
    CourseItem(prompt: '一罐可乐', answer: 'a **can** of cola'),
    CourseItem(prompt: '一条裤子（trousers 恒复数）', answer: 'a **pair** of trousers'),
    CourseItem(prompt: '一条好消息', answer: 'a **piece** of good news'),
  ],
);

final QuizContent zhEnA22ReadMarket = zhEnRead(
  id: 'zh_en_a2_2_read_market',
  title: '阅读：Shopping in the market',
  passageTitle: 'At the market',
  passage:
      'On Sunday morning, Anna went to the market. It was busy and full of '
      'colour. She bought some fresh vegetables, a kilo of apples, and a loaf '
      'of bread. The apples were cheaper than in the supermarket. She also '
      "wanted some cheese, but there wasn't any. At a small shop, she found a "
      'beautiful scarf and bought it as a present. She spent thirty pounds and '
      'walked home happily.',
  passageTranslation:
      '周日上午，Anna 去了市场。市场很热闹，五彩缤纷。她买了一些新鲜蔬菜、一公斤苹果和一条面包。'
      '这里的苹果比超市便宜。她还想买些奶酪，但没有了。在一家小店，她发现了一条漂亮的围巾，'
      '买下来当礼物。她花了三十英镑，高高兴兴地走回了家。',
  intro: '读一段逛市场的短文。留意可数/不可数名词和部分词。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '部分词与比较级',
      text: 'a kilo of apples、a loaf of bread；cheaper than（比…便宜）。英式货币 pounds。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What did Anna buy at the market?',
      options: ['Vegetables and fruit', 'Meat', 'A bike'],
      correctIndex: 0,
      questionTranslation: 'Anna 在市场买了什么？',
    ),
    ReadingQuestion(
      question: 'Were the apples cheap?',
      options: ['Yes, cheaper than the supermarket', 'No', 'The same price'],
      correctIndex: 0,
      questionTranslation: '苹果便宜吗？',
    ),
    ReadingQuestion(
      question: 'How much did she spend?',
      options: ['Thirteen pounds', 'Thirty pounds', 'Three pounds'],
      correctIndex: 1,
      questionTranslation: '她花了多少钱？',
    ),
  ],
);

final QuizContent zhEnA22Articles = zhEnFill(
  id: 'zh_en_a2_2_articles',
  title: '冠词复习：a / an / the',
  intro: '再练冠词：初次提到用 a/an，再次提到或双方都知道的用 the。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ a vs the（Z11）',
      text: 'a = 初次、众多之一；the = 我们都知道的那一个、独一无二（the sun）。泛指复数/不可数用零冠词。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我有一只狗。那只狗很友好。', answer: 'I have a dog. **The** dog is friendly.'),
    CourseItem(prompt: '太阳很亮。', answer: '**The** sun is bright.'),
    CourseItem(prompt: '她是一名医生。', answer: "She's **a** doctor."),
    CourseItem(prompt: '请关上门。', answer: 'Please close **the** door.'),
    CourseItem(prompt: '这是一个好主意。', answer: "It's **a** good idea."),
    CourseItem(prompt: '她会弹钢琴。', answer: 'She can play **the** piano.'),
    CourseItem(prompt: '我在车站等你。（我们都知道哪个车站）', answer: "I'll wait for you at **the** station."),
    CourseItem(prompt: '他买了一部新手机。', answer: 'He bought **a** new phone.'),
    CourseItem(prompt: '月亮今晚很圆。', answer: '**The** moon is full tonight.'),
    CourseItem(prompt: '她吃了一个鸡蛋。', answer: 'She ate **an** egg.'),
    CourseItem(prompt: '我昨天看了一部电影。那部电影很棒。', answer: 'I saw a film yesterday. **The** film was great.'),
    CourseItem(prompt: '你能打开窗户吗？（我们都知道哪扇）', answer: 'Can you open **the** window?'),
    CourseItem(prompt: '他一小时后到。', answer: 'He will arrive in **an** hour.'),
    CourseItem(prompt: '天空是蓝色的。（独一无二）', answer: '**The** sky is blue.'),
    CourseItem(prompt: '她住在一个小村庄里。', answer: 'She lives in **a** small village.'),
  ],
);

final QuizContent zhEnA22SpeakVowels = zhEnSpeak(
  id: 'zh_en_a2_2_speak_vowels',
  title: '发音：元音对立',
  intro: '英语元音有长短、松紧之分，中文没有。听清楚 sheep 和 ship 的区别。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 长短元音（Z6）',
      text: '/iː/（长）如 sheep ≠ /ɪ/（短）如 ship；/æ/ bad ≠ /e/ bed。读错元音会变成另一个词。',
    ),
  ],
  items: const [
    CourseItem(prompt: '/iː/ vs /ɪ/', answer: 'sheep – ship, eat – it, seat – sit'),
    CourseItem(prompt: '/æ/ vs /e/', answer: 'bad – bed, sat – set, man – men'),
    CourseItem(prompt: '/ɒ/ vs /əʊ/', answer: 'not – note, cost – coast'),
    CourseItem(prompt: '/ʌ/ 音', answer: 'cup, bus, lunch, love'),
    CourseItem(prompt: '一整句', answer: 'The ship has cheap sheep.'),
  ],
);

final QuizContent zhEnA22Describing = zhEnVocab(
  id: 'zh_en_a2_2_describing',
  title: '描述人和地方 · Adjectives',
  intro: '常用形容词。英语形容词放在名词前面。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '形容词语序',
      text: '多个形容词的顺序：观点 + 大小 + 年龄 + 颜色 + 名词（a beautiful old town）。',
    ),
  ],
  pairs: const [
    MapEntry('高的', 'tall'),
    MapEntry('矮的', 'short'),
    MapEntry('友好的', 'friendly'),
    MapEntry('安静的', 'quiet'),
    MapEntry('繁忙的', 'busy'),
    MapEntry('美丽的', 'beautiful'),
    MapEntry('古老的', 'old'),
    MapEntry('现代的', 'modern'),
    MapEntry('拥挤的', 'crowded'),
    MapEntry('昂贵的', 'expensive'),
  ],
);

final QuizContent zhEnA22DictShopping = zhEnDict(
  id: 'zh_en_a2_2_dict_shopping',
  title: '听写：Shopping & plans',
  intro: '听句子并打出来。注意冠词、复数和部分词。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 冠词与复数（Z11/Z15）',
      text: '写出 some / a、复数 -s，以及 a pair of 这样的部分词。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我需要一些苹果和面包。', answer: 'I need some apples and bread.'),
    CourseItem(prompt: '我们打算去看我父母。', answer: "We're going to visit my parents."),
    CourseItem(prompt: '她买了一双鞋。', answer: 'She bought a pair of shoes.'),
    CourseItem(prompt: '没有牛奶了。', answer: "There isn't any milk."),
    CourseItem(prompt: '明天会是晴天。', answer: 'It will be sunny tomorrow.'),
    CourseItem(prompt: '这家店比那家大。', answer: 'This shop is bigger than that one.'),
    CourseItem(prompt: '我正在等公交车。', answer: 'I am waiting for the bus.'),
    CourseItem(prompt: '他是班里最高的。', answer: 'He is the tallest in the class.'),
    CourseItem(prompt: '请给我一杯水。', answer: 'Please give me a glass of water.'),
    CourseItem(prompt: '他们打算买一套新房子。', answer: 'They are going to buy a new house.'),
    CourseItem(prompt: '我想要一块蛋糕。', answer: 'I would like a piece of cake.'),
    CourseItem(prompt: '孩子们正在花园里玩。', answer: 'The children are playing in the garden.'),
    CourseItem(prompt: '这是最便宜的一个。', answer: 'It is the cheapest one.'),
    CourseItem(prompt: '你有问题吗？', answer: 'Do you have any questions?'),
    CourseItem(prompt: '我会帮你拿包。', answer: 'I will help you with your bags.'),
  ],
);

final QuizContent zhEnA22ReadCity = zhEnRead(
  id: 'zh_en_a2_2_read_city',
  title: '阅读：City life vs country life',
  passageTitle: 'City or country?',
  passage:
      'Many people ask: is city life better than country life? In the city, '
      'there are more jobs, better shops, and lots of things to do. But cities '
      'are often noisy, crowded and expensive. In the country, life is quieter '
      'and cheaper. The air is cleaner and people are friendlier. However, '
      'there are fewer jobs and the shops are far away. In my opinion, the city '
      'is more exciting, but the country is more relaxing. The best place '
      'depends on the person.',
  passageTranslation:
      '很多人会问：城市生活比乡村生活好吗？在城市里，工作更多、商店更好、可做的事也多。'
      '但城市往往吵闹、拥挤、昂贵。在乡村，生活更安静、更便宜，空气更清新，人们更友好。'
      '不过工作机会更少，商店也远。在我看来，城市更令人兴奋，乡村更让人放松。'
      '最好的地方因人而异。',
  intro: '读一段比较城市与乡村生活的短文。留意各种比较级。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '比较级密集',
      text: 'more jobs, quieter, cheaper, cleaner, friendlier, fewer——注意 fewer 用于可数。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is good about the city?',
      options: ['More jobs and shops', 'Cleaner air', "It's quiet"],
      correctIndex: 0,
      questionTranslation: '城市有什么好处？',
    ),
    ReadingQuestion(
      question: 'What is good about the country?',
      options: ['More jobs', 'Cheaper and quieter', 'Better shops'],
      correctIndex: 1,
      questionTranslation: '乡村有什么好处？',
    ),
    ReadingQuestion(
      question: 'What does the writer think?',
      options: ['One is clearly best', 'It depends on the person', 'The country is bad'],
      correctIndex: 1,
      questionTranslation: '作者怎么看？',
    ),
  ],
);

/// A2.2 in chain order.
final List<QuizContent> zhEnA2_2 = [
  zhEnA22Continuous,
  zhEnA22GoingTo,
  zhEnA22Will,
  zhEnA22SpeakPlans,
  zhEnA22Comparatives,
  zhEnA22Superlatives,
  zhEnA22ListenPlans,
  zhEnA22CountUncount,
  zhEnA22SpeakingMid,
  zhEnA22Quantifiers,
  zhEnA22Partitives,
  zhEnA22ReadMarket,
  zhEnA22Articles,
  zhEnA22SpeakVowels,
  zhEnA22Describing,
  zhEnA22DictShopping,
  zhEnA22ReadCity,
  zhEnA22BigText,
  zhEnA22SpeakingClose,
];
