import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// B1.1 — Results & Directions · 结果与方向 (HSK 3a). English → Mandarin.
///
/// Big rocks: complements — the "landing" after the verb that English lacks
/// (Z21: resultative 完/到/懂, directional 来/去), duration AFTER the verb
/// (Z13 extended), the three de 的/得/地 (Z20, with the course's first inline
/// big-text cloze), and paired connectives that keep BOTH halves (Z25).

final QuizContent enZhB11Result1 = enZhFill(
  id: 'en_zh_b1_1_result_1',
  title: 'Verbs need a landing: 完 / 到 / 懂',
  intro:
      '找 is to look — 找到 is to find. Chinese verbs describe the attempt; a '
      'result complement lands them: 完 finished, 到 attained, 懂 understood.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Verb + landing (Z21)',
      text: 'English packs result into the verb (find, hear); Chinese splits '
          'it: 找 look + 到 = find; 听 listen + 懂 = understand (by ear); 吃 '
          'eat + 完 = finish eating.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'The landing takes the 了',
      text: '我看完了这本书 — the ✓-stamp follows the whole verb+landing '
          'unit: 看完了, 找到了, 听懂了.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I finished reading this book.', answer: '我看**完**了这本书。', accepted: ['wán'], hint: 'wǒ kàn wán le zhè běn shū'),
    CourseItem(prompt: 'I found my phone!', answer: '我找**到**了我的手机！', accepted: ['dào'], hint: 'wǒ zhǎo dào le wǒ de shǒujī'),
    CourseItem(prompt: 'Did you understand (by listening)?', answer: '你听**懂**了吗？', accepted: ['dǒng'], hint: 'nǐ tīng dǒng le ma'),
    CourseItem(prompt: 'We finished eating.', answer: '我们吃**完**了。', accepted: ['wán'], hint: 'wǒmen chī wán le'),
    CourseItem(prompt: 'I understood this book. (by reading)', answer: '我看**懂**了这本书。', accepted: ['dǒng'], hint: 'wǒ kàn dǒng le zhè běn shū'),
    CourseItem(prompt: 'He bought (managed to get) the ticket.', answer: '他买**到**了票。', accepted: ['dào'], hint: 'tā mǎi dào le piào'),
    CourseItem(prompt: 'She finished writing her homework.', answer: '她写**完**了作业。', accepted: ['wán'], hint: 'tā xiě wán le zuòyè'),
    CourseItem(prompt: 'He found a good job.', answer: '他找**到**了一个好工作。', accepted: ['dào'], hint: 'tā zhǎo dào le yí ge hǎo gōngzuò'),
    CourseItem(prompt: 'Did you understand (by reading)?', answer: '你看**懂**了吗？', accepted: ['dǒng'], hint: 'nǐ kàn dǒng le ma'),
    CourseItem(prompt: 'We finished watching the film.', answer: '我们看**完**了电影。', accepted: ['wán'], hint: 'wǒmen kàn wán le diànyǐng'),
    CourseItem(prompt: 'I finally understood what she meant. (by listening)', answer: '我终于听**懂**了她的意思。', accepted: ['dǒng'], hint: 'wǒ zhōngyú tīng dǒng le tā de yìsi'),
    CourseItem(prompt: 'Did you find the restaurant?', answer: '你找**到**那个饭馆了吗？', accepted: ['dào'], hint: 'nǐ zhǎo dào nà ge fànguǎn le ma'),
    CourseItem(prompt: 'Drink up your soup! (finish drinking)', answer: '把汤喝**完**！', accepted: ['wán'], hint: 'bǎ tāng hē wán'),
    CourseItem(prompt: 'I received your letter. (receive = 收到)', answer: '我收**到**了你的信。', accepted: ['dào'], hint: 'wǒ shōu dào le nǐ de xìn'),
    CourseItem(prompt: 'She finished speaking and went out.', answer: '她说**完**就出去了。', accepted: ['wán'], hint: 'tā shuō wán jiù chūqù le'),
  ],
);

final QuizContent enZhB11Result2 = enZhFill(
  id: 'en_zh_b1_1_result_2',
  title: 'More landings: 见 / 好 / 错 — and 没 V 完',
  intro:
      '见 registers perception (看见 see, 听见 hear), 好 means done-and-ready, '
      '错 means wrongly. Negate a missed result with 没: 我没听懂.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '没 + verb + landing (Z21/Z17)',
      text: 'The result didn\'t happen → 没, and the 了 goes: 我没看见他 I '
          'didn\'t see him; 我还没做完 I\'m not done yet.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '错 = did it, but wrongly',
      text: '我说错了 I misspoke; 你打错了 wrong number. The action happened — '
          'the landing says it went wrong.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I saw him. (see = look + register)', answer: '我看**见**他了。', accepted: ['jiàn'], hint: 'wǒ kàn jiàn tā le'),
    CourseItem(prompt: 'I didn\'t hear (register) it.', answer: '我没听**见**。', accepted: ['jiàn'], hint: 'wǒ méi tīng jiàn'),
    CourseItem(prompt: 'The food is ready. (done-and-good)', answer: '饭做**好**了。', accepted: ['hǎo'], hint: 'fàn zuò hǎo le'),
    CourseItem(prompt: 'You wrote this character wrongly.', answer: '你写**错**了这个字。', accepted: ['cuò'], hint: 'nǐ xiě cuò le zhè ge zì'),
    CourseItem(prompt: 'I haven\'t finished my homework yet.', answer: '我还**没**做完作业。', accepted: ['méi'], hint: 'wǒ hái méi zuò wán zuòyè'),
    CourseItem(prompt: 'Sorry, you\'ve called the wrong number.', answer: '对不起，你打**错**了。', accepted: ['cuò'], hint: 'duìbuqǐ, nǐ dǎ cuò le'),
    CourseItem(prompt: 'I heard (registered) it.', answer: '我听**见**了。', accepted: ['jiàn'], hint: 'wǒ tīng jiàn le'),
    CourseItem(prompt: 'You said it wrong.', answer: '你说**错**了。', accepted: ['cuò'], hint: 'nǐ shuō cuò le'),
    CourseItem(prompt: 'The homework is done. (done-and-good)', answer: '作业做**好**了。', accepted: ['hǎo'], hint: 'zuòyè zuò hǎo le'),
    CourseItem(prompt: 'He hasn\'t finished eating yet.', answer: '他还**没**吃完。', accepted: ['méi'], hint: 'tā hái méi chī wán'),
    CourseItem(prompt: 'Did you see (register) my keys?', answer: '你看**见**我的钥匙了吗？', accepted: ['jiàn'], hint: 'nǐ kàn jiàn wǒ de yàoshi le ma'),
    CourseItem(prompt: 'I got on the wrong bus. (sit wrongly)', answer: '我坐**错**车了。', accepted: ['cuò'], hint: 'wǒ zuò cuò chē le'),
    CourseItem(prompt: 'Get ready — we\'re leaving right away. (prepare + 好)', answer: '准备**好**，我们马上走。', accepted: ['hǎo'], hint: 'zhǔnbèi hǎo, wǒmen mǎshàng zǒu'),
    CourseItem(prompt: 'She didn\'t see (register) the teacher.', answer: '她**没**看见老师。', accepted: ['méi'], hint: 'tā méi kàn jiàn lǎoshī'),
    CourseItem(prompt: 'You bought the wrong book.', answer: '你买**错**书了。', accepted: ['cuò'], hint: 'nǐ mǎi cuò shū le'),
  ],
);

