import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// B2.2 — Reporting & Nuance · 转述与细节. Mandarin → English.
///
/// Big rock: **reported speech (full backshift)** (Z29) and modals of deduction.
/// Also non-defining relative clauses (Z23), separable phrasal verbs (Z30),
/// connected speech (Z10), and topic→subject nuance in complex sentences (Z22).

final QuizContent zhEnB22Reported = zhEnFill(
  id: 'zh_en_b2_2_reported',
  title: '间接引语：陈述句',
  intro: '转述陈述句时，主要动词的时态要「后退一步」。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 时态后退（Z29）',
      text: 'is→was，will→would，can→could，have→had，过去式→过去完成。也要改人称和时间词（today→that day）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他说他很忙。', answer: 'He said he **was** busy.'),
    CourseItem(prompt: '她说她会打电话。', answer: 'She said she **would** call.'),
    CourseItem(prompt: '他们说他们看过了。', answer: 'They said they **had** seen it.'),
    CourseItem(prompt: '他说他不能来。', answer: "He said he **couldn't** come."),
    CourseItem(prompt: '她告诉我她累了。', answer: 'She told me she **was** tired.'),
  ],
);

final QuizContent zhEnB22ReportedQ = zhEnFill(
  id: 'zh_en_b2_2_reported_q',
  title: '间接引语：疑问与命令',
  intro: '转述疑问句用陈述语序；转述命令用 tell/ask sb (not) to do。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '语序与结构',
      text: '特殊疑问：where I **lived**（陈述语序）；一般疑问：ask **if/whether**；命令：tell sb **to**/not to do。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他问我住在哪里。', answer: 'He asked me where I **lived**.'),
    CourseItem(prompt: '她问我是否喜欢它。', answer: 'She asked me **if** I liked it.'),
    CourseItem(prompt: '他让我等一下。', answer: 'He told me **to** wait.'),
    CourseItem(prompt: '她叫我别迟到。', answer: 'She told me **not** to be late.'),
    CourseItem(prompt: '他问现在几点。', answer: 'He asked what **time** it was.'),
  ],
);

final QuizContent zhEnB22ReportingVerbs = zhEnFill(
  id: 'zh_en_b2_2_reporting_verbs',
  title: '转述动词及其搭配',
  intro: '不同的转述动词有不同的句型：有的接 -ing，有的接不定式。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '搭配（Z26/Z29）',
      text: 'suggest / admit / deny + V-ing；refuse / promise / offer + to do。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他建议早点出发。', answer: 'He suggested **leaving** early.'),
    CourseItem(prompt: '她承认犯了错误。', answer: 'She admitted **making** a mistake.'),
    CourseItem(prompt: '他们拒绝帮忙。', answer: 'They refused **to help**.'),
    CourseItem(prompt: '他答应回来。', answer: 'He promised **to return**.'),
    CourseItem(prompt: '她否认拿了钱。', answer: 'She denied **taking** the money.'),
  ],
);

final QuizContent zhEnB22SpeakReport = zhEnSpeak(
  id: 'zh_en_b2_2_speak_report',
  title: '开口说：转述别人的话',
  intro: '把别人说的话转述出来。听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '常用转述句型',
      text: 'He said (that)… / She told me… / He asked if… / She suggested that…。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他说他会晚点到。', answer: 'He said he would be late.'),
    CourseItem(prompt: '她告诉我她找到了工作。', answer: 'She told me she had found a job.'),
    CourseItem(prompt: '他们说他们同意。', answer: 'They said they agreed.'),
    CourseItem(prompt: '他问我要不要帮忙。', answer: 'He asked if I needed help.'),
    CourseItem(prompt: '她建议我们等一等。', answer: 'She suggested that we wait.'),
  ],
);

