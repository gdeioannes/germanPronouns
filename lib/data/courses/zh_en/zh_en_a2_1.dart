import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';
import 'zh_en_extra_a.dart';

/// A2.1 — Past & Experiences · 过去与经历. Mandarin → English.
///
/// Big rock: the **past simple** (regular `-ed` + irregular, `was/were`,
/// `did/didn't`). Contrastive focus: the whole tense system (Z17 — Chinese marks
/// time with 了/过 + time words, not verb endings), time words at the END (Z21),
/// and voiced/voiceless `-ed` endings (Z7).

final QuizContent zhEnA21PastReg = zhEnFill(
  id: 'zh_en_a2_1_past_reg',
  title: '一般过去时：规则动词 -ed',
  intro: '英语用动词加 -ed 表示过去。中文靠「了」和时间词，动词本身不变——这是关键区别。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 过去 = 动词变形（Z17）',
      text: '中文「昨天我去」动词不变，英语必须变：I **worked**、I **studied**。时间在过去，动词就要变。',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '拼写',
      text: '一般加 -ed；-e 结尾加 -d（live→lived）；辅音+y → ied（study→studied）；重读闭音节双写（stop→stopped）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '昨天我学习了英语。', answer: 'I **studied** English yesterday.'),
    CourseItem(prompt: '她昨晚看了电视。', answer: 'She **watched** TV last night.'),
    CourseItem(prompt: '我们上周参观了博物馆。', answer: 'We **visited** a museum last week.'),
    CourseItem(prompt: '他们昨天踢了足球。', answer: 'They **played** football yesterday.'),
    CourseItem(prompt: '他两小时前到的。', answer: 'He **arrived** two hours ago.'),
    CourseItem(prompt: '她在门口停下了。', answer: 'She **stopped** at the door.'),
    CourseItem(prompt: '我昨晚给妈妈打了电话。', answer: 'I **called** my mother last night.'),
    CourseItem(prompt: '他在那家公司工作了两年。', answer: 'He **worked** at that company for two years.'),
    CourseItem(prompt: '我们昨天打扫了房间。', answer: 'We **cleaned** the room yesterday.'),
    CourseItem(prompt: '她打开了窗户。', answer: 'She **opened** the window.'),
    CourseItem(prompt: '我昨晚很早就睡了。（decide 规则变化）', answer: 'I **decided** to sleep early last night.'),
    CourseItem(prompt: '他们在公园里聊了很久。（chat → 双写）', answer: 'They **chatted** for a long time in the park.'),
    CourseItem(prompt: '她试穿了那条裙子。（try → ied）', answer: 'She **tried** on the dress.'),
    CourseItem(prompt: '音乐会八点开始。（start）', answer: 'The concert **started** at eight.'),
    CourseItem(prompt: '我们昨天帮助了一位老人。', answer: 'We **helped** an old man yesterday.'),
  ],
);

final QuizContent zhEnA21SpeakEd = zhEnSpeak(
  id: 'zh_en_a2_1_speak_ed',
  title: '发音：-ed 的三种读音',
  intro: '-ed 有三种读音，而且常被中国学习者漏读或都读成 /ɪd/。听清楚，读出来。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ /t/ /d/ /ɪd/（Z7）',
      text: '清辅音后读 /t/（worked）；浊辅音/元音后读 /d/（played）；只有 t/d 结尾才读 /ɪd/（wanted）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '-ed 读 /t/', answer: 'worked, watched, stopped, liked'),
    CourseItem(prompt: '-ed 读 /d/', answer: 'played, lived, opened, called'),
    CourseItem(prompt: '-ed 读 /ɪd/', answer: 'wanted, needed, visited, started'),
    CourseItem(prompt: '对比', answer: 'worked – wanted, played – started'),
    CourseItem(prompt: '一整句', answer: 'I watched a film and visited a friend.'),
  ],
);

