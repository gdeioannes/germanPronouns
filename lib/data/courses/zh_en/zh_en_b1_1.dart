import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';
import 'zh_en_extra_b.dart';

/// B1.1 — Experiences & Connections · 经历与联系. Mandarin → English.
///
/// Big rock: the **present perfect** (vs past simple; for/since/ever/yet). The
/// course's cleverest lever lives here — the **aspect bridge** (Z18): relabel the
/// learner's native 了/过 intuition as the perfect, instead of fighting it. Also
/// articles with abstract/generic nouns (Z11), connective pairs (Z25), stress
/// and schwa (Z8).

final QuizContent zhEnB11PpForm = zhEnFill(
  id: 'zh_en_b1_1_pp_form',
  title: '现在完成时的构成',
  intro: '现在完成时 = have/has + 过去分词（V3），把过去和现在联系起来。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'have/has + V3',
      text: '规则动词的 V3 是 -ed；不规则要背：see→seen，be→been，lose→lost，do→done，write→written。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我看过那部电影。', answer: 'I have **seen** that film.'),
    CourseItem(prompt: '她去过伦敦。', answer: 'She has **been** to London.'),
    CourseItem(prompt: '他们完成了工作。', answer: 'They have **finished** the work.'),
    CourseItem(prompt: '我把钥匙弄丢了。', answer: 'I have **lost** my keys.'),
    CourseItem(prompt: '你吃过午饭了吗？', answer: 'Have you **eaten** lunch?'),
    CourseItem(prompt: '他还没到。', answer: "He hasn't **arrived** yet."),
    CourseItem(prompt: '她写了三封电子邮件。', answer: 'She has **written** three emails.'),
    CourseItem(prompt: '我们做完了所有的练习。', answer: 'We have **done** all the exercises.'),
    CourseItem(prompt: '他弄坏了他的手机。', answer: 'He has **broken** his phone.'),
    CourseItem(prompt: '我读过这本书。', answer: 'I have **read** this book.'),
    CourseItem(prompt: '她把钱花光了。（spend→spent）', answer: 'She has **spent** all her money.'),
    CourseItem(prompt: '我们买了一套新房子。（buy→bought）', answer: 'We have **bought** a new house.'),
    CourseItem(prompt: '他把咖啡喝完了。（drink→drunk）', answer: 'He has **drunk** all the coffee.'),
    CourseItem(prompt: '她给我们做了晚饭。（make→made）', answer: 'She has **made** dinner for us.'),
    CourseItem(prompt: '你把窗户关上了吗？（close 规则）', answer: 'Have you **closed** the window?'),
  ],
);

final QuizContent zhEnB11PpVsPast = zhEnFill(
  id: 'zh_en_b1_1_pp_vs_past',
  title: '现在完成时 vs 一般过去时',
  intro: '这是中国学习者的一个难点。诀窍：用你熟悉的「了／过」来分辨。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 用「过／了」分辨（Z18）',
      text: '讲经历、无具体时间 → 现在完成（≈「过」：I have **been** to Japan）；'
          '有具体过去时间 → 过去式（I **went** last year）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我去年去了日本。', answer: 'I **went** to Japan last year.'),
    CourseItem(prompt: '我去过日本。', answer: 'I have **been** to Japan.'),
    CourseItem(prompt: '她昨天见到他了。', answer: 'She **saw** him yesterday.'),
    CourseItem(prompt: '她这周见过他了。', answer: 'She has **seen** him this week.'),
    CourseItem(prompt: '你做完作业了吗？', answer: 'Have you **finished** your homework?'),
    CourseItem(prompt: '你几点做完的？', answer: 'What time **did** you finish?'),
    CourseItem(prompt: '我吃过北京烤鸭。（经历）', answer: 'I have **tried** Peking duck.'),
    CourseItem(prompt: '我们上个月搬了家。（具体时间）', answer: 'We **moved** house last month.'),
    CourseItem(prompt: '他把钱包丢了（现在还没找到）。', answer: 'He has **lost** his wallet.'),
    CourseItem(prompt: '她 2018 年大学毕业。', answer: 'She **graduated** in 2018.'),
    CourseItem(prompt: '我这辈子从没见过雪。（经历）', answer: 'I have never **seen** snow in my life.'),
    CourseItem(prompt: '我们昨晚看了一场比赛。（具体时间）', answer: 'We **watched** a match last night.'),
    CourseItem(prompt: '他今天早上已经喝了三杯咖啡。（今天还没结束）', answer: 'He has **had** three coffees this morning.'),
    CourseItem(prompt: '她两小时前离开了办公室。（具体时间）', answer: 'She **left** the office two hours ago.'),
    CourseItem(prompt: '你试过在线课程吗？（经历）', answer: 'Have you ever **tried** online classes?'),
  ],
);

