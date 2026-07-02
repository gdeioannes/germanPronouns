import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// C1.1 — Abstraction & Precision · 抽象与精确. Mandarin → English.
///
/// Big rock: advanced verb complementation, mixed conditionals, and
/// cohesion/nominalization (Z31 — English discourse structure). Also articles
/// with abstract/generic nouns (Z11, persistent C1 error), clefts (Z22),
/// collocation (Z32).

final QuizContent zhEnC11MixedCond = zhEnFill(
  id: 'zh_en_c1_1_mixed_cond',
  title: '混合条件句',
  intro: '混合条件句把不同时间连接起来：过去的条件影响现在的结果，或反之。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '跨时间的假设',
      text: '过去条件→现在结果：If I had studied…, I would **be**… now；现在条件→过去结果亦可。',
    ),
  ],
  items: const [
    CourseItem(prompt: '如果我当时学了医，现在就是医生了。', answer: 'If I had studied medicine, I **would** be a doctor now.'),
    CourseItem(prompt: '如果我更有条理，就不会错过截止日期。', answer: "If I were more organised, I **wouldn't** have missed the deadline."),
    CourseItem(prompt: '如果他昨晚睡了，现在就不累了。', answer: "If he had slept last night, he **wouldn't** be tired now."),
    CourseItem(prompt: '如果她会开车，昨天就自己去了。', answer: 'If she could drive, she **would** have gone yesterday.'),
  ],
);

final QuizContent zhEnC11Complementation = zhEnFill(
  id: 'zh_en_c1_1_complementation',
  title: '高级动词搭配',
  intro: '许多动词和短语后接固定的形式，必须准确记忆——尤其是 to 作介词时。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ to 有时是介词（Z26）',
      text: 'be used to / look forward to + V-ing（to 是介词！）；tend / manage + to do；avoid + V-ing。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我不习惯早起。', answer: "I'm not used to **getting** up early."),
    CourseItem(prompt: '他往往话很多。', answer: 'He tends **to talk** a lot.'),
    CourseItem(prompt: '她设法完成了。', answer: 'She managed **to finish** it.'),
    CourseItem(prompt: '我避免吃太多糖。', answer: 'I avoid **eating** too much sugar.'),
    CourseItem(prompt: '我们期待见到你。', answer: 'We look forward **to seeing** you.'),
  ],
);

final QuizContent zhEnC11Participle = zhEnFill(
  id: 'zh_en_c1_1_participle',
  title: '分词短语',
  intro: '分词短语让句子更简洁，用来代替时间、原因或方式从句。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '三种分词',
      text: 'Having + V3（完成）、V-ing（主动/同时）、V3（被动）替代从句：Having finished…, she left。',
    ),
  ],
  items: const [
    CourseItem(prompt: '做完工作后，她回家了。', answer: '**Having** finished her work, she went home.'),
    CourseItem(prompt: '从山顶看，城市很小。', answer: '**Seen** from the top, the city looks small.'),
    CourseItem(prompt: '不知道该说什么，他保持沉默。', answer: '**Not** knowing what to say, he stayed silent.'),
    CourseItem(prompt: '因为天气好，我们去散步了。', answer: 'The weather **being** nice, we went for a walk.'),
  ],
);

final QuizContent zhEnC11SpeakArgue = zhEnSpeak(
  id: 'zh_en_c1_1_speak_argue',
  title: '开口说：展开抽象论证',
  intro: '用这些短语组织抽象、复杂的论证。听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '论证语篇',
      text: '先框定问题，再分层展开，最后收束：This is a complex issue… Ultimately…。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这是一个复杂的问题。', answer: 'This is a complex issue.'),
    CourseItem(prompt: '我们必须考虑几个因素。', answer: 'We must consider several factors.'),
    CourseItem(prompt: '一方面……然而另一方面……', answer: 'On the one hand … yet on the other …'),
    CourseItem(prompt: '这引出了一个更深层的问题。', answer: 'This raises a deeper question.'),
    CourseItem(prompt: '归根结底……', answer: 'Ultimately, ...'),
  ],
);

