import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// C1.2 — The Written Register · 书面语 (HSK 5–6). English → Mandarin.
///
/// Big rocks: written Chinese as the half-new grammar it really is (Z30 —
/// 将/于/之/而/则/即), the formal passive 由/受/遭 (Z23), rhetorical questions
/// 难道/岂不, hedging, and the spoken↔written register pairs. This is the gap
/// every HSK 5–6 candidate hits.

final QuizContent enZhC12JiangYu = enZhFill(
  id: 'en_zh_c1_2_jiang_yu',
  title: '将 — the written 把 (and 于)',
  intro:
      'News and reports swap everyday words for classical ones: 将 replaces '
      '把 (and marks futures), 于 replaces 在 for time and place.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Two 将s, one 于 (Z30)',
      text: '将 №1 = written 把: 请将手机关闭. 将 №2 = will: 会议将于九点'
          '举行. 于 = at/in/on after the verb or before the time: 生于1990年, '
          '将于明日开幕.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Don\'t speak the written words',
      text: '将/于/之 in casual conversation sounds like reading a news '
          'bulletin at dinner. Register runs both ways — these are for '
          'writing and formal speech only.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Please switch off your mobile phone. (written 把)', answer: '请**将**手机关闭。', accepted: ['jiāng'], hint: 'qǐng jiāng shǒujī guānbì'),
    CourseItem(prompt: 'The meeting will be held at 9 a.m. (将 future + 于 time)', answer: '会议将**于**上午九点举行。', accepted: ['yú'], hint: 'huìyì jiāng yú shàngwǔ jiǔ diǎn jǔxíng'),
    CourseItem(prompt: 'He was born in Beijing in 1990. (verb + 于)', answer: '他1990年生**于**北京。', accepted: ['yú'], hint: 'tā yī jiǔ jiǔ líng nián shēng yú Běijīng'),
    CourseItem(prompt: 'The company will move its headquarters to Shanghai.', answer: '公司**将**总部迁至上海。', accepted: ['jiāng'], hint: 'gōngsī jiāng zǒngbù qiān zhì Shànghǎi'),
    CourseItem(prompt: 'The exhibition will open on the 5th. (将于)', answer: '展览**将于**五号开幕。', accepted: ['jiāng yú', 'jiangyu'], hint: 'zhǎnlǎn jiāng yú wǔ hào kāimù'),
    CourseItem(prompt: 'Please hand the report to the manager. (written 把)', answer: '请**将**报告交给经理。', accepted: ['jiāng'], hint: 'qǐng jiāng bàogào jiāo gěi jīnglǐ'),
    CourseItem(prompt: 'The new law will take effect on January 1st. (将于)', answer: '新法律**将于**一月一日生效。', accepted: ['jiāng yú', 'jiangyu'], hint: 'xīn fǎlǜ jiāng yú yī yuè yī rì shēngxiào'),
    CourseItem(prompt: 'The university was founded in 1898. (verb + 于)', answer: '这所大学创建**于**1898年。', accepted: ['yú'], hint: 'zhè suǒ dàxué chuàngjiàn yú yī bā jiǔ bā nián'),
    CourseItem(prompt: 'Prices will continue to rise. (将 = will)', answer: '物价**将**继续上涨。', accepted: ['jiāng'], hint: 'wùjià jiāng jìxù shàngzhǎng'),
    CourseItem(prompt: 'The results will be announced on the website. (将)', answer: '结果**将**在网站上公布。', accepted: ['jiāng'], hint: 'jiéguǒ jiāng zài wǎngzhàn shàng gōngbù'),
    CourseItem(prompt: 'Please send the documents to the following address. (written 把)', answer: '请**将**文件寄至以下地址。', accepted: ['jiāng'], hint: 'qǐng jiāng wénjiàn jì zhì yǐxià dìzhǐ'),
    CourseItem(prompt: 'The concert will take place at the city theatre. (将于…举行? no — 于 place)', answer: '音乐会将**于**市剧院举行。', accepted: ['yú'], hint: 'yīnyuèhuì jiāng yú shì jùyuàn jǔxíng'),
    CourseItem(prompt: 'She graduated from Peking University in 2015. (毕业 + 于)', answer: '她2015年毕业**于**北京大学。', accepted: ['yú'], hint: 'tā èr líng yī wǔ nián bìyè yú Běijīng Dàxué'),
    CourseItem(prompt: 'The two sides will sign the agreement next week. (将 = will; 签署)', answer: '双方**将**于下周签署协议。', accepted: ['jiāng'], hint: 'shuāngfāng jiāng yú xià zhōu qiānshǔ xiéyì'),
    CourseItem(prompt: 'Please keep this receipt safe. (written 把; 妥善保管)', answer: '请**将**收据妥善保管。', accepted: ['jiāng'], hint: 'qǐng jiāng shōujù tuǒshàn bǎoguǎn'),
  ],
);