final QuizContent zhEnB11ForSince = zhEnFill(
  id: 'zh_en_b1_1_for_since',
  title: 'for / since',
  intro: '现在完成时常和 for、since 连用，表示持续到现在的时间。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'for + 时间段，since + 时间点',
      text: 'for three years（一段时间）；since 2020 / since Monday（一个起点）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我学英语三年了。', answer: 'I have studied English **for** three years.'),
    CourseItem(prompt: '她从 2020 年就住在这里。', answer: 'She has lived here **since** 2020.'),
    CourseItem(prompt: '我们认识很久了。', answer: 'We have known each other **for** a long time.'),
    CourseItem(prompt: '他从早上就在工作。', answer: 'He has worked **since** this morning.'),
    CourseItem(prompt: '我两周没见他了。', answer: "I haven't seen him **for** two weeks."),
    CourseItem(prompt: '他们结婚十年了。', answer: 'They have been married **for** ten years.'),
    CourseItem(prompt: '她从周一起就生病了。', answer: 'She has been ill **since** Monday.'),
    CourseItem(prompt: '我们从上次会议后就没说过话。', answer: "We haven't spoken **since** the last meeting."),
    CourseItem(prompt: '他在这家公司工作六个月了。', answer: 'He has worked at this company **for** six months.'),
    CourseItem(prompt: '从孩提时代起我就喜欢音乐。', answer: 'I have loved music **since** I was a child.'),
    CourseItem(prompt: '他们从上周五就没上班。', answer: "They haven't worked **since** last Friday."),
    CourseItem(prompt: '我等了半个小时了。', answer: 'I have waited **for** half an hour.'),
    CourseItem(prompt: '她从搬来后就喜欢上了这座城市。', answer: 'She has loved this city **since** she moved here.'),
    CourseItem(prompt: '我们好几年没回老家了。', answer: "We haven't been home **for** years."),
    CourseItem(prompt: '他从毕业起就在这里工作。', answer: 'He has worked here **since** he graduated.'),
  ],
);

final QuizContent zhEnB11Adverbs = zhEnFill(
  id: 'zh_en_b1_1_adverbs',
  title: 'ever / never / already / yet / just',
  intro: '这些副词常和现在完成时一起用，表示经历或完成情况。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '各自的意思与位置',
      text: 'ever（曾经，疑问）、never（从未）、already（已经）放动词前；yet（还）放句尾（否定/疑问）；just（刚刚）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '你去过国外吗？', answer: 'Have you **ever** been abroad?'),
    CourseItem(prompt: '我从没吃过寿司。', answer: 'I have **never** eaten sushi.'),
    CourseItem(prompt: '我已经吃过了。', answer: 'I have **already** eaten.'),
    CourseItem(prompt: '你做完了吗？', answer: 'Have you finished **yet**?'),
    CourseItem(prompt: '他刚走。', answer: 'He has **just** left.'),
    CourseItem(prompt: '你曾经见过熊猫吗？', answer: 'Have you **ever** seen a panda?'),
    CourseItem(prompt: '她还没回复我。', answer: "She hasn't replied **yet**."),
    CourseItem(prompt: '我们刚吃完晚饭。', answer: 'We have **just** finished dinner.'),
    CourseItem(prompt: '他从没开过车。', answer: 'He has **never** driven a car.'),
    CourseItem(prompt: '火车已经离开了。', answer: 'The train has **already** left.'),
    CourseItem(prompt: '我刚收到你的消息。', answer: 'I have **just** got your message.'),
    CourseItem(prompt: '你曾经在国外工作过吗？', answer: 'Have you **ever** worked abroad?'),
    CourseItem(prompt: '她还没决定。', answer: "She hasn't decided **yet**."),
    CourseItem(prompt: '我们已经订好票了。', answer: 'We have **already** booked the tickets.'),
    CourseItem(prompt: '他从没迟到过。', answer: 'He has **never** been late.'),
  ],
);