final QuizContent zhEnC11Nominalization = zhEnFill(
  id: 'zh_en_c1_1_nominalization',
  title: '名词化',
  intro: '正式书面英语常把动词或形容词变成名词，使文风更凝练、客观。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 动词 → 名词（Z31）',
      text: 'decide→decision，explain→explanation，increase（动/名）。名词化让英语书面语更「学术」。',
    ),
  ],
  items: const [
    CourseItem(prompt: '政府决定提高税收。', answer: 'The government made a **decision** to raise taxes.'),
    CourseItem(prompt: '这项发现改变了科学。', answer: 'The **discovery** changed science.'),
    CourseItem(prompt: '价格的上涨引发了抗议。', answer: 'The **increase** in prices caused protests.'),
    CourseItem(prompt: '他的解释很清楚。', answer: 'His **explanation** was clear.'),
    CourseItem(prompt: '我们讨论了这个问题。', answer: 'We had a **discussion** about the problem.'),
  ],
);

final QuizContent zhEnC11Cohesion = zhEnFill(
  id: 'zh_en_c1_1_cohesion',
  title: '语篇衔接：指代与替代',
  intro: '用 this/that/one/so/others 指代前文，避免重复，让文章连贯。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 避免重复（Z31）',
      text: '用 one 替代可数名词，so 替代整句，this/that/others 指代前文——英语靠这些衔接词织成篇章。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我买了两本书。这本很好。', answer: 'I bought two books. **This** one is good.'),
    CourseItem(prompt: '我需要一支笔。你有吗？', answer: 'I need a pen. Do you have **one**?'),
    CourseItem(prompt: '他说他会来，我也这么认为。', answer: "He said he'd come, and I think **so** too."),
    CourseItem(prompt: '这个方案比那个好。', answer: 'This plan is better than **that** one.'),
    CourseItem(prompt: '有些人喜欢茶，另一些喜欢咖啡。', answer: 'Some like tea; **others** like coffee.'),
  ],
);

final QuizContent zhEnC11ListenLecture = zhEnListen(
  id: 'zh_en_c1_1_listen_lecture',
  title: '听力：A university lecture',
  passageTitle: 'The psychology of decisions',
  passage:
      "Good morning. Today's lecture is about the psychology of "
      'decision-making. Many people believe that we make choices logically, '
      'weighing up the facts. However, research over the past few decades has '
      'shown that this is rarely the case. In fact, most of our decisions are '
      'influenced by emotion, habit, and the way information is presented. For '
      "example, if a product is described as '90% fat-free' rather than '10% "
      "fat', people are far more likely to buy it — even though the two "
      "statements mean exactly the same thing. This is known as the 'framing "
      "effect'.",
  passageTranslation:
      '早上好。今天的讲座讲的是决策心理学。许多人以为我们是理性地做选择、权衡事实。然而，'
      '过去几十年的研究表明，情况很少如此。事实上，我们的大多数决定都受到情绪、习惯以及信息呈现'
      '方式的影响。例如，如果一件产品被描述为「90% 无脂」而不是「含 10% 脂肪」，人们购买的可能性'
      '会大得多——尽管两种说法意思完全相同。这被称为「框架效应」。',
  intro: '先听，再答题。学术讲座里有名词化和被动结构。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '学术语体',
      text: 'decisions are influenced（被动）；is known as（被动）；decision-making（名词化）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the lecture about?',
      options: ['The psychology of decision-making', 'Economics', 'History'],
      correctIndex: 0,
      questionTranslation: '讲座的主题是什么？',
    ),
    ReadingQuestion(
      question: 'What does research show?',
      options: ['Decisions are influenced by emotion', 'We are fully logical', "Choices don't matter"],
      correctIndex: 0,
      questionTranslation: '研究显示了什么？',
    ),
    ReadingQuestion(
      question: "What is the 'framing effect'?",
      options: ['How wording changes choices', 'A type of picture', 'A maths rule'],
      correctIndex: 0,
      questionTranslation: '「框架效应」是什么？',
    ),
  ],
);

