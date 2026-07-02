import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// B2.2 — Attitude & Flow · 语气与连贯 (HSK 4b). English → Mandarin.
///
/// Big rocks: the little adverbs 就/才/再/又/都/也/还 that carry attitude
/// (Z27 — the cliff), durative 着 (Z16), sentence-final particles 吧/呢/啊,
/// and the strong connective pairs (Z25). The aspect system gets its
/// consolidation pass in the 了/过/着 big-text cloze (Z14/Z15/Z16).

final QuizContent enZhB22Zhe = enZhFill(
  id: 'en_zh_b2_2_zhe',
  title: '着 — states that stay on',
  intro:
      'Verb + 着 zhe freezes an action into a state: 门开着 the door stands '
      'open, 她穿着红衣服 she\'s wearing red. Also: V1着 V2 — doing B while '
      'A-ing.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 着 = the pause button (Z16)',
      text: '开 is opening; 开着 is standing open. 了 stamps the change, 着 '
          'holds the resulting state. 墙上挂着一张照片 — a photo hangs on '
          'the wall.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'V着 + V = while',
      text: '她笑着说 she said, smiling; 我们坐着聊天 we sat chatting. The '
          '着-verb paints the backdrop of the main verb.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The door is (standing) open.', answer: '门开**着**。', accepted: ['zhe'], hint: 'mén kāi zhe'),
    CourseItem(prompt: 'She is wearing a red coat.', answer: '她穿**着**红大衣。', accepted: ['zhe'], hint: 'tā chuān zhe hóng dàyī'),
    CourseItem(prompt: 'A photo hangs on the wall.', answer: '墙上挂**着**一张照片。', accepted: ['zhe'], hint: 'qiáng shàng guà zhe yì zhāng zhàopiàn'),
    CourseItem(prompt: 'He said it smiling. (smile-着 say)', answer: '他笑**着**说。', accepted: ['zhe'], hint: 'tā xiào zhe shuō'),
    CourseItem(prompt: 'We sat chatting. (sit-着 chat)', answer: '我们坐**着**聊天。', accepted: ['zhe'], hint: 'wǒmen zuò zhe liáotiān'),
    CourseItem(prompt: 'The lights are on. (开 works for lights too)', answer: '灯开**着**。', accepted: ['zhe'], hint: 'dēng kāi zhe'),
  ],
);

final QuizContent enZhB22JiuCai = enZhFill(
  id: 'en_zh_b2_2_jiu_cai',
  title: '就 vs 才 — sooner vs later',
  intro:
      'The attitude twins: 八点就来了 — came at eight (early!); 八点才来 — '
      'didn\'t come UNTIL eight (finally!). Same clock, opposite feelings.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 就 = sooner than you think, 才 = later than you\'d like (Z27)',
      text: '就 says "that fast/easy/soon"; 才 says "only then, not before". '
          'Note: 才 blocks 了 — 他十点才来(了✗).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He came at eight ALREADY (early).', answer: '他八点**就**来了。', accepted: ['jiù'], hint: 'tā bā diǎn jiù lái le'),
    CourseItem(prompt: 'He didn\'t come UNTIL ten (late — and no 了!).', answer: '他十点**才**来。', accepted: ['cái'], hint: 'tā shí diǎn cái lái'),
    CourseItem(prompt: 'I understood after listening once (that easily).', answer: '我听了一遍**就**懂了。', accepted: ['jiù'], hint: 'wǒ tīng le yí biàn jiù dǒng le'),
    CourseItem(prompt: 'She only fell asleep at 2 a.m. (so late).', answer: '她两点**才**睡着。', accepted: ['cái'], hint: 'tā liǎng diǎn cái shuìzháo'),
    CourseItem(prompt: 'The food came right after we sat down. (that quickly)', answer: '我们一坐下，菜**就**来了。', accepted: ['jiù'], hint: 'wǒmen yí zuò xià, cài jiù lái le'),
    CourseItem(prompt: 'I only now understand this. (现在才)', answer: '我现在**才**明白。', accepted: ['cái'], hint: 'wǒ xiànzài cái míngbai'),
  ],
);

