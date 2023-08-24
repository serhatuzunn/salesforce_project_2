public class RC_QuoteAfterTriggerHelper {

    public static string GetBody(string bodyText){
    
    string saddsa = '<!DOCTYPE html>';
         saddsa += '<html>';
			saddsa += '<head>';
    		saddsa +='<title></title>';
			saddsa +='</head>';

		saddsa +='<body>';
        saddsa += bodyText;
		saddsa += '</body>';

		saddsa +='</html>';
        
        
    	return saddsa;
	}
    
    public static string TeklifSartlari(Datetime ExpirationDate,string WarrantyPeriod)
    {
        string response = '';
        string formattedExpirationDate = '';
        if(ExpirationDate != null)
      	  formattedExpirationDate = ExpirationDate.format('dd.MM.yyyy');
        
         response += '<ul style=list-style-type: disc;>';
        response += '<li><span style=sans-serif;color:#262626;>İşbu teklifimiz,&nbsp;</span><span style=sans-serif;color:#262626;>teklif&nbsp;</span><span style=sans-serif;color:#262626;>tarihinden itibaren '+ formattedExpirationDate +' tarihine kadar ge&ccedil;erlidir. Bu s&uuml;re i&ccedil;erisinde tarafınızca Teklif Şartları&rsquo;na uygun olarak d&uuml;zenlenecek bir &ldquo;Sipariş Formu&rdquo;nun Şirketimizce yazılı olarak teyit edilmemesi halinde yeni teklif şartları almak i&ccedil;in Satış Yetkilisi ile g&ouml;r&uuml;ş&uuml;n&uuml;z.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Fiyatlarımız yukarıda belirtilen adetler ve toplam proje bedeli dikkate alınarak oluşturulmuştur. Toplam Proje bedelinin ve adetlerin değişmesi halinde fiyatlarımız değişecektir.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>İşbu teklifimizde yer alan bedeller &uuml;r&uuml;nlerin tesliminden &ouml;nce peşin &ouml;deme esasına g&ouml;re oluşturulmuştur. Vade talep edilmesi halinde satış yetkilimiz ile g&ouml;r&uuml;ş&uuml;n&uuml;z. Vade uygulanması halinde faturalarda yazan vade, kur ve gecikme faizi oranları bağlayıcı olacaktır. Vestel Ticaret A.Ş. , vadeli alımlarda sevkten &ouml;nce uygun bir teminat isteyebilir ve sıralı &ccedil;eklerle hesabın kapatılmasını isteyebilir.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Aksi taraflar arasında yazılı olarak akdedilecek olan s&ouml;zleşmede kararlaştırılmadığı s&uuml;rece &uuml;r&uuml;nlerin teslim s&uuml;resi; peşin satışlarda &ouml;demenin tamamının yapılmasından, vadeli satışlarda ise t&uuml;m &ouml;deme evraklarının ve sipariş bedeli kadar teminatın VESTEL&rsquo; e teslim &nbsp;edilmesinden itibaren (8) haftadır.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Siparişiniz, Firmanızca işbu teklif şartlarına uygun &ldquo;Sipariş Formu&rdquo; ile Şirketimizin yukarıda belirtilen fax numarasına iletilip, Şirketimiz tarafından da teyit edildikten sonra bu teyidin Firmanızın Sipariş Formu&rsquo;nda belirteceğiniz fax numarasına ulaşmasından itibaren kesinleşmiş olacak ve &uuml;r&uuml;nlerin VESTEL Fabrikalarında Firmanızın siparişi doğrultusunda &uuml;retilmesi talimatı verilecektir. Bu aşamadan sonra sipariş iptali, &uuml;r&uuml;nlerin iadesi, &uuml;r&uuml;nlerin teslim alınmaması, ilave veya eksik sipariş kesinlikle s&ouml;z konusu olmayacaktır. Aksi halde Vestel Ticaret A.Ş. nezdinde doğmuş ve/veya doğacak her t&uuml;rl&uuml; zarar ve ziyan ( oluşan stok problemi, finansman y&uuml;k&uuml;, kar kaybı, vade kaybı vb. dahil ancak bunlarla sınırlı olmaksızın ) &nbsp;Firmanıza y&uuml;klenecektir. Bu sebeple Sipariş Formu&rsquo;nu d&uuml;zenlemeden &ouml;nce adetlerin, talep edilen teslimat zamanının ve t&uuml;m Temel Teklif Şartlarımızın değerlendirilerek siparişinizin kesinliğinden emin olunması gerekmektedir.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Fiyatlarımıza, Sipariş Formu&rsquo;nda belirteceğiniz adrese kadar yapılacak teslimat d&acirc;hildir. Şirketimizin, sipariş edilen &uuml;r&uuml;nleri belirttiğiniz adrese teslimi ile birlikte &uuml;r&uuml;nlerle ilgili her t&uuml;rl&uuml; sorumluluğu sona erecektir. Ancak Firmanız tarafından, &uuml;r&uuml;nlerin montajının yapılacağı mahallerin her t&uuml;rl&uuml; alt yapısının; elektrik ve su tesisatının montaja hazır hale getirilmesi, montaj yapılacak ortamların kimyasallardan ve inşaat artıklarından tamamen arındırılmış olması gerekmektedir. Aksi halde, bu nedenle &uuml;r&uuml;nlerde meydana gelebilecek zararlardan &uuml;retici firma hi&ccedil;bir şekilde sorumlu olmayacaktır.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Montaj gerektiren &uuml;r&uuml;nlerin montajları VESTEL yetkili servisleri tarafından yerine getirilecek, &nbsp;garanti ve satış sonrası hizmetleri ilgili y&uuml;r&uuml;rl&uuml;kteki mevzuata tabi olacaktır. &nbsp;&Uuml;r&uuml;nlerin garanti s&uuml;resi teslim tarihinden itibaren '+ WarrantyPeriod +' yıldır.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;>Cihazların uzun &ouml;m&uuml;rl&uuml; ve daha performanslı &ccedil;alışması i&ccedil;in periyodik bakımlarını yaptırmanız gerekmektedir. Montajları yapılan cihazların periyodik bakımları Vestel yetkili servisleri tarafından yapılmalıdır. Vestel yetkili servisleri haricinde yapılacak herhangi bir işlem sonrası cihazlar garanti dışı kalacaktır. Periyodik bakımları yapılmayan cihazlarda bakım yapılmaması nedeni ile oluşacak arızalar ve performans d&uuml;ş&uuml;mlerinden Vestel sorumlu tutulamaz.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Sipariş Formu&rsquo;nda belirttiğiniz adrese yapılan teslimatlar Firmanıza &nbsp;yapılmış kabul edilecektir. Firmanızın &uuml;r&uuml;nleri herhangi bir sebeple teslim almaması veya montajın yapılacağı mahalleri montaja hazır duruma getirememesi halinde Vestel Ticaret A.Ş.&rsquo;nin işbu satışı &nbsp;her zaman tek taraflı ve tazminatsız olarak fesih hakkı olduğu &nbsp; gibi, bunlarla sınırlı olmaksızın yapmış olduğu t&uuml;m masrafları ve doğmuş/doğacak t&uuml;m zararını (gidiş-d&ouml;n&uuml;ş nakliye, depolama, stok maliyetleri, &uuml;r&uuml;nlerin daha d&uuml;ş&uuml;k bir bedele satışı vb.) &nbsp; tazminini talep etme hakkı saklıdır.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>&Uuml;r&uuml;nlerin bir zaman planına g&ouml;re teslimatı ve montajı isteniyorsa bu tarihler adet/set d&ouml;k&uuml;ml&uuml; olarak Sipariş Formu&rsquo;nda a&ccedil;ık&ccedil;a belirtilmelidir.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Taraflarca imzalanmamış, kaşelenmemiş sipariş formu ge&ccedil;ersizdir. Şirketinizin d&uuml;zenleyeceği her t&uuml;rl&uuml; belge &uuml;zerinde Sipariş Formu referans numarası ve tarihi belirtilmelidir. Fiyatlarımız her t&uuml;rl&uuml; vergi, resim, har&ccedil;, damga pulu, s&ouml;zleşme masrafı vb. kanuni giderler hari&ccedil; olarak d&uuml;zenlenmiştir.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>S&ouml;zleşme ile aksi kararlaştırılmadığı takdirde, ge&ccedil; &ouml;demelerde TRL borca aylık %4, &nbsp;D&ouml;viz borca aylık &nbsp;%2 oranında faiz uygulanır. &nbsp;&Ouml;demelerin s&uuml;resinde yapılmaması halinde Vestel Ticaret A.Ş. &lsquo;nin taraflar arasındaki işbu alım satım anlaşmasını derhal bildirimsiz ve tazminatsız olarak fesh edebileceği gibi, geciken &ouml;demelerin vade farklarıyla birlikte yerine getirilmesi ve zararların tazminini &nbsp;i&ccedil;in karşı tarafa makul bir s&uuml;re &nbsp;verebilir. Verilen ek s&uuml;reye rağmen &ouml;demenin gereği gibi ifa edilmemesi durumunda Vestel Ticaret A.Ş.&rsquo;nin doğmuş ve/veya doğacak her t&uuml;rl&uuml; zarar ve ziyanı ( finansman y&uuml;k&uuml;, kar kaybı, vade kaybı vb. d&acirc;hil ancak bunlarla sınırlı olmaksızın ) Firmanızdan tazmin edilecektir.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Vestel Ticaret A.Ş. ve grup şirketlerinin &nbsp;ticari &uuml;nvanı, işletme adı, grup adı,marka,logo ve sair tanıtım işaretleri yazılı izin almaksızın kullanılamaz. Bu konudaki talepleriniz i&ccedil;in Satış Yetkilisi ile irtibat kurabilirsiniz. &nbsp;İzinsiz kullanım hallerinin tespiti halinde Vestel Ticaret A.Ş. ve grup şirketlerinin, doğmuş doğacak her t&uuml;rl&uuml; zarar ve ziyanından Firmanız sorumlu olacaktır.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Vestel Ticaret A.Ş. gerektiği hallerde teklif edilen &uuml;r&uuml;n&uuml;n muadili veya bir &uuml;st model ve &ouml;zellikte &uuml;r&uuml;nler sağlayacaktır.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>İşbu Teklif Mektubu hi&ccedil;bir şekilde stok tutulacağı, &uuml;r&uuml;n depolaması yapılacağı şeklinde yorumlanamaz. Şirketimiz, uhdesinde olmayan ve/ veya sonradan satış yapılması istenmeyen &uuml;r&uuml;nlerin siparişini tek taraflı inisiyatifine bağlı olarak kısmen veya tamamen reddedebilir, belli adetler i&ccedil;in sipariş tedarik edebilir.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Teklifimiz sadece firmanızın ihtiyacı i&ccedil;in ve size &ouml;zel olarak hazırlanmıştır. Teklifimiz ve fiyatlarımız gizlidir. &Uuml;&ccedil;&uuml;nc&uuml; şahıslar ile paylaşılamaz.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Vestel, yapılan iş ile sınırlı kalmak şartıyla, montajı tamamlanan &uuml;r&uuml;nlerin ve hizmet sunulan firmaya ait &ccedil;eşitli g&ouml;rselleri, dilediği g&ouml;rseller ile ve &ouml;nceden yazılı onay aranmaksızın, reklam amacı ile kullanılmak &uuml;zere g&ouml;r&uuml;nt&uuml;leyebilir ve paylaşabilir.</span></li>';
    response += '</ul>';
    response += '<p style=margin-top:0in;margin-right:0in;margin-bottom:0in;margin-left:.5in;line-height:normal;font-size:15px;font-family:Calibri,sans-serif;text-align:justify;><span style=sans-serif;color:#262626;>&nbsp;</span></p>';
        return GetBody(response);
    }
    
    public static string KamuSartlari(string WarrantyPeriod,string DeliveryTime,decimal DeliveryTime2,string term,Datetime ExpirationDate)
    {
        string termReturn = '';
         string formattedExpirationDate = '';
        if(ExpirationDate != null)
      	  formattedExpirationDate = ExpirationDate.format('dd.MM.yyyy');
        
         if(term == 'Peşin')
    termReturn = '<li>&Uuml;r&uuml;nlerin fabrikadan &ccedil;ıkışı sırasında fatura d&uuml;zenlenir, &ouml;deme fabrika &ccedil;ıkışı &ouml;ncesi peşin olarak yapılır.</li>';
    else
    termReturn=   '<li>&Uuml;r&uuml;nlerin fabrikadan &ccedil;ıkışı sırasında fatura d&uuml;zenlenir, &ouml;deme '+ term +' vadeli olarak yapılır.</li>';
    
         
        string response = '';
        
           response += '<ul style="list-style-type: disc;">';
    response += '    <li>Fiyata KDV dahil dahildir.&nbsp;</li>';
    response += '    <li>Teklif '+ formattedExpirationDate +' tarihine kadar ge&ccedil;erlidir. Gerekli olduğunda teklif opsiyonunu uzatılmasını s&uuml;resi i&ccedil;inde g&ouml;r&uuml;ş&uuml;n&uuml;z.&nbsp;</li>';
    response += '    <li>Birim fiyatlar projenin tamamı i&ccedil;in oluşturulmuştur, toplam adet/proje değiştiğinde Vestel fiyatları revize etme hakkını saklı tutar.&nbsp;</li>';
    response += termReturn;
    response += '    <li>Teslimat siparişin onaylanmasından itibaren '+ DeliveryTime2 + ' '+ DeliveryTime +' olarak belirlenmiştir.&nbsp;</li>';
    response += '    <li>Teslimat tarafımızdan ilgili adrese (tek nokta) yapılacaktır.&nbsp;</li>';
    response += '    <li>KDV oranı ve diğer yasal değişikliklerden doğabilecek farklar teklifimizdeki fiyatlara aynen yansıtılacaktır.&nbsp;</li>';
    response += '    <li>Fiyat teklifi gizlidir, fimanınıza &ouml;zeldir ve sadece işbu proje i&ccedil;in ge&ccedil;erlidir. Fiyat teklifinin, teklif verilen makam dışında 3. şahıslarla paylaşılması durumunda, Vestel, uğrayacağı b&uuml;t&uuml;n zararların tazmin edilmesi cihetine gidebilir.&nbsp;</li>';
    response += '    <li>Fiyata nakliye ve montaj dahildir.&nbsp;</li>';
    response += '    <li>&Uuml;r&uuml;nler '+ WarrantyPeriod +' yıl garantilidir.</li>';
      response += ' </ul>';
        
        return GetBody(response);
    }
    
    public static string Notlar(string WarrantyPeriod,string DeliveryTime,decimal DeliveryTime2,string term)
    {
        string termReturn = '';
        string response = '';
        
                if(term == 'Peşin')
     termReturn = '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Proforma fatura tarafımızca hazırlanarak banka havalesi ile toplam tutar nakit &ouml;deme yapılacaktır.</span></span></span></li>';
    else
     termReturn= '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Proforma fatura tarafımızca hazırlanarak <span style="color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; float: none; display: inline !important;"> ' + term + '</span> vadeli &ouml;deme yapılacaktır.</span></span></span></li>';
           
        
    
     response += '<ul style="list-style-type: disc;">';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Fiyatlarımıza KDV <strong>dahildir.</strong></span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Teslimat süreleri, her parti ürün için ödemenin yapılması ardından, ürünlerin stokta olması durumunda en geç '+ DeliveryTime2  +' '+ DeliveryTime + ' içinde sevk edilecektir.</span></span></span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Teklifimiz nakit olarak hazırlanmıştır.</span></span></span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">&Uuml;r&uuml;nlerimiz <span style="color: rgb(8, 7, 7); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: pre-line; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; float: none; display: inline !important;"> '+ WarrantyPeriod +'</span>&nbsp; yıl garantilidir.</span></span></span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Fiyatlarımız &Uuml;r&uuml;n + Montaj dahildir.&nbsp;</span></span></span></li>';
     response += termReturn;
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Teklifimize elektrik hattı, besleme ,karot kesme ve inşai işler ve dr</span><span style=font-family:"Verdana",sans-serif;color:#262626;>enaj hattı &ccedil;ekilmesi dahil değildir.&nbsp;</span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Vin&ccedil;, forklift vb. ekstra taşıma &uuml;cretleri hari&ccedil;tir.</span></li>';
     response += ' </ul>';

         
         return GetBody(response);
    }
    
    public static string Notes(string WarrantyPeriod,string DeliveryTime,decimal DeliveryTime2,string term)
    {
        string termReturn = '';
        string response = '';
        
                /*if(term == 'Peşin')
     termReturn = '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Proforma fatura tarafımızca hazırlanarak banka havalesi ile toplam tutar nakit &ouml;deme yapılacaktır.</span></span></span></li>';
    else
     termReturn= '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Proforma fatura tarafımızca hazırlanarak <span style="color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; float: none; display: inline !important;"> ' + term + '</span> vadeli &ouml;deme yapılacaktır.</span></span></span></li>';
      */     
        
    
     response += '<ul style="list-style-type: disc;">';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">VAT is <strong>not</strong> included in our prices.</span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Our prices include Installation.</span></span></span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Products which are not in stock will be delivered in 14-16 weeks.</span></span></span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Our products are guaranteed for 2 years.</span></span></span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">We will prepare a proforma invoice and the payment of the overall price will be made via bank transfer.</span></span></span></li>';
     response += termReturn;
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">Our offer doesn’t include power line installment, charging, drilling core, construction work and drain pipe installment.</span></li>';
     response += '   <li><span style=font-size: 16px;"><span style="sans-serif;"><span style="color: rgb(38, 38, 38);">The price excludes crane, forklift etc. extra transportation prices. </span></li>';
     response += ' </ul>';

         
         return GetBody(response);
    }
    
    public static string TermsOfOffer(Datetime ExpirationDate,string WarrantyPeriod)
    {
        string response = '';
        string formattedExpirationDate = '';
        if(ExpirationDate != null)
      	  formattedExpirationDate = ExpirationDate.format('dd.MM.yyyy');
        
         response += '<ul style=list-style-type: disc;>';
        response += '<li><span style=sans-serif;color:#262626;>This offer will be in force within 10 (ten) days from the date of offer. In case an “Offer Form,” prepared by you according to Terms of the Proposal, is not confirmed in written form by our company in this period, please kindly contact our Sales Representative to be informed about the terms of the new offer.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Our prices are specified in consideration to above number of items and overall project price. In case Overall Project price and number of items change, our prices will also change accordingly.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Prices in this offer are specified to be paid in cash before the delivery of the products. If you need extra time please kindly contact our sales representative. In case extra time is granted, foreign exchange rate, redemption date and interest of default will be binding. Vestel Trade Co., might demand a proper assurance before delivery or charging of debt via consecutive checks in deferred sales.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>In case the opposite is not agreed upon in a written contract by the parties, delivery time of the products is due upon the overall payment in cash sales and within 8 (eight) weeks upon the delivery of all payment documents and assurance based on the order price to VESTEL in deferred sales.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Your order will be confirmed once your Company delivers an “Order Form” prepared in line with these terms of proposal to the aforementioned fax number of our Company and our confirmation is delivered to your Company’s fax number specified in your Order Form and your products are instructed to be manufactured in VESTEL factories in line with your order. From that moment on, we won’t accept cancellation of order, product return, delivery failure, additional or lacking piece order. Otherwise, all damages and/or loss that might occur on the side of Vestel Trade Co. (including but not limited to possible stock problems, financial burden, profit loss, deferment loss etc.) will be the liability of your company. Therefore, please make sure that your order is final before preparing the Order Form by evaluating number of items, requested delivery time and all basic terms of the proposal. </span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Our prices include delivery to the address you specify in the Order Form. All liability of our company regarding the products will be finalized upon their delivery to the specified address. Nevertheless, your company is required to make the infrastructure ready, with power and water systems duly installed, in the lieu of installment which will be cleared of all chemicals and debris. Otherwise, the manufacturing company will not be held liable for all loss that might occur in products due to such negligence.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Installment of related products will be undertaken by VESTEL authorized services, guarantee and after-sales services will be subjected to related regulations in force. Guarantee term of the products is 2 years upon the date of delivery.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;>You are required to periodically carry out the maintenance of your devices so that they have a long time and they perform better. Installed devices shall be periodically maintained by Vestel authorized services. Upon any operation on products by parties other than Vestel authorized services, products will fall out of the scope of guarantee. Malfunction and underperformance due to negligence in periodical maintenance are not under the liability of Vestel.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Delivery to the address specified in the Order Form is deemed delivery to your company. In case your company cannot, for some reason, deliver the products or make them ready for installment, Vestel Trade Co., holds the right to unilaterally annul the sales in question without compensation, as well as the right to demand restitution of all costs and damages which have occurred and/or will occur (including but not limited to round-trip delivery fee, storage and stock costs, sales of products for cheaper prices etc.).&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>In case products are required to be delivered and installed according to a special schedule, these dates must be clearly specified in the Order Form based on items/sets of products.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Order Forms which is not undersigned and laminated by the Parties are deemed invalid. All documents to be prepared by your company shall include Order Form reference number and date. Our prices exclude all types of taxes, levies and charges, stamp fax, contract fee etc. legal costs.&nbsp;</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>In case the contrary is not specified in a Contract, deferred payment will be subjected to %4 of interest in TL debts and %2 of interest in foreign exchange debts. In case payments are not made in due terms, Vestel Trade Co., holds the right to immediately annul this sales and purchase contract without compensation and notification. The other party might receive an extra time to cover deferred payment with late interest and compensate the damage. In case the payment is not duly made albeit the granted extra time, your Company will cover all existing and/or possible damage and loss of Vestel Trade Co. (including but not limited to financing burden, profit loss etc.).</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Commercial title, company name, group name, logo and similar identification marks of Vestel Trade Co. and group companies cannot be used without written consent. Please kindly contact our Sales Representative for such demands. In case unauthorized use of above identification marks is detected, Vestel Trade Co. and group companies have the right to hold your Company responsible for all existing and possible damage and loss.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Vestel Trade Co. will provide you with an equivalent of the offered product or products of a higher model or properties, if necessary.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>This Letter of Proposal, by no means, signifies that stocks will be kept and the product will be stored. Our Company can unilaterally and upon will decide on partial or entire rejection of orders regarding products which are not under its liability and/or post facto sales decline.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Our offer is uniquely prepared for you according to your company’s requirements. Our offer and prices are confidential. They cannot be shared with third parties.</span></li>';
        response += '<li><span style=sans-serif;color:#262626;>Vestel can take pictures/videos of installed products and various visuals of the  company receiving its services to use them for advertisement purposes with desired other visuals without the need for a written permission, as long as it is related to the work done as part of the proposal.</span></li>';
    response += '</ul>';
    response += '<p style=margin-top:0in;margin-right:0in;margin-bottom:0in;margin-left:.5in;line-height:normal;font-size:15px;font-family:Calibri,sans-serif;text-align:justify;><span style=sans-serif;color:#262626;>&nbsp;</span></p>';
        return GetBody(response);
    }
    
    
}