final QuizContent zhEnB11SpeakEver = zhEnSpeak(
  id: 'zh_en_b1_1_speak_ever',
  title: '开口说：Have you ever…?',
  intro: '用现在完成时谈论经历。听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '缩写',
      text: "I have → I've，you have → you've，has not → hasn't。口语里常缩写。",
    ),
  ],
  items: const [
    CourseItem(prompt: '你去过英国吗？', answer: 'Have you ever been to the UK?'),
    CourseItem(prompt: '我从没坐过飞机。', answer: "I've never flown on a plane."),
    CourseItem(prompt: '我尝过英国菜。', answer: "I've tried British food."),
    CourseItem(prompt: '你看过这部电影吗？', answer: 'Have you seen this film?'),
    CourseItem(prompt: '我已经读过那本书了。', answer: "I've already read that book."),
  ],
);

final QuizContent zhEnB11ListenChange = zhEnListen(
  id: 'zh_en_b1_1_listen_change',
  title: '听力：How life has changed',
  passageTitle: "My grandmother's world",
  passage:
      'My grandmother often tells me how life has changed. When she was young, '
      'there were no mobile phones and no internet. People wrote letters and '
      'waited weeks for a reply. She has seen many changes in her life. Now she '
      'uses a smartphone to talk to her family in other cities. "Life is faster '
      'now," she says, "but I still miss the old days."',
  passageTranslation:
      '我奶奶常跟我说生活变了多少。她年轻时没有手机，也没有互联网。人们写信，要等上几周才有回信。'
      '她这一生见证了许多变化。现在她用智能手机和别的城市的家人通话。她说：「现在生活节奏快了，'
      '但我还是怀念过去的日子。」',
  intro: '先听，再答题。留意现在完成时（has changed, has seen）。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '完成时讲变化',
      text: 'life has changed、she has seen——现在完成时把过去的变化和现在连起来。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: "What didn't exist when the grandmother was young?",
      options: ['Cars', 'Mobile phones and the internet', 'Books'],
      correctIndex: 1,
      questionTranslation: '奶奶年轻时没有什么？',
    ),
    ReadingQuestion(
      question: 'How did people communicate then?',
      options: ['By letter', 'By phone', 'By email'],
      correctIndex: 0,
      questionTranslation: '那时人们怎么联系？',
    ),
    ReadingQuestion(
      question: 'How does she feel about the past?',
      options: ['She misses it', 'She hates it', "She doesn't care"],
      correctIndex: 0,
      questionTranslation: '她对过去有什么感受？',
    ),
  ],
);