final QuizContent enZhB11SpeakResults = enZhSpeak(
  id: 'en_zh_b1_1_speak_results',
  title: 'Speaking: verb + landing drills',
  intro:
      'Drill the verb-landing pairs aloud until they feel like single words — '
      'because to a Chinese ear, they are.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Stress the landing',
      text: 'The complement carries the news: 找到了! (FOUND it), 听懂了! '
          '(GOT it). Let your voice land on the landing (Z21).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wǒ zhǎo dào le! — I found it!', answer: '我找到了！'),
    CourseItem(prompt: 'Wǒ tīng dǒng le. — I understood (hearing it).', answer: '我听懂了。'),
    CourseItem(prompt: 'Wǒ hái méi kàn wán. — I haven\'t finished reading it.', answer: '我还没看完。'),
    CourseItem(prompt: 'Fàn zuò hǎo le, chīfàn ba! — Food\'s ready, let\'s eat!', answer: '饭做好了，吃饭吧！'),
    CourseItem(prompt: 'Duìbuqǐ, wǒ shuō cuò le. — Sorry, I said it wrong.', answer: '对不起，我说错了。'),
    CourseItem(prompt: 'Nǐ kàn jiàn wǒ de yàoshi le ma? — Have you seen my keys?', answer: '你看见我的钥匙了吗？'),
  ],
);

final QuizContent enZhB11Direction = enZhFill(
  id: 'en_zh_b1_1_direction',
  title: 'Direction: verb + 来 / 去',
  intro:
      '来 = toward me, 去 = away from me. Glued after motion verbs they give '
      'English\'s "in/out/up/back": 进来 come in, 出去 go out, 回来 come back.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The speaker is the compass (Z21)',
      text: 'Every direction is measured from where YOU stand: 上来 up '
          '(toward me), 上去 up (away). Change where you stand and 来/去 '
          'swap.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Places squeeze in the middle',
      text: 'With a place, it slots before 来/去: 回家去, 进教室来 — never '
          'after: 回去家 ✗.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Come in! (enter + toward me)', answer: '请**进来**！', accepted: ['jìnlái', 'jin lai'], hint: 'qǐng jìnlái'),
    CourseItem(prompt: 'He went out. (exit + away)', answer: '他**出去**了。', accepted: ['chūqù', 'chu qu'], hint: 'tā chūqù le'),
    CourseItem(prompt: 'She came back.', answer: '她**回来**了。', accepted: ['huílái'], hint: 'tā huílái le'),
    CourseItem(prompt: 'Please bring the tea over (here). (拿 = carry)', answer: '请把茶**拿来**。', accepted: ['nálái', 'na lai'], hint: 'qǐng bǎ chá nálái'),
    CourseItem(prompt: 'He went upstairs. (up + away from me, downstairs)', answer: '他**上去**了。', accepted: ['shàngqù'], hint: 'tā shàngqù le'),
    CourseItem(prompt: 'Tom went back home. (place in the middle!)', answer: '汤姆**回家去**了。', accepted: ['huí jiā qù'], hint: 'Tāngmǔ huí jiā qù le'),
    CourseItem(prompt: 'Come down! (down + toward me)', answer: '你**下来**吧！', accepted: ['xiàlái', 'xia lai'], hint: 'nǐ xiàlái ba'),
    CourseItem(prompt: 'She went in. (enter + away)', answer: '她**进去**了。', accepted: ['jìnqù', 'jin qu'], hint: 'tā jìnqù le'),
    CourseItem(prompt: 'The teacher came in.', answer: '老师**进来**了。', accepted: ['jìnlái', 'jin lai'], hint: 'lǎoshī jìnlái le'),
    CourseItem(prompt: 'Please take the medicine over (there).', answer: '请把药**拿去**。', accepted: ['náqù', 'na qu'], hint: 'qǐng bǎ yào náqù'),
    CourseItem(prompt: 'He ran out. (run + exit + away)', answer: '他跑**出去**了。', accepted: ['chūqù', 'chu qu'], hint: 'tā pǎo chūqù le'),
    CourseItem(prompt: 'She walked over (toward me). (walk + 过来)', answer: '她走**过来**了。', accepted: ['guòlái', 'guo lai'], hint: 'tā zǒu guòlái le'),
    CourseItem(prompt: 'Dad came downstairs. (down + toward me)', answer: '爸爸**下来**了。', accepted: ['xiàlái', 'xia lai'], hint: 'bàba xiàlái le'),
    CourseItem(prompt: 'Bring a cup of tea up (to me upstairs). (拿 + up + toward)', answer: '请**拿上来**一杯茶。', accepted: ['ná shànglái', 'na shang lai'], hint: 'qǐng ná shànglái yì bēi chá'),
    CourseItem(prompt: 'The cat jumped in (through the window, toward me). (jump = 跳)', answer: '猫跳**进来**了。', accepted: ['jìnlái', 'jin lai'], hint: 'māo tiào jìnlái le'),
  ],
);

