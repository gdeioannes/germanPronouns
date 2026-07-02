import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// B2.1 — Handling & Being Handled · 处置与被动 (HSK 4a). English → Mandarin.
///
/// Big rocks: the 把 disposal construction (Z22 — grab it, then act), 被 and
/// the notional passive (Z23), causative 让/叫, the full comparison kit (Z24),
/// and abstract directional complements (Z21). From this module the reading/
/// listening info button is English-only — the pinyin scaffold is retired.

final QuizContent enZhB21Ba1 = enZhFill(
  id: 'en_zh_b2_1_ba_1',
  title: '把 — grab it, then act',
  intro:
      'To say what you DID to something, grab it first: 我把门关上了 — I took '
      'the door and shut it. 把 + object + verb + landing.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Grab it, then do it (Z22)',
      text: 'S + 把 + object + verb + RESULT. The verb can\'t stand bare: '
          '把门关 ✗ — it needs a landing (关上, 吃完, 放在…). 把 fronts the '
          'object so the action\'s effect takes the spotlight.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'When to reach for 把',
      text: 'Known, specific object + what happened to it → 把. Telling '
          'someone what to do with things (put, move, finish, close) '
          'practically demands it.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I shut the door. (grab door, shut-up)', answer: '我**把**门关上了。', accepted: ['bǎ'], hint: 'wǒ bǎ mén guān shàng le'),
    CourseItem(prompt: 'He finished (eating) the noodles.', answer: '他**把**面条吃完了。', accepted: ['bǎ'], hint: 'tā bǎ miàntiáo chī wán le'),
    CourseItem(prompt: 'Please open the window. (grab window, open)', answer: '请**把**窗户打开。', accepted: ['bǎ'], hint: 'qǐng bǎ chuānghu dǎkāi'),
    CourseItem(prompt: 'I finished writing the homework.', answer: '我**把**作业写完了。', accepted: ['bǎ'], hint: 'wǒ bǎ zuòyè xiě wán le'),
    CourseItem(prompt: 'She drank up the tea.', answer: '她**把**茶喝完了。', accepted: ['bǎ'], hint: 'tā bǎ chá hē wán le'),
    CourseItem(prompt: 'Don\'t forget my book! (forget-drop: 忘了)', answer: '别**把**我的书忘了！', accepted: ['bǎ'], hint: 'bié bǎ wǒ de shū wàng le'),
  ],
);

final QuizContent enZhB21Ba2 = enZhFill(
  id: 'en_zh_b2_1_ba_2',
  title: '把 + where it lands: 在 / 到 / 给',
  intro:
      'The landing after a 把-verb often tells WHERE or TO WHOM: 放在桌子上 '
      'put ON the table, 送到机场 deliver TO the airport, 交给老师 hand TO '
      'the teacher.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'V + 在/到/给 + place/person (Z22)',
      text: '把 X 放**在** place / 送**到** destination / 交**给** person. '
          'These three endings cover most of what you ever do with objects.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Put the book on the table. (lands ON)', answer: '把书放**在**桌子上。', accepted: ['zài'], hint: 'bǎ shū fàng zài zhuōzi shàng'),
    CourseItem(prompt: 'He drove me to the airport. (lands AT)', answer: '他把我送**到**了机场。', accepted: ['dào'], hint: 'tā bǎ wǒ sòng dào le jīchǎng'),
    CourseItem(prompt: 'Hand the homework to the teacher. (lands WITH person)', answer: '把作业交**给**老师。', accepted: ['gěi'], hint: 'bǎ zuòyè jiāo gěi lǎoshī'),
    CourseItem(prompt: 'Please put the phone in the bag.', answer: '请把手机放**在**包里。', accepted: ['zài'], hint: 'qǐng bǎ shǒujī fàng zài bāo li'),
    CourseItem(prompt: 'I sent the photo to my mum. (发 = send)', answer: '我把照片发**给**了妈妈。', accepted: ['gěi'], hint: 'wǒ bǎ zhàopiàn fā gěi le māma'),
    CourseItem(prompt: 'Translate this sentence into English. (翻译成 = translate-into)', answer: '把这个句子翻译**成**英文。', accepted: ['chéng'], hint: 'bǎ zhè ge jùzi fānyì chéng Yīngwén'),
  ],
);