final QuizContent zhEnB11BeenGone = zhEnFill(
  id: 'zh_en_b1_1_been_gone',
  title: 'been vs gone',
  intro: 'have been to（去过，已回来）和 have gone to（去了，还没回来）意思不同。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'been = 回来了，gone = 还在那',
      text: 'She has **been** to Paris（去过，现在在这）；She has **gone** to Paris（去了，还在那/在路上）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '她去过巴黎（现在回来了）。', answer: 'She has **been** to Paris.'),
    CourseItem(prompt: '他去巴黎了（还没回来）。', answer: 'He has **gone** to Paris.'),
    CourseItem(prompt: '我去过那家新餐厅了。', answer: 'I have **been** to the new restaurant.'),
    CourseItem(prompt: '老板出去了（不在）。', answer: 'The boss has **gone** out.'),
    CourseItem(prompt: '你去过中国吗？', answer: 'Have you **been** to China?'),
    CourseItem(prompt: '他们去度假了（人还没回来）。', answer: 'They have **gone** on holiday.'),
    CourseItem(prompt: '我去过那个博物馆两次。', answer: 'I have **been** to that museum twice.'),
    CourseItem(prompt: '她去银行了（还没回来）。', answer: 'She has **gone** to the bank.'),
    CourseItem(prompt: '我们去过伦敦很多次。', answer: 'We have **been** to London many times.'),
    CourseItem(prompt: '孩子们上学去了（还在学校）。', answer: 'The children have **gone** to school.'),
    CourseItem(prompt: '你去过长城吗？', answer: 'Have you **been** to the Great Wall?'),
    CourseItem(prompt: '她去超市了（还没回来）。', answer: 'She has **gone** to the supermarket.'),
    CourseItem(prompt: '我们去过那个海滩一次。', answer: 'We have **been** to that beach once.'),
    CourseItem(prompt: '经理出差去了（人还在外地）。', answer: 'The manager has **gone** on a business trip.'),
    CourseItem(prompt: '我去过医院看他（现在回来了）。', answer: 'I have **been** to the hospital to see him.'),
  ],
);

final QuizContent zhEnB11UsedTo = zhEnFill(
  id: 'zh_en_b1_1_used_to',
  title: 'used to（过去的习惯）',
  intro: 'used to + 原形，表示过去常做但现在不再做的事。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'used to + 原形',
      text: '肯定：I **used to** live…；疑问/否定用 use to：Did you **use to**…? / I didn\'t use to…。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我小时候住在乡下。', answer: 'I **used** to live in the countryside.'),
    CourseItem(prompt: '她以前抽烟。', answer: 'She **used** to smoke.'),
    CourseItem(prompt: '我们以前经常见面。', answer: 'We **used** to meet often.'),
    CourseItem(prompt: '你以前喜欢足球吗？', answer: 'Did you **use** to like football?'),
    CourseItem(prompt: '这里以前有一家商店。', answer: 'There **used** to be a shop here.'),
    CourseItem(prompt: '他以前每天跑步。', answer: 'He **used** to run every day.'),
    CourseItem(prompt: '我以前不喜欢咖啡。', answer: "I didn't **use** to like coffee."),
    CourseItem(prompt: '她以前留长发。', answer: 'She **used** to have long hair.'),
    CourseItem(prompt: '我们以前住在一个小城市。', answer: 'We **used** to live in a small city.'),
    CourseItem(prompt: '你以前玩电子游戏吗？', answer: 'Did you **use** to play video games?'),
    CourseItem(prompt: '我以前很怕狗。', answer: 'I **used** to be afraid of dogs.'),
    CourseItem(prompt: '这座城市以前安静得多。', answer: 'This city **used** to be much quieter.'),
    CourseItem(prompt: '他以前不吃蔬菜。', answer: "He didn't **use** to eat vegetables."),
    CourseItem(prompt: '我们以前每年夏天去海边。', answer: 'We **used** to go to the seaside every summer.'),
    CourseItem(prompt: '你以前住在哪里？', answer: 'Where did you **use** to live?'),
  ],
);

