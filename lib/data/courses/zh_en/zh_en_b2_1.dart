import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// B2.1 — Opinions & Hypotheses · 观点与假设. Mandarin → English.
///
/// Big rock: **2nd & 3rd conditionals + wish** (Z28 — Chinese conditionals don't
/// change tense/mood) and the **passive voice** (Z27 — Chinese 被 is narrower).
/// Also present perfect continuous (Z18), reported speech (Z29 intro), argument
/// connectors (Z25/Z31).

final QuizContent zhEnB21Cond2 = zhEnFill(
  id: 'zh_en_b2_1_cond2',
  title: '第二条件句（现在的假设）',
  intro: '第二条件句讲现在或将来不太可能/不真实的假设。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 退一步 = 非真实（Z28）',
      text: 'if + 过去式, would + 原形。be 常用 were（If I **were** you）。中文不改时态，英语要「退一步」。',
    ),
  ],
  items: const [
    CourseItem(prompt: '如果我有钱，我就买房子。', answer: 'If I **had** money, I would buy a house.'),
    CourseItem(prompt: '如果我是你，我就接受。', answer: 'If I **were** you, I would accept.'),
    CourseItem(prompt: '如果她更努力，就会成功。', answer: 'If she tried harder, she **would** succeed.'),
    CourseItem(prompt: '如果我会飞，我就周游世界。', answer: 'If I **could** fly, I would travel the world.'),
    CourseItem(prompt: '如果我们赢了，我们就庆祝。', answer: 'If we **won**, we would celebrate.'),
    CourseItem(prompt: '如果他住得近一些，我们会常见面。', answer: 'If he **lived** closer, we would meet more often.'),
    CourseItem(prompt: '如果我认识她，我就把你介绍给她。', answer: 'If I **knew** her, I would introduce you.'),
    CourseItem(prompt: '如果没有手机，生活会很不一样。', answer: 'If there were no phones, life **would** be very different.'),
    CourseItem(prompt: '如果你有一百万，你会做什么？', answer: 'What **would** you do if you had a million?'),
    CourseItem(prompt: '如果天气暖和些，我们就去海边。', answer: 'If it **were** warmer, we would go to the beach.'),
    CourseItem(prompt: '如果我不用上班，我就天天读书。', answer: "If I **didn't** have to work, I would read every day."),
    CourseItem(prompt: '如果她说英语，就能得到那份工作。', answer: 'If she **spoke** English, she would get the job.'),
    CourseItem(prompt: '如果我们住在乡下，就会养一只狗。', answer: 'If we **lived** in the countryside, we would have a dog.'),
    CourseItem(prompt: '如果他不那么忙，就会多陪家人。', answer: 'If he **weren\'t** so busy, he would spend more time with his family.'),
    CourseItem(prompt: '如果你能见任何名人，你会见谁？', answer: 'Who **would** you meet if you could meet anyone famous?'),
  ],
);

