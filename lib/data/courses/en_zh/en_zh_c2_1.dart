import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// C2.1 — Idiom & Color · 成语与色彩 (HSK 6 / Band 3). English → Mandarin.
///
/// Big rocks: idiomatic mastery — 成语 in narrative and argument, 惯用语/俗语/
/// 歇后语 (Z30), connotation control, marked syntax 连…都 / 再…也 / 非…不可
/// (Z27), and fine aspect nuance (Z14–16 at the ceiling).

final QuizContent enZhC21Chengyu1 = enZhFill(
  id: 'en_zh_c2_1_chengyu_1',
  title: '成语 I — in stories',
  intro:
      'Narrative 成语: the four-character phrases that paint scenes — '
      'weather, crowds, moods — in a single brushstroke.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Paint, don\'t translate (Z30)',
      text: '倾盆大雨 "basin-tipping rain" beats 很大的雨 the way "bucketing '
          'down" beats "raining a lot". Learn each as an image with a '
          'grammar slot (predicate? adverb? attributive?).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'torrential rain (tipping-basin big rain)', answer: '倾盆大雨', accepted: ['qīng pén dà yǔ'], hint: 'qīng pén dà yǔ'),
    CourseItem(prompt: 'at a loss what to do (no plan can be applied)', answer: '无计可施', accepted: ['wú jì kě shī'], hint: 'wú jì kě shī'),
    CourseItem(prompt: 'to arrive as if by miracle, in the nick of time (from the sky descending)', answer: '从天而降', accepted: ['cóng tiān ér jiàng'], hint: 'cóng tiān ér jiàng'),
    CourseItem(prompt: 'utterly exhausted (muscles weary, strength drained)', answer: '筋疲力尽', accepted: ['jīn pí lì jìn'], hint: 'jīn pí lì jìn'),
    CourseItem(prompt: 'to talk and laugh merrily (talk-laugh wind-born)', answer: '谈笑风生', accepted: ['tán xiào fēng shēng'], hint: 'tán xiào fēng shēng'),
    CourseItem(prompt: 'Outside it was bucketing down, and we were exhausted.', answer: '外面下着**倾盆大雨**，我们已经筋疲力尽。', accepted: ['qīng pén dà yǔ'], hint: 'wàimiàn xià zhe qīng pén dà yǔ, wǒmen yǐjīng jīn pí lì jìn'),
  ],
);

final QuizContent enZhC21Chengyu2 = enZhFill(
  id: 'en_zh_c2_1_chengyu_2',
  title: '成语 II — in argument',
  intro:
      'Argumentative 成语: the ones that structure reasoning — citing '
      'precedent, exposing fallacies, weighing pros and cons.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'One per move',
      text: 'Chinese essays deploy an argumentative 成语 at each turn: '
          'concede with 无可否认, attack with 本末倒置, conclude with '
          '归根结底. They\'re the register\'s gears, not decoration.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'undeniably (nothing can be denied)', answer: '无可否认', accepted: ['wú kě fǒu rèn'], hint: 'wú kě fǒu rèn'),
    CourseItem(prompt: 'to put the cart before the horse (root and branch inverted)', answer: '本末倒置', accepted: ['běn mò dào zhì'], hint: 'běn mò dào zhì'),
    CourseItem(prompt: 'in the final analysis (return to root, reach bottom)', answer: '归根结底', accepted: ['guī gēn jié dǐ'], hint: 'guī gēn jié dǐ'),
    CourseItem(prompt: 'to complement each other perfectly (mutually assist, mutually complete)', answer: '相辅相成', accepted: ['xiāng fǔ xiāng chéng'], hint: 'xiāng fǔ xiāng chéng'),
    CourseItem(prompt: 'the two are as different as can be (heaven-abyss distinction)', answer: '天壤之别', accepted: ['tiān rǎng zhī bié'], hint: 'tiān rǎng zhī bié'),
    CourseItem(prompt: 'Undeniably, the two approaches complement each other.', answer: '**无可否认**，这两种方法相辅相成。', accepted: ['wú kě fǒu rèn'], hint: 'wú kě fǒu rèn, zhè liǎng zhǒng fāngfǎ xiāng fǔ xiāng chéng'),
  ],
);