final QuizContent zhEnB11ReadWork = zhEnRead(
  id: 'zh_en_b1_1_read_work',
  title: '阅读：The future of work',
  passageTitle: 'How work is changing',
  passage:
      'The way we work has changed a lot in recent years. In the past, most '
      'people worked in an office from nine to five. Now, many people work from '
      'home, using computers and video calls. This has given workers more '
      'freedom, but it has also created new problems. Some people feel lonely, '
      'and it is harder to separate work and home life. Experts say that in the '
      'future, more jobs will be done by machines. People will need new skills '
      'to stay useful. Learning, they say, will never stop.',
  passageTranslation:
      '近年来我们的工作方式发生了很大变化。过去大多数人朝九晚五在办公室上班。如今，许多人'
      '在家办公，用电脑和视频通话。这给了员工更多自由，但也带来了新问题。有些人感到孤独，'
      '而且更难把工作和家庭生活分开。专家说，将来更多工作会由机器完成，人们需要新技能才能'
      '保持有用。他们说，学习永远不会停止。',
  intro: '读一段关于工作变化的短文。留意现在完成时和被动语态的雏形。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '完成时讲近期变化',
      text: 'has changed, has given, has created——现在完成时描述最近发生、影响至今的变化。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How has work changed?',
      options: ['More people work from home', 'Everyone works in offices', 'No one works'],
      correctIndex: 0,
      questionTranslation: '工作方式有什么变化？',
    ),
    ReadingQuestion(
      question: 'What is a problem of working from home?',
      options: ['Loneliness', 'More money', 'Shorter hours'],
      correctIndex: 0,
      questionTranslation: '在家办公有什么问题？',
    ),
    ReadingQuestion(
      question: 'What will people need in the future?',
      options: ['New skills', 'Bigger offices', 'Less learning'],
      correctIndex: 0,
      questionTranslation: '将来人们需要什么？',
    ),
  ],
);

final QuizContent zhEnB11ArticlesDeep = zhEnFill(
  id: 'zh_en_b1_1_articles_deep',
  title: '冠词进阶：抽象与泛指',
  intro: '抽象名词、泛指的复数、语言和学科通常不加冠词——这和「the + 独一无二」形成对比。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 抽象名词不加冠词（Z11）',
      text: '泛指用零冠词：**Life** is…、**Dogs** are…、I study **English**；独一无二/乐器用 the：the sun、the piano。',
    ),
  ],
  items: const [
    CourseItem(prompt: '生活并不总是容易。', answer: '**Life** is not always easy.'),
    CourseItem(prompt: '狗是忠诚的动物。', answer: '**Dogs** are loyal animals.'),
    CourseItem(prompt: '爱很重要。', answer: '**Love** is important.'),
    CourseItem(prompt: '太阳给我们光。', answer: 'The **sun** gives us light.'),
    CourseItem(prompt: '他会弹钢琴。', answer: 'He plays the **piano**.'),
    CourseItem(prompt: '我周日不上班。', answer: "I don't work on **Sundays**."),
    CourseItem(prompt: '时间就是金钱。', answer: '**Time** is money.'),
    CourseItem(prompt: '猫喜欢睡觉。（泛指）', answer: '**Cats** like sleeping.'),
    CourseItem(prompt: '她在大学学习历史。', answer: 'She studies **history** at university.'),
    CourseItem(prompt: '月亮绕着地球转。', answer: 'The **moon** goes around the earth.'),
    CourseItem(prompt: '钱买不来幸福。（两个抽象名词都零冠词）', answer: '**Money** cannot buy happiness.'),
    CourseItem(prompt: '她在学法语。（语言零冠词）', answer: 'She is learning **French**.'),
    CourseItem(prompt: '早餐我喝咖啡。（餐名零冠词）', answer: 'I drink coffee at **breakfast**.'),
    CourseItem(prompt: '音乐让人快乐。（泛指）', answer: '**Music** makes people happy.'),
    CourseItem(prompt: '他会拉小提琴。（乐器用 the）', answer: 'He plays the **violin**.'),
  ],
);

