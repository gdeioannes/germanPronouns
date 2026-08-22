import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';
import 'zh_en_extra_c.dart';

/// C2.2 — Mastery · 精通 (capstone). Mandarin → English.
///
/// The ceiling of the ladder: near-native discourse — rhetoric, connotation and
/// irony, literary & journalistic analysis (Z31/Z32), nuanced counterfactuals
/// (Z28), complex passives (Z27), and residual-Chinglish elimination.

final QuizContent zhEnC22Cohesion = zhEnFill(
  id: 'zh_en_c2_2_cohesion',
  title: '高级语篇衔接',
  intro: '用衔接短语把段落织成整体，让论述层层推进。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '衔接手段（Z31）',
      text: 'coupled with、that said、as noted、for this reason、in sum——高级语篇的黏合剂。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这一点，再加上前述，解释了失败。', answer: 'This, **coupled** with the above, explains the failure.'),
    CourseItem(prompt: '正如前所述……', answer: 'As **noted** earlier, ...'),
    CourseItem(prompt: '出于这个原因，我们停了下来。', answer: 'For this **reason**, we stopped.'),
    CourseItem(prompt: '话虽如此，仍有希望。', answer: 'That **said**, there is still hope.'),
    CourseItem(prompt: '综上所述……', answer: 'In **sum**, ...'),
    CourseItem(prompt: '如前几段所示……', answer: 'As the previous paragraphs **show**, ...'),
    CourseItem(prompt: '与此密切相关的是成本问题。', answer: 'Closely **related** to this is the question of cost.'),
    CourseItem(prompt: '鉴于上述情况，我们建议……', answer: 'In **light** of the above, we recommend ...'),
    CourseItem(prompt: '反过来，这又引发了新问题。', answer: 'This, in **turn**, raises new questions.'),
    CourseItem(prompt: '话虽如此，风险依然存在。', answer: 'That **said**, the risks remain.'),
    CourseItem(prompt: '如下文所示……', answer: 'As will be **shown** below, ...'),
    CourseItem(prompt: '就此而论，两个案例十分相似。', answer: 'In this **regard**, the two cases are very similar.'),
    CourseItem(prompt: '基于同样的理由，我们反对该提案。', answer: 'By the same **token**, we oppose the proposal.'),
    CourseItem(prompt: '简而言之，代价太高了。', answer: 'In **short**, the cost is too high.'),
    CourseItem(prompt: '综合考虑各方面因素，方案 B 更佳。', answer: 'All things **considered**, option B is better.'),
  ],
);

final QuizContent zhEnC22Rhetoric = zhEnFill(
  id: 'zh_en_c2_2_rhetoric',
  title: '修辞手法',
  intro: '排比、对偶、低调陈述等修辞让语言更有感染力。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '修辞（Z31）',
      text: '排比（I came, I saw, I conquered）、低调陈述（no small matter = 大事）、对比。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我来了，我看见了，我征服了。', answer: 'I came, I saw, I **conquered**.'),
    CourseItem(prompt: '这可不是小事。', answer: 'This is **no** small matter.'),
    CourseItem(prompt: '问题不是要不要，而是何时。', answer: 'The question is not **whether**, but when.'),
    CourseItem(prompt: '要么现在，要么永不。', answer: 'It is now or **never**.'),
    CourseItem(prompt: '不自由，毋宁死。', answer: 'Give me liberty, or give me **death**.'),
    CourseItem(prompt: '问问你能为国家做什么。（对偶）', answer: 'Ask **what** you can do for your country.'),
    CourseItem(prompt: '说来容易，做来难。', answer: 'Easier said than **done**.'),
    CourseItem(prompt: '这不是结束，甚至不是结束的开始。', answer: 'This is not the end, nor even the beginning of the **end**.'),
    CourseItem(prompt: '轻描淡写：这有点小贵。（其实很贵）', answer: 'It is a **little** on the expensive side.'),
    CourseItem(prompt: '我们越少谈论它越好。', answer: 'The less said about it, the **better**.'),
    CourseItem(prompt: '排比：政府民有、民治、民享。', answer: 'Government of the people, by the people, for the **people**.'),
    CourseItem(prompt: '低调陈述：他对结果不太满意。（其实很生气）', answer: 'He was **not** exactly pleased with the result.'),
    CourseItem(prompt: '对比：我们要的是桥梁，不是高墙。', answer: 'We want bridges, not **walls**.'),
    CourseItem(prompt: '反问：我们还要再等多少年？', answer: 'How many more years must we **wait**?'),
    CourseItem(prompt: '三段排比：更快、更高、更强。', answer: 'Faster, higher, **stronger**.'),
  ],
);

