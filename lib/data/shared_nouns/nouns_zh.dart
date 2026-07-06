import '../content/noun_collection.dart';
import '../noun_database.dart';
import '../../models/quiz_config.dart';

/// The shared Mandarin noun list — reference vocabulary for every course that
/// teaches Chinese (today: `en_zh` and `en_zh_hanzi`, whose learners speak
/// English). Chinese has no grammatical gender, so entries carry `-`. The
/// `english` meaning includes the pinyin reading (e.g. `dad · bàba`).
/// Published to `assets/content/shared/nouns/zh.json`.
GermanNoun _n(
  String noun,
  String english,
  List<String> categories, {
  NounDifficulty difficulty = NounDifficulty.beginner,
}) => GermanNoun(
  noun: noun,
  gender: '-',
  english: english,
  categories: categories,
  difficulty: difficulty,
  declensionSafe: true,
);

final NounCollection mandarinNounCollection = NounCollection(
  categoryDisplayNames: const {
    'family': 'Family (家人 jiārén)',
    'food': 'Food (食物 shíwù)',
    'drinks': 'Drinks (饮料 yǐnliào)',
    'animals': 'Animals (动物 dòngwù)',
    'bodyParts': 'Body (身体 shēntǐ)',
    'clothing': 'Clothing (衣服 yīfu)',
    'city': 'City (城市 chéngshì)',
    'transport': 'Transport (交通 jiāotōng)',
    'school': 'School (学校 xuéxiào)',
    'time': 'Time (时间 shíjiān)',
    'nature': 'Nature (自然 zìrán)',
  },
  nouns: [
    // Family
    _n('爸爸', 'dad · bàba', ['family']),
    _n('妈妈', 'mum · māma', ['family']),
    _n('哥哥', 'older brother · gēge', ['family']),
    _n('姐姐', 'older sister · jiějie', ['family']),
    _n('弟弟', 'younger brother · dìdi', ['family']),
    _n('妹妹', 'younger sister · mèimei', ['family']),
    _n('儿子', 'son · érzi', ['family']),
    _n('女儿', "daughter · nǚ'ér", ['family']),
    _n('家', 'family/home · jiā', ['family']),
    _n('朋友', 'friend · péngyou', ['family']),
    // Food
    _n('米饭', 'cooked rice · mǐfàn', ['food']),
    _n('面条', 'noodles · miàntiáo', ['food']),
    _n('面包', 'bread · miànbāo', ['food']),
    _n('鸡蛋', 'egg · jīdàn', ['food']),
    _n('肉', 'meat · ròu', ['food']),
    _n('鱼', 'fish · yú', ['food']),
    _n('苹果', 'apple · píngguǒ', ['food']),
    _n('香蕉', 'banana · xiāngjiāo', ['food']),
    _n('蔬菜', 'vegetables · shūcài', ['food']),
    _n('汤', 'soup · tāng', ['food']),
    // Drinks
    _n('水', 'water · shuǐ', ['drinks']),
    _n('茶', 'tea · chá', ['drinks']),
    _n('咖啡', 'coffee · kāfēi', ['drinks']),
    _n('牛奶', 'milk · niúnǎi', ['drinks']),
    _n('果汁', 'juice · guǒzhī', ['drinks']),
    _n('啤酒', 'beer · píjiǔ', ['drinks']),
    _n('可乐', 'cola · kělè', ['drinks']),
    // Animals
    _n('狗', 'dog · gǒu', ['animals']),
    _n('猫', 'cat · māo', ['animals']),
    _n('马', 'horse · mǎ', ['animals']),
    _n('牛', 'cow/ox · niú', ['animals']),
    _n('鸟', 'bird · niǎo', ['animals']),
    _n('熊猫', 'panda · xióngmāo', ['animals']),
    _n('老虎', 'tiger · lǎohǔ', ['animals']),
    _n('兔子', 'rabbit · tùzi', ['animals']),
    // Body
    _n('头', 'head · tóu', ['bodyParts']),
    _n('手', 'hand · shǒu', ['bodyParts']),
    _n('眼睛', 'eye · yǎnjing', ['bodyParts']),
    _n('耳朵', 'ear · ěrduo', ['bodyParts']),
    _n('嘴', 'mouth · zuǐ', ['bodyParts']),
    _n('鼻子', 'nose · bízi', ['bodyParts']),
    _n('脚', 'foot · jiǎo', ['bodyParts']),
    _n('心', 'heart · xīn', ['bodyParts']),
    // Clothing
    _n('衣服', 'clothes · yīfu', ['clothing']),
    _n('裤子', 'trousers · kùzi', ['clothing']),
    _n('裙子', 'skirt · qúnzi', ['clothing']),
    _n('鞋', 'shoe · xié', ['clothing']),
    _n('帽子', 'hat · màozi', ['clothing']),
    _n('外套', 'coat · wàitào', ['clothing']),
    // City
    _n('城市', 'city · chéngshì', ['city']),
    _n('街', 'street · jiē', ['city']),
    _n('房子', 'house · fángzi', ['city']),
    _n('商店', 'shop · shāngdiàn', ['city']),
    _n('超市', 'supermarket · chāoshì', ['city']),
    _n('公园', 'park · gōngyuán', ['city']),
    _n('银行', 'bank · yínháng', ['city']),
    _n('医院', 'hospital · yīyuàn', ['city']),
    _n('学校', 'school · xuéxiào', ['city', 'school']),
    _n('饭馆', 'restaurant · fànguǎn', ['city']),
    // Transport
    _n('车', 'car/vehicle · chē', ['transport']),
    _n('火车', 'train · huǒchē', ['transport']),
    _n('公共汽车', 'bus · gōnggòng qìchē', ['transport']),
    _n('飞机', 'airplane · fēijī', ['transport']),
    _n('自行车', 'bicycle · zìxíngchē', ['transport']),
    _n('船', 'ship/boat · chuán', ['transport']),
    _n('出租车', 'taxi · chūzūchē', ['transport']),
    _n('票', 'ticket · piào', ['transport']),
    // School
    _n('书', 'book · shū', ['school']),
    _n('本子', 'notebook · běnzi', ['school']),
    _n('笔', 'pen · bǐ', ['school']),
    _n('桌子', 'table · zhuōzi', ['school']),
    _n('椅子', 'chair · yǐzi', ['school']),
    _n('字', 'character/word · zì', ['school']),
    _n('问题', 'question · wèntí', ['school']),
    _n('老师', 'teacher · lǎoshī', ['school']),
    _n('学生', 'student · xuésheng', ['school']),
    _n('考试', 'exam · kǎoshì', ['school']),
    // Time
    _n('天', 'day · tiān', ['time']),
    _n('星期', 'week · xīngqī', ['time']),
    _n('月', 'month · yuè', ['time']),
    _n('年', 'year · nián', ['time']),
    _n('小时', 'hour · xiǎoshí', ['time']),
    _n('分钟', 'minute · fēnzhōng', ['time']),
    _n('早上', 'morning · zǎoshang', ['time']),
    _n('晚上', 'evening · wǎnshang', ['time']),
    _n('现在', 'now · xiànzài', ['time']),
    _n('周末', 'weekend · zhōumò', ['time']),
    // Nature
    _n('太阳', 'sun · tàiyáng', ['nature']),
    _n('月亮', 'moon · yuèliang', ['nature']),
    _n('天空', 'sky · tiānkōng', ['nature']),
    _n('海', 'sea · hǎi', ['nature']),
    _n('河', 'river · hé', ['nature']),
    _n('山', 'mountain · shān', ['nature']),
    _n('树', 'tree · shù', ['nature']),
    _n('花', 'flower · huā', ['nature']),
    _n('雨', 'rain · yǔ', ['nature']),
    _n('雪', 'snow · xuě', ['nature']),
  ],
);
