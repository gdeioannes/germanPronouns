import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// C2.1 — Stylistic Command · 风格驾驭. Mandarin → English.
///
/// Big rock: idiomatic mastery (Z32), subtle modality & aspect (Z18),
/// ellipsis/substitution, and marked syntax. Recognising irony and connotation
/// (Z31/Z32), near-native prosody (Z10).

final QuizContent zhEnC21Modality = zhEnFill(
  id: 'zh_en_c2_1_modality',
  title: '情态的细微差别',
  intro: 'should/could/would/needn\'t + have + V3 表达对过去的评价、遗憾或推测。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '过去情态',
      text: 'should have（本该）、could have（本可以）、needn\'t have（本不必）、would have（本会）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他这时候应该已经到了。', answer: 'He **should** have arrived by now.'),
    CourseItem(prompt: '你本可以告诉我的。', answer: 'You **could** have told me.'),
    CourseItem(prompt: '她当时本不必来的。', answer: "She **needn't** have come."),
    CourseItem(prompt: '我本应该更早打电话。', answer: 'I **should** have called earlier.'),
    CourseItem(prompt: '那样本来会更好。', answer: 'It **would** have been better.'),
  ],
);

final QuizContent zhEnC21Aspect = zhEnFill(
  id: 'zh_en_c2_1_aspect',
  title: '完成与进行体的细腻区别',
  intro: '完成时看「结果」，进行时看「过程」；将来完成、完成进行表达细微的时间层次。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '结果 vs 过程（Z18）',
      text: 'have done（强调结果）vs have been doing（强调过程/持续）；by then, I will have done。',
    ),
  ],
  items: const [
    CourseItem(prompt: '到明年我就在这工作十年了。', answer: 'By next year, I will have **been** working here for ten years.'),
    CourseItem(prompt: '我一直在想这件事。', answer: "I've **been** thinking about it."),
    CourseItem(prompt: '他已经走了（人不在了）。', answer: 'He has **gone**.'),
    CourseItem(prompt: '那本书我看了好几周了（还没看完）。', answer: "I've been **reading** that book for weeks."),
    CourseItem(prompt: '等你到时我已经吃完了。', answer: 'By the time you arrive, I will have **finished**.'),
  ],
);

final QuizContent zhEnC21Ellipsis = zhEnFill(
  id: 'zh_en_c2_1_ellipsis',
  title: '省略与替代',
  intro: '用 so / to / do / one 等替代前文，避免重复，让语言自然流畅。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '替代手段（Z31）',
      text: 'so（替代整句）、to（替代动词短语）、do/does（替代动词）、one（替代可数名词）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我喜欢，她也喜欢。', answer: 'I like it, and so **does** she.'),
    CourseItem(prompt: '你想去吗？——很想。', answer: "Do you want to go? — I'd love **to**."),
    CourseItem(prompt: '他们说要下雨，我也这么想。', answer: "They say it'll rain. I think **so**."),
    CourseItem(prompt: '他会来，但她不会。', answer: "He'll come, but she **won't**."),
    CourseItem(prompt: '你想要的话可以拿一个。', answer: 'You can have one if you want **to**.'),
  ],
);

final QuizContent zhEnC21SpeakFluency = zhEnSpeak(
  id: 'zh_en_c2_1_speak_fluency',
  title: '发音：习语与自然节奏',
  intro: '地道流利 = 习语 + 自然节奏 + 连读弱读。像母语者一样把词连起来。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 流利的节奏（Z10）',
      text: '习语脱口而出、功能词弱读、词与词连读——这才是接近母语的语感。',
    ),
  ],
  items: const [
    CourseItem(prompt: '习语', answer: "It's a piece of cake."),
    CourseItem(prompt: '连读节奏', answer: 'What are you up to?'),
    CourseItem(prompt: '缩略', answer: "I dunno, whatever works."),
    CourseItem(prompt: '习语', answer: "Let's play it by ear."),
    CourseItem(prompt: '一整句', answer: "To be honest, I couldn't care less."),
  ],
);

