import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';
import 'zh_en_extra_c.dart';

/// C1.2 — Register & Rhetoric · 语体与修辞. Mandarin → English.
///
/// Big rock: inversion / cleft / fronting, participle-clause mastery, and
/// hedging & stance (Z31 — Chinese directness vs English hedging). Also
/// impersonal passive reporting (Z27), concession (Z25), collocation & idiom
/// (Z32), fronting/topic (Z22).

final QuizContent zhEnC12Inversion = zhEnFill(
  id: 'zh_en_c1_2_inversion',
  title: '否定副词前置引起的倒装',
  intro: '否定或限制性副词放在句首时，主谓要倒装——这是正式、强调的写法。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 否定开头就倒装（Z22）',
      text: 'Never / Not only / Little / Under no circumstances 放句首 → 借助动词倒装（Never **have** I…）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我从没见过这样的美景。', answer: 'Never **have** I seen such beauty.'),
    CourseItem(prompt: '他不但迟到，还忘了带报告。', answer: 'Not only **was** he late, but he also forgot the report.'),
    CourseItem(prompt: '他一到就下起了雨。', answer: 'No sooner **had** he arrived than it rained.'),
    CourseItem(prompt: '我几乎不了解她。', answer: 'Little **did** I know her.'),
    CourseItem(prompt: '任何情况下都不应开门。', answer: 'Under no circumstances **should** you open the door.'),
    CourseItem(prompt: '我很少遇到这么难的问题。', answer: 'Rarely **have** I met such a difficult problem.'),
    CourseItem(prompt: '她刚坐下电话就响了。', answer: 'Hardly **had** she sat down when the phone rang.'),
    CourseItem(prompt: '他直到那时才明白真相。', answer: 'Only then **did** he understand the truth.'),
    CourseItem(prompt: '我们绝不会忘记那一天。', answer: 'Never **will** we forget that day.'),
    CourseItem(prompt: '他不仅道了歉，还赔偿了损失。', answer: 'Not only **did** he apologise, but he also paid for the damage.'),
    CourseItem(prompt: '她刚说完，观众就鼓起掌来。', answer: 'No sooner **had** she finished than the audience applauded.'),
    CourseItem(prompt: '我做梦也没想到会赢。', answer: 'Never **did** I dream of winning.'),
    CourseItem(prompt: '直到很久以后我们才知道真相。', answer: 'Only much later **did** we learn the truth.'),
    CourseItem(prompt: '他很少在公众场合讲话。', answer: 'Seldom **does** he speak in public.'),
    CourseItem(prompt: '任何情况下都不得泄露密码。', answer: 'Under no circumstances **must** the password be shared.'),
  ],
);

final QuizContent zhEnC12CondInversion = zhEnFill(
  id: 'zh_en_c1_2_cond_inversion',
  title: '条件句的倒装（省略 if）',
  intro: '正式条件句可以省略 if，改用倒装。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Had / Were / Should 开头',
      text: 'Had I known… = If I had known…；Were I… = If I were…；Should you… = If you should…。',
    ),
  ],
  items: const [
    CourseItem(prompt: '要是我早知道，就会帮你。', answer: '**Had** I known, I would have helped.'),
    CourseItem(prompt: '如果我是你，我会拒绝。', answer: '**Were** I you, I would refuse.'),
    CourseItem(prompt: '万一你需要帮助，打给我。', answer: '**Should** you need help, call me.'),
    CourseItem(prompt: '要是没有你的帮助，我们就失败了。', answer: 'Had it not been for your help, we **would** have failed.'),
    CourseItem(prompt: '万一计划有变，我们会通知您。', answer: '**Should** the plan change, we will inform you.'),
    CourseItem(prompt: '要是我当时在场，我就阻止了。', answer: '**Had** I been there, I would have stopped it.'),
    CourseItem(prompt: '如果我处在她的位置，我会接受。', answer: '**Were** I in her position, I would accept.'),
    CourseItem(prompt: '要是他们早点动身，就不会误机了。', answer: 'Had they left earlier, they **would** not have missed the flight.'),
    CourseItem(prompt: '万一下雨，活动将移到室内。', answer: '**Should** it rain, the event will move indoors.'),
    CourseItem(prompt: '如果不是价格太高，我们就买了。', answer: '**Had** the price not been so high, we would have bought it.'),
    CourseItem(prompt: '万一您需要更多信息，请访问我们的网站。', answer: '**Should** you require further information, please visit our website.'),
    CourseItem(prompt: '要是我听了她的建议，就成功了。', answer: '**Had** I followed her advice, I would have succeeded.'),
    CourseItem(prompt: '如果这属实，后果将很严重。', answer: '**Were** this true, the consequences would be serious.'),
    CourseItem(prompt: '要是他们做了准备，就不会那么慌了。', answer: '**Had** they prepared, they would not have panicked.'),
    CourseItem(prompt: '万一航班取消，您将获得全额退款。', answer: '**Should** the flight be cancelled, you will receive a full refund.'),
  ],
);