final QuizContent zhEnC22Counterfactual = zhEnFill(
  id: 'zh_en_c2_2_counterfactual',
  title: '细腻的条件与反事实',
  intro: '用倒装、even、were it not for、unless 等表达最细腻的假设。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '高级条件（Z28）',
      text: 'Even had we…、Were it not for…、Had… been…、Unless stated otherwise。',
    ),
  ],
  items: const [
    CourseItem(prompt: '即便当时更努力，结果也可能一样。', answer: 'Even had we tried harder, the result **might** have been the same.'),
    CourseItem(prompt: '要不是因为他，我们早失败了。', answer: 'Were it not for him, we would have **failed**.'),
    CourseItem(prompt: '假如历史稍有不同……', answer: 'Had history been **slightly** different, ...'),
    CourseItem(prompt: '除非另有说明，规则照旧。', answer: 'Unless **stated** otherwise, the rules apply.'),
    CourseItem(prompt: '就算给我一百万我也不干。', answer: "I wouldn't do it, not **even** for a million."),
    CourseItem(prompt: '倘若价格再高一点，市场早就崩溃了。', answer: 'Had prices risen any higher, the market **would** have collapsed.'),
    CourseItem(prompt: '要不是运气好，一切都会不同。', answer: 'Were it not for luck, everything would have been **different**.'),
    CourseItem(prompt: '即便有再多的钱，也买不回时间。', answer: 'Even with all the money in the world, you **couldn\'t** buy back time.'),
    CourseItem(prompt: '除非有相反的证据，我们维持原判断。', answer: 'Unless there is evidence to the **contrary**, our view stands.'),
    CourseItem(prompt: '万一情况有变，请立即通知我们。', answer: '**Should** the situation change, inform us at once.'),
    CourseItem(prompt: '要不是那场雨，收成早就毁了。', answer: 'Were it not for the rain, the harvest would have been **ruined**.'),
    CourseItem(prompt: '即便再给一次机会，他也会做同样的选择。', answer: 'Even given a second chance, he **would** make the same choice.'),
    CourseItem(prompt: '除非另行通知，会议照常举行。', answer: 'Unless otherwise **notified**, the meeting will go ahead.'),
    CourseItem(prompt: '假如换一个时代，她也许早已成名。', answer: 'In another era, she **might** have been famous.'),
    CourseItem(prompt: '倘若当时有人反对，计划就会被搁置。', answer: 'Had anyone objected, the plan **would** have been shelved.'),
  ],
);

final QuizContent zhEnC22SpeakSpeech = zhEnSpeak(
  id: 'zh_en_c2_2_speak_speech',
  title: '开口说：发表一场演讲',
  intro: '用排比、停顿和坚定的语调打动听众。听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '演讲的力量（Z9）',
      text: '排比、留白、直呼听众、有力的结语——让语言产生感染力。',
    ),
  ],
  items: const [
    CourseItem(prompt: '各位，今天我们站在十字路口。', answer: 'Friends, today we stand at a crossroads.'),
    CourseItem(prompt: '我们不能，也绝不会退缩。', answer: 'We cannot, and we will not, back down.'),
    CourseItem(prompt: '想象这样一个世界……', answer: 'Imagine a world in which ...'),
    CourseItem(prompt: '这是我们这一代的责任。', answer: 'This is the duty of our generation.'),
    CourseItem(prompt: '让我们一起，创造历史。', answer: 'Together, let us make history.'),
  ],
);