final QuizContent enZhB22ZaiYou = enZhFill(
  id: 'en_zh_b2_2_zai_you',
  title: '再 vs 又 — the two "agains"',
  intro:
      'Both mean "again", split by time: 又 for repeats that already happened '
      '(他又来了), 再 for repeats still to come (明天再来).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 又 looks back, 再 looks forward (Z27)',
      text: '又迟到了 — late AGAIN (it happened). 再说一遍 — say it again '
          '(please, in the future). 再见 = see you again — future, hence 再.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He was late again (it happened).', answer: '他**又**迟到了。', accepted: ['yòu'], hint: 'tā yòu chídào le'),
    CourseItem(prompt: 'Please say it one more time. (future repeat)', answer: '请**再**说一遍。', accepted: ['zài'], hint: 'qǐng zài shuō yí biàn'),
    CourseItem(prompt: 'It rained again yesterday.', answer: '昨天**又**下雨了。', accepted: ['yòu'], hint: 'zuótiān yòu xià yǔ le'),
    CourseItem(prompt: 'Come again tomorrow.', answer: '明天**再**来吧。', accepted: ['zài'], hint: 'míngtiān zài lái ba'),
    CourseItem(prompt: 'Let\'s eat first and talk later. (先…再)', answer: '先吃饭，**再**说。', accepted: ['zài'], hint: 'xiān chīfàn, zài shuō'),
    CourseItem(prompt: 'She watched the film again (and had seen it before).', answer: '她**又**看了一遍那个电影。', accepted: ['yòu'], hint: 'tā yòu kàn le yí biàn nà ge diànyǐng'),
  ],
);

final QuizContent enZhB22SpeakParticles = enZhSpeak(
  id: 'en_zh_b2_2_speak_particles',
  title: 'Speaking: attitude particles 吧 / 呢 / 啊',
  intro:
      'One syllable of attitude: 吧 suggests or guesses, 呢 muses "and…?", 啊 '
      'warms and exclaims. Say them lightly — they ride the sentence\'s tail.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The tail carries the tone of voice',
      text: '走吧 let\'s go (suggestion) · 你是学生吧? you\'re a student, '
          'right? (guess) · 我的书呢? and where\'s my book? · 真好啊! how '
          'nice! All neutral-toned, all attitude.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wǒmen zǒu ba! — Let\'s go!', answer: '我们走吧！'),
    CourseItem(prompt: 'Nǐ shì xuésheng ba? — You\'re a student, right?', answer: '你是学生吧？'),
    CourseItem(prompt: 'Wǒ de yàoshi ne? — And where are my keys?', answer: '我的钥匙呢？'),
    CourseItem(prompt: 'Zhè ge cài zhēn hǎochī a! — This dish is SO good!', answer: '这个菜真好吃啊！'),
    CourseItem(prompt: 'Xiūxi yíxià ba. — Take a break, why don\'t you.', answer: '休息一下吧。'),
    CourseItem(prompt: 'Kuài diǎnr a! — Hurry up!', answer: '快点儿啊！'),
  ],
);

final QuizContent enZhB22DouYeHai = enZhFill(
  id: 'en_zh_b2_2_dou_ye_hai',
  title: 'The 都 / 也 / 还 slots',
  intro:
      '都 all, 也 also, 还 still/in addition — small adverbs with a fixed '
      'home: after the subject, before the verb. 都 sums up what stands '
      'BEFORE it.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 都 points backward (Z27)',
      text: '我们都去 — ALL of us go: 都 covers the crowd to its LEFT. "I '
          'read all the books" = 这些书我都看过 — front the books so 都 can '
          'see them.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Order in the slot: 也 > 都 > 还',
      text: 'Stacked, they keep this order: 我们也都还在等 — also-all-still '
          'waiting. Each stays before the verb, never after.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'We are all going.', answer: '我们**都**去。', accepted: ['dōu'], hint: 'wǒmen dōu qù'),
    CourseItem(prompt: 'I have read all of these books. (front the books!)', answer: '这些书我**都**看过。', accepted: ['dōu'], hint: 'zhèxiē shū wǒ dōu kàn guo'),
    CourseItem(prompt: 'She also likes Chinese food.', answer: '她**也**喜欢中国菜。', accepted: ['yě'], hint: 'tā yě xǐhuan Zhōngguó cài'),
    CourseItem(prompt: 'He is still working. (still at it)', answer: '他**还**在工作。', accepted: ['hái'], hint: 'tā hái zài gōngzuò'),
    CourseItem(prompt: 'I want another cup of coffee. (in addition: 还要)', answer: '我**还**要一杯咖啡。', accepted: ['hái'], hint: 'wǒ hái yào yì bēi kāfēi'),
    CourseItem(prompt: 'Everyone understood. (大家 + all)', answer: '大家**都**听懂了。', accepted: ['dōu'], hint: 'dàjiā dōu tīng dǒng le'),
  ],
);