final QuizContent zhEnA21PastIrreg = zhEnFill(
  id: 'zh_en_a2_1_past_irreg',
  title: '一般过去时：不规则动词',
  intro: '最常用的动词往往是不规则的，必须一个个背下来。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '高频不规则动词',
      text: 'go→went，have→had，see→saw，eat→ate，make→made，come→came，buy→bought，tell→told，get→got。',
    ),
  ],
  items: const [
    CourseItem(prompt: '昨天我去了学校。', answer: 'I **went** to school yesterday.'),
    CourseItem(prompt: '她昨晚有很多作业。', answer: 'She **had** a lot of homework.'),
    CourseItem(prompt: '我们看见了一个明星。', answer: 'We **saw** a film star.'),
    CourseItem(prompt: '他吃了三个苹果。', answer: 'He **ate** three apples.'),
    CourseItem(prompt: '我买了一本新书。', answer: 'I **bought** a new book.'),
    CourseItem(prompt: '他们来晚了。', answer: 'They **came** late.'),
    CourseItem(prompt: '她做了一个蛋糕。', answer: 'She **made** a cake.'),
    CourseItem(prompt: '他告诉了我这个消息。', answer: 'He **told** me the news.'),
    CourseItem(prompt: '我今天早上收到了一封信。', answer: 'I **got** a letter this morning.'),
    CourseItem(prompt: '我们坐了火车。', answer: 'We **took** the train.'),
    CourseItem(prompt: '我昨晚睡得很好。（sleep→slept）', answer: 'I **slept** well last night.'),
    CourseItem(prompt: '她给我写了一封长信。（write→wrote）', answer: 'She **wrote** me a long letter.'),
    CourseItem(prompt: '他们上周五离开了。（leave→left）', answer: 'They **left** last Friday.'),
    CourseItem(prompt: '我在车站遇见了她。（meet→met）', answer: 'I **met** her at the station.'),
    CourseItem(prompt: '他喝了两杯咖啡。（drink→drank）', answer: 'He **drank** two cups of coffee.'),
  ],
);

final QuizContent zhEnA21WasWere = zhEnFill(
  id: 'zh_en_a2_1_was_were',
  title: 'was / were（be 的过去式）',
  intro: 'be 动词的过去式：was（I/he/she/it）和 were（you/we/they）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '两个形式',
      text: 'I/he/she/it → **was**；you/we/they → **were**。否定：wasn\'t / weren\'t。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我昨天很累。', answer: 'I **was** tired yesterday.'),
    CourseItem(prompt: '他们上周在北京。', answer: 'They **were** in Beijing last week.'),
    CourseItem(prompt: '天气很好。', answer: 'The weather **was** nice.'),
    CourseItem(prompt: '你昨晚在家吗？', answer: '**Were** you at home last night?'),
    CourseItem(prompt: '电影不好看。', answer: "The film **wasn't** good."),
    CourseItem(prompt: '她小时候个子很小。', answer: 'She **was** small as a child.'),
    CourseItem(prompt: '我们迟到了。', answer: 'We **were** late.'),
    CourseItem(prompt: '街上没有人。', answer: 'There **were** no people in the street.'),
    CourseItem(prompt: '他昨天不在办公室。', answer: "He **wasn't** in the office yesterday."),
    CourseItem(prompt: '你们在哪儿？', answer: '**Where** were you?'),
    CourseItem(prompt: '考试很难。', answer: 'The exam **was** difficult.'),
    CourseItem(prompt: '孩子们昨天在学校吗？', answer: '**Were** the children at school yesterday?'),
    CourseItem(prompt: '门是开着的。', answer: 'The door **was** open.'),
    CourseItem(prompt: '商店里人不多。', answer: "There **weren't** many people in the shop."),
    CourseItem(prompt: '你小时候害羞吗？', answer: '**Were** you shy as a child?'),
  ],
);

