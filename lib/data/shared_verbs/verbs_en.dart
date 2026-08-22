import '../content/verb_collection.dart';

/// The shared English verb list — the ~30 most common verbs with the five
/// tenses a learner needs first: present simple, past simple, present
/// continuous, present perfect and future (will). All five tables are derived
/// from the verb's principal parts (base / 3rd person / past / participle /
/// -ing). Meanings: Chinese (the `zh_en` course's main language); the base
/// form doubles as the harmless English fallback. Published to
/// `assets/content/shared/verbs/en.json`.
const List<String> _p = ['I', 'you', 'he/she/it', 'we', 'they'];
const List<String> _be = ['am', 'are', 'is', 'are', 'are'];
const List<String> _have = ['have', 'have', 'has', 'have', 'have'];

List<ConjugationForm> _zip(List<String> forms) => [
  for (var i = 0; i < _p.length; i++)
    ConjugationForm(person: _p[i], form: forms[i]),
];

/// Spanish meanings for the `es_en` course (Spanish speakers learning
/// English).
const Map<String, String> _es = {
  'be': 'ser / estar',
  'have': 'tener',
  'do': 'hacer',
  'say': 'decir',
  'go': 'ir',
  'get': 'conseguir / recibir',
  'make': 'hacer / fabricar',
  'know': 'saber / conocer',
  'think': 'pensar / creer',
  'take': 'tomar / llevar',
  'see': 'ver',
  'come': 'venir',
  'want': 'querer',
  'look': 'mirar',
  'use': 'usar',
  'find': 'encontrar',
  'give': 'dar',
  'tell': 'contar / decir',
  'work': 'trabajar',
  'call': 'llamar',
  'try': 'intentar',
  'ask': 'preguntar / pedir',
  'need': 'necesitar',
  'feel': 'sentir(se)',
  'leave': 'salir / dejar',
  'put': 'poner',
  'mean': 'significar',
  'read': 'leer',
  'eat': 'comer',
  'drink': 'beber',
  'agree': 'estar de acuerdo',
  'answer': 'responder',
  'arrive': 'llegar',
  'become': 'convertirse en',
  'believe': 'creer',
  'break': 'romper',
  'buy': 'comprar',
  'catch': 'atrapar / coger',
  'change': 'cambiar',
  'cost': 'costar',
  'decide': 'decidir',
  'drive': 'conducir / manejar',
  'fail': 'fracasar / suspender',
  'finish': 'terminar',
  'help': 'ayudar',
  'hope': 'esperar (desear)',
  'learn': 'aprender',
  'like': 'gustar',
  'live': 'vivir',
  'lose': 'perder',
  'meet': 'conocer / encontrarse con',
  'miss': 'perder / echar de menos',
  'move': 'mover(se) / mudarse',
  'open': 'abrir',
  'plan': 'planear',
  'play': 'jugar / tocar',
  'promise': 'prometer',
  'rain': 'llover',
  'sleep': 'dormir',
  'speak': 'hablar',
  'start': 'empezar',
  'stay': 'quedarse',
  'study': 'estudiar',
  'travel': 'viajar',
  'turn': 'girar',
  'understand': 'entender',
  'visit': 'visitar',
  'wait': 'esperar',
  'watch': 'ver / mirar',
  'wish': 'desear',
  'write': 'escribir',
};

VerbEntry _v(
  String base,
  String third,
  String past,
  String participle,
  String ing,
  String zh,
) => VerbEntry(
  verb: base,
  english: base,
  meanings: {'zh': zh, 'es': _es[base]!},
  sets: [
    ConjugationSet(
      label: 'Present simple',
      forms: _zip([base, base, third, base, base]),
    ),
    ConjugationSet(
      label: 'Past simple',
      forms: _zip([past, past, past, past, past]),
    ),
    ConjugationSet(
      label: 'Present continuous',
      forms: _zip([for (final b in _be) '$b $ing']),
    ),
    ConjugationSet(
      label: 'Present perfect',
      forms: _zip([for (final h in _have) '$h $participle']),
    ),
    ConjugationSet(
      label: 'Future (will)',
      forms: _zip([for (var i = 0; i < 5; i++) 'will $base']),
    ),
  ],
);