final QuizContent zhEnC22Metaphor = zhEnFill(
  id: 'zh_en_c2_2_metaphor',
  title: '习语、隐喻与文化典故',
  intro: '隐喻和习语承载文化。地道使用能让表达生动而精准。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 文化的结晶（Z32）',
      text: 'a double-edged sword（双刃剑）、the elephant in the room（谁都不愿谈的问题）、a blessing in disguise（因祸得福）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这是一把双刃剑。', answer: "It's a double-edged **sword**."),
    CourseItem(prompt: '谁都不愿谈的那个大问题', answer: 'the elephant in the **room**'),
    CourseItem(prompt: '因祸得福', answer: 'a blessing in **disguise**'),
    CourseItem(prompt: '冰山一角', answer: 'the tip of the **iceberg**'),
    CourseItem(prompt: '泄露了秘密', answer: 'to let the cat out of the **bag**'),
    CourseItem(prompt: '烫手山芋', answer: 'a hot **potato**'),
    CourseItem(prompt: '压垮骆驼的最后一根稻草', answer: 'the last **straw**'),
    CourseItem(prompt: '纸上谈兵，说得容易', answer: 'easier said than **done**'),
    CourseItem(prompt: '身处困境，进退两难', answer: 'between a rock and a hard **place**'),
    CourseItem(prompt: '拨云见日的转机', answer: 'a light at the end of the **tunnel**'),
    CourseItem(prompt: '打开潘多拉魔盒（引发一连串问题）', answer: 'to open a can of **worms**'),
    CourseItem(prompt: '沧海一粟（大海里的一滴水）', answer: 'a drop in the **ocean**'),
    CourseItem(prompt: '燃眉之急先解决（先救火）', answer: 'to put out **fires**'),
    CourseItem(prompt: '换汤不换药（旧酒装新瓶）', answer: 'old wine in new **bottles**'),
    CourseItem(prompt: '亡羊补牢，为时未晚（迟做总比不做好）', answer: 'better late than **never**'),
  ],
);

final QuizContent zhEnC22Tone = zhEnFill(
  id: 'zh_en_c2_2_tone',
  title: '语气与分寸的掌控',
  intro: '讣告的庄重、打趣的轻松、外交的含蓄——高级表达在于分寸。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '分寸（Z32）',
      text: '不同场合选择恰当的语气：庄重、含蓄、真诚或调侃，都靠固定表达来实现。',
    ),
  ],
  items: const [
    CourseItem(prompt: '庄重宣布（讣告语气）', answer: 'It is with deep regret that we **announce** ...'),
    CourseItem(prompt: '轻松打趣', answer: 'Well, that could have gone **better**!'),
    CourseItem(prompt: '外交辞令', answer: 'We have agreed to **disagree**.'),
    CourseItem(prompt: '含蓄批评', answer: 'The report leaves something to be **desired**.'),
    CourseItem(prompt: '真诚感谢', answer: 'Words cannot **express** my gratitude.'),
    CourseItem(prompt: '婉转拒绝', answer: 'I am afraid we must respectfully **decline**.'),
    CourseItem(prompt: '得体祝贺', answer: 'Please accept my warmest **congratulations**.'),
    CourseItem(prompt: '深切慰问', answer: 'Our thoughts are **with** the family.'),
    CourseItem(prompt: '克制的乐观', answer: 'There are grounds for cautious **optimism**.'),
    CourseItem(prompt: '轻松自嘲', answer: 'Clearly, modesty is not my strong **suit**!'),
    CourseItem(prompt: '郑重承诺', answer: 'You have my **word**.'),
    CourseItem(prompt: '委婉提醒', answer: 'With all due **respect**, that may not be accurate.'),
    CourseItem(prompt: '低调的自信', answer: 'I have every **confidence** in our team.'),
    CourseItem(prompt: '得体的道歉', answer: 'I owe you an **apology**.'),
    CourseItem(prompt: '克制的批评', answer: 'The performance fell **short** of expectations.'),
  ],
);

