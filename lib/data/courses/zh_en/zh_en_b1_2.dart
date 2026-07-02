import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// B1.2 — Narratives & Conditions · 叙述与条件. Mandarin → English.
///
/// Big rock: past continuous vs simple, 0/1st conditionals, and **relative
/// clauses AFTER the noun** (Z23 — Chinese modifiers precede with 的). Also verb
/// + gerund/infinitive (Z26), phrasal verbs (Z30), connected speech (Z10).

final QuizContent zhEnB12PastCont = zhEnFill(
  id: 'zh_en_b1_2_past_cont',
  title: '过去进行时',
  intro: '过去进行时（was/were + V-ing）表示过去某个时刻正在进行的动作，常作背景。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'was/were + V-ing',
      text: '强调「当时正在进行」：At eight, I was **watching** TV。常和 while 连用。',
    ),
  ],
  items: const [
    CourseItem(prompt: '昨晚八点我在看电视。', answer: 'I was **watching** TV at eight last night.'),
    CourseItem(prompt: '他们当时在踢足球。', answer: 'They were **playing** football.'),
    CourseItem(prompt: '当时在下雨。', answer: 'It was **raining**.'),
    CourseItem(prompt: '你当时在做什么？', answer: 'What were you **doing**?'),
    CourseItem(prompt: '孩子们在花园里玩。', answer: 'The children were **playing** in the garden.'),
  ],
);

final QuizContent zhEnB12PastVsCont = zhEnFill(
  id: 'zh_en_b1_2_past_vs_cont',
  title: '过去式 vs 过去进行时',
  intro: '长的背景动作用过去进行时，突然打断的短动作用过去式。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'while + 进行，when + 过去',
      text: 'while I **was having** a shower（背景），the phone **rang**（打断）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我洗澡时电话响了。', answer: 'The phone rang while I was **having** a shower.'),
    CourseItem(prompt: '他到的时候我们正在吃饭。', answer: 'When he arrived, we were **having** dinner.'),
    CourseItem(prompt: '她走路时摔倒了。', answer: 'She **fell** while she was walking.'),
    CourseItem(prompt: '我做饭时切到了手指。', answer: 'I cut my finger while I was **cooking**.'),
    CourseItem(prompt: '我们出门时下起了雨。', answer: 'It started to rain when we **left**.'),
  ],
);

final QuizContent zhEnB12SpeakStory = zhEnSpeak(
  id: 'zh_en_b1_2_speak_story',
  title: '开口说：讲一个故事',
  intro: '用过去时讲一个小故事。听并跟读，注意用连接词串起来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '讲故事的框架',
      text: 'One day… / Suddenly… / So… / After a while… / In the end… 让故事有条理。',
    ),
  ],
  items: const [
    CourseItem(prompt: '有一天，我在公园散步。', answer: 'One day, I was walking in the park.'),
    CourseItem(prompt: '突然，开始下雨了。', answer: 'Suddenly, it started to rain.'),
    CourseItem(prompt: '我没带伞。', answer: "I didn't have an umbrella."),
    CourseItem(prompt: '所以我跑到一棵树下。', answer: 'So I ran under a tree.'),
    CourseItem(prompt: '过了一会儿，雨停了。', answer: 'After a while, the rain stopped.'),
  ],
);

final QuizContent zhEnB12Cond0 = zhEnFill(
  id: 'zh_en_b1_2_cond0',
  title: '零条件句（普遍真理）',
  intro: '零条件句讲永远成立的事实或规律，if 和主句都用一般现在时。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'if + 现在, 现在',
      text: 'If you heat water, it **boils**。两边都用一般现在时。',
    ),
  ],
  items: const [
    CourseItem(prompt: '如果加热水，它会沸腾。', answer: 'If you **heat** water, it boils.'),
    CourseItem(prompt: '如果不下雨，植物就会死。', answer: "If it doesn't rain, plants **die**."),
    CourseItem(prompt: '按这个键，灯就会亮。', answer: 'If you **press** this button, the light comes on.'),
    CourseItem(prompt: '冰受热会融化。', answer: 'Ice melts if you **heat** it.'),
    CourseItem(prompt: '我累了就会早睡。', answer: 'If I **am** tired, I go to bed early.'),
  ],
);