final QuizContent enZhC12ZhiErZe = enZhFill(
  id: 'en_zh_c1_2_zhi_er_ze',
  title: '之 / 而 / 则',
  intro:
      'Three classical particles alive in modern prose: 之 = written 的, 而 '
      'joins with contrast or flow, 则 = "in that case / whereas".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The classical trio (Z30)',
      text: '之 in set frames: 三分之一 (one third), 成功之路. 而 pivots: '
          '简单而有效 simple yet effective. 则 balances clauses: 南方多雨，'
          '北方则干燥.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'one third (three parts 之 one)', answer: '三分**之**一', accepted: ['zhī'], hint: 'sān fēn zhī yī'),
    CourseItem(prompt: 'the road to success (success 之 road)', answer: '成功**之**路', accepted: ['zhī'], hint: 'chénggōng zhī lù'),
    CourseItem(prompt: 'simple yet effective (joined with 而)', answer: '简单**而**有效', accepted: ['ér'], hint: 'jiǎndān ér yǒuxiào'),
    CourseItem(prompt: 'The south is rainy; the north, by contrast, is dry.', answer: '南方多雨，北方**则**干燥。', accepted: ['zé'], hint: 'nánfāng duō yǔ, běifāng zé gānzào'),
    CourseItem(prompt: 'one of the most important inventions (…之一)', answer: '最重要的发明**之一**', accepted: ['zhī yī', 'zhiyi'], hint: 'zuì zhòngyào de fāmíng zhī yī'),
    CourseItem(prompt: 'to proceed slowly but surely (slow 而 steady)', answer: '慢**而**稳', accepted: ['ér'], hint: 'màn ér wěn'),
    CourseItem(prompt: 'a quarter (four parts 之 one)', answer: '四分**之**一', accepted: ['zhī'], hint: 'sì fēn zhī yī'),
    CourseItem(prompt: 'a quiet yet beautiful little town (joined with 而)', answer: '一个安静**而**美丽的小城', accepted: ['ér'], hint: 'yí ge ānjìng ér měilì de xiǎo chéng'),
    CourseItem(prompt: 'Cancelled in case of rain. (rain → 则 cancelled, notice style)', answer: '遇雨**则**取消。', accepted: ['zé'], hint: 'yù yǔ zé qǔxiāo'),
    CourseItem(prompt: 'one of my best friends (…之一)', answer: '我最好的朋友**之一**', accepted: ['zhī yī', 'zhiyi'], hint: 'wǒ zuì hǎo de péngyou zhī yī'),
    CourseItem(prompt: 'the beauty of reading (reading 之 beauty)', answer: '阅读**之**美', accepted: ['zhī'], hint: 'yuèdú zhī měi'),
    CourseItem(prompt: 'cheap yet good quality (joined with 而)', answer: '便宜**而**质量好', accepted: ['ér'], hint: 'piányi ér zhìliàng hǎo'),
    CourseItem(prompt: 'Those who agree raise a hand; those who don\'t, by contrast, keep silent.', answer: '同意的举手，不同意的**则**保持沉默。', accepted: ['zé'], hint: 'tóngyì de jǔshǒu, bù tóngyì de zé bǎochí chénmò'),
    CourseItem(prompt: 'two thirds (three parts 之 two)', answer: '三分**之**二', accepted: ['zhī'], hint: 'sān fēn zhī èr'),
    CourseItem(prompt: 'to work hard without complaint (labor 而 no complaint)', answer: '努力**而**无怨言', accepted: ['ér'], hint: 'nǔlì ér wú yuànyán'),
  ],
);

final QuizContent enZhC12SpeakNews = enZhSpeak(
  id: 'en_zh_c1_2_speak_news',
  title: 'Speaking: reading a news lead',
  intro:
      'Read like a newsreader: measured pace, full tones, the written words '
      'given their full weight.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'News rhythm (Z30/Z6)',
      text: 'Broadcast Mandarin groups four-to-six syllables per breath-unit '
          'and never swallows finals. Match the voice\'s phrasing exactly.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Běn cì huìyì jiāng yú míngrì shàngwǔ jǔxíng. — This meeting will be held tomorrow morning.', answer: '本次会议将于明日上午举行。'),
    CourseItem(prompt: 'Jù bàodào, gāi gōngsī qǔdé le chuàngjìlù de yèjì. — Reportedly, the company achieved record results.', answer: '据报道，该公司取得了创纪录的业绩。'),
    CourseItem(prompt: 'Zhuānjiā rènwéi, zhè yì wèntí bùróng hūshì. — Experts hold that this problem must not be ignored.', answer: '专家认为，这一问题不容忽视。'),
    CourseItem(prompt: 'Xiāngguān bùmén yǐ zhǎnkāi diàochá. — The relevant authorities have opened an investigation.', answer: '相关部门已展开调查。'),
    CourseItem(prompt: 'Xiángqíng qǐng guānzhù hòuxù bàodào. — For details, follow our continuing coverage.', answer: '详情请关注后续报道。'),
  ],
);

final QuizContent enZhC12FormalPassive = enZhFill(
  id: 'en_zh_c1_2_formal_passive',
  title: 'Formal passive: 由 / 受 / 遭',
  intro:
      'Written Chinese has a passive palette: neutral 由 (handled by), '
      'receptive 受 (受到欢迎 well received), adverse 遭 (遭到破坏 suffered '
      'damage).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Pick by flavour (Z23/Z30)',
      text: '由 assigns responsibility, no drama: 会议由王教授主持. 受(到) '
          'receives, neutral-to-good: 受到好评. 遭(到) suffers, always bad: '
          '遭到拒绝. 被 stays the everyday generalist.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The meeting will be chaired by Professor Wang. (assigned)', answer: '会议**由**王教授主持。', accepted: ['yóu'], hint: 'huìyì yóu Wáng jiàoshòu zhǔchí'),
    CourseItem(prompt: 'The film was warmly received by audiences. (受到)', answer: '这部电影**受到**观众的欢迎。', accepted: ['shòudào', 'shòu dào'], hint: 'zhè bù diànyǐng shòudào guānzhòng de huānyíng'),
    CourseItem(prompt: 'The old buildings suffered serious damage. (遭到)', answer: '老建筑**遭到**严重破坏。', accepted: ['zāodào', 'zāo dào'], hint: 'lǎo jiànzhù zāodào yánzhòng pòhuài'),
    CourseItem(prompt: 'His proposal was rejected. (suffered rejection)', answer: '他的建议**遭到**拒绝。', accepted: ['zāodào'], hint: 'tā de jiànyì zāodào jùjué'),
    CourseItem(prompt: 'This tradition is valued (受到重视) by young people again.', answer: '这个传统再次**受到**年轻人的重视。', accepted: ['shòudào'], hint: 'zhè ge chuántǒng zàicì shòudào niánqīngrén de zhòngshì'),
    CourseItem(prompt: 'Deliveries in this district are handled by our company.', answer: '本区的快递**由**我们公司负责。', accepted: ['yóu'], hint: 'běn qū de kuàidì yóu wǒmen gōngsī fùzé'),
    CourseItem(prompt: 'The plan was well received. (受到好评)', answer: '这个计划**受到**好评。', accepted: ['shòudào', 'shòu dào'], hint: 'zhè ge jìhuà shòudào hǎopíng'),
    CourseItem(prompt: 'The project is managed by the city government.', answer: '这个项目**由**市政府管理。', accepted: ['yóu'], hint: 'zhè ge xiàngmù yóu shìzhèngfǔ guǎnlǐ'),
    CourseItem(prompt: 'Many trees suffered damage in the storm.', answer: '暴风雨中许多树木**遭到**破坏。', accepted: ['zāodào', 'zāo dào'], hint: 'bàofēngyǔ zhōng xǔduō shùmù zāodào pòhuài'),
    CourseItem(prompt: 'The new policy is supported by most residents. (受到支持)', answer: '新政策**受到**大多数居民的支持。', accepted: ['shòudào'], hint: 'xīn zhèngcè shòudào dàduōshù jūmín de zhīchí'),
    CourseItem(prompt: 'Security is handled by a professional company. (assigned)', answer: '安保工作**由**专业公司负责。', accepted: ['yóu'], hint: 'ānbǎo gōngzuò yóu zhuānyè gōngsī fùzé'),
    CourseItem(prompt: 'The young teacher is deeply loved by her students. (受到喜爱)', answer: '这位年轻老师**受到**学生的喜爱。', accepted: ['shòudào', 'shòu dào'], hint: 'zhè wèi niánqīng lǎoshī shòudào xuésheng de xǐ\'ài'),
    CourseItem(prompt: 'The village suffered flooding. (遭到 + 水灾? use 遭受)', answer: '村庄**遭受**了水灾。', accepted: ['zāoshòu'], hint: 'cūnzhuāng zāoshòu le shuǐzāi'),
    CourseItem(prompt: 'The costs are borne by the company. (assigned: 由…承担)', answer: '费用**由**公司承担。', accepted: ['yóu'], hint: 'fèiyòng yóu gōngsī chéngdān'),
    CourseItem(prompt: 'His work received wide attention. (受到关注)', answer: '他的作品**受到**广泛关注。', accepted: ['shòudào', 'shòu dào'], hint: 'tā de zuòpǐn shòudào guǎngfàn guānzhù'),
  ],
);

