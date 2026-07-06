import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// A2.1 — Time & Daily Life · 时间与日常 (HSK 2a). English → Mandarin.
///
/// Big rocks: time and place go BEFORE the verb (Z13 — the word-order cliff),
/// 在 + place as scene-setter (Z29 coverbs), serial 去 + verb, and English
/// "can" splitting into 会/能/可以 (Z26). Named bridge: the ultra-regular
/// calendar (星期一, 二月).

final QuizContent enZhA21Calendar = enZhFill(
  id: 'en_zh_a2_1_calendar',
  title: 'The regular calendar',
  intro:
      'Weekdays are numbered (星期一 = weekday-one = Monday), months are '
      'numbered (二月 = two-month = February). Two patterns replace fourteen '
      'English words.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Count your week',
      text: '星期一 Monday … 星期六 Saturday — then Sunday breaks the pattern: '
          '星期天 (or 星期日), the "sky/sun day".',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Dates run big → small',
      text: 'Year 年 → month 月 → day 号 → weekday: 2026年7月2号星期四. Chinese '
          'time always zooms from large to small.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Monday (weekday-one)', answer: '星期一', accepted: ['xīngqīyī', 'xīngqī yī'], hint: 'xīngqīyī'),
    CourseItem(prompt: 'Thursday', answer: '星期四', accepted: ['xīngqīsì'], hint: 'xīngqīsì'),
    CourseItem(prompt: 'Sunday', answer: '星期天', accepted: ['xīngqītiān', '星期日', 'xīngqīrì'], hint: 'xīngqītiān'),
    CourseItem(prompt: 'February (two-month)', answer: '二月', accepted: ['èryuè'], hint: 'èryuè'),
    CourseItem(prompt: 'October', answer: '十月', accepted: ['shíyuè'], hint: 'shíyuè'),
    CourseItem(prompt: 'today', answer: '今天', accepted: ['jīntiān'], hint: 'jīntiān'),
    CourseItem(prompt: 'tomorrow', answer: '明天', accepted: ['míngtiān'], hint: 'míngtiān'),
    CourseItem(prompt: 'yesterday', answer: '昨天', accepted: ['zuótiān'], hint: 'zuótiān'),
    CourseItem(prompt: 'Saturday', answer: '星期六', accepted: ['xīngqīliù'], hint: 'xīngqīliù'),
    CourseItem(prompt: 'June (six-month)', answer: '六月', accepted: ['liùyuè'], hint: 'liùyuè'),
    CourseItem(prompt: 'Wednesday (weekday-three)', answer: '星期三', accepted: ['xīngqīsān'], hint: 'xīngqīsān'),
    CourseItem(prompt: 'What day of the week is it today?', answer: '今天**星期几**？', accepted: ['xīngqī jǐ', 'xingqi ji'], hint: 'jīntiān xīngqī jǐ'),
    CourseItem(prompt: 'December (twelve-month)', answer: '十二月', accepted: ['shí\'èryuè', 'shi er yue'], hint: 'shí\'èryuè'),
    CourseItem(prompt: 'this year', answer: '今年', accepted: ['jīnnián'], hint: 'jīnnián'),
    CourseItem(prompt: 'My birthday is May 4th. (month + 号)', answer: '我的生日是**五月四号**。', accepted: ['wǔyuè sì hào'], hint: 'wǒ de shēngrì shì wǔyuè sì hào'),
  ],
);

final QuizContent enZhA21Time = enZhFill(
  id: 'en_zh_a2_1_time',
  title: 'Telling the time: 点 / 分 / 半',
  intro:
      'Clock time is number + 点 (o\'clock): 三点 = 3:00. Add 半 for half past '
      'and 分 for minutes. 几点? asks the time.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '点 = o\'clock, 半 = half past',
      text: '八点 8:00, 八点半 8:30, 八点十分 8:10. Note "two o\'clock" is '
          '两点 (liǎng diǎn), never 二点.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'What time is it now?', answer: '现在**几点**？', accepted: ['jǐ diǎn', 'jǐdiǎn'], hint: 'xiànzài jǐ diǎn'),
    CourseItem(prompt: 'It\'s three o\'clock.', answer: '现在三**点**。', accepted: ['diǎn'], hint: 'xiànzài sān diǎn'),
    CourseItem(prompt: 'It\'s half past eight.', answer: '八点**半**。', accepted: ['bàn'], hint: 'bā diǎn bàn'),
    CourseItem(prompt: 'It\'s two o\'clock. (careful: 两!)', answer: '**两**点。', accepted: ['liǎng'], hint: 'liǎng diǎn'),
    CourseItem(prompt: 'It\'s 6:10. (ten minutes)', answer: '六点十**分**。', accepted: ['fēn'], hint: 'liù diǎn shí fēn'),
    CourseItem(prompt: 'in the morning (early-on)', answer: '早上', accepted: ['zǎoshang'], hint: 'zǎoshang'),
    CourseItem(prompt: 'in the evening', answer: '晚上', accepted: ['wǎnshang'], hint: 'wǎnshang'),
    CourseItem(prompt: 'It\'s 9:15. (fifteen minutes)', answer: '九点十五**分**。', accepted: ['fēn'], hint: 'jiǔ diǎn shíwǔ fēn'),
    CourseItem(prompt: 'in the afternoon', answer: '下午', accepted: ['xiàwǔ'], hint: 'xiàwǔ'),
    CourseItem(prompt: 'noon / midday', answer: '中午', accepted: ['zhōngwǔ'], hint: 'zhōngwǔ'),
    CourseItem(prompt: 'It\'s a quarter past four. (one 刻 = 15 min)', answer: '四点一**刻**。', accepted: ['kè'], hint: 'sì diǎn yí kè'),
    CourseItem(prompt: 'It\'s almost ten to eight. (差 + minutes + 点)', answer: '**差**十分八点。', accepted: ['chà'], hint: 'chà shí fēn bā diǎn'),
    CourseItem(prompt: 'It\'s half past two. (careful: 两!)', answer: '**两**点半。', accepted: ['liǎng'], hint: 'liǎng diǎn bàn'),
    CourseItem(prompt: 'What time do you go to work?', answer: '你**几点**上班？', accepted: ['jǐ diǎn', 'jǐdiǎn'], hint: 'nǐ jǐ diǎn shàngbān'),
    CourseItem(prompt: 'It\'s 7:45 in the evening. (evening + time)', answer: '晚上七点四十五**分**。', accepted: ['fēn'], hint: 'wǎnshang qī diǎn sìshíwǔ fēn'),
  ],
);