final QuizContent zhEnA21Did = zhEnFill(
  id: 'zh_en_a2_1_did',
  title: '过去时的疑问与否定：did / didn\'t',
  intro: '过去时的疑问和否定要借助 did，主要动词回到原形。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ did + 原形（Z14）',
      text: 'Did you **go**? / I **didn\'t go**——did 已表示过去，主要动词用原形（不是 went）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '你昨天见到他了吗？', answer: '**Did** you see him yesterday?'),
    CourseItem(prompt: '我没去上班。', answer: "I **didn't** go to work."),
    CourseItem(prompt: '她昨晚给你打电话了吗？', answer: '**Did** she call you last night?'),
    CourseItem(prompt: '他们不喜欢那部电影。', answer: "They **didn't** like the film."),
    CourseItem(prompt: '你周末做什么了？', answer: 'What **did** you do at the weekend?'),
    CourseItem(prompt: '他昨天来了吗？', answer: '**Did** he come yesterday?'),
    CourseItem(prompt: '我们没看那场比赛。', answer: "We **didn't** watch the match."),
    CourseItem(prompt: '你们在哪儿吃的饭？', answer: 'Where **did** you eat?'),
    CourseItem(prompt: '她没买那条裙子。', answer: "She **didn't** buy the dress."),
    CourseItem(prompt: '你什么时候到的？', answer: 'When **did** you arrive?'),
    CourseItem(prompt: '你为什么没来？', answer: 'Why **didn\'t** you come?'),
    CourseItem(prompt: '他吃早饭了吗？', answer: '**Did** he have breakfast?'),
    CourseItem(prompt: '我昨晚没睡好。', answer: "I **didn't** sleep well last night."),
    CourseItem(prompt: '火车旅程花了多长时间？', answer: 'How long **did** the journey take?'),
    CourseItem(prompt: '她没告诉我她的名字。', answer: "She **didn't** tell me her name."),
  ],
);

final QuizContent zhEnA21ListenWeekend = zhEnListen(
  id: 'zh_en_a2_1_listen_weekend',
  title: '听力：My weekend',
  passageTitle: 'My weekend',
  passage:
      'Last weekend was great. On Saturday, I went to the park with my friends. '
      'We played football and had a picnic. In the evening, we watched a film. '
      'On Sunday, I stayed at home. I read a book and cooked dinner for my '
      'family. I didn\'t study, so today I\'m a bit busy!',
  passageTranslation:
      '上个周末很棒。周六我和朋友们去了公园。我们踢了足球，还野餐了。晚上我们看了一部电影。'
      '周日我待在家里，读了一本书，还给家人做了晚饭。我没学习，所以今天有点忙！',
  intro: '先听，再答题。留意所有的过去式动词。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '听过去式',
      text: 'went, played, had, watched, stayed, read, cooked——都是过去式。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What did they do on Saturday?',
      options: ['Went shopping', 'Played football', 'Studied'],
      correctIndex: 1,
      questionTranslation: '他们周六做了什么？',
    ),
    ReadingQuestion(
      question: 'What did the speaker do on Sunday?',
      options: ['Watched a film in the cinema', 'Stayed at home and cooked', 'Went to the park'],
      correctIndex: 1,
      questionTranslation: '说话人周日做了什么？',
    ),
    ReadingQuestion(
      question: 'Did the speaker study?',
      options: ['Yes', 'No', 'A lot'],
      correctIndex: 1,
      questionTranslation: '说话人学习了吗？',
    ),
  ],
);

final QuizContent zhEnA21TimeOrder = zhEnFill(
  id: 'zh_en_a2_1_time_order',
  title: '过去时间词与语序',
  intro: '英语把时间词放在**句尾**，而中文放在动词前。这是常见的语序错误。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 时间词放句尾（Z21）',
      text: '中文「我昨天去了」→ 英语 I went to Shanghai **yesterday**，不是 I yesterday went。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我昨天去了上海。', answer: 'I went to Shanghai **yesterday**.'),
    CourseItem(prompt: '她上周到的。', answer: 'She arrived last **week**.'),
    CourseItem(prompt: '他们两年前搬走了。', answer: 'They moved away two years **ago**.'),
    CourseItem(prompt: '我今天早上见到他了。', answer: 'I saw him this **morning**.'),
    CourseItem(prompt: '我们去年去了日本。', answer: 'We went to Japan last **year**.'),
    CourseItem(prompt: '他昨晚给我打了电话。', answer: 'He called me last **night**.'),
    CourseItem(prompt: '我三天前买了这本书。', answer: 'I bought this book three days **ago**.'),
    CourseItem(prompt: '她上个月开始了新工作。', answer: 'She started her new job last **month**.'),
    CourseItem(prompt: '我们昨天下午见了面。', answer: 'We met yesterday **afternoon**.'),
    CourseItem(prompt: '他一小时前离开了。', answer: 'He left an hour **ago**.'),
    CourseItem(prompt: '我们前天到的。（the day before yesterday）', answer: 'We arrived the day before **yesterday**.'),
    CourseItem(prompt: '她昨天晚上学习了英语。', answer: 'She studied English last **night**.'),
    CourseItem(prompt: '他们五分钟前出发了。', answer: 'They left five minutes **ago**.'),
    CourseItem(prompt: '我上周日见了我的祖父母。', answer: 'I saw my grandparents last **Sunday**.'),
    CourseItem(prompt: '我们今天下午买了菜。', answer: 'We bought vegetables this **afternoon**.'),
  ],
);