final QuizContent enZhB11ListenHospital = enZhListen(
  id: 'en_zh_b1_1_listen_hospital',
  title: 'Listening: 去医院',
  passageTitle: '汤姆去医院',
  passage:
      '汤姆早上起床的时候，觉得头很疼。他没去上课，去了医院。'
      '医生看了看，说："你感冒了。回家好好休息，多喝水，吃这个药。"'
      '汤姆听懂了医生的话，买了药就回家了。'
      '下午小美打电话问他："你好点儿了吗？"汤姆说："好多了，谢谢！"',
  passageTranslation:
      'Tāngmǔ zǎoshang qǐchuáng de shíhou, juéde tóu hěn téng. Tā méi qù '
      'shàngkè, qù le yīyuàn. Yīshēng kàn le kàn, shuō: "Nǐ gǎnmào le. Huí jiā '
      'hǎohāo xiūxi, duō hē shuǐ, chī zhè ge yào." Tāngmǔ tīng dǒng le '
      'yīshēng de huà, mǎi le yào jiù huí jiā le. Xiàwǔ Xiǎoměi dǎ diànhuà wèn '
      'tā: "Nǐ hǎo diǎnr le ma?" Tāngmǔ shuō: "Hǎo duō le, xièxie!"\n\n'
      'When Tom got up in the morning, his head hurt. He didn\'t go to class — '
      'he went to the hospital. The doctor had a look and said: "You\'ve '
      'caught a cold. Go home and rest properly, drink lots of water, take '
      'this medicine." Tom understood the doctor, bought the medicine and went '
      'straight home. In the afternoon Xiaomei phoned to ask: "Are you '
      'feeling a bit better?" Tom said: "Much better, thanks!"',
  intro:
      'Tom gets sick. Listen for the landings — 听懂了, 好点儿了, 好多了 — '
      'they carry the story\'s progress.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '好点儿了 / 好多了',
      text: 'Recovery in two sizes: 好(一)点儿了 a bit better, 好多了 much '
          'better — comparison + change-了 in one phrase.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆哪儿不舒服？',
      options: ['头疼', '肚子疼', '脚疼'],
      correctIndex: 0,
      questionTranslation: 'What is hurting Tom?',
    ),
    ReadingQuestion(
      question: '医生让汤姆做什么？',
      options: ['去上课', '回家休息、多喝水', '去跑步'],
      correctIndex: 1,
      questionTranslation: 'What does the doctor tell Tom to do?',
    ),
    ReadingQuestion(
      question: '下午汤姆怎么样了？',
      options: ['更疼了', '好多了', '没有变化'],
      correctIndex: 1,
      questionTranslation: 'How is Tom in the afternoon?',
    ),
  ],
);

final QuizContent enZhB11Duration = enZhFill(
  id: 'en_zh_b1_1_duration',
  title: 'Duration AFTER the verb',
  intro:
      'When something happens goes BEFORE the verb; how long it lasts goes '
      'AFTER: 我学了三年中文 — I studied Chinese for three years.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚠️ WHEN before, HOW-LONG after (Z13)',
      text: '我昨天(when)睡了十个小时(how long). Point in time = scene-setting '
          '→ front. Amount of time = result-like → after the verb.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Still going on? Double 了',
      text: '我学了三年了 — the second 了 says the three years reach into '
          'now: "…and counting". One 了 = a closed chapter.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I studied Chinese for three years.', answer: '我学了**三年**中文。', accepted: ['sān nián'], hint: 'wǒ xué le sān nián Zhōngwén'),
    CourseItem(prompt: 'He slept for ten hours.', answer: '他睡了**十个小时**。', accepted: ['shí ge xiǎoshí'], hint: 'tā shuì le shí ge xiǎoshí'),
    CourseItem(prompt: 'We waited for twenty minutes.', answer: '我们等了**二十分钟**。', accepted: ['èrshí fēnzhōng'], hint: 'wǒmen děng le èrshí fēnzhōng'),
    CourseItem(prompt: 'She lived in Beijing for two years.', answer: '她在北京住了**两年**。', accepted: ['liǎng nián'], hint: 'tā zài Běijīng zhù le liǎng nián'),
    CourseItem(prompt: 'I\'ve been studying Chinese for a year (and counting).', answer: '我学中文学了一年**了**。', accepted: ['le'], hint: 'wǒ xué Zhōngwén xué le yì nián le'),
    CourseItem(prompt: 'How long did you watch TV?', answer: '你看了**多长时间**电视？', accepted: ['duō cháng shíjiān'], hint: 'nǐ kàn le duō cháng shíjiān diànshì'),
    CourseItem(prompt: 'He worked for eight hours.', answer: '他工作了**八个小时**。', accepted: ['bā ge xiǎoshí'], hint: 'tā gōngzuò le bā ge xiǎoshí'),
    CourseItem(prompt: 'I slept for six hours last night.', answer: '我昨天晚上睡了**六个小时**。', accepted: ['liù ge xiǎoshí'], hint: 'wǒ zuótiān wǎnshang shuì le liù ge xiǎoshí'),
    CourseItem(prompt: 'She waited for half an hour. (半个小时)', answer: '她等了**半个小时**。', accepted: ['bàn ge xiǎoshí'], hint: 'tā děng le bàn ge xiǎoshí'),
    CourseItem(prompt: 'We lived in Shanghai for five years.', answer: '我们在上海住了**五年**。', accepted: ['wǔ nián'], hint: 'wǒmen zài Shànghǎi zhù le wǔ nián'),
    CourseItem(prompt: 'I ran for forty minutes this morning.', answer: '我今天早上跑了**四十分钟**。', accepted: ['sìshí fēnzhōng'], hint: 'wǒ jīntiān zǎoshang pǎo le sìshí fēnzhōng'),
    CourseItem(prompt: 'He has been working for ten years (and counting).', answer: '他工作了十年**了**。', accepted: ['le'], hint: 'tā gōngzuò le shí nián le'),
    CourseItem(prompt: 'How long did you live in China?', answer: '你在中国住了**多长时间**？', accepted: ['duō cháng shíjiān'], hint: 'nǐ zài Zhōngguó zhù le duō cháng shíjiān'),
    CourseItem(prompt: 'She studied Chinese for a year and studied it very well. (repeat the verb)', answer: '她学中文学了**一年**，学得很好。', accepted: ['yì nián'], hint: 'tā xué Zhōngwén xué le yì nián, xué de hěn hǎo'),
    CourseItem(prompt: 'We talked for two hours. (talk = 聊)', answer: '我们聊了**两个小时**。', accepted: ['liǎng ge xiǎoshí'], hint: 'wǒmen liáo le liǎng ge xiǎoshí'),
  ],
);