final QuizContent enZhA21WordOrder = enZhFill(
  id: 'en_zh_a2_1_word_order',
  title: 'Time goes BEFORE the verb',
  intro:
      'The word-order cliff: English says "I get up at seven"; Chinese sets '
      'the scene first — 我七点起床 (I at-seven get up). Time never trails the '
      'verb.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Set the scene, then act (Z13)',
      text: 'Subject + WHEN + (WHERE) + verb: 我明天去北京. Putting time at '
          'the end (我去北京明天 ✗) is the #1 English-speaker word-order '
          'error.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Time can also lead',
      text: 'For emphasis the time may open the sentence: 明天我去北京. '
          'Before the subject or after it — but never after the verb.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I get up at seven.', answer: '我**七点**起床。', accepted: ['qī diǎn', 'qīdiǎn'], hint: 'wǒ qī diǎn qǐchuáng'),
    CourseItem(prompt: 'He goes to Beijing tomorrow.', answer: '他**明天**去北京。', accepted: ['míngtiān'], hint: 'tā míngtiān qù Běijīng'),
    CourseItem(prompt: 'We eat at twelve.', answer: '我们**十二点**吃饭。', accepted: ['shí\'èr diǎn', 'shi er dian'], hint: 'wǒmen shí\'èr diǎn chīfàn'),
    CourseItem(prompt: 'She works on Monday.', answer: '她**星期一**上班。', accepted: ['xīngqīyī'], hint: 'tā xīngqīyī shàngbān'),
    CourseItem(prompt: 'Are you coming this evening?', answer: '你**今天晚上**来吗？', accepted: ['jīntiān wǎnshang'], hint: 'nǐ jīntiān wǎnshang lái ma'),
    CourseItem(prompt: 'I sleep at eleven at night.', answer: '我晚上**十一点**睡觉。', accepted: ['shíyī diǎn'], hint: 'wǒ wǎnshang shíyī diǎn shuìjiào'),
    CourseItem(prompt: 'They eat at home in the evening.', answer: '他们**晚上**在家吃饭。', accepted: ['wǎnshang'], hint: 'tāmen wǎnshang zài jiā chīfàn'),
    CourseItem(prompt: 'I phone my mum on Sunday.', answer: '我**星期天**给妈妈打电话。', accepted: ['xīngqītiān'], hint: 'wǒ xīngqītiān gěi māma dǎ diànhuà'),
    CourseItem(prompt: 'He drinks tea in the morning.', answer: '他**早上**喝茶。', accepted: ['zǎoshang'], hint: 'tā zǎoshang hē chá'),
    CourseItem(prompt: 'We go to the park tomorrow afternoon.', answer: '我们**明天下午**去公园。', accepted: ['míngtiān xiàwǔ'], hint: 'wǒmen míngtiān xiàwǔ qù gōngyuán'),
    CourseItem(prompt: 'My dad goes to work at eight every day.', answer: '我爸爸**每天八点**上班。', accepted: ['měitiān bā diǎn'], hint: 'wǒ bàba měitiān bā diǎn shàngbān'),
    CourseItem(prompt: 'What are you doing this weekend? (weekend = 周末)', answer: '你**周末**做什么？', accepted: ['zhōumò'], hint: 'nǐ zhōumò zuò shénme'),
    CourseItem(prompt: 'She doesn\'t work on Sunday. (time still before 不)', answer: '她**星期天**不上班。', accepted: ['xīngqītiān'], hint: 'tā xīngqītiān bú shàngbān'),
    CourseItem(prompt: 'Tomorrow morning I\'m going to buy things.', answer: '**明天早上**我去买东西。', accepted: ['míngtiān zǎoshang'], hint: 'míngtiān zǎoshang wǒ qù mǎi dōngxi'),
    CourseItem(prompt: 'We have Chinese class at half past nine.', answer: '我们**九点半**上中文课。', accepted: ['jiǔ diǎn bàn'], hint: 'wǒmen jiǔ diǎn bàn shàng Zhōngwén kè'),
  ],
);

final QuizContent enZhA21SpeakDay = enZhSpeak(
  id: 'en_zh_a2_1_speak_day',
  title: 'Speaking: my day',
  intro:
      'Say your daily routine aloud — feel how the time expression always '
      'lands before the action.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Chunk it: WHEN + DO',
      text: 'Pause mentally after the time chunk: 我七点 // 起床. Building the '
          'habit aloud installs the word order for free (Z13).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wǒ měitiān qī diǎn qǐchuáng. — I get up at seven every day.', answer: '我每天七点起床。'),
    CourseItem(prompt: 'Wǒ zǎoshang hē kāfēi. — I drink coffee in the morning.', answer: '我早上喝咖啡。'),
    CourseItem(prompt: 'Wǒ bā diǎn bàn qù xuéxiào. — I go to school at 8:30.', answer: '我八点半去学校。'),
    CourseItem(prompt: 'Wǒmen shí\'èr diǎn chī wǔfàn. — We eat lunch at twelve.', answer: '我们十二点吃午饭。'),
    CourseItem(prompt: 'Wǎnshang wǒ kàn diànshì. — In the evening I watch TV.', answer: '晚上我看电视。'),
    CourseItem(prompt: 'Wǒ shíyī diǎn shuìjiào. — I go to bed at eleven.', answer: '我十一点睡觉。'),
  ],
);