final QuizContent enZhC12ListenNews = enZhListen(
  id: 'en_zh_c1_2_listen_news',
  title: 'Listening: 新闻播报',
  passageTitle: '晚间新闻两则',
  passage:
      '晚上好，欢迎收看晚间新闻。\n'
      '第一条：本市地铁五号线将于下月正式开通。'
      '新线路全长四十二公里，由二十八个车站组成。'
      '专家认为，五号线的开通将大大缓解市中心的交通压力。\n'
      '第二条：本周末，第十二届国际图书节将在市图书馆举行。'
      '届时，来自三十多个国家的作家将与读者见面。'
      '本届图书节的主题为"阅读之美"。组织者表示，'
      '所有活动均免费向公众开放，详情可在图书馆网站查询。',
  passageTranslation:
      'Good evening, and welcome to the evening news.\n'
      'Item one: the city\'s Metro Line 5 will officially open next month. '
      'The new line runs 42 kilometres and consists of 28 stations. Experts '
      'believe its opening will greatly ease traffic pressure downtown.\n'
      'Item two: this weekend, the 12th International Book Festival will be '
      'held at the city library. Writers from more than thirty countries will '
      'meet readers. This year\'s theme is "The Beauty of Reading". The '
      'organizers say all events are open to the public free of charge; '
      'details on the library\'s website.',
  intro:
      'Two broadcast news items — 将于, 由…组成, 均, 之美: the written '
      'register read aloud, exactly as Chinese TV does nightly.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '均 = written 都',
      text: '所有活动均免费 — all events are free. 均 is 都 in a suit; you\'ll '
          'hear it only in announcements and read it everywhere (Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '地铁五号线什么时候开通？',
      options: ['下月', '本周末', '明年'],
      correctIndex: 0,
      questionTranslation: 'When does Metro Line 5 open?',
    ),
    ReadingQuestion(
      question: '五号线由多少个车站组成？',
      options: ['二十八个', '四十二个', '三十个'],
      correctIndex: 0,
      questionTranslation: 'How many stations does Line 5 consist of?',
    ),
    ReadingQuestion(
      question: '图书节的活动要花多少钱？',
      options: ['免费', '很贵', '每场十块'],
      correctIndex: 0,
      questionTranslation: 'How much do the book festival events cost?',
    ),
  ],
);