final QuizContent enZhB11DeDeDe = enZhFill(
  id: 'en_zh_b1_1_de_de_de',
  title: '的 / 得 / 地 — one sound, three jobs',
  intro:
      'All three are pronounced de. 的 clips descriptions to nouns, 得 grades '
      'how a verb went, 地 turns adjectives into adverbs before the verb.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ noun-的 · how-it-went-得 · how-you-do-it-地 (Z20)',
      text: 'Before a NOUN → 的 (红色的车). After a VERB, grading it → 得 '
          '(说得很好). Before a VERB, styling it → 地 (慢慢地走). Ask what '
          'the de touches.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'One frame, three de',
      text: '他是很好的老师 · 他教得很好 · 他认真地教 — same teacher, three '
          'different de.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'my Chinese teacher (description + noun)', answer: '我**的**中文老师', accepted: ['de'], hint: 'wǒ de Zhōngwén lǎoshī'),
    CourseItem(prompt: 'He speaks (Chinese) very well. (grade the verb)', answer: '他说**得**很好。', accepted: ['de'], hint: 'tā shuō de hěn hǎo'),
    CourseItem(prompt: 'She walked over slowly. (style the verb)', answer: '她慢慢**地**走过来。', accepted: ['de'], hint: 'tā mànmàn de zǒu guòlái'),
    CourseItem(prompt: 'a very interesting book', answer: '一本很有意思**的**书', accepted: ['de'], hint: 'yì běn hěn yǒuyìsi de shū'),
    CourseItem(prompt: 'He runs fast. (grade)', answer: '他跑**得**很快。', accepted: ['de'], hint: 'tā pǎo de hěn kuài'),
    CourseItem(prompt: 'Listen to the teacher carefully. (style)', answer: '认真**地**听老师说。', accepted: ['de'], hint: 'rènzhēn de tīng lǎoshī shuō'),
    CourseItem(prompt: 'his mum\'s phone (possession)', answer: '他妈妈**的**手机', accepted: ['de'], hint: 'tā māma de shǒujī'),
    CourseItem(prompt: 'She sings very well. (grade the verb)', answer: '她唱**得**很好。', accepted: ['de'], hint: 'tā chàng de hěn hǎo'),
    CourseItem(prompt: 'He happily went home. (style the verb)', answer: '他高兴**地**回家了。', accepted: ['de'], hint: 'tā gāoxìng de huí jiā le'),
    CourseItem(prompt: 'very pretty clothes (description + noun)', answer: '很漂亮**的**衣服', accepted: ['de'], hint: 'hěn piàoliang de yīfu'),
    CourseItem(prompt: 'She quietly closed the door. (style; quiet = 轻轻)', answer: '她轻轻**地**关上了门。', accepted: ['de'], hint: 'tā qīngqīng de guān shàng le mén'),
    CourseItem(prompt: 'He drives very slowly. (grade)', answer: '他开车开**得**很慢。', accepted: ['de'], hint: 'tā kāichē kāi de hěn màn'),
    CourseItem(prompt: 'the book I bought yesterday (clause + noun)', answer: '我昨天买**的**书', accepted: ['de'], hint: 'wǒ zuótiān mǎi de shū'),
    CourseItem(prompt: 'They happily sang songs. (style)', answer: '他们高兴**地**唱歌。', accepted: ['de'], hint: 'tāmen gāoxìng de chànggē'),
    CourseItem(prompt: 'You slept very late. (grade)', answer: '你睡**得**很晚。', accepted: ['de'], hint: 'nǐ shuì de hěn wǎn'),
  ],
);

final QuizContent enZhB11Degree = enZhFill(
  id: 'en_zh_b1_1_degree',
  title: '得 — grading the result',
  intro:
      'Verb + 得 + evaluation is how Chinese says "well/badly/fast/late": '
      '他说得很好. With an object, repeat the verb: 她说中文说得很好.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'V + O, V + 得 + grade (Z20/Z21)',
      text: 'Object in the sentence? Say the verb twice: 她**写**字**写得**'
          '很漂亮. The first verb carries the object, the second carries the '
          'grade.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He speaks very well.', answer: '他说**得**很好。', accepted: ['de'], hint: 'tā shuō de hěn hǎo'),
    CourseItem(prompt: 'She speaks Chinese very well. (repeat the verb)', answer: '她说中文**说得**很好。', accepted: ['shuō de'], hint: 'tā shuō Zhōngwén shuō de hěn hǎo'),
    CourseItem(prompt: 'You came too late.', answer: '你来**得**太晚了。', accepted: ['de'], hint: 'nǐ lái de tài wǎn le'),
    CourseItem(prompt: 'He writes characters beautifully.', answer: '他写字写**得**很漂亮。', accepted: ['de'], hint: 'tā xiě zì xiě de hěn piàoliang'),
    CourseItem(prompt: 'They ate very happily.', answer: '他们吃**得**很高兴。', accepted: ['de'], hint: 'tāmen chī de hěn gāoxìng'),
    CourseItem(prompt: 'How did you sleep? (slept how?)', answer: '你睡**得**怎么样？', accepted: ['de'], hint: 'nǐ shuì de zěnmeyàng'),
    CourseItem(prompt: 'He eats very fast.', answer: '他吃**得**很快。', accepted: ['de'], hint: 'tā chī de hěn kuài'),
    CourseItem(prompt: 'You speak too fast.', answer: '你说**得**太快了。', accepted: ['de'], hint: 'nǐ shuō de tài kuài le'),
    CourseItem(prompt: 'They played very happily. (玩)', answer: '他们玩**得**很高兴。', accepted: ['de'], hint: 'tāmen wán de hěn gāoxìng'),
    CourseItem(prompt: 'She sings songs very well. (repeat the verb)', answer: '她唱歌**唱得**很好。', accepted: ['chàng de'], hint: 'tā chànggē chàng de hěn hǎo'),
    CourseItem(prompt: 'My dad cooks really deliciously. (repeat the verb)', answer: '我爸爸做饭**做得**很好吃。', accepted: ['zuò de'], hint: 'wǒ bàba zuòfàn zuò de hěn hǎochī'),
    CourseItem(prompt: 'He got up very early today.', answer: '他今天起**得**很早。', accepted: ['de'], hint: 'tā jīntiān qǐ de hěn zǎo'),
    CourseItem(prompt: 'She writes Chinese characters better than me. (得 + 比)', answer: '她写汉字写**得**比我好。', accepted: ['de'], hint: 'tā xiě Hànzì xiě de bǐ wǒ hǎo'),
    CourseItem(prompt: 'The children ran very fast.', answer: '孩子们跑**得**很快。', accepted: ['de'], hint: 'háizimen pǎo de hěn kuài'),
    CourseItem(prompt: 'How did he do on the exam? (考 + 得)', answer: '他考**得**怎么样？', accepted: ['de'], hint: 'tā kǎo de zěnmeyàng'),
  ],
);