final QuizContent zhEnC11ArticlesAbstract = zhEnFill(
  id: 'zh_en_c1_1_articles_abstract',
  title: '冠词：抽象与泛指（进阶）',
  intro: '抽象名词泛指用零冠词；the + 形容词表一类人；独一无二、世纪等用 the。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 这里的冠词很微妙（Z11）',
      text: 'Education is…（零冠词，抽象）；the poor（一类人）；the internet、the 19th century（the）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '教育是通往机会的钥匙。', answer: '**Education** is the key to opportunity.'),
    CourseItem(prompt: '穷人往往受苦最多。', answer: '**The** poor often suffer most.'),
    CourseItem(prompt: '互联网改变了社会。', answer: '**The** internet has changed society.'),
    CourseItem(prompt: '幸福买不到。', answer: '**Happiness** cannot be bought.'),
    CourseItem(prompt: '十九世纪见证了巨变。', answer: '**The** nineteenth century saw great change.'),
  ],
);

final QuizContent zhEnC11ReadEthics = zhEnRead(
  id: 'zh_en_c1_1_read_ethics',
  title: '阅读：The ethics of technology',
  passageTitle: 'Machines and morality',
  passage:
      'As technology advances, society faces increasingly difficult ethical '
      'questions. Consider the case of self-driving cars. If an accident is '
      'unavoidable, how should the car be programmed to react? Should it '
      'protect its passengers at all costs, or should it minimise the total '
      'number of injuries, even if that means harming its owner? There is no '
      'easy answer. What is clear, however, is that these decisions can no '
      'longer be left to engineers alone. Philosophers, lawmakers and the '
      'public must all be involved. The technology may be new, but the moral '
      'questions it raises are as old as humanity itself.',
  passageTranslation:
      '随着科技进步，社会面临越来越棘手的伦理问题。以自动驾驶汽车为例：如果一场事故不可避免，'
      '汽车该被设定成如何反应？是不惜一切保护乘客，还是尽量减少总伤亡——哪怕这意味着伤及车主本人？'
      '这没有简单的答案。然而，有一点很清楚：这些决定不能再只交给工程师。哲学家、立法者和公众'
      '都必须参与其中。技术也许是新的，但它引发的道德问题，和人类本身一样古老。',
  intro: '读一段关于科技伦理的议论文。留意强调句、被动和名词化。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '强调句 + 被动',
      text: 'What is clear is that…（强调句）；can no longer be left（被动）；the questions it raises（省略 that 的从句）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What ethical example is given?',
      options: ['Self-driving cars', 'Smartphones', 'Social media'],
      correctIndex: 0,
      questionTranslation: '举了什么伦理例子？',
    ),
    ReadingQuestion(
      question: 'What is the dilemma?',
      options: ['Whom the car should protect', 'The price', 'The colour'],
      correctIndex: 0,
      questionTranslation: '两难在哪里？',
    ),
    ReadingQuestion(
      question: 'Who should be involved in the decisions?',
      options: ['Many groups, not just engineers', 'Only engineers', 'No one'],
      correctIndex: 0,
      questionTranslation: '谁应该参与决策？',
    ),
  ],
);

final QuizContent zhEnC11Cleft = zhEnFill(
  id: 'zh_en_c1_1_cleft',
  title: '强调句（分裂句）',
  intro: '用 It is/was … that … 和 What … is … 来突出句子中的某个信息。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 突出重点（Z22）',
      text: '中文靠「是…的」和主题句突出信息；英语用 It is X that… 和 What… is…。这是主题突出的桥梁。',
    ),
  ],
  items: const [
    CourseItem(prompt: '正是他打破了窗户。', answer: '**It** was he who broke the window.'),
    CourseItem(prompt: '我需要的是时间。', answer: '**What** I need is time.'),
    CourseItem(prompt: '正是在巴黎我们初次相遇。', answer: 'It was in Paris **that** we first met.'),
    CourseItem(prompt: '让我惊讶的是他的诚实。', answer: 'What surprised me **was** his honesty.'),
    CourseItem(prompt: '我真正想要的是安宁。', answer: 'What I really want **is** peace.'),
  ],
);