final QuizContent zhEnB12Cond1 = zhEnFill(
  id: 'zh_en_b1_2_cond1',
  title: '第一条件句（真实将来）',
  intro: '第一条件句讲将来可能发生的真实情况。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ if 从句用现在时（Z28）',
      text: 'If it **rains**, I\'ll stay（不是 if it will rain）。if 从句里用现在时表将来，主句用 will。',
    ),
  ],
  items: const [
    CourseItem(prompt: '如果明天下雨，我就待在家。', answer: "If it **rains** tomorrow, I'll stay at home."),
    CourseItem(prompt: '你努力学习就会通过。', answer: 'If you study hard, you **will** pass.'),
    CourseItem(prompt: '如果我有时间，就给你打电话。', answer: "If I **have** time, I'll call you."),
    CourseItem(prompt: '你不快点就会迟到。', answer: "You'll be late if you **don't** hurry."),
    CourseItem(prompt: '如果她来，我们就开始。', answer: "If she **comes**, we'll start."),
  ],
);

final QuizContent zhEnB12ListenAnnounce = zhEnListen(
  id: 'zh_en_b1_2_listen_announce',
  title: '听力：An announcement',
  passageTitle: 'At the station',
  passage:
      "Good morning, passengers. This is an announcement for the ten o'clock "
      'train to Manchester. We are sorry to inform you that this train is '
      'delayed by thirty minutes. The train will now leave from platform four, '
      'not platform two. Passengers travelling to Liverpool should change at '
      'Manchester. Thank you for your patience, and we apologise for any '
      'inconvenience.',
  passageTranslation:
      '各位乘客早上好。这是十点开往曼彻斯特列车的通知。很抱歉地通知您，本次列车晚点三十分钟。'
      '列车现将从四号站台发车，而不是二号站台。前往利物浦的乘客请在曼彻斯特换乘。'
      '感谢您的耐心，对由此带来的不便我们深表歉意。',
  intro: '先听，再答题。车站广播语速偏快，抓住关键信息。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '广播用语',
      text: 'delayed（晚点）、platform（站台）、change at（换乘）。英式拼写 apologise。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where is the train going?',
      options: ['Manchester', 'London', 'Liverpool'],
      correctIndex: 0,
      questionTranslation: '列车开往哪里？',
    ),
    ReadingQuestion(
      question: 'Why is there a problem?',
      options: ['The train is delayed', "It's cancelled", "It's early"],
      correctIndex: 0,
      questionTranslation: '出了什么问题？',
    ),
    ReadingQuestion(
      question: 'Which platform will the train leave from?',
      options: ['Platform two', 'Platform four', 'Platform ten'],
      correctIndex: 1,
      questionTranslation: '列车从几号站台发车？',
    ),
  ],
);

final QuizContent zhEnB12Relative = zhEnFill(
  id: 'zh_en_b1_2_relative',
  title: '定语从句：who / which / that',
  intro: '定语从句用来修饰名词。英语把它放在名词**后面**，中文用「的」放在前面。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 描述挂在名词后（Z23）',
      text: '中文「我买的书」修饰语在前；英语 the book **that I bought** 放后面。人用 who，物用 which/that。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这是那个帮我的人。', answer: 'This is the man **who** helped me.'),
    CourseItem(prompt: '我买的那本书很有意思。', answer: 'The book **that** I bought is interesting.'),
    CourseItem(prompt: '住在隔壁的女人是医生。', answer: 'The woman **who** lives next door is a doctor.'),
    CourseItem(prompt: '这是拍这张照片的相机。', answer: 'This is the camera **which** took the photo.'),
    CourseItem(prompt: '会说三种语言的人很少。', answer: 'People **who** speak three languages are rare.'),
  ],
);