final QuizContent enZhB21SpeakBa = enZhSpeak(
  id: 'en_zh_b2_1_speak_ba',
  title: 'Speaking: instructions with 把',
  intro:
      'Give instructions aloud — moving-day orders are pure 把 territory: '
      'grab the thing, say where it goes.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Rhythm: 把-X | V-landing',
      text: 'Chunk each order in two: 把桌子 | 搬到客厅. The pause after the '
          'object keeps long instructions clear (Z22).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Bǎ zhuōzi bān dào kètīng. — Move the table into the living room.', answer: '把桌子搬到客厅。'),
    CourseItem(prompt: 'Qǐng bǎ mén guān shàng. — Please shut the door.', answer: '请把门关上。'),
    CourseItem(prompt: 'Bǎ yīfu fàng zài chuáng shàng ba. — Put the clothes on the bed.', answer: '把衣服放在床上吧。'),
    CourseItem(prompt: 'Bié bǎ yàoshi wàng zài jiā li! — Don\'t leave the keys at home!', answer: '别把钥匙忘在家里！'),
    CourseItem(prompt: 'Bǎ zhè bēi chá ná gěi nǎinai. — Take this cup of tea to grandma.', answer: '把这杯茶拿给奶奶。'),
    CourseItem(prompt: 'Bǎ nǐ de xíngli fàng zài zhèr. — Put your luggage here.', answer: '把你的行李放在这儿。'),
  ],
);

final QuizContent enZhB21Bei = enZhFill(
  id: 'en_zh_b2_1_bei',
  title: '被 — when things happen TO you',
  intro:
      '被 flips the sentence: 蛋糕被弟弟吃了 — the cake got eaten by little '
      'brother. Classic 被 carries a whiff of misfortune.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Victim + 被 + (culprit) + verb + landing (Z23)',
      text: '我的自行车被(人)偷了 — my bike got stolen. The culprit is '
          'optional; the landing (了, 走, 完…) is not.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Don\'t translate every English passive with 被',
      text: '"The problem was solved" is NOT 被: say 问题解决了 (next '
          'quiz). 被 fits mishaps and formal reports — overusing it is '
          'textbook foreign accent.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The cake was eaten by my little brother.', answer: '蛋糕**被**弟弟吃了。', accepted: ['bèi'], hint: 'dàngāo bèi dìdi chī le'),
    CourseItem(prompt: 'My bike was stolen.', answer: '我的自行车**被**偷了。', accepted: ['bèi'], hint: 'wǒ de zìxíngchē bèi tōu le'),
    CourseItem(prompt: 'My phone was taken away by the teacher.', answer: '我的手机**被**老师拿走了。', accepted: ['bèi'], hint: 'wǒ de shǒujī bèi lǎoshī ná zǒu le'),
    CourseItem(prompt: 'The window was broken by the wind. (打破 = break)', answer: '窗户**被**风打破了。', accepted: ['bèi'], hint: 'chuānghu bèi fēng dǎ pò le'),
    CourseItem(prompt: 'He was criticized by the boss. (批评 = criticize)', answer: '他**被**老板批评了。', accepted: ['bèi'], hint: 'tā bèi lǎobǎn pīpíng le'),
    CourseItem(prompt: 'The last piece of duck got eaten by Tom.', answer: '最后一块烤鸭**被**汤姆吃了。', accepted: ['bèi'], hint: 'zuìhòu yí kuài kǎoyā bèi Tāngmǔ chī le'),
  ],
);

