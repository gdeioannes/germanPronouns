import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// The B-level "all quiz kinds" boost for the zh_en course: one inline
/// big-text cloze plus two external-AI speaking exercises per module,
/// B1.1–B2.2.

// ── B1.1 经历与联系 ────────────────────────────────────────────────────────

final QuizContent zhEnB11SpeakingMid = zhEnSpeaking(
  id: 'zh_en_b1_1_speaking_mid',
  title: '对话：我的经历',
  level: 'B1.1',
  topic: 'A chat about my life experiences: places I have visited, foods I '
      'have tried, things I have never done but want to do.',
  practisePoints: [
    'Have you ever…? questions and natural answers',
    'Present perfect for experience, past simple for the details',
    'for/since with how long questions',
  ],
  scoringCriteria: [
    'Perfect vs past chosen correctly',
    'Irregular participles (been, seen, eaten) correct',
    'for/since used correctly',
  ],
  priorityErrors: [
    'perfect used with finished-time expressions',
    '"I am here since" instead of "I have been here for/since"',
    'aspect particles translated word for word (⚑Z aspect bridge)',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：和 AI 助手聊聊你的人生经历。复制、开口、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '完成时-过去时二重奏',
      text: '用 perfect 报幕（I have been to Xi\'an），用过去时讲细节'
          '（I went in 2022）。这一来一回正是地道的 B1。',
    ),
  ],
);

final QuizContent zhEnB11BigText = zhEnBigText(
  id: 'zh_en_b1_1_bigtext',
  title: '整段填空：Ten years in London',
  passageTitle: 'Ten years in London',
  intro: '完成短文：现在完成时还是过去时、for/since，以及动词后接 -ing 还是 to。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '日期已封口，还是人生仍打开？',
      text: 'in 2016、two months later → 过去时。for/since、ever、yet → '
          '完成时。一空一判断。',
    ),
  ],
  template:
      'Mrs. Park {{0}} lived in London {{1}} ten years. She moved here in '
      '2016, when she {{2}} a job at a language school. Since then she '
      '{{3}} taught hundreds of students. "I enjoy {{4}} people grow," she '
      'says. She has never {{5}} of changing jobs, but last year she '
      'decided {{6}} something new: she signed {{7}} for a pottery class. '
      '"I {{8}} made fifty cups since September — and I have given most of '
      'them {{9}} to my students."',
  blanks: [
    inputBlank('has'),
    inputBlank('for'),
    inputBlank('found', accepted: ['got', 'took']),
    inputBlank('has'),
    inputBlank('watching', accepted: ['seeing', 'helping']),
    inputBlank('thought'),
    inputBlank('to try', accepted: ['to do', 'to learn']),
    inputBlank('up'),
    inputBlank('have', accepted: ["'ve"]),
    inputBlank('away'),
  ],
  passageTranslation:
      '帕克太太在伦敦已经住了十年。她 2016 年搬来这里，当时在一所语言学校找到了'
      '工作。从那以后她教过几百名学生。"我喜欢看着人成长，"她说。她从没想过换'
      '工作，不过去年她决定尝试点新东西：报名了一门陶艺课。"从九月到现在我做了'
      '五十个杯子——大部分都送给了我的学生。"',
);

final QuizContent zhEnB11SpeakingClose = zhEnSpeaking(
  id: 'zh_en_b1_1_speaking_close',
  title: '结业对话：我的轨迹',
  level: 'B1.1',
  topic: 'An interview about my life so far: how long I have done my job or '
      'studies, places I have lived, habits I used to have, and my opinions '
      'about learning English.',
  practisePoints: [
    'Present perfect + for/since for my current situation',
    'Perfect for experience, past for the story details',
    'used to for old habits',
    'Giving opinions: I think, I agree, in my opinion',
  ],
  scoringCriteria: [
    'Perfect vs past accuracy',
    'for/since correct',
    'Opinions expressed with correct verb patterns',
  ],
  targetVocabulary: [
    'have been', 'since', 'for', 'used to', 'in my opinion',
  ],
  priorityErrors: [
    '"I am agree"',
    'perfect with yesterday/ago',
    'used to confused with be used to',
  ],
  mode: SpeakingMode.interview,
  intro: 'B1.1 模块的结业对话：一次关于你人生轨迹的采访。复制、开口、'
      '把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '你的招牌句',
      text: "I've worked as a … for … years——这样自我介绍，"
          '半个模块的要点就已经展示完了。',
    ),
  ],
);