final QuizContent enZhB11ReadLearning = enZhRead(
  id: 'en_zh_b1_1_read_learning',
  title: 'Reading: 学中文的路',
  passageTitle: '学中文的路',
  passage:
      '汤姆学中文学了一年了。开始的时候，他觉得声调太难了，常常说错。'
      '有一次，他想说"我想问你"，可是说成了"我想吻你"，大家都笑了。'
      '现在他听得懂老师说的话，也看得懂简单的中文书。'
      '他每天认真地学习，写字写得越来越漂亮。'
      '王老师说："学外语就是这样：慢慢来，别怕说错。"'
      '汤姆觉得，虽然中文很难，但是他学得很开心。',
  passageTranslation:
      'Tāngmǔ xué Zhōngwén xué le yì nián le. Kāishǐ de shíhou, tā juéde '
      'shēngdiào tài nán le, chángcháng shuō cuò. Yǒu yí cì, tā xiǎng shuō '
      '"wǒ xiǎng wèn nǐ", kěshì shuō chéng le "wǒ xiǎng wěn nǐ", dàjiā dōu '
      'xiào le. Xiànzài tā tīng de dǒng lǎoshī shuō de huà, yě kàn de dǒng '
      'jiǎndān de Zhōngwén shū. Tā měitiān rènzhēn de xuéxí, xiě zì xiě de '
      'yuèláiyuè piàoliang. Wáng lǎoshī shuō: "Xué wàiyǔ jiù shì zhèyàng: '
      'mànmàn lái, bié pà shuō cuò." Tāngmǔ juéde, suīrán Zhōngwén hěn nán, '
      'dànshì tā xué de hěn kāixīn.\n\n'
      'Tom has been learning Chinese for a year now. At the beginning he found '
      'the tones too hard and often misspoke. Once he meant to say "I want to '
      'ask you" (wèn) but said "I want to kiss you" (wěn) — everyone laughed. '
      'Now he can understand what the teacher says and read simple Chinese '
      'books. He studies conscientiously every day, and his characters look '
      'better and better. Teacher Wang says: "That\'s what learning a language '
      'is: take it slowly, don\'t fear mistakes." Tom feels that although '
      'Chinese is hard, he\'s learning it very happily.',
  intro:
      'Tom\'s first year — told with this module\'s whole toolkit: duration, '
      'landings, the three de, and one tone slip that proves why tones matter.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ wèn ≠ wěn',
      text: '问 (ask, 4th tone) vs 吻 (kiss, 3rd tone) — the passage\'s joke '
          'is a real cautionary tale about tones (Z1).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆学中文学了多长时间了？',
      options: ['半年', '一年', '三年'],
      correctIndex: 1,
      questionTranslation: 'How long has Tom been learning Chinese?',
    ),
    ReadingQuestion(
      question: '开始的时候，汤姆觉得什么太难了？',
      options: ['汉字', '声调', '语法'],
      correctIndex: 1,
      questionTranslation: 'What did Tom find too hard at the beginning?',
    ),
    ReadingQuestion(
      question: '汤姆想说"问"，说成了什么？',
      options: ['吻', '完', '晚'],
      correctIndex: 0,
      questionTranslation: 'Tom meant to say "ask" — what did he say instead?',
    ),
  ],
);