final QuizContent enZhB21Notional = enZhFill(
  id: 'en_zh_b2_1_notional',
  title: 'The notional passive: 问题解决了',
  intro:
      'Chinese\'s favourite passive has no marker at all: topic first, verb '
      'after — 问题解决了 the problem (got) solved, 饭做好了 dinner\'s ready.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Topic + verb, no 被 (Z23/Z28)',
      text: 'When no culprit matters and nothing bad happened, drop the '
          'passive machinery: 票买好了 tickets are bought, 信写完了 the '
          'letter\'s written. This is the natural voice of Chinese.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The problem is solved. (no 被!)', answer: '问题**解决**了。', accepted: ['jiějué'], hint: 'wèntí jiějué le'),
    CourseItem(prompt: 'Dinner is ready. (made-good)', answer: '饭**做好**了。', accepted: ['zuò hǎo'], hint: 'fàn zuò hǎo le'),
    CourseItem(prompt: 'The tickets are bought.', answer: '票**买好**了。', accepted: ['mǎi hǎo'], hint: 'piào mǎi hǎo le'),
    CourseItem(prompt: 'The letter is written. (write-finish)', answer: '信**写完**了。', accepted: ['xiě wán'], hint: 'xìn xiě wán le'),
    CourseItem(prompt: 'The clothes are washed. (wash-clean: 洗干净)', answer: '衣服**洗干净**了。', accepted: ['xǐ gānjìng'], hint: 'yīfu xǐ gānjìng le'),
    CourseItem(prompt: 'This book sold out. (sell-finish)', answer: '这本书**卖完**了。', accepted: ['mài wán'], hint: 'zhè běn shū mài wán le'),
  ],
);

final QuizContent enZhB21ListenCake = enZhListen(
  id: 'en_zh_b2_1_listen_cake',
  title: 'Listening: 谁把蛋糕吃了?',
  passageTitle: '蛋糕不见了',
  passage:
      '晚上，小美回到家，打开冰箱，发现她的生日蛋糕不见了。\n'
      '小美："谁把我的蛋糕吃了？！"\n'
      '弟弟："不是我！我下午一直在踢足球。"\n'
      '爸爸："我也没吃。你去问问你妈妈。"\n'
      '妈妈笑了："蛋糕没被人吃，我把它放到楼上了，'
      '因为今天晚上我们要给你一个惊喜。生日快乐！"',
  passageTranslation:
      'In the evening, Xiaomei comes home, opens the fridge, and finds her '
      'birthday cake gone.\n'
      'Xiaomei: "Who ate my cake?!"\n'
      'Little brother: "Not me! I was playing football all afternoon."\n'
      'Dad: "I didn\'t eat it either. Go ask your mum."\n'
      'Mum laughs: "Nobody ate the cake — I moved it upstairs, because '
      'tonight we\'re giving you a surprise. Happy birthday!"',
  intro:
      'A missing-cake mystery, told in 把 and 被. (From now on the info button '
      'is English-only — your pinyin training wheels are off.)',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '把 accuses, 被 defends',
      text: '谁把蛋糕吃了? points at a doer; 蛋糕没被人吃 clears everyone. '
          'The same event, grabbed from both ends (Z22/Z23).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '小美发现什么不见了？',
      options: ['生日蛋糕', '自行车', '手机'],
      correctIndex: 0,
      questionTranslation: 'What does Xiaomei find missing?',
    ),
    ReadingQuestion(
      question: '弟弟下午在做什么？',
      options: ['吃蛋糕', '踢足球', '看电视'],
      correctIndex: 1,
      questionTranslation: 'What was little brother doing in the afternoon?',
    ),
    ReadingQuestion(
      question: '蛋糕在哪儿？',
      options: ['被弟弟吃了', '被妈妈放到楼上了', '被卖了'],
      correctIndex: 1,
      questionTranslation: 'Where is the cake?',
    ),
  ],
);