final QuizContent zhEnA21SpeakTrip = zhEnSpeak(
  id: 'zh_en_a2_1_speak_trip',
  title: '开口说：说说你的旅行',
  intro: '用过去时讲一次旅行。听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '讲故事用过去时',
      text: '整段都用过去式：was / went / visited。用 first, then, after that 串联。',
    ),
  ],
  items: const [
    CourseItem(prompt: '上个月我去了西安。', answer: "Last month, I went to Xi'an."),
    CourseItem(prompt: '我坐火车去的。', answer: 'I went there by train.'),
    CourseItem(prompt: '我参观了兵马俑。', answer: 'I visited the Terracotta Army.'),
    CourseItem(prompt: '天气很热。', answer: 'The weather was very hot.'),
    CourseItem(prompt: '食物很好吃。', answer: 'The food was delicious.'),
    CourseItem(prompt: '我玩得很开心。', answer: 'I had a great time.'),
  ],
);

final QuizContent zhEnA21ReadShanghai = zhEnRead(
  id: 'zh_en_a2_1_read_shanghai',
  title: '阅读：A weekend in Shanghai',
  passageTitle: 'A weekend in Shanghai',
  passage:
      'Last weekend, Wei visited Shanghai with his family. They arrived on '
      'Friday evening and stayed in a small hotel near the river. On Saturday, '
      'they walked along the Bund and took many photos. In the afternoon, they '
      'went shopping on Nanjing Road. Wei bought a present for his grandmother. '
      'On Sunday, they visited a museum and then took the train home. It was a '
      'busy but wonderful weekend.',
  passageTranslation:
      '上个周末，Wei 和家人游览了上海。他们周五晚上到达，住在江边一家小旅馆。周六他们'
      '沿着外滩散步，拍了很多照片。下午他们在南京路购物。Wei 给奶奶买了一份礼物。周日他们'
      '参观了一家博物馆，然后坐火车回家。这是一个忙碌但美好的周末。',
  intro: '读一段周末游记。留意不规则过去式（took, went, bought）。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '不规则动词',
      text: 'arrive→arrived（规则），但 take→took、go→went、buy→bought 是不规则的。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'When did they arrive?',
      options: ['Friday evening', 'Saturday morning', 'Sunday'],
      correctIndex: 0,
      questionTranslation: '他们什么时候到的？',
    ),
    ReadingQuestion(
      question: 'What did Wei buy?',
      options: ['A photo', 'A present', 'A hotel'],
      correctIndex: 1,
      questionTranslation: 'Wei 买了什么？',
    ),
    ReadingQuestion(
      question: 'How did they go home?',
      options: ['By train', 'By car', 'By plane'],
      correctIndex: 0,
      questionTranslation: '他们怎么回家的？',
    ),
  ],
);

final QuizContent zhEnA21Transport = zhEnVocab(
  id: 'zh_en_a2_1_transport',
  title: '交通与出行 · Transport',
  intro: '常见交通方式。说「乘坐某交通工具」用 by + 名词（不加冠词）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'by + 交通工具',
      text: 'by bus / by train / by car（不加 a/the）；但「步行」是 on foot。英式英语「地铁」= the underground / the tube。',
    ),
  ],
  pairs: const [
    MapEntry('公共汽车', 'bus'),
    MapEntry('地铁（英式）', 'underground'),
    MapEntry('出租车', 'taxi'),
    MapEntry('火车', 'train'),
    MapEntry('飞机', 'plane'),
    MapEntry('自行车', 'bike'),
    MapEntry('车站', 'station'),
    MapEntry('机场', 'airport'),
    MapEntry('船', 'boat'),
    MapEntry('摩托车', 'motorbike'),
  ],
);