// ── B1.2 叙述与条件 ────────────────────────────────────────────────────────

final QuizContent zhEnB12SpeakingMid = zhEnSpeaking(
  id: 'zh_en_b1_2_speaking_mid',
  title: '对话：给我讲个故事',
  level: 'B1.2',
  topic: 'Tell me a real story from your life: something funny, scary or '
      'surprising that happened to you. I will ask about the details.',
  practisePoints: [
    'Setting the scene with was/were + -ing',
    'Telling the events in past simple',
    'Connectors: suddenly, while, in the end',
  ],
  scoringCriteria: [
    'Past continuous vs past simple used correctly',
    'The story has a beginning, middle and end',
    'Connectors used naturally',
  ],
  priorityErrors: [
    'past simple used for background scenes',
    'missing was/were before -ing',
    'story told entirely in present',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：给 AI 助手讲一件你亲身经历的事。复制、开口、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '先把开场排练好',
      text: 'It was…, I was -ing…, when… 把第一句练熟，后面自然会滚动起来。',
    ),
  ],
);

final QuizContent zhEnB12BigText = zhEnBigText(
  id: 'zh_en_b1_2_bigtext',
  title: '整段填空：The night the lights went out',
  passageTitle: 'The night the lights went out',
  intro: '完成故事：过去进行时、used to、关系从句和一个条件句。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '背景 -ing，事件简单过去',
      text: '用 was/were + -ing 铺背景，用过去式点事件。'
          '这段文字会毫无预告地在两者之间切换。',
    ),
  ],
  template:
      'It was a windy night and I {{0}} watching an old film at home. My '
      'street, {{1}} is usually noisy, was completely quiet. Suddenly the '
      'lights {{2}} out. While I {{3}} looking for a candle, someone '
      'knocked on the door. It was my neighbour, Mrs. Wang, {{4}} used '
      '{{5}} be an electrician. "If you {{6}} me your torch, I will check '
      'the fuse box," she said. Ten minutes later the lights came back. '
      'Now, if the lights {{7}} out again, I {{8}} exactly who to call — '
      'the neighbour {{9}} saved my Friday night.',
  blanks: [
    inputBlank('was'),
    inputBlank('which'),
    inputBlank('went'),
    inputBlank('was'),
    inputBlank('who'),
    inputBlank('to'),
    inputBlank('lend', accepted: ['give', 'bring']),
    inputBlank('go'),
    inputBlank('know', accepted: ['will know']),
    inputBlank('who', accepted: ['that']),
  ],
  passageTranslation:
      '那是一个刮风的夜晚，我正在家看一部老电影。我住的那条平时很吵的街道'
      '完全安静了下来。突然停电了。我正找蜡烛时，有人敲门。是邻居王太太——'
      '她以前是电工。"你把手电借我，我去看看保险盒，"她说。十分钟后灯亮了。'
      '现在，如果再停电，我很清楚该找谁——那位拯救了我周五晚上的邻居。',
);

final QuizContent zhEnB12SpeakingClose = zhEnSpeaking(
  id: 'zh_en_b1_2_speaking_close',
  title: '结业对话：从前与现在',
  level: 'B1.2',
  topic: 'A conversation about how my life has changed: what I used to do '
      'as a child, a memorable story from those years, and what I will do '
      'if things go well next year.',
  practisePoints: [
    'used to for old habits',
    'Past continuous + past simple in one story',
    'First conditional: if …, I will…',
    'Relative clauses to describe people and places',
  ],
  scoringCriteria: [
    'used to formed correctly',
    'Scene vs event tenses correct',
    'if-clause in present, main clause with will',
  ],
  targetVocabulary: [
    'used to', 'while', 'suddenly', 'if', 'who', 'where',
  ],
  priorityErrors: [
    'will inside the if-clause',
    'story with no connectors',
    'missing was/were in the continuous',
  ],
  mode: SpeakingMode.interview,
  intro: 'B1.2 模块的结业对话：你的从前、一个故事和一个条件。复制、开口、'
      '把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '三幕剧',
      text: '从前（used to）→ 故事（was -ing… when…）→ 展望（If…, I will…）。'
          '按这个剧本走，每个要点都会覆盖到。',
    ),
  ],
);

// ── B2.1 观点与假设 ────────────────────────────────────────────────────────