final QuizContent enZhC12Discourse = enZhFill(
  id: 'en_zh_c1_2_discourse',
  title: 'Flow markers: 然而 / 因此 / 此外 / 总之',
  intro:
      'The written connective set: 然而 however, 因此 therefore, 此外 '
      'furthermore, 总之 in short — the skeleton of every essay and report.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Match register across the sentence (Z25/Z30)',
      text: '然而 belongs with 将/由/之; 可是 belongs with 把/在/的. Mixing '
          '(然而…啦!) jars like "however… gonna". Pick a register, keep it.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'However, the facts are not so. (written but)', answer: '**然而**，事实并非如此。', accepted: ['rán\'ér', 'raner'], hint: 'rán\'ér, shìshí bìngfēi rúcǐ'),
    CourseItem(prompt: 'Therefore, we must act at once. (written so)', answer: '**因此**，我们必须立刻行动。', accepted: ['yīncǐ'], hint: 'yīncǐ, wǒmen bìxū lìkè xíngdòng'),
    CourseItem(prompt: 'Furthermore, costs keep rising.', answer: '**此外**，成本不断上升。', accepted: ['cǐwài'], hint: 'cǐwài, chéngběn búduàn shàngshēng'),
    CourseItem(prompt: 'In short, this plan is worth trying.', answer: '**总之**，这个方案值得一试。', accepted: ['zǒngzhī'], hint: 'zǒngzhī, zhè ge fāng\'àn zhídé yí shì'),
    CourseItem(prompt: 'The plan has clear advantages; however, the risks must not be ignored.', answer: '方案优点明显，**然而**风险也不容忽视。', accepted: ['rán\'ér'], hint: 'fāng\'àn yōudiǎn míngxiǎn, rán\'ér fēngxiǎn yě bùróng hūshì'),
    CourseItem(prompt: 'However, things changed quickly. (written but)', answer: '**然而**，情况很快发生了变化。', accepted: ['rán\'ér', 'raner'], hint: 'rán\'ér, qíngkuàng hěn kuài fāshēng le biànhuà'),
    CourseItem(prompt: 'Therefore, the plan was postponed.', answer: '**因此**，计划被推迟了。', accepted: ['yīncǐ'], hint: 'yīncǐ, jìhuà bèi tuīchí le'),
    CourseItem(prompt: 'Furthermore, we still need more time.', answer: '**此外**，我们还需要更多时间。', accepted: ['cǐwài'], hint: 'cǐwài, wǒmen hái xūyào gèng duō shíjiān'),
    CourseItem(prompt: 'In short, the experiment succeeded.', answer: '**总之**，实验成功了。', accepted: ['zǒngzhī'], hint: 'zǒngzhī, shíyàn chénggōng le'),
    CourseItem(prompt: 'Costs rose; therefore prices rose too.', answer: '成本上升，**因此**价格也上涨了。', accepted: ['yīncǐ'], hint: 'chéngběn shàngshēng, yīncǐ jiàgé yě shàngzhǎng le'),
    CourseItem(prompt: 'However, not everyone agrees with this view.', answer: '**然而**，并不是所有人都同意这个看法。', accepted: ['rán\'ér', 'raner'], hint: 'rán\'ér, bìng bú shì suǒyǒu rén dōu tóngyì zhè ge kànfǎ'),
    CourseItem(prompt: 'Furthermore, the survey covered only three cities.', answer: '**此外**，调查只包括了三个城市。', accepted: ['cǐwài'], hint: 'cǐwài, diàochá zhǐ bāokuò le sān ge chéngshì'),
    CourseItem(prompt: 'In short, prevention matters more than treatment. (预防/治疗)', answer: '**总之**，预防比治疗更重要。', accepted: ['zǒngzhī'], hint: 'zǒngzhī, yùfáng bǐ zhìliáo gèng zhòngyào'),
    CourseItem(prompt: 'The population is aging; therefore demand for care is growing.', answer: '人口老龄化，**因此**护理需求不断增长。', accepted: ['yīncǐ'], hint: 'rénkǒu lǎolínghuà, yīncǐ hùlǐ xūqiú búduàn zēngzhǎng'),
    CourseItem(prompt: 'However, the data tells a different story. (数据)', answer: '**然而**，数据说明了另一个情况。', accepted: ['rán\'ér', 'raner'], hint: 'rán\'ér, shùjù shuōmíng le lìng yí ge qíngkuàng'),
  ],
);

final QuizContent enZhC12Rhetorical = enZhFill(
  id: 'en_zh_c1_2_rhetorical',
  title: 'Rhetorical questions: 难道 / 岂不',
  intro:
      'Questions that argue: 难道…吗? — "do you seriously mean…?"; 岂不(是) — '
      '"wouldn\'t that be…?". Both expect agreement, not answers.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'A question wearing armor',
      text: '难道你忘了吗? — surely you haven\'t forgotten?! The literal '
          'question mark hides an exclamation. Use sparingly: one per '
          'argument hits hard, three per paragraph is melodrama.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Surely you haven\'t forgotten?!', answer: '**难道**你忘了吗？', accepted: ['nándào'], hint: 'nándào nǐ wàng le ma'),
    CourseItem(prompt: 'Wouldn\'t that be even better?', answer: '这**岂不**是更好吗？', accepted: ['qǐbù', 'qǐ bù'], hint: 'zhè qǐbù shì gèng hǎo ma'),
    CourseItem(prompt: 'Do you seriously think this is a coincidence?', answer: '**难道**这只是巧合吗？', accepted: ['nándào'], hint: 'nándào zhè zhǐshì qiǎohé ma'),
    CourseItem(prompt: 'Giving up now — wouldn\'t all the effort be wasted?', answer: '现在放弃，之前的努力**岂不**白费了吗？', accepted: ['qǐbù'], hint: 'xiànzài fàngqì, zhīqián de nǔlì qǐbù báifèi le ma'),
    CourseItem(prompt: 'Can it be that we can\'t solve even this small problem?', answer: '**难道**我们连这个小问题都解决不了吗？', accepted: ['nándào'], hint: 'nándào wǒmen lián zhè ge xiǎo wèntí dōu jiějué bùliǎo ma'),
    CourseItem(prompt: 'Surely you don\'t believe this?!', answer: '**难道**你相信这个吗？', accepted: ['nándào'], hint: 'nándào nǐ xiāngxìn zhè ge ma'),
    CourseItem(prompt: 'Wouldn\'t that be a pity?', answer: '这**岂不**是很可惜吗？', accepted: ['qǐbù', 'qǐ bù'], hint: 'zhè qǐbù shì hěn kěxī ma'),
    CourseItem(prompt: 'Surely he isn\'t still waiting?!', answer: '**难道**他还在等吗？', accepted: ['nándào'], hint: 'nándào tā hái zài děng ma'),
    CourseItem(prompt: 'Doing it this way — wouldn\'t it be faster?', answer: '这样做**岂不**更快？', accepted: ['qǐbù'], hint: 'zhèyàng zuò qǐbù gèng kuài'),
    CourseItem(prompt: 'Doesn\'t this deserve our reflection?!', answer: '**难道**这不值得我们思考吗？', accepted: ['nándào'], hint: 'nándào zhè bù zhídé wǒmen sīkǎo ma'),
    CourseItem(prompt: 'Surely this isn\'t just my problem?!', answer: '**难道**这只是我一个人的问题吗？', accepted: ['nándào'], hint: 'nándào zhè zhǐshì wǒ yí ge rén de wèntí ma'),
    CourseItem(prompt: 'Solving it early — wouldn\'t that save trouble? (省事)', answer: '早点儿解决**岂不**省事？', accepted: ['qǐbù', 'qǐ bù'], hint: 'zǎodiǎnr jiějué qǐbù shěngshì'),
    CourseItem(prompt: 'Surely you don\'t plan to give up?!', answer: '**难道**你打算放弃吗？', accepted: ['nándào'], hint: 'nándào nǐ dǎsuàn fàngqì ma'),
    CourseItem(prompt: 'Wouldn\'t that be a waste of everyone\'s time?', answer: '这**岂不**是浪费大家的时间吗？', accepted: ['qǐbù', 'qǐ bù'], hint: 'zhè qǐbù shì làngfèi dàjiā de shíjiān ma'),
    CourseItem(prompt: 'Can it be that we learned nothing from history?!', answer: '**难道**我们没有从历史中学到什么吗？', accepted: ['nándào'], hint: 'nándào wǒmen méiyǒu cóng lìshǐ zhōng xué dào shénme ma'),
  ],
);