final QuizContent zhEnC21Idioms = zhEnFill(
  id: 'zh_en_c2_1_idioms',
  title: '习语与固定表达',
  intro: '习语不能字面翻译。整体记忆，用在合适的语境。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 别逐字直译（Z32）',
      text: '习语是文化的结晶：a piece of cake（小菜一碟）、cost an arm and a leg（花大价钱）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '小菜一碟', answer: 'a piece of **cake**'),
    CourseItem(prompt: '花大价钱', answer: 'cost an arm and a **leg**'),
    CourseItem(prompt: '倾盆大雨', answer: 'to rain **cats** and dogs'),
    CourseItem(prompt: '一举两得', answer: 'to kill two **birds** with one stone'),
    CourseItem(prompt: '千载难逢', answer: 'once in a blue **moon**'),
  ],
);

final QuizContent zhEnC21Connotation = zhEnFill(
  id: 'zh_en_c2_1_connotation',
  title: '词的褒贬色彩',
  intro: '许多同义词意思相近，但褒贬色彩不同。选词见修养。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 褒义还是贬义？（Z32）',
      text: 'determined（褒：坚定）vs stubborn（贬：固执）；affordable（褒）vs cheap（可含贬义）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这位政治家很坚定（褒）。', answer: 'The politician is **determined**.'),
    CourseItem(prompt: '这位政治家很固执（贬）。', answer: 'The politician is **stubborn**.'),
    CourseItem(prompt: '一栋便宜的房子（可含贬义）。', answer: 'a **cheap** house'),
    CourseItem(prompt: '一栋实惠的房子（褒）。', answer: 'an **affordable** house'),
    CourseItem(prompt: '他很节俭（褒）。', answer: 'He is **thrifty**.'),
  ],
);

final QuizContent zhEnC21ListenIrony = zhEnListen(
  id: 'zh_en_c2_1_listen_irony',
  title: '听力：Irony & humour',
  passageTitle: 'My smart home',
  passage:
      "So, I bought one of those 'smart' home devices last month. You know, "
      'the ones that are supposed to make your life easier. Well, let me tell '
      'you how my morning went. I asked it to turn on the lights. It played '
      'jazz. I asked it to play music. It ordered fifty rolls of toilet paper. '
      "And when I finally, in desperation, shouted 'Help!', it cheerfully "
      "replied: 'I'm sorry, I didn't quite catch that.' Truly, we are living in "
      'the future.',
  passageTranslation:
      '话说，我上个月买了那种「智能」家居设备。你懂的，就是号称能让生活更轻松的那种。来，'
      '让我说说我那天早上过得怎么样。我叫它开灯，它放起了爵士乐。我叫它放音乐，它订了五十卷厕纸。'
      '最后我绝望地喊「救命！」，它欢快地回答：「抱歉，我没太听清。」我们，真是活在未来啊。',
  intro: '先听，再答题。关键是听出反讽——说的和真正的意思相反。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 反讽（Z31）',
      text: "'Truly, we are living in the future' 是反讽：字面在夸，实则在讽刺。靠语气和上下文判断。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the speaker really saying about the device?',
      options: ["It doesn't work well", "It's excellent", "It's cheap"],
      correctIndex: 0,
      questionTranslation: '说话人其实在说这个设备怎么样？',
    ),
    ReadingQuestion(
      question: 'Is the speaker being serious at the end?',
      options: ["No, it's ironic", 'Yes', 'Unclear'],
      correctIndex: 0,
      questionTranslation: '结尾那句是认真的吗？',
    ),
    ReadingQuestion(
      question: 'What is the tone?',
      options: ['Humorous and ironic', 'Angry', 'Sad'],
      correctIndex: 0,
      questionTranslation: '整体语气如何？',
    ),
  ],
);

final QuizContent zhEnC21Marked = zhEnFill(
  id: 'zh_en_c2_1_marked',
  title: '强调与特殊结构',
  intro: '用助动词 do、强调句和否定倒装突出信息、加强语气。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '强调手段（Z22）',
      text: '用 do 强调肯定（I **did** tell you）；强调句 It is…that…；否定倒装。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我确实告诉过你。', answer: 'I **did** tell you.'),
    CourseItem(prompt: '正是这一点让我担心。', answer: 'It is this that **worries** me.'),
    CourseItem(prompt: '他就是不肯听。', answer: "He simply **won't** listen."),
    CourseItem(prompt: '我一点也不在乎。', answer: "I couldn't care **less**."),
    CourseItem(prompt: '她的确来了，虽然迟到了。', answer: 'She **did** come, albeit late.'),
  ],
);