final QuizContent enZhC21SpeakStory = enZhSpeak(
  id: 'en_zh_c2_1_speak_story',
  title: 'Speaking: storytelling with idioms',
  intro:
      'Tell a story the way an educated speaker would — idioms placed at the '
      'peaks, plain language in the valleys.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Idioms at the peaks (Z30)',
      text: 'Set the scene plainly, then let the 成语 land the punch: '
          '"我们等了三个小时——真是度日如年。" Contrast is what makes the '
          'idiom shine.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Nà tiān wǒmen qǐ le ge dà zǎo, xìngzhìbóbó de chūfā le. — That day we rose early and set out in high spirits.', answer: '那天我们起了个大早，兴致勃勃地出发了。'),
    CourseItem(prompt: 'Shéi zhīdào bàn lù xià qǐ le qīng pén dà yǔ. — Who knew: halfway there it started bucketing down.', answer: '谁知道半路下起了倾盆大雨。'),
    CourseItem(prompt: 'Wǒmen wú jì kě shī, zhǐ hǎo duǒ jìn yì jiā xiǎo diàn. — At a loss, we could only shelter in a little shop.', answer: '我们无计可施，只好躲进一家小店。'),
    CourseItem(prompt: 'Méi xiǎng dào, zhè jiā xiǎo diàn de miàntiáo hǎochī de chūhūyìliào. — Unexpectedly, that little shop\'s noodles were astonishingly good.', answer: '没想到，这家小店的面条好吃得出乎意料。'),
    CourseItem(prompt: 'Guī gēn jié dǐ, zuì hǎo de lǚxíng wǎngwǎng shì jìhuà zhī wài de. — In the end, the best journeys are usually the unplanned ones.', answer: '归根结底，最好的旅行往往是计划之外的。'),
  ],
);

final QuizContent enZhC21Guanyongyu = enZhFill(
  id: 'en_zh_c2_1_guanyongyu',
  title: 'Street Chinese: 惯用语 & 俗语',
  intro:
      'Below the 成语 sits the street layer: three-character 惯用语 (拍马屁 '
      'flatter, 开夜车 pull an all-nighter) and proverbs everyone quotes.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Register: these are jeans, not suits',
      text: '惯用语 belong in speech and casual writing. 他很会拍马屁 among '
          'friends ✓; in a formal report you\'d write 奉承. Never mix them '
          'into 书面语 (Z30).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'to flatter, kiss up (pat the horse\'s rump)', answer: '拍马屁', accepted: ['pāi mǎpì'], hint: 'pāi mǎpì'),
    CourseItem(prompt: 'to pull an all-nighter (drive the night bus)', answer: '开夜车', accepted: ['kāi yèchē'], hint: 'kāi yèchē'),
    CourseItem(prompt: 'to be a scapegoat (carry the black pot)', answer: '背黑锅', accepted: ['bēi hēiguō'], hint: 'bēi hēiguō'),
    CourseItem(prompt: 'to chat idly / shoot the breeze', answer: '聊天儿', accepted: ['liáotiānr', 'liáo tiānr'], hint: 'liáotiānr'),
    CourseItem(prompt: '"Distance tests a horse\'s strength, time reveals a person\'s heart."', answer: '路遥知马力，日久见人心', accepted: ['lù yáo zhī mǎ lì, rì jiǔ jiàn rén xīn'], hint: 'lù yáo zhī mǎlì, rì jiǔ jiàn rénxīn'),
    CourseItem(prompt: 'He pulled an all-nighter to finish the report.', answer: '他**开夜车**把报告写完了。', accepted: ['kāi yèchē'], hint: 'tā kāi yèchē bǎ bàogào xiě wán le'),
  ],
);