final QuizContent zhEnB12Relative2 = zhEnFill(
  id: 'zh_en_b1_2_relative2',
  title: '定语从句：where / whose',
  intro: 'where 引导地点，whose 表示所属（谁的）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'where = 地点, whose = 所属',
      text: 'the town **where** I was born（我出生的城镇）；the girl **whose** father is a pilot（爸爸是飞行员的女孩）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这是我出生的城镇。', answer: 'This is the town **where** I was born.'),
    CourseItem(prompt: '丢了钱包的男人很生气。', answer: 'The man **whose** wallet was lost was angry.'),
    CourseItem(prompt: '这是我们初次见面的餐厅。', answer: 'This is the restaurant **where** we first met.'),
    CourseItem(prompt: '我认识一个女孩，她爸爸是飞行员。', answer: 'I know a girl **whose** father is a pilot.'),
    CourseItem(prompt: '那是我工作的办公室。', answer: 'That is the office **where** I work.'),
  ],
);

final QuizContent zhEnB12ReadAnecdote = zhEnRead(
  id: 'zh_en_b1_2_read_anecdote',
  title: '阅读：A true anecdote',
  passageTitle: 'The lost dog',
  passage:
      'A few years ago, something strange happened to my uncle. He was driving '
      'home late one night when he saw a dog in the middle of the road. He '
      'stopped the car and got out. The dog looked frightened, so my uncle put '
      'it in his car and took it home. The next morning, he put up signs in the '
      'neighbourhood. A week later, a little girl who had lost her dog knocked '
      'on the door. She was crying with happiness. My uncle, who loves animals, '
      'was very glad to help. It is a story that our family still tells today.',
  passageTranslation:
      '几年前，我叔叔遇到了一件奇怪的事。一天深夜他开车回家，看见路中间有一只狗。他停下车'
      '下来。那只狗看起来很害怕，于是叔叔把它抱进车里带回了家。第二天早上，他在小区里贴了'
      '寻主启事。一周后，一个丢了狗的小女孩敲响了门，她高兴得哭了。爱护动物的叔叔非常乐意'
      '帮忙。这是一个我们家至今还常讲的故事。',
  intro: '读一个真实的小故事。留意过去进行时的背景和定语从句。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '背景 + 定语从句',
      text: 'was driving…when he saw（背景+打断）；a girl **who had lost** her dog（定语从句）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What did the uncle find?',
      options: ['A dog', 'A girl', 'A car'],
      correctIndex: 0,
      questionTranslation: '叔叔发现了什么？',
    ),
    ReadingQuestion(
      question: 'What did he do the next morning?',
      options: ['Put up signs', 'Called the police', 'Kept the dog'],
      correctIndex: 0,
      questionTranslation: '第二天早上他做了什么？',
    ),
    ReadingQuestion(
      question: 'Who came to the door?',
      options: ['A little girl', 'A policeman', 'A neighbour'],
      correctIndex: 0,
      questionTranslation: '谁来敲门了？',
    ),
  ],
);

final QuizContent zhEnB12Gerund = zhEnFill(
  id: 'zh_en_b1_2_gerund',
  title: '动词 + 动名词',
  intro: '有些动词后面要用动名词（-ing），必须记住哪些。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 用 -ing 的动词（Z26）',
      text: 'enjoy / finish / mind / give up / keep + V-ing。中文动词直接叠加，英语要选对形式。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我喜欢游泳。', answer: 'I enjoy **swimming**.'),
    CourseItem(prompt: '她做完了作业。', answer: 'She finished **doing** her homework.'),
    CourseItem(prompt: '你介意开窗吗？', answer: 'Do you mind **opening** the window?'),
    CourseItem(prompt: '我戒烟了。', answer: 'I gave up **smoking**.'),
    CourseItem(prompt: '他不停地说话。', answer: 'He kept **talking**.'),
  ],
);