final QuizContent zhEnB21Cond3 = zhEnFill(
  id: 'zh_en_b2_1_cond3',
  title: '第三条件句（过去的假设）',
  intro: '第三条件句讲过去与事实相反的假设——本可以发生但没发生的事。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 退两步 = 过去非真实（Z28）',
      text: 'if + had + V3, would have + V3。表示对过去的懊悔或假设。',
    ),
  ],
  items: const [
    CourseItem(prompt: '如果我早知道，我就会帮你。', answer: 'If I **had known**, I would have helped you.'),
    CourseItem(prompt: '如果她学习了，就会通过。', answer: 'If she had studied, she would **have** passed.'),
    CourseItem(prompt: '如果早点出发，就不会迟到。', answer: "If we had left earlier, we **wouldn't** have been late."),
    CourseItem(prompt: '如果你告诉我，我就来了。', answer: 'If you had told me, I **would** have come.'),
    CourseItem(prompt: '要是没下雨，我们就去了。', answer: "If it hadn't rained, we would have **gone**."),
    CourseItem(prompt: '如果他抓紧时间，就赶上火车了。', answer: 'If he had hurried, he **would** have caught the train.'),
    CourseItem(prompt: '如果我看到你，我就打招呼了。', answer: 'If I **had seen** you, I would have said hello.'),
    CourseItem(prompt: '如果她带了地图，就不会迷路了。', answer: "If she had taken a map, she **wouldn't** have got lost."),
    CourseItem(prompt: '如果我们订了票，就能进去了。', answer: 'If we had booked tickets, we would **have** got in.'),
    CourseItem(prompt: '要是我早点起床，就不会误机了。', answer: "If I had got up earlier, I **wouldn't** have missed the flight."),
    CourseItem(prompt: '如果你听了我的话，就不会有这个问题。', answer: 'If you **had listened** to me, there would have been no problem.'),
    CourseItem(prompt: '要是她带了手机，就能给我们打电话了。', answer: 'If she had taken her phone, she **could** have called us.'),
    CourseItem(prompt: '如果我们早点订酒店，就更便宜了。', answer: 'If we had booked the hotel earlier, it **would** have been cheaper.'),
    CourseItem(prompt: '要是他没生病，就参加比赛了。', answer: "If he **hadn't** been ill, he would have taken part in the match."),
    CourseItem(prompt: '如果你当时在场，你会怎么做？', answer: 'What **would** you have done if you had been there?'),
  ],
);

final QuizContent zhEnB21Wish = zhEnFill(
  id: 'zh_en_b2_1_wish',
  title: 'wish / if only',
  intro: 'wish 表达与现实相反的愿望或遗憾。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'wish 的时态',
      text: 'wish + 过去式（现在的遗憾：I wish I **were**…）；wish + had + V3（过去的遗憾：I wish I **hadn\'t**…）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我希望我更高。', answer: 'I wish I **were** taller.'),
    CourseItem(prompt: '要是我会西班牙语就好了。', answer: 'I wish I **could** speak Spanish.'),
    CourseItem(prompt: '真希望我没说那句话。', answer: "I wish I **hadn't** said that."),
    CourseItem(prompt: '要是他在这儿就好了。', answer: 'If only he **were** here.'),
    CourseItem(prompt: '我希望雨能停。', answer: 'I wish it **would** stop raining.'),
    CourseItem(prompt: '我希望我住在海边。', answer: 'I wish I **lived** by the sea.'),
    CourseItem(prompt: '真希望我当时更用功。', answer: 'I wish I **had** studied harder.'),
    CourseItem(prompt: '要是现在是周五就好了。', answer: 'If only it **were** Friday.'),
    CourseItem(prompt: '我希望我有更多空闲时间。', answer: 'I wish I **had** more free time.'),
    CourseItem(prompt: '真希望我们没错过那趟航班。', answer: "I wish we **hadn't** missed that flight."),
    CourseItem(prompt: '真希望我年轻时多去旅行。', answer: 'I wish I **had** travelled more when I was young.'),
    CourseItem(prompt: '要是我的邻居能安静点就好了。（抱怨用 would）', answer: 'I wish my neighbours **would** be quieter.'),
    CourseItem(prompt: '我希望我知道答案。（现在）', answer: 'I wish I **knew** the answer.'),
    CourseItem(prompt: '要是我们没吵架就好了。（过去）', answer: "If only we **hadn't** argued."),
    CourseItem(prompt: '我希望我不用这么早起床。（现在）', answer: "I wish I **didn't** have to get up so early."),
  ],
);

final QuizContent zhEnB21SpeakIf = zhEnSpeak(
  id: 'zh_en_b2_1_speak_if',
  title: '开口说：What would you do if…?',
  intro: '用条件句谈假设。听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '缩写',
      text: "I would → I'd，would not → wouldn't。假设句里大量使用。",
    ),
  ],
  items: const [
    CourseItem(prompt: '如果我中了彩票，我会去环游世界。', answer: "If I won the lottery, I'd travel the world."),
    CourseItem(prompt: '如果我是你，我会接受这份工作。', answer: "If I were you, I'd take the job."),
    CourseItem(prompt: '换作是我，我不会那么做。', answer: "I wouldn't do that if I were you."),
    CourseItem(prompt: '要是我有更多时间就好了。', answer: 'I wish I had more time.'),
    CourseItem(prompt: '你会怎么做？', answer: 'What would you do?'),
  ],
);