final QuizContent enZhB21Rang = enZhFill(
  id: 'en_zh_b2_1_rang',
  title: 'Making & letting: 让 / 叫',
  intro:
      '让 (and casual 叫) hand an action to someone else: 妈妈让我学中文 — mum '
      'has/lets me study Chinese. Negate in front: 不让.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'A + 让 + B + verb',
      text: 'The second verb belongs to B: 老板让我们加班 the boss makes us '
          'work late; 别让我等 don\'t make me wait. English "make/let/have '
          'someone do" collapses into 让.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Mum lets/has me study Chinese.', answer: '妈妈**让**我学中文。', accepted: ['ràng'], hint: 'māma ràng wǒ xué Zhōngwén'),
    CourseItem(prompt: 'The teacher had us write characters.', answer: '老师**让**我们写汉字。', accepted: ['ràng'], hint: 'lǎoshī ràng wǒmen xiě Hànzì'),
    CourseItem(prompt: 'Dad won\'t let me play on the phone.', answer: '爸爸**不让**我玩手机。', accepted: ['bú ràng', 'bu rang'], hint: 'bàba bú ràng wǒ wán shǒujī'),
    CourseItem(prompt: 'Don\'t make everyone wait too long.', answer: '别**让**大家等太久。', accepted: ['ràng'], hint: 'bié ràng dàjiā děng tài jiǔ'),
    CourseItem(prompt: 'This news made him very happy. (让 = made feel)', answer: '这个消息**让**他很高兴。', accepted: ['ràng'], hint: 'zhè ge xiāoxi ràng tā hěn gāoxìng'),
  ],
);

final QuizContent enZhB21Compare = enZhFill(
  id: 'en_zh_b2_1_compare',
  title: 'Comparison: the full kit',
  intro:
      'Beyond plain 比: 更 even more, 最 the most, 跟…一样 the same as, '
      '没有…那么 not as … as.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Four tools, four jobs (Z24)',
      text: 'A 比 B 高 taller · A 比 B **更**高 even taller (B is tall too!) · '
          'A **最**高 tallest · A **跟** B **一样**高 equally tall · A '
          '**没有** B **那么**高 not as tall.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Shanghai is even bigger than Beijing. (both are big)', answer: '上海比北京**更**大。', accepted: ['gèng'], hint: 'Shànghǎi bǐ Běijīng gèng dà'),
    CourseItem(prompt: 'This restaurant is the best.', answer: '这家饭馆**最**好。', accepted: ['zuì'], hint: 'zhè jiā fànguǎn zuì hǎo'),
    CourseItem(prompt: 'My phone is the same as yours.', answer: '我的手机**跟**你的**一样**。', accepted: ['gēn…yíyàng', 'gen yiyang'], hint: 'wǒ de shǒujī gēn nǐ de yíyàng'),
    CourseItem(prompt: 'Today isn\'t as cold as yesterday.', answer: '今天**没有**昨天**那么**冷。', accepted: ['méiyǒu…nàme', 'meiyou name'], hint: 'jīntiān méiyǒu zuótiān nàme lěng'),
    CourseItem(prompt: 'He speaks as well as the teacher. (一样 + 好)', answer: '他说得跟老师**一样**好。', accepted: ['yíyàng'], hint: 'tā shuō de gēn lǎoshī yíyàng hǎo'),
    CourseItem(prompt: 'Chinese is even more interesting than I thought. (比我想的)', answer: '中文比我想的**更**有意思。', accepted: ['gèng'], hint: 'Zhōngwén bǐ wǒ xiǎng de gèng yǒuyìsi'),
  ],
);

final QuizContent enZhB21ReadMoving = enZhRead(
  id: 'en_zh_b2_1_read_moving',
  title: 'Reading: 搬家',
  passageTitle: '搬家',
  passage:
      '这个周末汤姆搬家了。新家比旧家大得多，离学校也更近。\n'
      '小美和几个朋友都来帮忙。汤姆让大家先把大东西搬上车：'
      '床、桌子、椅子，还有那个最重的书柜。\n'
      '"把书柜放在哪儿？"小美问。\n'
      '"放在窗户旁边吧，"汤姆说，"把书都放到书柜里，把衣服放在床上，'
      '我等一下自己收拾。"\n'
      '搬完家，大家都累了。汤姆把大家的水杯拿来，说："今天真是太感谢你们了！'
      '晚上我请大家吃饭——菜已经被我订好了！"',
  passageTranslation:
      'This weekend Tom moved house. The new place is much bigger than the '
      'old one, and closer to school too.\n'
      'Xiaomei and a few friends came to help. Tom had everyone move the big '
      'things onto the truck first: the bed, the table, the chairs, and that '
      'heaviest of bookcases.\n'
      '"Where do we put the bookcase?" Xiaomei asked.\n'
      '"Next to the window," said Tom. "Put the books in the bookcase and the '
      'clothes on the bed — I\'ll sort them out myself later."\n'
      'When the move was done, everyone was exhausted. Tom brought everyone\'s '
      'water and said: "Thank you all so much for today! Dinner\'s on me '
      'tonight — the food is already ordered!"',
  intro:
      'Moving day: instructions with 把, one 被 for flavour, and comparisons '
      'between old home and new.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '离 = distance from (Z29)',
      text: '新家离学校更近 — 离 measures the gap between two places: A 离 B '
          '近/远. It\'s a coverb: it stands before what it relates to.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '新家怎么样？',
      options: ['比旧家大得多', '比旧家小', '跟旧家一样'],
      correctIndex: 0,
      questionTranslation: 'What is the new home like?',
    ),
    ReadingQuestion(
      question: '书柜放在哪儿？',
      options: ['床旁边', '窗户旁边', '门旁边'],
      correctIndex: 1,
      questionTranslation: 'Where does the bookcase go?',
    ),
    ReadingQuestion(
      question: '晚上谁请大家吃饭？',
      options: ['小美', '汤姆', '王老师'],
      correctIndex: 1,
      questionTranslation: 'Who treats everyone to dinner in the evening?',
    ),
  ],
);