final QuizContent zhEnB12Infinitive = zhEnFill(
  id: 'zh_en_b1_2_infinitive',
  title: '动词 + 不定式',
  intro: '另一些动词后面要用不定式（to + 原形）。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 用 to 的动词（Z26）',
      text: 'want / decide / plan / hope / need + to + 原形。这些动词后不能用 -ing。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我想学英语。', answer: 'I want **to learn** English.'),
    CourseItem(prompt: '她决定出国。', answer: 'She decided **to go** abroad.'),
    CourseItem(prompt: '我们计划早点出发。', answer: 'We plan **to leave** early.'),
    CourseItem(prompt: '他希望成功。', answer: 'He hopes **to succeed**.'),
    CourseItem(prompt: '我需要休息。', answer: 'I need **to rest**.'),
  ],
);

final QuizContent zhEnB12Phrasal = zhEnFill(
  id: 'zh_en_b1_2_phrasal',
  title: '短语动词（入门）',
  intro: '短语动词由「动词 + 小品词」构成，意思常常不能从字面猜出。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 成组记（Z30）',
      text: 'turn on = 打开，look for = 寻找，give up = 放弃，take off = 起飞。中文没有这种结构，要整组背。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我七点起床。', answer: 'I **get** up at seven.'),
    CourseItem(prompt: '请把灯打开。', answer: 'Please **turn** on the light.'),
    CourseItem(prompt: '我在找我的钥匙。', answer: "I'm **looking** for my keys."),
    CourseItem(prompt: '飞机起飞了。', answer: 'The plane **took** off.'),
    CourseItem(prompt: '别放弃！', answer: "Don't **give** up!"),
  ],
);

final QuizContent zhEnB12SpeakLinking = zhEnSpeak(
  id: 'zh_en_b1_2_speak_linking',
  title: '发音：句重音与连读',
  intro: '英语把词连在一起读——连读、弱读、缩略。这让语流听起来自然。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 把词连起来（Z10）',
      text: '辅音+元音连读（an apple → a-napple）；功能词弱读（fish and chips）。别一个词一个词地蹦。',
    ),
  ],
  items: const [
    CourseItem(prompt: '实词重读', answer: 'I WANT to GO to the CInema.'),
    CourseItem(prompt: '连读', answer: 'an apple, pick it up, turn it on'),
    CourseItem(prompt: '弱读', answer: 'fish and chips, a cup of tea'),
    CourseItem(prompt: '缩略', answer: "I'm going to call you."),
    CourseItem(prompt: '一整句', answer: 'What are you going to do at the weekend?'),
  ],
);

final QuizContent zhEnB12ListenStory = zhEnListen(
  id: 'zh_en_b1_2_listen_story',
  title: '听力：A short story',
  passageTitle: 'The message in a bottle',
  passage:
      'When Emma was a child, she lived in a small village by the sea. Every '
      'summer, she would spend the whole day on the beach. One afternoon, while '
      'she was building a sandcastle, she found an old bottle. Inside the '
      'bottle, there was a piece of paper with a message. It was a letter from '
      'a boy in another country. Emma wrote back, and they became friends by '
      'letter for many years. She still keeps that first message today.',
  passageTranslation:
      'Emma 小时候住在海边一个小村庄。每年夏天，她都会在沙滩上玩一整天。一天下午，'
      '她堆沙堡时发现了一个旧瓶子。瓶子里有一张写着字的纸——那是另一个国家的一个男孩写的信。'
      'Emma 回了信，他们通过书信做了很多年的朋友。直到今天，她还保存着那第一封信。',
  intro: '先听，再答题。注意过去进行时作背景。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '背景动作',
      text: 'while she was building a sandcastle（背景），she found a bottle（发生的事）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where did Emma live as a child?',
      options: ['By the sea', 'In a big city', 'In the mountains'],
      correctIndex: 0,
      questionTranslation: 'Emma 小时候住在哪里？',
    ),
    ReadingQuestion(
      question: 'What did she find on the beach?',
      options: ['A bottle with a message', 'Money', 'A shell'],
      correctIndex: 0,
      questionTranslation: '她在沙滩上发现了什么？',
    ),
    ReadingQuestion(
      question: 'What happened next?',
      options: ['She made a friend by letter', 'She moved away', 'She lost it'],
      correctIndex: 0,
      questionTranslation: '后来发生了什么？',
    ),
  ],
);