final QuizContent zhEnB21Ppc = zhEnFill(
  id: 'zh_en_b2_1_ppc',
  title: '现在完成进行时',
  intro: 'have been + V-ing 强调一个动作从过去持续到现在（可能还在进行）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'have been + V-ing',
      text: '强调持续和过程：I have been **studying**（我一直在学）。常和 for/since/all day 连用。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我一直在学英语。', answer: 'I have been **studying** English.'),
    CourseItem(prompt: '她等了两个小时了。', answer: 'She has been **waiting** for two hours.'),
    CourseItem(prompt: '下了一整天雨。', answer: 'It has been **raining** all day.'),
    CourseItem(prompt: '你一直在做什么？', answer: 'What have you been **doing**?'),
    CourseItem(prompt: '他们从早上就一直在工作。', answer: 'They have been **working** since morning.'),
    CourseItem(prompt: '他跑了一个小时了。', answer: 'He has been **running** for an hour.'),
    CourseItem(prompt: '我们一整天都在打扫房子。', answer: 'We have been **cleaning** the house all day.'),
    CourseItem(prompt: '她最近一直在练钢琴。', answer: 'She has been **practising** the piano lately.'),
    CourseItem(prompt: '你等了多久了？', answer: 'How long have you been **waiting**?'),
    CourseItem(prompt: '我一直在想这个问题。', answer: 'I have been **thinking** about this problem.'),
    CourseItem(prompt: '她学中文学了三年了（还在学）。', answer: 'She has been **learning** Chinese for three years.'),
    CourseItem(prompt: '你哭了吗？你的眼睛红了。', answer: 'Have you been **crying**? Your eyes are red.'),
    CourseItem(prompt: '他们盖这栋楼盖了两年了。', answer: 'They have been **building** this block for two years.'),
    CourseItem(prompt: '我找我的眼镜找了一上午。', answer: 'I have been **looking** for my glasses all morning.'),
    CourseItem(prompt: '他最近一直在加班。', answer: 'He has been **working** overtime lately.'),
  ],
);

final QuizContent zhEnB21Passive = zhEnFill(
  id: 'zh_en_b2_1_passive',
  title: '被动语态：现在与过去',
  intro: '被动语态 = be + 过去分词，强调动作的承受者。英语被动比中文常见得多。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ be + V3（Z27）',
      text: '把宾语提到句首 + be + 过去分词，需要时才用 by 提施动者。中文「被」较窄且常含负面，英语被动很中性。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这本书很多人读。', answer: 'This book is **read** by many people.'),
    CourseItem(prompt: '这座桥建于 1990 年。', answer: 'The bridge was **built** in 1990.'),
    CourseItem(prompt: '英语在很多国家使用。', answer: 'English is **spoken** in many countries.'),
    CourseItem(prompt: '窗户被打破了。', answer: 'The window was **broken**.'),
    CourseItem(prompt: '这些房子建于去年。', answer: 'These houses were **built** last year.'),
    CourseItem(prompt: '这首歌是一位学生写的。', answer: 'This song was **written** by a student.'),
    CourseItem(prompt: '晚饭七点供应。', answer: 'Dinner is **served** at seven.'),
    CourseItem(prompt: '我的自行车被偷了。', answer: 'My bike was **stolen**.'),
    CourseItem(prompt: '大米在中国南方种植。', answer: 'Rice is **grown** in southern China.'),
    CourseItem(prompt: '他被邀请参加聚会了。', answer: 'He was **invited** to the party.'),
    CourseItem(prompt: '这个词有两种发音。（被动：is pronounced）', answer: 'This word is **pronounced** in two ways.'),
    CourseItem(prompt: '茶起源于中国。（被动：was first grown）', answer: 'Tea was first **grown** in China.'),
    CourseItem(prompt: '每年生产数百万部手机。', answer: 'Millions of phones are **made** every year.'),
    CourseItem(prompt: '这封信是昨天寄出的。', answer: 'The letter was **sent** yesterday.'),
    CourseItem(prompt: '博物馆周一关闭。（被动：is closed）', answer: 'The museum is **closed** on Mondays.'),
  ],
);