final QuizContent enZhC12ReadEditorial = enZhRead(
  id: 'en_zh_c1_2_read_editorial',
  title: 'Reading: 一篇社论',
  passageTitle: '社论：让城市为行人留一条路',
  passage:
      '近年来，本市机动车数量持续增长，人行道却越修越窄，'
      '部分路段甚至被停放的车辆完全占用。行人被迫走上机动车道，'
      '安全问题日益突出。\n'
      '有人认为，城市的首要任务是保证交通效率，行人应当"让路"。'
      '然而，这种观点岂不是本末倒置？城市因人而生，为人而建。'
      '一座只方便汽车而不方便行人的城市，谈何宜居？\n'
      '因此，我们呼吁：第一，有关部门应尽快清理被占用的人行道，'
      '违规停车行为必须受到处罚；第二，新建道路必须为行人和自行车'
      '留出足够的空间；此外，学校、医院周边路段应设置更多的过街设施。\n'
      '总之，衡量一座城市的文明程度，不在于它的高楼有多高，'
      '而在于它对最普通的行人有多友好。',
  passageTranslation:
      'Editorial: Leave the pedestrians a path\n'
      'In recent years, the number of motor vehicles in our city has kept '
      'growing while pavements are built ever narrower — some stretches are '
      'entirely occupied by parked cars. Pedestrians are forced onto the '
      'roadway, and safety problems grow by the day.\n'
      'Some argue a city\'s first task is traffic efficiency, and pedestrians '
      'should "give way". But isn\'t that putting the cart before the horse? '
      'Cities exist because of people and are built for people. A city '
      'convenient for cars but not for walkers — how could it be called '
      'livable?\n'
      'We therefore urge: first, the authorities should promptly clear the '
      'occupied pavements, and illegal parking must be punished; second, new '
      'roads must reserve adequate space for pedestrians and bicycles; '
      'furthermore, more crossings should be installed near schools and '
      'hospitals.\n'
      'In short, a city\'s civilization is measured not by the height of its '
      'towers but by its friendliness to the ordinary person on foot.',
  intro:
      'A full editorial in 书面语: 然而/因此/此外/总之 as skeleton, 受到 '
      'passives, a rhetorical 岂不, and the closing 不在于…而在于.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '不在于 A，而在于 B',
      text: '"lies not in A but in B" — the editorial\'s closing frame is a '
          'C1 essay staple. Steal it for your own conclusions (Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '部分人行道被什么占用了？',
      options: ['停放的车辆', '商店', '自行车'],
      correctIndex: 0,
      questionTranslation: 'What is occupying some pavements?',
    ),
    ReadingQuestion(
      question: '文章认为城市是为谁建的？',
      options: ['为人', '为汽车', '为公司'],
      correctIndex: 0,
      questionTranslation: 'Who does the editorial say cities are built for?',
    ),
    ReadingQuestion(
      question: '衡量城市文明程度，文章认为在于什么？',
      options: ['对行人有多友好', '高楼有多高', '汽车有多少'],
      correctIndex: 0,
      questionTranslation: 'What measures a city\'s civilization, per the editorial?',
    ),
  ],
);

final QuizContent enZhC12Hedging = enZhFill(
  id: 'en_zh_c1_2_hedging',
  title: 'Hedging: 恐怕 / 未必 / 不见得',
  intro:
      'Soften claims like an educated speaker: 恐怕 I\'m afraid…, 未必 not '
      'necessarily (written), 不见得 not necessarily (spoken), 在一定程度上 '
      'to some extent.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Hedge the claim, keep the face',
      text: 'Blunt 你错了 vs hedged 这个说法恐怕不太准确. Chinese argument '
          'culture prizes the soft landing — the hedge IS the politeness.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I\'m afraid this won\'t work.', answer: '这样**恐怕**不行。', accepted: ['kǒngpà'], hint: 'zhèyàng kǒngpà bùxíng'),
    CourseItem(prompt: 'Expensive is not necessarily good. (written hedge)', answer: '贵的**未必**好。', accepted: ['wèibì'], hint: 'guì de wèibì hǎo'),
    CourseItem(prompt: 'He doesn\'t necessarily agree. (spoken hedge)', answer: '他**不见得**同意。', accepted: ['bújiàndé', 'bu jian de'], hint: 'tā bújiàndé tóngyì'),
    CourseItem(prompt: 'To some extent, this view is reasonable.', answer: '**在一定程度上**，这个看法有道理。', accepted: ['zài yídìng chéngdù shàng'], hint: 'zài yídìng chéngdù shàng, zhè ge kànfǎ yǒu dàolǐ'),
    CourseItem(prompt: 'I\'m afraid we must reconsider. (恐怕 + 得)', answer: '我们**恐怕**得重新考虑。', accepted: ['kǒngpà'], hint: 'wǒmen kǒngpà děi chóngxīn kǎolǜ'),
    CourseItem(prompt: 'I\'m afraid it\'s too late.', answer: '**恐怕**太晚了。', accepted: ['kǒngpà'], hint: 'kǒngpà tài wǎn le'),
    CourseItem(prompt: 'The most expensive is not necessarily the best. (written)', answer: '最贵的**未必**是最好的。', accepted: ['wèibì'], hint: 'zuì guì de wèibì shì zuì hǎo de'),
    CourseItem(prompt: 'This method doesn\'t necessarily work. (spoken hedge)', answer: '这个办法**不见得**有用。', accepted: ['bújiàndé', 'bu jian de'], hint: 'zhè ge bànfǎ bújiàndé yǒuyòng'),
    CourseItem(prompt: 'To some extent, he is right.', answer: '**在一定程度上**，他是对的。', accepted: ['zài yídìng chéngdù shàng'], hint: 'zài yídìng chéngdù shàng, tā shì duì de'),
    CourseItem(prompt: 'I\'m afraid the meeting has to be postponed.', answer: '会议**恐怕**要推迟了。', accepted: ['kǒngpà'], hint: 'huìyì kǒngpà yào tuīchí le'),
    CourseItem(prompt: 'More people is not necessarily better. (written hedge)', answer: '人多**未必**是好事。', accepted: ['wèibì'], hint: 'rén duō wèibì shì hǎoshì'),
    CourseItem(prompt: 'What he said isn\'t necessarily true. (spoken hedge)', answer: '他说的**不见得**是真的。', accepted: ['bújiàndé', 'bu jian de'], hint: 'tā shuō de bújiàndé shì zhēn de'),
    CourseItem(prompt: 'To some extent, technology changed how we think.', answer: '**在一定程度上**，科技改变了我们的思维方式。', accepted: ['zài yídìng chéngdù shàng'], hint: 'zài yídìng chéngdù shàng, kējì gǎibiàn le wǒmen de sīwéi fāngshì'),
    CourseItem(prompt: 'I\'m afraid this price is beyond our budget. (预算)', answer: '这个价格**恐怕**超出了我们的预算。', accepted: ['kǒngpà'], hint: 'zhè ge jiàgé kǒngpà chāochū le wǒmen de yùsuàn'),
    CourseItem(prompt: 'Working overtime every day doesn\'t necessarily raise efficiency. (written)', answer: '天天加班**未必**能提高效率。', accepted: ['wèibì'], hint: 'tiāntiān jiābān wèibì néng tígāo xiàolǜ'),
  ],
);