final QuizContent zhEnB12DictChildhood = zhEnDict(
  id: 'zh_en_b1_2_dict_childhood',
  title: '听写：A childhood memory',
  intro: '听句子并打出来。注意过去进行时、定语从句和动名词。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 写出结构',
      text: '注意 was/were + -ing，who/that 引导的从句，以及 -ing 动名词。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我小时候住在一个村子里。', answer: 'When I was young, I lived in a village.'),
    CourseItem(prompt: '我们当时在外面玩。', answer: 'We were playing outside.'),
    CourseItem(prompt: '开始下雨了。', answer: 'It started to rain.'),
    CourseItem(prompt: '我永远不会忘记那一天。', answer: 'I will never forget that day.'),
    CourseItem(prompt: '她喜欢读书。', answer: 'She enjoyed reading books.'),
    CourseItem(prompt: '帮助我们的那个人很善良。', answer: 'The man who helped us was kind.'),
  ],
);

final QuizContent zhEnB12ReadCity = zhEnRead(
  id: 'zh_en_b1_2_read_city',
  title: '阅读：Protecting our city',
  passageTitle: 'The river project',
  passage:
      'Last year, a group of students in our city started a project to protect '
      'the environment. They noticed that the river, which runs through the '
      'city, was full of rubbish. Every weekend, they met by the river and '
      'cleaned it. At first, only ten students came, but soon hundreds of '
      'people joined. The local council, which was impressed by their work, '
      'gave them money for equipment. Today, the river is clean, and fish have '
      'returned. "If everyone helps," the leader said, "we can make a real '
      'difference."',
  passageTranslation:
      '去年，我们城市的一群学生发起了一个保护环境的项目。他们注意到穿过城市的那条河里'
      '满是垃圾。每个周末，他们都在河边清理。起初只有十名学生参加，但很快就有数百人加入。'
      '当地议会对他们的工作印象深刻，出资购买了设备。如今，河水变干净了，鱼也回来了。'
      '带头的学生说：「只要人人出力，我们就能带来真正的改变。」',
  intro: '读一段环保故事。留意非限定定语从句和第一条件句。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '从句 + 条件句',
      text: 'the river, **which runs through the city**（补充信息）；If everyone helps, we can…（真实条件）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What problem did the students notice?',
      options: ['The river was full of rubbish', 'No trees', 'Dirty air'],
      correctIndex: 0,
      questionTranslation: '学生们注意到什么问题？',
    ),
    ReadingQuestion(
      question: 'What did the council do?',
      options: ['Gave them money', 'Stopped them', 'Did nothing'],
      correctIndex: 0,
      questionTranslation: '议会做了什么？',
    ),
    ReadingQuestion(
      question: 'What is the result?',
      options: ['The river is clean and fish returned', 'Nothing changed', 'It got worse'],
      correctIndex: 0,
      questionTranslation: '结果如何？',
    ),
  ],
);

/// B1.2 in chain order.
final List<QuizContent> zhEnB1_2 = [
  zhEnB12PastCont,
  zhEnB12PastVsCont,
  zhEnB12SpeakStory,
  zhEnB12Cond0,
  zhEnB12Cond1,
  zhEnB12ListenAnnounce,
  zhEnB12Relative,
  zhEnB12Relative2,
  zhEnB12ReadAnecdote,
  zhEnB12Gerund,
  zhEnB12Infinitive,
  zhEnB12Phrasal,
  zhEnB12SpeakLinking,
  zhEnB12ListenStory,
  zhEnB12DictChildhood,
  zhEnB12ReadCity,
];