final QuizContent enZhB22ListenWaiting = enZhListen(
  id: 'en_zh_b2_2_listen_waiting',
  title: 'Listening: 等人',
  passageTitle: '等人',
  passage:
      '星期六下午两点，汤姆和小美约好在电影院门口见面，电影两点半开始。\n'
      '汤姆一点半就到了，站着等小美。两点过了，小美还没来。'
      '他给小美发消息："你到哪儿了？电影就要开始了！"\n'
      '两点二十五，小美才跑来，笑着说："对不起对不起！我又坐错车了！"\n'
      '汤姆说："你上次也坐错了！快走吧，再不进去，电影就开始了！"',
  passageTranslation:
      'Saturday afternoon at two, Tom and Xiaomei have agreed to meet at the '
      'cinema entrance; the film starts at half past two.\n'
      'Tom arrives at half past one already and stands there waiting. Two '
      'o\'clock passes — still no Xiaomei. He messages her: "Where are you? '
      'The film is about to start!"\n'
      'At 2:25 Xiaomei finally comes running, saying with a laugh: "Sorry, '
      'sorry! I took the wrong bus again!"\n'
      'Tom says: "You took the wrong one last time too! Quick — if we don\'t '
      'go in now, the film will start!"',
  intro:
      'One little story, all the little adverbs: 就 (early), 才 (finally), '
      '又 (again!), 还 (still), plus a 着 and a 吧.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '就要…了 = about to',
      text: '电影就要开始了 — on the very edge of starting. 就 + 要 + verb + '
          '了 is the "any second now" frame (Z27).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆几点到的？',
      options: ['一点半', '两点', '两点二十五'],
      correctIndex: 0,
      questionTranslation: 'What time did Tom arrive?',
    ),
    ReadingQuestion(
      question: '小美为什么来晚了？',
      options: ['她又坐错车了', '她在加班', '她生病了'],
      correctIndex: 0,
      questionTranslation: 'Why was Xiaomei late?',
    ),
    ReadingQuestion(
      question: '小美是第几次坐错车？',
      options: ['第一次', '不是第一次'],
      correctIndex: 1,
      questionTranslation: 'Is this the first time Xiaomei took the wrong bus?',
    ),
  ],
);

final QuizContent enZhB22Pairs = enZhFill(
  id: 'en_zh_b2_2_pairs',
  title: 'Strong pairs: 不但…而且 / 只要…就 / 只有…才',
  intro:
      'Three heavyweight pairs: 不但 A 而且 B (not only… but also), 只要 A 就 '
      'B (as long as → enough), 只有 A 才 B (only if → necessary).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ 只要…就 is generous, 只有…才 is strict (Z25)',
      text: '只要练习，就会进步 — ANY practice brings progress (sufficient). '
          '只有练习，才会进步 — NOTHING BUT practice brings it (necessary). '
          'The closer (就 vs 才) matches the opener.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He not only speaks Chinese, but also writes characters.', answer: '他**不但**会说中文，**而且**会写汉字。', accepted: ['búdàn…érqiě', 'budan erqie'], hint: 'tā búdàn huì shuō Zhōngwén, érqiě huì xiě Hànzì'),
    CourseItem(prompt: 'As long as you practise every day, you\'ll (then) improve.', answer: '只要你每天练习，**就**会进步。', accepted: ['jiù'], hint: 'zhǐyào nǐ měitiān liànxí, jiù huì jìnbù'),
    CourseItem(prompt: 'Only by practising can you (only then) improve.', answer: '只有多练习，**才**会进步。', accepted: ['cái'], hint: 'zhǐyǒu duō liànxí, cái huì jìnbù'),
    CourseItem(prompt: 'This dish is not only cheap but also delicious.', answer: '这个菜不但便宜，**而且**很好吃。', accepted: ['érqiě'], hint: 'zhè ge cài búdàn piányi, érqiě hěn hǎochī'),
    CourseItem(prompt: 'As long as it doesn\'t rain, we\'ll (then) go.', answer: '**只要**不下雨，我们就去。', accepted: ['zhǐyào'], hint: 'zhǐyào bú xià yǔ, wǒmen jiù qù'),
    CourseItem(prompt: 'Only the people who finished the homework can (only then) watch TV.', answer: '**只有**写完作业，才能看电视。', accepted: ['zhǐyǒu'], hint: 'zhǐyǒu xiě wán zuòyè, cái néng kàn diànshì'),
  ],
);