final QuizContent zhEnC21ReadSatire = zhEnRead(
  id: 'zh_en_c2_1_read_satire',
  title: '阅读：A satirical article',
  passageTitle: 'Happiness is now compulsory',
  passage:
      'In a bold move to improve public health, the government has announced '
      'that from next year, all citizens will be required to feel happy at all '
      "times. Frowning in public will carry a small fine, while excessive "
      "sighing may result in a mandatory 'joy workshop'. A spokesperson "
      "explained: 'We believe happiness is a simple choice. If people are "
      "unhappy, it is clearly their own fault.' Critics have pointed out that "
      'poverty, stress and poor healthcare might have something to do with it — '
      'but such negativity, the government insists, is exactly the problem. The '
      'scheme will be funded by a new tax on umbrellas, since rain, too, has '
      'been declared unpatriotic.',
  passageTranslation:
      '为改善公众健康，政府大胆宣布：从明年起，全体公民必须时刻感到快乐。在公共场合皱眉将被'
      '处以小额罚款，而过度叹气可能被强制参加「快乐工作坊」。一位发言人解释道：「我们认为快乐是'
      '一个简单的选择。如果人们不快乐，那显然是他们自己的错。」批评者指出，贫困、压力和糟糕的'
      '医疗或许与此有关——但政府坚称，这种消极情绪正是问题所在。该计划将由一项新的雨伞税提供'
      '资金，因为下雨也已被宣布为不爱国。',
  intro: '读一篇讽刺文章。关键是识别夸张背后的讽刺，别当真。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 讽刺文体（Z31）',
      text: '用荒诞的夸张来批评现实观点（「快乐是简单的选择」）。识别出它并非字面真实。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Is this article describing a real policy?',
      options: ["No, it's satire", 'Yes', "It's a documentary"],
      correctIndex: 0,
      questionTranslation: '这篇文章在描述真实政策吗？',
    ),
    ReadingQuestion(
      question: 'What is the article criticising?',
      options: ['The idea that happiness is just a choice', 'Rain', 'Umbrellas'],
      correctIndex: 0,
      questionTranslation: '文章在批评什么？',
    ),
    ReadingQuestion(
      question: 'What is the tone?',
      options: ['Satirical and mocking', 'Serious', 'Sad'],
      correctIndex: 0,
      questionTranslation: '语气如何？',
    ),
  ],
);

final QuizContent zhEnC21PvNetworks = zhEnFill(
  id: 'zh_en_c2_1_pv_networks',
  title: '短语动词网络：put',
  intro: '同一个动词配不同小品词，意思迥异。put 是典型例子。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'put 的家族（Z30）',
      text: 'put up with（忍受）、put off（推迟）、put out（扑灭）、put through（接通）、put down（放下）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我受不了这噪音了。', answer: "I can't put up **with** this noise."),
    CourseItem(prompt: '别把会议推迟了。', answer: "Don't put the meeting **off**."),
    CourseItem(prompt: '把书放下。', answer: 'Put the book **down**.'),
    CourseItem(prompt: '请把我转接给经理。', answer: 'Please put me **through** to the manager.'),
    CourseItem(prompt: '消防员扑灭了火。', answer: 'The firefighters put **out** the fire.'),
  ],
);

final QuizContent zhEnC21RegisterShift = zhEnFill(
  id: 'zh_en_c2_1_register_shift',
  title: '语体转换',
  intro: '同一意思在正式与非正式之间转换。掌握这种对应是高级能力。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 正式 ↔ 非正式（Z32）',
      text: 'give me a hand（非正式）↔ assist me（正式）；hang on（非正式）↔ please wait（正式）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '非正式：帮个忙。', answer: 'Give me a **hand**.'),
    CourseItem(prompt: '正式：我必须先告辞。', answer: 'I must take my **leave**.'),
    CourseItem(prompt: '非正式：收到你消息了。', answer: 'Got your **message**.'),
    CourseItem(prompt: '正式：这确实令人印象深刻。', answer: 'That is most **impressive**.'),
    CourseItem(prompt: '非正式：等一下。', answer: 'Hang **on** a sec.'),
  ],
);