final QuizContent zhEnB21Passive2 = zhEnFill(
  id: 'zh_en_b2_1_passive2',
  title: '被动语态：完成时与情态',
  intro: '被动也能用于完成时（have been + V3）和情态动词（can/must be + V3）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '扩展被动',
      text: '完成被动：has been **done**；情态被动：must be **done**、can be **finished**。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这个问题已经解决了。', answer: 'The problem has been **solved**.'),
    CourseItem(prompt: '这项工作明天能完成。', answer: 'The work can be **finished** tomorrow.'),
    CourseItem(prompt: '钱已经花光了。', answer: 'The money has been **spent**.'),
    CourseItem(prompt: '这必须马上做。', answer: 'This must be **done** now.'),
    CourseItem(prompt: '会议被取消了。', answer: 'The meeting has been **cancelled**.'),
    CourseItem(prompt: '规则必须遵守。', answer: 'The rules must be **followed**.'),
    CourseItem(prompt: '这份表格可以在网上填写。', answer: 'The form can be **completed** online.'),
    CourseItem(prompt: '房间已经打扫过了。', answer: 'The room has been **cleaned**.'),
    CourseItem(prompt: '这件事应该认真对待。', answer: 'This should be **taken** seriously.'),
    CourseItem(prompt: '票已经全部售出。', answer: 'All the tickets have been **sold**.'),
    CourseItem(prompt: '你的申请正在处理中。（is being + V3）', answer: 'Your application is being **processed**.'),
    CourseItem(prompt: '这座老教堂已经修复了。', answer: 'The old church has been **restored**.'),
    CourseItem(prompt: '报告必须在周五前交。', answer: 'The report must be **handed** in by Friday.'),
    CourseItem(prompt: '这个箱子不能打开。', answer: 'This box cannot be **opened**.'),
    CourseItem(prompt: '新的地铁线明年就能建成。', answer: 'The new metro line can be **completed** next year.'),
  ],
);

final QuizContent zhEnB21ListenDebate = zhEnListen(
  id: 'zh_en_b2_1_listen_debate',
  title: '听力：A radio debate',
  passageTitle: 'Should cars be banned?',
  passage:
      'Welcome back to the debate. Our question today is: should cars be banned '
      "from city centres? Our first guest, Dr Green, believes they should. "
      "'Cities are too polluted,' she says. 'If we removed cars, the air would "
      "be cleaner and streets would be safer.' But our second guest, Mr Blake, "
      "disagrees. 'Many people need their cars for work,' he argues. 'A ban "
      "would hurt small businesses.' What do you think? Call us and share your "
      'opinion.',
  passageTranslation:
      '欢迎回到辩论现场。今天的问题是：市中心是否应该禁止汽车？第一位嘉宾 Green 博士认为应该。'
      '她说：「城市污染太严重了。如果我们取消汽车，空气会更清新，街道也会更安全。」但第二位嘉宾'
      'Blake 先生不同意。他说：「很多人上班需要开车，禁令会伤害小企业。」你怎么看？打电话'
      '来分享你的观点吧。',
  intro: '先听，再答题。留意用第二条件句展开的论证。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '论证中的条件句',
      text: 'If we removed cars, the air **would** be cleaner——用第二条件句设想结果。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the debate about?',
      options: ['Banning cars from city centres', 'Cheaper cars', 'New roads'],
      correctIndex: 0,
      questionTranslation: '辩论的主题是什么？',
    ),
    ReadingQuestion(
      question: 'What does Dr Green think?',
      options: ['Cars should be banned', 'Cars are good', 'She has no opinion'],
      correctIndex: 0,
      questionTranslation: 'Green 博士怎么看？',
    ),
    ReadingQuestion(
      question: 'Why does Mr Blake disagree?',
      options: ['People need cars for work', 'Cars are cheap', 'Cities are clean'],
      correctIndex: 0,
      questionTranslation: 'Blake 先生为什么反对？',
    ),
  ],
);