final QuizContent zhEnC22ListenDebate = zhEnListen(
  id: 'zh_en_c2_2_listen_debate',
  title: '听力：A current-affairs debate',
  passageTitle: 'Social media: harm or good?',
  passage:
      "Tonight's motion: 'This house believes that social media does more harm "
      "than good.' Speaking for the motion: 'We have created a world in which "
      'teenagers compare their real lives to the edited highlights of others, '
      'and then wonder why they feel inadequate. That is not connection; it is '
      "a slow poison.' And against: 'Every new technology has been feared. "
      'Social media has given a voice to the voiceless and toppled dictators. '
      "To blame the tool for how some use it is both lazy and dangerous.' A "
      'powerful exchange. Now, over to our audience.',
  passageTranslation:
      '今晚的辩题：「本方认为社交媒体弊大于利。」正方发言：「我们造就了这样一个世界：青少年'
      '拿自己真实的生活去和别人经过修饰的高光片段比较，然后纳闷自己为何感到不如人。那不是'
      '连接，而是一种慢性毒药。」反方：「每一项新技术都曾被恐惧。社交媒体给了无声者以声音，'
      '也曾推翻独裁者。因为有些人的滥用就去责怪工具本身，既懒惰又危险。」精彩的交锋。现在，'
      '交给现场观众。',
  intro: '先听，再答题。留意双方的修辞和论证。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '辩论修辞（Z31）',
      text: "'a slow poison'（隐喻）；'give a voice to the voiceless'（对比排比）；正反论点均衡。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the debate motion?',
      options: ['Social media does more harm than good', 'Phones are cheap', 'TV is bad'],
      correctIndex: 0,
      questionTranslation: '辩题是什么？',
    ),
    ReadingQuestion(
      question: "What is the 'for' speaker's argument?",
      options: ['It harms mental health', "It's expensive", "It's slow"],
      correctIndex: 0,
      questionTranslation: '正方的论点是什么？',
    ),
    ReadingQuestion(
      question: "What is the 'against' speaker's argument?",
      options: ['Blaming the tool is wrong', "It's perfect", "It's boring"],
      correctIndex: 0,
      questionTranslation: '反方的论点是什么？',
    ),
  ],
);

final QuizContent zhEnC22ReadAnalysis = zhEnRead(
  id: 'zh_en_c2_2_read_analysis',
  title: '阅读：A journalistic analysis',
  passageTitle: 'Behind the numbers',
  passage:
      'The numbers, at first glance, tell a reassuring story: unemployment is '
      'at a record low. Politicians have, predictably, rushed to take the '
      'credit. Look closer, however, and the picture grows murkier. Much of '
      "this 'employment' consists of insecure, part-time work, often paying "
      'less than a living wage. A person delivering parcels for twelve hours a '
      'day, with no sick pay and no guaranteed hours, counts in the statistics '
      "as 'employed' — and yet may be poorer than someone officially out of "
      'work a decade ago. Statistics, as ever, are not lies; but they are '
      'rarely the whole truth. The real question is not how many people are '
      'working, but whether that work allows them to live with dignity.',
  passageTranslation:
      '乍看之下，数字讲述着一个令人安心的故事：失业率处于历史低位。不出所料，政客们争相邀功。'
      '然而，凑近一看，图景就变得模糊。许多所谓的「就业」是不稳定的兼职，报酬常常低于维生工资。'
      '一个每天送十二小时快递、没有病假、也没有保障工时的人，在统计里算作「就业」——却可能比'
      '十年前一个正式失业的人还要穷。数字，一如既往，并非谎言；但它们很少是全部真相。真正的'
      '问题不在于有多少人在工作，而在于那份工作能否让他们有尊严地生活。',
  intro: '读一篇分析性新闻评论。留意数据背后的批判视角。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '分析性写作（Z31）',
      text: "'Look closer, however'（转折）；委婉限定（rarely the whole truth）；'The real question is…'（强调句）。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What do the headline numbers suggest?',
      options: ['Low unemployment', 'High unemployment', 'Nothing'],
      correctIndex: 0,
      questionTranslation: '表面数字说明了什么？',
    ),
    ReadingQuestion(
      question: "What is the writer's real point?",
      options: ['The quality of jobs matters', 'Statistics are lies', "Jobs don't matter"],
      correctIndex: 0,
      questionTranslation: '作者真正的观点是什么？',
    ),
    ReadingQuestion(
      question: 'What does the writer say about statistics?',
      options: ['Not lies, but not the whole truth', 'Always false', 'Always true'],
      correctIndex: 0,
      questionTranslation: '作者怎么看待统计数字？',
    ),
  ],
);