final QuizContent enZhC12RegisterPairs = enZhFill(
  id: 'en_zh_c1_2_register_pairs',
  title: 'Register pairs: 跟→与, 给→为, 用→以',
  intro:
      'Every everyday function word has a written twin: 跟→与, 给→为, 用→以, '
      '从→自, 到→至, 都→均, 很→十分. Same meaning, different suit.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The wardrobe rule (Z30)',
      text: 'One idea, two outfits: 跟你合作 (jeans) → 与您合作 (suit). '
          'Reading news, translate the suits back to jeans and the grammar '
          'is one you already know.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'to cooperate with you (formal: 与)', answer: '**与**您合作', accepted: ['yǔ'], hint: 'yǔ nín hézuò'),
    CourseItem(prompt: 'to provide services for customers (formal: 为)', answer: '**为**顾客提供服务', accepted: ['wèi'], hint: 'wèi gùkè tígōng fúwù'),
    CourseItem(prompt: 'from Beijing to Shanghai (formal: 至)', answer: '自北京**至**上海', accepted: ['zhì'], hint: 'zì Běijīng zhì Shànghǎi'),
    CourseItem(prompt: 'The results are extremely clear. (formal 很: 十分)', answer: '结果**十分**明显。', accepted: ['shífēn'], hint: 'jiéguǒ shífēn míngxiǎn'),
    CourseItem(prompt: 'to solve the problem by this method (formal 用: 以)', answer: '**以**这种方法解决问题', accepted: ['yǐ'], hint: 'yǐ zhè zhǒng fāngfǎ jiějué wèntí'),
    CourseItem(prompt: 'All the prices include tax. (formal 都: 均)', answer: '所有价格**均**含税。', accepted: ['jūn'], hint: 'suǒyǒu jiàgé jūn hán shuì'),
    CourseItem(prompt: 'to discuss this question with experts (formal: 与)', answer: '**与**专家讨论这个问题', accepted: ['yǔ'], hint: 'yǔ zhuānjiā tǎolùn zhè ge wèntí'),
    CourseItem(prompt: 'from the 1st to the 5th (formal: 至)', answer: '一号**至**五号', accepted: ['zhì'], hint: 'yī hào zhì wǔ hào'),
    CourseItem(prompt: 'This service is extremely important. (formal 很: 十分)', answer: '这项服务**十分**重要。', accepted: ['shífēn'], hint: 'zhè xiàng fúwù shífēn zhòngyào'),
    CourseItem(prompt: 'to make a decision for the company (formal 给: 为)', answer: '**为**公司做决定', accepted: ['wèi'], hint: 'wèi gōngsī zuò juédìng'),
    CourseItem(prompt: 'to sign an agreement with the government (formal: 与)', answer: '**与**政府签署协议', accepted: ['yǔ'], hint: 'yǔ zhèngfǔ qiānshǔ xiéyì'),
    CourseItem(prompt: 'The letter comes from a reader. (formal 从: 自)', answer: '这封信来**自**一位读者。', accepted: ['zì'], hint: 'zhè fēng xìn lái zì yí wèi dúzhě'),
    CourseItem(prompt: 'to celebrate for the whole team (formal 给: 为)', answer: '**为**全队庆祝', accepted: ['wèi'], hint: 'wèi quán duì qìngzhù'),
    CourseItem(prompt: 'open from 9 a.m. to 5 p.m. (formal: 至)', answer: '上午九点**至**下午五点开放', accepted: ['zhì'], hint: 'shàngwǔ jiǔ diǎn zhì xiàwǔ wǔ diǎn kāifàng'),
    CourseItem(prompt: 'to express thanks in this way (formal 用: 以…表示)', answer: '**以**这种方式表示感谢', accepted: ['yǐ'], hint: 'yǐ zhè zhǒng fāngshì biǎoshì gǎnxiè'),
  ],
);