final QuizContent enZhC21ListenHumor = enZhListen(
  id: 'en_zh_c2_1_listen_humor',
  title: 'Listening: 幽默 — 相声片段',
  passageTitle: '相声：学外语',
  passage:
      '甲："听说你最近在学英语？"\n'
      '乙："对啊，学了三年了。"\n'
      '甲："那你说两句让我听听。"\n'
      '乙："这个……我的英语是哑巴英语——能听，能看，就是不能说。"\n'
      '甲："那不就是收音机吗？"\n'
      '乙："你别笑话我。你不是也学过法语吗？"\n'
      '甲："我那法语学得可好了，法国人都夸我。"\n'
      '乙："夸你什么？"\n'
      '甲："夸我中文说得真棒！"',
  passageTranslation:
      'A: "I hear you\'ve been learning English lately?"\n'
      'B: "Right, three years now."\n'
      'A: "Say a couple of lines, let me hear."\n'
      'B: "Well… mine is mute English — I can listen, I can read, I just '
      'can\'t speak."\n'
      'A: "So… you\'re a radio?"\n'
      'B: "Don\'t mock me. Didn\'t you study French too?"\n'
      'A: "My French is superb — even the French praise me."\n'
      'B: "Praise you for what?"\n'
      'A: "For how brilliant my Chinese is!"',
  intro:
      'A crosstalk (相声) sketch — the setup-punchline rhythm of Chinese '
      'humor. Listen for what\'s implied, not just what\'s said.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '哑巴英语',
      text: '"Mute English" — the (self-)mocking term for reading-only '
          'language skill. This course\'s speaking spine exists precisely so '
          'your Chinese won\'t be 哑巴中文.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '乙说自己的英语是什么英语？',
      options: ['哑巴英语', '流利英语', '广播英语'],
      correctIndex: 0,
      questionTranslation: 'What does B call his English?',
    ),
    ReadingQuestion(
      question: '法国人夸甲什么？',
      options: ['中文说得棒', '法语说得好', '英语说得好'],
      correctIndex: 0,
      questionTranslation: 'What do the French praise A for?',
    ),
    ReadingQuestion(
      question: '这段对话的幽默在哪里？',
      options: ['甲的法语其实很差', '乙的英语很好', '两人不认识'],
      correctIndex: 0,
      questionTranslation: 'Where is the humor in this dialogue?',
    ),
  ],
);

final QuizContent enZhC21Connotation = enZhFill(
  id: 'en_zh_c2_1_connotation',
  title: 'Connotation: 果断 or 武断?',
  intro:
      'Word pairs with the same denotation and opposite charge: 果断 decisive '
      '(+) vs 武断 arbitrary (−), 成果 achievement (+) vs 后果 consequence (−).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ The charge is in the character',
      text: '果断 fruit-cut = decisively; 武断 force-cut = high-handedly. '
          '后果 always lands badly; 结果 is neutral; 成果 glows. Praise with '
          'a minus-word and you\'ve insulted someone politely.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'His decision was decisive (+).', answer: '他的决定很**果断**。', accepted: ['guǒduàn'], hint: 'tā de juédìng hěn guǒduàn'),
    CourseItem(prompt: 'Don\'t be so arbitrary (−) — hear everyone out first.', answer: '别这么**武断**，先听听大家的意见。', accepted: ['wǔduàn'], hint: 'bié zhème wǔduàn, xiān tīng tīng dàjiā de yìjiàn'),
    CourseItem(prompt: 'The research produced important achievements (+).', answer: '这项研究取得了重要的**成果**。', accepted: ['chéngguǒ'], hint: 'zhè xiàng yánjiū qǔdé le zhòngyào de chéngguǒ'),
    CourseItem(prompt: 'You must bear the consequences (−) yourself.', answer: '你要自己承担**后果**。', accepted: ['hòuguǒ'], hint: 'nǐ yào zìjǐ chéngdān hòuguǒ'),
    CourseItem(prompt: 'She is thrifty (+, not stingy).', answer: '她很**节俭**。', accepted: ['jiéjiǎn'], hint: 'tā hěn jiéjiǎn'),
    CourseItem(prompt: 'He\'s just plain stingy (−).', answer: '他简直太**小气**了。', accepted: ['xiǎoqì'], hint: 'tā jiǎnzhí tài xiǎoqì le'),
  ],
);

