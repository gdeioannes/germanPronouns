import '../../../models/quiz_content.dart';
import 'zh_en_builder.dart';

/// A1.1 — First Contact · 初次接触. Mandarin → English.
///
/// Big rocks: the verb `be` (Z12 — Chinese adjectives need no copula), `a/an`
/// (Z11 — Chinese has no articles), `he/she/it` (Z20 — spoken *tā* is
/// genderless), and the English sounds Mandarin lacks (Z1–Z4: the alphabet,
/// `th`, `/v/`, final consonants).

final QuizContent zhEnA11Alphabet = zhEnSpeak(
  id: 'zh_en_a1_1_alphabet',
  title: '字母与发音 · The alphabet',
  intro: '英语用的是拉丁字母，和拼音一样——但字母的读音不同。听一听，跟着读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '你的优势',
      text: '拼音已经让你熟悉这 26 个字母的样子。这里只需要学它们在英语里的读音。',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '元音',
      text: '英语元音 a e i o u 的读音和拼音不同：a≈/eɪ/，e≈/iː/，i≈/aɪ/。先跟读，别用拼音去套。',
    ),
  ],
  items: const [
    CourseItem(prompt: '字母 A–G', answer: 'A, B, C, D, E, F, G'),
    CourseItem(prompt: '字母 H–N', answer: 'H, I, J, K, L, M, N'),
    CourseItem(prompt: '字母 O–T', answer: 'O, P, Q, R, S, T'),
    CourseItem(prompt: '字母 U–Z', answer: 'U, V, W, X, Y, Z'),
    CourseItem(prompt: '五个元音字母', answer: 'a, e, i, o, u'),
    CourseItem(prompt: '拼读：hello', answer: 'H-E-L-L-O, hello'),
    CourseItem(prompt: '拼读：thanks', answer: 'T-H-A-N-K-S, thanks'),
  ],
);

final QuizContent zhEnA11Numbers = zhEnVocab(
  id: 'zh_en_a1_1_numbers',
  title: '数字 0–20 · Numbers',
  intro: '数字 0 到 20 是所有更大数字的基础，先背熟。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '注意拼写',
      text: '容易拼错的：four / fourteen（有 u），nine，twelve，thirteen，fifteen（不是 five-teen）。',
    ),
  ],
  pairs: const [
    MapEntry('0', 'zero'),
    MapEntry('1', 'one'),
    MapEntry('2', 'two'),
    MapEntry('3', 'three'),
    MapEntry('4', 'four'),
    MapEntry('5', 'five'),
    MapEntry('6', 'six'),
    MapEntry('7', 'seven'),
    MapEntry('8', 'eight'),
    MapEntry('9', 'nine'),
    MapEntry('10', 'ten'),
    MapEntry('11', 'eleven'),
    MapEntry('12', 'twelve'),
    MapEntry('13', 'thirteen'),
    MapEntry('14', 'fourteen'),
    MapEntry('15', 'fifteen'),
    MapEntry('16', 'sixteen'),
    MapEntry('17', 'seventeen'),
    MapEntry('18', 'eighteen'),
    MapEntry('19', 'nineteen'),
    MapEntry('20', 'twenty'),
  ],
);

final QuizContent zhEnA11Pronouns = zhEnVocab(
  id: 'zh_en_a1_1_pronouns',
  title: '人称代词 · Subject pronouns',
  intro: '做动作的人——英语的主格人称代词。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ he / she / it（Z20）',
      text: '中文里 他 / 她 / 它 读音都是「tā」，但英语必须分清：he（男）、she（女）、it（物/动物）。'
          '说话时特别容易把 she 说成 he——多练。',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'I 永远大写',
      text: '「我」= I，无论在句子哪个位置都要大写。',
    ),
  ],
  pairs: const [
    MapEntry('我', 'I'),
    MapEntry('你', 'you'),
    MapEntry('他', 'he'),
    MapEntry('她', 'she'),
    MapEntry('它', 'it'),
    MapEntry('我们', 'we'),
    MapEntry('你们', 'you'),
    MapEntry('他们 / 她们', 'they'),
    MapEntry('它们', 'they'),
    MapEntry('咱们（包括你）', 'we'),
  ],
);

