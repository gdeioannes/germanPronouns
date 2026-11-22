// The literature shelf's poll: which public-domain book should be annotated
// next, five per level. Every book passed two checks (2026-11-22): the author
// died 70+ years ago (publicDomainCutoff() in literature.ts), and a clean free
// transcription exists on Project Gutenberg or German Wikisource, linked as
// `source`. Never Projekt Gutenberg-DE (its terms forbid reuse) or a modern
// edited edition. A book whose only text failed that check was swapped for
// another of the same level (Schachnovelle → Brennendes Geheimnis,
// Radetzkymarsch → Törleß, Fallersleben's Kinderlieder → Hans Huckebein).
//
// Each synopsis is in every site language: the poll shows them in the
// language the visitor picks for the notes. Vote counts live in Firestore
// (services/bookVotes.ts), keyed by `id`: never rename an id once it is live.

import type { UiLang } from '$lib/i18n/lang.svelte';

export const POLL_LEVELS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'] as const;
export type PollLevel = (typeof POLL_LEVELS)[number];

export interface PollBook {
	id: string;
	level: PollLevel;
	author: string;
	/** The year the author died: what makes the book free to use. */
	died: number;
	title: string;
	/** First published (for Woyzeck: first printed, after Büchner's death). */
	year: number;
	/** The free text the edition would be made from. */
	source: { site: 'Project Gutenberg' | 'Wikisource'; href: string };
	synopsis: Record<UiLang, string>;
}

const pg = (n: number) => ({ site: 'Project Gutenberg' as const, href: `https://www.gutenberg.org/ebooks/${n}` });
const ws = (page: string) => ({ site: 'Wikisource' as const, href: `https://de.wikisource.org/wiki/${page.replaceAll(' ', '_')}` });

/** The languages the notes can be in, in each language's own name. */
export const NOTE_LANGS: { id: UiLang; name: string }[] = [
	{ id: 'en', name: 'English' },
	{ id: 'es', name: 'Español' },
	{ id: 'fr', name: 'Français' },
	{ id: 'tr', name: 'Türkçe' },
	{ id: 'ar', name: 'العربية' },
	{ id: 'uk', name: 'Українська' }
];