final QuizContent zhEnC12Fronting = zhEnFill(
  id: 'zh_en_c1_2_fronting',
  title: '前置强调',
  intro: '把想强调的成分提到句首，让语气更有力，有时会引起倒装。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 主题前置（Z22）',
      text: '源自中文的主题句：把强调的部分提前——Money I don\'t have; time I **do**。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这样的错误绝不能重犯。', answer: 'Such mistakes **must** never be repeated.'),
    CourseItem(prompt: '钱我没有，时间我有。', answer: "Money I don't have; time I **do**."),
    CourseItem(prompt: '山谷中坐落着一座小村庄。', answer: 'In the valley **lay** a small village.'),
    CourseItem(prompt: '他说的话我一个字都不信。', answer: 'Not a word **did** I believe.'),
    CourseItem(prompt: '她这么说，也这么做了。', answer: 'So she said, and so she **did**.'),
    CourseItem(prompt: '门外站着一个陌生人。', answer: 'Outside the door **stood** a stranger.'),
    CourseItem(prompt: '这一点我们完全同意。', answer: 'On this point we **do** agree.'),
    CourseItem(prompt: '山顶上矗立着一座古塔。', answer: 'On the hilltop **stood** an ancient tower.'),
    CourseItem(prompt: '这样的机会你再也遇不到了。', answer: 'Such a chance you will **never** find again.'),
    CourseItem(prompt: '桌上放着一封没拆的信。', answer: 'On the table **lay** an unopened letter.'),
    CourseItem(prompt: '树林深处藏着一间小木屋。', answer: 'Deep in the woods **stood** a little cabin.'),
    CourseItem(prompt: '这个问题我们稍后再谈。（前置宾语）', answer: 'This question we will **discuss** later.'),
    CourseItem(prompt: '钟声响起，随之而来的是一片寂静。', answer: 'The bell rang, and then **came** the silence.'),
    CourseItem(prompt: '如此重要的决定，我们不能仓促做出。', answer: 'So important a decision we cannot **make** in haste.'),
    CourseItem(prompt: '正前方矗立着大教堂。', answer: 'Straight ahead **stood** the cathedral.'),
  ],
);

final QuizContent zhEnC12SpeakRegister = zhEnSpeak(
  id: 'zh_en_c1_2_speak_register',
  title: '开口说：正式与非正式语体',
  intro: '同一个意思，正式和非正式场合说法不同。听并跟读，感受差异。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '语体的选择（Z32）',
      text: '正式场合更委婉、更间接：Would you like me to assist you? vs Need a hand?',
    ),
  ],
  items: const [
    CourseItem(prompt: '非正式：需要帮忙吗？', answer: 'Do you need a hand?'),
    CourseItem(prompt: '正式：需要我协助吗？', answer: 'Would you like me to assist you?'),
    CourseItem(prompt: '非正式：我觉得不行。', answer: "I don't think so."),
    CourseItem(prompt: '正式：恐怕这不太可行。', answer: "I'm afraid that won't be possible."),
    CourseItem(prompt: '正式请求', answer: 'I was wondering if you could help me.'),
  ],
);