final QuizContent zhEnB22Deduction = zhEnFill(
  id: 'zh_en_b2_2_deduction',
  title: '推测（现在）',
  intro: '用 must / might / can\'t 对现在的情况做推断。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '肯定/可能/否定推断',
      text: 'must（一定是）、might/may（可能是）、can\'t（不可能是）+ be/原形。',
    ),
  ],
  items: const [
    CourseItem(prompt: '灯亮着，他一定在家。', answer: 'He **must** be at home; the lights are on.'),
    CourseItem(prompt: '她可能病了。', answer: 'She **might** be ill.'),
    CourseItem(prompt: '这不可能是真的。', answer: "It **can't** be true."),
    CourseItem(prompt: '你一定很累。', answer: 'You **must** be tired.'),
    CourseItem(prompt: '他也许知道。', answer: 'He **may** know.'),
  ],
);

final QuizContent zhEnB22DeductionPast = zhEnFill(
  id: 'zh_en_b2_2_deduction_past',
  title: '推测（过去）',
  intro: '用 must / might / can\'t + have + V3 对过去的情况做推断。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '过去推断',
      text: 'must have + V3（一定做过）、might have + V3（可能做过）、can\'t have + V3（不可能做过）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '他一定是忘了。', answer: 'He **must** have forgotten.'),
    CourseItem(prompt: '她可能错过了火车。', answer: 'She **might** have missed the train.'),
    CourseItem(prompt: '你不可能看到他。', answer: "You **can't** have seen him."),
    CourseItem(prompt: '他们一定很努力。', answer: 'They **must** have worked hard.'),
    CourseItem(prompt: '我可能把它落在家里了。', answer: 'I **might** have left it at home.'),
  ],
);

final QuizContent zhEnB22ListenNews = zhEnListen(
  id: 'zh_en_b2_2_listen_news',
  title: '听力：A news report',
  passageTitle: 'Evening news',
  passage:
      'Good evening. Here is the news. Heavy rain has caused flooding in '
      'several parts of the country today. In the north, hundreds of people '
      'have been forced to leave their homes. The government has promised to '
      'send help, and emergency teams are working through the night. Experts '
      'say the rain must have been the heaviest in fifty years. Drivers are '
      'advised to avoid the affected roads. We will bring you more updates '
      'later this evening.',
  passageTranslation:
      '晚上好，为您播报新闻。今天暴雨在全国多地引发洪灾。北方有数百人被迫离开家园。政府已承诺'
      '派遣救援，应急队伍正连夜工作。专家称这场雨可能是五十年来最大的一次。提醒驾驶员避开受灾'
      '路段。今晚稍后我们将带来更多最新消息。',
  intro: '先听，再答题。新闻里有被动和过去推断结构。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '被动 + 过去推断',
      text: 'have been forced（被动完成）；must have been the heaviest（过去推断）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What has happened?',
      options: ['Flooding', 'A fire', 'An earthquake'],
      correctIndex: 0,
      questionTranslation: '发生了什么？',
    ),
    ReadingQuestion(
      question: 'What has the government promised?',
      options: ['To send help', 'To do nothing', 'To raise taxes'],
      correctIndex: 0,
      questionTranslation: '政府承诺了什么？',
    ),
    ReadingQuestion(
      question: 'What are drivers advised to do?',
      options: ['Avoid the affected roads', 'Drive fast', 'Stay in their cars'],
      correctIndex: 0,
      questionTranslation: '提醒驾驶员做什么？',
    ),
  ],
);

final QuizContent zhEnB22Nondefining = zhEnFill(
  id: 'zh_en_b2_2_nondefining',
  title: '非限定性定语从句',
  intro: '非限定从句用逗号隔开，补充「额外」信息（去掉也不影响主句意思），不用 that。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '逗号 + who/which',
      text: 'My uncle, **who** lives in London, is a doctor。人用 who，物用 which，绝不用 that。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我叔叔（住在伦敦）是医生。', answer: 'My uncle, **who** lives in London, is a doctor.'),
    CourseItem(prompt: '这本书（去年出版）很受欢迎。', answer: 'The book, **which** was published last year, is popular.'),
    CourseItem(prompt: '北京（中国的首都）很大。', answer: 'Beijing, **which** is the capital of China, is huge.'),
    CourseItem(prompt: '她哥哥（一名教师）帮了我们。', answer: 'Her brother, **who** is a teacher, helped us.'),
    CourseItem(prompt: '这部电影（我上周看的）很棒。', answer: 'The film, **which** I saw last week, was great.'),
  ],
);