final QuizContent zhEnB21SpeakingMid = zhEnSpeaking(
  id: 'zh_en_b2_1_speaking_mid',
  title: '对话：如果当初……',
  level: 'B2.1',
  topic: 'A conversation about decisions and their consequences: a decision '
      'that changed my life, what would have happened if I had chosen '
      'differently, and a wish I have about the present.',
  practisePoints: [
    'Second and third conditionals about my own life',
    'wish + past / had + participle',
    'Argument connectors: although, however, therefore',
  ],
  scoringCriteria: [
    'Conditional structures correct',
    'wish followed by the right tense',
    'Ideas connected with linkers, not just "and"',
  ],
  priorityErrors: [
    '"would have" inside the if-clause',
    'wish + present tense',
    'linkers with the wrong grammar',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：和 AI 助手聊聊人生的假设。复制、开口、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '你的黄金句',
      text: 'If I hadn\'t …, I would never have … ——'
          '开口前先准备两个自己人生里的真实例子。',
    ),
  ],
);

final QuizContent zhEnB21BigText = zhEnBigText(
  id: 'zh_en_b2_1_bigtext',
  title: '整段填空：The mystery of the empty office',
  passageTitle: 'The mystery of the empty office',
  intro: '完成短文：被动语态、情态推测和第三条件句。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '语法侦探',
      text: '动作的执行者不重要 → 被动。这是推测 → must/might have。'
          '想象中的过去 → had + 过去分词。',
    ),
  ],
  template:
      'When Xiaomei arrived on Monday, the office was empty. The lights '
      'had been {{0}} on all weekend and a window {{1}} open. "Someone '
      '{{2}} have been here," she thought. Her laptop was still on the '
      'desk, so it {{3}} have been a thief — a thief would have {{4}} it. '
      'Then she saw a note: "The pipes burst on Saturday. Everyone was '
      '{{5}} to work from home. The message was {{6}} to all staff by '
      'email." Xiaomei sighed. If she {{7}} checked her inbox, she {{8}} '
      'have stayed in bed. Although the walk had woken her up, she would '
      'rather have {{9}} it on a beach.',
  blanks: [
    inputBlank('left'),
    inputBlank('was'),
    inputBlank('must'),
    inputBlank("can't", accepted: ['cannot', 'couldn\'t']),
    inputBlank('taken', accepted: ['stolen']),
    inputBlank('told', accepted: ['asked']),
    inputBlank('sent'),
    inputBlank('had'),
    inputBlank('would'),
    inputBlank('spent'),
  ],
  passageTranslation:
      '周一小美到公司时，办公室空无一人。灯亮了整个周末，一扇窗开着。'
      '"肯定有人来过，"她想。她的笔记本电脑还在桌上，所以不可能是小偷——'
      '小偷早拿走了。然后她看见一张字条："周六水管爆了。所有人改为在家办公。'
      '通知已通过邮件发给全体员工。"小美叹了口气。要是查过收件箱，'
      '她本可以继续睡觉。虽然这一路走来让她清醒了，她还是宁愿把这段路'
      '花在海滩上。',
);

final QuizContent zhEnB21SpeakingClose = zhEnSpeaking(
  id: 'zh_en_b2_1_speaking_close',
  title: '结业对话：辩论场',
  level: 'B2.1',
  topic: 'A friendly debate: choose a topic like remote work, cars in city '
      'centres or social media, defend your position and answer my '
      'counter-arguments.',
  practisePoints: [
    'Building an argument with although/however/therefore',
    'The passive for general claims: it is said, it has been shown',
    'Hypotheses: conditionals 2 and 3',
    'Polite disagreement: I see your point, but…',
  ],
  scoringCriteria: [
    'Arguments connected logically',
    'Passive and conditional structures correct',
    'Counter-arguments answered, not ignored',
  ],
  targetVocabulary: [
    'although', 'however', 'therefore', 'in my view', 'on the other hand',
  ],
  priorityErrors: [
    'linkers with the wrong grammar (despite + clause)',
    'conditional halves mixed up',
    'bare opinions with no support',
  ],
  mode: SpeakingMode.conversation,
  intro: 'B2.1 模块的结业对话：一场真正的辩论。复制、亮出立场、把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '先让一步，再转身',
      text: 'I see your point; however… ——先承认再反驳，'
          '正是让分歧听起来像 B2 的方法。',
    ),
  ],
);

