<script lang="ts">
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

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
</script>

<Seo
	title="About Language Quiz: a free German course by a learner"
	description="The story behind Language Quiz: a free, accessible A1–C2 German course by a learner in Germany for people who struggle with linear courses. No account, no ads."
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
				A1 ve A2 seviyelerini kapsıyor.
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
</style>