final QuizContent zhEnB22ReadCulture = zhEnRead(
  id: 'zh_en_b2_2_read_culture',
  title: '阅读：A cultural misunderstanding',
  passageTitle: 'Reading between the lines',
  passage:
      'When Li Wei started working in London, he made an interesting discovery '
      'about British culture. In China, he was used to being direct. But his '
      "British colleagues often said things like 'That might be a bit "
      "difficult' when they actually meant 'no'. At first, Li Wei was confused. "
      'He thought people were unsure, but really they were being polite. He '
      'also noticed that the British apologise a lot, even when something is '
      "not their fault. Over time, Li Wei learnt to 'read between the lines'. "
      'He realised that understanding a culture is just as important as '
      'speaking the language.',
  passageTranslation:
      '李伟刚到伦敦工作时，对英国文化有了一个有趣的发现。在中国，他习惯直来直去。但他的英国同事'
      '常说「那可能有点难」，其实意思是「不行」。起初李伟很困惑，以为大家拿不定主意，其实他们是'
      '在委婉客气。他还注意到英国人很爱道歉，哪怕并不是他们的错。渐渐地，李伟学会了「听出言外之意」。'
      '他意识到，理解一种文化和会说这门语言同样重要。',
  intro: '读一段关于跨文化沟通的短文。留意英语的委婉与「言外之意」。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '委婉与习语（Z32）',
      text: "'read between the lines'（听出言外之意）；英语常用委婉语气代替直接的「不」。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What surprised Li Wei?',
      options: ['Indirect, polite language', 'Rude people', 'No English'],
      correctIndex: 0,
      questionTranslation: '什么让李伟意外？',
    ),
    ReadingQuestion(
      question: "What did 'That might be difficult' really mean?",
      options: ['No', 'Yes', 'Maybe'],
      correctIndex: 0,
      questionTranslation: '「那可能有点难」其实是什么意思？',
    ),
    ReadingQuestion(
      question: 'What did he learn?',
      options: ['Culture matters as much as language', 'Language is enough', 'To be rude'],
      correctIndex: 0,
      questionTranslation: '他学到了什么？',
    ),
  ],
);

final QuizContent zhEnB22Phrasal = zhEnFill(
  id: 'zh_en_b2_2_phrasal',
  title: '可分短语动词',
  intro: '许多短语动词可以「分开」，而且宾语是代词时必须放在中间。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 代词放中间（Z30）',
      text: 'turn the TV off / turn it off（代词必须放中间，不能说 turn off it）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '请把电视关掉。', answer: 'Please turn the TV **off**.'),
    CourseItem(prompt: '我得查一下这个词。', answer: 'I need to look this word **up**.'),
    CourseItem(prompt: '别把会议推迟。', answer: "Don't put the meeting **off**."),
    CourseItem(prompt: '把你的外套脱掉。', answer: 'Take your coat **off**.'),
    CourseItem(prompt: '他填好了表格。', answer: 'He filled the form **in**.'),
  ],
);