final QuizContent zhEnA11Be = zhEnFill(
  id: 'zh_en_a1_1_be',
  title: '动词 be：am / is / are',
  intro: '英语的「是」——be 动词。它随主语变化：I am、you are、he/she/it is。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '口诀',
      text: 'I → am，he/she/it → is，you/we/they → are。',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 形容词前也要 be（Z12）',
      text: '中文「他很高」没有「是」，但英语必须说 He **is** tall——形容词前也要加 be。别漏掉。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我是学生。', answer: 'I **am** a student.'),
    CourseItem(prompt: '你是老师。', answer: 'You **are** a teacher.'),
    CourseItem(prompt: '他很高。', answer: 'He **is** tall.'),
    CourseItem(prompt: '她是我的朋友。', answer: 'She **is** my friend.'),
    CourseItem(prompt: '它是一只猫。', answer: 'It **is** a cat.'),
    CourseItem(prompt: '我们是中国人。', answer: 'We **are** Chinese.'),
    CourseItem(prompt: '他们很忙。', answer: 'They **are** busy.'),
    CourseItem(prompt: '这是一本书。', answer: 'This **is** a book.'),
    CourseItem(prompt: '你们是学生。', answer: 'You **are** students.'),
    CourseItem(prompt: '我妈妈是护士。', answer: 'My mother **is** a nurse.'),
    CourseItem(prompt: '你的书很旧。', answer: 'Your book **is** old.'),
    CourseItem(prompt: '我今天很累。', answer: 'I **am** tired today.'),
    CourseItem(prompt: '那些椅子是新的。', answer: 'Those chairs **are** new.'),
    CourseItem(prompt: '天气很冷。', answer: 'The weather **is** cold.'),
    CourseItem(prompt: '你和我是好朋友。', answer: 'You and I **are** good friends.'),
  ],
);

final QuizContent zhEnA11SpeakIntro = zhEnSpeak(
  id: 'zh_en_a1_1_speak_intro',
  title: '开口说：自我介绍',
  intro: '用英语介绍自己——听并跟读。',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '缩写更自然',
      text: 'I am → I\'m，What is → What\'s。口语里几乎都用缩写。',
    ),
  ],
  items: const [
    CourseItem(prompt: '你好！', answer: 'Hello!'),
    CourseItem(prompt: '我叫李明。', answer: "I'm Li Ming."),
    CourseItem(prompt: '我来自中国。', answer: "I'm from China."),
    CourseItem(prompt: '我是学生。', answer: "I'm a student."),
    CourseItem(prompt: '你叫什么名字？', answer: "What's your name?"),
    CourseItem(prompt: '你好吗？', answer: 'How are you?'),
    CourseItem(prompt: '我很好，谢谢。', answer: "I'm fine, thank you."),
    CourseItem(prompt: '很高兴认识你。', answer: 'Nice to meet you.'),
  ],
);

final QuizContent zhEnA11AAn = zhEnFill(
  id: 'zh_en_a1_1_a_an',
  title: '不定冠词 a / an',
  intro: '中文没有冠词，但英语在「单数、可数、初次提到」的名词前几乎都要加 a 或 an。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'a 还是 an？',
      text: '看下一个词的读音：辅音音开头用 a（a book），元音音开头用 an（an apple）。',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 看读音，不是看字母（Z11）',
      text: 'an hour（h 不发音，元音开头）、a university（读 /juː/，辅音开头）。凭耳朵判断。',
    ),
  ],
  items: const [
    CourseItem(prompt: '一个苹果', answer: "It's **an** apple."),
    CourseItem(prompt: '一本书', answer: "It's **a** book."),
    CourseItem(prompt: '一个鸡蛋', answer: "It's **an** egg."),
    CourseItem(prompt: '一位老师', answer: "She's **a** teacher."),
    CourseItem(prompt: '一个橙子', answer: "It's **an** orange."),
    CourseItem(prompt: '一个小时后', answer: 'in **an** hour'),
    CourseItem(prompt: '一所大学', answer: "It's **a** university."),
    CourseItem(prompt: '一辆车', answer: "It's **a** car."),
    CourseItem(prompt: '一名工程师', answer: "He's **an** engineer."),
    CourseItem(prompt: '一只狗', answer: "It's **a** dog."),
    CourseItem(prompt: '一把伞（umbrella）', answer: "It's **an** umbrella."),
    CourseItem(prompt: '一个想法（idea）', answer: "It's **an** idea."),
    CourseItem(prompt: '一位护士', answer: "She's **a** nurse."),
    CourseItem(prompt: '一个诚实的男孩（honest，h 不发音）', answer: "He's **an** honest boy."),
    CourseItem(prompt: '一个欧洲国家（European，读 /jʊ/）', answer: "It's **a** European country."),
  ],
);

