import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// The C-level "all quiz kinds" boost for the zh_en course: one inline
/// big-text cloze plus two external-AI speaking exercises per module,
/// C1.1–C2.2.

// ── C1.1 抽象与精确 ────────────────────────────────────────────────────────

final QuizContent zhEnC11SpeakingMid = zhEnSpeaking(
  id: 'zh_en_c1_1_speaking_mid',
  title: '对话：分析一个趋势',
  level: 'C1.1',
  topic: 'An analytical discussion: pick a trend you know well (in your '
      'city, your industry or your generation), explain its causes and '
      'effects, and qualify your claims like an analyst.',
  practisePoints: [
    'Hedged claims: tend to, appear to, arguably',
    'Cause and effect with nominalisations: the growth of…, the loss of…',
    'One inversion for emphasis: Not only… but also…',
  ],
  scoringCriteria: [
    'Claims are qualified, not absolute',
    'Formal vocabulary and collocations',
    'Inversion used correctly at least once',
  ],
  priorityErrors: [
    'absolute claims where hedging is needed',
    'collocations translated literally from Chinese',
    'inversion without auxiliary-subject order',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：像向委员会汇报一样，和 AI 助手分析一个趋势。'
      '复制、开口、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '按栏思考',
      text: '原因 / 影响 / 限定语，各说一分钟——'
          '比十个零散观点更能体现 C1。',
    ),
  ],
);

final QuizContent zhEnC11BigText = zhEnBigText(
  id: 'zh_en_c1_1_bigtext',
  title: '整段填空：The report',
  passageTitle: 'The quarterly report',
  intro: '补全一份正式报告：名词化、模糊限定、被动与倒装。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '报告腔',
      text: '这里不说 I think：当家的是 it appears、the data suggest '
          '和抽象名词。',
    ),
  ],
  template:
      'The {{0}} of sales in the northern region appears {{1}} be linked '
      'to three factors. First, the late launch: the product was {{2}} two '
      'months after our competitors\'. Second, prices {{3}} to be higher '
      'than the market average, a gap that has widened since January. '
      'Third, and {{4}} most damaging, the loss {{5}} two key partners in '
      'March. It could be {{6}} that the region was under-resourced from '
      'the start. Not only {{7}} the team lack local knowledge — they also '
      'received the new materials late. Only in June {{8}} the situation '
      'begin to improve, and early figures suggest the recovery will '
      '{{9}} sense of the investment.',
  blanks: [
    inputBlank('decline', accepted: ['fall', 'drop', 'loss']),
    inputBlank('to'),
    inputBlank('launched', accepted: ['released']),
    inputBlank('tend', accepted: ['appear', 'seem']),
    inputBlank('arguably'),
    inputBlank('of'),
    inputBlank('argued'),
    inputBlank('did'),
    inputBlank('did'),
    inputBlank('make'),
  ],
  passageTranslation:
      '北部地区销售额的下滑似乎与三个因素有关。第一，上市过晚：产品比竞争对手'
      '晚了两个月。第二，价格往往高于市场均价，且差距自一月以来持续扩大。'
      '第三，也可能是伤害最大的一点：三月失去了两家关键合作伙伴。可以说，'
      '该地区从一开始就资源不足。团队不仅缺乏本地经验，新物料也拿得太晚。'
      '直到六月局面才开始好转，而初步数据显示，这轮复苏将让投入物有所值。',
);

final QuizContent zhEnC11SpeakingClose = zhEnSpeaking(
  id: 'zh_en_c1_1_speaking_close',
  title: '结业对话：正式陈述',
  level: 'C1.1',
  topic: 'Present a topic you know deeply for several minutes, as if to an '
      'expert audience, then take challenging questions: defend your '
      'analysis with qualified, precise language.',
  practisePoints: [
    'A structured argument: causes, effects, qualifications',
    'Formal register: nominalisations and collocations',
    'Hedging under pressure: that may be true to some extent, but…',
    'Emphasis with inversion where it counts',
  ],
  scoringCriteria: [
    'Register consistently formal',
    'Claims properly qualified and defended',
    'Grammar of inversion and nominalisation correct',
  ],
  targetVocabulary: [
    'arguably', 'tend to', 'raise a question', 'play a role', 'assumption',
  ],
  priorityErrors: [
    'register drops to casual speech',
    'literal Chinese collocations',
    'unqualified absolute claims',
  ],
  mode: SpeakingMode.roleplay,
  intro: 'C1.1 模块的结业对话：一场带"善意刁难"提问的正式陈述。'
      '复制、陈述、把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '优雅的让步',
      text: 'That may be true to some extent; however… ——'
          '让出一厘米，赢回一米。',
    ),
  ],
);

// ── C1.2 语体与修辞 ────────────────────────────────────────────────────────