final QuizContent zhEnB22Causative = zhEnFill(
  id: 'zh_en_b2_2_causative',
  title: '使役结构：have / get sth done',
  intro: 'have/get + 宾语 + 过去分词，表示「请／让别人做某事」。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'have/get + 宾语 + V3',
      text: 'have my hair **cut**（让别人给我剪头发），不是我自己剪。get 更口语。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我要去理发。', answer: "I'm going to have my hair **cut**."),
    CourseItem(prompt: '她把车修好了。', answer: 'She had her car **repaired**.'),
    CourseItem(prompt: '我们在请人粉刷房子。', answer: 'We are having the house **painted**.'),
    CourseItem(prompt: '你应该去检查眼睛。', answer: 'You should have your eyes **tested**.'),
    CourseItem(prompt: '我把照片洗出来了。', answer: 'I got the photos **printed**.'),
  ],
);

final QuizContent zhEnB22SpeakWeak = zhEnSpeak(
  id: 'zh_en_b2_2_speak_weak',
  title: '发音：连读与弱读',
  intro: '功能词（to, and, of, have）在句中会弱读。这是自然英语的关键。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 弱读功能词（Z10）',
      text: 'to→/tə/，and→/ən/，of→/əv/，have→/əv/。I could have gone → /kʊdəv/。',
    ),
  ],
  items: const [
    CourseItem(prompt: '弱读 to', answer: 'I want to go now.'),
    CourseItem(prompt: '弱读 and', answer: 'bread and butter, fish and chips'),
    CourseItem(prompt: '弱读 of', answer: 'a lot of people, a cup of tea'),
    CourseItem(prompt: '弱读 have', answer: 'I could have gone, she must have left'),
    CourseItem(prompt: '一整句', answer: 'What do you want to do this evening?'),
  ],
);

final QuizContent zhEnB22ListenWork = zhEnListen(
  id: 'zh_en_b2_2_listen_work',
  title: '听力：A workplace briefing',
  passageTitle: "This week's plan",
  passage:
      "Right, everyone, let me quickly go through this week's plan. The new "
      'project starts on Monday. Sarah will be leading the team, and she has '
      "asked everyone to send their reports by Friday. We've also been told "
      'that the client is visiting next Thursday, so the office must be tidy. '
      'If anyone has questions, please email me. Oh, and don\'t forget: the '
      "meeting on Wednesday has been moved to two o'clock. Thanks, everyone.",
  passageTranslation:
      '好，各位，我快速过一下这周的安排。新项目周一开始。Sarah 将带领团队，她要求大家在周五前'
      '交报告。我们还被告知，客户下周四来访，所以办公室必须整洁。有问题请给我发邮件。哦，别忘了：'
      '周三的会议改到两点。谢谢大家。',
  intro: '先听，再答题。留意被动和转述结构。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '被动 + 转述',
      text: "we've been told（被动）；she has asked everyone to…（转述命令）；has been moved（被动）。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'When does the new project start?',
      options: ['Monday', 'Friday', 'Thursday'],
      correctIndex: 0,
      questionTranslation: '新项目什么时候开始？',
    ),
    ReadingQuestion(
      question: 'Who is leading the team?',
      options: ['Sarah', 'The client', 'The speaker'],
      correctIndex: 0,
      questionTranslation: '谁带领团队？',
    ),
    ReadingQuestion(
      question: "What time is Wednesday's meeting now?",
      options: ["Two o'clock", "Three o'clock", "One o'clock"],
      correctIndex: 0,
      questionTranslation: '周三的会议现在几点？',
    ),
  ],
);

final QuizContent zhEnB22DictNews = zhEnDict(
  id: 'zh_en_b2_2_dict_news',
  title: '听写：A news summary',
  intro: '听句子并打出来。注意转述、被动和推断结构。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 结构要写全（Z29/Z27）',
      text: '写出转述（he said he would…）、被动（has been cancelled）、推断（must have…）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '政府承诺提供帮助。', answer: 'The government has promised to help.'),
    CourseItem(prompt: '他说他会晚点到。', answer: 'He said he would be late.'),
    CourseItem(prompt: '会议被取消了。', answer: 'The meeting has been cancelled.'),
    CourseItem(prompt: '她一定是忘了。', answer: 'She must have forgotten.'),
    CourseItem(prompt: '我叔叔（他住在国外）给我打了电话。', answer: 'My uncle, who lives abroad, called me.'),
  ],
);