final QuizContent zhEnA11Nationalities = zhEnVocab(
  id: 'zh_en_a1_1_nationalities',
  title: '国家与国籍 · Countries',
  intro: '国家、语言和国籍。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 首字母大写',
      text: '英语里国家、国籍和语言都要大写：China、Chinese、English——即使在句子中间也一样。',
    ),
  ],
  pairs: const [
    MapEntry('中国', 'China'),
    MapEntry('中国人 / 中国的', 'Chinese'),
    MapEntry('英语', 'English'),
    MapEntry('美国', 'America'),
    MapEntry('英国', 'Britain'),
    MapEntry('澳大利亚', 'Australia'),
    MapEntry('加拿大', 'Canada'),
    MapEntry('日本', 'Japan'),
    MapEntry('法国', 'France'),
    MapEntry('德国', 'Germany'),
  ],
);

final QuizContent zhEnA11ListenMeet = zhEnListen(
  id: 'zh_en_a1_1_listen_meet',
  title: '听力：Nice to meet you',
  passageTitle: 'Meet Emma',
  passage:
      "Hi! My name is Emma. I'm from London, in the UK. I'm twenty years old "
      "and I'm a student. I live with two friends. I like music and books. "
      "Nice to meet you! What's your name?",
  passageTranslation:
      '你好！我叫 Emma。我来自英国伦敦。我二十岁，是一名学生。我和两个朋友住在一起。'
      '我喜欢音乐和书。很高兴认识你！你叫什么名字？',
  intro: '课文不会显示在屏幕上——先听，再答题。可以反复播放。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '抓关键词',
      text: '听 where（哪里）、how old（多大）、like（喜欢什么）——抓住这几个信息就够答题了。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where is Emma from?',
      options: ['Beijing', 'London', 'Paris'],
      correctIndex: 1,
      questionTranslation: 'Emma 来自哪里？',
    ),
    ReadingQuestion(
      question: 'How old is she?',
      options: ['12', '20', '22'],
      correctIndex: 1,
      questionTranslation: '她多大了？',
    ),
    ReadingQuestion(
      question: 'What does she like?',
      options: ['Sport', 'Music and books', 'Films'],
      correctIndex: 1,
      questionTranslation: '她喜欢什么？',
    ),
  ],
);

final QuizContent zhEnA11ThisThat = zhEnFill(
  id: 'zh_en_a1_1_this_that',
  title: '指示词 this / that / these / those',
  intro: '近的用 this（复数 these），远的用 that（复数 those）。',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '近 vs 远，单 vs 复',
      text: 'this（这，单）/ these（这些，复）；that（那，单）/ those（那些，复）。',
    ),
  ],
  items: const [
    CourseItem(prompt: '这是我的书。', answer: '**This** is my book.'),
    CourseItem(prompt: '那是你的包。', answer: '**That** is your bag.'),
    CourseItem(prompt: '这些是我的朋友。', answer: '**These** are my friends.'),
    CourseItem(prompt: '那些是他们的书。', answer: '**Those** are their books.'),
    CourseItem(prompt: '这个用英语怎么说？', answer: "What's **this** in English?"),
    CourseItem(prompt: '那是什么？', answer: "What's **that**?"),
    CourseItem(prompt: '这是一个苹果。', answer: '**This** is an apple.'),
    CourseItem(prompt: '那些是我们的椅子。', answer: '**Those** are our chairs.'),
    CourseItem(prompt: '这些书是新的。', answer: '**These** books are new.'),
    CourseItem(prompt: '那个男孩是我弟弟。', answer: '**That** boy is my little brother.'),
    CourseItem(prompt: '这些苹果很好吃。', answer: '**These** apples are delicious.'),
    CourseItem(prompt: '那些人是老师。', answer: '**Those** people are teachers.'),
    CourseItem(prompt: '这支笔是红色的。', answer: '**This** pen is red.'),
    CourseItem(prompt: '那辆车是我爸爸的。', answer: "**That** car is my father's."),
    CourseItem(prompt: '这些是你的钥匙吗？', answer: 'Are **these** your keys?'),
  ],
);

