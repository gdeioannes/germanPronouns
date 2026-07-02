// Reorganizes the hanzi data into thematic categories:
//
//   dart run tool/organize_hanzi.dart
//
// Reads every `HanziEntry(...)` line from the existing data file(s) (the legacy
// frequency chunks if present, else the categorized `hanzi_data.dart` itself),
// assigns each character to a category from the spec below, and rewrites
// `lib/data/courses/en_zh_hanzi/hanzi_data.dart` grouped by category. The
// pinyin/meaning of every entry travels along untouched.
//
// The '*' spec is the catch-all: any character no earlier category claimed
// lands there (in original frequency order), so the 1000 characters always
// partition exactly. Duplicate or unknown spec characters abort with an error.
import 'dart:io';

/// (id, display title, characters) — order here is the course order.
/// '*' as characters = the remainder bucket.
const List<(String, String, String)> kCategorySpec = [
  (
    'essentials',
    'Little words',
    '的了是不在个们着就和要也得以会可而过么之都只如把还用第样其此与或将被'
        '于所同又却并即且乎吗呢吧若虽既般况每些两很太最更共约仅甚曾未必该则'
        '及什怎哪谁何无没非别令使由至向从往相自为因让较稍逐渐忽挺随似尽竟确'
        '有这那能对然当但现已几才便等像各总比',
  ),
  (
    'numbers_time',
    'Numbers & time',
    '一三四五六七八九十百千万亿零半双数号岁年月日时分秒天期早晚夜午晨昨今'
        '春夏秋冬季久常初末尾始终周点次刻钟候前后先再',
  ),
  (
    'people',
    'People & family',
    '人我你他她它您男女孩儿子母父妈爸妻夫兄弟姐妹叔姨爷孙婆娘童友朋民师王'
        '官士员者宾农客主亲婚神',
  ),
  (
    'actions',
    'Everyday actions',
    '来到出去走跑跳坐站睡醒起回进入开关放拿打找给送买吃喝尝咬穿洗擦扫挂搬'
        '抬推抱抓扔换修盖剪煮烧烤炒吹呼吸闻摸碰踢爬滚滑飘浮沉逃追赶躲藏丢偷'
        '骗救帮护陪迎递托靠挤堆铺卷停止做作干办行取接交带提拉持供排压载存借'
        '租购售销领收留装造建发住叫唱举跟倒转变立失完解切',
  ),
  (
    'mind',
    'Mind, speech & feelings',
    '说话想知思觉懂忘记信爱恨怕喜欢感情意心猜疑忆谢请问答讲谈论议评批判念'
        '听看见观望笑哭吵闹骂夸劝祝诉认识悲怒烦恼愁忧虑慌羞骄傲谦虚诚善恶慈'
        '愿希惊乐苦痛幸福志决选求待应灵迷',
  ),
  (
    'qualities',
    'Describing things',
    '大小多少好新旧高低长快远近深满空真直正重轻强弱难易忙闲累困饿渴饱醉晕'
        '冷暖热凉湿脏净亮暗粗厚薄宽窄尖硬软鲜甜酸辣咸淡香臭丑美胖瘦矮壮穷富'
        '贵老青红白黑色光明静独奇丽细紧足全整平准极简详略缺剩余增减添补均密'
        '显险清安',
  ),
  (
    'body',
    'Body & health',
    '头手口眼脸脚耳鼻嘴牙舌骨血背腰腿臂胸肚眉汗身体目睛病医药针疗症疾患康'
        '健锻炼死命活生疼痒泪息',
  ),
  (
    'food',
    'Food & kitchen',
    '茶饭菜肉蛋奶糖盐油汤瓜豆麦粮米酒果杯碗筷勺刀叉壶锅炉瓶盆桶',
  ),
  ('animals', 'Animals', '鸟鱼牛羊马猪狗猫虎龙熊鸡蛇兔鼠猴象毛皮'),
  (
    'nature',
    'Nature & weather',
    '山水火石河江湖海云雨雪冰雷风阳阴地田野草叶花树林森沙泥岩岛洋波浪溪星'
        '气界世环染污',
  ),
  (
    'places',
    'Places & travel',
    '国家城市京州洲村乡镇县省郊区路街巷店馆厂园院楼房门窗墙顶底桥场台局'
        '处址境域港湾岸边角座层梯厅厨卧室东西南北左右中上下里外内间面方位道'
        '车船飞汽票轮舱驶骑乘途速堵游运通达铁',
  ),
  (
    'home',
    'Home & belongings',
    '床灯桌椅板镜伞锁篮箱柜架枕毯巾衣裤裙鞋袜帽衫袋扣袖布网屏幕键盘机器码'
        '电视表球歌画图玉珠宝币钱金银钢',
  ),
  (
    'school',
    'School, words & work',
    '学校课班书读写字词典篇页段文句章题考练习预测验错教育笔纸语言音声名工'
        '业商产品价费税账贸支款项算计诗曲术究程',
  ),
  (
    'state',
    'China & the state',
    '军战队争政府委联统治制义法社团集群级证卫朝史纪基公',
  ),
  ('world', 'Names & the world', '英德克罗巴尼阿兰卡华苏亚'),
  ('society', 'Big ideas', '*'),
];