final QuizContent enZhB21AbstractDir = enZhFill(
  id: 'en_zh_b2_1_abstract_dir',
  title: 'Abstract directions: 起来 / 下去 / 出来',
  intro:
      'Directional complements go abstract: 想起来 recall (thought comes UP), '
      '坚持下去 keep going (persist DOWNWARD/onward), 听出来 tell by ear '
      '(hear it OUT).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Directions become metaphors (Z21)',
      text: '起来 = starting/surfacing (笑起来 burst out laughing, 想起来 it '
          'comes back to me). 下去 = continuing (说下去 go on). 出来 = '
          'emerging/identifying (看出来 spot it).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I remembered! (the thought came up)', answer: '我想**起来**了！', accepted: ['qǐlái', 'qilai'], hint: 'wǒ xiǎng qǐlái le'),
    CourseItem(prompt: 'Keep studying (persist onward) — don\'t give up.', answer: '坚持**下去**，别放弃。', accepted: ['xiàqù', 'xiaqu'], hint: 'jiānchí xiàqù, bié fàngqì'),
    CourseItem(prompt: 'She suddenly burst out laughing.', answer: '她忽然笑了**起来**。', accepted: ['qǐlái'], hint: 'tā hūrán xiào le qǐlái'),
    CourseItem(prompt: 'Could you tell (by listening) that he\'s British?', answer: '你听**出来**他是英国人吗？', accepted: ['chūlái', 'chulai'], hint: 'nǐ tīng chūlái tā shì Yīngguó rén ma'),
    CourseItem(prompt: 'Please continue speaking. (speak onward)', answer: '请说**下去**。', accepted: ['xiàqù'], hint: 'qǐng shuō xiàqù'),
    CourseItem(prompt: 'The weather is starting to get hot.', answer: '天气热**起来**了。', accepted: ['qǐlái'], hint: 'tiānqì rè qǐlái le'),
  ],
);

final QuizContent enZhB21SpeakIntonation = enZhSpeak(
  id: 'en_zh_b2_1_speak_intonation',
  title: 'Speaking: question intonation OVER tones',
  intro:
      'A Chinese question rises as a whole — but every syllable keeps its own '
      'tone. Don\'t let English question-melody bend the words.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ The sentence rises, the tones survive (Z6)',
      text: 'In 你去吗? the overall pitch floats up, but 去 still FALLS (4th '
          'tone) inside that float. English speakers turn 去 into a rise — '
          'and say a different word.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Nǐ qù ma? — Are you going? (去 still falls!)', answer: '你去吗？'),
    CourseItem(prompt: 'Nǐ shì shéi? — Who are you? (statement melody)', answer: '你是谁？'),
    CourseItem(prompt: 'Zhēn de ma? — Really?', answer: '真的吗？'),
    CourseItem(prompt: 'Nǐ bǎ yàoshi fàng zài nǎr le? — Where did you put the keys?', answer: '你把钥匙放在哪儿了？'),
    CourseItem(prompt: 'Zhè ge duōshao qián? — How much is this? (calm, no English rise)', answer: '这个多少钱？'),
    CourseItem(prompt: 'Nǐ tīng de dǒng tīng bu dǒng? — Can you follow or not?', answer: '你听得懂听不懂？'),
  ],
);