final QuizContent zhEnA11Jobs = zhEnVocab(
  id: 'zh_en_a1_1_jobs',
  title: '职业 · Jobs',
  intro: '常见职业。问职业说：What do you do?',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '职业前要加 a',
      text: '说职业时前面要有冠词：I\'m **a** teacher（不是 I\'m teacher）。这又是 Z11 的冠词规则。',
    ),
  ],
  pairs: const [
    MapEntry('老师', 'teacher'),
    MapEntry('学生', 'student'),
    MapEntry('医生', 'doctor'),
    MapEntry('护士', 'nurse'),
    MapEntry('工程师', 'engineer'),
    MapEntry('厨师', 'cook'),
    MapEntry('司机', 'driver'),
    MapEntry('警察', 'police officer'),
    MapEntry('农民', 'farmer'),
    MapEntry('服务员', 'waiter'),
  ],
);

final QuizContent zhEnA11ReadFamily = zhEnRead(
  id: 'zh_en_a1_1_read_family',
  title: '阅读：This is my family',
  passageTitle: 'My family',
  passage:
      'This is my family. My name is Lin. I have a father, a mother, and a '
      'little brother. My father is a doctor and my mother is a teacher. My '
      'brother is six years old. We have a small dog. Its name is Coco. I love '
      'my family.',
  passageTranslation:
      '这是我的家。我叫 Lin。我有爸爸、妈妈和一个弟弟。我爸爸是医生，妈妈是老师。'
      '我弟弟六岁。我们有一只小狗，它叫 Coco。我爱我的家。',
  intro: '读一段简短的自我介绍。先读英文，中文翻译在信息按钮里。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ his / her（Z20）',
      text: '留意 My father is **a** doctor：每个职业前都有 a。文中 father→he，mother→she，别混。',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: "What is the father's job?",
      options: ['Teacher', 'Doctor', 'Driver'],
      correctIndex: 1,
      questionTranslation: '爸爸的职业是什么？',
    ),
    ReadingQuestion(
      question: 'How old is the brother?',
      options: ['Four', 'Six', 'Ten'],
      correctIndex: 1,
      questionTranslation: '弟弟多大了？',
    ),
    ReadingQuestion(
      question: "What is the dog's name?",
      options: ['Lin', 'Coco', 'Emma'],
      correctIndex: 1,
      questionTranslation: '小狗叫什么名字？',
    ),
  ],
);

final QuizContent zhEnA11Colours = zhEnVocab(
  id: 'zh_en_a1_1_colours',
  title: '颜色与课堂用品 · Colours',
  intro: '常见颜色和几样课堂物品。',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '形容词放名词前',
      text: '颜色作形容词放在名词前：a **red** pen（一支红笔），不是 a pen red。',
    ),
  ],
  pairs: const [
    MapEntry('红色', 'red'),
    MapEntry('蓝色', 'blue'),
    MapEntry('绿色', 'green'),
    MapEntry('黄色', 'yellow'),
    MapEntry('黑色', 'black'),
    MapEntry('白色', 'white'),
    MapEntry('书', 'book'),
    MapEntry('笔', 'pen'),
    MapEntry('桌子', 'desk'),
    MapEntry('椅子', 'chair'),
  ],
);

final QuizContent zhEnA11SpeakThV = zhEnSpeak(
  id: 'zh_en_a1_1_speak_th_v',
  title: '发音：th 与 /v/',
  intro: '这两个音中文里没有，是中国学习者最容易出错的地方。多听多练。',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ th 的舌位（Z2）',
      text: '把舌尖轻轻放到上下牙之间再送气，就是 th。别读成 s 或 f：think 不是 sink，three 不是 free。',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ /v/ 不是 /w/（Z3）',
      text: '/v/ 用上牙咬下唇（有摩擦）；/w/ 双唇收圆。very 不是 wery，vest 不是 west。',
    ),
  ],
  items: const [
    CourseItem(prompt: 'th（清辅音）', answer: 'think, thank, three, mouth'),
    CourseItem(prompt: 'th（浊辅音）', answer: 'this, that, they, mother'),
    CourseItem(prompt: '对比 s / th', answer: 'sink – think, sing – thing'),
    CourseItem(prompt: '/v/ 音', answer: 'very, video, five, love'),
    CourseItem(prompt: '对比 v / w', answer: 'vine – wine, vest – west'),
    CourseItem(prompt: '一整句', answer: 'I have a very nice view of the three trees.'),
  ],
);