final QuizContent enZhC21Marked = enZhFill(
  id: 'en_zh_c2_1_marked',
  title: 'Marked syntax: 连…都 / 再…也 / 非…不可',
  intro:
      'Structures that shout: 连…都 (even…!), 再…也 (no matter how…), '
      '非…不可 (absolutely must).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Three intensifier frames (Z27)',
      text: '连小孩都懂 even a child gets it · 再贵我也买 however pricey, '
          'I\'m buying · 我非去不可 I simply must go (double negative = '
          'iron will).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Even a child can understand this.', answer: '**连**小孩**都**能听懂。', accepted: ['lián…dōu', 'lian dou'], hint: 'lián xiǎohái dōu néng tīng dǒng'),
    CourseItem(prompt: 'However expensive it is, I\'m still buying it.', answer: '**再**贵我**也**要买。', accepted: ['zài…yě', 'zai ye'], hint: 'zài guì wǒ yě yào mǎi'),
    CourseItem(prompt: 'I absolutely must attend this meeting.', answer: '这个会我**非**去**不可**。', accepted: ['fēi…bùkě', 'fei buke'], hint: 'zhè ge huì wǒ fēi qù bùkě'),
    CourseItem(prompt: 'He didn\'t even say goodbye. (even 再见!)', answer: '他**连**再见**都**没说。', accepted: ['lián…dōu'], hint: 'tā lián zàijiàn dōu méi shuō'),
    CourseItem(prompt: 'However you explain, he won\'t listen.', answer: '你**再**怎么解释，他**也**不听。', accepted: ['zài…yě'], hint: 'nǐ zài zěnme jiěshì, tā yě bù tīng'),
  ],
);

final QuizContent enZhC21ReadSatire = enZhRead(
  id: 'en_zh_c2_1_read_satire',
  title: 'Reading: 一篇讽刺文章',
  passageTitle: '论"打卡式"旅游',
  passage:
      '如今流行一种全新的旅游方式，我称之为"打卡式"旅游。'
      '其要领如下：到达景点后，第一时间找到最佳拍照角度，'
      '拍照三十张，修图十分钟，发朋友圈一条，然后——奔赴下一个景点。'
      '至于景点本身？看没看，重要吗？\n'
      '这种旅游效率之高，令人叹为观止。'
      '有人一天"游"了八个景点，晚上数着朋友圈的点赞，'
      '满意地宣布：这个城市，我玩明白了。'
      '古人说"读万卷书，行万里路"；今人则是"拍万张照，修万张图"。\n'
      '当然，我并非反对拍照。只是，当我们连一分钟都不肯留给风景本身，'
      '当点赞数成了旅行唯一的"成果"，我们与其说是在看世界，'
      '不如说是在让世界看我们——看我们忙着看手机。',
  passageTranslation:
      'On "check-in" tourism\n'
      'A brand-new style of travel is in fashion; I call it "check-in" '
      'tourism. The technique: on arriving at a sight, immediately locate the '
      'best photo angle, take thirty shots, retouch for ten minutes, post one '
      'WeChat update — then dash to the next sight. As for the sight itself? '
      'Seen or not — does it matter?\n'
      'The efficiency is breathtaking. Some "tour" eight sights in a day, '
      'count their likes at night, and declare with satisfaction: this city — '
      'nailed it. The ancients said, "Read ten thousand books, travel ten '
      'thousand miles"; our contemporaries: "Take ten thousand photos, '
      'retouch ten thousand pictures."\n'
      'I\'m not against photography, of course. But when we won\'t spare the '
      'scenery even one minute, when likes become a journey\'s only '
      '"achievement" — we are not so much seeing the world as letting the '
      'world watch us… watching our phones.',
  intro:
      'Satire runs on deadpan precision: mock-technical language (要领如下), '
      'ironic praise (令人叹为观止), and a twisted classic. Read for the '
      'sting under the smile.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '与其说 A，不如说 B',
      text: '"Not so much A as B" — the essay\'s final turn. A precision '
          'instrument for reframing: 与其说是在看世界，不如说是在让世界看'
          '我们.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '"打卡式"旅游最关心什么？',
      options: ['拍照和点赞', '景点的历史', '当地的菜'],
      correctIndex: 0,
      questionTranslation: 'What does "check-in" tourism care about most?',
    ),
    ReadingQuestion(
      question: '"令人叹为观止"在文中是什么语气？',
      options: ['讽刺', '真心赞美', '生气'],
      correctIndex: 0,
      questionTranslation: 'What tone does "breathtaking" carry here?',
    ),
    ReadingQuestion(
      question: '作者反对拍照吗？',
      options: ['不反对，反对只拍照不看风景', '完全反对拍照', '觉得应该多拍'],
      correctIndex: 0,
      questionTranslation: 'Is the author against photography?',
    ),
  ],
);