final QuizContent enZhB21Work = enZhFill(
  id: 'en_zh_b2_1_work',
  title: 'Work & office',
  intro:
      'The vocabulary of jobs and offices — where 把-instructions and polite '
      '让-requests live all day.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '班 = your shift',
      text: '上班 go on shift (start work), 下班 come off shift, 加班 add '
          'shift (overtime) — one noun, three daily verbs.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'to work overtime (add-shift)', answer: '加班', accepted: ['jiābān'], hint: 'jiābān'),
    CourseItem(prompt: 'to finish work (off-shift)', answer: '下班', accepted: ['xiàbān'], hint: 'xiàbān'),
    CourseItem(prompt: 'meeting (to attend one: 开会)', answer: '开会', accepted: ['kāihuì'], hint: 'kāihuì'),
    CourseItem(prompt: 'colleague', answer: '同事', accepted: ['tóngshì'], hint: 'tóngshì'),
    CourseItem(prompt: 'boss / manager', answer: '经理', accepted: ['jīnglǐ'], hint: 'jīnglǐ'),
    CourseItem(prompt: 'email (electric-mail)', answer: '电子邮件', accepted: ['diànzǐ yóujiàn'], hint: 'diànzǐ yóujiàn'),
    CourseItem(prompt: 'The manager has us in a meeting every Monday.', answer: '经理**让**我们每星期一开会。', accepted: ['ràng'], hint: 'jīnglǐ ràng wǒmen měi xīngqīyī kāihuì'),
  ],
);

final QuizContent enZhB21ListenInterview = enZhListen(
  id: 'en_zh_b2_1_listen_interview',
  title: 'Listening: 面试',
  passageTitle: '汤姆的面试',
  passage:
      '汤姆想找一份兼职工作，今天他去一家翻译公司面试。\n'
      '经理："你为什么想来我们公司工作？"\n'
      '汤姆："因为我喜欢语言。我会说英文和法文，中文也说得越来越好。"\n'
      '经理："你能把这段中文翻译成英文吗？"\n'
      '汤姆看了看，把那段话翻译了出来。\n'
      '经理很满意："翻译得不错！下星期一你能来上班吗？"\n'
      '汤姆高兴地说："能！谢谢您给我这个机会。"',
  passageTranslation:
      'Tom wants a part-time job, and today he has an interview at a '
      'translation company.\n'
      'Manager: "Why do you want to work at our company?"\n'
      'Tom: "Because I love languages. I speak English and French, and my '
      'Chinese keeps getting better."\n'
      'Manager: "Can you translate this Chinese passage into English?"\n'
      'Tom looks it over and translates the passage.\n'
      'The manager is pleased: "Nicely translated! Can you start next '
      'Monday?"\n'
      'Tom says happily: "I can! Thank you for giving me this opportunity."',
  intro:
      'Tom\'s job interview — 把…翻译成, a potential complement, and polite '
      'workplace Chinese.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '您 = polite you',
      text: '您 nín is 你 with a heart (心) underneath — the respectful "you" '
          'for bosses, elders and customers. 谢谢您!',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆去哪儿面试？',
      options: ['一家翻译公司', '一家饭馆', '一家书店'],
      correctIndex: 0,
      questionTranslation: 'Where is Tom\'s interview?',
    ),
    ReadingQuestion(
      question: '经理让汤姆做什么？',
      options: ['写汉字', '把中文翻译成英文', '打电话'],
      correctIndex: 1,
      questionTranslation: 'What does the manager have Tom do?',
    ),
    ReadingQuestion(
      question: '汤姆什么时候开始上班？',
      options: ['明天', '下星期一', '下个月'],
      correctIndex: 1,
      questionTranslation: 'When does Tom start work?',
    ),
  ],
);