final QuizContent enZhA21Zai = enZhFill(
  id: 'en_zh_a2_1_zai',
  title: '在 + place: scene before action',
  intro:
      '在 zài marks where: 我在家 I\'m at home. Doing something somewhere puts '
      'the 在-phrase BEFORE the verb: 我在家吃饭 — at home (I) eat.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚠️ 在 + place + verb (Z13/Z29)',
      text: '我在咖啡馆学习 — "I at the café study." English appends "at the '
          'café"; Chinese sets the scene before the action. 我学习在咖啡馆 ✗.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '在 alone = to be at',
      text: 'With no other verb, 在 IS the verb: 他在家 he\'s home, 你在哪儿? '
          'where are you?',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am at home.', answer: '我**在**家。', accepted: ['zài'], hint: 'wǒ zài jiā'),
    CourseItem(prompt: 'Where are you?', answer: '你**在**哪儿？', accepted: ['zài'], hint: 'nǐ zài nǎr'),
    CourseItem(prompt: 'I eat at home. (at home + eat)', answer: '我**在家**吃饭。', accepted: ['zài jiā'], hint: 'wǒ zài jiā chīfàn'),
    CourseItem(prompt: 'He works in Beijing.', answer: '他**在北京**工作。', accepted: ['zài Běijīng'], hint: 'tā zài Běijīng gōngzuò'),
    CourseItem(prompt: 'She studies Chinese at school.', answer: '她**在学校**学习中文。', accepted: ['zài xuéxiào'], hint: 'tā zài xuéxiào xuéxí Zhōngwén'),
    CourseItem(prompt: 'We drink tea at the café.', answer: '我们**在咖啡馆**喝茶。', accepted: ['zài kāfēiguǎn'], hint: 'wǒmen zài kāfēiguǎn hē chá'),
    CourseItem(prompt: 'He is at school.', answer: '他**在**学校。', accepted: ['zài'], hint: 'tā zài xuéxiào'),
    CourseItem(prompt: 'My mum works at home.', answer: '我妈妈**在家**工作。', accepted: ['zài jiā'], hint: 'wǒ māma zài jiā gōngzuò'),
    CourseItem(prompt: 'They read at the library.', answer: '他们**在图书馆**看书。', accepted: ['zài túshūguǎn'], hint: 'tāmen zài túshūguǎn kàn shū'),
    CourseItem(prompt: 'Where does he work?', answer: '他**在**哪儿工作？', accepted: ['zài'], hint: 'tā zài nǎr gōngzuò'),
    CourseItem(prompt: 'The cat is not at home. (不在)', answer: '猫**不在**家。', accepted: ['bú zài', 'bu zai'], hint: 'māo bú zài jiā'),
    CourseItem(prompt: 'I buy things at the shop.', answer: '我**在商店**买东西。', accepted: ['zài shāngdiàn'], hint: 'wǒ zài shāngdiàn mǎi dōngxi'),
    CourseItem(prompt: 'Where do you eat lunch?', answer: '你**在哪儿**吃午饭？', accepted: ['zài nǎr', 'zai nar'], hint: 'nǐ zài nǎr chī wǔfàn'),
    CourseItem(prompt: 'He watches TV at his friend\'s home.', answer: '他**在朋友家**看电视。', accepted: ['zài péngyou jiā'], hint: 'tā zài péngyou jiā kàn diànshì'),
    CourseItem(prompt: 'My mum is at the hospital. (hospital = 医院)', answer: '我妈妈**在**医院。', accepted: ['zài'], hint: 'wǒ māma zài yīyuàn'),
  ],
);

final QuizContent enZhA21ListenMorning = enZhListen(
  id: 'en_zh_a2_1_listen_morning',
  title: 'Listening: 你几点起床?',
  passageTitle: '汤姆的早上',
  passage:
      '汤姆每天早上七点起床。他七点半喝咖啡，吃面包。八点他去学校学习中文。'
      '他很喜欢他的中文课。十二点他和小美在学校吃午饭。',
  passageTranslation:
      'Tāngmǔ měitiān zǎoshang qī diǎn qǐchuáng. Tā qī diǎn bàn hē kāfēi, chī '
      'miànbāo. Bā diǎn tā qù xuéxiào xuéxí Zhōngwén. Tā hěn xǐhuan tā de '
      'Zhōngwén kè. Shí\'èr diǎn tā hé Xiǎoměi zài xuéxiào chī wǔfàn.\n\n'
      'Tom gets up at seven every morning. At 7:30 he drinks coffee and eats '
      'bread. At eight he goes to school to study Chinese. He really likes his '
      'Chinese class. At twelve he and Xiaomei eat lunch at school.',
  intro:
      'Listen for the times — they always come right before the action they '
      'schedule.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Numbers first',
      text: 'Catch 七点, 七点半, 八点, 十二点 — pin each time to the verb that '
          'follows it and the whole story falls into place.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆几点起床？',
      options: ['七点', '八点', '十二点'],
      correctIndex: 0,
      questionTranslation: 'What time does Tom get up?',
    ),
    ReadingQuestion(
      question: '汤姆早上喝什么？',
      options: ['茶', '咖啡', '水'],
      correctIndex: 1,
      questionTranslation: 'What does Tom drink in the morning?',
    ),
    ReadingQuestion(
      question: '他和谁吃午饭？',
      options: ['小美', '王老师', '他妈妈'],
      correctIndex: 0,
      questionTranslation: 'Who does he eat lunch with?',
    ),
  ],
);