final QuizContent zhEnC22ComplexPassive = zhEnFill(
  id: 'zh_en_c2_2_complex_passive',
  title: '复杂被动与非人称结构',
  intro: '高级被动包括 be believed to do、be being done、need + V-ing（含被动义）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '高级被动（Z27）',
      text: 'be believed/seen to do、be being done（进行被动）、need + V-ing（=need to be done）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '据信许多物种已灭绝。', answer: 'Many species are believed to have **become** extinct.'),
    CourseItem(prompt: '有人看见他离开了大楼。', answer: 'He was seen to **leave** the building.'),
    CourseItem(prompt: '这件事亟需处理。', answer: 'The matter needs **addressing**.'),
    CourseItem(prompt: '此事正由他人处理。', answer: 'The issue is being dealt **with** by someone else.'),
    CourseItem(prompt: '据估计损失巨大。', answer: 'The losses are estimated to be **considerable**.'),
    CourseItem(prompt: '这座桥正在维修中。（进行被动）', answer: 'The bridge is **being** repaired.'),
    CourseItem(prompt: '这些窗户需要清洗。（need + V-ing）', answer: 'The windows need **cleaning**.'),
    CourseItem(prompt: '据认为他已离开该国。', answer: 'He is thought to have **left** the country.'),
    CourseItem(prompt: '新政策正在被讨论。', answer: 'The new policy is **being** discussed.'),
    CourseItem(prompt: '你的头发该剪了。（need + V-ing）', answer: 'Your hair needs **cutting**.'),
    CourseItem(prompt: '据报道嫌疑人已被逮捕。', answer: 'The suspect is reported to have been **arrested**.'),
    CourseItem(prompt: '这个问题正在被认真研究。', answer: 'The problem is **being** studied seriously.'),
    CourseItem(prompt: '这些规则需要重新审视。（need + V-ing）', answer: 'These rules need **reviewing**.'),
    CourseItem(prompt: '他被公认为该领域的权威。', answer: 'He is widely **regarded** as an authority in the field.'),
    CourseItem(prompt: '合同据说已经签署。', answer: 'The contract is said to have been **signed**.'),
  ],
);

final QuizContent zhEnC22Concision = zhEnFill(
  id: 'zh_en_c2_2_concision',
  title: '精准与简洁（修掉中式英语）',
  intro: '摆脱中式英语：用地道搭配、去掉冗余、追求准确与简洁。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Chinglish 修复（Z32）',
      text: 'open the light → turn on；very agree → strongly agree；「因为…的原因」是冗余，去掉一个。',
    ),
  ],
  items: const [
    CourseItem(prompt: '开灯（正确搭配）', answer: 'turn **on** the light'),
    CourseItem(prompt: '我非常同意（地道）', answer: 'I **strongly** agree'),
    CourseItem(prompt: '在我看来（简洁）', answer: 'in my **opinion**'),
    CourseItem(prompt: '很多人（正确）', answer: 'many **people**'),
    CourseItem(prompt: '因为下雨（去冗余）', answer: 'because it **rained**'),
    CourseItem(prompt: '学习知识（地道说法）', answer: '**gain** knowledge'),
    CourseItem(prompt: '价格很贵 →（应该说物品贵）', answer: 'The book is **expensive**.'),
    CourseItem(prompt: '身体健康（简洁）', answer: 'in good **health**'),
    CourseItem(prompt: '注意安全（地道告别语）', answer: 'Take **care**.'),
    CourseItem(prompt: '人山人海（地道表达）', answer: 'The place was **packed**.'),
    CourseItem(prompt: '提高英语水平（地道搭配）', answer: '**improve** my English'),
    CourseItem(prompt: '给你添麻烦了（地道说法）', answer: 'Sorry to **bother** you.'),
    CourseItem(prompt: '吃药（正确动词）', answer: '**take** medicine'),
    CourseItem(prompt: '看手机（地道说法：check）', answer: '**check** my phone'),
    CourseItem(prompt: '我随便看看（购物时）', answer: "I'm just **browsing**."),
  ],
);