final QuizContent enZhB21DictBa = enZhDict(
  id: 'en_zh_b2_1_dict_ba',
  title: 'Dictation: 把-sentences',
  intro:
      'Type what you hear — the 把 fronts the object, so hold the whole '
      'sentence in your ear before typing.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 把 vs 被 — one syllable apart',
      text: 'bǎ (3rd tone) grabs, bèi (4th tone) suffers. In fast speech only '
          'the tone separates who did it from who got it done to (Z22/Z23).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Please shut the door.', answer: '请把门关上。'),
    CourseItem(prompt: 'I put the book on the table.', answer: '我把书放在桌子上了。'),
    CourseItem(prompt: 'My phone was taken by the teacher.', answer: '我的手机被老师拿走了。'),
    CourseItem(prompt: 'He finished (eating) the noodles.', answer: '他把面条吃完了。'),
    CourseItem(prompt: 'The problem is solved.', answer: '问题解决了。'),
    CourseItem(prompt: 'Hand the homework to the teacher.', answer: '把作业交给老师。'),
  ],
);

final QuizContent enZhB21ReadDelivery = enZhRead(
  id: 'en_zh_b2_1_read_delivery',
  title: 'Reading: 中国的快递',
  passageTitle: '中国的快递',
  passage:
      '在中国生活了一年以后，汤姆觉得最方便的就是快递。'
      '你在手机上买的东西，第二天就能被送到家门口。'
      '快递员每天把成千上万个包裹送到城市的每一个角落，'
      '比很多国家的快递快得多，也便宜得多。\n'
      '上个星期，汤姆把一本书寄给在上海的朋友。他早上把书交给快递员，'
      '朋友第二天中午就收到了。朋友给他发消息："收到了！这也太快了吧！"\n'
      '不过快递也带来了新问题：人们买得越来越多，包装垃圾也越来越多。'
      '现在很多公司开始让顾客把纸箱留给快递员，这样纸箱就能被再次使用。',
  passageTranslation:
      'After a year of living in China, Tom thinks the most convenient thing '
      'of all is the express delivery system. Something you buy on your phone '
      'can be delivered to your door the next day. Couriers deliver tens of '
      'thousands of parcels to every corner of the city every day — much '
      'faster and much cheaper than in many countries.\n'
      'Last week, Tom mailed a book to a friend in Shanghai. He handed the '
      'book to the courier in the morning, and his friend received it the '
      'next day at noon. The friend messaged him: "Got it! That\'s just too '
      'fast!"\n'
      'But delivery brings new problems too: people buy more and more, and '
      'packaging waste keeps growing. Many companies now have customers leave '
      'the boxes with the courier, so the boxes can be used again.',
  intro:
      'A slice of modern China — full of this module\'s grammar: 把, 被, '
      'comparisons and a 让 at the end.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '被 without a culprit',
      text: '能被送到家门口 / 能被再次使用 — formal-neutral 被 with no agent '
          'is fine in written style. Speech would just say 送到家门口 (Z23).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆觉得在中国生活最方便的是什么？',
      options: ['快递', '地铁', '手机'],
      correctIndex: 0,
      questionTranslation: 'What does Tom find most convenient about life in China?',
    ),
    ReadingQuestion(
      question: '朋友什么时候收到了书？',
      options: ['当天晚上', '第二天中午', '一个星期以后'],
      correctIndex: 1,
      questionTranslation: 'When did the friend receive the book?',
    ),
    ReadingQuestion(
      question: '快递带来了什么新问题？',
      options: ['太贵', '包装垃圾越来越多', '太慢'],
      correctIndex: 1,
      questionTranslation: 'What new problem does delivery bring?',
    ),
  ],
);

/// B2.1 in chain order.
final List<QuizContent> enZhB2_1 = [
  enZhB21Ba1,
  enZhB21Ba2,
  enZhB21SpeakBa,
  enZhB21Bei,
  enZhB21Notional,
  enZhB21ListenCake,
  enZhB21Rang,
  enZhB21Compare,
  enZhB21ReadMoving,
  enZhB21AbstractDir,
  enZhB21SpeakIntonation,
  enZhB21Work,
  enZhB21ListenInterview,
  enZhB21DictBa,
  enZhB21ReadDelivery,
];