final QuizContent zhEnB11Pairs = zhEnFill(
  id: 'zh_en_b1_1_pairs',
  title: '连词对：although / but，because / so',
  intro: '英语一个句子里这些连词只能用一个，而中文习惯成对使用。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 一句一座桥（Z25）',
      text: '「虽然…但是…」在英语里只留一个：**Although** it rained, I went（不要再加 but）。「因为…所以…」同理。',
    ),
  ],
  items: const [
    CourseItem(prompt: '虽然下雨了，我还是去了。', answer: '**Although** it rained, I went.'),
    CourseItem(prompt: '因为我累了，所以早睡了。', answer: '**Because** I was tired, I went to bed.'),
    CourseItem(prompt: '他很有钱，但不快乐。', answer: 'He is rich, **but** he is not happy.'),
    CourseItem(prompt: '尽管很难，她没放弃。', answer: "**Although** it was hard, she didn't give up."),
    CourseItem(prompt: '天气很冷，所以我们待在家里。', answer: 'It was cold, **so** we stayed at home.'),
    CourseItem(prompt: '虽然他很年轻，但他很有经验。', answer: '**Although** he is young, he has a lot of experience.'),
    CourseItem(prompt: '因为票卖完了，所以我们没去。', answer: "**Because** the tickets were sold out, we didn't go."),
    CourseItem(prompt: '我喜欢这份工作，但工资很低。', answer: 'I like the job, **but** the pay is low.'),
    CourseItem(prompt: '虽然很贵，我还是买了。', answer: '**Although** it was expensive, I bought it.'),
    CourseItem(prompt: '他病了，所以待在床上。', answer: 'He was ill, **so** he stayed in bed.'),
    CourseItem(prompt: '虽然她很忙，她还是来了。', answer: '**Although** she was busy, she came.'),
    CourseItem(prompt: '因为下雪，学校关门了。', answer: '**Because** it snowed, the school closed.'),
    CourseItem(prompt: '这家酒店很旧，但很干净。', answer: 'The hotel is old, **but** it is clean.'),
    CourseItem(prompt: '虽然他学了很多年英语，他还是不敢开口。', answer: '**Although** he has studied English for years, he is afraid to speak.'),
    CourseItem(prompt: '我把钥匙忘在家里了，所以进不了门。', answer: "I left my keys at home, **so** I couldn't get in."),
  ],
);

final QuizContent zhEnB11SpeakStress = zhEnSpeak(
  id: 'zh_en_b1_1_speak_stress',
  title: '发音：词重音与弱读',
  intro: '英语是重音节奏语言：一个词只有一个重读音节，其余弱读成 /ə/。这和音节等长的中文很不同。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 一个重读 + 懒音（Z8）',
      text: '重音会移动：PHOtograph → phoTOGrapher。非重读音节弱读成 /ə/（about, banana）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '重音移动', answer: 'PHOtograph, phoTOGrapher, photoGRAPHic'),
    CourseItem(prompt: '弱读 /ə/', answer: 'about, banana, computer, teacher'),
    CourseItem(prompt: '名词/动词重音', answer: 'a REcord – to reCORD, a PREsent – to preSENT'),
    CourseItem(prompt: '弱读功能词', answer: 'a cup of tea, fish and chips'),
    CourseItem(prompt: '一整句', answer: 'I would like a cup of coffee, please.'),
  ],
);