final QuizContent zhEnB21ReadAi = zhEnRead(
  id: 'zh_en_b2_1_read_ai',
  title: '阅读：Should we trust AI?',
  passageTitle: 'Trusting AI',
  passage:
      'Artificial intelligence, or AI, has become part of our daily lives. It '
      'is used in phones, cars, hospitals and schools. Supporters say that AI '
      'makes life easier and can solve difficult problems, such as diseases and '
      'climate change. However, critics warn that AI also brings risks. Jobs '
      'may be lost, and if machines make important decisions, who is '
      'responsible when things go wrong? Many experts believe that AI should be '
      'controlled by clear rules. If it were used carefully, they argue, it '
      'could benefit everyone. The debate is far from over.',
  passageTranslation:
      '人工智能（AI）已经成为我们日常生活的一部分，被用于手机、汽车、医院和学校。支持者说 AI 让'
      '生活更方便，还能解决疾病、气候变化等难题。然而，批评者警告 AI 也带来风险：工作可能被取代；'
      '如果由机器做重要决定，出问题时谁来负责？许多专家认为，AI 应当受明确规则的约束。他们认为，'
      '只要谨慎使用，它就能造福所有人。这场辩论远未结束。',
  intro: '读一段关于人工智能的议论文。留意被动语态和第二条件句。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '被动 + 条件',
      text: 'It **is used** in phones（被动）；If it **were used** carefully（第二条件）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where is AI used?',
      options: ['In many areas of daily life', 'Only in games', 'Nowhere yet'],
      correctIndex: 0,
      questionTranslation: 'AI 用在哪些地方？',
    ),
    ReadingQuestion(
      question: 'What is a risk of AI?',
      options: ['Job losses', 'More jobs', 'Cheaper phones'],
      correctIndex: 0,
      questionTranslation: 'AI 有什么风险？',
    ),
    ReadingQuestion(
      question: 'What do experts suggest?',
      options: ['Clear rules', 'Ban AI', 'Ignore it'],
      correctIndex: 0,
      questionTranslation: '专家建议什么？',
    ),
  ],
);

final QuizContent zhEnB21Modals = zhEnFill(
  id: 'zh_en_b2_1_modals',
  title: '可能性情态动词',
  intro: 'might / may / could 表示某事可能发生（也许），语气比 will 弱。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '表可能',
      text: 'might / may / could + 原形，表示不确定的可能性。might not = 也许不。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他可能在家。', answer: 'He **might** be at home.'),
    CourseItem(prompt: '这可能是真的。', answer: 'It **could** be true.'),
    CourseItem(prompt: '她也许知道答案。', answer: 'She **may** know the answer.'),
    CourseItem(prompt: '他们可能会晚点到。', answer: 'They **might** be late.'),
    CourseItem(prompt: '这也许行得通。', answer: 'It **might** work.'),
    CourseItem(prompt: '明天可能会下雪。', answer: 'It **might** snow tomorrow.'),
    CourseItem(prompt: '她可能不来了。', answer: 'She **might** not come.'),
    CourseItem(prompt: '这可能是个好机会。', answer: 'This **could** be a good opportunity.'),
    CourseItem(prompt: '他也许在开会。', answer: 'He **may** be in a meeting.'),
    CourseItem(prompt: '我们可能需要更多帮助。', answer: 'We **might** need more help.'),
    CourseItem(prompt: '她可能已经出发了。', answer: 'She **might** have left already.'),
    CourseItem(prompt: '这条路可能更快。', answer: 'This road **could** be faster.'),
    CourseItem(prompt: '他们也许会改变主意。', answer: 'They **may** change their minds.'),
    CourseItem(prompt: '价格可能会上涨。', answer: 'Prices **might** go up.'),
    CourseItem(prompt: '小心——那可能很危险。', answer: 'Be careful — it **could** be dangerous.'),
  ],
);