final QuizContent enZhA21QuVerb = enZhFill(
  id: 'en_zh_a2_1_qu_verb',
  title: 'Going to do: 去 + verb',
  intro:
      'Verbs chain directly in Chinese: 去买咖啡 = go buy coffee. No "to", no '
      'linking word — the second verb is the purpose of the first.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Verbs stack bare (Z29)',
      text: '我去学校学习中文 — go + study, no connector. English needs "to"; '
          'Chinese just lines the actions up in order of happening.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I\'m going to buy coffee.', answer: '我**去买**咖啡。', accepted: ['qù mǎi'], hint: 'wǒ qù mǎi kāfēi'),
    CourseItem(prompt: 'He goes to school to study Chinese.', answer: '他去学校**学习**中文。', accepted: ['xuéxí'], hint: 'tā qù xuéxiào xuéxí Zhōngwén'),
    CourseItem(prompt: 'We\'re going to eat. (go eat-rice)', answer: '我们**去吃饭**。', accepted: ['qù chīfàn'], hint: 'wǒmen qù chīfàn'),
    CourseItem(prompt: 'She is coming to see you. (come see)', answer: '她**来看**你。', accepted: ['lái kàn'], hint: 'tā lái kàn nǐ'),
    CourseItem(prompt: 'Tomorrow I\'m going to Beijing to see a friend.', answer: '明天我去北京**看**朋友。', accepted: ['kàn'], hint: 'míngtiān wǒ qù Běijīng kàn péngyou'),
    CourseItem(prompt: 'Do you want to go buy books?', answer: '你想**去买**书吗？', accepted: ['qù mǎi'], hint: 'nǐ xiǎng qù mǎi shū ma'),
    CourseItem(prompt: 'She goes to the shop to buy tea.', answer: '她去商店**买**茶。', accepted: ['mǎi'], hint: 'tā qù shāngdiàn mǎi chá'),
    CourseItem(prompt: 'They go to the café to drink coffee.', answer: '他们去咖啡馆**喝**咖啡。', accepted: ['hē'], hint: 'tāmen qù kāfēiguǎn hē kāfēi'),
    CourseItem(prompt: 'I\'m going home to cook.', answer: '我回家**做饭**。', accepted: ['zuòfàn', 'zuò fàn'], hint: 'wǒ huí jiā zuòfàn'),
    CourseItem(prompt: 'Do you want to come to my home to eat?', answer: '你想来我家**吃饭**吗？', accepted: ['chīfàn', 'chī fàn'], hint: 'nǐ xiǎng lái wǒ jiā chīfàn ma'),
    CourseItem(prompt: 'He goes to the hospital to see the doctor.', answer: '他去医院**看**医生。', accepted: ['kàn'], hint: 'tā qù yīyuàn kàn yīshēng'),
    CourseItem(prompt: 'We go to the library to borrow books. (borrow = 借)', answer: '我们去图书馆**借**书。', accepted: ['jiè'], hint: 'wǒmen qù túshūguǎn jiè shū'),
    CourseItem(prompt: 'I\'m going to the park to see friends on Saturday.', answer: '我星期六**去公园**看朋友。', accepted: ['qù gōngyuán'], hint: 'wǒ xīngqīliù qù gōngyuán kàn péngyou'),
    CourseItem(prompt: 'She is coming to China to study Chinese.', answer: '她**来中国**学习中文。', accepted: ['lái Zhōngguó'], hint: 'tā lái Zhōngguó xuéxí Zhōngwén'),
    CourseItem(prompt: 'Are you going to the shop to buy tea tomorrow?', answer: '你明天**去商店**买茶吗？', accepted: ['qù shāngdiàn'], hint: 'nǐ míngtiān qù shāngdiàn mǎi chá ma'),
  ],
);

final QuizContent enZhA21XiangYao = enZhFill(
  id: 'en_zh_a2_1_xiang_yao',
  title: 'Wanting: 想 / 要',
  intro:
      '想 xiǎng = would like to (soft), 要 yào = want / am going to (firm). '
      'Both sit directly before the verb.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '想 wishes, 要 orders',
      text: '我想喝茶 I feel like tea; 我要喝茶 I WANT tea / I\'m having tea. '
          'In a café, 我要一杯咖啡 is how you actually order.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '想 + noun = to miss',
      text: '我想你 = I miss you — 想 straight onto a person means missing '
          'them, not wanting them to do something.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I would like to drink tea.', answer: '我**想**喝茶。', accepted: ['xiǎng'], hint: 'wǒ xiǎng hē chá'),
    CourseItem(prompt: 'I want a cup of coffee. (ordering)', answer: '我**要**一杯咖啡。', accepted: ['yào'], hint: 'wǒ yào yì bēi kāfēi'),
    CourseItem(prompt: 'He would like to go to China.', answer: '他**想**去中国。', accepted: ['xiǎng'], hint: 'tā xiǎng qù Zhōngguó'),
    CourseItem(prompt: 'Do you want to watch TV?', answer: '你**想**看电视吗？', accepted: ['xiǎng'], hint: 'nǐ xiǎng kàn diànshì ma'),
    CourseItem(prompt: 'We are going to buy a computer. (firm plan)', answer: '我们**要**买电脑。', accepted: ['yào'], hint: 'wǒmen yào mǎi diànnǎo'),
    CourseItem(prompt: 'I miss my mum.', answer: '我**想**我妈妈。', accepted: ['xiǎng'], hint: 'wǒ xiǎng wǒ māma'),
    CourseItem(prompt: 'She would like to buy a phone.', answer: '她**想**买手机。', accepted: ['xiǎng'], hint: 'tā xiǎng mǎi shǒujī'),
    CourseItem(prompt: 'I want to go home. (firm)', answer: '我**要**回家。', accepted: ['yào'], hint: 'wǒ yào huí jiā'),
    CourseItem(prompt: 'Do you want a cup of tea? (ordering)', answer: '你**要**一杯茶吗？', accepted: ['yào'], hint: 'nǐ yào yì bēi chá ma'),
    CourseItem(prompt: 'He misses home. (想 + 家 = homesick)', answer: '他**想**家。', accepted: ['xiǎng'], hint: 'tā xiǎng jiā'),
    CourseItem(prompt: 'I don\'t want to go to work today. (soft)', answer: '我今天**不想**上班。', accepted: ['bù xiǎng', 'bu xiang'], hint: 'wǒ jīntiān bù xiǎng shàngbān'),
    CourseItem(prompt: 'What would you like to eat?', answer: '你**想**吃什么？', accepted: ['xiǎng'], hint: 'nǐ xiǎng chī shénme'),
    CourseItem(prompt: 'We want two cups of coffee. (ordering)', answer: '我们**要**两杯咖啡。', accepted: ['yào'], hint: 'wǒmen yào liǎng bēi kāfēi'),
    CourseItem(prompt: 'She really misses her older sister.', answer: '她很**想**她姐姐。', accepted: ['xiǎng'], hint: 'tā hěn xiǎng tā jiějie'),
    CourseItem(prompt: 'He is going to buy a car this year. (firm plan)', answer: '他今年**要**买车。', accepted: ['yào'], hint: 'tā jīnnián yào mǎi chē'),
  ],
);