// ── B2.2 转述与细节 ────────────────────────────────────────────────────────

final QuizContent zhEnB22SpeakingMid = zhEnSpeaking(
  id: 'zh_en_b2_2_speaking_mid',
  title: '对话：他们告诉我……',
  level: 'B2.2',
  topic: 'Gossip and messages: tell me about advice people have given you, '
      'things your family used to tell you, and a piece of news someone '
      'told you recently — all in reported speech.',
  practisePoints: [
    'Reported statements with backshift: she said she was…',
    'Reported questions and requests: he asked me if… / to…',
    'say vs tell used correctly',
  ],
  scoringCriteria: [
    'Backshift applied consistently',
    'tell + person, say without person',
    'Natural connectors between reported items',
  ],
  priorityErrors: [
    '"she said me"',
    'no backshift after said/told',
    'word order in reported questions',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：把别人对你说过的话转述给 AI 助手。复制、开口、'
      '把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '备好弹药',
      text: 'My grandmother always told me that… / A friend said he '
          'would… 开始前先想好三段回忆。',
    ),
  ],
);

final QuizContent zhEnB22BigText = zhEnBigText(
  id: 'zh_en_b2_2_bigtext',
  title: '整段填空：The message chain',
  passageTitle: 'The message chain',
  intro: '完成短文：间接引语、say/tell、附加疑问和 phrasal verbs。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '顺着链条走',
      text: '每个人都在转述上一个人的话：注意每一环的时态后移。',
    ),
  ],
  template:
      'On Monday Emma {{0}} her team that the client wanted changes. Tom '
      'understood that the client {{1}} unhappy, so he told Daniel that '
      'they {{2}} have to redo the design. Daniel {{3}} that it was '
      'impossible — they had run {{4}} of time. "You spoke to the client '
      'yourself, {{5}} you?" he asked Emma. "Well, no. Her assistant told '
      'me she {{6}} seen the drafts," Emma admitted. In the end, the '
      'client loved the design and had only asked them {{7}} change one '
      'colour. "I wish people {{8}} check the original message," Daniel '
      'sighed, "before a small comment {{9}} into a crisis."',
  blanks: [
    inputBlank('told'),
    inputBlank('was'),
    inputBlank('would'),
    inputBlank('said'),
    inputBlank('out'),
    inputBlank("didn't"),
    inputBlank('had'),
    inputBlank('to'),
    inputBlank('would'),
    inputBlank('turns', accepted: ['grows']),
  ],
  passageTranslation:
      '周一，Emma 告诉团队客户想要修改。Tom 理解成客户不满意，于是告诉 Daniel '
      '他们得重做设计。Daniel 说这不可能——时间已经用完了。"你亲自跟客户谈过，'
      '对吧？"他问 Emma。"呃，没有。她的助理告诉我客户看过草稿了，"Emma 承认。'
      '最后，客户其实很喜欢这个设计，只是请他们改一个颜色。"真希望大家都去核对'
      '原始信息，"Daniel 叹气说，"别让一句小评论演变成一场危机。"',
);

final QuizContent zhEnB22SpeakingClose = zhEnSpeaking(
  id: 'zh_en_b2_2_speaking_close',
  title: '结业对话：转述与揣测',
  level: 'B2.2',
  topic: 'A long conversation where you retell things: a conversation you '
      'had recently, advice you were given as a child, and a '
      'misunderstanding that turned out fine — plus deductions about why '
      'people acted as they did (must have, might have).',
  practisePoints: [
    'Reported speech with clean backshift',
    'Deductions about the past: must/might/can\'t have',
    'Question tags to keep the conversation alive',
    'Reporting verbs beyond say/tell: admit, promise, suggest',
  ],
  scoringCriteria: [
    'Reported structures accurate',
    'Deduction modals with the right certainty',
    'Conversation flows with tags and softeners',
  ],
  targetVocabulary: [
    'told', 'would', 'must have', 'suggest', 'turn out', 'sort out',
  ],
  priorityErrors: [
    'said/told confusion',
    'no backshift',
    'tags with the wrong auxiliary',
  ],
  mode: SpeakingMode.interview,
  intro: 'B2.2 模块——也是 B 级——的结业对话：转述、揣测、把话说圆。'
      '复制、开口、把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '附加疑问的妙用',
      text: '偶尔用 tag 收尾（…, wasn\'t it?）——既拉住对方，又非常地道。',
    ),
  ],
);