final QuizContent enZhB11Pairs = enZhFill(
  id: 'en_zh_b1_1_pairs',
  title: 'Keep BOTH: 因为…所以 / 虽然…但是',
  intro:
      'Chinese connectives come in pairs and keep both halves: 因为 A，所以 B '
      '(because A, so B); 虽然 A，但是 B (although A, but B).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Don\'t drop the second half (Z25)',
      text: 'English "although" bans a following "but" — Chinese REQUIRES it: '
          '虽然贵，**但是**很好. Dropping 但是/所以 sounds broken, not '
          'elegant.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Because it was raining, (so) we didn\'t go out.', answer: '因为下雨了，**所以**我们没出去。', accepted: ['suǒyǐ'], hint: 'yīnwèi xià yǔ le, suǒyǐ wǒmen méi chūqù'),
    CourseItem(prompt: 'Although it\'s expensive, (but) it\'s very good.', answer: '虽然很贵，**但是**很好。', accepted: ['dànshì'], hint: 'suīrán hěn guì, dànshì hěn hǎo'),
    CourseItem(prompt: 'Because I was sick, (so) I didn\'t go to class.', answer: '**因为**我病了，所以没去上课。', accepted: ['yīnwèi'], hint: 'yīnwèi wǒ bìng le, suǒyǐ méi qù shàngkè'),
    CourseItem(prompt: 'Although he is British, (but) he speaks Chinese very well.', answer: '**虽然**他是英国人，但是他中文说得很好。', accepted: ['suīrán'], hint: 'suīrán tā shì Yīngguó rén, dànshì tā Zhōngwén shuō de hěn hǎo'),
    CourseItem(prompt: 'Because the tickets sold out, (so) we watched TV at home.', answer: '因为票卖完了，**所以**我们在家看电视。', accepted: ['suǒyǐ'], hint: 'yīnwèi piào mài wán le, suǒyǐ wǒmen zài jiā kàn diànshì'),
    CourseItem(prompt: 'Because I\'m busy today, (so) I\'m not going.', answer: '因为我今天很忙，**所以**不去了。', accepted: ['suǒyǐ'], hint: 'yīnwèi wǒ jīntiān hěn máng, suǒyǐ bú qù le'),
    CourseItem(prompt: 'Although he is tired, (but) he is still studying.', answer: '虽然他很累，**但是**还在学习。', accepted: ['dànshì'], hint: 'suīrán tā hěn lèi, dànshì hái zài xuéxí'),
    CourseItem(prompt: 'Because Chinese is interesting, (so) I like studying it.', answer: '因为中文很有意思，**所以**我喜欢学。', accepted: ['suǒyǐ'], hint: 'yīnwèi Zhōngwén hěn yǒuyìsi, suǒyǐ wǒ xǐhuan xué'),
    CourseItem(prompt: 'Although this dish is cheap, (but) it is delicious.', answer: '**虽然**这个菜很便宜，但是很好吃。', accepted: ['suīrán'], hint: 'suīrán zhè ge cài hěn piányi, dànshì hěn hǎochī'),
    CourseItem(prompt: 'Because I have no money, (so) I\'m not buying it.', answer: '因为我没有钱，**所以**不买了。', accepted: ['suǒyǐ'], hint: 'yīnwèi wǒ méiyǒu qián, suǒyǐ bù mǎi le'),
    CourseItem(prompt: 'Although she is very young, (but) she speaks very well.', answer: '虽然她很小，**但是**说得很好。', accepted: ['dànshì'], hint: 'suīrán tā hěn xiǎo, dànshì shuō de hěn hǎo'),
    CourseItem(prompt: 'Because the weather is too hot, (so) we didn\'t run.', answer: '因为天气太热了，**所以**我们没跑步。', accepted: ['suǒyǐ'], hint: 'yīnwèi tiānqì tài rè le, suǒyǐ wǒmen méi pǎobù'),
    CourseItem(prompt: 'Although I studied for a year, (but) I still don\'t understand.', answer: '**虽然**我学了一年，但是还没听懂。', accepted: ['suīrán'], hint: 'suīrán wǒ xué le yì nián, dànshì hái méi tīng dǒng'),
    CourseItem(prompt: 'Because he found a good job, (so) he is very happy.', answer: '**因为**他找到了好工作，所以很高兴。', accepted: ['yīnwèi'], hint: 'yīnwèi tā zhǎo dào le hǎo gōngzuò, suǒyǐ hěn gāoxìng'),
    CourseItem(prompt: 'Although the hospital is far, (but) the doctor is very good.', answer: '虽然医院很远，**但是**医生很好。', accepted: ['dànshì'], hint: 'suīrán yīyuàn hěn yuǎn, dànshì yīshēng hěn hǎo'),
  ],
);

final QuizContent enZhB11Health = enZhFill(
  id: 'en_zh_b1_1_health',
  title: 'Health & body',
  intro:
      'Aches, colds and the doctor. The pattern for pain: body part + 疼 — '
      '我头疼, literally "I head-hurt".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'X 疼 = my X hurts',
      text: '头疼 headache, 肚子疼 stomach ache — no "have a" needed: the '
          'body part is the topic and 疼 does the rest (Z28 preview).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I have a headache. (head hurts)', answer: '我**头疼**。', accepted: ['tóu téng'], hint: 'wǒ tóu téng'),
    CourseItem(prompt: 'He has caught a cold.', answer: '他**感冒**了。', accepted: ['gǎnmào'], hint: 'tā gǎnmào le'),
    CourseItem(prompt: 'to see a doctor (look at illness)', answer: '看病', accepted: ['kànbìng'], hint: 'kànbìng'),
    CourseItem(prompt: 'to rest', answer: '休息', accepted: ['xiūxi'], hint: 'xiūxi'),
    CourseItem(prompt: 'medicine (to take: 吃药)', answer: '药', accepted: ['yào'], hint: 'yào'),
    CourseItem(prompt: 'body / health', answer: '身体', accepted: ['shēntǐ'], hint: 'shēntǐ'),
    CourseItem(prompt: 'My stomach hurts.', answer: '我**肚子疼**。', accepted: ['dùzi téng'], hint: 'wǒ dùzi téng'),
    CourseItem(prompt: 'to be sick / fall ill', answer: '生病', accepted: ['shēngbìng'], hint: 'shēngbìng'),
    CourseItem(prompt: 'hospital', answer: '医院', accepted: ['yīyuàn'], hint: 'yīyuàn'),
    CourseItem(prompt: 'My eyes hurt.', answer: '我**眼睛疼**。', accepted: ['yǎnjing téng'], hint: 'wǒ yǎnjing téng'),
    CourseItem(prompt: 'to have a fever (issue heat)', answer: '发烧', accepted: ['fāshāo'], hint: 'fāshāo'),
    CourseItem(prompt: 'to cough', answer: '咳嗽', accepted: ['késou'], hint: 'késou'),
    CourseItem(prompt: 'My throat hurts. (throat = 嗓子)', answer: '我**嗓子疼**。', accepted: ['sǎngzi téng'], hint: 'wǒ sǎngzi téng'),
    CourseItem(prompt: 'healthy (health as adjective)', answer: '健康', accepted: ['jiànkāng'], hint: 'jiànkāng'),
    CourseItem(prompt: 'to take medicine (eat medicine)', answer: '吃药', accepted: ['chī yào', 'chīyào'], hint: 'chī yào'),
  ],
);