final QuizContent zhEnC12Hedging = zhEnFill(
  id: 'zh_en_c1_2_hedging',
  title: '模糊限制与语气软化',
  intro: '学术和正式英语常用模糊限制语来软化语气、避免绝对化。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 别太绝对（Z31）',
      text: 'tend to / appear to / arguably / to some extent 让论断更谨慎。中文更直接，注意补上这层委婉。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这在某种程度上是对的。', answer: 'This is, to some **extent**, true.'),
    CourseItem(prompt: '似乎有个误会。', answer: 'There **appears** to be a misunderstanding.'),
    CourseItem(prompt: '这往往是这样。', answer: 'This **tends** to be the case.'),
    CourseItem(prompt: '可以说结果是成功的。', answer: 'The result was, **arguably**, a success.'),
    CourseItem(prompt: '我倾向于认为他错了。', answer: "I'm **inclined** to think he's wrong."),
    CourseItem(prompt: '数据似乎支持这一观点。', answer: 'The data **seems** to support this view.'),
    CourseItem(prompt: '这或许并不完全准确。', answer: 'This may not be **entirely** accurate.'),
    CourseItem(prompt: '在多数情况下，这个方法有效。', answer: 'In **most** cases, this method works.'),
    CourseItem(prompt: '有人可能会说这太贵了。', answer: 'One **might** argue that it is too expensive.'),
    CourseItem(prompt: '结果在一定程度上取决于运气。', answer: 'The outcome depends, to a certain **extent**, on luck.'),
    CourseItem(prompt: '证据表明（似乎表明）存在联系。', answer: 'The evidence **suggests** a connection.'),
    CourseItem(prompt: '这大体上是正确的。', answer: 'This is **broadly** correct.'),
    CourseItem(prompt: '结果可能因人而异。', answer: 'Results may **vary** from person to person.'),
    CourseItem(prompt: '据我们所知，这是首例。', answer: 'As far as we **know**, this is the first case.'),
    CourseItem(prompt: '这个说法似乎有些夸张。', answer: 'The claim **appears** somewhat exaggerated.'),
  ],
);

final QuizContent zhEnC12Impersonal = zhEnFill(
  id: 'zh_en_c1_2_impersonal',
  title: '客观被动转述',
  intro: '用 It is said that… / 主语 + be + 过去分词 + to do 客观转述，不点名消息来源。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '两种句型',
      text: 'It is said/believed that…；或 He is thought/said to be…。常见于新闻和学术。',
    ),
  ],
  items: const [
    CourseItem(prompt: '据说他很有钱。', answer: 'It is **said** that he is rich.'),
    CourseItem(prompt: '人们认为运动有益健康。', answer: 'Exercise is **thought** to be good for health.'),
    CourseItem(prompt: '据报道事故发生在夜里。', answer: 'The accident is **reported** to have happened at night.'),
    CourseItem(prompt: '大家普遍相信……', answer: 'It is widely **believed** that ...'),
    CourseItem(prompt: '他被认为是最佳人选。', answer: 'He is **considered** to be the best candidate.'),
    CourseItem(prompt: '据信这幅画已有三百年历史。', answer: 'The painting is **believed** to be three hundred years old.'),
    CourseItem(prompt: '据说那家公司陷入了困境。', answer: 'The company is **said** to be in trouble.'),
    CourseItem(prompt: '据估计有上千人参加。', answer: 'It is **estimated** that a thousand people attended.'),
    CourseItem(prompt: '他被传闻已经辞职。', answer: 'He is **rumoured** to have resigned.'),
    CourseItem(prompt: '据预计价格会上涨。', answer: 'It is **expected** that prices will rise.'),
    CourseItem(prompt: '据了解双方已达成协议。', answer: 'It is **understood** that both sides have reached an agreement.'),
    CourseItem(prompt: '他被认为已离开该国。', answer: 'He is **thought** to have left the country.'),
    CourseItem(prompt: '据称该公司隐瞒了亏损。', answer: 'The company is **alleged** to have hidden its losses.'),
    CourseItem(prompt: '普遍认为锻炼能改善情绪。', answer: 'It is generally **accepted** that exercise improves mood.'),
    CourseItem(prompt: '这座桥据说是本地最古老的。', answer: 'The bridge is **said** to be the oldest in the area.'),
  ],
);

