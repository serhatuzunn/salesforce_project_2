public class RC_CreditAnalysisFormPDFController {
    ApexPages.StandardController controller;
    
    public RC_Credit_Analysis_Form__c creditAnalysisForm {get;set;}
    public RC_Credit_Analysis_Form__c creditAnalysisFormRec {get;set;}
    public List<RC_Account_Financial_Information__c> vestelWorkInfoList {get;set;}
    public List<RC_Account_Financial_Information__c> bankInfoList {get;set;}
    public List<RC_Account_Financial_Information__c> gayrimenkulInfoList {get;set;}
    public List<RC_Account_Financial_Information__c> bilancoInfoList {get;set;}
    public List<RC_Account_Financial_Information__c> gelirTablosuList {get;set;}
    public List<RC_Account_Financial_Information__c> oranAnaliziList {get;set;}
    public List<bilancoWrapper> bilancoWrapperList {get;set;}
    public bilancoWrapper bilancoWrapperItem {get;set;}
    public gelirTablosuWrapper gelirTablosuItem {get;set;}
    public oranAnaliziWrapper oranAnaliziItem {get;set;}
    
    public RC_CreditAnalysisFormPDFController(ApexPages.StandardController c) {
        controller = c;
        creditAnalysisForm = (RC_Credit_Analysis_Form__c) c.getRecord(); 
        system.debug('creditAnalysisForm: ' + creditAnalysisForm);
        if(creditAnalysisForm.Id == null){
            return;
        }
        
        creditAnalysisFormRec = [SELECT Id, Name, CreatedBy.Name, RC_Account__c, RC_Statu_Satis_Kanali__c, RC_Bayi_Olus_Tarihi__c, RC_Rapor_Tarihi__c, RC_Son_Kredi_Degerleme__c, RC_Risk_Performansi__c,
                                 RC_Is_Merkezi__c,RC_Sicil_No__c, RC_Vergi_No__c, RC_is_merkezii__c, RC_Sube__c, RC_Kurulus_Tarihi__c, RC_Sicil_No_Vergi_No__c, RC_Firma_Sahibi_Temsil_Sure__c, RC_Kayitli_Sermaye__c, RC_Acik_Kredi_Limit__c, RC_Acik_Kredi_Teminat__c,
                                 RC_Kefalet_Kredisi_Limit__c, RC_Kefalet_Kredisi_Teminat__c, RC_Banka_Teminat_Mektubu_Limit__c, RC_Banka_Teminat_Mektubu_Teminat__c, RC_Ipotek_Limit__c, RC_Ipotek_Teminat__c,
                                 RC_Musteri_Cek_Senet_Limit__c, RC_Musteri_Cek_Senet_Teminat__c, RC_Toplam_Limit__c, RC_Karsiliksiz_Cek_Protestolu_Senet__c, Piyasa_Bilgisi__c, RC_Findeks_Rapor_Ozeti__c,
                                 RC_Diger_Sektor_Bilgileri__c, RC_Cari_Yil_Ciro__c, RC_Inceki_Yil_Ciro__c, RC_Calisma_Suresi__c, RC_Teminat_Turu__c, RC_Teminat_Tutari__c, RC_Ciro_Cari_Donem__c, Ciro_Onceki_Donem__c,
                                 RC_Alacak__c, RC_Borc__c, RC_Stok__c, Kredi_Kartl_Sat__c, RC_Kredi_Kartli_Calisma_Sekli__c, RC_Geciken_Alacak__c, RC_Kanuni_Takip_Alacagi__c, RC_Calisan_Sayisi__c, RC_Aylik_Sabit_Gider__c,
                                 RC_G_Resmi_Veri_Ozeti__c, RC_Tasit_Bilgileri__c, CreatedBy.Manager.Name, CreatedDate, RC_Bolge_Mudurlugu_Gorusu__c, RC_Ozgecmis__c, RC_Genel_Degerlendirme__c,
                                 RC_Gelir_Tablosu_Aciklama__c, RC_Oran_Analizi_Aciklama__c, RC_Bilanco_Aciklama__c, RC_Account_Code__c
                                 FROM RC_Credit_Analysis_Form__c
                                 WHERE Id =: creditAnalysisForm.Id];
        system.debug('creditAnalysisFormRec: ' + creditAnalysisFormRec);
        
        vestelWorkInfoList = [SELECT Id, RC_Ciro__c, RC_Risk__c, RC_Calisma_Vadesi__c, RC_Vadesi_Gecmis_Alacak__c, RC_Karsiliksiz_Cek_Protestolu_Senet__c, RC_Temdit__c, 
                              RC_DTS_KMH_Takip__c, RC_Yil__c
                              FROM RC_Account_Financial_Information__c
                              WHERE Account__c =: creditAnalysisFormRec.RC_Account__c AND RecordType.DeveloperName ='Ciro' Order By RC_Yil__c Desc LIMIT 4];
        
        bankInfoList = [SELECT Id, RC_Banka_Adi__c, RC_Kullandigi_Urunler__c, RC_Limit__c, RC_Risk__c, RC_Teminat__c
                        FROM RC_Account_Financial_Information__c
                        WHERE Account__c =: creditAnalysisFormRec.RC_Account__c AND RecordType.DeveloperName='RC_Calistigi_Bankalar'];
        
        gayrimenkulInfoList = [SELECT Id, RC_Malik__c, RC_Il_Ilce__c, RC_Niteligi__c, RC_Ipotek_Tutari__c, RC_Ekspertiz_Degeri__c, RC_Gecerli_Tutar__c
                               FROM RC_Account_Financial_Information__c
                               WHERE Account__c =: creditAnalysisFormRec.RC_Account__c];
        
        bilancoInfoList = [SELECT Id, RC_Aktif_Toplam__c, RC_Yil__c, RC_Donen_Varliklar__c, RC_Hazir_Degerler__c, RC_Ticari_Alacaklar__c, RC_Supheli_Ticari_Alacaklar__c, RC_Stoklar__c, RC_Duran_Varliklar__c,
                           RC_Ticari_Alacaklar_Duran_Varl_k__c, RC_Maddi_Duran_Varliklar__c, RC_KV_Yabanci_Kaynaklar__c, RC_Banka_Kredileri__c, RC_Ticari_Borc_lar__c, RC_UV_Yabanci_Kaynaklar__c, RC_Banka_Kredileri_UV__c,
                           RC_Ticari_Borclar_UV__c, RC_Ozkaynaklar__c, RC_Odenmis_Sermaye__c
                           FROM RC_Account_Financial_Information__c
                           WHERE Account__c =: creditAnalysisFormRec.RC_Account__c AND RecordType.DeveloperName='Bilanco' Order By RC_Yil__c Desc LIMIT 4];
        integer b = bilancoInfoList.size() - 1;
        integer j = 1;
        Map<String, Decimal> bilancoItemCastMap = new Map<String, Decimal>();
        while(b >= 0){
            if(b-j >=0){
                bilancoItemCastMap.put('yil' + ((b + 1) - j), Decimal.valueOf(bilancoInfoList[b].RC_Yil__c));
                bilancoItemCastMap.put('aktifToplam' + ((b + 1) - j), bilancoInfoList[b].RC_Aktif_Toplam__c);
                bilancoItemCastMap.put('donenVarliklar' + ((b + 1) - j), bilancoInfoList[b].RC_Donen_Varliklar__c);
                bilancoItemCastMap.put('hazirDegerler' + ((b + 1) - j), bilancoInfoList[b].RC_Hazir_Degerler__c);
                bilancoItemCastMap.put('ticariAlacaklar' + ((b + 1) - j), bilancoInfoList[b].RC_Ticari_Alacaklar__c);
                bilancoItemCastMap.put('supheliTicariAlacaklar' + ((b + 1) - j), bilancoInfoList[b].RC_Supheli_Ticari_Alacaklar__c);
                bilancoItemCastMap.put('stoklar' + ((b + 1) - j), bilancoInfoList[b].RC_Stoklar__c);
                bilancoItemCastMap.put('duranVarliklar' + ((b + 1) - j), bilancoInfoList[b].RC_Duran_Varliklar__c);
                bilancoItemCastMap.put('ticariAlacaklarduranVarliklar' + ((b + 1) - j), bilancoInfoList[b].RC_Ticari_Alacaklar_Duran_Varl_k__c);
                bilancoItemCastMap.put('maddiDuranVarliklar' + ((b + 1) - j), bilancoInfoList[b].RC_Maddi_Duran_Varliklar__c);
                bilancoItemCastMap.put('kvYabanciKaynaklar' + ((b + 1) - j), bilancoInfoList[b].RC_KV_Yabanci_Kaynaklar__c);
                bilancoItemCastMap.put('bankaKredileriKV' + ((b + 1) - j), bilancoInfoList[b].RC_Banka_Kredileri__c);
                bilancoItemCastMap.put('ticariBorclarKV' + ((b + 1) - j), bilancoInfoList[b].RC_Ticari_Borc_lar__c);
                bilancoItemCastMap.put('uvYabanciKaynaklar' + ((b + 1) - j), bilancoInfoList[b].RC_UV_Yabanci_Kaynaklar__c);
                bilancoItemCastMap.put('bankaKredileriUV' + ((b + 1) - j), bilancoInfoList[b].RC_Banka_Kredileri_UV__c);
                bilancoItemCastMap.put('ticariBorclarUV' + ((b + 1) - j), bilancoInfoList[b].RC_Ticari_Borclar_UV__c);
                bilancoItemCastMap.put('ozKaynaklar' + ((b + 1) - j), bilancoInfoList[b].RC_Ozkaynaklar__c);
                bilancoItemCastMap.put('odenmisSermaye' + ((b + 1) - j), bilancoInfoList[b].RC_Odenmis_Sermaye__c);
            }
            b--;
        }
        bilancoWrapperItem = (bilancoWrapper)JSON.deserialize(JSON.serialize(bilancoItemCastMap), bilancoWrapper.class);
        
        gelirTablosuList = [SELECT Id, RC_Net_Satislar__c, RC_Satilan_Malin_Maliyeti__c, RC_Faaliyet_Kari__c, RC_Net_Kar__c, RC_Yil__c
                            FROM RC_Account_Financial_Information__c
                            WHERE Account__c =: creditAnalysisFormRec.RC_Account__c AND RecordType.DeveloperName='Gelir_Tablosu' Order By RC_Yil__c Desc LIMIT 4];
        
        integer g = gelirTablosuList.size() - 1;
        integer h = 1;
        Map<String, Decimal> gelirTablosuItemCastMap = new Map<String, Decimal>();
        while(g >= 0){
            if(g-h >=0){
                gelirTablosuItemCastMap.put('netSatislar' + ((g + 1) - j), gelirTablosuList[g].RC_Net_Satislar__c);
                gelirTablosuItemCastMap.put('satilanMalMaliyeti' + ((g + 1) - j), gelirTablosuList[g].RC_Satilan_Malin_Maliyeti__c);
                gelirTablosuItemCastMap.put('faaliyetKari' + ((g + 1) - j), gelirTablosuList[g].RC_Faaliyet_Kari__c);
                gelirTablosuItemCastMap.put('netKar' + ((g + 1) - j), gelirTablosuList[g].RC_Net_Kar__c);
            }
            g--;
        }
        gelirTablosuItem = (gelirTablosuWrapper)JSON.deserialize(JSON.serialize(gelirTablosuItemCastMap), gelirTablosuWrapper.class);
        
        oranAnaliziList = [SELECT Id, RC_Aktif_Toplam__c, RC_Yil__c, RC_Donen_Varliklar__c, RC_Hazir_Degerler__c, RC_Ticari_Alacaklar__c, RC_Supheli_Ticari_Alacaklar__c, RC_Stoklar__c, RC_Duran_Varliklar__c,
                           RC_Ticari_Alacaklar_Duran_Varl_k__c, RC_Maddi_Duran_Varliklar__c, RC_KV_Yabanci_Kaynaklar__c, RC_Banka_Kredileri__c, RC_Ticari_Borc_lar__c, RC_UV_Yabanci_Kaynaklar__c, RC_Banka_Kredileri_UV__c,
                           RC_Ticari_Borclar_UV__c, RC_Ozkaynaklar__c, RC_Odenmis_Sermaye__c, RC_Net_Kar__c, RC_Satilan_Malin_Maliyeti__c, RC_Net_Satislar__c
                           FROM RC_Account_Financial_Information__c
                           WHERE Account__c =: creditAnalysisFormRec.RC_Account__c AND RecordType.DeveloperName='Bilanco' Order By RC_Yil__c Desc LIMIT 4];
        system.debug('oranAnaliziList: ' + oranAnaliziList.size());
        
        integer k = oranAnaliziList.size() - 1;
        integer i = 1;
        Map<String, Decimal> itemCastMap = new Map<String, Decimal>();
        while(k >= 0){
            if(k-i >=0){
                    String key1 = 'stokTutmaSuresi' + ((k + 1) - i);
                    String key2 = 'ortalamaTahsilatSuresi' + ((k + 1) - i);
                
                if(oranAnaliziList[k].RC_Net_Kar__c != 0 && oranAnaliziList[k].RC_Net_Satislar__c != 0 && oranAnaliziList[k].RC_Net_Kar__c != null && oranAnaliziList[k].RC_Net_Satislar__c != null){
                    Decimal stokTutmaSuresi = 360/(oranAnaliziList[k].RC_Net_Kar__c/((oranAnaliziList[k].RC_Stoklar__c+oranAnaliziList[k-1].RC_Stoklar__c)/2));
                    Decimal ortalamaTahsilatSuresi = 360/(oranAnaliziList[k].RC_Net_Satislar__c/((oranAnaliziList[k].RC_Ticari_Alacaklar__c+oranAnaliziList[k-1].RC_Ticari_Alacaklar__c)/2));
                    
                    itemCastMap.put(key1, stokTutmaSuresi);
                    itemCastMap.put(key2, ortalamaTahsilatSuresi);
                }
                else{
                    itemCastMap.put(key1, 0);
                    itemCastMap.put(key2, 0);
                }
            }
            k--;
        }
        oranAnaliziItem = (oranAnaliziWrapper)JSON.deserialize(JSON.serialize(itemCastMap), oranAnaliziWrapper.class);
    }
    
    public class bilancoWrapper{
        public String yil1 {get;set;}
        public String yil2 {get;set;}
        public String yil3 {get;set;}
        public Decimal aktifToplam1 {get;set;}
        public Decimal aktifToplam2 {get;set;}
        public Decimal aktifToplam3 {get;set;}
        public Decimal donenVarliklar1 {get;set;}
        public Decimal donenVarliklar2 {get;set;}
        public Decimal donenVarliklar3 {get;set;}
        public Decimal hazirDegerler1 {get;set;}
        public Decimal hazirDegerler2 {get;set;}
        public Decimal hazirDegerler3 {get;set;}
        public Decimal ticariAlacaklar1 {get;set;}
        public Decimal ticariAlacaklar2 {get;set;}
        public Decimal ticariAlacaklar3 {get;set;}
        public Decimal supheliTicariAlacaklar1 {get;set;}
        public Decimal supheliTicariAlacaklar2 {get;set;}
        public Decimal supheliTicariAlacaklar3 {get;set;}
        public Decimal stoklar1 {get;set;}
        public Decimal stoklar2 {get;set;}
        public Decimal stoklar3 {get;set;}
        public Decimal duranVarliklar1 {get;set;}
        public Decimal duranVarliklar2 {get;set;}
        public Decimal duranVarliklar3 {get;set;}
        public Decimal ticariAlacaklarduranVarliklar1 {get;set;}
        public Decimal ticariAlacaklarduranVarliklar2 {get;set;}
        public Decimal ticariAlacaklarduranVarliklar3 {get;set;}
        public Decimal maddiDuranVarliklar1 {get;set;}
        public Decimal maddiDuranVarliklar2 {get;set;}
        public Decimal maddiDuranVarliklar3 {get;set;}
        public Decimal kvYabanciKaynaklar1 {get;set;}
        public Decimal kvYabanciKaynaklar2 {get;set;}
        public Decimal kvYabanciKaynaklar3 {get;set;}
        public Decimal bankaKredileriKV1 {get;set;}
        public Decimal bankaKredileriKV2 {get;set;}
        public Decimal bankaKredileriKV3 {get;set;}
        public Decimal ticariBorclarKV1 {get;set;}
        public Decimal ticariBorclarKV2 {get;set;}
        public Decimal ticariBorclarKV3 {get;set;}
        public Decimal uvYabanciKaynaklar1 {get;set;}
        public Decimal uvYabanciKaynaklar2 {get;set;}
        public Decimal uvYabanciKaynaklar3 {get;set;}
        public Decimal bankaKredileriUV1 {get;set;}
        public Decimal bankaKredileriUV2 {get;set;}
        public Decimal bankaKredileriUV3 {get;set;}
        public Decimal ticariBorclarUV1 {get;set;}
        public Decimal ticariBorclarUV2 {get;set;}
        public Decimal ticariBorclarUV3 {get;set;}
        public Decimal ozKaynaklar1 {get;set;}
        public Decimal ozKaynaklar2 {get;set;}
        public Decimal ozKaynaklar3 {get;set;}
        public Decimal odenmisSermaye1 {get;set;}
        public Decimal odenmisSermaye2 {get;set;}
        public Decimal odenmisSermaye3 {get;set;}
        
    }
    
    public class gelirTablosuWrapper{
        public Decimal netSatislar1 {get;set;}
        public Decimal netSatislar2 {get;set;}
        public Decimal netSatislar3 {get;set;}
        public Decimal satilanMalMaliyeti1 {get;set;}
        public Decimal satilanMalMaliyeti2 {get;set;}
        public Decimal satilanMalMaliyeti3 {get;set;}
        public Decimal faaliyetKari1 {get;set;}
        public Decimal faaliyetKari2 {get;set;}
        public Decimal faaliyetKari3 {get;set;}
        public Decimal netKar1 {get;set;}
        public Decimal netKar2 {get;set;}
        public Decimal netKar3 {get;set;}
    }
    
    public class oranAnaliziWrapper{
        public Decimal stokTutmaSuresi1 {get;set;}
        public Decimal stokTutmaSuresi2 {get;set;}
        public Decimal stokTutmaSuresi3 {get;set;}
        public Decimal ortalamaTahsilatSuresi1 {get;set;}
        public Decimal ortalamaTahsilatSuresi2 {get;set;}
        public Decimal ortalamaTahsilatSuresi3 {get;set;}
    }
}