final QuizContent enZhA21HuiNeng = enZhFill(
  id: 'en_zh_a2_1_hui_neng',
  title: 'Can: 会 / 能 / 可以',
  intro:
      'English "can" splits three ways: 会 = learned skill, 能 = physically/'
      'circumstantially able, 可以 = allowed.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Skill 会, power 能, permission 可以 (Z26)',
      text: 'Learned it? 会 (我会说中文). Able right now? 能 (今天我不能来). '
          'Allowed? 可以 (这儿可以坐吗?). Pick by asking WHY you "can".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '会 also predicts',
      text: 'Later, 会 marks likely futures: 明天会下雨 — it will rain. Skill '
          'first, forecast later.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I can speak Chinese. (learned skill)', answer: '我**会**说中文。', accepted: ['huì'], hint: 'wǒ huì shuō Zhōngwén'),
    CourseItem(prompt: 'She can\'t cook. (never learned)', answer: '她不**会**做饭。', accepted: ['huì'], hint: 'tā bú huì zuòfàn'),
    CourseItem(prompt: 'I can\'t come today. (circumstances)', answer: '我今天不**能**来。', accepted: ['néng'], hint: 'wǒ jīntiān bù néng lái'),
    CourseItem(prompt: 'May I sit here? (permission)', answer: '我**可以**坐这儿吗？', accepted: ['kěyǐ'], hint: 'wǒ kěyǐ zuò zhèr ma'),
    CourseItem(prompt: 'Can you swim? (skill)', answer: '你**会**游泳吗？', accepted: ['huì'], hint: 'nǐ huì yóuyǒng ma'),
    CourseItem(prompt: 'You may drink tea here. (allowed)', answer: '你**可以**在这儿喝茶。', accepted: ['kěyǐ'], hint: 'nǐ kěyǐ zài zhèr hē chá'),
    CourseItem(prompt: 'He can drive. (learned skill)', answer: '他**会**开车。', accepted: ['huì'], hint: 'tā huì kāichē'),
    CourseItem(prompt: 'Can you come tomorrow? (circumstances)', answer: '你明天**能**来吗？', accepted: ['néng'], hint: 'nǐ míngtiān néng lái ma'),
    CourseItem(prompt: 'May I ask a question? (permission)', answer: '我**可以**问一个问题吗？', accepted: ['kěyǐ'], hint: 'wǒ kěyǐ wèn yí ge wèntí ma'),
    CourseItem(prompt: 'She can\'t swim. (never learned)', answer: '她不**会**游泳。', accepted: ['huì'], hint: 'tā bú huì yóuyǒng'),
    CourseItem(prompt: 'You can\'t smoke here. (not allowed)', answer: '这儿不**可以**吸烟。', accepted: ['kěyǐ'], hint: 'zhèr bù kěyǐ xīyān'),
    CourseItem(prompt: 'My grandma can cook Chinese food. (skill)', answer: '我奶奶**会**做中国菜。', accepted: ['huì'], hint: 'wǒ nǎinai huì zuò Zhōngguó cài'),
    CourseItem(prompt: 'I\'m too busy today, I can\'t go. (circumstances)', answer: '我今天很忙，不**能**去。', accepted: ['néng'], hint: 'wǒ jīntiān hěn máng, bù néng qù'),
    CourseItem(prompt: 'May I use your phone? (permission; use = 用)', answer: '我**可以**用你的手机吗？', accepted: ['kěyǐ'], hint: 'wǒ kěyǐ yòng nǐ de shǒujī ma'),
    CourseItem(prompt: 'Can you write Chinese characters? (skill; characters = 汉字)', answer: '你**会**写汉字吗？', accepted: ['huì'], hint: 'nǐ huì xiě Hànzì ma'),
  ],
);