final QuizContent zhEnC12ListenInterview = zhEnListen(
  id: 'zh_en_c1_2_listen_interview',
  title: '听力：A political interview',
  passageTitle: 'The minister responds',
  passage:
      'Minister, thank you for joining us. Critics say your new housing policy '
      'has failed. How do you respond? — Well, I would say it\'s too early to '
      'judge. It is true that progress has been slower than we hoped. However, '
      "we've laid the foundations for long-term change. — But families are "
      'still waiting for homes. — I understand their frustration, and I share '
      'it. What I would ask is for a little more patience. Rome, as they say, '
      "wasn't built in a day. — Minister, thank you.",
  passageTranslation:
      '部长，感谢您接受采访。批评者说您的新住房政策失败了，您怎么回应？——嗯，我会说现在下结论'
      '还为时过早。诚然，进展比我们希望的要慢。然而，我们已经为长期变革打下了基础。——但families'
      '仍在等待住房。——我理解他们的沮丧，我也感同身受。我想请求的是多一点耐心。正如人们所说，'
      '罗马不是一天建成的。——部长，谢谢您。',
  intro: '先听，再答题。政治访谈中大量使用委婉和习语。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '委婉 + 习语（Z31/Z32）',
      text: "I would say、too early to judge（委婉）；Rome wasn't built in a day（习语）；What I would ask…（强调句）。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the interview about?',
      options: ['A housing policy', 'A war', 'The economy'],
      correctIndex: 0,
      questionTranslation: '采访的主题是什么？',
    ),
    ReadingQuestion(
      question: 'How does the minister respond to criticism?',
      options: ["It's too early to judge", 'He agrees it failed', 'He refuses to answer'],
      correctIndex: 0,
      questionTranslation: '部长如何回应批评？',
    ),
    ReadingQuestion(
      question: 'What does he ask for?',
      options: ['Patience', 'Money', 'Votes'],
      correctIndex: 0,
      questionTranslation: '他请求什么？',
    ),
  ],
);

final QuizContent zhEnC12Discourse = zhEnFill(
  id: 'zh_en_c1_2_discourse',
  title: '语篇连接词',
  intro: '用 nonetheless、moreover、by contrast 等连接观点，让论述更有条理、更正式。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '连接词的功能',
      text: 'nonetheless（尽管如此）、moreover（此外）、by contrast（相比之下）、in other words（换言之）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '尽管如此，我们仍需谨慎。', answer: '**Nonetheless**, we must be cautious.'),
    CourseItem(prompt: '此外，还有其他因素。', answer: '**Moreover**, there are other factors.'),
    CourseItem(prompt: '相比之下，第二种方案更便宜。', answer: 'By **contrast**, the second option is cheaper.'),
    CourseItem(prompt: '换句话说，我们失败了。', answer: 'In **other** words, we failed.'),
    CourseItem(prompt: '也就是说，需要更多时间。', answer: 'That is to **say**, more time is needed.'),
    CourseItem(prompt: '同样地，第二个实验也失败了。', answer: '**Similarly**, the second experiment failed.'),
    CourseItem(prompt: '因此，必须采取行动。', answer: '**Consequently**, action must be taken.'),
    CourseItem(prompt: '然而，证据并不充分。', answer: '**Nevertheless**, the evidence is not sufficient.'),
    CourseItem(prompt: '总而言之，改革势在必行。', answer: 'In **summary**, reform is essential.'),
    CourseItem(prompt: '此外，成本也是一个因素。', answer: '**Furthermore**, cost is also a factor.'),
    CourseItem(prompt: '就此而言，两个方案是相同的。（in this respect）', answer: 'In this **respect**, the two plans are identical.'),
    CourseItem(prompt: '综上所述，该提案值得支持。', answer: 'In **conclusion**, the proposal deserves support.'),
    CourseItem(prompt: '与此同时，成本持续上升。', answer: '**Meanwhile**, costs continued to rise.'),
    CourseItem(prompt: '更重要的是，数据是可靠的。', answer: 'More **importantly**, the data is reliable.'),
    CourseItem(prompt: '换个角度说，问题在于信任。', answer: 'Put **another** way, the problem is trust.'),
  ],
);