final QuizContent zhEnB21SpeakOpinion = zhEnSpeak(
  id: 'zh_en_b2_1_speak_opinion',
  title: '开口说：表达并捍卫观点',
  intro: '用这些框架短语清晰地表达和支持你的观点。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '观点框架',
      text: '先立观点，再给理由，最后总结：In my opinion… because… All in all…。',
    ),
  ],
  items: const [
    CourseItem(prompt: '在我看来……', answer: 'In my opinion, ...'),
    CourseItem(prompt: '我认为……', answer: 'I believe that ...'),
    CourseItem(prompt: '一方面……另一方面……', answer: 'On the one hand ... on the other hand ...'),
    CourseItem(prompt: '我理解你的观点，但是……', answer: 'I see your point, but ...'),
    CourseItem(prompt: '总而言之……', answer: 'All in all, ...'),
  ],
);

final QuizContent zhEnB21ReportedIntro = zhEnFill(
  id: 'zh_en_b2_1_reported_intro',
  title: '间接引语（入门）',
  intro: '转述别人的话时，时态通常要「后退一步」。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 时态后退（Z29）',
      text: 'is→was，will→would，have→had，一般现在→一般过去。中文没有这种时态回退。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他说他很累。', answer: 'He said he **was** tired.'),
    CourseItem(prompt: '她说她会来。', answer: 'She said she **would** come.'),
    CourseItem(prompt: '他们说他们已经吃过了。', answer: 'They said they **had** eaten.'),
    CourseItem(prompt: '他告诉我他喜欢它。', answer: 'He told me he **liked** it.'),
    CourseItem(prompt: '她说她住在伦敦。', answer: 'She said she **lived** in London.'),
    CourseItem(prompt: '他说他在工作。', answer: 'He said he **was** working.'),
    CourseItem(prompt: '她告诉我她买了一辆新车。', answer: 'She told me she **had** bought a new car.'),
    CourseItem(prompt: '他们说他们第二天会到。', answer: 'They said they **would** arrive the next day.'),
    CourseItem(prompt: '她说她不喜欢咖啡。', answer: "She said she **didn't** like coffee."),
    CourseItem(prompt: '他说他能帮我们。', answer: 'He said he **could** help us.'),
    CourseItem(prompt: '她说她正在等公交车。', answer: 'She said she **was** waiting for the bus.'),
    CourseItem(prompt: '他们告诉我们他们没有时间。', answer: "They told us they **didn't** have time."),
    CourseItem(prompt: '他说他把钥匙忘在办公室了。', answer: 'He said he **had** left his keys in the office.'),
    CourseItem(prompt: '她说她第二天要去看医生。', answer: 'She said she **would** see the doctor the next day.'),
    CourseItem(prompt: '他告诉我他从没去过国外。', answer: 'He told me he **had** never been abroad.'),
  ],
);