final QuizContent enZhC21Xiehouyu = enZhFill(
  id: 'en_zh_c2_1_xiehouyu',
  title: '歇后语 & cultural references',
  intro:
      '歇后语 are two-part jokes: a setup, then the point — often a pun. '
      '泥菩萨过江——自身难保: a clay Buddha crossing the river can\'t even '
      'save itself.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Say the setup, imply the point',
      text: 'Natives often speak only the first half — 他现在是泥菩萨过江… — '
          'and let you finish it. Knowing the second half is the insider '
          'test (Z30).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'A clay Buddha crossing the river — …can\'t even save itself.', answer: '泥菩萨过江——**自身难保**', accepted: ['zìshēn nán bǎo'], hint: 'ní púsà guò jiāng — zìshēn nán bǎo'),
    CourseItem(prompt: 'Zhang Fei eating bean sprouts — …a piece of cake. (小菜一碟)', answer: '张飞吃豆芽——**小菜一碟**', accepted: ['xiǎo cài yì dié'], hint: 'Zhāng Fēi chī dòuyá — xiǎo cài yì dié'),
    CourseItem(prompt: 'A dumb person eating huanglian (bitter herb) — …suffering he cannot voice.', answer: '哑巴吃黄连——**有苦说不出**', accepted: ['yǒu kǔ shuō bu chū'], hint: 'yǎba chī huánglián — yǒu kǔ shuō bu chū'),
    CourseItem(prompt: 'The weasel pays a New Year call to the hen — …with no good intentions.', answer: '黄鼠狼给鸡拜年——**没安好心**', accepted: ['méi ān hǎo xīn'], hint: 'huángshǔláng gěi jī bàinián — méi ān hǎo xīn'),
    CourseItem(prompt: 'This job? Piece of cake — like Zhang Fei eating bean sprouts.', answer: '这活儿对他来说是张飞吃豆芽——**小菜一碟**。', accepted: ['xiǎo cài yì dié'], hint: 'zhè huór duì tā lái shuō shì… xiǎo cài yì dié'),
  ],
);

final QuizContent enZhC21SpeakProsody = enZhSpeak(
  id: 'en_zh_c2_1_speak_prosody',
  title: 'Speaking: prosody & attitude',
  intro:
      'The same words, different music: irony, warmth, impatience. Copy the '
      'voice\'s attitude, not just its syllables.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Attitude lives in tempo & weight (Z6)',
      text: 'Mandarin irony stretches syllables (是——吗?), warmth softens '
          'and speeds, impatience clips. The tones stay; the music around '
          'them changes.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Shì ma? (flat: neutral curiosity) — Oh, really?', answer: '是吗？'),
    CourseItem(prompt: 'Shì——ma? (stretched: pure irony) — Oh, REALLY?', answer: '是——吗？'),
    CourseItem(prompt: 'Nǐ kě suàn lái le! — Finally, you\'re here! (warm relief)', answer: '你可算来了！'),
    CourseItem(prompt: 'Xíng xíng xíng, dōu tīng nǐ de. — Fine, fine, fine — have it your way. (surrender)', answer: '行行行，都听你的。'),
    CourseItem(prompt: 'Tā ya, jiù shì dāozi zuǐ, dòufu xīn. — Her? Knife mouth, tofu heart. (fond)', answer: '她呀，就是刀子嘴，豆腐心。'),
  ],
);