final QuizContent zhEnA21Weather = zhEnVocab(
  id: 'zh_en_a2_1_weather',
  title: '天气与季节 · Weather',
  intro: '描述天气和四季。说天气用虚主语 It\'s …。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'It\'s + 天气（Z19）',
      text: '说天气要有主语 it：It\'s sunny / It\'s cold。英式英语「秋天」用 autumn（不是 fall）。',
    ),
  ],
  pairs: const [
    MapEntry('晴朗的', 'sunny'),
    MapEntry('下雨的', 'rainy'),
    MapEntry('多云的', 'cloudy'),
    MapEntry('刮风的', 'windy'),
    MapEntry('春天', 'spring'),
    MapEntry('夏天', 'summer'),
    MapEntry('秋天', 'autumn'),
    MapEntry('冬天', 'winter'),
    MapEntry('下雪的', 'snowy'),
    MapEntry('有雾的', 'foggy'),
  ],
);

final QuizContent zhEnA21Connectors = zhEnFill(
  id: 'zh_en_a2_1_connectors',
  title: '连词 because / so / but',
  intro: '用 because（因为）、so（所以）、but（但是）连接句子。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 一句一个连词（Z25）',
      text: '中文说「因为…所以…」，英语只能用一个：I was tired, **so** I left（不要再加 because）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我很累，所以早睡了。', answer: 'I was tired, **so** I went to bed early.'),
    CourseItem(prompt: '我没去，因为下雨了。', answer: "I didn't go **because** it rained."),
    CourseItem(prompt: '我想去，但我很忙。', answer: 'I wanted to go, **but** I was busy.'),
    CourseItem(prompt: '她饿了，所以做了饭。', answer: 'She was hungry, **so** she cooked.'),
    CourseItem(prompt: '他学习了，但没通过。', answer: "He studied, **but** he didn't pass."),
    CourseItem(prompt: '天冷，所以我们待在家里。', answer: 'It was cold, **so** we stayed at home.'),
    CourseItem(prompt: '她高兴，因为她通过了考试。', answer: 'She was happy **because** she passed the exam.'),
    CourseItem(prompt: '这家餐馆很好，但很贵。', answer: 'The restaurant was good, **but** expensive.'),
    CourseItem(prompt: '我迟到了，因为公交车没来。', answer: "I was late **because** the bus didn't come."),
    CourseItem(prompt: '他没带伞，所以淋湿了。', answer: "He didn't have an umbrella, **so** he got wet."),
    CourseItem(prompt: '我买了票，但把它忘在家里了。', answer: 'I bought the ticket, **but** I left it at home.'),
    CourseItem(prompt: '她很累，因为她工作到很晚。', answer: 'She was tired **because** she worked late.'),
    CourseItem(prompt: '火车晚点了，所以我们等了一个小时。', answer: 'The train was late, **so** we waited an hour.'),
    CourseItem(prompt: '他想买那辆车，但太贵了。', answer: 'He wanted to buy the car, **but** it was too expensive.'),
    CourseItem(prompt: '我们没出去，因为天气太冷。', answer: "We didn't go out **because** it was too cold."),
  ],
);

final QuizContent zhEnA21ListenTrip = zhEnListen(
  id: 'zh_en_a2_1_listen_trip',
  title: '听力：A short trip',
  passageTitle: 'A day trip',
  passage:
      'Yesterday, Mei took a day trip to a small town in the mountains. She '
      'left home early and took the bus. The journey took two hours. When she '
      'arrived, the weather was cold and windy. She walked around the old '
      'streets and had lunch in a small restaurant. She bought some local tea. '
      'In the afternoon, it started to rain, so she came home early.',
  passageTranslation:
      '昨天，Mei 去山里的一个小镇一日游。她一早就出发，坐了公交车，路上花了两个小时。'
      '到的时候天气又冷又刮风。她在古老的街道上走了走，在一家小餐馆吃了午饭，还买了一些当地的茶。'
      '下午下起了雨，所以她提前回家了。',
  intro: '先听，再答题。注意天气和原因。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '听 so 表原因结果',
      text: '…it started to rain, **so** she came home early——so 引出结果。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How did Mei travel?',
      options: ['By bus', 'By train', 'By car'],
      correctIndex: 0,
      questionTranslation: 'Mei 怎么去的？',
    ),
    ReadingQuestion(
      question: 'What was the weather like when she arrived?',
      options: ['Hot and sunny', 'Cold and windy', 'Warm'],
      correctIndex: 1,
      questionTranslation: '她到的时候天气怎么样？',
    ),
    ReadingQuestion(
      question: 'Why did she come home early?',
      options: ['It rained', 'She was tired', 'It was late'],
      correctIndex: 0,
      questionTranslation: '她为什么提前回家？',
    ),
  ],
);