final QuizContent enZhB22BigtextAspect = enZhBigText(
  id: 'en_zh_b2_2_bigtext_aspect',
  title: 'Big text: 了 / 过 / 着 — the aspect story',
  passageTitle: '一个星期六',
  template:
      '星期六早上，汤姆睡到九点。窗户开{{0}}，外面下{{1}}小雨。\n'
      '他喝{{2}}一杯咖啡，然后坐{{3}}看书。这本书他以前看{{4}}一遍，'
      '可是越看越喜欢。\n'
      '中午，小美来电话："你吃饭{{5}}吗？我知道一家新饭馆，'
      '我还没去{{6}}，一起去吧！"\n'
      '饭馆里人很多。他们等{{7}}二十分钟才坐下。墙上挂{{8}}很多老照片，'
      '菜也很好吃。汤姆笑{{9}}说："下个星期我们再来吧！"',
  blanks: [
    particleBlank('着', options: const ['了', '过', '着'], translation: 'the window STANDS open — a held state'),
    particleBlank('着', options: const ['了', '过', '着'], translation: 'rain falling as backdrop — durative'),
    particleBlank('了', options: const ['了', '过', '着'], translation: 'drank one cup — completed, counted'),
    particleBlank('着', options: const ['了', '过', '着'], translation: 'sat (and stayed seated) reading — V着V'),
    particleBlank('过', options: const ['了', '过', '着'], translation: 'had read it once BEFORE — experience'),
    particleBlank('了', options: const ['了', '过', '着'], translation: 'eaten yet? — completion asked with 了吗'),
    particleBlank('过', options: const ['了', '过', '着'], translation: 'never been there — missing experience'),
    particleBlank('了', options: const ['了', '过', '着'], translation: 'waited twenty minutes — completed duration'),
    particleBlank('着', options: const ['了', '过', '着'], translation: 'photos HANG on the wall — state'),
    particleBlank('着', options: const ['了', '过', '着'], translation: 'said it smiling — V着V backdrop'),
  ],
  passageTranslation:
      'Saturday morning Tom sleeps till nine. The window stands open; outside '
      'a light rain is falling. He drinks a cup of coffee, then sits reading. '
      'He\'s read this book once before, but likes it more with every page. '
      'At noon Xiaomei calls: "Have you eaten? I know a new restaurant — I '
      'haven\'t been yet. Let\'s go together!" The restaurant is packed. They '
      'wait twenty minutes before getting a table. Old photos hang on the '
      'walls, and the food is great. Tom says with a smile: "Let\'s come '
      'again next week!"',
  intro:
      'One Saturday, ten gaps, three particles. For each: completed and '
      'counted → 了; life experience → 过; held state or backdrop → 着.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The three stamps side by side (Z14/Z15/Z16)',
      text: '了 = ✓ done · 过 = passport-stamped experience · 着 = pause '
          'button. If the sentence counts something (一杯, 二十分钟), 了. If '
          'it says "ever/never", 过. If something just hangs there, 着.',
    ),
  ],
);