final QuizContent zhEnB21ListenScience = zhEnListen(
  id: 'zh_en_b2_1_listen_science',
  title: '听力：A science podcast',
  passageTitle: 'The amazing brain',
  passage:
      'Did you know that the human brain uses about twenty per cent of our '
      'energy, even though it is only two per cent of our body weight? '
      'Scientists have been studying the brain for centuries, but there is '
      'still a lot we don\'t understand. Recent research suggests that sleep is '
      'very important for memory. While we sleep, the brain organises the '
      'information we have learnt during the day. So, if you want to remember '
      'something, don\'t stay up all night — get some sleep!',
  passageTranslation:
      '你知道吗？人脑只占体重的百分之二，却消耗我们大约百分之二十的能量。科学家研究大脑已有几个'
      '世纪，但仍有很多我们不了解的地方。最新研究表明，睡眠对记忆非常重要。我们睡觉时，大脑会'
      '整理白天学到的信息。所以，如果你想记住什么，别熬夜——去睡一觉吧！',
  intro: '先听，再答题。留意现在完成进行时和被动。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '完成进行 + 被动',
      text: 'have been studying（一直在研究）；the information we have learnt（我们学过的信息）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How much energy does the brain use?',
      options: ['About 20%', 'About 2%', 'About 50%'],
      correctIndex: 0,
      questionTranslation: '大脑消耗多少能量？',
    ),
    ReadingQuestion(
      question: 'What is important for memory?',
      options: ['Sleep', 'Food', 'Exercise'],
      correctIndex: 0,
      questionTranslation: '什么对记忆很重要？',
    ),
    ReadingQuestion(
      question: 'What is the advice?',
      options: ['Get some sleep', 'Study all night', 'Eat more'],
      correctIndex: 0,
      questionTranslation: '给出的建议是什么？',
    ),
  ],
);

final QuizContent zhEnB21DictOpinion = zhEnDict(
  id: 'zh_en_b2_1_dict_opinion',
  title: '听写：An opinion paragraph',
  intro: '听句子并打出来。注意被动语态和条件句。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 被动与条件（Z27/Z28）',
      text: '写出 be + V3（was directed, has been solved）和 would + 原形。',
    ),
  ],
  items: const [
    CourseItem(prompt: '在我看来，英语非常有用。', answer: 'In my opinion, English is very useful.'),
    CourseItem(prompt: '如果我有更多时间，我会去旅行。', answer: 'If I had more time, I would travel.'),
    CourseItem(prompt: '这个问题已经解决了。', answer: 'This problem has been solved.'),
    CourseItem(prompt: '我学英语好多年了。', answer: "I've been learning English for years."),
    CourseItem(prompt: '这部电影由一位著名导演执导。', answer: 'The film was directed by a famous director.'),
    CourseItem(prompt: '如果我是你，我会再试一次。', answer: 'If I were you, I would try again.'),
    CourseItem(prompt: '真希望我没卖掉我的车。', answer: 'I wish I had not sold my car.'),
    CourseItem(prompt: '会议被推迟了。', answer: 'The meeting has been postponed.'),
    CourseItem(prompt: '他说他会帮忙。', answer: 'He said he would help.'),
    CourseItem(prompt: '因此，我们应该谨慎行动。', answer: 'Therefore, we should act carefully.'),
    CourseItem(prompt: '她等了一个多小时了。', answer: 'She has been waiting for over an hour.'),
    CourseItem(prompt: '规则必须遵守。', answer: 'The rules must be followed.'),
    CourseItem(prompt: '要是我住得近一点就好了。', answer: 'I wish I lived closer.'),
    CourseItem(prompt: '如果早点告诉我，我就来了。', answer: 'If you had told me earlier, I would have come.'),
    CourseItem(prompt: '然而，并非人人同意。', answer: 'However, not everyone agrees.'),
  ],
);