final QuizContent zhEnC21SpeakProsody = zhEnSpeak(
  id: 'zh_en_c2_1_speak_prosody',
  title: '发音：韵律与态度',
  intro: '同一句话，语调不同，态度（真诚、讽刺、犹豫）就不同。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '语调即态度（Z9）',
      text: '"Oh, great" 可以真诚，也可以讽刺——全看语调。用声音传达真正的意思。',
    ),
  ],
  items: const [
    CourseItem(prompt: '讽刺语调', answer: 'Oh, great. Just what I needed.'),
    CourseItem(prompt: '真诚语调', answer: 'I really appreciate your help.'),
    CourseItem(prompt: '不确定语调', answer: 'Well, I suppose so...'),
    CourseItem(prompt: '强调语调', answer: "That's absolutely brilliant!"),
    CourseItem(prompt: '一整句', answer: "Honestly? I'd rather not."),
  ],
);

final QuizContent zhEnC21CollocationPrecision = zhEnFill(
  id: 'zh_en_c2_1_collocation_precision',
  title: '搭配的精准',
  intro: '表示「强、重、深」时要选对形容词，搭配错了就不地道。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 强度搭配（Z32）',
      text: 'heavy rain（不是 big rain）、strong accent、deep regret、fast asleep、high praise。',
    ),
  ],
  items: const [
    CourseItem(prompt: '倾盆大雨', answer: 'heavy **rain**'),
    CourseItem(prompt: '浓重的口音', answer: 'a strong **accent**'),
    CourseItem(prompt: '深深的遗憾', answer: 'deep **regret**'),
    CourseItem(prompt: '高度赞扬', answer: 'high **praise**'),
    CourseItem(prompt: '熟睡', answer: 'fast **asleep**'),
  ],
);

final QuizContent zhEnC21ListenLiterary = zhEnListen(
  id: 'zh_en_c2_1_listen_literary',
  title: '听力：A literary reading',
  passageTitle: 'The old house',
  passage:
      "Listen to this short passage. 'The old house stood at the end of the "
      'lane, silent and watchful, as it had for a hundred years. Its windows, '
      'dark and empty, seemed to follow you as you passed. The villagers said '
      'nothing lived there now — nothing, at least, that they cared to name. '
      'But on winter nights, when the wind was still, a single light would '
      'sometimes appear in the highest window, and then, just as quickly, be '
      "gone.' Notice how the writer creates a feeling of mystery without ever "
      'explaining what is really there.',
  passageTranslation:
      '听这一小段文字：「那座老屋伫立在小巷尽头，沉默而警觉，一如它百年来的模样。它那一扇扇'
      '黑洞洞、空荡荡的窗户，似乎在你经过时目送着你。村民说如今那里什么都不住了——至少，没有'
      '他们愿意说出名字的东西。可在冬夜，风止之时，最高的那扇窗里有时会亮起一盏孤灯，随即，'
      '又同样迅速地熄灭。」注意作者如何在从不解释的情况下营造神秘感。',
  intro: '先听，再答题。留意营造氛围的文学手法。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '文学手法（Z31）',
      text: '拟人（windows seemed to follow you）、氛围营造、留白——不解释反而更有力。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What kind of text is this?',
      options: ['Atmospheric fiction', 'A news report', 'A recipe'],
      correctIndex: 0,
      questionTranslation: '这是什么类型的文本？',
    ),
    ReadingQuestion(
      question: 'What feeling does the writer create?',
      options: ['Mystery', 'Joy', 'Boredom'],
      correctIndex: 0,
      questionTranslation: '作者营造了什么感觉？',
    ),
    ReadingQuestion(
      question: 'Does the writer explain the light?',
      options: ['No', 'Yes', 'Partly'],
      correctIndex: 0,
      questionTranslation: '作者解释那盏灯了吗？',
    ),
  ],
);