final QuizContent zhEnC22SpeakRebuttal = zhEnSpeak(
  id: 'zh_en_c2_2_speak_rebuttal',
  title: '开口说：即兴论辩与反驳',
  intro: '即兴反驳要礼貌而坚定，用连接语争取思考时间。听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '反驳的艺术（Z10）',
      text: '先承认，再转折，最后立论：I take your point, but… On the contrary…。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我明白你的意思，但请考虑……', answer: 'I take your point, but consider this ...'),
    CourseItem(prompt: '恰恰相反……', answer: 'On the contrary, ...'),
    CourseItem(prompt: '那正好证明了我的观点。', answer: 'That rather proves my point.'),
    CourseItem(prompt: '这里我们要区分一下……', answer: 'We must draw a distinction here ...'),
    CourseItem(prompt: '恕我直言，那站不住脚。', answer: "With respect, that simply doesn't hold up."),
  ],
);

final QuizContent zhEnC22ListenCritical = zhEnListen(
  id: 'zh_en_c2_2_listen_critical',
  title: '听力：A literary/critical talk',
  passageTitle: 'The perfect opening line',
  passage:
      "What makes a great opening line? Consider the famous first sentence: "
      "'It was the best of times, it was the worst of times.' In just ten "
      'words, Dickens captures an entire age of contradiction. A great opening '
      'does not merely begin a story; it makes a promise to the reader. It '
      'says: trust me, this will be worth your time. Modern writers, under '
      'pressure to grab attention, sometimes forget that intrigue is not the '
      'same as confusion. The best openings are clear, yet they leave a door '
      'slightly open — a question we cannot help but want answered.',
  passageTranslation:
      '什么造就了精彩的开篇句？想想那句著名的开头：「这是最好的时代，也是最坏的时代。」仅仅十个'
      '词，狄更斯就道尽了一个充满矛盾的时代。伟大的开篇不只是开始一个故事，它是对读者的一个承诺，'
      '它在说：相信我，这值得你花时间。现代作家在吸引眼球的压力下，有时忘了「引人入胜」不等于'
      '「令人困惑」。最好的开篇是清晰的，却留了一道微微敞开的门——一个我们忍不住想知道答案的问题。',
  intro: '先听，再答题。留意文学评论中的比喻与对偶。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '评论修辞（Z31）',
      text: "对偶（best of times / worst of times）；比喻（leave a door open）；intrigue ≠ confusion 的辨析。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the talk about?',
      options: ['Great opening lines', 'Grammar', 'Spelling'],
      correctIndex: 0,
      questionTranslation: '这段讲话的主题是什么？',
    ),
    ReadingQuestion(
      question: 'What does a great opening do?',
      options: ['Makes a promise to the reader', 'Confuses', 'Bores'],
      correctIndex: 0,
      questionTranslation: '好的开篇会做什么？',
    ),
    ReadingQuestion(
      question: 'What mistake do some modern writers make?',
      options: ['Confusing intrigue with confusion', 'Being too clear', 'Writing too little'],
      correctIndex: 0,
      questionTranslation: '一些现代作家犯了什么错误？',
    ),
  ],
);