final QuizContent enZhC21AspectNuance = enZhFill(
  id: 'en_zh_c2_1_aspect_nuance',
  title: 'Aspect at C2: 了 / 着 / 过 nuance',
  intro:
      'The final pass on the aspect system: double 了, 过 vs 了 in near-'
      'identical sentences, and 着 in commands and warnings.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚠️ The ceiling cases (Z14/Z15/Z16)',
      text: '我在北京住了三年 (closed chapter — I no longer do) vs 住了三年了 '
          '(still there). 去了 reports; 去过 credits experience. 拿着! (hold '
          'it!) — 着 keeps a command\'s result in force.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I lived in Beijing for three years (and still do — double 了).', answer: '我在北京住了三年**了**。', accepted: ['le'], hint: 'wǒ zài Běijīng zhù le sān nián le'),
    CourseItem(prompt: 'I lived in Beijing for three years (a closed chapter — one 了).', answer: '我在北京住**了**三年。', accepted: ['le'], hint: 'wǒ zài Běijīng zhù le sān nián'),
    CourseItem(prompt: 'She has been to Xinjiang (experience credit).', answer: '她去**过**新疆。', accepted: ['guo', 'guò'], hint: 'tā qù guo Xīnjiāng'),
    CourseItem(prompt: 'Hold it — don\'t let go! (着 in a command)', answer: '拿**着**，别松手！', accepted: ['zhe'], hint: 'ná zhe, bié sōngshǒu'),
    CourseItem(prompt: 'The meeting is (in the middle of being) held — 开着 state.', answer: '会正开**着**呢，小声点儿。', accepted: ['zhe'], hint: 'huì zhèng kāi zhe ne, xiǎoshēng diǎnr'),
    CourseItem(prompt: 'By the time I arrived, the film had (already) started. (就…了)', answer: '我到的时候，电影已经开始**了**。', accepted: ['le'], hint: 'wǒ dào de shíhou, diànyǐng yǐjīng kāishǐ le'),
  ],
);