final QuizContent zhEnB11SoSuch = zhEnFill(
  id: 'zh_en_b1_1_so_such',
  title: 'so / such / too / enough',
  intro: '这些词用来加强或说明程度，但搭配不同。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '搭配',
      text: 'so + 形容词；such + (a) + 名词；too + 形容词（过分，含否定意味）；形容词 + enough（足够）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '天气太热了，没法出门。', answer: 'It was **too** hot to go out.'),
    CourseItem(prompt: '今天太冷了。', answer: 'It is **so** cold today.'),
    CourseItem(prompt: '这是个很好的主意。', answer: "It's **such** a good idea."),
    CourseItem(prompt: '我不够高，够不到。', answer: "I'm not tall **enough**."),
    CourseItem(prompt: '这咖啡太烫，没法喝。', answer: 'The coffee is **too** hot to drink.'),
    CourseItem(prompt: '他跑得太慢，赶不上公交车。', answer: 'He ran **too** slowly to catch the bus.'),
    CourseItem(prompt: '她是一个如此善良的人。', answer: 'She is **such** a kind person.'),
    CourseItem(prompt: '这个考试够简单。', answer: 'The exam was easy **enough**.'),
    CourseItem(prompt: '电影太好看了，我们看了两遍。', answer: 'The film was **so** good that we watched it twice.'),
    CourseItem(prompt: '我们没有足够的时间。', answer: "We don't have **enough** time."),
    CourseItem(prompt: '这个箱子太重，我搬不动。', answer: 'The box is **too** heavy for me to carry.'),
    CourseItem(prompt: '那是一部如此无聊的电影。', answer: 'It was **such** a boring film.'),
    CourseItem(prompt: '他年纪够大，可以自己决定。', answer: 'He is old **enough** to decide for himself.'),
    CourseItem(prompt: '她说得太快，我听不懂。', answer: 'She speaks **so** fast that I cannot understand her.'),
    CourseItem(prompt: '他们是如此好的邻居。（复数名词，such 不加 a）', answer: 'They are **such** good neighbours.'),
  ],
);

final QuizContent zhEnB11ListenPodcast = zhEnListen(
  id: 'zh_en_b1_1_listen_podcast',
  title: '听力：A podcast on technology',
  passageTitle: 'Tech Talk',
  passage:
      "Welcome to Tech Talk. Today we're discussing how smartphones have "
      'changed our lives. Twenty years ago, phones were only for calls. Now, we '
      'use them for everything: shopping, banking, learning, and staying in '
      'touch with friends. But experts warn that we spend too much time looking '
      'at screens. Some studies show that people check their phones over a '
      'hundred times a day. So, our tip this week: try to put your phone away '
      'for one hour every evening.',
  passageTranslation:
      '欢迎收听《Tech Talk》。今天我们聊聊智能手机如何改变了我们的生活。二十年前，手机只能'
      '用来打电话。如今，我们用它做一切：购物、银行、学习、和朋友保持联系。但专家警告，我们'
      '花太多时间盯着屏幕。有研究显示，人们一天查看手机超过一百次。所以，本周的建议是：'
      '每天晚上试着把手机放开一个小时。',
  intro: '先听，再答题。这段语速较自然，注意连读。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '完成时 + 连读',
      text: 'smartphones have changed；注意 a lot of、too much 的连读弱读。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is the podcast about?',
      options: ['How smartphones have changed our lives', 'New phones', 'Phone prices'],
      correctIndex: 0,
      questionTranslation: '这期播客讲什么？',
    ),
    ReadingQuestion(
      question: 'What do experts warn about?',
      options: ['Too much screen time', 'Expensive phones', 'Slow internet'],
      correctIndex: 0,
      questionTranslation: '专家警告什么？',
    ),
    ReadingQuestion(
      question: 'What is the tip?',
      options: ['Put your phone away for an hour', 'Buy a new phone', 'Never use phones'],
      correctIndex: 0,
      questionTranslation: '给出的建议是什么？',
    ),
  ],
);