final QuizContent zhEnA11DictName = zhEnDict(
  id: 'zh_en_a1_1_dict_name',
  title: '听写：My name & number',
  intro: '听英语句子，把你听到的打出来。这能训练你听清并写出中文里常漏掉的 -s 和冠词。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 别漏词尾（Z4 / Z13 / Z15）',
      text: '注意结尾的 -s：two brother**s**、She i**s**。这些词尾正是中文母语者最常漏掉的。',
    ),
  ],
  items: const [
    CourseItem(prompt: '我叫安娜。', answer: 'My name is Anna.'),
    CourseItem(prompt: '我来自中国。', answer: 'I am from China.'),
    CourseItem(prompt: '我是学生。', answer: 'I am a student.'),
    CourseItem(prompt: '我有两个兄弟。', answer: 'I have two brothers.'),
    CourseItem(prompt: '她是老师。', answer: 'She is a teacher.'),
    CourseItem(prompt: '这是我的书。', answer: 'This is my book.'),
    CourseItem(prompt: '我二十岁。', answer: 'I am twenty years old.'),
    CourseItem(prompt: '他是医生。', answer: 'He is a doctor.'),
    CourseItem(prompt: '我们来自北京。', answer: 'We are from Beijing.'),
    CourseItem(prompt: '那是一只猫。', answer: 'That is a cat.'),
    CourseItem(prompt: '我的电话号码是九〇五。', answer: 'My phone number is nine zero five.'),
    CourseItem(prompt: '她十八岁。', answer: 'She is eighteen years old.'),
    CourseItem(prompt: '我们是学生。', answer: 'We are students.'),
    CourseItem(prompt: '他叫汤姆。', answer: 'His name is Tom.'),
    CourseItem(prompt: '这些是我的朋友。', answer: 'These are my friends.'),
  ],
);

final QuizContent zhEnA11Wh = zhEnFill(
  id: 'zh_en_a1_1_wh',
  title: '特殊疑问词 what / where / who',
  intro: '用 what（什么）、where（哪里）、who（谁）提问。疑问词放句首。',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 疑问词放句首（Z-word order）',
      text: '中文「你叫什么」里「什么」在中间，但英语疑问词要放句首：**What** is your name?',
    ),
  ],
  items: const [
    CourseItem(prompt: '你叫什么名字？', answer: '**What** is your name?'),
    CourseItem(prompt: '你住在哪里？', answer: '**Where** do you live?'),
    CourseItem(prompt: '她是谁？', answer: '**Who** is she?'),
    CourseItem(prompt: '这是什么？', answer: '**What** is this?'),
    CourseItem(prompt: '你的老师是谁？', answer: '**Who** is your teacher?'),
    CourseItem(prompt: '你的学校在哪里？', answer: '**Where** is your school?'),
    CourseItem(prompt: '你的书在哪里？', answer: '**Where** is your book?'),
    CourseItem(prompt: '那个女孩是谁？', answer: '**Who** is that girl?'),
    CourseItem(prompt: '你最喜欢的颜色是什么？', answer: '**What** is your favourite colour?'),
    CourseItem(prompt: '你的包里有什么？', answer: '**What** is in your bag?'),
    CourseItem(prompt: '洗手间在哪里？', answer: '**Where** is the bathroom?'),
    CourseItem(prompt: '你的英语老师是谁？', answer: '**Who** is your English teacher?'),
    CourseItem(prompt: '你的工作是什么？', answer: '**What** is your job?'),
    CourseItem(prompt: '你的父母在哪里？', answer: '**Where** are your parents?'),
    CourseItem(prompt: '门口的那个男人是谁？', answer: '**Who** is the man at the door?'),
  ],
);

/// A1.1 in chain order (interleaved sound / knowledge / listening / reading /
/// dictation, ≤ 2 knowledge quizzes in a row).
final List<QuizContent> zhEnA1_1 = [
  zhEnA11Alphabet,
  zhEnA11Numbers,
  zhEnA11Pronouns,
  zhEnA11Be,
  zhEnA11SpeakIntro,
  zhEnA11AAn,
  zhEnA11Nationalities,
  zhEnA11ListenMeet,
  zhEnA11ThisThat,
  zhEnA11Jobs,
  zhEnA11ReadFamily,
  zhEnA11Colours,
  zhEnA11SpeakThV,
  zhEnA11DictName,
  zhEnA11Wh,
];