final QuizContent enZhC12SpeakRegister = enZhSpeak(
  id: 'en_zh_c1_2_speak_register',
  title: 'Speaking: formal vs casual delivery',
  intro:
      'The same message in two outfits — say both versions and feel the '
      'register switch in your mouth.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hear the suit change',
      text: 'Casual runs fast and swallows; formal walks evenly and '
          'finishes every syllable. Practice flipping — interpreting between '
          'registers is a real C1 skill (Z30).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Casual: Zhè shìr gěi wǒ ba! — Leave this to me!', answer: '这事儿给我吧！'),
    CourseItem(prompt: 'Formal: Cǐ shì jiāng yóu wǒ fùzé. — This matter will be handled by me.', answer: '此事将由我负责。'),
    CourseItem(prompt: 'Casual: Míngtiān jiǔ diǎn kāihuì, dōu děi lái a! — Meeting at nine tomorrow, everyone has to come!', answer: '明天九点开会，都得来啊！'),
    CourseItem(prompt: 'Formal: Huìyì jiāng yú míngrì jiǔ shí jǔxíng, qǐng zhǔnshí chūxí. — The meeting will be held at nine tomorrow; please attend punctually.', answer: '会议将于明日九时举行，请准时出席。'),
    CourseItem(prompt: 'Casual: Xièxie dàjiā bāngmáng! — Thanks for the help, everyone!', answer: '谢谢大家帮忙！'),
    CourseItem(prompt: 'Formal: Zhōngxīn gǎnxiè gèwèi de dàlì zhīchí. — Heartfelt thanks to you all for your generous support.', answer: '衷心感谢各位的大力支持。'),
  ],
);

final QuizContent enZhC12BigtextFormal = enZhBigText(
  id: 'en_zh_c1_2_bigtext_formal',
  title: 'Big text: a report in 书面语',
  passageTitle: '关于图书馆使用情况的报告',
  template:
      '关于图书馆使用情况的报告\n\n'
      '本学期，图书馆的使用情况{{0}}明显改善。'
      '与去年相比，每日到馆人数增长了三分{{1}}一。'
      '其中，周末的阅览室{{2}}受学生欢迎，常常座无虚席。\n'
      '调查显示，大部分学生对新的开放时间表示满意，'
      '{{3}}，也有部分同学建议，考试期间应{{4}}开放时间延长至晚上十一点。'
      '{{5}}，自习区的座位仍然不足，高峰时段约有五分之一的学生找不到座位。\n'
      '{{6}}，我们建议：第一，增设两百个自习座位；'
      '第二，考试期间延长开放时间；第三，所有新措施{{7}}于下月起实行。',
  blanks: [
    particleBlank('有了', options: const ['有了', '被', '受到'], translation: 'usage HAS improved — plain 有了 fits; the passives don\'t'),
    particleBlank('之', options: const ['之', '的', '得'], translation: 'fractions use classical 之: 三分之一'),
    particleBlank('最', options: const ['最', '更', '十分'], translation: 'THE most popular — superlative 最'),
    particleBlank('然而', options: const ['然而', '可是', '否则'], translation: 'written "however" to match the register'),
    particleBlank('将', options: const ['将', '把', '被'], translation: 'written 把 in a formal suggestion: 将开放时间延长'),
    particleBlank('此外', options: const ['此外', '总之', '因此'], translation: 'furthermore — one more finding follows'),
    particleBlank('因此', options: const ['因此', '此外', '然而'], translation: 'therefore — the conclusions follow'),
    particleBlank('均', options: const ['均', '都', '也'], translation: 'written 都: all measures take effect'),
  ],
  passageTranslation:
      'Report on library usage\n\n'
      'This semester, library usage has clearly improved. Compared with last '
      'year, daily visits grew by one third. The weekend reading rooms are '
      'the most popular with students — often not an empty seat.\n'
      'Surveys show most students are satisfied with the new opening hours; '
      'however, some suggest extending opening to 11 p.m. during exams. '
      'Furthermore, study-area seats remain insufficient: at peak times about '
      'one fifth of students cannot find a seat.\n'
      'We therefore recommend: first, adding 200 study seats; second, longer '
      'hours during exams; third, all new measures to take effect from next '
      'month.',
  intro:
      'A campus report with its register words removed. For each gap, pick '
      'the form that keeps the whole text in 书面语 — the casual twin is '
      'always lurking among the options.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Register is a system (Z30)',
      text: 'One 可是 in a report of 然而s breaks the suit. Choose by '
          'register first, grammar second — every option is grammatical, '
          'only one is dressed right.',
    ),
  ],
);

final QuizContent enZhC12ListenBusiness = enZhListen(
  id: 'en_zh_c1_2_listen_business',
  title: 'Listening: 商务会谈',
  passageTitle: '一次商务会谈',
  passage:
      '"李总，欢迎欢迎！感谢您百忙之中抽时间与我们见面。"\n'
      '"张经理客气了。贵公司的方案我们已经仔细研究过了。"\n'
      '"您觉得怎么样？"\n'
      '"总的来说，方案十分专业。不过，恐怕有两点需要再商量：'
      '第一，交货时间太紧，我们希望能延长两周；'
      '第二，关于售后服务的条款，写得不够具体。"\n'
      '"您提的这两点都很有道理。这样吧，交货时间我们可以调整，'
      '售后条款今天下午就由法务部重新起草，明天发给贵公司。"\n'
      '"好，那就这么定了。合作愉快！"\n'
      '"合作愉快！"',
  passageTranslation:
      '"Director Li, welcome! Thank you for making time to meet us out of '
      'your busy schedule."\n'
      '"You\'re too kind, Manager Zhang. We have studied your company\'s '
      'proposal carefully."\n'
      '"What do you think?"\n'
      '"Overall, it\'s very professional. But I\'m afraid two points need '
      'more discussion: first, the delivery schedule is too tight — we\'d '
      'like two more weeks; second, the after-sales clauses aren\'t specific '
      'enough."\n'
      '"Both points are fair. How about this: we can adjust the delivery '
      'time, and our legal department will redraft the after-sales clauses '
      'this afternoon and send them to you tomorrow."\n'
      '"Good, it\'s settled then. To a happy cooperation!"\n'
      '"To a happy cooperation!"',
  intro:
      'Polite business Mandarin: 贵公司, 百忙之中, hedged objections with '
      '恐怕, and a 由-passive in action.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '贵 = your (honorable)',
      text: '贵公司 your (esteemed) company, 贵姓? your honorable surname? — '
          'the politeness prefix that makes business Chinese purr.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '李总觉得方案怎么样？',
      options: ['十分专业，但有两点要商量', '完全不行', '太便宜了'],
      correctIndex: 0,
      questionTranslation: 'What does Director Li think of the proposal?',
    ),
    ReadingQuestion(
      question: '李总希望交货时间怎么样？',
      options: ['延长两周', '提前两周', '不变'],
      correctIndex: 0,
      questionTranslation: 'What does Li want for the delivery time?',
    ),
    ReadingQuestion(
      question: '售后条款由谁重新起草？',
      options: ['法务部', '李总', '销售部'],
      correctIndex: 0,
      questionTranslation: 'Who will redraft the after-sales clauses?',
    ),
  ],
);