final QuizContent enZhA21ReadDay = enZhRead(
  id: 'en_zh_a2_1_read_day',
  title: 'Reading: 汤姆的一天',
  passageTitle: '汤姆的一天',
  passage:
      '汤姆每天早上七点起床，七点半喝咖啡。八点他去学校，在学校学习中文。'
      '十二点他和朋友吃午饭。下午他在图书馆看书。'
      '晚上六点他回家做饭。他会做英国菜，可是他更想学做中国菜。'
      '晚上他有时候看电视，有时候给妈妈打电话。他十一点睡觉。',
  passageTranslation:
      'Tāngmǔ měitiān zǎoshang qī diǎn qǐchuáng, qī diǎn bàn hē kāfēi. Bā diǎn '
      'tā qù xuéxiào, zài xuéxiào xuéxí Zhōngwén. Shí\'èr diǎn tā hé péngyou '
      'chī wǔfàn. Xiàwǔ tā zài túshūguǎn kàn shū. Wǎnshang liù diǎn tā huí jiā '
      'zuòfàn. Tā huì zuò Yīngguó cài, kěshì tā gèng xiǎng xué zuò Zhōngguó '
      'cài. Wǎnshang tā yǒushíhou kàn diànshì, yǒushíhou gěi māma dǎ diànhuà. '
      'Tā shíyī diǎn shuìjiào.\n\n'
      'Tom gets up at seven every morning and drinks coffee at 7:30. At eight '
      'he goes to school, where he studies Chinese. At twelve he eats lunch '
      'with friends. In the afternoon he reads in the library. At six in the '
      'evening he goes home and cooks. He can cook British food, but he\'d '
      'rather learn to cook Chinese food. In the evening he sometimes watches '
      'TV, sometimes phones his mum. He goes to bed at eleven.',
  intro:
      'A full day, scheduled the Chinese way: every time and place stands '
      'before its verb. Read it twice — once for the story, once for the '
      'word order.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Spot the pattern (Z13)',
      text: 'Underline mentally: 七点起床, 在学校学习, 晚上六点回家 — WHEN/'
          'WHERE + verb, sentence after sentence. That rhythm is the grammar.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆在哪儿学习中文？',
      options: ['在家', '在学校', '在图书馆'],
      correctIndex: 1,
      questionTranslation: 'Where does Tom study Chinese?',
    ),
    ReadingQuestion(
      question: '下午他做什么？',
      options: ['看电视', '在图书馆看书', '做饭'],
      correctIndex: 1,
      questionTranslation: 'What does he do in the afternoon?',
    ),
    ReadingQuestion(
      question: '汤姆想学做什么菜？',
      options: ['英国菜', '中国菜'],
      correctIndex: 1,
      questionTranslation: 'What food does Tom want to learn to cook?',
    ),
  ],
);

final QuizContent enZhA21SpeakFinals = enZhSpeak(
  id: 'en_zh_a2_1_speak_finals',
  title: 'Sounds: -n vs -ng, j/q/x, ü',
  intro:
      'Three sound contrasts English ears blur: the -n/-ng endings, the '
      'smiling j/q/x row, and ü. Exaggerate them now, relax later.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ fán ≠ fáng (Z5)',
      text: '-n ends with the tongue tip at the teeth; -ng ends open, in the '
          'throat. 半 bàn vs 帮 bāng, 人 rén vs 冷 lěng — different words.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'ü = "ee" with rounded lips',
      text: 'Say "ee", freeze your tongue, round your lips: 去 qù, 女 nǚ, 绿 '
          'lǜ. After j/q/x it\'s written u but still sounds ü.',
    ),
  ],
  items: const [
    CourseItem(prompt: '-n vs -ng: bàn / bāng — half / help', answer: '半，帮'),
    CourseItem(prompt: '-n vs -ng: rén / lěng — person / cold', answer: '人，冷'),
    CourseItem(prompt: 'j q x: jiā qī xiǎo — home, seven, small', answer: '家，七，小'),
    CourseItem(prompt: 'ü after j/q/x: qù jǔ xǔ', answer: '去，举，许'),
    CourseItem(prompt: 'nǚ lǜ — woman, green (true ü)', answer: '女，绿'),
    CourseItem(prompt: 'Wǒ xiǎng qù Zhōngguó. — I\'d like to go to China.', answer: '我想去中国。'),
  ],
);

final QuizContent enZhA21DailyVerbs = enZhFill(
  id: 'en_zh_a2_1_daily_verbs',
  title: 'Daily verbs',
  intro:
      'The verbs of an ordinary day. Several are verb+object pairs (吃饭 '
      'eat-rice, 睡觉 sleep-a-sleep) — learn them as one word for now.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Verb + built-in object',
      text: '吃饭, 睡觉, 上班, 打电话 carry a default object inside. Later '
          'you\'ll split them (睡了一个好觉) — for now treat each as a unit.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'to get up', answer: '起床', accepted: ['qǐchuáng'], hint: 'qǐchuáng'),
    CourseItem(prompt: 'to eat (a meal)', answer: '吃饭', accepted: ['chīfàn'], hint: 'chīfàn'),
    CourseItem(prompt: 'to go to work', answer: '上班', accepted: ['shàngbān'], hint: 'shàngbān'),
    CourseItem(prompt: 'to sleep / go to bed', answer: '睡觉', accepted: ['shuìjiào'], hint: 'shuìjiào'),
    CourseItem(prompt: 'to make a phone call', answer: '打电话', accepted: ['dǎ diànhuà'], hint: 'dǎ diànhuà'),
    CourseItem(prompt: 'to cook (make food)', answer: '做饭', accepted: ['zuòfàn'], hint: 'zuòfàn'),
    CourseItem(prompt: 'to read (look at books)', answer: '看书', accepted: ['kàn shū', 'kànshū'], hint: 'kàn shū'),
    CourseItem(prompt: 'to go home (return home)', answer: '回家', accepted: ['huí jiā', 'huíjiā'], hint: 'huí jiā'),
    CourseItem(prompt: 'to buy things / go shopping', answer: '买东西', accepted: ['mǎi dōngxi'], hint: 'mǎi dōngxi'),
    CourseItem(prompt: 'to attend class', answer: '上课', accepted: ['shàngkè'], hint: 'shàngkè'),
    CourseItem(prompt: 'to get off work', answer: '下班', accepted: ['xiàbān'], hint: 'xiàbān'),
    CourseItem(prompt: 'to take a shower / bathe', answer: '洗澡', accepted: ['xǐzǎo'], hint: 'xǐzǎo'),
    CourseItem(prompt: 'to run (as exercise)', answer: '跑步', accepted: ['pǎobù'], hint: 'pǎobù'),
    CourseItem(prompt: 'to listen to music', answer: '听音乐', accepted: ['tīng yīnyuè'], hint: 'tīng yīnyuè'),
    CourseItem(prompt: 'to go online / use the internet', answer: '上网', accepted: ['shàngwǎng'], hint: 'shàngwǎng'),
  ],
);