final QuizContent zhEnC22DictEditorial = zhEnDict(
  id: 'zh_en_c2_2_dict_editorial',
  title: '听写：A dense editorial',
  intro: '听句子并打出来。这些句子综合了倒装、强调句、委婉和反事实。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 综合结构（Z31）',
      text: '写出 Rarely has…（倒装）、What is needed is…（强调句）、Were the government to…（反事实）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '很少有一个决定受到如此广泛的批评。', answer: 'Rarely has a decision been so widely criticised.'),
    CourseItem(prompt: '需要的不是更多空谈，而是行动。', answer: 'What is needed is not more talk, but action.'),
    CourseItem(prompt: '后果虽难预料，但不太可能微不足道。', answer: 'The consequences, though hard to predict, are unlikely to be minor.'),
    CourseItem(prompt: '倘若政府重新考虑，仍有很多可挽回。', answer: 'Were the government to reconsider, much could still be saved.'),
    CourseItem(prompt: '正是这种自满让我警觉。', answer: 'It is precisely this complacency that alarms me.'),
    CourseItem(prompt: '直到危机来临，人们才开始重视。', answer: 'Only when the crisis came did people begin to care.'),
    CourseItem(prompt: '据信谈判已进入最后阶段。', answer: 'The talks are believed to be in their final stage.'),
    CourseItem(prompt: '这与其说是政策，不如说是姿态。', answer: 'It is not so much a policy as a gesture.'),
    CourseItem(prompt: '话虽如此，改革不能再等。', answer: 'That said, reform cannot wait any longer.'),
    CourseItem(prompt: '需要的是勇气，而非口号。', answer: 'What is needed is courage, not slogans.'),
    CourseItem(prompt: '若不采取行动，历史不会宽恕我们。', answer: 'History will not forgive us if we fail to act.'),
    CourseItem(prompt: '直到最后一刻，协议才达成。', answer: 'Only at the last moment was the agreement reached.'),
    CourseItem(prompt: '很少有改革得到如此一致的支持。', answer: 'Seldom has a reform enjoyed such unanimous support.'),
    CourseItem(prompt: '问题不在资源，而在意愿。', answer: 'The problem lies not in resources, but in will.'),
    CourseItem(prompt: '话虽如此，乐观也要有分寸。', answer: 'That said, optimism must be kept within reason.'),
  ],
);

final QuizContent zhEnC22ReadStory = zhEnRead(
  id: 'zh_en_c2_2_read_story',
  title: '阅读：Analysing a short story',
  passageTitle: 'The power of the unsaid',
  passage:
      "In Hemingway's famous six-word story — 'For sale: baby shoes, never "
      "worn' — nothing is explained, and yet everything is felt. The power "
      'lies entirely in what is left unsaid. We are not told who is selling '
      'the shoes, or why they were never worn; but the reader\'s imagination '
      'fills the silence with loss. This is the essence of great short '
      'fiction: it trusts the reader. Rather than describing grief, Hemingway '
      'hands us a single object and lets us feel its weight. The best stories, '
      'it has been said, are written as much in the white space between the '
      'words as in the words themselves.',
  passageTranslation:
      '在海明威著名的六词小说——「出售：婴儿鞋，从未穿过」——中，什么都没有解释，却什么都感受'
      '到了。力量完全在于「没说出口」的部分。我们不知道是谁在卖这双鞋，也不知道它为何从未被穿过；'
      '但读者的想象把这段沉默填满了失去。这正是伟大短篇小说的精髓：它信任读者。海明威没有描写'
      '悲伤，而是递给我们一件小小的物品，让我们自己去感受它的重量。有人说，最好的故事，写在词与'
      '词之间的留白里，不亚于写在词句本身。',
  intro: '读一段关于短篇小说的文学分析。留意「留白」与含蓄的力量。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '文学分析（Z31）',
      text: "被动（nothing is explained, it has been said）；'white space' 的隐喻；含蓄胜过直白。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is special about the six-word story?',
      options: ['It implies a whole tragedy', "It's funny", "It's long"],
      correctIndex: 0,
      questionTranslation: '这个六词故事特别在哪里？',
    ),
    ReadingQuestion(
      question: 'Where does its power lie?',
      options: ['In what is left unsaid', 'In long description', 'In dialogue'],
      correctIndex: 0,
      questionTranslation: '它的力量在哪里？',
    ),
    ReadingQuestion(
      question: 'What does great short fiction do?',
      options: ['Trusts the reader', 'Explains everything', 'Avoids emotion'],
      correctIndex: 0,
      questionTranslation: '伟大的短篇小说会做什么？',
    ),
  ],
);