final QuizContent zhEnC12ReadColumn = zhEnRead(
  id: 'zh_en_c1_2_read_column',
  title: '阅读：An opinion column',
  passageTitle: 'The tyranny of the slogan',
  passage:
      'There is a growing tendency, especially among politicians, to speak in '
      'slogans rather than substance. Complex problems are reduced to '
      'three-word phrases, as if a catchy rhyme could solve a housing crisis or '
      'repair a broken health service. This, I would argue, is not merely '
      'lazy; it is dangerous. When language becomes empty, so too does thought. '
      'A society that stops demanding careful argument will, sooner or later, '
      'stop receiving it. We would do well to remember that the loudest voice '
      'is rarely the wisest, and that a simple answer to a difficult question '
      'is almost always the wrong one.',
  passageTranslation:
      '有一种日益增长的倾向，尤其在政客中间：说口号，而非实质。复杂的问题被简化成三字短语，'
      '仿佛一句朗朗上口的顺口溜就能解决住房危机或修复崩坏的医疗系统。我要说，这不仅仅是懒惰，'
      '更是危险。当语言变得空洞，思想也随之空洞。一个不再要求缜密论证的社会，迟早也将不再得到'
      '缜密论证。我们最好记住：最大的嗓门很少是最智慧的，而对难题给出的简单答案，几乎总是错的。',
  intro: '读一篇观点专栏。留意修辞、倒装和习语式的表达。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '修辞语体',
      text: 'so too does thought（倒装）；We would do well to…（委婉建议）；排比与对比增强说服力。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What does the writer criticise?',
      options: ['Empty slogans', 'Long books', 'Foreign words'],
      correctIndex: 0,
      questionTranslation: '作者批评什么？',
    ),
    ReadingQuestion(
      question: 'What does the writer fear?',
      options: ['That thought becomes empty', 'That people read too much', 'Nothing'],
      correctIndex: 0,
      questionTranslation: '作者担心什么？',
    ),
    ReadingQuestion(
      question: 'What is the writer\'s view of simple answers?',
      options: ['Usually wrong', 'Always right', 'Harmless'],
      correctIndex: 0,
      questionTranslation: '作者怎么看简单答案？',
    ),
  ],
);

final QuizContent zhEnC12Concession = zhEnFill(
  id: 'zh_en_c1_2_concession',
  title: '让步：whereas / albeit / despite',
  intro: '让步与对比连接词各有搭配，用对了文风才地道。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 搭配不同（Z25）',
      text: 'although/though + 句子；despite / in spite of + 名词或 -ing；whereas 表对比；albeit 很正式。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他很聪明，尽管有点懒。', answer: 'He is clever, **albeit** a little lazy.'),
    CourseItem(prompt: '尽管下雨，比赛还是进行了。', answer: '**Despite** the rain, the match went ahead.'),
    CourseItem(prompt: '有些人喜欢城市，而另一些喜欢乡村。', answer: 'Some like the city, **whereas** others prefer the country.'),
    CourseItem(prompt: '虽然努力了，她还是失败了。', answer: '**Although** she tried, she failed.'),
    CourseItem(prompt: '尽管有困难，他们成功了。', answer: 'They succeeded **in** spite of the difficulties.'),
    CourseItem(prompt: '尽管年事已高，他仍每天工作。', answer: '**Despite** his age, he still works every day.'),
    CourseItem(prompt: '北方多雨，而南方干燥。', answer: 'The north is rainy, **whereas** the south is dry.'),
    CourseItem(prompt: '这是个好方案，虽然并不便宜。', answer: 'It is a good plan, **albeit** not a cheap one.'),
    CourseItem(prompt: '尽管迟到了，她还是被放了进去。', answer: '**Despite** arriving late, she was let in.'),
    CourseItem(prompt: '虽然价格高，需求仍在增长。', answer: '**Although** prices are high, demand keeps growing.'),
    CourseItem(prompt: '尽管缺乏经验，她表现出色。', answer: '**Despite** her lack of experience, she performed brilliantly.'),
    CourseItem(prompt: '他接受了这份工作，虽然有些犹豫。', answer: 'He accepted the job, **albeit** with some hesitation.'),
    CourseItem(prompt: '老一代重视储蓄，而年轻人更爱消费。', answer: 'The older generation values saving, **whereas** the young prefer spending.'),
    CourseItem(prompt: '尽管练习了几个月，他还是失败了。', answer: '**Despite** practising for months, he failed.'),
    CourseItem(prompt: '虽然天气恶劣，救援仍在继续。', answer: '**Although** the weather was terrible, the rescue continued.'),
  ],
);