final QuizContent zhEnB21ArgConnectors = zhEnFill(
  id: 'zh_en_b2_1_arg_connectors',
  title: '论证连接词',
  intro: 'however、therefore、moreover 等连接词让论证更清晰、更正式。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 一句一个连词（Z25）',
      text: 'however（然而）比 but 正式，后加逗号；therefore（因此）、moreover（此外）。别叠用 although…but。',
    ),
  ],
  items: const [
    CourseItem(prompt: '然而，还有另一面。', answer: '**However**, there is another side.'),
    CourseItem(prompt: '因此，我们应该行动。', answer: '**Therefore**, we should act.'),
    CourseItem(prompt: '此外，费用很高。', answer: '**Moreover**, the cost is high.'),
    CourseItem(prompt: '尽管有风险，好处更大。', answer: '**Although** there are risks, the benefits are greater.'),
    CourseItem(prompt: '例如……', answer: 'For **example**, ...'),
    CourseItem(prompt: '另一方面，费用会上升。', answer: 'On the other **hand**, costs will rise.'),
    CourseItem(prompt: '结果，很多商店关门了。', answer: 'As a **result**, many shops closed.'),
    CourseItem(prompt: '此外，这种方法更环保。', answer: '**Moreover**, this method is greener.'),
    CourseItem(prompt: '总的来说，好处大于坏处。', answer: 'In **conclusion**, the benefits outweigh the drawbacks.'),
    CourseItem(prompt: '然而，并非人人同意。', answer: '**However**, not everyone agrees.'),
    CourseItem(prompt: '因此，价格上涨了。', answer: '**Therefore**, prices went up.'),
    CourseItem(prompt: '此外，这项计划还能创造就业。', answer: '**Moreover**, the plan can create jobs.'),
    CourseItem(prompt: '例如，很多学生在线学习。', answer: 'For **example**, many students study online.'),
    CourseItem(prompt: '另一方面，也存在风险。', answer: 'On the other **hand**, there are also risks.'),
    CourseItem(prompt: '结果，交通有了改善。', answer: 'As a **result**, traffic has improved.'),
  ],
);

final QuizContent zhEnB21ReadRemote = zhEnRead(
  id: 'zh_en_b2_1_read_remote',
  title: '阅读：The benefits of remote work',
  passageTitle: 'Working from home',
  passage:
      'Since the pandemic, remote work has become common in many companies. '
      'Employees who work from home save time and money because they don\'t '
      'have to travel. They can also have a better balance between work and '
      'family life. Companies benefit too: they can hire talented people from '
      'anywhere in the world and spend less on office space. However, remote '
      'work is not perfect. Some employees feel isolated, and teamwork can be '
      "harder online. Experts believe that in the future, many companies will "
      "use a 'hybrid' model, where staff work partly at home and partly in the "
      'office.',
  passageTranslation:
      '自疫情以来，远程办公在许多公司变得普遍。在家办公的员工省时省钱，因为不必通勤，也能更好地'
      '平衡工作与家庭。公司同样受益：可以在全球任何地方招募人才，办公空间的开支也更少。然而，'
      '远程办公并不完美。有些员工感到孤立，线上协作也更难。专家认为，未来许多公司会采用「混合」'
      '模式，员工一部分时间在家、一部分时间在办公室工作。',
  intro: '读一段关于远程办公的短文。留意定语从句和 however 的转折。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '从句 + 转折',
      text: 'Employees **who work from home**（定语从句）；However（转折，更正式的 but）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is a benefit for employees?',
      options: ['Saving time and money', 'Longer hours', 'More travel'],
      correctIndex: 0,
      questionTranslation: '对员工有什么好处？',
    ),
    ReadingQuestion(
      question: 'What is a benefit for companies?',
      options: ['Hiring people from anywhere', 'Bigger offices', 'Higher costs'],
      correctIndex: 0,
      questionTranslation: '对公司有什么好处？',
    ),
    ReadingQuestion(
      question: "What is the 'hybrid' model?",
      options: ['Partly home, partly office', 'Only home', 'Only office'],
      correctIndex: 0,
      questionTranslation: '「混合」模式是什么？',
    ),
  ],
);

/// B2.1 in chain order.
final List<QuizContent> zhEnB2_1 = [
  zhEnB21Cond2,
  zhEnB21Cond3,
  zhEnB21Wish,
  zhEnB21SpeakIf,
  zhEnB21Ppc,
  zhEnB21Passive,
  zhEnB21Passive2,
  zhEnB21ListenDebate,
  zhEnB21ReadAi,
  zhEnB21Modals,
  zhEnB21SpeakOpinion,
  zhEnB21ReportedIntro,
  zhEnB21ListenScience,
  zhEnB21DictOpinion,
  zhEnB21ArgConnectors,
  zhEnB21ReadRemote,
];