final QuizContent zhEnB22Intensifiers = zhEnFill(
  id: 'zh_en_b2_2_intensifiers',
  title: '比较级的程度修饰',
  intro: '用 much/far/a bit/slightly 等来修饰比较级，说明差距的大小。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '差距大 vs 小',
      text: 'much / far / a lot + 比较级（差距大）；a bit / slightly + 比较级（差距小）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这个贵多了。', answer: 'This is **much** more expensive.'),
    CourseItem(prompt: '他跑得快得多。', answer: 'He runs **far** faster.'),
    CourseItem(prompt: '今天稍微暖和一点。', answer: "It's **slightly** warmer today."),
    CourseItem(prompt: '这个好一点点。', answer: "It's a **bit** better."),
    CourseItem(prompt: '她远比我高。', answer: 'She is **far** taller than me.'),
  ],
);

final QuizContent zhEnB22ReadHeadline = zhEnRead(
  id: 'zh_en_b2_2_read_headline',
  title: '阅读：The story behind the headline',
  passageTitle: 'Beyond the headline',
  passage:
      "Newspaper headlines are designed to catch our attention, but they don't "
      'always tell the whole story. Last week, one paper printed the headline: '
      "'Robots to take all our jobs!' The article, which was much calmer than "
      'the headline, actually said that while some jobs will change, many new '
      'jobs will also be created. This is a common problem in the media. A '
      'shocking headline sells more papers, so writers often make things sound '
      'worse than they are. Experts advise readers to look beyond the headline '
      "and read the full story before forming an opinion. As the saying goes, "
      "'Don't judge a book by its cover.'",
  passageTranslation:
      '报纸标题是为了吸引注意，但并不总是讲述事情的全貌。上周，一家报纸打出标题：「机器人将抢走'
      '我们所有的工作！」而那篇文章其实比标题冷静得多，说的是：虽然有些工作会改变，但也会创造出'
      '许多新工作。这是媒体的常见问题。耸动的标题更好卖，所以写手常把事情说得比实际更糟。专家'
      '建议读者别只看标题，先读完整篇再下结论。正如那句话所说：「别以封面评断一本书。」',
  intro: '读一段关于新闻标题的短文。留意非限定从句和习语。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '从句 + 习语（Z32）',
      text: "The article, **which was much calmer**（非限定从句）；'Don't judge a book by its cover'（习语）。",
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the problem with headlines?',
      options: ['They can be misleading', 'They are too long', 'They are boring'],
      correctIndex: 0,
      questionTranslation: '标题有什么问题？',
    ),
    ReadingQuestion(
      question: 'What did the article really say?',
      options: ['New jobs will also be created', 'All jobs are lost', 'Robots are bad'],
      correctIndex: 0,
      questionTranslation: '文章其实说了什么？',
    ),
    ReadingQuestion(
      question: 'What do experts advise?',
      options: ['Read the full story', 'Trust headlines', 'Stop reading news'],
      correctIndex: 0,
      questionTranslation: '专家建议什么？',
    ),
  ],
);

/// B2.2 in chain order.
final List<QuizContent> zhEnB2_2 = [
  zhEnB22Reported,
  zhEnB22ReportedQ,
  zhEnB22ReportingVerbs,
  zhEnB22SpeakReport,
  zhEnB22Deduction,
  zhEnB22DeductionPast,
  zhEnB22ListenNews,
  zhEnB22Nondefining,
  zhEnB22ReadCulture,
  zhEnB22Phrasal,
  zhEnB22Causative,
  zhEnB22SpeakWeak,
  zhEnB22ListenWork,
  zhEnB22DictNews,
  zhEnB22Intensifiers,
  zhEnB22ReadHeadline,
];
