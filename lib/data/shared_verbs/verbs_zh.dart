import '../content/verb_collection.dart';

/// The shared Mandarin verb list — the ~30 most common action verbs. Chinese
/// verbs don't conjugate, so instead of tenses each verb shows the six aspect/
/// particle patterns that do the work of conjugation: bare present, 了
/// (completed), 过 (experienced), 在 (in progress), 要 (future intention) and
/// 不/没 (negation) — all derived from the verb, with 我 as the model subject.
/// Meanings: English with pinyin (the Chinese courses' main language is
/// English). Published to `assets/content/shared/verbs/zh.json`.
VerbEntry _v(String verb, String english) => VerbEntry(
  verb: verb,
  english: english,
  sets: [
    ConjugationSet(
      label: 'Present · plain',
      forms: [ConjugationForm(person: '我', form: '我$verb')],
    ),
    ConjugationSet(
      label: '了 · completed action',
      forms: [ConjugationForm(person: '我', form: '我$verb了')],
    ),
    ConjugationSet(
      label: '过 · past experience',
      forms: [ConjugationForm(person: '我', form: '我$verb过')],
    ),
    ConjugationSet(
      label: '在 · in progress',
      forms: [ConjugationForm(person: '我', form: '我在$verb')],
    ),
    ConjugationSet(
      label: '要 · future intention',
      forms: [ConjugationForm(person: '我', form: '我要$verb')],
    ),
    ConjugationSet(
      label: '不/没 · negation',
      forms: [ConjugationForm(person: '我', form: '我不$verb / 我没$verb')],
    ),
  ],
);

final VerbCollection mandarinVerbCollection = VerbCollection(
  verbs: [
    _v('吃', 'to eat · chī'),
    _v('喝', 'to drink · hē'),
    _v('去', 'to go · qù'),
    _v('来', 'to come · lái'),
    _v('看', 'to look, to watch · kàn'),
    _v('听', 'to listen · tīng'),
    _v('说', 'to speak · shuō'),
    _v('读', 'to read · dú'),
    _v('写', 'to write · xiě'),
    _v('买', 'to buy · mǎi'),
    _v('做', 'to do, to make · zuò'),
    _v('学习', 'to study · xuéxí'),
    _v('工作', 'to work · gōngzuò'),
    _v('睡觉', 'to sleep · shuìjiào'),
    _v('玩', 'to play · wán'),
    _v('用', 'to use · yòng'),
    _v('找', 'to look for · zhǎo'),
    _v('给', 'to give · gěi'),
    _v('拿', 'to take, to hold · ná'),
    _v('开', 'to open, to drive · kāi'),
    _v('坐', 'to sit · zuò'),
    _v('走', 'to walk · zǒu'),
    _v('跑', 'to run · pǎo'),
    _v('唱', 'to sing · chàng'),
    _v('跳', 'to jump, to dance · tiào'),
    _v('洗', 'to wash · xǐ'),
    _v('穿', 'to wear · chuān'),
    _v('打', 'to hit, to play (sports) · dǎ'),
    _v('等', 'to wait · děng'),
    _v('问', 'to ask · wèn'),
  ],
);