final QuizContent enZhB22ReadDate = enZhRead(
  id: 'en_zh_b2_2_read_date',
  title: 'Reading: 一次约会',
  passageTitle: '一次约会',
  passage:
      '小美的姐姐上个月认识了一个男孩子，两个人都喜欢爬山，很快就熟了。\n'
      '第一次约会，男孩子七点就到了饭馆门口，站着等她。'
      '姐姐七点半才到，因为路上堵车堵得厉害。'
      '她远远地看见他手里拿着一束花，心里就不紧张了。\n'
      '吃饭的时候，两个人聊得很开心。他不但会做菜，而且也喜欢看书。'
      '姐姐回家以后对小美说："只有跟他聊天的时候，我才觉得时间过得这么快。'
      '我们下星期还要再见面呢！"',
  passageTranslation:
      'Last month Xiaomei\'s older sister met a boy; they both love hiking '
      'and quickly hit it off.\n'
      'For the first date, the boy arrived at the restaurant at seven already '
      'and stood waiting. The sister didn\'t arrive until half past — the '
      'traffic jam was terrible. From a distance she saw the bouquet in his '
      'hand, and her nerves melted away.\n'
      'Over dinner the two talked happily. He not only cooks, but loves books '
      'too. Back home, the sister told Xiaomei: "Only when I\'m talking with '
      'him does time pass this fast. We\'re meeting again next week!"',
  intro:
      'A first date told through the module\'s lens: 就 vs 才, 着-states, '
      '不但…而且, 只有…才 — attitude in every line.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '呢 keeps it warm',
      text: 'The closing 我们还要再见面呢! carries a happy glow — 呢 softens '
          'a statement into shared excitement.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '男孩子几点到的？',
      options: ['七点', '七点半', '八点'],
      correctIndex: 0,
      questionTranslation: 'What time did the boy arrive?',
    ),
    ReadingQuestion(
      question: '姐姐为什么来晚了？',
      options: ['她坐错车了', '路上堵车', '她在加班'],
      correctIndex: 1,
      questionTranslation: 'Why was the sister late?',
    ),
    ReadingQuestion(
      question: '男孩子手里拿着什么？',
      options: ['一本书', '一束花', '一杯咖啡'],
      correctIndex: 1,
      questionTranslation: 'What was the boy holding?',
    ),
  ],
);

final QuizContent enZhB22Concession = enZhFill(
  id: 'en_zh_b2_2_concession',
  title: 'Concession: 即使…也 / 无论…都',
  intro:
      'Bulletproof statements: 即使 A，也 B (even if A, still B), 无论 A，都 B '
      '(no matter A, always B).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '也/都 close the pair (Z25)',
      text: '即使 pairs with 也; 无论 pairs with 都 — and 无论 wants an '
          'open question after it (谁/什么/多 or A不A): 无论多忙，都要吃饭.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Even if it rains, I will still go.', answer: '即使下雨，我**也**去。', accepted: ['yě'], hint: 'jíshǐ xià yǔ, wǒ yě qù'),
    CourseItem(prompt: 'No matter how busy, you must always eat.', answer: '无论多忙，**都**要吃饭。', accepted: ['dōu'], hint: 'wúlùn duō máng, dōu yào chīfàn'),
    CourseItem(prompt: 'Even if it\'s very expensive, she\'ll still buy it.', answer: '**即使**很贵，她也要买。', accepted: ['jíshǐ'], hint: 'jíshǐ hěn guì, tā yě yào mǎi'),
    CourseItem(prompt: 'No matter who asks, don\'t (always don\'t) tell.', answer: '**无论**谁问，都别说。', accepted: ['wúlùn'], hint: 'wúlùn shéi wèn, dōu bié shuō'),
    CourseItem(prompt: 'No matter where he goes, he always takes that book.', answer: '无论去哪儿，他**都**带着那本书。', accepted: ['dōu'], hint: 'wúlùn qù nǎr, tā dōu dài zhe nà běn shū'),
  ],
);

final QuizContent enZhB22SpeakFlow = enZhSpeak(
  id: 'en_zh_b2_2_speak_flow',
  title: 'Speaking: connected speech at pace',
  intro:
      'Full sentences at natural speed: keep the particles light, the tones '
      'intact, and breathe at the commas.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Light ≠ lost (Z6)',
      text: '了, 着, 吧, 呢 go quiet and quick — but never vanish. Aim for '
          '"small but there": native rhythm keeps every syllable\'s slot.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Tā xiào zhe shuō: "Wǒmen zǒu ba!" — She said, smiling: "Let\'s go!"', answer: '她笑着说："我们走吧！"'),
    CourseItem(prompt: 'Zhǐyào nǐ lái, wǒmen jiù hěn gāoxìng. — As long as you come, we\'ll be happy.', answer: '只要你来，我们就很高兴。'),
    CourseItem(prompt: 'Tā búdàn huì zuò cài, érqiě zuò de fēicháng hǎochī. — He not only cooks — he cooks wonderfully.', answer: '他不但会做菜，而且做得非常好吃。'),
    CourseItem(prompt: 'Wúlùn duō wǎn, wǒ dōu děng nǐ. — However late, I\'ll wait for you.', answer: '无论多晚，我都等你。'),
    CourseItem(prompt: 'Diànyǐng jiù yào kāishǐ le, kuài diǎnr a! — The film\'s about to start, hurry!', answer: '电影就要开始了，快点儿啊！'),
  ],
);