final QuizContent zhEnC12Idioms = zhEnFill(
  id: 'zh_en_c1_2_idioms',
  title: '高级搭配与习语',
  intro: '地道的搭配和习语要整体记忆——这是摆脱中式英语的关键。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 成组记忆（Z32）',
      text: 'make up your mind、come to terms with、break the ice——别逐字直译中文。',
    ),
  ],
  items: const [
    CourseItem(prompt: '下定决心', answer: 'to **make** up your mind'),
    CourseItem(prompt: '接受（并释怀）', answer: 'to **come** to terms with it'),
    CourseItem(prompt: '起重要作用', answer: 'to play a key **role**'),
    CourseItem(prompt: '打破僵局', answer: 'to break the **ice**'),
    CourseItem(prompt: '权衡利弊', answer: 'to weigh the **pros** and cons'),
    CourseItem(prompt: '开门见山，直奔主题', answer: 'to get straight to the **point**'),
    CourseItem(prompt: '设身处地为某人着想', answer: 'to put yourself in someone\'s **shoes**'),
    CourseItem(prompt: '雪上加霜', answer: 'to add insult to **injury**'),
    CourseItem(prompt: '三思而后行', answer: 'to think **twice** before acting'),
    CourseItem(prompt: '实话实说', answer: 'to tell the **truth**'),
    CourseItem(prompt: '未雨绸缪（为最坏情况做打算）', answer: 'to prepare for the **worst**'),
    CourseItem(prompt: '话中有话，言外之意', answer: 'to read between the **lines**'),
    CourseItem(prompt: '一石二鸟', answer: 'to kill two birds with one **stone**'),
    CourseItem(prompt: '各让一步，折中处理', answer: 'to meet someone **halfway**'),
    CourseItem(prompt: '守口如瓶（保守秘密）', answer: 'to keep it under your **hat**'),
  ],
);

final QuizContent zhEnC12SpeakPersuade = zhEnSpeak(
  id: 'zh_en_c1_2_speak_persuade',
  title: '发音：有说服力的语调',
  intro: '用停顿、重音和排比增强说服力；语调传达信念。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '修辞节奏',
      text: '三段排比、反问、恰当停顿，让讲话更有力量。',
    ),
  ],
  items: const [
    CourseItem(prompt: '三段排比', answer: 'It is unfair, it is unwise, and it is unnecessary.'),
    CourseItem(prompt: '反问', answer: 'How much longer must we wait?'),
    CourseItem(prompt: '停顿制造效果', answer: 'The answer … is simple.'),
    CourseItem(prompt: '升调引出重点', answer: 'And the reason? Trust.'),
    CourseItem(prompt: '一整句', answer: 'We can do better, and we must.'),
  ],
);