final QuizContent enZhC21ListenLiterary = enZhListen(
  id: 'en_zh_c2_1_listen_literary',
  title: 'Listening: 文学朗读',
  passageTitle: '朗读：《家乡的秋》（散文节选）',
  passage:
      '在我的记忆里，家乡的秋天是有味道的。\n'
      '是院子里桂花的甜香，混着新收的稻谷味儿；'
      '是母亲晒在竹竿上的辣椒，红得晃眼，辣得呛人。\n'
      '那时候，日子过得慢。邮递员的自行车铃一响，半条街的人都探出头来；'
      '一封信，要读三遍：自己读一遍，念给奶奶听一遍，'
      '晚上躺在床上，在心里再读一遍。\n'
      '如今我住在城里，秋天来了，只是手机上的一条消息："今日立秋。"'
      '我常想，我们得到了整个世界的消息，却弄丢了自己院子里的桂花香。',
  passageTranslation:
      'Reading: "Autumn in My Hometown" (prose excerpt)\n'
      'In my memory, autumn in my hometown had a smell. It was the sweet '
      'scent of osmanthus in the courtyard mixed with newly harvested rice; '
      'it was the chilies my mother dried on bamboo poles — dazzling red, '
      'chokingly hot.\n'
      'Days passed slowly then. When the postman\'s bicycle bell rang, half '
      'the street leaned out. A letter got read three times: once to '
      'yourself, once aloud to grandma, and once more at night, lying in '
      'bed, in your heart.\n'
      'Now I live in the city, and autumn arrives as a phone notification: '
      '"Autumn begins today." I often think: we have gained the whole world\'s '
      'news, and lost the scent of osmanthus in our own courtyard.',
  intro:
      'Literary prose read aloud — images, rhythm, and a closing antithesis. '
      'Listen once with eyes closed; comprehension questions after.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '得到…却弄丢…',
      text: 'The closing frame: gained X, yet lost Y. 却 is the literary '
          '"yet" — a hinge you\'ll hear in every reflective essay.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '在作者的记忆里，家乡的秋天有什么味道？',
      options: ['桂花香和稻谷味', '咖啡香', '海水味'],
      correctIndex: 0,
      questionTranslation: 'What did hometown autumn smell of, in the author\'s memory?',
    ),
    ReadingQuestion(
      question: '那时候一封信要读几遍？',
      options: ['三遍', '一遍', '五遍'],
      correctIndex: 0,
      questionTranslation: 'How many times did a letter get read back then?',
    ),
    ReadingQuestion(
      question: '如今秋天怎么"来"？',
      options: ['手机上的一条消息', '桂花开了', '邮递员送信'],
      correctIndex: 0,
      questionTranslation: 'How does autumn "arrive" now?',
    ),
  ],
);

final QuizContent enZhC21DictNuance = enZhDict(
  id: 'en_zh_c2_1_dict_nuance',
  title: 'Dictation: nuanced lines',
  intro:
      'Literary and idiomatic lines at natural pace — every particle and '
      'every four-character phrase in its place.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 成语 type as units',
      text: 'Type the whole idiom\'s pinyin in one go (guigenjiedi) — the '
          'IME knows 归根结底. Typing character by character is how the '
          'wrong homophones sneak in.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'In the final analysis, this is a question of attitude.', answer: '归根结底，这是态度问题。'),
    CourseItem(prompt: 'Even he couldn\'t solve this problem.', answer: '连他都解决不了这个问题。'),
    CourseItem(prompt: 'However busy, I absolutely must go.', answer: '再忙我也非去不可。'),
    CourseItem(prompt: 'I\'ve been living in Beijing for three years (and counting).', answer: '我在北京住了三年了。'),
    CourseItem(prompt: 'Undeniably, the two complement each other.', answer: '无可否认，两者相辅相成。'),
  ],
);