final QuizContent zhEnC11TheThe = zhEnFill(
  id: 'zh_en_c1_1_the_the',
  title: 'the … the …（越……越……）',
  intro: '用「the + 比较级 …, the + 比较级 …」表达「越……越……」。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '双比较级',
      text: 'The + 比较级 …, the + 比较级 …：The more you learn, the more you know。',
    ),
  ],
  items: const [
    CourseItem(prompt: '越快越好。', answer: 'The faster, **the** better.'),
    CourseItem(prompt: '你学得越多，懂得越多。', answer: 'The more you learn, **the** more you know.'),
    CourseItem(prompt: '天气越热，我越累。', answer: 'The hotter it gets, **the** more tired I feel.'),
    CourseItem(prompt: '价格越高，需求越低。', answer: 'The higher the price, **the** lower the demand.'),
    CourseItem(prompt: '我们等得越久，就越紧张。', answer: 'The longer we wait, **the** more nervous we get.'),
  ],
);

final QuizContent zhEnC11SpeakEmphasis = zhEnSpeak(
  id: 'zh_en_c1_1_speak_emphasis',
  title: '发音：强调与对比语调',
  intro: '用重音和音调突出关键词、表达对比。移动重音会改变句子的含义。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 重音改变含义（Z9）',
      text: '"I didn\'t say SHE took it" 里重读哪个词，意思就不同。用语调传达态度和对比。',
    ),
  ],
  items: const [
    CourseItem(prompt: '强调对比', answer: "I didn't say SHE took it — I said HE did."),
    CourseItem(prompt: '升调表惊讶', answer: 'You did WHAT?'),
    CourseItem(prompt: '降调表肯定', answer: "That's exactly what I mean."),
    CourseItem(prompt: '列举语调', answer: 'We need pens, paper, and folders.'),
    CourseItem(prompt: '一整句', answer: 'It was HER idea, not mine.'),
  ],
);

final QuizContent zhEnC11Collocations = zhEnFill(
  id: 'zh_en_c1_1_collocations',
  title: '搭配：make / do / take / have',
  intro: '这些常见动词的搭配很挑剔，用错就是典型的中式英语。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 搭配要成组记（Z32）',
      text: 'make a decision（不是 do a decision）、do homework、take a photo、have a break。整组记忆。',
    ),
  ],
  items: const [
    CourseItem(prompt: '做决定', answer: '**make** a decision'),
    CourseItem(prompt: '做作业', answer: '**do** your homework'),
    CourseItem(prompt: '拍照', answer: '**take** a photo'),
    CourseItem(prompt: '休息一下', answer: '**have** a break'),
    CourseItem(prompt: '犯错误', answer: '**make** a mistake'),
  ],
);

final QuizContent zhEnC11ListenPanel = zhEnListen(
  id: 'zh_en_c1_1_listen_panel',
  title: '听力：A panel discussion',
  passageTitle: 'The future of cities',
  passage:
      "Let's turn to our next topic: the future of cities. Professor Adams, "
      "you've argued that cities will become greener. Could you explain? — "
      'Certainly. As populations grow, we simply cannot continue building in '
      'the old way. Cities of the future will need vertical gardens, better '
      'public transport, and buildings that produce their own energy. — But '
      "isn't that expensive? — In the short term, yes. However, the cost of "
      'doing nothing would be far higher. If we fail to act, our cities will '
      'become unliveable.',
  passageTranslation:
      '我们进入下一个话题：城市的未来。Adams 教授，您认为城市会变得更绿色，能解释一下吗？——当然。'
      '随着人口增长，我们不能再以旧方式建设。未来的城市需要垂直花园、更好的公共交通，以及能自己'
      '产能的建筑。——但那不是很贵吗？——短期内是的。然而，什么都不做的代价会高得多。如果我们不'
      '行动，城市将变得无法居住。',
  intro: '先听，再答题。留意条件句和名词化。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '条件 + 名词化',
      text: 'If we fail to act, our cities will become…（条件）；the cost of doing nothing（名词化）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the topic?',
      options: ['The future of cities', 'The past', 'Farming'],
      correctIndex: 0,
      questionTranslation: '讨论的主题是什么？',
    ),
    ReadingQuestion(
      question: 'What does Professor Adams predict?',
      options: ['Greener cities', 'No cities', 'Bigger cars'],
      correctIndex: 0,
      questionTranslation: 'Adams 教授预测什么？',
    ),
    ReadingQuestion(
      question: 'What does he say about the cost?',
      options: ['Doing nothing costs more', "It's free", "It's cheap"],
      correctIndex: 0,
      questionTranslation: '他怎么看待成本？',
    ),
  ],
);