final QuizContent zhEnB11DictYear = zhEnDict(
  id: 'zh_en_b1_1_dict_year',
  title: '听写：What I\'ve done this year',
  intro: '听句子并打出来。重点是 have/has + 过去分词，以及 for/since/yet。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 写出完成时（Z18）',
      text: '注意 have/has + V3，缩写 I\'ve / hasn\'t，以及 yet 放句尾。英式拼写 learnt。',
    ),
  ],
  items: const [
    CourseItem(prompt: '今年我学到了很多。', answer: "I've learnt a lot this year."),
    CourseItem(prompt: '她去过三个国家。', answer: 'She has visited three countries.'),
    CourseItem(prompt: '他们还没做完。', answer: "They haven't finished yet."),
    CourseItem(prompt: '我从 2019 年就认识他。', answer: "I've known him since 2019."),
    CourseItem(prompt: '他刚到。', answer: 'He has just arrived.'),
    CourseItem(prompt: '我们从没去过日本。', answer: "We've never been to Japan."),
    CourseItem(prompt: '你吃过午饭了吗？', answer: 'Have you had lunch yet?'),
    CourseItem(prompt: '她已经找到了新工作。', answer: 'She has already found a new job.'),
    CourseItem(prompt: '我在这里住了五年了。', answer: 'I have lived here for five years.'),
    CourseItem(prompt: '他以前住在乡下。', answer: 'He used to live in the countryside.'),
    CourseItem(prompt: '我们刚搬进新家。', answer: 'We have just moved into our new home.'),
    CourseItem(prompt: '你去过上海吗？', answer: 'Have you ever been to Shanghai?'),
    CourseItem(prompt: '她学英语学了十年了。', answer: 'She has studied English for ten years.'),
    CourseItem(prompt: '他已经把书还了。', answer: 'He has already returned the book.'),
    CourseItem(prompt: '我从没吃过这么好吃的菜。', answer: 'I have never eaten such delicious food.'),
  ],
);

final QuizContent zhEnB11ReadStudy = zhEnRead(
  id: 'zh_en_b1_1_read_study',
  title: '阅读：Studying abroad',
  passageTitle: 'Studying abroad',
  passage:
      'More and more Chinese students have chosen to study abroad in recent '
      'years. Studying in another country has many benefits. Students improve '
      'their language skills and learn about different cultures. They also '
      'become more independent. However, life abroad is not always easy. Many '
      'students feel homesick at first, and everyday tasks like cooking and '
      'shopping can be difficult in a new language. Experts advise students to '
      'join clubs and make local friends. "The first months are the hardest," '
      'one student said, "but it has been the best experience of my life."',
  passageTranslation:
      '近年来，越来越多的中国学生选择出国留学。在异国学习有许多好处：学生能提高语言能力、'
      '了解不同文化，也会变得更独立。然而，海外生活并不总是轻松。许多学生起初会想家，'
      '做饭、购物这些日常小事在陌生语言里也会变难。专家建议学生参加社团、结交当地朋友。'
      '一位学生说：「最初几个月最难，但这是我人生中最棒的经历。」',
  intro: '读一段关于留学的短文。留意现在完成时与 however 的转折。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '完成时 + 转折',
      text: 'have chosen、has been；however 引出转折（相当于 but，但更正式）。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What is a benefit of studying abroad?',
      options: ['Better language skills', 'More money', 'An easier life'],
      correctIndex: 0,
      questionTranslation: '留学有什么好处？',
    ),
    ReadingQuestion(
      question: 'What is a difficulty?',
      options: ['Homesickness', 'Too many friends', 'Cheap food'],
      correctIndex: 0,
      questionTranslation: '有什么困难？',
    ),
    ReadingQuestion(
      question: 'What do experts advise?',
      options: ['Join clubs and make friends', 'Stay at home', 'Study alone'],
      correctIndex: 0,
      questionTranslation: '专家建议什么？',
    ),
  ],
);

/// B1.1 in chain order.
final List<QuizContent> zhEnB1_1 = [
  zhEnB11PpForm,
  zhEnB11PpVsPast,
  zhEnB11ForSince,
  zhEnB11Adverbs,
  zhEnB11SpeakEver,
  zhEnB11ListenChange,
  zhEnB11BeenGone,
  zhEnB11UsedTo,
  zhEnB11SpeakingMid,
  zhEnB11ReadWork,
  zhEnB11ArticlesDeep,
  zhEnB11Pairs,
  zhEnB11SpeakStress,
  zhEnB11SoSuch,
  zhEnB11ListenPodcast,
  zhEnB11DictYear,
  zhEnB11ReadStudy,
  zhEnB11BigText,
  zhEnB11SpeakingClose,
];