final QuizContent enZhA21Frequency = enZhFill(
  id: 'en_zh_a2_1_frequency',
  title: '每天 / 常常 / 有时候',
  intro:
      'How often? 每天 every day, 常常 often, 有时候 sometimes — all take the '
      'time slot before the verb, like every other time word.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Frequency lives in the WHEN slot (Z13)',
      text: '我常常喝茶, 他每天上班 — same position as 明天 or 七点. One slot '
          'to rule all time words.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I drink coffee every day.', answer: '我**每天**喝咖啡。', accepted: ['měitiān'], hint: 'wǒ měitiān hē kāfēi'),
    CourseItem(prompt: 'He often goes to the library.', answer: '他**常常**去图书馆。', accepted: ['chángcháng'], hint: 'tā chángcháng qù túshūguǎn'),
    CourseItem(prompt: 'Sometimes I watch TV.', answer: '我**有时候**看电视。', accepted: ['yǒushíhou', 'yǒu shíhou'], hint: 'wǒ yǒushíhou kàn diànshì'),
    CourseItem(prompt: 'She gets up at six every day.', answer: '她**每天**六点起床。', accepted: ['měitiān'], hint: 'tā měitiān liù diǎn qǐchuáng'),
    CourseItem(prompt: 'We often eat at home.', answer: '我们**常常**在家吃饭。', accepted: ['chángcháng'], hint: 'wǒmen chángcháng zài jiā chīfàn'),
    CourseItem(prompt: 'He sometimes drinks tea.', answer: '他**有时候**喝茶。', accepted: ['yǒushíhou', 'yǒu shíhou'], hint: 'tā yǒushíhou hē chá'),
    CourseItem(prompt: 'She often phones her friends.', answer: '她**常常**给朋友打电话。', accepted: ['chángcháng'], hint: 'tā chángcháng gěi péngyou dǎ diànhuà'),
    CourseItem(prompt: 'We go to the park every day.', answer: '我们**每天**去公园。', accepted: ['měitiān'], hint: 'wǒmen měitiān qù gōngyuán'),
    CourseItem(prompt: 'I often buy books at the bookshop.', answer: '我**常常**在书店买书。', accepted: ['chángcháng'], hint: 'wǒ chángcháng zài shūdiàn mǎi shū'),
    CourseItem(prompt: 'He reads every evening.', answer: '他**每天**晚上看书。', accepted: ['měitiān'], hint: 'tā měitiān wǎnshang kàn shū'),
    CourseItem(prompt: 'She runs every morning.', answer: '她**每天**早上跑步。', accepted: ['měitiān'], hint: 'tā měitiān zǎoshang pǎobù'),
    CourseItem(prompt: 'Sometimes we eat at the restaurant. (restaurant = 饭馆)', answer: '我们**有时候**在饭馆吃饭。', accepted: ['yǒushíhou', 'yǒu shíhou'], hint: 'wǒmen yǒushíhou zài fànguǎn chīfàn'),
    CourseItem(prompt: 'I don\'t often watch TV. (不常)', answer: '我**不常**看电视。', accepted: ['bù cháng', 'bu chang'], hint: 'wǒ bù cháng kàn diànshì'),
    CourseItem(prompt: 'He listens to music every day.', answer: '他**每天**听音乐。', accepted: ['měitiān'], hint: 'tā měitiān tīng yīnyuè'),
    CourseItem(prompt: 'My dad often goes online in the evening.', answer: '我爸爸晚上**常常**上网。', accepted: ['chángcháng'], hint: 'wǒ bàba wǎnshang chángcháng shàngwǎng'),
  ],
);

final QuizContent enZhA21DictRoutine = enZhDict(
  id: 'en_zh_a2_1_dict_routine',
  title: 'Dictation: my routine',
  intro:
      'Type what you hear. The times and places all come before their verbs — '
      'let the word order guide your typing.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Homophone alert: diǎn',
      text: 'Typing "qidiǎn"? 七点 (7 o\'clock) — the IME may offer 起点 '
          '(starting point). Context beats the first suggestion.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I get up at seven every day.', answer: '我每天七点起床。'),
    CourseItem(prompt: 'He works in Beijing.', answer: '他在北京工作。'),
    CourseItem(prompt: 'We eat lunch at twelve.', answer: '我们十二点吃午饭。'),
    CourseItem(prompt: 'I\'d like to go to China.', answer: '我想去中国。'),
    CourseItem(prompt: 'Can you speak Chinese?', answer: '你会说中文吗？'),
    CourseItem(prompt: 'Sometimes I read at the café.', answer: '我有时候在咖啡馆看书。'),
    CourseItem(prompt: 'I go to bed at half past ten.', answer: '我十点半睡觉。'),
    CourseItem(prompt: 'He often goes to the park.', answer: '他常常去公园。'),
    CourseItem(prompt: 'I want a cup of tea.', answer: '我要一杯茶。'),
    CourseItem(prompt: 'She goes home to cook in the evening.', answer: '她晚上回家做饭。'),
    CourseItem(prompt: 'What time do you get up?', answer: '你几点起床？'),
    CourseItem(prompt: 'Today is Wednesday.', answer: '今天星期三。'),
    CourseItem(prompt: 'He gets off work at six.', answer: '他六点下班。'),
    CourseItem(prompt: 'May I sit here?', answer: '我可以坐这儿吗？'),
    CourseItem(prompt: 'We often listen to music at home.', answer: '我们常常在家听音乐。'),
  ],
);