final QuizContent zhEnC11DictAcademic = zhEnDict(
  id: 'zh_en_c1_1_dict_academic',
  title: '听写：An academic paragraph',
  intro: '听句子并打出来。注意名词化、被动和分词结构。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 学术结构（Z31）',
      text: '写出名词化（findings, implications）、被动（it is believed）、分词（having considered）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '研究显示出一个明显的规律。', answer: 'The research shows a clear pattern.'),
    CourseItem(prompt: '这些发现有重要意义。', answer: 'These findings have important implications.'),
    CourseItem(prompt: '人们普遍认为气候正在变化。', answer: 'It is widely believed that the climate is changing.'),
    CourseItem(prompt: '在考虑了证据之后，我们可以得出结论。', answer: 'Having considered the evidence, we can draw a conclusion.'),
    CourseItem(prompt: '我们投入越多，收益越大。', answer: 'The more we invest, the greater the benefit.'),
  ],
);

final QuizContent zhEnC11ReadEssay = zhEnRead(
  id: 'zh_en_c1_1_read_essay',
  title: '阅读：An argumentative essay',
  passageTitle: 'Should university be free?',
  passage:
      'Should university education be free? Supporters argue that free '
      'education creates a fairer society, in which talented students are not '
      'held back by their financial background. Moreover, a well-educated '
      'population benefits everyone, since it leads to a stronger economy and '
      "greater innovation. Opponents, however, point out that 'free' education "
      'is not really free: it is paid for through higher taxes. They also argue '
      'that if everyone can attend university, degrees may lose their value. In '
      'my view, while the cost is a genuine concern, the long-term benefits of '
      'an educated society outweigh the disadvantages. Investment in education '
      'is, quite simply, an investment in the future.',
  passageTranslation:
      '大学教育应该免费吗？支持者认为，免费教育造就更公平的社会，让有才华的学生不再因经济背景'
      '而受限。此外，受过良好教育的人口惠及所有人，因为它带来更强的经济和更多的创新。然而，'
      '反对者指出，「免费」教育其实并不免费：它靠更高的税收买单。他们还认为，如果人人都能上大学，'
      '文凭可能会贬值。在我看来，尽管成本是一个真实的顾虑，但受教育社会的长远收益超过其弊端。'
      '对教育的投资，说到底，就是对未来的投资。',
  intro: '读一篇议论文。留意定语从句、名词化和论证连接词。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '议论文结构',
      text: 'in which…（定语从句）；Moreover / however（论证连接）；Investment…（名词化收尾）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What do supporters argue?',
      options: ['Free education creates fairness', "It's cheap", "It's bad"],
      correctIndex: 0,
      questionTranslation: '支持者的论点是什么？',
    ),
    ReadingQuestion(
      question: 'What do opponents say?',
      options: ["It's paid through taxes", "It's perfect", "It's illegal"],
      correctIndex: 0,
      questionTranslation: '反对者说什么？',
    ),
    ReadingQuestion(
      question: "What is the writer's view?",
      options: ['Benefits outweigh disadvantages', "It's a bad idea", 'No opinion'],
      correctIndex: 0,
      questionTranslation: '作者的观点是什么？',
    ),
  ],
);

/// C1.1 in chain order.
final List<QuizContent> zhEnC1_1 = [
  zhEnC11MixedCond,
  zhEnC11Complementation,
  zhEnC11Participle,
  zhEnC11SpeakArgue,
  zhEnC11Nominalization,
  zhEnC11Cohesion,
  zhEnC11ListenLecture,
  zhEnC11ArticlesAbstract,
  zhEnC11ReadEthics,
  zhEnC11Cleft,
  zhEnC11TheThe,
  zhEnC11SpeakEmphasis,
  zhEnC11Collocations,
  zhEnC11ListenPanel,
  zhEnC11DictAcademic,
  zhEnC11ReadEssay,
];