final QuizContent zhEnC22ReadCapstone = zhEnRead(
  id: 'zh_en_c2_2_read_capstone',
  title: '阅读：Capstone — A long-form feature',
  passageTitle: 'The price of silence',
  passage:
      'For most of human history, silence was free and abundant. Today, it has '
      'become a luxury. In our cities, the hum of traffic never truly stops; '
      'in our homes, screens murmur through the night. We have, without quite '
      'deciding to, engineered a world in which quiet is something we must '
      'actively seek out — and pay for. Wellness retreats sell it by the '
      'weekend; noise-cancelling headphones sell it by the hour. Yet the deeper '
      'cost may be one we have barely begun to measure. Studies increasingly '
      'suggest that constant noise raises stress, disturbs sleep, and erodes '
      'our very capacity to think. Perhaps the most radical act of the coming '
      'century will not be to speak louder, but to learn, once again, how to be '
      'still.',
  passageTranslation:
      '在人类历史的大部分时间里，寂静是免费而充裕的。今天，它却成了一种奢侈。在城市里，车流的'
      '嗡鸣从未真正停止；在家中，屏幕彻夜低语。我们并未真正下过决心，却造出了这样一个世界：'
      '安静成了必须主动去寻找——而且要花钱买——的东西。养生营按周出售它，降噪耳机按小时出售它。'
      '然而更深的代价，也许是我们才刚刚开始衡量的。越来越多的研究表明，持续的噪音会增加压力、'
      '扰乱睡眠，并侵蚀我们思考的能力本身。也许，下一个世纪最激进的举动，不是把话说得更响，'
      '而是重新学会——如何安静下来。',
  intro: '毕业级长篇特写。综合运用隐喻、反讽与节奏，读出言外的深意。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '特写文风（Z31/Z32）',
      text: "'sell it by the weekend / by the hour'（对偶）；'screens murmur'（拟人）；含蓄有力的结语。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: "What has become a 'luxury'?",
      options: ['Silence', 'Traffic', 'Screens'],
      correctIndex: 0,
      questionTranslation: '什么成了「奢侈品」？',
    ),
    ReadingQuestion(
      question: 'What does the writer suggest about noise?',
      options: ['It harms health and thought', "It's harmless", "It's pleasant"],
      correctIndex: 0,
      questionTranslation: '作者暗示噪音有什么影响？',
    ),
    ReadingQuestion(
      question: "What is the writer's closing idea?",
      options: ['Learning to be still is radical', 'Speak louder', 'Buy more'],
      correctIndex: 0,
      questionTranslation: '作者结尾的观点是什么？',
    ),
  ],
);

final QuizContent zhEnC22SpeakCapstone = zhEnSpeak(
  id: 'zh_en_c2_2_speak_capstone',
  title: '开口说：Capstone — 就复杂议题表达观点',
  intro: '毕业级口语：综合运用观点框架、让步、证据和有力的结语，完成一次完整的论述。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '一次完整的论述（Z9）',
      text: '立场 → 让步 → 证据 → 结论。用坚定而有分寸的语气收束——这是 C2 的标志。',
    ),
  ],
  items: const [
    CourseItem(prompt: '关于这个问题，我的立场很明确。', answer: 'On this issue, my position is clear.'),
    CourseItem(prompt: '虽然双方都有合理之处……', answer: 'While there is merit on both sides ...'),
    CourseItem(prompt: '证据强烈地表明……', answer: 'The evidence strongly suggests ...'),
    CourseItem(prompt: '因此，我坚定地认为……', answer: 'I therefore firmly believe that ...'),
    CourseItem(prompt: '归根结底，这关乎我们想成为怎样的社会。', answer: 'Ultimately, it comes down to what kind of society we want to be.'),
  ],
);

/// C2.2 in chain order (capstone).
final List<QuizContent> zhEnC2_2 = [
  zhEnC22Cohesion,
  zhEnC22Rhetoric,
  zhEnC22Counterfactual,
  zhEnC22SpeakSpeech,
  zhEnC22Metaphor,
  zhEnC22Tone,
  zhEnC22ListenDebate,
  zhEnC22ReadAnalysis,
  zhEnC22SpeakingMid,
  zhEnC22ComplexPassive,
  zhEnC22Concision,
  zhEnC22SpeakRebuttal,
  zhEnC22ListenCritical,
  zhEnC22DictEditorial,
  zhEnC22ReadStory,
  zhEnC22ReadCapstone,
  zhEnC22SpeakCapstone,
  zhEnC22BigText,
  zhEnC22SpeakingClose,
];