final QuizContent enZhB11SpeakRhythm = enZhSpeak(
  id: 'en_zh_b1_1_speak_rhythm',
  title: 'Speaking: longer sentences, steady tones',
  intro:
      'Longer sentences now — keep every syllable\'s tone while the sentence '
      'flows. Chinese rhythm gives each syllable its beat.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Don\'t stress-time it (Z6)',
      text: 'English squeezes unstressed syllables; Chinese gives each '
          'syllable even weight. Resist rushing the "small" words — 了, 的, '
          '得 stay clear (just lighter).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wǒ xué Zhōngwén xué le yì nián le. — I\'ve been learning Chinese for a year.', answer: '我学中文学了一年了。'),
    CourseItem(prompt: 'Tā shuō Zhōngwén shuō de fēicháng hǎo. — She speaks Chinese extremely well.', answer: '她说中文说得非常好。'),
    CourseItem(prompt: 'Yīnwèi wǒ bìng le, suǒyǐ méi qù shàngkè. — Because I was ill, I didn\'t go to class.', answer: '因为我病了，所以没去上课。'),
    CourseItem(prompt: 'Qǐng nǐ mànmàn de shuō, wǒ tīng de dǒng. — Speak slowly please, and I can understand.', answer: '请你慢慢地说，我听得懂。'),
    CourseItem(prompt: 'Suīrán hěn nán, dànshì hěn yǒuyìsi. — Hard, but interesting.', answer: '虽然很难，但是很有意思。'),
  ],
);

final QuizContent enZhB11BigtextDe = enZhBigText(
  id: 'en_zh_b1_1_bigtext_de',
  title: 'Big text: 的/得/地 in a letter',
  passageTitle: '给妈妈的信',
  template:
      '亲爱{{0}}妈妈：\n'
      '你好吗？我在北京过{{1}}很好。我每天认真{{2}}学习中文，'
      '现在说{{3}}比以前好多了。我{{4}}老师姓王，她是一位非常好{{5}}老师。'
      '她说，我写字写{{6}}很漂亮。\n'
      '周末我常常和朋友慢慢{{7}}走过老城，看好看{{8}}房子。\n'
      '我很想你们。\n'
      '你{{9}}儿子，汤姆',
  blanks: [
    particleBlank('的', options: const ['的', '得', '地'], translation: 'dear (adj) + DE + mum → noun-de'),
    particleBlank('得', options: const ['的', '得', '地'], translation: 'live + DE + well → grading the verb'),
    particleBlank('地', options: const ['的', '得', '地'], translation: 'conscientious + DE + study → styling the verb'),
    particleBlank('得', options: const ['的', '得', '地'], translation: 'speak + DE + better → grading'),
    particleBlank('的', options: const ['的', '得', '地'], translation: 'my + DE + teacher → possession'),
    particleBlank('的', options: const ['的', '得', '地'], translation: 'very good + DE + teacher → noun-de'),
    particleBlank('得', options: const ['的', '得', '地'], translation: 'write + DE + beautifully → grading'),
    particleBlank('地', options: const ['的', '得', '地'], translation: 'slowly + DE + walk → styling'),
    particleBlank('的', options: const ['的', '得', '地'], translation: 'good-looking + DE + houses → noun-de'),
    particleBlank('的', options: const ['的', '得', '地'], translation: 'your + DE + son → possession'),
  ],
  passageTranslation:
      'Qīn\'ài de māma: nǐ hǎo ma? Wǒ zài Běijīng guò de hěn hǎo…\n\n'
      'Dear Mum,\n'
      'How are you? I\'m doing very well in Beijing. I study Chinese '
      'conscientiously every day, and I speak much better than before. My '
      'teacher\'s surname is Wang — she\'s a very good teacher. She says my '
      'characters look beautiful. At the weekend I often stroll slowly through '
      'the old town with friends, looking at the lovely houses. I miss you '
      'all. Your son, Tom',
  intro:
      'Tom\'s letter home — with every de removed. Read it once, then choose '
      '的, 得 or 地 for each gap: what does the de touch?',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The three-question test (Z20)',
      text: 'Before a noun? → 的. After a verb, grading how it went? → 得. '
          'Before a verb, styling how it\'s done? → 地. Every gap answers one '
          'of the three.',
    ),
  ],
);

final QuizContent enZhB11ListenAdvice = enZhListen(
  id: 'en_zh_b1_1_listen_advice',
  title: 'Listening: 王老师的建议',
  passageTitle: '王老师的建议',
  passage:
      '很多学生问我，怎么才能学好中文。我想说三件事。'
      '第一，每天都要听，听得越多，懂得越多。'
      '第二，别怕说错。说错了没关系，说得多了，就说得好了。'
      '第三，认真地写汉字。写完一个字，要问自己：我写对了吗？'
      '因为学外语不容易，所以要慢慢来。',
  passageTranslation:
      'Hěn duō xuésheng wèn wǒ, zěnme cái néng xué hǎo Zhōngwén. Wǒ xiǎng shuō '
      'sān jiàn shì. Dì yī, měitiān dōu yào tīng, tīng de yuè duō, dǒng de yuè '
      'duō. Dì èr, bié pà shuō cuò. Shuō cuò le méi guānxi, shuō de duō le, '
      'jiù shuō de hǎo le. Dì sān, rènzhēn de xiě Hànzì. Xiě wán yí ge zì, yào '
      'wèn zìjǐ: wǒ xiě duì le ma? Yīnwèi xué wàiyǔ bù róngyì, suǒyǐ yào '
      'mànmàn lái.\n\n'
      'Many students ask me how to master Chinese. I\'d say three things. '
      'First, listen every day — the more you hear, the more you understand. '
      'Second, don\'t fear mistakes. Misspeaking doesn\'t matter: speak a lot '
      'and you\'ll speak well. Third, write characters carefully. When you '
      'finish one, ask yourself: did I write it right? Learning a language '
      'isn\'t easy, so take it step by step.',
  intro:
      'Teacher Wang\'s three tips — a listening full of landings (学好, 说错, '
      '写完, 写对) and both de-graders.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '第 makes ordinals',
      text: '第一, 第二, 第三 — first, second, third. 第 + number turns any '
          'count into a ranking.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '王老师说了几件事？',
      options: ['两件', '三件', '四件'],
      correctIndex: 1,
      questionTranslation: 'How many points does Teacher Wang make?',
    ),
    ReadingQuestion(
      question: '说错了怎么办？',
      options: ['没关系，多说', '别说了', '去问医生'],
      correctIndex: 0,
      questionTranslation: 'What about making mistakes when speaking?',
    ),
    ReadingQuestion(
      question: '写完一个字，要问自己什么？',
      options: ['我写对了吗？', '我写快了吗？', '我写大了吗？'],
      correctIndex: 0,
      questionTranslation: 'After finishing a character, what should you ask yourself?',
    ),
  ],
);