const String kDataDir = 'lib/data/courses/en_zh_hanzi';

void main() {
  // ── Collect every entry line in original (frequency) order ────────────────
  final entryOf = <String, String>{};
  final order = <String>[];
  final entryPattern = RegExp(r"^\s*HanziEntry\('(.)',");
  final chunkFiles = [
    for (var i = 1; i <= 4; i++) File('$kDataDir/hanzi_data_$i.dart'),
  ].where((f) => f.existsSync()).toList();
  final sources = chunkFiles.isNotEmpty
      ? chunkFiles
      : [File('$kDataDir/hanzi_data.dart')];
  for (final f in sources) {
    for (final line in f.readAsLinesSync()) {
      final m = entryPattern.firstMatch(line);
      if (m == null) continue;
      final c = m.group(1)!;
      if (entryOf.containsKey(c)) {
        stderr.writeln('DUPLICATE entry "$c" in ${f.path}');
        exit(1);
      }
      entryOf[c] = line.trim();
      order.add(c);
    }
  }
  stdout.writeln('Read ${order.length} entries from '
      '${sources.map((f) => f.uri.pathSegments.last).join(', ')}.');

  // ── Assign to categories ───────────────────────────────────────────────────
  final used = <String>{};
  final byCategory = <String, List<String>>{}; // id -> chars in course order
  String? restId;
  for (final (id, _, chars) in kCategorySpec) {
    if (chars == '*') {
      restId = id;
      byCategory[id] = [];
      continue;
    }
    final list = byCategory[id] = [];
    for (final c in chars.runes.map(String.fromCharCode)) {
      if (!entryOf.containsKey(c)) {
        stderr.writeln('Category "$id": "$c" is not in the data set.');
        exit(1);
      }
      if (!used.add(c)) {
        stderr.writeln('Category "$id": "$c" is already assigned elsewhere.');
        exit(1);
      }
      list.add(c);
    }
  }
  final rest = [for (final c in order) if (!used.contains(c)) c];
  if (restId != null) byCategory[restId] = rest;
  stdout.writeln('Remainder → "$restId" (${rest.length}): ${rest.join()}');

  // ── Emit the categorized data file ────────────────────────────────────────
  final out = StringBuffer('''
// Reorganized by tool/organize_hanzi.dart — to move characters between
// categories, edit the spec there and re-run it; the pinyin/meaning of each
// entry travels along unchanged.

/// One character of the writing course: the [char] itself, its [pinyin]
/// (with tone marks, the most common reading), and a short English [meaning].
class HanziEntry {
  const HanziEntry(this.char, this.pinyin, this.meaning);

  final String char;
  final String pinyin;
  final String meaning;
}

/// A thematic group of characters — one drawer section of the course.
class HanziCategory {
  const HanziCategory(this.id, this.title, this.entries);

  final String id;
  final String title;
  final List<HanziEntry> entries;
}

/// The 1000 most common Chinese characters, grouped by theme. Uniqueness and
/// the 1000-count are enforced by `test/en_zh_hanzi_course_test.dart`.
final List<HanziCategory> hanziCategories = [
''');
  for (final (id, title, _) in kCategorySpec) {
    final chars = byCategory[id]!;
    out.writeln("  HanziCategory('$id', '$title', [");
    for (final c in chars) {
      out.writeln('    ${entryOf[c]}');
    }
    out.writeln('  ]),');
  }
  out.write('''
];

/// Every character across all categories, in course order.
final List<HanziEntry> hanzi1000 = [
  for (final c in hanziCategories) ...c.entries,
];
''');
  File('$kDataDir/hanzi_data.dart').writeAsStringSync(out.toString());
  final counts = [
    for (final (id, _, _) in kCategorySpec) '$id ${byCategory[id]!.length}',
  ].join(', ');
  stdout.writeln('Wrote $kDataDir/hanzi_data.dart ($counts).');
}