final QuizContent enZhB22Feelings = enZhFill(
  id: 'en_zh_b2_2_feelings',
  title: 'Feelings & opinions',
  intro:
      'Words for the inner weather — and the frames that carry opinions: '
      '我觉得… I feel/think, 对…感兴趣 interested in.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '对 X 感兴趣',
      text: 'Interest aims with 对: 我对历史感兴趣 — toward history I feel '
          'interest. Another coverb setting the scene before the verb (Z29).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I think / feel that…', answer: '我**觉得**', accepted: ['juéde'], hint: 'wǒ juéde'),
    CourseItem(prompt: 'excited', answer: '激动', accepted: ['jīdòng'], hint: 'jīdòng'),
    CourseItem(prompt: 'worried', answer: '担心', accepted: ['dānxīn'], hint: 'dānxīn'),
    CourseItem(prompt: 'surprised (feel unexpected)', answer: '惊讶', accepted: ['jīngyà'], hint: 'jīngyà'),
    CourseItem(prompt: 'to relax (put down the heart)', answer: '放心', accepted: ['fàngxīn'], hint: 'fàngxīn'),
    CourseItem(prompt: 'I am interested in history.', answer: '我**对**历史感兴趣。', accepted: ['duì'], hint: 'wǒ duì lìshǐ gǎn xìngqù'),
    CourseItem(prompt: 'In my view / opinion (looking at it my way)', answer: '在我看来', accepted: ['zài wǒ kàn lái'], hint: 'zài wǒ kàn lái'),
  ],
);

final QuizContent enZhB22ListenPodcast = enZhListen(
  id: 'en_zh_b2_2_listen_podcast',
  title: 'Listening: 播客 — 好习惯',
  passageTitle: '好习惯是怎么来的',
  passage:
      '大家好，欢迎收听我们的播客。今天聊一个话题：好习惯是怎么来的？\n'
      '很多人觉得，只要下定决心，就能改变自己。可是研究发现，'
      '只有把新习惯变得很小、很容易，才能坚持下去。'
      '比如，你想每天看书，就先从每天看一页开始。'
      '即使那天再忙，一页书也看得完。\n'
      '还有一个方法：把新习惯放在老习惯后面。'
      '每天喝着咖啡的时候背五个生词——咖啡喝完了，生词也背完了。'
      '听起来很简单吧？无论你想养成什么习惯，都可以试试这个办法。',
  passageTranslation:
      'Hello everyone, welcome to our podcast. Today\'s topic: where do good '
      'habits come from?\n'
      'Many people think that as long as you\'re determined, you can change '
      'yourself. But research finds that only by making a new habit small and '
      'easy can you keep it going. Say you want to read every day — start '
      'with one page a day. Even on your busiest day, one page is doable.\n'
      'Another method: attach the new habit to an old one. Memorize five new '
      'words while drinking your daily coffee — when the coffee\'s finished, '
      'so are the words. Sounds simple, right? Whatever habit you want to '
      'build, give this method a try.',
  intro:
      'A podcast on habits — listen for 只要…就 vs 只有…才 doing real '
      'argumentative work, plus 着, 即使…也 and 无论…都.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '听起来 = it sounds…',
      text: '听起来很简单 — "hearing-wise it comes out simple". The abstract '
          '起来 turns any verb into an impression: 看起来, 说起来 (Z21).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '研究发现，怎样才能坚持新习惯？',
      options: ['把习惯变得很小、很容易', '下定决心', '每天想着它'],
      correctIndex: 0,
      questionTranslation: 'According to research, how can you keep a new habit going?',
    ),
    ReadingQuestion(
      question: '想每天看书，应该从什么开始？',
      options: ['每天看一页', '每天看一本', '每天看一个小时'],
      correctIndex: 0,
      questionTranslation: 'To read daily, what should you start with?',
    ),
    ReadingQuestion(
      question: '喝咖啡的时候可以做什么？',
      options: ['背五个生词', '看电视', '睡觉'],
      correctIndex: 0,
      questionTranslation: 'What can you do while drinking coffee?',
    ),
  ],
);