final QuizContent enZhB11DictStudy = enZhDict(
  id: 'en_zh_b1_1_dict_study',
  title: 'Dictation: 我学了…',
  intro:
      'Type what you hear — durations after the verb, landings on the verbs, '
      'and the right de in the right place.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Your IME writes all three de as "de"',
      text: 'Typing "de" offers 的/得/地 — the sentence\'s grammar picks the '
          'winner, not the first suggestion (Z20).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I studied Chinese for two years.', answer: '我学了两年中文。'),
    CourseItem(prompt: 'She speaks very well.', answer: '她说得很好。'),
    CourseItem(prompt: 'I finished reading this book.', answer: '我看完了这本书。'),
    CourseItem(prompt: 'I didn\'t understand (by listening).', answer: '我没听懂。'),
    CourseItem(prompt: 'Because I\'m ill, I\'m resting at home.', answer: '因为我病了，所以在家休息。'),
    CourseItem(prompt: 'Please speak slowly.', answer: '请慢慢地说。'),
    CourseItem(prompt: 'He slept for ten hours.', answer: '他睡了十个小时。'),
    CourseItem(prompt: 'You said it wrong.', answer: '你说错了。'),
    CourseItem(prompt: 'Although Chinese is hard, it is very interesting.', answer: '虽然中文很难，但是很有意思。'),
    CourseItem(prompt: 'I found my keys.', answer: '我找到了我的钥匙。'),
    CourseItem(prompt: 'He came back.', answer: '他回来了。'),
    CourseItem(prompt: 'We waited for half an hour.', answer: '我们等了半个小时。'),
    CourseItem(prompt: 'The food is ready — come and eat!', answer: '饭做好了，来吃吧！'),
    CourseItem(prompt: 'She writes characters very beautifully.', answer: '她写字写得很漂亮。'),
    CourseItem(prompt: 'I have a headache and a fever.', answer: '我头疼，还发烧。'),
  ],
);

final QuizContent enZhB11ReadSick = enZhRead(
  id: 'en_zh_b1_1_read_sick',
  title: 'Reading: 汤姆病了',
  passageTitle: '汤姆病了',
  passage:
      '上个星期，汤姆病了。他头疼，肚子也疼，两天没去上课。'
      '小美给他买来了药和水果。她说："多休息，多喝水，你很快就会好的。"'
      '汤姆吃了药，睡了十二个小时。第二天，他觉得好多了。'
      '他给小美打电话："谢谢你！因为你的帮助，所以我好得这么快。"'
      '小美笑着说："别客气！朋友就是要互相帮助。"',
  passageTranslation:
      'Shàng ge xīngqī, Tāngmǔ bìng le. Tā tóu téng, dùzi yě téng, liǎng tiān '
      'méi qù shàngkè. Xiǎoměi gěi tā mǎi lái le yào hé shuǐguǒ. Tā shuō: '
      '"Duō xiūxi, duō hē shuǐ, nǐ hěn kuài jiù huì hǎo de." Tāngmǔ chī le '
      'yào, shuì le shí\'èr ge xiǎoshí. Dì èr tiān, tā juéde hǎo duō le. Tā '
      'gěi Xiǎoměi dǎ diànhuà: "Xièxie nǐ! Yīnwèi nǐ de bāngzhù, suǒyǐ wǒ hǎo '
      'de zhème kuài." Xiǎoměi xiào zhe shuō: "Bié kèqi! Péngyou jiù shì yào '
      'hùxiāng bāngzhù."\n\n'
      'Last week Tom fell ill. His head hurt, his stomach too, and he missed '
      'class for two days. Xiaomei bought him medicine and fruit. She said: '
      '"Rest a lot, drink lots of water — you\'ll be better in no time." Tom '
      'took the medicine and slept twelve hours. The next day he felt much '
      'better. He phoned Xiaomei: "Thank you! It\'s thanks to your help that I '
      'got better so fast." Xiaomei said with a smile: "Don\'t mention it! '
      'Friends are there to help each other."',
  intro:
      'The whole module in a story: durations (两天, 十二个小时), landings '
      '(买来), pairs (因为…所以) and a graded 得 (好得这么快).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '买来 = bought & brought',
      text: '买来了药 — the 来 lands the buying at Tom\'s door. Directional '
          'complements sneak onto ordinary verbs everywhere (Z21).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆几天没去上课？',
      options: ['一天', '两天', '三天'],
      correctIndex: 1,
      questionTranslation: 'How many days did Tom miss class?',
    ),
    ReadingQuestion(
      question: '小美给汤姆买来了什么？',
      options: ['药和水果', '咖啡和面包', '书和笔'],
      correctIndex: 0,
      questionTranslation: 'What did Xiaomei buy and bring Tom?',
    ),
    ReadingQuestion(
      question: '汤姆睡了多长时间？',
      options: ['十个小时', '十二个小时', '两个小时'],
      correctIndex: 1,
      questionTranslation: 'How long did Tom sleep?',
    ),
  ],
);

/// B1.1 in chain order.
final List<QuizContent> enZhB1_1 = [
  enZhB11Result1,
  enZhB11Result2,
  enZhB11SpeakResults,
  enZhB11Direction,
  enZhB11ListenHospital,
  enZhB11Duration,
  enZhB11DeDeDe,
  enZhB11Degree,
  enZhB11ReadLearning,
  enZhB11Pairs,
  enZhB11Health,
  enZhB11SpeakRhythm,
  enZhB11BigtextDe,
  enZhB11ListenAdvice,
  enZhB11DictStudy,
  enZhB11ReadSick,
];
