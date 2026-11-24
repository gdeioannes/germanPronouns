<script lang="ts">
	import { creditShort } from '$lib/domain/credits';
	// About: the project's story and the person behind it. Prose lives right
	// here — it changes rarely and has no reason to be data.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { absoluteUrl } from '$lib/seo';
	import { page } from '$app/state';
	import { lang } from '$lib/i18n/lang.svelte';
	import { t } from '$lib/i18n/t';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
</script>

<Seo
	title={t('About us: who makes Language Quiz and why')}
	description={t('The story behind Language Quiz: a free, accessible A1–C2 German course by a learner in Germany for people who struggle with linear courses. No account, no ads.')}
	path="/about"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'AboutPage',
			name: 'About Language Quiz',
			url: absoluteUrl('/about'),
			description:
				'The story and mission of Language Quiz: a free, privacy-first and accessible German course from A1 to C2 that adapts to different styles of learning.',
			about: {
				'@type': 'Course',
				name: 'German Course A1–C2',
				url: absoluteUrl('/course/de_cert_a1'),
				isAccessibleForFree: true,
				accessibilitySummary:
					'Aims at WCAG 2.2 AA: works with a keyboard and screen readers, has no time limits, offers text for listening exercises and reduced motion on request.'
			},
			hasPart: [
				{ '@type': 'WebPageElement', name: 'How AI is used', url: absoluteUrl('/about#ai') },
				{ '@type': 'WebPageElement', name: 'Accessibility', url: absoluteUrl('/about#accessibility') }
			],
			mainEntity: {
				'@type': 'Person',
				name: 'GDI',
				description:
					'Creator of Language Quiz. A German learner living in Germany since 2019, building the course they needed: non-linear, free, and tested on themself first.',
				knowsLanguage: ['de', 'en', 'es'],
				jobTitle: 'Independent developer and course author',
				url: 'https://www.100words.org/en/'
			}
		}
	]}
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>

	<!-- A second language: the page written in it rather than pieced together
	     string by string. Keep both in step with the English below. -->
	{#if lang.tr}
		<header>
			<h1>Language Quiz hakkında</h1>
			<p class="lede">
				Zamanına ve gizliliğine saygı duyan ücretsiz bir Almanca kursu: hesap yok, reklam yok,
				ödeme duvarı yok ve seninle ilgili hiçbir şey tarayıcından dışarı çıkmaz. Türkçe kurs
				A1’den C2’ye kadar tüm seviyeleri açıklıyor.
			</p>
		</header>

		<section class="split">
			<div class="lead">
				<h2>Proje</h2>
				<p>
					Language Quiz, Haziran 2026’da Almancanın en zor alışkanlığı için küçük bir testle başladı:
					<em lang="de">der, die, das</em>. Sürüm sürüm <strong class="key">eksiksiz bir kursa dönüştü</strong>:
					her seviyede sesli, adım adım dersler, boşluk doldurma alıştırmaları, dikte, kelime kartları
					ve uygulamayla birlikte çalışan her seviye için bir kitap.
				</p>
			</div>
			<figure>
				<img src="/img/deck/bahnhof-1200.webp" alt="Kalabalık bir Alman tren istasyonu" width="512" height="384" fetchpriority="high" />
			<figcaption class="photo-credit"><a href="/credits#b2a12_bahn_opener">{creditShort('b2a12_bahn_opener')}</a></figcaption>
			</figure>
			<p>
				Her kararı birkaç ilke belirliyor. <strong class="key">Öğrenmek, sınanmaktan önemlidir</strong>: hiçbir
				şey kilitli değil, her seviye ilk ziyaretten itibaren açık. Eksik bir umlaut ya da unutulmuş bir
				nokta cevabı batırmaz, çünkü gerçek pratik böyle işler. Ve <strong class="key">her şey ücretsiz kalıyor</strong>:
				ilerlemen kendi tarayıcında durur, sesler önceden kaydedilmiştir ve hesap açman gerekmez.
			</p>
			<p>
				<strong class="key">Gizlilik burada bir özellik değil, yapının kendisi.</strong> Çerez yok, kimlik
				bilgisi yok, onay penceresi yok; yalnızca anonim, toplu istatistikler var. Ayrıntılar
				<a href="/settings">ayarlar sayfasında</a>.
			</p>

			<div class="disclosure" id="ai">
				<h3>Yapay zekâ nasıl kullanılıyor</h3>
				<p>
					Her şeyi açıkça söylemek adına: <strong class="key">bu kurs yapay zekâ araçlarının yardımıyla yapılıyor</strong>
					ve nerede kullanıldığını bilmelisin.
				</p>
				<ul>
					<li><strong>Resimler</strong>: her çizim, benim yazdığım ve seçtiğim tarif ve stille Google’ın Gemini görsel modeliyle üretiliyor.</li>
					<li><strong>Ses</strong>: duyduğun Almanca, kayıtlı insan sesleri değil, Google Cloud Text-to-Speech yapay sinir ağı sesleri.</li>
					<li><strong>Dersler ve alıştırmalar</strong>: Anthropic’in Claude’u açıklamaları, örnek cümleleri ve soruları taslak olarak yazmama yardım ediyor; neyin gireceğine ben karar veriyorum, kontrol edip düzeltiyorum.</li>
					<li><strong>Türkçe</strong>: Türkçe açıklamalar ve arayüz Claude ile çevrildi ve Türkçe konuşanlar için yeniden yazıldı. Henüz anadili Türkçe olan biri tarafından tamamen kontrol edilmedi: bir hata görürsen lütfen yaz.</li>
					<li><strong>Kod</strong>: uygulamayı bir yapay zekâ kodlama asistanı olan Claude Code ile yazıyorum.</li>
				</ul>
				<p>
					<strong class="key">Hiçbiri senin üzerinde çalışmaz</strong>: hiçbir yapay zekâ cevaplarını ya da
					ilerlemeni okumaz; konuşma alıştırması seni kendi seçtiğin bir asistana yönlendirir. Yapay
					zekâ yine de hata yapabilir ve bazıları gözümden kaçabilir. Bir tane görürsen lütfen söyle.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>Amaç</h2>
				<p>
					Çoğu dil kursu tek tip bir öğrenci varsayar: birinci sayfadan başla, düz bir çizgide ilerle,
					sınavı geç, sayfayı çevir. Pek çok insan böyle öğrenmez ve çoğu sorunun kendisinde olduğunu
					düşünür. <strong class="key">Öyle değil.</strong> Language Quiz’le amacım, Almancayı
					<strong class="key">tam da bu insanlara açmak</strong>.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2a21_sonntag_opener.webp" alt="Güneşli bir Alman ormanında kıvrılan bir patika" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				Bu yüzden kurs tek bir düz çizgi olmayı reddeder. Bir dersi okuyabilir, dinleyebilir, kelime
				kartlarıyla çalışabilir, yazabilir, sesli söyleyebilir ya da kitabı açıp kâğıt üzerinde
				çalışabilirsin: aynı Almanca, öğrenme yolları kadar çok biçimde. Seviye atla, geri dön,
				sıkıldığını geç: <strong class="key">kurs senin öğrenme şekline uyar, tersi değil.</strong>
			</p>
			<p>
				Baştan sona ücretsiz, açık teknolojiyle çalışır; böylece her öğrenci için ücretsiz kalabilir.
				<strong class="key">Bir dile erişim bir aboneliğe bağlı olmamalı.</strong>
			</p>

			<div class="disclosure" id="accessibility">
				<h3>Erişilebilirlik</h3>
				<p>
					Almancayı herkese açmak, ekran okuyucu ya da fare yerine klavye kullananları, renge, sese ya
					da hızlı okumaya güvenemeyenleri de kapsamalı. <strong class="key">Kurs onlar için de çalışacak şekilde
					yapıldı</strong> ve WCAG 2.2 AA yönergelerini hedefler:
				</p>
				<ul>
					<li><strong>Ekran okuyucular</strong>: doğru ve yanlış cevaplar, düzeltilmiş cevap, tur sonucun ve yeni madalyalar anında okunur. Almanca, Alman sesiyle okunsun diye Almanca olarak işaretlenmiştir.</li>
					<li><strong>Tek seferde tek ses</strong>: kurs Almanca soruları ve cevapları kendiliğinden sesli okur. Ekran okuyucu kullanıyorsan <a href="/settings">ayarlarda</a> “Soruları ve cevapları sesli oku”yu kapat.</li>
					<li><strong>Klavye</strong>: her alıştırma, kart destesi ve her panel faresiz çalışır; seçenekler ok tuşlarıyla değişir, Enter bir sonrakine geçer.</li>
					<li><strong>Kendi hızın</strong>: hiçbir şey zamanlı değil. “Beni bekle” ayarıyla alıştırmalar kendiliğinden hiç ilerlemez.</li>
					<li><strong>İşitme</strong>: “Dinleme alıştırmalarında metni göster” dikte ve dinleme alıştırmalarına metni ekler. Hiçbir alıştırma mikrofon gerektirmez.</li>
					<li><strong>Görme</strong>: metinler AA kontrast yönergelerini karşılar, isimlerin cinsiyeti renginin yanında alt çizgisiyle de ayırt edilir ve her sayfa 320 piksel genişlikte ya da %400 yakınlaştırmada çalışır.</li>
					<li><strong>Eller ve yazma</strong>: “Esnek düzeltme” (varsayılan olarak açık) yalnızca bir umlaut, bir aksan ya da bir nokta eksik olan cevabı kabul eder; ä, ö, ü ve ß olmayan bir klavye sorun değil.</li>
					<li><strong>Hareket ve ses</strong>: ayarlardaki “Sakin efektler” ya da cihazının “hareketi azalt” ayarı konfetiyi ve titreşimleri kapatır. “Uygulamayı sessize al” her şeyi susturur.</li>
				</ul>
				<p>
					Bunları kendim test ediyorum ama her yardımcı teknolojiyle değil. Bir şey yoluna çıkarsa
					<strong class="key">lütfen bana yaz</strong>; bunu bir dilek değil, bir hata olarak görürüm.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>Ben kimim</h2>
				<p>
					Merhaba, ben GDI. 2019’da Almanya’ya taşındım ve o günden beri Almancayı zor yoldan
					öğreniyorum: A1’den B1.2’ye kadar her sınıf kursu, çoğunu birden fazla kez, büyük dil
					uygulamaları ve uzun bir çevrimiçi kaynak listesi. <strong class="key">Ve hâlâ zorlanıyorum.</strong>
					Bu araçların her biri beni aynı şekilde kaybetti: sayfa sayfa katı bir ilerleyiş, ta ki
					ilgi tükenip bırakana kadar. Ama burada yaşarken bırakmak bir seçenek değil.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2b21_homeoffice_opener.webp" alt="Aydınlık ortak bir ofiste masalarda çalışan insanlar" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				<strong class="key">Bu yüzden ihtiyacım olan kursu yapıyorum</strong>: tek başına da, bir sınıf
				kursunun yanında da işe yarayan, dersler arasında dili canlı tutan bir şey.
				<strong class="key">İlk deneği de benim</strong>: uygulamadaki neredeyse her etkileşim önce bende
				deneniyor; işe yararsa kalıyor, yaramazsa yeniden yapılıyor. Umarım benim durumumdaki ve
				hiç hayal etmediğim durumlardaki daha çok insana yardımı olur.
			</p>
			<p>
				Kodu, kurs içeriğini, çizimleri ve sesleri tek başıma, <a href="#ai">yukarıda anlatılan</a>
				yapay zekâ araçlarıyla yapıyorum. Language Quiz, diğer projelerimin de yer aldığı kişisel
				sitem <a href="https://www.100words.org/en/" rel="noopener">100words.org</a>’un bir parçası.
				Bir şey yanlış, kafa karıştırıcı ya da eksikse <strong class="key">gerçekten bilmek istiyorum</strong>:
				uygulama tam da bu tür geri bildirimlerle büyüdü. <a href="/contact">Bana yaz</a>, her mesaj okunur.
			</p>
		</section>
	{:else if lang.ar}
		<!-- Arabic: written from the English, same shape as the Turkish. -->
		<header>
			<h1>عن Language Quiz</h1>
			<p class="lede">
				دورة ألمانية مجانية تحترم وقتك وخصوصيتك: لا حساب، ولا إعلانات، ولا اشتراك مدفوع، ولا شيء
				عنك يغادر متصفحك. الدورة بالعربية تغطي المستويين A1 وA2.
			</p>
		</header>

		<section class="split">
			<div class="lead">
				<h2>المشروع</h2>
				<p>
					بدأ Language Quiz في يونيو 2026 كاختبار صغير لأصعب عادة في الألمانية:
					<em lang="de">der, die, das</em>. ثم <strong class="key">نما، إصدارًا بعد إصدار، إلى دورة كاملة</strong>:
					دروس متدرجة مع صوت في كل مستوى، وتمارين ملء الفراغات، وإملاء، وبطاقات كلمات، وكتاب لكل
					مستوى يعمل مع التطبيق.
				</p>
			</div>
			<figure>
				<img src="/img/deck/bahnhof-1200.webp" alt="قاعة محطة قطارات ألمانية مزدحمة" width="512" height="384" fetchpriority="high" />
			<figcaption class="photo-credit"><a href="/credits#b2a12_bahn_opener">{creditShort('b2a12_bahn_opener')}</a></figcaption>
			</figure>
			<p>
				بعض القناعات تحدد كل قرار. <strong class="key">التعلّم أهم من الاختبار</strong>: لا شيء مقفل، وكل
				مستوى مفتوح من الزيارة الأولى. الأخطاء الصغيرة، كعلامة Umlaut ناقصة أو نقطة منسية، لا تُسقط
				الإجابة، لأن التمرين الحقيقي هكذا يكون. و<strong class="key">كل شيء يبقى مجانيًا</strong>: تقدّمك
				يبقى في متصفحك، والصوت مسجَّل مسبقًا، ولا حاجة إلى إنشاء حساب.
			</p>
			<p>
				<strong class="key">الخصوصية هنا ليست ميزة، بل هي أساس البناء.</strong> لا ملفات تعريف ارتباط،
				ولا معرّفات، ولا نافذة موافقة؛ فقط إحصاءات مجهولة وإجمالية. التفاصيل في
				<a href="/settings">صفحة الإعدادات</a>.
			</p>

			<div class="disclosure" id="ai">
				<h3>كيف يُستعمل الذكاء الاصطناعي</h3>
				<p>
					لنقل الأمور بوضوح: <strong class="key">هذه الدورة مصنوعة بمساعدة أدوات الذكاء الاصطناعي</strong>،
					ومن حقك أن تعرف أين.
				</p>
				<ul>
					<li><strong>الصور</strong>: كل رسم مولَّد بنموذج الصور Gemini من Google، من أوصاف وأسلوب أكتبها وأختارها بنفسي.</li>
					<li><strong>الصوت</strong>: الألمانية التي تسمعها تنطقها أصوات عصبية من Google Cloud Text-to-Speech، لا أشخاص مسجَّلون.</li>
					<li><strong>الدروس والتمارين</strong>: يساعدني Claude من Anthropic في كتابة مسودات الشروح والجمل الأمثلة والأسئلة؛ وأنا أقرر ما يدخل، وأراجعه وأصححه.</li>
					<li><strong>العربية</strong>: الشروح والواجهة بالعربية ترجمها Claude وأعاد كتابتها للناطقين بالعربية. لم يراجعها بعدُ متحدث أصلي بالعربية مراجعة كاملة: إن رأيت خطأ فاكتب لي من فضلك.</li>
					<li><strong>البرمجة</strong>: أكتب التطبيق مع Claude Code، وهو مساعد برمجة بالذكاء الاصطناعي.</li>
				</ul>
				<p>
					<strong class="key">لا شيء من ذلك يعمل عليك</strong>: لا ذكاء اصطناعي يقرأ إجاباتك أو تقدّمك،
					وتمرين الكلام ينقلك إلى مساعد تختاره أنت. ومع ذلك يخطئ الذكاء الاصطناعي، وقد يفوتني بعض
					الأخطاء. إن رأيت واحدًا فأخبرني من فضلك.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>الهدف</h2>
				<p>
					معظم دورات اللغة تفترض نوعًا واحدًا من المتعلمين: ابدأ من الصفحة الأولى، وتقدّم في خط
					مستقيم، وانجح في الامتحان، واقلب الصفحة. كثيرون لا يتعلمون هكذا، وكثير منهم يظن أن المشكلة
					فيه. <strong class="key">ليست فيه.</strong> هدفي مع Language Quiz أن
					<strong class="key">أفتح الألمانية لهؤلاء الناس تحديدًا</strong>.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2a21_sonntag_opener.webp" alt="ممر متعرج في غابة ألمانية مشمسة" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				لذلك ترفض الدورة أن تكون خطًا مستقيمًا واحدًا. تستطيع أن تقرأ درسًا، أو تستمع إليه، أو
				تتمرن عليه ببطاقات الكلمات، أو تكتبه، أو تقوله بصوت عالٍ، أو تفتح الكتاب وتعمل على الورق: الألمانية
				نفسها، بأشكال بعدد طرق التعلّم. اقفز بين المستويات، وارجع، وتخطَّ ما يملّك:
				<strong class="key">الدورة تتكيف مع طريقة تعلّمك، لا العكس.</strong>
			</p>
			<p>
				وهي تعمل بتقنيات مجانية ومفتوحة من أولها إلى آخرها، لتبقى مجانية لكل متعلم.
				<strong class="key">تعلّم لغة لا يجب أن يتوقف على اشتراك.</strong>
			</p>

			<div class="disclosure" id="accessibility">
				<h3>إمكانية الوصول</h3>
				<p>
					فتح الألمانية للجميع يجب أن يشمل من يستعمل قارئ شاشة، أو لوحة المفاتيح بدل الفأرة، أو لا
					يستطيع الاعتماد على اللون أو الصوت أو القراءة السريعة. <strong class="key">الدورة مبنية لتعمل لهم
					أيضًا</strong>، وتهدف إلى إرشادات WCAG 2.2 AA:
				</p>
				<ul>
					<li><strong>قارئات الشاشة</strong>: الإجابات الصحيحة والخاطئة، والإجابة المصحَّحة، ونتيجة جولتك، والميداليات الجديدة تُقرأ فور حدوثها. الألمانية معلَّمة كألمانية، لتُقرأ بصوت ألماني.</li>
					<li><strong>صوت واحد في كل مرة</strong>: الدورة تقرأ الأسئلة والإجابات الألمانية بصوت عالٍ من تلقاء نفسها. إن كنت تستعمل قارئ شاشة، فأوقف «اقرأ الأسئلة والإجابات بصوت عالٍ» في <a href="/settings">الإعدادات</a>.</li>
					<li><strong>لوحة المفاتيح</strong>: كل تمرين، وكل البطاقات، وكل لوحة تعمل دون فأرة؛ الخيارات تتغير بمفاتيح الأسهم، وEnter ينقلك إلى التالي.</li>
					<li><strong>سرعتك أنت</strong>: لا شيء محدد بوقت. مع إعداد «انتظرني» لا تتقدم التمارين من تلقاء نفسها أبدًا.</li>
					<li><strong>السمع</strong>: «أظهر النص في تمارين الاستماع» يضيف النص إلى تمارين الإملاء والاستماع. لا تمرين يحتاج إلى ميكروفون.</li>
					<li><strong>البصر</strong>: النصوص تحقق إرشادات التباين AA، وجنس الأسماء يُميَّز بالخط تحتها إلى جانب لونها، وكل صفحة تعمل على شاشة بعرض 320 بكسل أو مع تكبير 400%.</li>
					<li><strong>اليدان والكتابة</strong>: «تصحيح متساهل» (مفعّل افتراضيًا) يقبل الإجابة التي ينقصها فقط Umlaut أو علامة نطق أو نقطة، فلوحة مفاتيح دون ä وö وü وß ليست مشكلة.</li>
					<li><strong>الحركة والصوت</strong>: «مؤثرات هادئة» في الإعدادات، أو إعداد «تقليل الحركة» في جهازك، يوقف قصاصات الورق الملوّن والاهتزازات. «اكتم التطبيق» يُسكت كل شيء.</li>
				</ul>
				<p>
					أختبر هذا بنفسي، لكن ليس مع كل التقنيات المساعدة. إن اعترضك شيء،
					<strong class="key">فاكتب لي من فضلك</strong>؛ أعدّ ذلك خطأً يجب إصلاحه، لا مجرد أمنية.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>من أنا</h2>
				<p>
					مرحبًا، أنا GDI. انتقلت إلى ألمانيا في 2019، ومنذ ذلك الحين أتعلم الألمانية بالطريق الصعب:
					كل دورة صفّية من A1 إلى B1.2، معظمها أكثر من مرة، وتطبيقات اللغة الكبيرة، وقائمة طويلة من
					المصادر على الإنترنت. <strong class="key">وما زلت أجد صعوبة.</strong> كل هذه الأدوات فقدتني بالطريقة
					نفسها: تقدّم جامد صفحة بعد صفحة، حتى يذهب الاهتمام وأتوقف. لكن التوقف ليس خيارًا حين تعيش هنا.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2b21_homeoffice_opener.webp" alt="أشخاص يعملون على مكاتب في مكتب مشترك مضيء" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				<strong class="key">لذلك أبني الدورة التي كنت أحتاجها</strong>: شيء يعمل وحده، ويعمل إلى جانب دورة
				صفّية، ليبقي اللغة حية بين الدروس.
				<strong class="key">وأنا أول من يجرّبها</strong>: كل تفاعل تقريبًا في التطبيق يُجرَّب عليّ أولًا؛ يبقى إن
				نجح، ويُعاد بناؤه إن لم ينجح. أرجو أن يساعد أناسًا أكثر في وضعي، وفي أوضاع لم أتخيلها بعد.
			</p>
			<p>
				أبني هذا وحدي: البرمجة، ومحتوى الدورة، والرسوم، والصوت، مع أدوات الذكاء الاصطناعي
				<a href="#ai">الموصوفة أعلاه</a>. Language Quiz جزء من موقعي الشخصي
				<a href="https://www.100words.org/en/" rel="noopener">100words.org</a>، حيث تجد مشاريعي الأخرى.
				إن كان شيء خاطئًا أو مربكًا أو ناقصًا، <strong class="key">فأنا أريد حقًا أن أعرف</strong>:
				التطبيق نما من هذا النوع من الملاحظات تحديدًا. <a href="/contact">اكتب لي</a>، فكل رسالة تُقرأ.
			</p>
		</section>
	{:else if lang.uk}
		<!-- Ukrainian: written from the English, same shape as the Turkish. -->
		<header>
			<h1>Про Language Quiz</h1>
			<p class="lede">
				Безкоштовний курс німецької, який поважає твій час і твою приватність: без акаунта, без
				реклами, без платного доступу, і ніщо про тебе не залишає твій браузер. Українською курс
				пояснює всі рівні, від A1 до C2.
			</p>
		</header>

		<section class="split">
			<div class="lead">
				<h2>Проєкт</h2>
				<p>
					Language Quiz почався в червні 2026 року як маленький тест на найважчу звичку німецької:
					<em lang="de">der, die, das</em>. Версія за версією він <strong class="key">виріс у повний курс</strong>:
					покрокові уроки з аудіо на кожному рівні, вправи на заповнення пропусків, диктанти, картки
					зі словами і книжка для кожного рівня, що працює разом із застосунком.
				</p>
			</div>
			<figure>
				<img src="/img/deck/bahnhof-1200.webp" alt="Людний зал німецького вокзалу" width="512" height="384" fetchpriority="high" />
			<figcaption class="photo-credit"><a href="/credits#b2a12_bahn_opener">{creditShort('b2a12_bahn_opener')}</a></figcaption>
			</figure>
			<p>
				Кожне рішення визначають кілька переконань. <strong class="key">Навчання важливіше за перевірку</strong>:
				нічого не заблоковано, кожен рівень відкритий з першого візиту. Дрібні помилки, як-от
				пропущений умлаут чи забута крапка, не зараховують відповідь як неправильну, бо так виглядає
				справжня практика. І <strong class="key">усе залишається безкоштовним</strong>: твій поступ зберігається
				у твоєму браузері, аудіо записане заздалегідь, і створювати акаунт не потрібно.
			</p>
			<p>
				<strong class="key">Приватність тут не функція, а сама основа.</strong> Без файлів cookie, без
				ідентифікаторів, без вікна згоди; лише анонімна загальна статистика. Подробиці на
				<a href="/settings">сторінці налаштувань</a>.
			</p>

			<div class="disclosure" id="ai">
				<h3>Як використовується штучний інтелект</h3>
				<p>
					Щоб усе було чесно: <strong class="key">цей курс створено за допомогою інструментів штучного інтелекту</strong>,
					і ти маєш право знати, де саме.
				</p>
				<ul>
					<li><strong>Зображення</strong>: кожен малюнок згенеровано моделлю зображень Gemini від Google за описами і стилем, які пишу і вибираю я.</li>
					<li><strong>Аудіо</strong>: німецьку, яку ти чуєш, озвучують нейронні голоси Google Cloud Text-to-Speech, а не записані люди.</li>
					<li><strong>Уроки і вправи</strong>: Claude від Anthropic допомагає мені писати чернетки пояснень, прикладів речень і запитань; я вирішую, що до курсу потрапить, перевіряю і виправляю.</li>
					<li><strong>Українська</strong>: пояснення та інтерфейс українською переклав Claude і переписав для україномовних. Носій мови ще не перевірив їх повністю: якщо бачиш помилку, напиши мені, будь ласка.</li>
					<li><strong>Код</strong>: я пишу застосунок разом із Claude Code, помічником з програмування на основі ШІ.</li>
				</ul>
				<p>
					<strong class="key">Ніщо з цього не працює з тобою</strong>: жоден ШІ не читає твоїх відповідей чи
					поступу, а вправа з говоріння веде тебе до помічника, якого обираєш ти. І все ж ШІ
					помиляється, і деякі помилки я можу пропустити. Якщо помітиш одну, скажи мені, будь ласка.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>Мета</h2>
				<p>
					Більшість мовних курсів розраховані на один тип учня: почни з першої сторінки, рухайся
					прямою лінією, склади іспит, перегорни сторінку. Багато людей так не вчаться, і багато хто
					з них думає, що проблема в них. <strong class="key">Це не так.</strong> Моя мета з Language Quiz:
					<strong class="key">відкрити німецьку саме для цих людей</strong>.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2a21_sonntag_opener.webp" alt="Звивиста стежка в сонячному німецькому лісі" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				Тому курс не хоче бути однією прямою лінією. Урок можна прочитати, прослухати, потренувати
				з картками, написати, сказати вголос або відкрити книжку й працювати на папері: та сама
				німецька в стількох формах, скільки є способів учитися. Перескакуй між рівнями, повертайся,
				пропускай те, що набридло: <strong class="key">курс підлаштовується під твій спосіб навчання, а не навпаки.</strong>
			</p>
			<p>
				Він від початку до кінця працює на безкоштовних відкритих технологіях, щоб залишатися
				безкоштовним для кожного учня. <strong class="key">Доступ до мови не повинен залежати від підписки.</strong>
			</p>

			<div class="disclosure" id="accessibility">
				<h3>Доступність</h3>
				<p>
					Відкрити німецьку для всіх означає також для тих, хто користується програмою зчитування
					з екрана чи клавіатурою замість миші, або не може покладатися на колір, звук чи швидке
					читання. <strong class="key">Курс зроблено так, щоб він працював і для них</strong>, і він орієнтується
					на настанови WCAG 2.2 AA:
				</p>
				<ul>
					<li><strong>Програми зчитування з екрана</strong>: правильні й неправильні відповіді, виправлена відповідь, результат раунду та нові медалі оголошуються одразу. Німецька позначена як німецька, щоб її читав німецький голос.</li>
					<li><strong>Один голос за раз</strong>: курс сам читає вголос німецькі запитання й відповіді. Якщо ти користуєшся програмою зчитування з екрана, вимкни «Читати запитання і відповіді вголос» у <a href="/settings">налаштуваннях</a>.</li>
					<li><strong>Клавіатура</strong>: кожна вправа, колода карток і панель працюють без миші; варіанти змінюються клавішами зі стрілками, Enter переходить до наступного.</li>
					<li><strong>Твій темп</strong>: ніщо не обмежене в часі. З налаштуванням «Зачекай на мене» вправи ніколи не переходять далі самі.</li>
					<li><strong>Слух</strong>: «Показувати текст у вправах на аудіювання» додає текст до диктантів і вправ на аудіювання. Жодна вправа не потребує мікрофона.</li>
					<li><strong>Зір</strong>: тексти відповідають настановам контрасту AA, рід іменників позначений не лише кольором, а й підкресленням, і кожна сторінка працює на ширині 320 пікселів або при збільшенні 400%.</li>
					<li><strong>Руки і набір тексту</strong>: «Поблажлива перевірка» (увімкнена за замовчуванням) приймає відповідь, у якій бракує лише умлауту, наголосу чи крапки, тож клавіатура без ä, ö, ü і ß не проблема.</li>
					<li><strong>Рух і звук</strong>: «Спокійні ефекти» в налаштуваннях або «зменшення руху» на твоєму пристрої вимикають конфеті й потрушування. «Вимкнути звук застосунку» прибирає весь звук.</li>
				</ul>
				<p>
					Я перевіряю це особисто, але не з кожною допоміжною технологією. Якщо щось заважає,
					<strong class="key">напиши мені, будь ласка</strong>; для мене це помилка, яку треба виправити, а не побажання.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>Хто я</h2>
				<p>
					Привіт, я GDI. Я живу в Німеччині з 2019 року і відтоді вчу німецьку важким шляхом:
					усі групові курси від A1 до B1.2, більшість не раз, великі мовні застосунки і довгий
					список онлайн-ресурсів. <strong class="key">І мені досі важко.</strong> Усі ці інструменти втрачали мене
					однаково: жорсткий рух сторінка за сторінкою, аж поки інтерес не зникав і навчання не зупинялося. Але
					коли ти тут живеш, кинути не вийде.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2b21_homeoffice_opener.webp" alt="Люди працюють за столами у світлому спільному офісі" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				<strong class="key">Тому я роблю курс, якого мені бракувало</strong>: щось, що працює саме по собі
				і поряд із груповим курсом, щоб мова жила між заняттями.
				<strong class="key">І випробовую його насамперед на собі</strong>: майже кожну дію в застосунку спершу
				пробую на собі; якщо працює, вона залишається, якщо ні, її переробляю. Сподіваюся, курс
				допоможе більшій кількості людей у моєму становищі і в тих, яких я ще не уявляю.
			</p>
			<p>
				Я роблю все без команди: код, зміст курсу, малюнки й аудіо, з інструментами ШІ,
				<a href="#ai">описаними вище</a>. Language Quiz є частиною мого особистого сайту
				<a href="https://www.100words.org/en/" rel="noopener">100words.org</a>, де є й інші мої проєкти.
				Якщо щось неправильно, незрозуміло чи бракує, <strong class="key">я справді хочу про це знати</strong>:
				застосунок виріс саме з таких відгуків. <a href="/contact">Напиши мені</a>, кожне повідомлення читаю.
			</p>
		</section>
	{:else if lang.fr}
		<!-- French: written from the English, same shape as the Turkish. -->
		<header>
			<h1>À propos de Language Quiz</h1>
			<p class="lede">
				Un cours d'allemand gratuit qui respecte votre temps et votre vie privée : pas de compte,
				pas de publicité, pas d'abonnement, et rien de ce qui vous concerne ne quitte votre
				navigateur. En français, le cours explique tous les niveaux, de A1 à C2.
			</p>
		</header>

		<section class="split">
			<div class="lead">
				<h2>Le projet</h2>
				<p>
					Language Quiz a commencé en juin 2026 comme un petit quiz sur la pire habitude de l'allemand :
					<em lang="de">der, die, das</em>. Version après version, il est <strong class="key">devenu un cours complet</strong> :
					des leçons pas à pas avec audio à chaque niveau, des exercices à trous, des dictées, des
					fiches de vocabulaire et un livre par niveau qui fonctionne avec l'application.
				</p>
			</div>
			<figure>
				<img src="/img/deck/bahnhof-1200.webp" alt="Le hall animé d'une gare allemande" width="512" height="384" fetchpriority="high" />
			<figcaption class="photo-credit"><a href="/credits#b2a12_bahn_opener">{creditShort('b2a12_bahn_opener')}</a></figcaption>
			</figure>
			<p>
				Quelques convictions guident chaque décision. <strong class="key">Apprendre compte plus que contrôler</strong> :
				rien n'est verrouillé, chaque niveau est ouvert dès la première visite. Les petites fautes,
				comme un Umlaut oublié ou un point manquant, ne rendent pas une réponse fausse, parce que
				c'est à cela que ressemble une vraie pratique. Et <strong class="key">tout reste gratuit</strong> : votre
				progression est enregistrée dans votre navigateur, l'audio est enregistré à l'avance, et aucun
				compte n'est nécessaire.
			</p>
			<p>
				<strong class="key">Ici, la vie privée n'est pas une option, c'est la base.</strong> Pas de cookies,
				pas d'identifiants, pas de bandeau de consentement ; seulement des statistiques anonymes et
				globales. Les détails sont sur la <a href="/settings">page des paramètres</a>.
			</p>

			<div class="disclosure" id="ai">
				<h3>Comment l'intelligence artificielle est utilisée</h3>
				<p>
					Pour être honnête : <strong class="key">ce cours est fait avec l'aide d'outils d'intelligence artificielle</strong>,
					et vous avez le droit de savoir où.
				</p>
				<ul>
					<li><strong>Images</strong> : chaque illustration est générée par le modèle d'images Gemini de Google, à partir de descriptions et d'un style que j'écris et que je choisis.</li>
					<li><strong>Audio</strong> : l'allemand que vous entendez est lu par les voix neuronales de Google Cloud Text-to-Speech, pas par des personnes enregistrées.</li>
					<li><strong>Leçons et exercices</strong> : Claude, d'Anthropic, m'aide à rédiger les explications, les phrases d'exemple et les questions ; je décide de ce qui entre dans le cours, je relis et je corrige.</li>
					<li><strong>Français</strong> : les explications et l'interface en français ont été traduites par Claude et réécrites pour les francophones. Une personne de langue maternelle française ne les a pas encore entièrement relues : si vous voyez une erreur, écrivez-moi, s'il vous plaît.</li>
					<li><strong>Code</strong> : j'écris l'application avec Claude Code, un assistant de programmation basé sur l'IA.</li>
				</ul>
				<p>
					<strong class="key">Rien de tout cela ne travaille sur vous</strong> : aucune IA ne lit vos réponses ni
					votre progression, et l'exercice d'expression orale vous envoie vers l'assistant que vous
					choisissez. Mais l'IA se trompe, et il se peut que je laisse passer des erreurs. Si vous en
					remarquez une, dites-le-moi, s'il vous plaît.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>La mission</h2>
				<p>
					La plupart des cours de langue sont faits pour un seul type d'apprenant : commencer à la
					première page, avancer en ligne droite, passer l'examen, tourner la page. Beaucoup de gens
					n'apprennent pas ainsi, et beaucoup pensent que le problème vient d'eux.
					<strong class="key">Ce n'est pas le cas.</strong> Mon but avec Language Quiz :
					<strong class="key">ouvrir l'allemand à ces personnes-là</strong>.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2a21_sonntag_opener.webp" alt="Un sentier sinueux dans une forêt allemande ensoleillée" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				C'est pourquoi le cours ne veut pas être une seule ligne droite. Une leçon peut se lire,
				s'écouter, s'entraîner avec des fiches, s'écrire, se dire à voix haute, ou se travailler sur
				papier dans le livre : le même allemand sous autant de formes qu'il y a de façons d'apprendre.
				Passez d'un niveau à l'autre, revenez en arrière, sautez ce qui vous ennuie :
				<strong class="key">le cours s'adapte à votre façon d'apprendre, pas l'inverse.</strong>
			</p>
			<p>
				Il fonctionne du début à la fin avec des technologies libres et gratuites, pour rester
				gratuit pour chaque apprenant. <strong class="key">L'accès à une langue ne devrait pas dépendre d'un abonnement.</strong>
			</p>

			<div class="disclosure" id="accessibility">
				<h3>Accessibilité</h3>
				<p>
					Ouvrir l'allemand à tout le monde, c'est aussi l'ouvrir à qui utilise un lecteur d'écran ou
					le clavier au lieu de la souris, ou ne peut pas compter sur la couleur, le son ou une lecture
					rapide. <strong class="key">Le cours est fait pour fonctionner aussi pour ces personnes</strong>, et il
					suit les recommandations WCAG 2.2 AA :
				</p>
				<ul>
					<li><strong>Lecteurs d'écran</strong> : les bonnes et les mauvaises réponses, la réponse corrigée, le résultat d'une série et les nouvelles médailles sont annoncés aussitôt. L'allemand est marqué comme allemand, pour être lu par une voix allemande.</li>
					<li><strong>Une voix à la fois</strong> : le cours lit lui-même à voix haute les questions et les réponses allemandes. Si vous utilisez un lecteur d'écran, désactivez « Lire les questions et les réponses à voix haute » dans les <a href="/settings">paramètres</a>.</li>
					<li><strong>Clavier</strong> : chaque exercice, paquet de cartes et panneau fonctionne sans souris ; les flèches changent d'option, Entrée passe à la suite.</li>
					<li><strong>Votre rythme</strong> : rien n'est chronométré. Avec le réglage « Attendez-moi », les exercices ne passent jamais tout seuls à la suite.</li>
					<li><strong>Audition</strong> : « Afficher le texte dans les exercices d'écoute » ajoute le texte aux dictées et aux exercices d'écoute. Aucun exercice n'a besoin d'un micro.</li>
					<li><strong>Vue</strong> : les textes respectent les contrastes AA, le genre des noms est marqué non seulement par la couleur mais aussi par un soulignement, et chaque page fonctionne sur 320 pixels de large ou zoomée à 400 %.</li>
					<li><strong>Mains et frappe</strong> : la « Correction indulgente » (activée par défaut) accepte une réponse à laquelle il ne manque qu'un Umlaut, un accent ou un point : un clavier sans ä, ö, ü ni ß n'est pas un problème.</li>
					<li><strong>Mouvement et son</strong> : « Effets calmes » dans les paramètres, ou « réduire les animations » sur votre appareil, coupe les confettis et les secousses. « Couper le son de l'appli » supprime tout le son.</li>
				</ul>
				<p>
					Je vérifie cela moi-même, mais pas avec chaque technologie d'assistance. Si quelque chose
					vous gêne, <strong class="key">écrivez-moi, s'il vous plaît</strong> : pour moi, c'est un bug à corriger, pas un souhait.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>Qui je suis</h2>
				<p>
					Bonjour, ici GDI. Je vis en Allemagne depuis 2019 et j'apprends l'allemand à la dure depuis :
					tous les cours en groupe de A1 à B1.2, la plupart plus d'une fois, les grandes applications
					de langues et une longue liste de ressources en ligne. <strong class="key">Et c'est toujours difficile pour moi.</strong>
					Tous ces outils me perdaient de la même manière : une marche rigide, page après page, jusqu'à
					ce que l'intérêt disparaisse et que l'apprentissage s'arrête. Mais quand on vit ici, on ne
					peut pas abandonner.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2b21_homeoffice_opener.webp" alt="Des personnes travaillent à des bureaux dans un espace de travail partagé lumineux" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				<strong class="key">Alors je construis le cours qui me manquait</strong> : quelque chose qui fonctionne
				seul et à côté d'un cours en groupe, pour que la langue vive entre les séances.
				<strong class="key">Et je le teste d'abord sur moi-même</strong> : presque chaque élément de
				l'application, je l'essaie d'abord moi-même ; s'il marche, il reste, sinon, je le refais.
				J'espère qu'il aidera d'autres personnes dans ma situation, et dans des situations que je
				n'imagine pas encore.
			</p>
			<p>
				Je fais tout sans équipe : le code, le contenu du cours, les images et l'audio, avec les
				outils d'IA <a href="#ai">décrits plus haut</a>. Language Quiz fait partie de mon site
				personnel <a href="https://www.100words.org/en/" rel="noopener">100words.org</a>, où vous
				trouverez mes autres projets. Si quelque chose est faux, confus ou manquant,
				<strong class="key">je veux vraiment le savoir</strong> : l'application est née précisément de ce
				genre de retours. <a href="/contact">Écrivez-moi</a>, chaque message est lu.
			</p>
		</section>
	{:else if lang.es}
		<!-- Spanish: written from the English, same shape as the French. Neutral Spanish, tú. -->
		<header>
			<h1>Acerca de Language Quiz</h1>
			<p class="lede">
				Un curso de alemán gratuito que respeta tu tiempo y tu privacidad: sin cuenta, sin
				publicidad, sin suscripción, y nada sobre ti sale de tu navegador. En español, el curso
				explica todos los niveles, de A1 a C2.
			</p>
		</header>

		<section class="split">
			<div class="lead">
				<h2>El proyecto</h2>
				<p>
					Language Quiz empezó en junio de 2026 como un pequeño quiz sobre la peor costumbre del alemán:
					<em lang="de">der, die, das</em>. Versión tras versión, <strong class="key">se convirtió en un curso completo</strong>:
					lecciones paso a paso con audio en cada nivel, ejercicios para completar, dictados,
					tarjetas de vocabulario y un libro por nivel que funciona junto con la aplicación.
				</p>
			</div>
			<figure>
				<img src="/img/deck/bahnhof-1200.webp" alt="El vestíbulo lleno de gente de una estación de tren alemana" width="512" height="384" fetchpriority="high" />
			<figcaption class="photo-credit"><a href="/credits#b2a12_bahn_opener">{creditShort('b2a12_bahn_opener')}</a></figcaption>
			</figure>
			<p>
				Algunas convicciones guían cada decisión. <strong class="key">Aprender importa más que controlar</strong>:
				nada está bloqueado, todos los niveles están abiertos desde la primera visita. Los errores
				pequeños, como una diéresis olvidada o un punto que falta, no convierten una respuesta en
				incorrecta, porque así es la práctica real. Y <strong class="key">todo sigue siendo gratis</strong>: tu
				progreso se guarda en tu navegador, el audio está grabado de antemano y no hace falta ninguna cuenta.
			</p>
			<p>
				<strong class="key">Aquí la privacidad no es un extra, es la base.</strong> Sin cookies,
				sin identificadores, sin avisos de consentimiento; solo estadísticas anónimas y globales.
				Los detalles están en la <a href="/settings">página de ajustes</a>.
			</p>

			<div class="disclosure" id="ai">
				<h3>Cómo se usa la inteligencia artificial</h3>
				<p>
					Con toda honestidad: <strong class="key">este curso se hace con ayuda de herramientas de inteligencia artificial</strong>,
					y tienes derecho a saber dónde.
				</p>
				<ul>
					<li><strong>Imágenes</strong>: cada ilustración la genera el modelo de imágenes Gemini de Google, a partir de descripciones y de un estilo que yo escribo y elijo.</li>
					<li><strong>Audio</strong>: el alemán que escuchas lo leen las voces neuronales de Google Cloud Text-to-Speech, no personas grabadas.</li>
					<li><strong>Lecciones y ejercicios</strong>: Claude, de Anthropic, me ayuda a redactar las explicaciones, las frases de ejemplo y las preguntas; yo decido qué entra en el curso, lo reviso y lo corrijo.</li>
					<li><strong>Español</strong>: las explicaciones y la interfaz en español las tradujo Claude y se reescribieron para hispanohablantes. Todavía no las ha revisado por completo una persona nativa: si ves un error, escríbeme, por favor.</li>
					<li><strong>Código</strong>: escribo la aplicación con Claude Code, un asistente de programación basado en IA.</li>
				</ul>
				<p>
					<strong class="key">Nada de esto trabaja sobre ti</strong>: ninguna IA lee tus respuestas ni tu
					progreso, y el ejercicio de expresión oral te envía al asistente que tú elijas. Pero la IA
					se equivoca, y puede que se me escapen errores. Si notas alguno, avísame, por favor.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>La misión</h2>
				<p>
					La mayoría de los cursos de idiomas están hechos para un solo tipo de estudiante: empezar en
					la primera página, avanzar en línea recta, aprobar el examen, pasar página. Mucha gente no
					aprende así, y mucha cree que el problema es suyo.
					<strong class="key">No lo es.</strong> Mi objetivo con Language Quiz:
					<strong class="key">abrir el alemán a esas personas</strong>.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2a21_sonntag_opener.webp" alt="Un sendero que serpentea por un bosque alemán soleado" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				Por eso el curso no quiere ser una sola línea recta. Una lección se puede leer, escuchar,
				practicar con tarjetas, escribir, decir en voz alta o trabajar en papel en el libro: el mismo
				alemán en tantas formas como maneras hay de aprender. Pasa de un nivel a otro, vuelve atrás,
				sáltate lo que te aburre:
				<strong class="key">el curso se adapta a tu forma de aprender, no al revés.</strong>
			</p>
			<p>
				Funciona de principio a fin con tecnologías libres y gratuitas, para seguir siendo gratis
				para cada estudiante. <strong class="key">El acceso a un idioma no debería depender de una suscripción.</strong>
			</p>

			<div class="disclosure" id="accessibility">
				<h3>Accesibilidad</h3>
				<p>
					Abrir el alemán a todo el mundo también significa abrirlo a quien usa un lector de pantalla o
					el teclado en vez del ratón, o no puede fiarse del color, del sonido o de una lectura rápida.
					<strong class="key">El curso está hecho para funcionar también para esas personas</strong>, y
					sigue las pautas WCAG 2.2 AA:
				</p>
				<ul>
					<li><strong>Lectores de pantalla</strong>: las respuestas correctas e incorrectas, la respuesta corregida, el resultado de una ronda y las medallas nuevas se anuncian al momento. El alemán está marcado como alemán, para que lo lea una voz alemana.</li>
					<li><strong>Una voz a la vez</strong>: el curso lee en voz alta las preguntas y respuestas en alemán. Si usas un lector de pantalla, desactiva «Leer en voz alta preguntas y respuestas» en los <a href="/settings">ajustes</a>.</li>
					<li><strong>Teclado</strong>: cada ejercicio, mazo de tarjetas y panel funciona sin ratón; las flechas cambian de opción y Enter pasa a lo siguiente.</li>
					<li><strong>Tu ritmo</strong>: nada tiene tiempo límite. Con el ajuste «Espérame», los ejercicios nunca avanzan solos.</li>
					<li><strong>Audición</strong>: «Mostrar el texto en los ejercicios de escucha» añade el texto a los dictados y a los ejercicios de escucha. Ningún ejercicio necesita micrófono.</li>
					<li><strong>Vista</strong>: los textos cumplen los contrastes AA, el género de los sustantivos se marca no solo con color sino también con un subrayado, y cada página funciona con 320 píxeles de ancho o con zoom al 400 %.</li>
					<li><strong>Manos y escritura</strong>: la «Corrección flexible» (activada por defecto) acepta una respuesta a la que solo le falta una diéresis, un acento o un punto: un teclado sin ä, ö, ü ni ß no es problema.</li>
					<li><strong>Movimiento y sonido</strong>: «Efectos tranquilos» en los ajustes, o «reducir movimiento» en tu dispositivo, quita el confeti y las sacudidas. «Silenciar la aplicación» quita todo el sonido.</li>
				</ul>
				<p>
					Lo compruebo personalmente, pero no con todas las tecnologías de apoyo. Si algo te dificulta el uso,
					<strong class="key">escríbeme, por favor</strong>: para mí es un error que corregir, no un deseo.
				</p>
			</div>
		</section>

		<section class="split">
			<div class="lead">
				<h2>Quién soy</h2>
				<p>
					Hola, aquí GDI. Vivo en Alemania desde 2019 y desde entonces aprendo alemán por el camino
					difícil: todos los cursos presenciales de A1 a B1.2, la mayoría más de una vez, las grandes
					aplicaciones de idiomas y una larga lista de recursos en línea. <strong class="key">Y me sigue costando.</strong>
					Todas esas herramientas me perdían de la misma manera: un avance rígido, página tras página,
					hasta que el interés desaparecía y dejaba de aprender. Pero cuando vives aquí, rendirse no es
					una opción.
				</p>
			</div>
			<figure>
				<img src="/img/deck/b2b21_homeoffice_opener.webp" alt="Personas trabajando en escritorios en un espacio de trabajo compartido y luminoso" width="512" height="384" loading="lazy" />
			</figure>
			<p>
				<strong class="key">Así que construyo el curso que me faltaba</strong>: algo que funcione solo y
				junto a un curso presencial, para que el idioma siga vivo entre clase y clase.
				<strong class="key">Y lo pruebo primero conmigo</strong>: casi cada parte de la aplicación la pruebo
				antes en carne propia; si funciona, se queda, y si no, la rehago. Espero que ayude a otras personas
				en mi situación, y en situaciones que todavía no imagino.
			</p>
			<p>
				Lo hago todo sin equipo: el código, el contenido del curso, las imágenes y el audio, con las
				herramientas de IA <a href="#ai">descritas arriba</a>. Language Quiz forma parte de mi sitio
				personal <a href="https://www.100words.org/en/" rel="noopener">100words.org</a>, donde
				encontrarás mis otros proyectos. Si algo está mal, confuso o falta,
				<strong class="key">de verdad quiero saberlo</strong>: la aplicación nació precisamente de este
				tipo de comentarios. <a href="/contact">Escríbeme</a>, leo cada mensaje.
			</p>
		</section>
	{:else}
	<header>
		<h1>About Language Quiz</h1>
		<p class="lede">
			A free German course from A1 to C2 that respects your time and your
			privacy: no account, no ads, no paywall, and nothing about you leaves
			your browser.
		</p>
	</header>

	<section class="split">
		<div class="lead">
			<h2>The project</h2>
			<p>
				Language Quiz started in June 2026 as a small quiz for the hardest
				habit in German — <em>der, die, das</em> — and <strong class="key">grew, release by
				release, into a complete course</strong>: stepped lessons with audio at every
				level, fill-in exercises, dictation, flashcards, a word library of
				nouns and verbs, printable exercise sheets, and a book for every level
				that works together with the app. The <a href="/changelog">changelog</a> tells
				that story in full.
			</p>
		</div>
		<figure>
			<img
				src="/img/deck/bahnhof-1200.webp"
				alt="A busy German railway station hall"
				width="512"
				height="384"
				fetchpriority="high"
			/>
		<figcaption class="photo-credit"><a href="/credits#b2a12_bahn_opener">{creditShort('b2a12_bahn_opener')}</a></figcaption>
		</figure>
		<p>
			A few convictions shape every decision. <strong class="key">Learning beats testing</strong>, so
			nothing is locked and every level is open from the first visit.
			Small slips — a missing umlaut, a forgotten full stop — don't sink
			an answer, because that is how real practice works. And <strong class="key">the whole
			thing stays free</strong>: your progress lives in your own browser, the
			audio is pre-recorded rather than metered, and there is no account
			to create because none is needed.
		</p>
		<p>
			<strong class="key">Privacy is not a feature here, it is the architecture.</strong> No cookies,
			no identifiers, no consent banner — only anonymous, aggregate
			statistics, as the <a href="/settings">settings page</a> explains in
			plain words.
		</p>
		<div class="disclosure" id="ai">
			<h3>How AI is used</h3>
			<p>
				In the spirit of saying plainly how things work: <strong class="key">this course is made
				with the help of AI tools</strong>, and you should know where.
			</p>
			<ul>
				<li>
					<strong>Pictures</strong> — every illustration is generated with
					Google's Gemini image model, from prompts and a style I write and choose.
				</li>
				<li>
					<strong>Audio</strong> — the German you hear is spoken by Google Cloud
					Text-to-Speech neural voices, not by recorded human speakers.
				</li>
				<li>
					<strong>Lessons and exercises</strong> — Anthropic's Claude helps me draft
					explanations, example sentences and questions; I decide what goes
					in, and check and correct it.
				</li>
				<li>
					<strong>Code</strong> — I write the app with Claude Code, an AI coding assistant.
				</li>
			</ul>
			<p>
				<strong class="key">None of it runs on you</strong>: no AI reads your answers or your progress,
				and the speaking exercise hands off to an assistant <em>you</em>
				choose. AI still gets things wrong, and some slips will get past me
				— if you spot one, please tell me.
			</p>
		</div>
	</section>

	<section class="split">
		<div class="lead">
			<h2>The mission</h2>
			<p>
				Most language courses assume one kind of learner: start at page
				one, proceed in a straight line, pass the test, turn the page.
				Plenty of people don't learn that way — and too many of them
				conclude the problem is them. <strong class="key">It isn't.</strong> Part of my mission with
				Language Quiz is to <strong class="key">open German up to exactly those people</strong>.
			</p>
		</div>
		<figure>
			<img
				src="/img/deck/b2a21_sonntag_opener.webp"
				alt="A path winding through a sunny German forest"
				width="512"
				height="384"
				loading="lazy"
			/>
		</figure>
		<p>
			That is why the course refuses to be a single straight line. You
			can read a lesson, listen to it, drill it as flashcards, type it,
			speak it, play it as a game, or open the book and work
			on paper — the same German, offered in as many shapes as there are
			ways of learning. Jump levels, circle back, skip what bores you:
			<strong class="key">the course adapts to how you learn, not the other way round.</strong>
		</p>
		<p>
			And it runs on free, open technology end to end, so it can stay
			free for every learner. <strong class="key">Access to a language should not depend on
			a subscription.</strong>
		</p>
		<div class="disclosure" id="accessibility">
			<h3>Accessibility</h3>
			<p>
				Opening German up has to include people who use a screen reader, a
				keyboard instead of a mouse, or who can't rely on colour, sound or
				fast reading. <strong class="key">The course is built to work for them too</strong>, aiming
				at the WCAG 2.2 AA guidelines:
			</p>
			<ul>
				<li>
					<strong>Screen readers</strong> — right and wrong answers, the
					corrected answer, your run result and new medals are read out as
					they happen. German is marked as German (titles, answers, words in
					the picture hunt), so it is spoken in a German voice rather than an
					English one. Every icon button has a name, and in the picture hunt
					every object in the room is a named button, so you can look for it
					in a list instead of by eye. When a panel or a pop-up opens, your
					screen reader goes into it, the page behind it goes quiet, Escape
					closes it and you land back where you were.
				</li>
				<li>
					<strong>One voice at a time</strong> — the course reads German
					questions and answers aloud by itself. If you use a screen reader,
					turn off "Say questions and answers aloud" in
					<a href="/settings">settings</a> so the two voices don't talk over
					each other; the play buttons still work.
				</li>
				<li>
					<strong>Keyboard</strong> — every exercise, the card deck and every
					panel work without a mouse. There is a "Skip to content" link, the
					der/die/das buttons and other choices move with the arrow keys,
					Enter moves on after an answer, and the picture hunt zooms with
					+ and − buttons as well as a pinch. Your place is never lost when
					the screen changes.
				</li>
				<li>
					<strong>Your own pace</strong> — nothing is timed. In settings you
					choose how long an answer stays on screen, and "Wait for me" stops
					the exercises moving on by themselves at all.
				</li>
				<li>
					<strong>Hearing</strong> — "Show the text in listening exercises"
					adds the text to dictations and listening exercises and writes the
					word in the picture hunt's Listen step. If no voice can play, that
					step writes the word by itself. No exercise needs a microphone.
				</li>
				<li>
					<strong>Seeing</strong> — text meets the AA contrast guidelines,
					noun genders are told apart by their underline as well as their
					colour, and every page still works on a screen 320 pixels wide or
					zoomed in to 400%.
				</li>
				<li>
					<strong>Hands and typing</strong> — in the picture hunt a tap just
					beside a small thing still finds it. "Relaxed correction" (on by
					default) accepts an answer that only misses an umlaut, an accent or
					a full stop, so a keyboard without ä, ö, ü and ß is no problem.
				</li>
				<li>
					<strong>Motion and sound</strong> — "Calm effects" in settings, or
					your device's "reduce motion" setting, turns off the confetti,
					shakes and pulses. "Mute the app" silences everything, and the
					sound effects can be turned off on their own.
				</li>
			</ul>
			<p>
				The course is checked in rounds with an automatic accessibility test
				(axe), a walk through each page using only the keyboard, and a narrow
				320-pixel screen.
			</p>
			<p>
				I test this myself, but not with every assistive technology. If
				something gets in your way, <strong class="key">please tell me</strong>; I treat that
				as a bug, not a wish.
			</p>
		</div>
	</section>

	<section class="split">
		<div class="lead">
			<h2>About me</h2>
			<p>
				Hi — I'm GDI. I moved to Germany in 2019, and I've been learning
				German the hard way ever since: every classroom course from A1 to
				B1.2, most of them more than once, plus the big language apps and a
				long list of other online resources. <strong class="key">And still I
				struggle.</strong> Every one of those tools lost me the same way — the
				rigid forward march, one page after the next, until the interest
				drained away and I stopped. But stopping isn't an option when you
				live here. I need to keep learning.
			</p>
		</div>
		<figure>
			<img
				src="/img/deck/b2b21_homeoffice_opener.webp"
				alt="People working at desks in a bright shared office"
				width="512"
				height="384"
				loading="lazy"
			/>
		</figure>
		<p>
			<strong class="key">So I'm building the course I needed</strong>: something that works on its
			own and alongside a classroom course, for keeping the language
			alive between lessons. <strong class="key">I'm also its first test subject</strong> — nearly
			every interaction in the app gets tried on me first, kept when it
			works and rebuilt when it doesn't, so the app gets better while I
			learn. I hope it helps more people in my situation, and in
			situations I haven't imagined yet.
		</p>
		<p>
			I build this on my own — the code, the course content, the
			drawings and the audio, with the AI tools
			<a href="#ai">described above</a>. Language Quiz is part of
			<a href="https://www.100words.org/en/" rel="noopener">100words.org</a>,
			my personal site, where my other projects live. If something is wrong,
			confusing or missing, <strong class="key">I genuinely want to know</strong>: the app has grown
			out of exactly that kind of feedback. <a href="/contact">Write to me</a> —
			every message gets read — or ask in the <a href="/forum">forum</a>, where
			other learners can see the answer too.
		</p>
	</section>
	{/if}
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.5rem;
	}

	/* Tighter than the stock page-wide: the full-width paragraphs set the
	   measure here, and past ~95ch they stop being comfortable to read. */
	main {
		max-width: 56rem;
	}

	header {
		margin-bottom: 3rem;
	}

	.lede {
		margin: 0;
		max-width: 62ch;
		color: var(--ink-muted);
	}

	section h2 {
		margin: 0 0 0.75rem;
		font-size: 1.25rem;
	}

	section p {
		margin: 0 0 1rem;
		line-height: 1.65;
	}

	/* The line each paragraph turns on: a touch heavier, in the heading ink,
	   over a soft terracotta highlighter stroke along the lower half — enough
	   for a skimming eye to catch, quiet enough to keep it prose. */
	.key {
		font-weight: 600;
		color: var(--heading);
		background: linear-gradient(transparent 58%, var(--accent-soft) 58%);
		box-decoration-break: clone;
		-webkit-box-decoration-break: clone;
		padding-inline: 0.1em;
	}

	/* -- each section: heading + opening paragraph beside the picture, ------
	   -- then the rest of the prose across the full width ------------------ */
	/* The cream panel is the illustration's own paper; rounded like every
	   other card, it reads as a deliberate plate next to the lead text. */
	.split {
		display: grid;
		grid-template-columns: minmax(0, 1fr) minmax(16rem, 22rem);
		column-gap: 3rem;
		row-gap: 0.25rem;
		align-items: center;
		margin-bottom: 3.5rem;
	}

	.split .lead {
		grid-column: 1;
	}

	.split figure {
		grid-column: 2;
		grid-row: 1;
		margin: 0;
	}

	/* The paragraphs after the lead span both columns, ending flush with the
	   picture's right edge so the whole section shares one text block. */
	.split > p {
		grid-column: 1 / -1;
		/* The global p measure would stop short of the picture's edge. */
		max-width: none;
	}

	.split > p:last-child {
		margin-bottom: 0;
	}

	/* The AI disclosure: a quiet ruled-off note across the full width. */
	.disclosure {
		grid-column: 1 / -1;
		margin-top: 0.75rem;
		padding-top: 1.25rem;
		border-top: 1px solid var(--line);
	}

	.disclosure h3 {
		margin: 0 0 0.5rem;
		font-size: 1.05rem;
	}

	.disclosure p,
	.disclosure ul {
		max-width: none;
	}

	.disclosure ul {
		margin: 0 0 1rem;
		padding-inline-start: 1.25rem;
		line-height: 1.65;
	}

	.disclosure li + li {
		margin-top: 0.35rem;
	}

	.disclosure p:last-child {
		margin-bottom: 0;
	}

	.split img {
		display: block;
		width: 100%;
		height: auto;
		aspect-ratio: 4 / 3;
		object-fit: cover;
		border-radius: var(--radius);
	}

	/* On a phone everything stacks: heading, lead, picture, rest. The photo
	   runs full width, cropped a little lower so it does not fill the screen. */
	@media (max-width: 48rem) {
		.split {
			grid-template-columns: 1fr;
			margin-bottom: 2.5rem;
		}
		.split figure {
			grid-column: 1;
			grid-row: auto;
			margin: 0.25rem 0 1.25rem;
		}
		.split img {
			aspect-ratio: 16 / 9;
		}
	}
	.photo-credit {
		margin-top: 0.3rem;
		font-size: 0.72rem;
	}
	.photo-credit a {
		color: var(--ink-muted);
	}
</style>