final QuizContent zhEnA21DictWeekend = zhEnDict(
  id: 'zh_en_a2_1_dict_weekend',
  title: '听写：Last weekend',
  intro: '听句子并打出来。重点是过去式的 -ed 和不规则动词。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 写出过去式（Z17）',
      text: '注意 -ed（watched, played, visited）和不规则（went）——别写成原形。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我去了公园。', answer: 'I went to the park.'),
    CourseItem(prompt: '她看了一部电影。', answer: 'She watched a film.'),
    CourseItem(prompt: '我们踢了足球。', answer: 'We played football.'),
    CourseItem(prompt: '他们参观了一家博物馆。', answer: 'They visited a museum.'),
    CourseItem(prompt: '天气很冷。', answer: 'It was very cold.'),
    CourseItem(prompt: '我没有学习。', answer: "I didn't study."),
    CourseItem(prompt: '他买了一份礼物。', answer: 'He bought a present.'),
    CourseItem(prompt: '我们坐火车回家的。', answer: 'We took the train home.'),
    CourseItem(prompt: '你昨天见到她了吗？', answer: 'Did you see her yesterday?'),
    CourseItem(prompt: '他们上周在上海。', answer: 'They were in Shanghai last week.'),
    CourseItem(prompt: '我昨晚给她打了电话。', answer: 'I called her last night.'),
    CourseItem(prompt: '她做了一个蛋糕。', answer: 'She made a cake.'),
    CourseItem(prompt: '我们没看那部电影。', answer: "We didn't watch that film."),
    CourseItem(prompt: '他一小时前离开了。', answer: 'He left an hour ago.'),
    CourseItem(prompt: '你去哪儿了？', answer: 'Where did you go?'),
  ],
);

final QuizContent zhEnA21ReadAbroad = zhEnRead(
  id: 'zh_en_a2_1_read_abroad',
  title: '阅读：Lin\'s first week abroad',
  passageTitle: "Lin's first week",
  passage:
      'Lin moved to London last month to study English. Her first week was '
      'difficult. On the first day, she got lost and arrived late for class. '
      'The weather was cold and grey, and she missed her family. But things '
      'soon got better. She made new friends from many countries. They cooked '
      'dinner together and practised English. By the end of the week, Lin felt '
      'happy. "London is my new home," she thought.',
  passageTranslation:
      'Lin 上个月搬到伦敦学英语。她的第一周很艰难。第一天她迷了路，上课迟到了。天气又冷又阴，'
      '她很想家。但情况很快好转了。她结识了来自许多国家的新朋友。他们一起做饭、练习英语。'
      '到那周结束时，Lin 感到很快乐。「伦敦是我的新家。」她心想。',
  intro: '读一段关于适应海外生活的短文。全篇用过去时叙述。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '过去式叙事',
      text: 'moved, was, got, arrived, missed, made——注意 got better（变得更好）。英式拼写 grey。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Why did Lin move to London?',
      options: ['To study English', 'To work', 'For a holiday'],
      correctIndex: 0,
      questionTranslation: 'Lin 为什么搬到伦敦？',
    ),
    ReadingQuestion(
      question: 'How did she feel in the first week?',
      options: ['Happy', 'Homesick and it was difficult', 'Bored'],
      correctIndex: 1,
      questionTranslation: '她第一周感觉怎么样？',
    ),
    ReadingQuestion(
      question: 'What made things better?',
      options: ['New friends', 'Good weather', 'More money'],
      correctIndex: 0,
      questionTranslation: '是什么让情况好转的？',
    ),
  ],
);

/// A2.1 in chain order.
final List<QuizContent> zhEnA2_1 = [
  zhEnA21PastReg,
  zhEnA21SpeakEd,
  zhEnA21PastIrreg,
  zhEnA21WasWere,
  zhEnA21Did,
  zhEnA21ListenWeekend,
  zhEnA21TimeOrder,
  zhEnA21SpeakTrip,
  zhEnA21SpeakingMid,
  zhEnA21ReadShanghai,
  zhEnA21Transport,
  zhEnA21Weather,
  zhEnA21Connectors,
  zhEnA21ListenTrip,
  zhEnA21DictWeekend,
  zhEnA21ReadAbroad,
  zhEnA21BigText,
  zhEnA21SpeakingClose,
];