export const POLL_BOOKS: PollBook[] = [
	// -- A1 --------------------------------------------------------------------
	{
		id: 'struwwelpeter',
		level: 'A1',
		author: 'Heinrich Hoffmann',
		died: 1894,
		title: 'Der Struwwelpeter',
		year: 1845,
		source: pg(19791),
		synopsis: {
			en: 'Ten picture-book rhymes about children who will not behave, like the boy who never cuts his hair or nails and the girl who plays with matches, and the wild things that happen to them.',
			es: 'Diez historias en verso con dibujos sobre niños que no se portan bien, como el niño que nunca se corta el pelo ni las uñas o la niña que juega con cerillas, y lo que les pasa.',
			fr: 'Dix histoires en vers illustrées sur des enfants qui n’obéissent pas, comme le garçon qui ne se coupe jamais les cheveux ni les ongles ou la fillette qui joue avec des allumettes, et ce qui leur arrive.',
			tr: 'Söz dinlemeyen çocuklar üzerine resimli on manzum hikâye: saçını ve tırnaklarını hiç kesmeyen çocuk, kibritle oynayan kız ve başlarına gelen tuhaf olaylar.',
			ar: 'عشر قصص مصوّرة منظومة شعرًا عن أطفال لا يسمعون الكلام، مثل الولد الذي لا يقصّ شعره ولا أظافره أبدًا والبنت التي تلعب بالكبريت، وما يحدث لهم من أمور غريبة.',
			uk: 'Десять віршованих історій з малюнками про неслухняних дітей, як-от хлопчик, що ніколи не стриже волосся й нігті, чи дівчинка, що бавиться сірниками, і про те, що з ними стається.'
		}
	},
	{
		id: 'hey-fabeln',
		level: 'A1',
		author: 'Wilhelm Hey',
		died: 1854,
		title: 'Fünfzig Fabeln für Kinder',
		year: 1833,
		source: ws('Fünfzig Fabeln für Kinder'),
		synopsis: {
			en: 'Fifty tiny fables in verse for small children: a raven, a snowman, a cat and a dog talk to each other in a few simple lines, each with a picture.',
			es: 'Cincuenta fábulas cortísimas en verso para niños pequeños: un cuervo, un muñeco de nieve, un gato y un perro hablan en unas pocas líneas sencillas, cada una con su dibujo.',
			fr: 'Cinquante toutes petites fables en vers pour les jeunes enfants : un corbeau, un bonhomme de neige, un chat et un chien se parlent en quelques lignes simples, chacune avec son image.',
			tr: 'Küçük çocuklar için elli minik manzum fabl: bir karga, bir kardan adam, bir kedi ve bir köpek birkaç basit satırda konuşur; her fablın bir resmi vardır.',
			ar: 'خمسون حكاية قصيرة جدًا منظومة للأطفال الصغار: غراب ورجل ثلج وقطة وكلب يتحدثون في أسطر قليلة بسيطة، ولكل حكاية صورتها.',
			uk: 'П’ятдесят коротеньких віршованих байок для малечі: ворон, сніговик, кіт і пес розмовляють кількома простими рядками, і до кожної байки є малюнок.'
		}
	},
	{
		id: 'max-und-moritz',
		level: 'A1',
		author: 'Wilhelm Busch',
		died: 1908,
		title: 'Max und Moritz',
		year: 1865,
		source: pg(17161),
		synopsis: {
			en: 'Two boys play seven nasty tricks on their village (the widow’s hens, the tailor’s bridge, the teacher’s pipe) until the miller finally catches them. Told in rhyme, with pictures.',
			es: 'Dos niños gastan siete bromas pesadas a su pueblo (las gallinas de la viuda, el puente del sastre, la pipa del maestro) hasta que el molinero por fin los atrapa. En verso y con dibujos.',
			fr: 'Deux garçons jouent sept mauvais tours à leur village (les poules de la veuve, le pont du tailleur, la pipe du maître d’école) jusqu’à ce que le meunier finisse par les attraper. En vers et en images.',
			tr: 'İki çocuk köylerine yedi kötü şaka yapar (dul kadının tavukları, terzinin köprüsü, öğretmenin piposu), ta ki sonunda değirmenci onları yakalayana kadar. Resimli ve manzum.',
			ar: 'ولدان يدبّران سبعة مقالب شريرة لأهل قريتهما (دجاجات الأرملة، جسر الخيّاط، غليون المعلّم) حتى يمسك بهما الطحّان في النهاية. قصة منظومة مع رسوم.',
			uk: 'Двоє хлопців утинають у своєму селі сім лихих витівок (кури вдови, місток кравця, люлька вчителя), аж поки мірошник нарешті їх не спіймає. Віршами й у малюнках.'
		}
	},
	{
		id: 'grimm-kurz',
		level: 'A1',
		author: 'Jacob und Wilhelm Grimm',
		died: 1863,
		title: 'Kurze Märchen: Der süße Brei und andere',
		year: 1812,
		source: ws('Der süße Brei'),
		synopsis: {
			en: 'The shortest Grimm tales, some only a page long, like the pot that cooks sweet porridge and will not stop, told in plain words.',
			es: 'Los cuentos más cortos de los Grimm, algunos de una sola página, como la olla que cocina papilla dulce y no para, contados con palabras sencillas.',
			fr: 'Les contes les plus courts des Grimm, certains d’une seule page, comme la marmite qui fait de la bouillie sucrée sans jamais s’arrêter, racontés avec des mots simples.',
			tr: 'Grimm’lerin en kısa masalları, bazıları tek sayfa: durmadan tatlı lapa pişiren tencere gibi, sade kelimelerle anlatılmış hikâyeler.',
			ar: 'أقصر حكايات الأخوين غريم، بعضها صفحة واحدة فقط، مثل القِدر الذي يطبخ عصيدة حلوة ولا يتوقف، مكتوبة بكلمات بسيطة.',
			uk: 'Найкоротші казки братів Грімм, деякі лише на сторінку, як-от про горщик, що варить солодку кашу й не може зупинитися, розказані простими словами.'
		}
	},
	{
		id: 'hans-huckebein',
		level: 'A1',
		author: 'Wilhelm Busch',
		died: 1908,
		title: 'Hans Huckebein, der Unglücksrabe',
		year: 1867,
		source: pg(2322),
		synopsis: {
			en: 'A boy catches a young raven and brings it home, and the bird turns the house upside down: it steals, breaks things and in the end gets drunk. A short picture story in rhyme.',
			es: 'Un niño atrapa un cuervo joven y se lo lleva a casa, y el pájaro lo pone todo patas arriba: roba, rompe cosas y al final se emborracha. Una breve historia en verso con dibujos.',
			fr: 'Un garçon attrape un jeune corbeau et le ramène à la maison, où l’oiseau met tout sens dessus dessous : il vole, casse tout et finit par se saouler. Une courte histoire en vers et en images.',
			tr: 'Bir çocuk genç bir karga yakalayıp eve getirir ve kuş evi altüst eder: çalar, kırar döker, sonunda da sarhoş olur. Kısa, resimli ve manzum bir hikâye.',
			ar: 'ولد يصطاد غرابًا صغيرًا ويأخذه إلى البيت، فيقلب الطائر البيت رأسًا على عقب: يسرق ويكسر الأشياء ثم يسكر في النهاية. قصة قصيرة منظومة مع رسوم.',
			uk: 'Хлопчик ловить молодого ворона й приносить додому, а птах перевертає хату догори дриґом: краде, б’є все підряд і зрештою напивається. Коротка віршована історія в малюнках.'
		}
	},
	// -- A2 --------------------------------------------------------------------
	{
		id: 'grimm-maerchen',
		level: 'A2',
		author: 'Jacob und Wilhelm Grimm',
		died: 1863,
		title: 'Deutsche Märchen: Hänsel und Gretel, Rotkäppchen und andere',
		year: 1812,
		source: pg(77905),
		synopsis: {
			en: 'The best-known fairy tales as the Grimms wrote them down: Hänsel und Gretel, Rotkäppchen, Die Bremer Stadtmusikanten, Der Froschkönig and more.',
			es: 'Los cuentos más conocidos tal como los escribieron los Grimm: Hansel y Gretel, Caperucita Roja, Los músicos de Bremen, El rey rana y muchos más.',
			fr: 'Les contes les plus connus tels que les Grimm les ont notés : Hansel et Gretel, le Petit Chaperon rouge, les Musiciens de Brême, le Roi grenouille et d’autres.',
			tr: 'En bilinen masallar, Grimm kardeşlerin yazdığı hâliyle: Hansel ile Gretel, Kırmızı Başlıklı Kız, Bremen Mızıkacıları, Kurbağa Prens ve daha fazlası.',
			ar: 'أشهر الحكايات الخرافية كما دوّنها الأخوان غريم: هانسل وغريتل، ذات الرداء الأحمر، موسيقيو مدينة بريمن، الأمير الضفدع وغيرها.',
			uk: 'Найвідоміші казки в записі братів Грімм: «Гензель і Гретель», «Червона Шапочка», «Бременські музиканти», «Король-жаба» та інші.'
		}
	},
	{
		id: 'bechstein',
		level: 'A2',
		author: 'Ludwig Bechstein',
		died: 1860,
		title: 'Ludwig Bechsteins Märchenbuch',
		year: 1845,
		source: pg(63465),
		synopsis: {
			en: 'For a long time the most popular fairy-tale book in Germany, more read than the Grimms: clever tailors, talking animals and wishes that go wrong.',
			es: 'Durante mucho tiempo el libro de cuentos más popular de Alemania, más leído que los Grimm: sastres astutos, animales que hablan y deseos que salen mal.',
			fr: 'Longtemps le livre de contes le plus populaire d’Allemagne, plus lu que les Grimm : tailleurs malins, animaux qui parlent et vœux qui tournent mal.',
			tr: 'Uzun süre Almanya’nın en sevilen masal kitabı, Grimm’lerden bile çok okundu: kurnaz terziler, konuşan hayvanlar ve ters giden dilekler.',
			ar: 'ظلّ زمنًا طويلًا أشهر كتاب حكايات في ألمانيا، وقُرئ أكثر من حكايات غريم: خيّاطون أذكياء وحيوانات تتكلم وأمنيات تنقلب على أصحابها.',
			uk: 'Довгий час найпопулярніша книжка казок у Німеччині, яку читали більше, ніж Грімм: кмітливі кравці, тварини, що розмовляють, і бажання, що збуваються не так.'
		}
	},
	{
		id: 'kleiner-muck',
		level: 'A2',
		author: 'Wilhelm Hauff',
		died: 1827,
		title: 'Die Geschichte von dem kleinen Muck',
		year: 1826,
		source: pg(6638),
		synopsis: {
			en: 'A small man everyone laughs at leaves home, finds magic slippers that make him faster than anyone and a stick that finds gold, and learns what life at the king’s court is really like.',
			es: 'Un hombrecillo del que todos se ríen se va de casa, encuentra unas zapatillas mágicas que lo hacen el más rápido y un bastón que encuentra oro, y descubre cómo es de verdad la vida en la corte del rey.',
			fr: 'Un petit homme dont tout le monde se moque quitte sa maison, trouve des pantoufles magiques qui le rendent plus rapide que tous et un bâton qui trouve l’or, et découvre ce qu’est vraiment la vie à la cour du roi.',
			tr: 'Herkesin alay ettiği ufak tefek bir adam evinden ayrılır; onu herkesten hızlı yapan sihirli terlikler ve altın bulan bir değnek bulur, kralın sarayındaki hayatın aslında nasıl olduğunu öğrenir.',
			ar: 'رجل قصير يسخر منه الجميع يغادر بيته، فيجد خُفّين سحريين يجعلانه أسرع من الجميع وعصا تدلّه على الذهب، ويعرف كيف هي الحياة حقًا في قصر الملك.',
			uk: 'Маленький чоловічок, з якого всі сміються, іде з дому, знаходить чарівні капці, що роблять його найпрудкішим, і паличку, яка шукає золото, та дізнається, яке насправді життя при королівському дворі.'
		}
	},
	{
		id: 'heidi',
		level: 'A2',
		author: 'Johanna Spyri',
		died: 1901,
		title: 'Heidis Lehr- und Wanderjahre',
		year: 1880,
		source: pg(7500),
		synopsis: {
			en: 'A girl grows up with her grandfather high in the Swiss mountains, is taken to Frankfurt to keep a sick girl company, and longs to go back to the mountains.',
			es: 'Una niña crece con su abuelo en lo alto de las montañas suizas, la llevan a Fráncfort para acompañar a una niña enferma y sueña con volver a las montañas.',
			fr: 'Une fillette grandit chez son grand-père, haut dans les montagnes suisses, puis on l’emmène à Francfort tenir compagnie à une fille malade, et elle rêve de retourner dans ses montagnes.',
			tr: 'Bir kız, İsviçre dağlarının yükseklerinde dedesiyle büyür; hasta bir kıza arkadaşlık etmesi için Frankfurt’a götürülür ve dağlara dönmeyi özler.',
			ar: 'فتاة تكبر مع جدّها في أعالي جبال سويسرا، ثم تُؤخذ إلى فرانكفورت لتؤنس فتاة مريضة، فيشتدّ حنينها إلى الجبال.',
			uk: 'Дівчинка росте з дідусем високо у швейцарських горах, потім її везуть до Франкфурта, щоб складала товариство хворій дівчинці, і вона тужить за горами.'
		}
	},
	{
		id: 'biene-maja',
		level: 'A2',
		author: 'Waldemar Bonsels',
		died: 1952,
		title: 'Die Biene Maja und ihre Abenteuer',
		year: 1912,
		source: pg(21021),
		synopsis: {
			en: 'A young bee leaves the hive to see the world, meets beetles, a grasshopper and a spider, and in the end has to warn her people of an attack by the hornets.',
			es: 'Una abeja joven deja la colmena para ver el mundo, conoce escarabajos, un saltamontes y una araña, y al final tiene que avisar a su pueblo de un ataque de los avispones.',
			fr: 'Une jeune abeille quitte la ruche pour voir le monde, rencontre des scarabées, une sauterelle et une araignée, et doit finalement prévenir son peuple d’une attaque des frelons.',
			tr: 'Genç bir arı dünyayı görmek için kovanından ayrılır; böceklerle, bir çekirgeyle ve bir örümcekle tanışır, sonunda da halkını eşek arılarının saldırısına karşı uyarmak zorunda kalır.',
			ar: 'نحلة صغيرة تترك الخلية لترى العالم، فتلتقي بخنافس وجرادة وعنكبوت، وفي النهاية عليها أن تحذّر قومها من هجوم الدبابير.',
			uk: 'Молода бджілка покидає вулик, щоб побачити світ, знайомиться з жуками, коником і павуком, а зрештою мусить попередити свій народ про напад шершнів.'
		}
	},
	// -- B1 --------------------------------------------------------------------
	{
		id: 'immensee',
		level: 'B1',
		author: 'Theodor Storm',
		died: 1888,
		title: 'Immensee',
		year: 1849,
		source: pg(6651),
		synopsis: {
			en: 'An old man remembers Elisabeth, the girl he loved as a boy. While he studies far away, she marries his school friend, and they meet only once more, by a lake.',
			es: 'Un anciano recuerda a Elisabeth, la chica a la que amó de niño. Mientras él estudia lejos, ella se casa con su compañero de escuela, y solo vuelven a verse una vez, junto a un lago.',
			fr: 'Un vieil homme se souvient d’Elisabeth, la fille qu’il aimait enfant. Pendant qu’il étudie au loin, elle épouse son camarade d’école, et ils ne se revoient qu’une fois, au bord d’un lac.',
			tr: 'Yaşlı bir adam, çocukken sevdiği kız Elisabeth’i hatırlar. O uzakta okurken kız, onun okul arkadaşıyla evlenir; bir göl kıyısında yalnızca bir kez daha karşılaşırlar.',
			ar: 'رجل عجوز يتذكّر إليزابيت، الفتاة التي أحبّها في صباه. وبينما يدرس بعيدًا تتزوج صديق دراسته، ولا يلتقيان بعد ذلك إلا مرة واحدة عند بحيرة.',
			uk: 'Старий згадує Елізабет, дівчину, яку кохав хлопцем. Поки він навчається далеко від дому, вона виходить заміж за його шкільного друга, і вони зустрічаються ще лише раз, біля озера.'
		}
	},
	{
		id: 'krambambuli',
		level: 'B1',
		author: 'Marie von Ebner-Eschenbach',
		died: 1916,
		title: 'Krambambuli',
		year: 1883,
		source: pg(79749),
		synopsis: {
			en: 'A gamekeeper buys a beautiful dog from a poacher for twelve bottles of cherry brandy. Years later the dog’s old master comes back, and the dog has to choose between them.',
			es: 'Un guardabosques compra un perro precioso a un cazador furtivo por doce botellas de aguardiente de cereza. Años después vuelve el antiguo amo, y el perro tiene que elegir entre los dos.',
			fr: 'Un garde-chasse achète un beau chien à un braconnier contre douze bouteilles d’eau-de-vie de cerise. Des années plus tard, l’ancien maître revient, et le chien doit choisir entre eux.',
			tr: 'Bir av bekçisi, bir kaçak avcıdan on iki şişe vişne rakısı karşılığında güzel bir köpek satın alır. Yıllar sonra köpeğin eski sahibi geri döner ve köpek ikisi arasında seçim yapmak zorunda kalır.',
			ar: 'حارس غابة يشتري كلبًا جميلًا من صيّاد غير شرعي مقابل اثنتي عشرة زجاجة من عرق الكرز. وبعد سنوات يعود صاحب الكلب القديم، فيجد الكلب نفسه مضطرًا إلى الاختيار بينهما.',
			uk: 'Лісник купує в браконьєра гарного пса за дванадцять пляшок вишнівки. Через роки повертається колишній господар, і пес мусить вибрати між ними.'
		}
	},
	{
		id: 'kleider-machen-leute',
		level: 'B1',
		author: 'Gottfried Keller',
		died: 1890,
		title: 'Kleider machen Leute',
		year: 1874,
		source: pg(21141),
		synopsis: {
			en: 'A poor tailor in a fine coat arrives in a small Swiss town, and everyone takes him for a Polish count. He does not dare to say no, and then he falls in love.',
			es: 'Un sastre pobre con un abrigo elegante llega a un pueblo suizo, y todos lo toman por un conde polaco. No se atreve a decir que no, y entonces se enamora.',
			fr: 'Un pauvre tailleur vêtu d’un beau manteau arrive dans une petite ville suisse, et tout le monde le prend pour un comte polonais. Il n’ose pas dire non, et puis il tombe amoureux.',
			tr: 'Şık bir palto giymiş yoksul bir terzi küçük bir İsviçre kasabasına gelir ve herkes onu Polonyalı bir kont sanır. Hayır demeye cesaret edemez, sonra da âşık olur.',
			ar: 'خيّاط فقير يرتدي معطفًا أنيقًا يصل إلى بلدة سويسرية صغيرة، فيظنه الجميع كونتًا بولنديًا. لا يجرؤ على النفي، ثم يقع في الحب.',
			uk: 'Бідний кравець у гарному пальті приїжджає до швейцарського містечка, і всі вважають його польським графом. Він не наважується заперечити, а потім закохується.'
		}
	},
	{
		id: 'taugenichts',
		level: 'B1',
		author: 'Joseph von Eichendorff',
		died: 1857,
		title: 'Aus dem Leben eines Taugenichts',
		year: 1826,
		source: pg(35312),
		synopsis: {
			en: 'A miller’s lazy son is sent out into the world with his violin, works as a gardener at a castle near Vienna, falls in love, and wanders all the way to Rome and back.',
			es: 'El hijo perezoso de un molinero sale a recorrer el mundo con su violín, trabaja de jardinero en un palacio cerca de Viena, se enamora y viaja hasta Roma y vuelta.',
			fr: 'Le fils paresseux d’un meunier part courir le monde avec son violon, devient jardinier dans un château près de Vienne, tombe amoureux et voyage jusqu’à Rome, aller et retour.',
			tr: 'Bir değirmencinin tembel oğlu kemanıyla dünyaya açılır, Viyana yakınlarındaki bir şatoda bahçıvanlık yapar, âşık olur ve ta Roma’ya kadar gidip geri döner.',
			ar: 'ابن طحّان كسول يُرسَل إلى العالم ومعه كمانه، فيعمل بستانيًا في قصر قرب فيينا، ويقع في الحب، ويتجوّل حتى روما ثم يعود.',
			uk: 'Ледачого сина мірошника виряджають у світ зі скрипкою; він працює садівником у замку під Віднем, закохується й мандрує аж до Рима і назад.'
		}
	},
	{
		id: 'ein-landarzt',
		level: 'B1',
		author: 'Franz Kafka',
		died: 1924,
		title: 'Ein Landarzt: Kleine Erzählungen',
		year: 1920,
		source: pg(21989),
		synopsis: {
			en: 'Kafka’s short stories, many only a page long: a country doctor called out on a winter night, a man who waits all his life at the door of the law, a message from the emperor that never arrives.',
			es: 'Los relatos breves de Kafka, muchos de una sola página: un médico rural llamado en una noche de invierno, un hombre que espera toda la vida ante la puerta de la ley, un mensaje del emperador que nunca llega.',
			fr: 'Les nouvelles de Kafka, souvent d’une seule page : un médecin de campagne appelé par une nuit d’hiver, un homme qui attend toute sa vie à la porte de la loi, un message de l’empereur qui n’arrive jamais.',
			tr: 'Kafka’nın çoğu tek sayfalık kısa öyküleri: bir kış gecesi hastaya çağrılan bir köy doktoru, ömrü boyunca yasanın kapısında bekleyen bir adam, hiç ulaşmayan bir imparator mesajı.',
			ar: 'قصص كافكا القصيرة، وكثير منها صفحة واحدة: طبيب ريفي يُستدعى في ليلة شتوية، ورجل ينتظر طوال حياته أمام باب القانون، ورسالة من الإمبراطور لا تصل أبدًا.',
			uk: 'Короткі оповідання Кафки, багато з них — на одну сторінку: сільського лікаря кличуть зимової ночі, чоловік усе життя чекає біля брами закону, послання від імператора так і не доходить.'
		}
	},
	// -- B2 --------------------------------------------------------------------
	{
		id: 'schimmelreiter',
		level: 'B2',
		author: 'Theodor Storm',
		died: 1888,
		title: 'Der Schimmelreiter',
		year: 1888,
		source: pg(19790),
		synopsis: {
			en: 'On the North Sea coast, a clever young man becomes the dike reeve and builds a new kind of dike. The villagers distrust him and his white horse, and then the great storm comes.',
			es: 'En la costa del mar del Norte, un joven listo llega a ser el encargado de los diques y construye un dique de un tipo nuevo. Los vecinos desconfían de él y de su caballo blanco, y entonces llega la gran tormenta.',
			fr: 'Sur la côte de la mer du Nord, un jeune homme intelligent devient le maître des digues et construit une digue d’un genre nouveau. Les villageois se méfient de lui et de son cheval blanc, puis vient la grande tempête.',
			tr: 'Kuzey Denizi kıyısında zeki bir genç, set bekçisi olur ve yeni tip bir set inşa eder. Köylüler ona ve beyaz atına güvenmez; sonra büyük fırtına gelir.',
			ar: 'على ساحل بحر الشمال يصبح شاب ذكي مسؤولًا عن السدود، ويبني سدًا من نوع جديد. لا يثق أهل القرية به ولا بحصانه الأبيض، ثم تأتي العاصفة الكبرى.',
			uk: 'На узбережжі Північного моря кмітливий юнак стає наглядачем дамб і будує дамбу нового типу. Селяни не довіряють ні йому, ні його білому коневі, а тоді приходить великий шторм.'
		}
	},
	{
		id: 'judenbuche',
		level: 'B2',
		author: 'Annette von Droste-Hülshoff',
		died: 1848,
		title: 'Die Judenbuche',
		year: 1842,
		source: pg(45798),
		synopsis: {
			en: 'In a poor village in Westphalia, a Jewish man is murdered under a beech tree, and young Friedrich disappears. A crime story about guilt, poverty and a village that looks away.',
			es: 'En un pueblo pobre de Westfalia asesinan a un hombre judío bajo una haya, y el joven Friedrich desaparece. Una historia criminal sobre la culpa, la pobreza y un pueblo que mira hacia otro lado.',
			fr: 'Dans un village pauvre de Westphalie, un homme juif est assassiné sous un hêtre, et le jeune Friedrich disparaît. Un récit criminel sur la culpabilité, la misère et un village qui détourne les yeux.',
			tr: 'Vestfalya’da yoksul bir köyde bir Yahudi adam bir kayın ağacının altında öldürülür ve genç Friedrich ortadan kaybolur. Suç, yoksulluk ve başını çeviren bir köy üzerine bir cinayet hikâyesi.',
			ar: 'في قرية فقيرة في وستفاليا يُقتل رجل يهودي تحت شجرة زان، ويختفي الشاب فريدريش. قصة جريمة عن الذنب والفقر وقرية تغضّ الطرف.',
			uk: 'У бідному вестфальському селі під буком убивають єврея, а молодий Фрідріх зникає. Кримінальна повість про провину, злидні й село, яке відводить очі.'
		}
	},
	{
		id: 'sandmann',
		level: 'B2',
		author: 'E. T. A. Hoffmann',
		died: 1822,
		title: 'Der Sandmann',
		year: 1816,
		source: pg(6341),
		synopsis: {
			en: 'Nathanael is haunted by the Sandman of his childhood, a figure he believes killed his father. As a student he falls in love with the beautiful Olimpia, who is not what she seems.',
			es: 'A Nathanael lo persigue el Hombre de Arena de su infancia, una figura que, según cree, mató a su padre. De estudiante se enamora de la bella Olimpia, que no es lo que parece.',
			fr: 'Nathanael est hanté par le Marchand de sable de son enfance, une figure qui, croit-il, a tué son père. Étudiant, il tombe amoureux de la belle Olimpia, qui n’est pas ce qu’elle semble être.',
			tr: 'Nathanael, babasını öldürdüğüne inandığı çocukluğunun Kum Adamı’ndan bir türlü kurtulamaz. Öğrenciyken güzel Olimpia’ya âşık olur; ama Olimpia göründüğü gibi değildir.',
			ar: 'يطارد ناتانائيل «رجل الرمل» من أيام طفولته، وهو شخصية يعتقد أنها قتلت أباه. وحين يصبح طالبًا يقع في حب أوليمبيا الجميلة، لكنها ليست كما تبدو.',
			uk: 'Натанаеля переслідує Пісочна людина з дитинства, постать, яка, на його думку, вбила батька. Студентом він закохується в чарівну Олімпію, що виявляється зовсім не тим, чим здається.'
		}
	},
	{
		id: 'brennendes-geheimnis',
		level: 'B2',
		author: 'Stefan Zweig',
		died: 1942,
		title: 'Brennendes Geheimnis',
		year: 1911,
		source: pg(24173),
		synopsis: {
			en: 'At a mountain hotel, a baron makes friends with a twelve-year-old boy only to get close to his mother. Slowly the boy understands, and his jealousy becomes a burning secret.',
			es: 'En un hotel de montaña, un barón se hace amigo de un niño de doce años solo para acercarse a su madre. Poco a poco el niño lo entiende, y sus celos se convierten en un secreto ardiente.',
			fr: 'Dans un hôtel de montagne, un baron se lie d’amitié avec un garçon de douze ans pour approcher sa mère. Peu à peu, l’enfant comprend, et sa jalousie devient un secret brûlant.',
			tr: 'Bir dağ otelinde bir baron, yalnızca annesine yaklaşmak için on iki yaşında bir çocukla arkadaş olur. Çocuk yavaş yavaş anlar ve kıskançlığı yakıcı bir sırra dönüşür.',
			ar: 'في فندق جبلي يصادق بارون صبيًا في الثانية عشرة ليقترب من أمّه فقط. ويفهم الصبي شيئًا فشيئًا، فتتحوّل غيرته إلى سرّ حارق.',
			uk: 'У гірському готелі барон заприятелює з дванадцятирічним хлопцем лише для того, щоб наблизитися до його матері. Хлопець поволі все розуміє, і ревнощі стають пекучою таємницею.'
		}
	},
	{
		id: 'tonio-kroeger',
		level: 'B2',
		author: 'Thomas Mann',
		died: 1955,
		title: 'Tonio Kröger',
		year: 1903,
		source: pg(23313),
		synopsis: {
			en: 'A boy from a northern merchant family loves fair-haired, ordinary people who never read, and becomes a writer. Years later he travels back north and sees what he has given up.',
			es: 'Un chico de una familia de comerciantes del norte quiere a la gente rubia y corriente que nunca lee, y se hace escritor. Años después vuelve al norte y ve a qué ha renunciado.',
			fr: 'Un garçon d’une famille de négociants du Nord aime les gens blonds et ordinaires qui ne lisent jamais, et devient écrivain. Des années plus tard, il retourne dans le Nord et voit ce à quoi il a renoncé.',
			tr: 'Kuzeyli bir tüccar ailesinin oğlu, hiç kitap okumayan sarışın, sıradan insanları sever ve yazar olur. Yıllar sonra kuzeye döner ve nelerden vazgeçtiğini görür.',
			ar: 'فتى من عائلة تجّار في الشمال يحبّ الناس العاديين الشُّقر الذين لا يقرؤون أبدًا، ويصبح كاتبًا. وبعد سنوات يعود إلى الشمال ويرى ما الذي تخلّى عنه.',
			uk: 'Хлопець із північної купецької родини любить світловолосих, звичайних людей, які ніколи не читають, і стає письменником. Через роки він повертається на північ і бачить, від чого відмовився.'
		}
	},
	// -- C1 --------------------------------------------------------------------
	{
		id: 'werther',
		level: 'C1',
		author: 'Johann Wolfgang von Goethe',
		died: 1832,
		title: 'Die Leiden des jungen Werther',
		year: 1774,
		source: pg(19794),
		synopsis: {
			en: 'The letters of a young man who falls in love with Lotte, who is engaged to someone else. His feelings grow stronger than he can bear. The book that made Goethe famous.',
			es: 'Las cartas de un joven que se enamora de Lotte, prometida con otro hombre. Sus sentimientos se vuelven más fuertes de lo que puede soportar. El libro que hizo famoso a Goethe.',
			fr: 'Les lettres d’un jeune homme qui tombe amoureux de Lotte, fiancée à un autre. Ses sentiments deviennent plus forts qu’il ne peut le supporter. Le livre qui a rendu Goethe célèbre.',
			tr: 'Başkasıyla nişanlı olan Lotte’ye âşık olan genç bir adamın mektupları. Duyguları taşıyabileceğinden daha güçlü hâle gelir. Goethe’yi ünlü yapan kitap.',
			ar: 'رسائل شاب يقع في حب لوته المخطوبة لرجل آخر. وتشتدّ مشاعره حتى تفوق ما يحتمل. الكتاب الذي جعل غوته مشهورًا.',
			uk: 'Листи юнака, який закохується в Лотту, заручену з іншим. Його почуття стають сильнішими, ніж він може витримати. Книжка, що прославила Ґете.'
		}
	},
	{
		id: 'kohlhaas',
		level: 'C1',
		author: 'Heinrich von Kleist',
		died: 1811,
		title: 'Michael Kohlhaas',
		year: 1810,
		source: pg(6645),
		synopsis: {
			en: 'A horse dealer is cheated by a nobleman, and when the courts fail him he takes justice into his own hands and sets towns on fire. The story of a man who is in the right and still does wrong.',
			es: 'Un tratante de caballos es estafado por un noble, y cuando los tribunales le fallan se toma la justicia por su mano y quema ciudades. La historia de un hombre que tiene razón y aun así obra mal.',
			fr: 'Un marchand de chevaux est escroqué par un noble, et quand la justice lui fait défaut, il se fait justice lui-même et incendie des villes. L’histoire d’un homme qui a raison et qui pourtant fait le mal.',
			tr: 'Bir at tüccarı bir soylu tarafından dolandırılır; mahkemeler ona hakkını vermeyince adaleti kendi eline alır ve kasabaları ateşe verir. Haklı olduğu hâlde yanlış yapan bir adamın hikâyesi.',
			ar: 'تاجر خيول يخدعه أحد النبلاء، وحين تخذله المحاكم يأخذ حقه بيده ويحرق المدن. قصة رجل على حق ومع ذلك يرتكب الخطأ.',
			uk: 'Торговця кіньми ошукує шляхтич, і коли суди не допомагають, він сам береться вершити справедливість і палить міста. Історія людини, яка має рацію і все одно чинить зло.'
		}
	},
	{
		id: 'fraeulein-else',
		level: 'C1',
		author: 'Arthur Schnitzler',
		died: 1931,
		title: 'Fräulein Else',
		year: 1924,
		source: ws('Fräulein Else'),
		synopsis: {
			en: 'On holiday in the Dolomites, nineteen-year-old Else learns that her father needs a fortune by the next day, and that a rich older man will pay it on one condition. Told entirely in her thoughts.',
			es: 'De vacaciones en los Dolomitas, Else, de diecinueve años, se entera de que su padre necesita una fortuna para el día siguiente y de que un hombre rico y mayor la pagará con una condición. Contado todo desde sus pensamientos.',
			fr: 'En vacances dans les Dolomites, Else, dix-neuf ans, apprend que son père a besoin d’une fortune pour le lendemain, et qu’un homme riche et âgé la paiera à une condition. Entièrement raconté dans ses pensées.',
			tr: 'Dolomitler’de tatildeki on dokuz yaşındaki Else, babasının ertesi güne kadar büyük bir paraya ihtiyacı olduğunu ve zengin, yaşlı bir adamın bunu tek bir şartla ödeyeceğini öğrenir. Tamamen onun düşünceleriyle anlatılır.',
			ar: 'في عطلة في جبال الدولوميت تعرف إلزه، ابنة التاسعة عشرة، أن أباها يحتاج إلى ثروة بحلول الغد، وأن رجلًا ثريًا كبير السن سيدفعها بشرط واحد. القصة كلها تُروى من داخل أفكارها.',
			uk: 'На відпочинку в Доломітах дев’ятнадцятирічна Ельза дізнається, що батькові до завтра потрібні величезні гроші і що багатий літній чоловік заплатить їх за однієї умови. Уся повість — її думки.'
		}
	},
	{
		id: 'effi-briest',
		level: 'C1',
		author: 'Theodor Fontane',
		died: 1898,
		title: 'Effi Briest',
		year: 1895,
		source: pg(5323),
		synopsis: {
			en: 'At seventeen, Effi marries a much older baron and moves to a lonely town on the Baltic. Years later, old letters reveal a short affair, and society shows no mercy.',
			es: 'A los diecisiete años, Effi se casa con un barón mucho mayor y se muda a una ciudad solitaria a orillas del Báltico. Años después, unas cartas antiguas revelan una breve aventura, y la sociedad no tiene piedad.',
			fr: 'À dix-sept ans, Effi épouse un baron bien plus âgé et part vivre dans une ville isolée au bord de la Baltique. Des années plus tard, de vieilles lettres révèlent une brève liaison, et la société est sans pitié.',
			tr: 'Effi on yedi yaşında kendinden çok büyük bir baronla evlenir ve Baltık kıyısında ıssız bir kasabaya taşınır. Yıllar sonra eski mektuplar kısa bir ilişkiyi ortaya çıkarır ve toplum hiç acımaz.',
			ar: 'في السابعة عشرة تتزوج إفّي بارونًا يكبرها بكثير وتنتقل إلى بلدة موحشة على بحر البلطيق. وبعد سنوات تكشف رسائل قديمة علاقة قصيرة، فلا يرحمها المجتمع.',
			uk: 'У сімнадцять Еффі виходить заміж за значно старшого барона й переїздить до самотнього містечка на Балтиці. Через роки старі листи викривають короткий роман, і суспільство не знає милосердя.'
		}
	},
	{
		id: 'tod-in-venedig',
		level: 'C1',
		author: 'Thomas Mann',
		died: 1955,
		title: 'Der Tod in Venedig',
		year: 1912,
		source: pg(12108),
		synopsis: {
			en: 'A famous writer, Gustav von Aschenbach, travels to Venice and becomes obsessed with a beautiful Polish boy. He stays on while cholera spreads through the city.',
			es: 'Un escritor famoso, Gustav von Aschenbach, viaja a Venecia y se obsesiona con un hermoso muchacho polaco. Se queda mientras el cólera se extiende por la ciudad.',
			fr: 'Un écrivain célèbre, Gustav von Aschenbach, part à Venise et devient obsédé par un beau garçon polonais. Il reste alors que le choléra se répand dans la ville.',
			tr: 'Ünlü yazar Gustav von Aschenbach Venedik’e gider ve güzel bir Polonyalı çocuğa takıntılı hâle gelir. Kolera şehirde yayılırken o kalmaya devam eder.',
			ar: 'كاتب مشهور، غوستاف فون آشنباخ، يسافر إلى البندقية ويصبح مهووسًا بصبي بولندي جميل. ويبقى هناك بينما تنتشر الكوليرا في المدينة.',
			uk: 'Відомий письменник Густав фон Ашенбах їде до Венеції й стає одержимим вродливим польським хлопцем. Він лишається там, хоча містом шириться холера.'
		}
	},
	// -- C2 --------------------------------------------------------------------
	{
		id: 'faust',
		level: 'C2',
		author: 'Johann Wolfgang von Goethe',
		died: 1832,
		title: 'Faust: Der Tragödie erster Teil',
		year: 1808,
		source: pg(2229),
		synopsis: {
			en: 'A scholar who knows everything except what life is for makes a bet with the devil, Mephisto. He gets his youth back and falls in love with Gretchen, with terrible results.',
			es: 'Un sabio que lo sabe todo menos para qué sirve la vida hace una apuesta con el diablo, Mefisto. Recupera la juventud y se enamora de Gretchen, con consecuencias terribles.',
			fr: 'Un savant qui sait tout, sauf à quoi sert la vie, fait un pari avec le diable, Méphisto. Il retrouve sa jeunesse et tombe amoureux de Gretchen, avec des conséquences terribles.',
			tr: 'Hayatın ne için olduğu dışında her şeyi bilen bir bilgin, şeytan Mefisto ile bahse girer. Gençliğine yeniden kavuşur ve Gretchen’e âşık olur; sonuçları korkunçtur.',
			ar: 'عالِم يعرف كل شيء إلا معنى الحياة يعقد رهانًا مع الشيطان ميفيستو. فيستعيد شبابه ويقع في حب غريتشن، وتكون العواقب مأساوية.',
			uk: 'Учений, який знає все, крім того, навіщо жити, укладає парі з дияволом Мефістофелем. Він повертає собі молодість і закохується в Гретхен, що має жахливі наслідки.'
		}
	},
	{
		id: 'woyzeck',
		level: 'C2',
		author: 'Georg Büchner',
		died: 1837,
		title: 'Woyzeck',
		year: 1879,
		source: pg(5322),
		synopsis: {
			en: 'A poor soldier is used by everyone: his captain mocks him, a doctor experiments on him, and his lover Marie turns to another man. An unfinished play in short, sharp scenes.',
			es: 'Todos se aprovechan de un soldado pobre: su capitán se burla de él, un médico experimenta con él y su amante Marie se va con otro. Una obra inacabada en escenas cortas y duras.',
			fr: 'Tout le monde se sert d’un pauvre soldat : son capitaine se moque de lui, un médecin fait des expériences sur lui, et sa compagne Marie se tourne vers un autre homme. Une pièce inachevée en scènes courtes et tranchantes.',
			tr: 'Yoksul bir askeri herkes kullanır: yüzbaşısı onunla alay eder, bir doktor onun üzerinde deney yapar, sevgilisi Marie başka bir adama yönelir. Kısa, keskin sahnelerden oluşan yarım kalmış bir oyun.',
			ar: 'جندي فقير يستغله الجميع: يسخر منه قائده، ويجري عليه طبيب تجاربه، وتميل حبيبته ماري إلى رجل آخر. مسرحية لم تكتمل، في مشاهد قصيرة حادة.',
			uk: 'Бідного солдата використовують усі: капітан глузує з нього, лікар ставить на ньому досліди, а кохана Марі тягнеться до іншого. Незавершена п’єса з коротких, гострих сцен.'
		}
	},
	{
		id: 'der-process',
		level: 'C2',
		author: 'Franz Kafka',
		died: 1924,
		title: 'Der Process',
		year: 1925,
		source: pg(69327),
		synopsis: {
			en: 'One morning Josef K. is arrested, though he has done nothing wrong. He is never told the charge, and the harder he fights the court, the deeper it draws him in.',
			es: 'Una mañana arrestan a Josef K., aunque no ha hecho nada malo. Nunca le dicen de qué lo acusan, y cuanto más lucha contra el tribunal, más lo atrapa este.',
			fr: 'Un matin, Josef K. est arrêté alors qu’il n’a rien fait de mal. On ne lui dit jamais de quoi il est accusé, et plus il se bat contre le tribunal, plus celui-ci l’engloutit.',
			tr: 'Josef K. bir sabah, hiçbir suç işlememiş olduğu hâlde tutuklanır. Suçlamanın ne olduğu ona hiç söylenmez; mahkemeyle ne kadar mücadele ederse o kadar içine çekilir.',
			ar: 'ذات صباح يُعتقل يوزف ك. مع أنه لم يرتكب أي ذنب. لا يُقال له أبدًا ما التهمة، وكلما قاوم المحكمة أكثر جرّته إليها أعمق.',
			uk: 'Одного ранку Йозефа К. заарештовують, хоч він нічого поганого не зробив. Йому так і не кажуть, у чому його звинувачують, і що більше він бореться із судом, то глибше той його затягує.'
		}
	},
	{
		id: 'toerless',
		level: 'C2',
		author: 'Robert Musil',
		died: 1942,
		title: 'Die Verwirrungen des Zöglings Törleß',
		year: 1906,
		source: pg(34717),
		synopsis: {
			en: 'At a military boarding school, young Törleß watches two classmates torment a weaker boy, and does nothing. A novel about cruelty, power and growing up.',
			es: 'En un internado militar, el joven Törless ve cómo dos compañeros atormentan a un chico más débil, y no hace nada. Una novela sobre la crueldad, el poder y el hacerse mayor.',
			fr: 'Dans un internat militaire, le jeune Törless regarde deux camarades tourmenter un garçon plus faible, et ne fait rien. Un roman sur la cruauté, le pouvoir et le passage à l’âge adulte.',
			tr: 'Bir askerî yatılı okulda genç Törless, iki sınıf arkadaşının daha zayıf bir çocuğa eziyet etmesini izler ve hiçbir şey yapmaz. Zalimlik, güç ve büyümek üzerine bir roman.',
			ar: 'في مدرسة داخلية عسكرية يشاهد الفتى تورلس زميلين يعذّبان فتى أضعف منهما، ولا يفعل شيئًا. رواية عن القسوة والسلطة والانتقال إلى سنّ الرشد.',
			uk: 'У військовому інтернаті юний Терлес дивиться, як двоє однокласників знущаються зі слабшого хлопця, і нічого не робить. Роман про жорстокість, владу й дорослішання.'
		}
	},
	{
		id: 'buddenbrooks',
		level: 'C2',
		author: 'Thomas Mann',
		died: 1955,
		title: 'Buddenbrooks: Verfall einer Familie',
		year: 1901,
		source: pg(34811),
		synopsis: {
			en: 'Four generations of a rich merchant family in Lübeck, from success to ruin. Thomas Mann’s first novel, the one named when he won the Nobel Prize.',
			es: 'Cuatro generaciones de una rica familia de comerciantes de Lübeck, del éxito a la ruina. La primera novela de Thomas Mann, la que se citó cuando ganó el Premio Nobel.',
			fr: 'Quatre générations d’une riche famille de négociants de Lübeck, de la réussite à la ruine. Le premier roman de Thomas Mann, celui que cita le jury quand il reçut le prix Nobel.',
			tr: 'Lübeck’li zengin bir tüccar ailesinin dört kuşağı, başarıdan çöküşe. Thomas Mann’ın ilk romanı; Nobel Ödülü’nü kazandığında adı anılan eser.',
			ar: 'أربعة أجيال من عائلة تجّار ثرية في مدينة لوبيك، من النجاح إلى الانهيار. أول روايات توماس مان، وهي التي ذُكرت حين نال جائزة نوبل.',
			uk: 'Чотири покоління багатої купецької родини з Любека — від успіху до занепаду. Перший роман Томаса Манна, саме його згадали, коли він отримав Нобелівську премію.'
		}
	}
];