final QuizContent enZhC12DictFormal = enZhDict(
  id: 'en_zh_c1_2_dict_formal',
  title: 'Dictation: formal lines',
  intro:
      'Formal sentences at broadcast pace. The written function words (将, '
      '于, 均, 由) are short — but your IME knows them if you type the whole '
      'phrase.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ jiāng/jiàng, yú/yǔ',
      text: 'The written words have common homophones (将/讲, 于/与/雨). '
          'Register expectation — you KNOW a report says 将于 — beats the '
          'ear here (Z30).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The meeting will be held tomorrow morning.', answer: '会议将于明天上午举行。'),
    CourseItem(prompt: 'Please switch off your mobile phone.', answer: '请将手机关闭。'),
    CourseItem(prompt: 'The event is chaired by Professor Wang.', answer: '活动由王教授主持。'),
    CourseItem(prompt: 'However, the problem has not been truly solved.', answer: '然而，问题并没有真正解决。'),
    CourseItem(prompt: 'I\'m afraid we must reconsider.', answer: '恐怕我们得重新考虑。'),
    CourseItem(prompt: 'The exhibition will open on the 5th.', answer: '展览将于五号开幕。'),
    CourseItem(prompt: 'His proposal was rejected.', answer: '他的建议遭到拒绝。'),
    CourseItem(prompt: 'Therefore, we must act at once.', answer: '因此，我们必须立刻行动。'),
    CourseItem(prompt: 'Expensive is not necessarily good.', answer: '贵的未必好。'),
    CourseItem(prompt: 'All prices include tax.', answer: '所有价格均含税。'),
    CourseItem(prompt: 'The film was warmly received by audiences.', answer: '这部电影受到观众的欢迎。'),
    CourseItem(prompt: 'Furthermore, costs keep rising.', answer: '此外，成本不断上升。'),
    CourseItem(prompt: 'One third of the students take the metro to school.', answer: '三分之一的学生坐地铁上学。'),
    CourseItem(prompt: 'In short, this plan is worth trying.', answer: '总之，这个方案值得一试。'),
    CourseItem(prompt: 'He was born in Shanghai in 1985.', answer: '他1985年生于上海。'),
  ],
);

final QuizContent enZhC12ReadLetters = enZhRead(
  id: 'en_zh_c1_2_read_letters',
  title: 'Reading: 两封信，两种语体',
  passageTitle: '两封信',
  passage:
      '【第一封：给朋友的微信】\n'
      '小美！告诉你个好消息——我拿到那份工作啦！'
      '下个月就开始上班，就是你说的那家出版社！'
      '周五晚上出来吃饭吧，我请客！随便你想吃什么！哈哈！\n\n'
      '【第二封：给出版社的邮件】\n'
      '尊敬的人力资源部：\n'
      '您好。我已收到贵社的录用通知，非常感谢贵社给予的信任与机会。'
      '我愿意接受该职位，并将于下月一日准时报到。'
      '如需我提前提交任何材料，请随时与我联系。\n'
      '此致敬礼\n'
      '汤姆',
  passageTranslation:
      '[First: a WeChat message to a friend]\n'
      'Xiaomei! Great news — I got the job!! I start next month — it\'s that '
      'publisher you mentioned! Let\'s go out for dinner Friday night, my '
      'treat! Whatever you feel like eating! Haha!\n\n'
      '[Second: an email to the publisher]\n'
      'Dear Human Resources,\n'
      'I have received your offer of employment, and I am deeply grateful for '
      'the trust and opportunity your company has extended. I am pleased to '
      'accept the position and will report for duty on the 1st of next '
      'month. Should any materials be required in advance, please contact me '
      'at any time.\n'
      'Respectfully yours,\n'
      'Tom',
  intro:
      'The same good news, twice: WeChat-casual and letter-formal. Read them '
      'side by side and collect the register pairs.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Collect the pairs',
      text: '拿到→收到录用通知, 那家→贵社, 就开始上班→将于…报到, 啦/吧/哈哈→'
          '此致敬礼. Same writer, ten minutes apart, two grammars (Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆拿到了什么？',
      options: ['一份工作', '一本书', '一张票'],
      correctIndex: 0,
      questionTranslation: 'What did Tom get?',
    ),
    ReadingQuestion(
      question: '哪封信更正式？',
      options: ['第二封（邮件）', '第一封（微信）'],
      correctIndex: 0,
      questionTranslation: 'Which letter is more formal?',
    ),
    ReadingQuestion(
      question: '"贵社"是什么意思？',
      options: ['您的出版社（尊称）', '很贵的公司', '一个地名'],
      correctIndex: 0,
      questionTranslation: 'What does 贵社 mean?',
    ),
  ],
);

/// C1.2 in chain order.
final List<QuizContent> enZhC1_2 = [
  enZhC12JiangYu,
  enZhC12ZhiErZe,
  enZhC12SpeakNews,
  enZhC12FormalPassive,
  enZhC12ListenNews,
  enZhC12Discourse,
  enZhC12Rhetorical,
  enZhC12ReadEditorial,
  enZhC12Hedging,
  enZhC12RegisterPairs,
  enZhC12SpeakRegister,
  enZhC12BigtextFormal,
  enZhC12ListenBusiness,
  enZhC12DictFormal,
  enZhC12ReadLetters,
];