final QuizContent zhEnC21DictNuance = zhEnDict(
  id: 'zh_en_c2_1_dict_nuance',
  title: '听写：A nuanced argument',
  intro: '听句子并打出来。注意委婉、倒装、强调句等细腻结构。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 细腻结构（Z31）',
      text: '写出 not so much…as…、Had we…、to put it mildly、What matters is…。',
    ),
  ],
  items: const [
    CourseItem(prompt: '有人可能会说恰恰相反。', answer: 'One could argue that the opposite is true.'),
    CourseItem(prompt: '与其说这是问题，不如说是症状。', answer: 'It is not so much a problem as a symptom.'),
    CourseItem(prompt: '要是我们早点行动，也许本可避免。', answer: 'Had we acted sooner, this might have been avoided.'),
    CourseItem(prompt: '委婉地说，这些证据缺乏说服力。', answer: 'The evidence is, to put it mildly, unconvincing.'),
    CourseItem(prompt: '重要的不是我们说什么，而是做什么。', answer: 'What matters is not what we say, but what we do.'),
  ],
);

final QuizContent zhEnC21ReadReview = zhEnRead(
  id: 'zh_en_c2_1_read_review',
  title: '阅读：A book review with irony',
  passageTitle: "The professor's hat",
  passage:
      "Mr Pinter's new novel, we are told, is a 'towering achievement'. It is "
      'certainly towering in length: at nine hundred pages, it could '
      'comfortably serve as a doorstop. The plot, such as it is, follows a '
      'middle-aged professor who spends the entire book deciding whether or not '
      'to buy a new hat. Along the way, we are treated to forty pages on the '
      "history of felt. Admirers will call this 'meditative'; the rest of us "
      'may call it something shorter. And yet — I confess — I read to the end. '
      'Perhaps, buried beneath the endless description, there is a real story '
      'struggling to get out. Or perhaps I simply wanted to know about the hat.',
  passageTranslation:
      '据说，Pinter 先生的新小说是一部「巍峨的杰作」。它在篇幅上确实巍峨：九百页，完全可以'
      '当门挡用。至于情节——如果那也算情节的话——讲的是一位中年教授用整本书来纠结要不要买一顶'
      '新帽子。一路上，我们还「有幸」读到四十页关于毡子历史的内容。仰慕者会称之为「冥想式」；'
      '我们其余人也许会用一个更短的词来形容。然而——我承认——我读到了最后。也许，在无尽的描写'
      '之下，真有一个故事在挣扎着想冒出来。又或者，我只是想知道那顶帽子到底怎样了。',
  intro: '读一篇带反讽的书评。留意「明褒暗贬」的手法。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '明褒暗贬（Z32）',
      text: "'towering achievement' → 转为吐槽篇幅；'something shorter' 是含蓄的贬评。识别反语与低调陈述。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: "What is the reviewer's real opinion?",
      options: ['Mostly negative', 'Very positive', 'Neutral'],
      correctIndex: 0,
      questionTranslation: '评论者真正的看法是什么？',
    ),
    ReadingQuestion(
      question: "What is the joke about the book's length?",
      options: ['It could be a doorstop', "It's too short", "It's perfect"],
      correctIndex: 0,
      questionTranslation: '关于篇幅的玩笑是什么？',
    ),
    ReadingQuestion(
      question: 'Does the reviewer finish the book?',
      options: ['Yes', 'No', 'Gives up halfway'],
      correctIndex: 0,
      questionTranslation: '评论者读完这本书了吗？',
    ),
  ],
);

/// C2.1 in chain order.
final List<QuizContent> zhEnC2_1 = [
  zhEnC21Modality,
  zhEnC21Aspect,
  zhEnC21Ellipsis,
  zhEnC21SpeakFluency,
  zhEnC21Idioms,
  zhEnC21Connotation,
  zhEnC21ListenIrony,
  zhEnC21Marked,
  zhEnC21ReadSatire,
  zhEnC21PvNetworks,
  zhEnC21RegisterShift,
  zhEnC21SpeakProsody,
  zhEnC21CollocationPrecision,
  zhEnC21ListenLiterary,
  zhEnC21DictNuance,
  zhEnC21ReadReview,
];