final QuizContent enZhC21ReadReview = enZhRead(
  id: 'en_zh_c2_1_read_review',
  title: 'Reading: 一篇书评',
  passageTitle: '书评：《深夜食堂里的中国》',
  passage:
      '这本书的书名起得极好，好到让人担心内容配不上它。'
      '读完之后可以放心了：担心是多余的——内容比书名还好。\n'
      '作者花了五年时间，走访了三十个城市的夜宵摊。'
      '他写烤串，写馄饨，写凌晨三点的一碗热汤面，'
      '但归根结底，他写的是人：下了夜班的护士，刚吵完架的小两口，'
      '把一天的委屈就着啤酒咽下去的中年人。'
      '文字平实，却处处见功夫——没有一个字在炫技，也没有一个字是多余的。\n'
      '当然，书也并非无可挑剔。后三分之一略显重复，'
      '几个城市的故事读起来大同小异。'
      '但瑕不掩瑜：在人人都写"大时代"的今天，'
      '有人愿意蹲下来，认认真真地写一碗面，这本身就值得敬佩。',
  passageTranslation:
      'Book review: "China at the Midnight Diner"\n'
      'The title is so good you worry the book can\'t live up to it. Having '
      'finished it, you can relax: the worry was superfluous — the book is '
      'better than its title.\n'
      'The author spent five years visiting late-night food stalls in thirty '
      'cities. He writes skewers, wontons, a bowl of hot noodle soup at 3 '
      'a.m. — but in the end he writes people: the nurse coming off a night '
      'shift, the young couple fresh from a quarrel, the middle-aged man '
      'washing the day\'s grievances down with beer. The prose is plain yet '
      'masterful everywhere — not one character shows off, and not one is '
      'wasted.\n'
      'The book isn\'t beyond criticism, of course. The final third feels '
      'repetitive; several cities\' stories read much the same. But the flaw '
      'doesn\'t obscure the jade: in an age when everyone writes "the great '
      'era", someone willing to crouch down and write one bowl of noodles '
      'with full seriousness deserves respect in itself.',
  intro:
      'A book review with a personality: ironic opener, concrete praise, an '
      'honest flaw, and 成语 (瑕不掩瑜, 大同小异) earning their keep.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '瑕不掩瑜',
      text: '"The flaw doesn\'t hide the jade\'s luster" — THE set phrase for '
          'balanced reviews: acknowledge the defect, keep the praise (Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '作者花了多长时间走访夜宵摊？',
      options: ['五年', '三年', '一年'],
      correctIndex: 0,
      questionTranslation: 'How long did the author spend visiting night stalls?',
    ),
    ReadingQuestion(
      question: '书评认为这本书归根结底写的是什么？',
      options: ['人', '菜', '城市'],
      correctIndex: 0,
      questionTranslation: 'What does the review say the book is ultimately about?',
    ),
    ReadingQuestion(
      question: '"瑕不掩瑜"在这里是什么意思？',
      options: ['缺点掩盖不了优点', '这本书没有缺点', '优点很少'],
      correctIndex: 0,
      questionTranslation: 'What does "the flaw doesn\'t hide the jade" mean here?',
    ),
  ],
);

final QuizContent enZhC21Precision = enZhFill(
  id: 'en_zh_c2_1_precision',
  title: 'Precision pairs: 发挥/发扬, 度过/渡过',
  intro:
      'The last mile of vocabulary: pairs split by collocation alone. 发挥 '
      'abilities, 发扬 traditions; 度过 time, 渡过 crises.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Collocation is the meaning',
      text: '发挥作用/水平 (bring into play) vs 发扬传统/精神 (carry '
          'forward); 度过假期 (spend) vs 渡过难关 (weather — note the water '
          'radical for crossing rivers/crises).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'to bring one\'s abilities into (full) play', answer: '**发挥**自己的水平', accepted: ['fāhuī'], hint: 'fāhuī zìjǐ de shuǐpíng'),
    CourseItem(prompt: 'to carry forward the fine tradition', answer: '**发扬**优良传统', accepted: ['fāyáng'], hint: 'fāyáng yōuliáng chuántǒng'),
    CourseItem(prompt: 'to spend a pleasant holiday', answer: '**度过**了一个愉快的假期', accepted: ['dùguò'], hint: 'dùguò le yí ge yúkuài de jiàqī'),
    CourseItem(prompt: 'to weather the crisis (water radical!)', answer: '**渡过**难关', accepted: ['dùguò'], hint: 'dùguò nánguān'),
    CourseItem(prompt: 'to raise (improve) efficiency', answer: '**提高**效率', accepted: ['tígāo'], hint: 'tígāo xiàolǜ'),
    CourseItem(prompt: 'to improve (perfect) the system', answer: '**完善**制度', accepted: ['wánshàn'], hint: 'wánshàn zhìdù'),
  ],
);

/// C2.1 in chain order.
final List<QuizContent> enZhC2_1 = [
  enZhC21Chengyu1,
  enZhC21Chengyu2,
  enZhC21SpeakStory,
  enZhC21Guanyongyu,
  enZhC21ListenHumor,
  enZhC21Connotation,
  enZhC21Marked,
  enZhC21ReadSatire,
  enZhC21Xiehouyu,
  enZhC21SpeakProsody,
  enZhC21AspectNuance,
  enZhC21ListenLiterary,
  enZhC21DictNuance,
  enZhC21ReadReview,
  enZhC21Precision,
];