final QuizContent zhEnC12SpeakingMid = zhEnSpeaking(
  id: 'zh_en_c1_2_speaking_mid',
  title: '对话：两副语体',
  level: 'C1.2',
  topic: 'One story, two audiences: first tell me about a problem at work '
      'or in your studies as you would tell a friend; then re-tell exactly '
      'the same events as if reporting formally to a director.',
  practisePoints: [
    'The informal version: phrasal verbs, contractions, casual markers',
    'The formal version: latinate verbs, nominalisations, passives',
    'Keeping the facts identical while the register changes',
  ],
  scoringCriteria: [
    'Clear register contrast between the two versions',
    'Formal vocabulary accurate (request, discover, require)',
    'No register mixing within a version',
  ],
  priorityErrors: [
    'formal words in the casual version and vice versa',
    'phrasal verbs in the formal report',
    'identical wording in both versions',
  ],
  mode: SpeakingMode.roleplay,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：同一件事，先穿便装讲，再穿西装讲。复制、开口、'
      '把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '换动词就是换衣服',
      text: 'find out → discover，ask for → request，sort out → resolve。'
          '十个动词换装，整个语体就转了。',
    ),
  ],
);

final QuizContent zhEnC12BigText = zhEnBigText(
  id: 'zh_en_c1_2_bigtext',
  title: '整段填空：The formal complaint',
  passageTitle: 'The formal complaint',
  intro: '补全一封正式投诉信：高语体、分词结构、被动与语篇标记。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '西装革履',
      text: '每个空都要选正式的那一个：request 而非 ask for；'
          'received 而非 got。',
    ),
  ],
  template:
      'Dear Ms. Serrano, I am writing with {{0}} to the delays affecting '
      'the Line 4 service. {{1}} used this line daily for six years, I '
      'have never experienced disruption on the current scale. Trains are '
      'frequently cancelled without notice; {{2}}, passengers are rarely '
      'informed of alternatives. It was only through a fellow passenger '
      '{{3}} I learned of last week\'s timetable change. I must therefore '
      '{{4}} that a revised timetable be published and that refunds {{5}} '
      'issued for season-ticket holders. {{6}}, the service has improved '
      'slightly since March; {{7}} said, the current situation remains '
      'unacceptable. What passengers ultimately {{8}} is reliability, not '
      'apologies. I look forward to {{9}} your response. Yours sincerely, '
      'Wang Lei.',
  blanks: [
    inputBlank('regard'),
    inputBlank('Having'),
    inputBlank('moreover', accepted: ['furthermore', 'in addition']),
    inputBlank('that'),
    inputBlank('request'),
    inputBlank('be'),
    inputBlank('Admittedly'),
    inputBlank('that'),
    inputBlank('need', accepted: ['want', 'require']),
    inputBlank('receiving'),
  ],
  passageTranslation:
      '尊敬的 Serrano 女士：兹就影响 4 号线服务的延误问题致函于您。'
      '六年来我每天乘坐这条线路，从未经历过如今这种规模的中断。列车常常'
      '不加通知就被取消；此外，乘客几乎得不到替代方案的信息。上周的时刻表'
      '调整，我还是从另一位乘客那里才得知的。因此我必须要求：公布修订后的'
      '时刻表，并向持季票乘客发放退款。诚然，三月以来服务略有改善；话虽如此，'
      '目前的状况仍不可接受。乘客最终需要的是可靠，而不是道歉。'
      '盼复。王磊 谨上。',
);

final QuizContent zhEnC12SpeakingClose = zhEnSpeaking(
  id: 'zh_en_c1_2_speaking_close',
  title: '结业对话：正式会谈',
  level: 'C1.2',
  topic: 'A formal meeting roleplay: you present a complaint or proposal '
      'to a director (me), negotiate the details, and close with agreed '
      'next steps — all in high register.',
  practisePoints: [
    'Formal openings and closings: I am writing/calling with regard to…',
    'Requests with formality: I must request that…, Would it be possible…',
    'Cleft sentences to focus the key point',
    'Discourse markers to structure the negotiation',
  ],
  scoringCriteria: [
    'Register formal and consistent',
    'Requests softened yet precise',
    'Clear structure with discourse markers',
  ],
  targetVocabulary: [
    'with regard to', 'request', 'nevertheless', 'that said', 'ultimately',
  ],
  priorityErrors: [
    'casual phrasal verbs in the formal meeting',
    'demands without softening',
    'missing structure markers',
  ],
  mode: SpeakingMode.roleplay,
  intro: 'C1.2 模块的结业对话：一场从头到尾的正式会谈。复制、谈判、'
      '把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '用模板开场',
      text: 'Thank you for seeing me. I\'d like to raise the issue of… ——'
          '这样的开场定下整场会谈的基调。',
    ),
  ],
);