final QuizContent enZhB22DictAttitude = enZhDict(
  id: 'en_zh_b2_2_dict_attitude',
  title: 'Dictation: attitude lines',
  intro:
      'Type what you hear — the meaning hides in the little words: 就, 才, '
      '又, 再, 着, 吧.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ The adverbs are the message (Z27)',
      text: '他八点就来了 vs 他八点才来 — one small word flips early to '
          'late. If you\'re unsure what you heard, replay for the adverb, '
          'not the nouns.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He arrived at eight already.', answer: '他八点就到了。'),
    CourseItem(prompt: 'She didn\'t come until ten.', answer: '她十点才来。'),
    CourseItem(prompt: 'It\'s raining again!', answer: '又下雨了！'),
    CourseItem(prompt: 'Please say it one more time.', answer: '请再说一遍。'),
    CourseItem(prompt: 'The door is open (standing open).', answer: '门开着。'),
    CourseItem(prompt: 'Let\'s go, the film is about to start!', answer: '走吧，电影就要开始了！'),
  ],
);

final QuizContent enZhB22ReadPhones = enZhRead(
  id: 'en_zh_b2_2_read_phones',
  title: 'Reading: 手机与生活',
  passageTitle: '手机与生活',
  passage:
      '在中国，手机几乎就是生活本身。人们用手机买东西、点外卖、坐地铁、看病挂号。'
      '汤姆刚来的时候还带着钱包，现在他出门只带手机——钱包在家里放着，'
      '已经放了半年了。\n'
      '手机让生活变得方便，可是也带来了新问题。'
      '在地铁里，几乎每个人都低着头看手机；朋友们坐在一起吃饭，'
      '也常常是一边吃着饭，一边看着手机。\n'
      '小美说："我们只有把手机放下，才能真正地在一起。"'
      '所以他们约好：吃饭的时候，谁先拿手机，谁就请客。'
      '这个办法听起来简单，可是很有用——即使是最爱看手机的朋友，也坚持下来了。',
  passageTranslation:
      'In China, the phone practically IS daily life. People use it to shop, '
      'order food, ride the metro, register at the hospital. When Tom first '
      'arrived he still carried a wallet; now he leaves home with only his '
      'phone — the wallet has been sitting at home for half a year.\n'
      'Phones make life convenient, but they bring new problems. On the '
      'metro, almost everyone rides with head bowed over a screen; friends '
      'sitting down to dinner often eat with one eye on their phones.\n'
      'Xiaomei says: "Only by putting the phones down can we truly be '
      'together." So they made a deal: at dinner, whoever reaches for their '
      'phone first pays the bill. It sounds simple, but it works — even the '
      'most phone-addicted friend has stuck to it.',
  intro:
      'Modern China through this module\'s grammar: 着-states everywhere, '
      '一边…一边, 只有…才, and a 谁…谁 pattern worth stealing.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '谁…谁… = whoever',
      text: '谁先拿手机，谁就请客 — whoever grabs the phone first, THAT '
          'person treats. The question word doubles as "whoever" (Z28).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆现在出门带什么？',
      options: ['只带手机', '手机和钱包', '只带钱包'],
      correctIndex: 0,
      questionTranslation: 'What does Tom take when he goes out now?',
    ),
    ReadingQuestion(
      question: '朋友们约好了什么？',
      options: ['谁先拿手机，谁请客', '吃饭不说话', '每天背生词'],
      correctIndex: 0,
      questionTranslation: 'What deal did the friends make?',
    ),
    ReadingQuestion(
      question: '这个办法有用吗？',
      options: ['很有用', '没有用'],
      correctIndex: 0,
      questionTranslation: 'Does the method work?',
    ),
  ],
);

/// B2.2 in chain order.
final List<QuizContent> enZhB2_2 = [
  enZhB22Zhe,
  enZhB22JiuCai,
  enZhB22ZaiYou,
  enZhB22SpeakParticles,
  enZhB22DouYeHai,
  enZhB22ListenWaiting,
  enZhB22Pairs,
  enZhB22BigtextAspect,
  enZhB22ReadDate,
  enZhB22Concession,
  enZhB22SpeakFlow,
  enZhB22Feelings,
  enZhB22ListenPodcast,
  enZhB22DictAttitude,
  enZhB22ReadPhones,
];