final QuizContent zhEnC12PhrasalAdv = zhEnFill(
  id: 'zh_en_c1_2_phrasal_adv',
  title: '高级短语与介词动词',
  intro: '高级短语动词常有抽象含义，不能字面理解。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '抽象含义（Z30）',
      text: 'come down to（归结为）、fall through（落空）、come across（偶然遇到）、back up（支持）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这归结为金钱问题。', answer: 'It **comes** down to money.'),
    CourseItem(prompt: '我们必须坚持到底。', answer: 'We must **carry** on to the end.'),
    CourseItem(prompt: '那个计划落空了。', answer: 'The plan **fell** through.'),
    CourseItem(prompt: '他偶然发现了真相。', answer: 'He **came** across the truth by chance.'),
    CourseItem(prompt: '我支持你的决定。', answer: 'I **back** you up.'),
    CourseItem(prompt: '这个想法是他提出来的。', answer: 'He **came** up with the idea.'),
    CourseItem(prompt: '我们得想办法弥补损失。', answer: 'We have to **make** up for the loss.'),
    CourseItem(prompt: '会议被无限期推迟了。', answer: 'The meeting was **put** off indefinitely.'),
    CourseItem(prompt: '他们最终解决了分歧。', answer: 'They finally **sorted** out their differences.'),
    CourseItem(prompt: '这次经历让我打消了念头。', answer: 'The experience **put** me off the idea.'),
    CourseItem(prompt: '我们最终查明了原因。（track down）', answer: 'We finally **tracked** down the cause.'),
    CourseItem(prompt: '谈判破裂了。（break down）', answer: 'The talks **broke** down.'),
    CourseItem(prompt: '他从困难中挺了过来。（pull through）', answer: 'He **pulled** through the difficulties.'),
    CourseItem(prompt: '这个传统可以追溯到明朝。（date back）', answer: 'The tradition **dates** back to the Ming dynasty.'),
    CourseItem(prompt: '她婉拒了升职。（turn down）', answer: 'She **turned** down the promotion.'),
  ],
);

final QuizContent zhEnC12ListenNegotiation = zhEnListen(
  id: 'zh_en_c1_2_listen_negotiation',
  title: '听力：A business negotiation',
  passageTitle: 'Closing the deal',
  passage:
      "Thank you for meeting us. Let me be direct: we're very interested in "
      'your product, but the price is a concern. — I appreciate your honesty. '
      'What did you have in mind? — If you could reduce the price by ten per '
      "cent, we'd be prepared to sign a two-year contract. — That's a "
      'significant reduction. However, for a two-year commitment, I think we '
      "could offer eight per cent. — Let's say nine, and we have a deal. — Nine "
      "it is. I'll have the contract drawn up.",
  passageTranslation:
      '感谢与我们会面。我就直说了：我们对贵方的产品很感兴趣，但价格是个顾虑。——感谢您的坦诚。'
      '您有什么想法？——如果您能把价格降低百分之十，我们愿意签一份两年的合同。——这个降幅可不小。'
      '不过，考虑到两年的承诺，我想我们可以让百分之八。——就九个点吧，成交。——那就九个点。'
      '我这就让人把合同拟好。',
  intro: '先听，再答题。留意谈判中的委婉条件句和使役结构。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '条件 + 使役',
      text: "If you could reduce…we'd be prepared（委婉条件）；have the contract drawn up（使役被动）。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the buyer concerned about?',
      options: ['The price', 'The colour', 'The delivery'],
      correctIndex: 0,
      questionTranslation: '买方担心什么？',
    ),
    ReadingQuestion(
      question: 'What does the buyer offer in return for a discount?',
      options: ['A two-year contract', 'More orders', 'Nothing'],
      correctIndex: 0,
      questionTranslation: '买方为折扣提供什么？',
    ),
    ReadingQuestion(
      question: 'What discount do they agree on?',
      options: ['Nine per cent', 'Ten per cent', 'Eight per cent'],
      correctIndex: 0,
      questionTranslation: '他们最终同意打几折？',
    ),
  ],
);

final QuizContent zhEnC12DictEmail = zhEnDict(
  id: 'zh_en_c1_2_dict_email',
  title: '听写：A formal email',
  intro: '听句子并打出来。注意正式邮件的固定表达。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 正式表达（Z32）',
      text: '写出 I would be grateful if…、Please find attached…、Should you have any questions…。英式拼写 enquire。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我写信是想咨询贵方的服务。', answer: 'I am writing to enquire about your services.'),
    CourseItem(prompt: '如蒙尽快回复，我将不胜感激。', answer: 'I would be grateful if you could reply soon.'),
    CourseItem(prompt: '随附您所要求的文件。', answer: 'Please find attached the requested document.'),
    CourseItem(prompt: '期待您的回复。', answer: 'I look forward to hearing from you.'),
    CourseItem(prompt: '如有任何问题，请随时与我联系。', answer: 'Should you have any questions, do not hesitate to contact me.'),
    CourseItem(prompt: '感谢您的及时回复。', answer: 'Thank you for your prompt reply.'),
    CourseItem(prompt: '就给您带来的不便，我们深表歉意。', answer: 'We apologise for any inconvenience caused.'),
    CourseItem(prompt: '我想确认一下我们的会议时间。', answer: 'I would like to confirm the time of our meeting.'),
    CourseItem(prompt: '请查收附件中的报告。', answer: 'Please find the report attached.'),
    CourseItem(prompt: '我们期待与贵方合作。', answer: 'We look forward to working with you.'),
    CourseItem(prompt: '兹回复您五月三日的来信。', answer: 'I am writing in reply to your letter of the third of May.'),
    CourseItem(prompt: '若能安排一次会面，我将不胜感激。', answer: 'I would appreciate it if you could arrange a meeting.'),
    CourseItem(prompt: '请代我向您的团队致谢。', answer: 'Please pass on my thanks to your team.'),
    CourseItem(prompt: '我们很遗憾地通知您，该职位已招满。', answer: 'We regret to inform you that the position has been filled.'),
    CourseItem(prompt: '感谢您对此事的关注。', answer: 'Thank you for your attention to this matter.'),
  ],
);