// ── C2.1 风格驾驭 ──────────────────────────────────────────────────────────

final QuizContent zhEnC21SpeakingMid = zhEnSpeaking(
  id: 'zh_en_c2_1_speaking_mid',
  title: '对话：听懂弦外之音',
  level: 'C2.1',
  topic: 'A conversation full of understatement and idioms: we chat about '
      'work, houses and plans; I will underplay everything and you must '
      'respond to what I mean, not what I say — and use idioms naturally '
      'yourself.',
  practisePoints: [
    'Decoding understatement and responding to the real meaning',
    'Using three or four idioms naturally, not forced',
    'Fine modality: may well, might as well, needn\'t have',
  ],
  scoringCriteria: [
    'Idioms used accurately and in context',
    'Responses match the implied meaning',
    'Modal nuances correct',
  ],
  priorityErrors: [
    'idioms slightly wrong in wording',
    'literal responses to understatement',
    'over-formal register in casual chat',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：一场话里有话的闲聊。复制、对话、把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '每场两个习语',
      text: '放在真正合适的位置，然后收手。三个自然的习语'
          '胜过十个硬塞的。',
    ),
  ],
);

final QuizContent zhEnC21BigText = zhEnBigText(
  id: 'zh_en_c2_1_bigtext',
  title: '整段填空：The review',
  passageTitle: 'Restaurant review: The Golden Fork',
  intro: '补全一篇带英式反讽的餐厅评论：习语、轻描淡写和精细情态。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '先读出语气',
      text: '这篇评论踩着刹车夸、带着微笑批。每个空都要维持这个温度。',
    ),
  ],
  template:
      'The Golden Fork is not exactly {{0}} — dinner for two cost an arm '
      'and a {{1}} — but the cooking is not bad at {{2}}. The famous fish '
      'pie may {{3}} be the best in the city, though the waiter who '
      'described it for six full minutes was, shall we say, none too '
      '{{4}}. Service is a bit of a {{5}}: our starters arrived before '
      'the menus, and the wine never arrived at all. "It slipped my '
      '{{6}}," the waiter admitted, which at least had the charm of '
      'honesty. Would I go back? I think {{7}}. The chef clearly knows '
      'his craft, and at the end of the {{8}}, one forgives a great deal '
      'for pastry like that. But I might as {{9}} book somewhere quieter '
      'for the conversation.',
  blanks: [
    inputBlank('cheap'),
    inputBlank('leg'),
    inputBlank('all'),
    inputBlank('well'),
    inputBlank('brief', accepted: ['quick', 'short']),
    inputBlank('problem', accepted: ['mess', 'lottery']),
    inputBlank('mind'),
    inputBlank('so'),
    inputBlank('day'),
    inputBlank('well'),
  ],
  passageTranslation:
      '"金叉子"确实算不上便宜——两人晚餐花了大价钱——但菜做得着实不坏。'
      '招牌鱼派很可能是全城最好的，只是那位足足介绍了六分钟的服务员，'
      '怎么说呢，不太"简短"。服务有点小状况：前菜比菜单先上，酒则始终没来。'
      '"我完全忘了，"服务员承认——至少这份诚实还算可爱。会再去吗？我想会的。'
      '主厨的手艺明摆着，说到底，为那样的酥皮可以原谅很多。'
      '不过想好好聊天的话，我还是不如订个安静点的地方。',
);

final QuizContent zhEnC21SpeakingClose = zhEnSpeaking(
  id: 'zh_en_c2_1_speaking_close',
  title: '结业对话：幽默与分寸',
  level: 'C2.1',
  topic: 'Tell me about a disaster that turned out fine — a trip, a meal, '
      'a project — told with irony and understatement, British style. Then '
      'we review a plan together and you push back with softened but firm '
      'disagreement.',
  practisePoints: [
    'A story told with understatement and irony',
    'Idioms placed naturally at key moments',
    'Ellipsis in the back-and-forth: so do I, I hope not, neither did we',
    'Firm but soft disagreement',
  ],
  scoringCriteria: [
    'Humour lands through language, not volume',
    'Idioms and litotes accurate',
    'Natural short responses with ellipsis',
  ],
  priorityErrors: [
    'idioms misquoted',
    'irony explained instead of performed',
    'full sentences where a native would use two words',
  ],
  mode: SpeakingMode.conversation,
  intro: 'C2.1 模块的结业对话：用英式的从容讲一场"灾难"。复制、开口、'
      '把分数带回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '给形容词踩刹车',
      text: '想说 terrible 的地方，说 "not ideal"。'
          'C2 的听众听得出刹车，也就听得出事情的分量。',
    ),
  ],
);

// ── C2.2 精通 ─────────────────────────────────────────────────────────────