final VerbCollection englishVerbCollection = VerbCollection(
  verbs: [
    // "be" is the one verb whose present/past decline by person.
    VerbEntry(
      verb: 'be',
      english: 'be',
      meanings: const {'zh': '是 shì', 'es': 'ser / estar'},
      sets: [
        ConjugationSet(label: 'Present simple', forms: _zip(_be)),
        ConjugationSet(
          label: 'Past simple',
          forms: _zip(const ['was', 'were', 'was', 'were', 'were']),
        ),
        ConjugationSet(
          label: 'Present continuous',
          forms: _zip([for (final b in _be) '$b being']),
        ),
        ConjugationSet(
          label: 'Present perfect',
          forms: _zip([for (final h in _have) '$h been']),
        ),
        ConjugationSet(
          label: 'Future (will)',
          forms: _zip([for (var i = 0; i < 5; i++) 'will be']),
        ),
      ],
    ),
    _v('have', 'has', 'had', 'had', 'having', '有 yǒu'),
    _v('do', 'does', 'did', 'done', 'doing', '做 zuò'),
    _v('say', 'says', 'said', 'said', 'saying', '说 shuō'),
    _v('go', 'goes', 'went', 'gone', 'going', '去 qù'),
    _v('get', 'gets', 'got', 'got', 'getting', '得到 dédào'),
    _v('make', 'makes', 'made', 'made', 'making', '制作 zhìzuò'),
    _v('know', 'knows', 'knew', 'known', 'knowing', '知道 zhīdào'),
    _v('think', 'thinks', 'thought', 'thought', 'thinking', '想 xiǎng / 认为 rènwéi'),
    _v('take', 'takes', 'took', 'taken', 'taking', '拿 ná'),
    _v('see', 'sees', 'saw', 'seen', 'seeing', '看见 kànjiàn'),
    _v('come', 'comes', 'came', 'come', 'coming', '来 lái'),
    _v('want', 'wants', 'wanted', 'wanted', 'wanting', '想要 xiǎngyào'),
    _v('look', 'looks', 'looked', 'looked', 'looking', '看 kàn'),
    _v('use', 'uses', 'used', 'used', 'using', '用 yòng'),
    _v('find', 'finds', 'found', 'found', 'finding', '找到 zhǎodào'),
    _v('give', 'gives', 'gave', 'given', 'giving', '给 gěi'),
    _v('tell', 'tells', 'told', 'told', 'telling', '告诉 gàosu'),
    _v('work', 'works', 'worked', 'worked', 'working', '工作 gōngzuò'),
    _v('call', 'calls', 'called', 'called', 'calling', '打电话 dǎ diànhuà / 叫 jiào'),
    _v('try', 'tries', 'tried', 'tried', 'trying', '尝试 chángshì'),
    _v('ask', 'asks', 'asked', 'asked', 'asking', '问 wèn'),
    _v('need', 'needs', 'needed', 'needed', 'needing', '需要 xūyào'),
    _v('feel', 'feels', 'felt', 'felt', 'feeling', '感觉 gǎnjué'),
    _v('leave', 'leaves', 'left', 'left', 'leaving', '离开 líkāi'),
    _v('put', 'puts', 'put', 'put', 'putting', '放 fàng'),
    _v('mean', 'means', 'meant', 'meant', 'meaning', '意思是 yìsi shì'),
    _v('read', 'reads', 'read', 'read', 'reading', '读 dú'),
    _v('eat', 'eats', 'ate', 'eaten', 'eating', '吃 chī'),
    _v('drink', 'drinks', 'drank', 'drunk', 'drinking', '喝 hē'),
    // ── Verbs from the zh_en course sentences. ───────────────────────────
    _v('agree', 'agrees', 'agreed', 'agreed', 'agreeing', '同意 tóngyì'),
    _v('answer', 'answers', 'answered', 'answered', 'answering', '回答 huídá'),
    _v('arrive', 'arrives', 'arrived', 'arrived', 'arriving', '到达 dàodá'),
    _v('become', 'becomes', 'became', 'become', 'becoming', '成为 chéngwéi'),
    _v('believe', 'believes', 'believed', 'believed', 'believing', '相信 xiāngxìn'),
    _v('break', 'breaks', 'broke', 'broken', 'breaking', '打破 dǎpò'),
    _v('buy', 'buys', 'bought', 'bought', 'buying', '买 mǎi'),
    _v('catch', 'catches', 'caught', 'caught', 'catching', '赶上 gǎnshàng / 抓住 zhuāzhù'),
    _v('change', 'changes', 'changed', 'changed', 'changing', '改变 gǎibiàn'),
    _v('cost', 'costs', 'cost', 'cost', 'costing', '花费 huāfèi'),
    _v('decide', 'decides', 'decided', 'decided', 'deciding', '决定 juédìng'),
    _v('drive', 'drives', 'drove', 'driven', 'driving', '开车 kāichē'),
    _v('fail', 'fails', 'failed', 'failed', 'failing', '失败 shībài / 不及格 bù jígé'),
    _v('finish', 'finishes', 'finished', 'finished', 'finishing', '完成 wánchéng'),
    _v('help', 'helps', 'helped', 'helped', 'helping', '帮助 bāngzhù'),
    _v('hope', 'hopes', 'hoped', 'hoped', 'hoping', '希望 xīwàng'),
    _v('learn', 'learns', 'learned', 'learned', 'learning', '学习 xuéxí / 学会 xuéhuì'),
    _v('like', 'likes', 'liked', 'liked', 'liking', '喜欢 xǐhuan'),
    _v('live', 'lives', 'lived', 'lived', 'living', '住 zhù / 生活 shēnghuó'),
    _v('lose', 'loses', 'lost', 'lost', 'losing', '丢失 diūshī / 输 shū'),
    _v('meet', 'meets', 'met', 'met', 'meeting', '见面 jiànmiàn / 遇到 yùdào'),
    _v('miss', 'misses', 'missed', 'missed', 'missing', '错过 cuòguò / 想念 xiǎngniàn'),
    _v('move', 'moves', 'moved', 'moved', 'moving', '搬家 bānjiā / 移动 yídòng'),
    _v('open', 'opens', 'opened', 'opened', 'opening', '打开 dǎkāi'),
    _v('plan', 'plans', 'planned', 'planned', 'planning', '计划 jìhuà'),
    _v('play', 'plays', 'played', 'played', 'playing', '玩 wán / 打(球) dǎ'),
    _v('promise', 'promises', 'promised', 'promised', 'promising', '承诺 chéngnuò / 答应 dāying'),
    _v('rain', 'rains', 'rained', 'rained', 'raining', '下雨 xiàyǔ'),
    _v('sleep', 'sleeps', 'slept', 'slept', 'sleeping', '睡觉 shuìjiào'),
    _v('speak', 'speaks', 'spoke', 'spoken', 'speaking', '说话 shuōhuà'),
    _v('start', 'starts', 'started', 'started', 'starting', '开始 kāishǐ'),
    _v('stay', 'stays', 'stayed', 'stayed', 'staying', '停留 tíngliú / 待 dāi'),
    _v('study', 'studies', 'studied', 'studied', 'studying', '学习 xuéxí'),
    _v('travel', 'travels', 'travelled', 'travelled', 'travelling', '旅行 lǚxíng'),
    _v('turn', 'turns', 'turned', 'turned', 'turning', '转 zhuǎn / 拐 guǎi'),
    _v('understand', 'understands', 'understood', 'understood', 'understanding', '理解 lǐjiě / 懂 dǒng'),
    _v('visit', 'visits', 'visited', 'visited', 'visiting', '参观 cānguān / 拜访 bàifǎng'),
    _v('wait', 'waits', 'waited', 'waited', 'waiting', '等 děng'),
    _v('watch', 'watches', 'watched', 'watched', 'watching', '看 kàn'),
    _v('wish', 'wishes', 'wished', 'wished', 'wishing', '希望 xīwàng / 祝 zhù'),
    _v('write', 'writes', 'wrote', 'written', 'writing', '写 xiě'),
    // ── Modal verbs — no -s/-ing forms, so their tables are bespoke. ─────
    _modal('can', '能 néng / 会 huì',
        past: 'could', negative: "can't / cannot",
        future: 'will be able to', conditional: 'could'),
    _modal('must', '必须 bìxū',
        past: 'had to', negative: "mustn't / don't have to",
        future: 'will have to', conditional: 'would have to'),
    _modal('should', '应该 yīnggāi',
        past: 'should have + participle', negative: "shouldn't",
        future: 'should', conditional: 'should'),
    _modal('may', '可以 kěyǐ / 可能 kěnéng',
        past: 'might / was allowed to', negative: 'may not',
        future: 'may', conditional: 'might'),
  ],
);

/// A modal verb: one invariable form per person, so instead of tenses the
/// table shows the substitutes learners actually need (past, negative,
/// future, conditional).
VerbEntry _modal(
  String base,
  String zh, {
  required String past,
  required String negative,
  required String future,
  required String conditional,
}) {
  ConjugationSet one(String label, String form) =>
      ConjugationSet(label: label, forms: [
        ConjugationForm(person: 'all persons', form: form),
      ]);
  const esModal = {
    'can': 'poder',
    'must': 'deber / tener que',
    'should': 'deber (condicional)',
    'may': 'poder (permiso / posibilidad)',
  };
  return VerbEntry(
    verb: base,
    english: base,
    meanings: {'zh': zh, 'es': esModal[base]!},
    sets: [
      one('Present', base),
      one('Past / substitute', past),
      one('Negative', negative),
      one('Future', future),
      one('Conditional', conditional),
    ],
  );
}