final QuizContent zhEnC12ReadReviews = zhEnRead(
  id: 'zh_en_c1_2_read_reviews',
  title: '阅读：Two reviews, two registers',
  passageTitle: 'A tale of two reviews',
  passage:
      'Here are two reviews of the same restaurant. The first, from a food '
      "critic, reads: 'The dishes, though modest in appearance, reveal a chef "
      'of considerable skill; the balance of flavours is, quite frankly, '
      "exquisite.' The second, posted online by a customer, says: 'Food was "
      "well nice! A bit pricey but worth it lol. Will defo go back!' Both "
      'reviews are positive, yet they could hardly be more different. The first '
      'uses careful, formal language; the second is casual and full of slang. '
      "Neither is 'wrong'. Rather, each is appropriate to its context — and "
      'knowing which register to use, and when, is one of the true marks of '
      'fluency.',
  passageTranslation:
      '这里有对同一家餐厅的两则评价。第一则出自美食评论家：「这些菜肴外表朴素，却显露出一位技艺'
      '不凡的厨师；风味的平衡，坦白说，堪称精妙。」第二则由一位顾客发在网上：「东西超好吃！有点小贵'
      '但值了 哈哈。绝对还会再去！」两则都是好评，却几乎再不同不过。前者用词讲究、正式；后者随意，'
      '满是俚语。两者都没有「错」。相反，各自都契合其语境——而知道该在何时使用哪种语体，正是真正'
      '流利的标志之一。',
  intro: '读两则语体截然不同的评价。本课的核心：语体意识。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '语体对比（Z32）',
      text: '正式：exquisite、considerable skill；非正式：well nice、defo、lol。流利 = 会在对的场合用对的语体。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How are the two reviews similar?',
      options: ['Both positive', 'Both negative', 'Both formal'],
      correctIndex: 0,
      questionTranslation: '两则评价有什么共同点？',
    ),
    ReadingQuestion(
      question: 'How do they differ?',
      options: ['In register / formality', 'In the food', 'In the price'],
      correctIndex: 0,
      questionTranslation: '它们有什么不同？',
    ),
    ReadingQuestion(
      question: "What is 'a true mark of fluency'?",
      options: ['Knowing which register to use', 'Using slang', 'Being formal'],
      correctIndex: 0,
      questionTranslation: '「真正流利的标志」是什么？',
    ),
  ],
);

/// C1.2 in chain order.
final List<QuizContent> zhEnC1_2 = [
  zhEnC12Inversion,
  zhEnC12CondInversion,
  zhEnC12Fronting,
  zhEnC12SpeakRegister,
  zhEnC12Hedging,
  zhEnC12Impersonal,
  zhEnC12ListenInterview,
  zhEnC12Discourse,
  zhEnC12SpeakingMid,
  zhEnC12ReadColumn,
  zhEnC12Concession,
  zhEnC12Idioms,
  zhEnC12SpeakPersuade,
  zhEnC12PhrasalAdv,
  zhEnC12ListenNegotiation,
  zhEnC12DictEmail,
  zhEnC12ReadReviews,
  zhEnC12BigText,
  zhEnC12SpeakingClose,
];