final QuizContent zhEnC22SpeakingMid = zhEnSpeaking(
  id: 'zh_en_c2_2_speaking_mid',
  title: '对话：当编辑',
  level: 'C2.2',
  topic: 'You are the editor: I will say bloated, clumsy or ambiguous '
      'sentences and you re-say each one better — tighter, clearer, in the '
      'right register — explaining your choice in one line.',
  practisePoints: [
    'Rewriting wordy sentences concisely on the spot',
    'Choosing register deliberately and saying why',
    'Precision vocabulary over general words',
  ],
  scoringCriteria: [
    'Rewrites genuinely improve the original',
    'Explanations are precise and brief',
    'No meaning lost in the compression',
  ],
  priorityErrors: [
    'rewrites that only shuffle words',
    'register mismatches',
    'over-explanation',
  ],
  mode: SpeakingMode.roleplay,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: '中段检查点：这次你来当编辑，把臃肿的句子当场改好。复制、开口、'
      '把分数输回来。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '先找动词',
      text: '几乎每个臃肿的句子里都埋着一个被名词困住的动词。'
          '把它挖出来，句子自己就好了。',
    ),
  ],
);

final QuizContent zhEnC22BigText = zhEnBigText(
  id: 'zh_en_c2_2_bigtext',
  title: '整段填空：The graduation address',
  passageTitle: 'The graduation address',
  intro: '最后一篇整段填空：修辞、倒装、语体与最终的细节陷阱——'
      '整门课浓缩在一页里。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '课程收官',
      text: '每个空都是你已经掌握的一个模块。通读、享受、收尾。',
    ),
  ],
  template:
      'Friends, we gather to celebrate not an ending {{0}} a beginning. '
      'Never {{1}} this room held so much hard-won knowledge. You arrived '
      'unable to order a coffee; you leave able to argue, to joke, to '
      '{{2}} between registers as easily as you change shoes. {{3}} is '
      'short, and people {{4}} generous with their patience — so speak, '
      'and speak badly when you must, because it was the mistakes {{5}} '
      'taught you the most. Having climbed this far, you may {{6}} '
      'wonder what comes next. In other {{7}}, everything. Eventually '
      'every learner realises the secret: nobody is finished. Not the '
      'teachers, not the natives, not even the poets. What we call '
      'mastery is simply curiosity {{8}} refused to give {{9}}. '
      'Congratulations — now go and use it.',
  blanks: [
    inputBlank('but'),
    inputBlank('has'),
    inputBlank('switch', accepted: ['move', 'shift']),
    inputBlank('Life'),
    inputBlank('are'),
    inputBlank('that', accepted: ['which']),
    inputBlank('well'),
    inputBlank('words'),
    inputBlank('that', accepted: ['which']),
    inputBlank('up'),
  ],
  passageTranslation:
      '朋友们，我们相聚于此，庆祝的不是终点，而是起点。这间屋子从未装下过'
      '这么多来之不易的学识。你们来时连一杯咖啡都点不了；离开时已能辩论、'
      '能开玩笑、能像换鞋一样在语体之间切换。人生苦短，而人们对耐心却慷慨'
      '——所以去说吧，必要时就说得磕磕绊绊，因为教你最多的恰恰是那些错误。'
      '爬到这里，你们大概会想：接下来是什么？换句话说：是一切。终有一天，'
      '每个学习者都会明白这个秘密：没有人是"学完了"的。老师没有，母语者'
      '没有，连诗人也没有。我们所谓的精通，不过是不肯认输的好奇心。'
      '祝贺你们——现在，去用它吧。',
);

final QuizContent zhEnC22SpeakingClose = zhEnSpeaking(
  id: 'zh_en_c2_2_speaking_close',
  title: '结业对话：精通',
  level: 'C2.2',
  topic: 'The final conversation: a wide-ranging, natural discussion '
      'moving between registers — small talk, a debate, a story with '
      'irony, and a formal summing-up — as one continuous conversation. '
      'Show everything.',
  practisePoints: [
    'Register switching on demand, mid-conversation',
    'Rhetorical structure in the summing-up',
    'Idiom, understatement and precise modality',
    'The near-native details: articles, third-person -s, final consonants',
  ],
  scoringCriteria: [
    'Range: every register visited convincingly',
    'Accuracy at the near-native level',
    'The conversation feels effortless, not performed',
  ],
  targetVocabulary: [
    'eventually', 'that said', 'may well', 'what matters is', 'in short',
  ],
  priorityErrors: [
    'register bleed between sections',
    'the classic survivors: dropped articles and -s endings',
    'idioms misquoted',
  ],
  mode: SpeakingMode.conversation,
  intro: '整门课的最后一场对话。你构建的一切，在一次谈话里。复制、开口、'
      '带回你的最后一个分数。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '最后的建议',
      text: '不要展示语言，去使用它。当你不再想着精通时，精通才显形。',
    ),
  ],
);