final QuizContent enZhA21ReadCafe = enZhRead(
  id: 'en_zh_a2_1_read_cafe',
  title: 'Reading: 在咖啡馆',
  passageTitle: '在咖啡馆',
  passage:
      '星期六早上，汤姆和小美在咖啡馆。\n'
      '小美："你想喝什么？"\n'
      '汤姆："我要一杯咖啡。你呢？"\n'
      '小美："我不喝咖啡，我要一杯茶。"\n'
      '汤姆："你今天下午想做什么？"\n'
      '小美："我想去书店买书，你能和我一起去吗？"\n'
      '汤姆："能！我也想买一本中文书。"',
  passageTranslation:
      'Xīngqīliù zǎoshang, Tāngmǔ hé Xiǎoměi zài kāfēiguǎn.\n'
      'Xiǎoměi: "Nǐ xiǎng hē shénme?"\n'
      'Tāngmǔ: "Wǒ yào yì bēi kāfēi. Nǐ ne?"\n'
      'Xiǎoměi: "Wǒ bù hē kāfēi, wǒ yào yì bēi chá."\n'
      'Tāngmǔ: "Nǐ jīntiān xiàwǔ xiǎng zuò shénme?"\n'
      'Xiǎoměi: "Wǒ xiǎng qù shūdiàn mǎi shū, nǐ néng hé wǒ yìqǐ qù ma?"\n'
      'Tāngmǔ: "Néng! Wǒ yě xiǎng mǎi yì běn Zhōngwén shū."\n\n'
      'Saturday morning, Tom and Xiaomei are at the café.\n'
      'Xiaomei: "What would you like to drink?"\n'
      'Tom: "I\'ll have a coffee. You?"\n'
      'Xiaomei: "I don\'t drink coffee — I\'ll have a tea."\n'
      'Tom: "What do you want to do this afternoon?"\n'
      'Xiaomei: "I\'d like to go to the bookshop to buy books. Can you come '
      'with me?"\n'
      'Tom: "I can! I\'d like to buy a Chinese book too."',
  intro:
      'Your first dialogue. Notice how the answer to a Chinese question keeps '
      'the question\'s exact shape — 能…吗? → 能!',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Answer with the verb',
      text: 'Chinese has no yes/no words: answer by echoing the verb. 能吗? → '
          '能 / 不能. 想去吗? → 想 / 不想.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '小美喝什么？',
      options: ['咖啡', '茶', '水'],
      correctIndex: 1,
      questionTranslation: 'What does Xiaomei drink?',
    ),
    ReadingQuestion(
      question: '小美下午想去哪儿？',
      options: ['书店', '学校', '图书馆'],
      correctIndex: 0,
      questionTranslation: 'Where does Xiaomei want to go in the afternoon?',
    ),
    ReadingQuestion(
      question: '汤姆想买什么？',
      options: ['一杯咖啡', '一本中文书', '一个手机'],
      correctIndex: 1,
      questionTranslation: 'What does Tom want to buy?',
    ),
  ],
);

final QuizContent enZhA21ListenWeekend = enZhListen(
  id: 'en_zh_a2_1_listen_weekend',
  title: 'Listening: 周末做什么?',
  passageTitle: '小美的周末',
  passage:
      '我周末不上课。星期六早上我常常去咖啡馆看书。下午我喜欢和朋友去公园。'
      '星期天我在家。早上我给妈妈打电话，下午我做饭。'
      '我会做很多中国菜。晚上我有时候看电视，十点半睡觉。',
  passageTranslation:
      'Wǒ zhōumò bú shàngkè. Xīngqīliù zǎoshang wǒ chángcháng qù kāfēiguǎn kàn '
      'shū. Xiàwǔ wǒ xǐhuan hé péngyou qù gōngyuán. Xīngqītiān wǒ zài jiā. '
      'Zǎoshang wǒ gěi māma dǎ diànhuà, xiàwǔ wǒ zuòfàn. Wǒ huì zuò hěn duō '
      'Zhōngguó cài. Wǎnshang wǒ yǒushíhou kàn diànshì, shí diǎn bàn '
      'shuìjiào.\n\n'
      'I don\'t have class at the weekend. On Saturday morning I often go to '
      'the café to read. In the afternoon I like going to the park with '
      'friends. On Sunday I stay home. In the morning I phone my mum; in the '
      'afternoon I cook. I can make lots of Chinese dishes. In the evening I '
      'sometimes watch TV, and I go to bed at half past ten.',
  intro:
      'Xiaomei\'s weekend. Listen once for the days, once for what happens on '
      'each.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Weekend = 周末',
      text: '周 is the formal "week": 周末 weekend, 周一 = 星期一 Monday. '
          'You\'ll hear both systems everywhere.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '星期六早上小美常常做什么？',
      options: ['去咖啡馆看书', '去公园', '做饭'],
      correctIndex: 0,
      questionTranslation: 'What does Xiaomei often do on Saturday morning?',
    ),
    ReadingQuestion(
      question: '星期天早上她给谁打电话？',
      options: ['朋友', '妈妈', '老师'],
      correctIndex: 1,
      questionTranslation: 'Who does she phone on Sunday morning?',
    ),
    ReadingQuestion(
      question: '她几点睡觉？',
      options: ['十点', '十点半', '十一点'],
      correctIndex: 1,
      questionTranslation: 'What time does she go to bed?',
    ),
  ],
);

/// A2.1 in chain order.
final List<QuizContent> enZhA2_1 = [
  enZhA21Calendar,
  enZhA21Time,
  enZhA21WordOrder,
  enZhA21SpeakDay,
  enZhA21Zai,
  enZhA21ListenMorning,
  enZhA21QuVerb,
  enZhA21XiangYao,
  enZhA21HuiNeng,
  enZhA21ReadDay,
  enZhA21SpeakFinals,
  enZhA21DailyVerbs,
  enZhA21Frequency,
  enZhA21DictRoutine,
  enZhA21ReadCafe,
  enZhA21ListenWeekend,
];
