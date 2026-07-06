import '../content/noun_collection.dart';
import '../noun_database.dart';
import '../../models/quiz_config.dart';

/// The shared English noun list — reference vocabulary for every course that
/// teaches English (today: `zh_en`, whose learners speak Chinese). English has
/// no grammatical gender, so entries carry `-`; the meaning shown is the
/// Chinese translation (with pinyin). Published to
/// `assets/content/shared/nouns/en.json`.
GermanNoun _n(
  String noun,
  String zh,
  List<String> categories, {
  NounDifficulty difficulty = NounDifficulty.beginner,
}) => GermanNoun(
  noun: noun,
  gender: '-',
  // The word itself is the harmless English fallback; zh_en learners see the
  // Chinese meaning via `meaningFor('zh')`.
  english: noun,
  categories: categories,
  difficulty: difficulty,
  declensionSafe: true,
  meanings: {'zh': zh},
);

final NounCollection englishNounCollection = NounCollection(
  // Chinese-first labels: the Word Library chrome of the zh_en course is
  // Chinese.
  categoryDisplayNames: const {
    'family': '家人 (Family)',
    'food': '食物 (Food)',
    'drinks': '饮料 (Drinks)',
    'animals': '动物 (Animals)',
    'bodyParts': '身体 (Body)',
    'clothing': '衣服 (Clothing)',
    'city': '城市 (City)',
    'transport': '交通 (Transport)',
    'school': '学校 (School)',
    'time': '时间 (Time)',
    'nature': '自然 (Nature)',
  },
  nouns: [
    // Family
    _n('father', '父亲 fùqīn', ['family']),
    _n('mother', '母亲 mǔqīn', ['family']),
    _n('brother', '兄弟 xiōngdì', ['family']),
    _n('sister', '姐妹 jiěmèi', ['family']),
    _n('son', '儿子 érzi', ['family']),
    _n('daughter', '女儿 nǚ\'ér', ['family']),
    _n('grandfather', '祖父 zǔfù', ['family']),
    _n('grandmother', '祖母 zǔmǔ', ['family']),
    _n('family', '家庭 jiātíng', ['family']),
    _n('friend', '朋友 péngyou', ['family']),
    _n('child', '孩子 háizi', ['family']),
    _n('parents', '父母 fùmǔ', ['family']),
    // Food
    _n('bread', '面包 miànbāo', ['food']),
    _n('cheese', '奶酪 nǎilào', ['food']),
    _n('egg', '鸡蛋 jīdàn', ['food']),
    _n('meat', '肉 ròu', ['food']),
    _n('fish', '鱼 yú', ['food', 'animals']),
    _n('rice', '米饭 mǐfàn', ['food']),
    _n('apple', '苹果 píngguǒ', ['food']),
    _n('banana', '香蕉 xiāngjiāo', ['food']),
    _n('vegetable', '蔬菜 shūcài', ['food']),
    _n('soup', '汤 tāng', ['food']),
    _n('cake', '蛋糕 dàngāo', ['food']),
    _n('salad', '沙拉 shālā', ['food']),
    // Drinks
    _n('water', '水 shuǐ', ['drinks']),
    _n('coffee', '咖啡 kāfēi', ['drinks']),
    _n('tea', '茶 chá', ['drinks']),
    _n('milk', '牛奶 niúnǎi', ['drinks']),
    _n('juice', '果汁 guǒzhī', ['drinks']),
    _n('beer', '啤酒 píjiǔ', ['drinks']),
    _n('wine', '葡萄酒 pútaojiǔ', ['drinks']),
    _n('bottle', '瓶子 píngzi', ['drinks']),
    // Animals
    _n('dog', '狗 gǒu', ['animals']),
    _n('cat', '猫 māo', ['animals']),
    _n('horse', '马 mǎ', ['animals']),
    _n('cow', '奶牛 nǎiniú', ['animals']),
    _n('bird', '鸟 niǎo', ['animals']),
    _n('mouse', '老鼠 lǎoshǔ', ['animals']),
    _n('sheep', '羊 yáng', ['animals']),
    _n('pig', '猪 zhū', ['animals']),
    // Body
    _n('head', '头 tóu', ['bodyParts']),
    _n('hand', '手 shǒu', ['bodyParts']),
    _n('eye', '眼睛 yǎnjing', ['bodyParts']),
    _n('ear', '耳朵 ěrduo', ['bodyParts']),
    _n('mouth', '嘴 zuǐ', ['bodyParts']),
    _n('nose', '鼻子 bízi', ['bodyParts']),
    _n('arm', '手臂 shǒubì', ['bodyParts']),
    _n('leg', '腿 tuǐ', ['bodyParts']),
    _n('foot', '脚 jiǎo', ['bodyParts']),
    _n('heart', '心脏 xīnzàng', ['bodyParts']),
    // Clothing
    _n('shirt', '衬衫 chènshān', ['clothing']),
    _n('trousers', '裤子 kùzi', ['clothing']),
    _n('skirt', '裙子 qúnzi', ['clothing']),
    _n('dress', '连衣裙 liányīqún', ['clothing']),
    _n('shoe', '鞋 xié', ['clothing']),
    _n('coat', '外套 wàitào', ['clothing']),
    _n('hat', '帽子 màozi', ['clothing']),
    _n('sock', '袜子 wàzi', ['clothing']),
    // City
    _n('city', '城市 chéngshì', ['city']),
    _n('street', '街道 jiēdào', ['city']),
    _n('house', '房子 fángzi', ['city']),
    _n('shop', '商店 shāngdiàn', ['city']),
    _n('market', '市场 shìchǎng', ['city']),
    _n('church', '教堂 jiàotáng', ['city']),
    _n('museum', '博物馆 bówùguǎn', ['city']),
    _n('bank', '银行 yínháng', ['city']),
    _n('park', '公园 gōngyuán', ['city']),
    _n('hospital', '医院 yīyuàn', ['city']),
    // Transport
    _n('car', '汽车 qìchē', ['transport']),
    _n('train', '火车 huǒchē', ['transport']),
    _n('bus', '公共汽车 gōnggòng qìchē', ['transport']),
    _n('plane', '飞机 fēijī', ['transport']),
    _n('bicycle', '自行车 zìxíngchē', ['transport']),
    _n('ship', '船 chuán', ['transport']),
    _n('taxi', '出租车 chūzūchē', ['transport']),
    _n('ticket', '票 piào', ['transport']),
    // School
    _n('school', '学校 xuéxiào', ['school']),
    _n('book', '书 shū', ['school']),
    _n('notebook', '笔记本 bǐjìběn', ['school']),
    _n('pen', '钢笔 gāngbǐ', ['school']),
    _n('table', '桌子 zhuōzi', ['school']),
    _n('chair', '椅子 yǐzi', ['school']),
    _n('word', '单词 dāncí', ['school']),
    _n('question', '问题 wèntí', ['school']),
    _n('answer', '答案 dá\'àn', ['school']),
    _n('exam', '考试 kǎoshì', ['school']),
    _n('teacher', '老师 lǎoshī', ['school']),
    _n('student', '学生 xuésheng', ['school']),
    // Time
    _n('day', '天 tiān', ['time']),
    _n('week', '星期 xīngqī', ['time']),
    _n('month', '月 yuè', ['time']),
    _n('year', '年 nián', ['time']),
    _n('hour', '小时 xiǎoshí', ['time']),
    _n('minute', '分钟 fēnzhōng', ['time']),
    _n('morning', '早上 zǎoshang', ['time']),
    _n('night', '夜晚 yèwǎn', ['time']),
    _n('evening', '晚上 wǎnshang', ['time']),
    _n('weekend', '周末 zhōumò', ['time']),
    // Nature
    _n('sun', '太阳 tàiyáng', ['nature']),
    _n('moon', '月亮 yuèliang', ['nature']),
    _n('sky', '天空 tiānkōng', ['nature']),
    _n('sea', '海 hǎi', ['nature']),
    _n('river', '河 hé', ['nature']),
    _n('mountain', '山 shān', ['nature']),
    _n('tree', '树 shù', ['nature']),
    _n('flower', '花 huā', ['nature']),
    _n('rain', '雨 yǔ', ['nature']),
    _n('snow', '雪 xuě', ['nature']),
  ],
);
