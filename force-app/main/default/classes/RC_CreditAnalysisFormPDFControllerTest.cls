@isTest
public class RC_CreditAnalysisFormPDFControllerTest {
    
    @testsetup static void prepareData(){
        try{
            Account acc = new Account();
            acc.Name = 'Test account';
            insert acc;
            
            RC_Credit_Analysis_Form__c caf = new RC_Credit_Analysis_Form__c();
            caf.RC_Account__c = acc.Id;
            insert caf;
            
            List<RC_Account_Financial_Information__c> afiList = new List<RC_Account_Financial_Information__c>();
            for(Integer i=0; i<=10; i++){
                RC_Account_Financial_Information__c afi = new RC_Account_Financial_Information__c();
                Decimal yil = 2019;
                afi.Account__c = acc.Id;
                afi.RecordTypeId = Schema.SObjectType.RC_Account_Financial_Information__c.getRecordTypeInfosByDeveloperName().get('Bilanco').getRecordTypeId();
                afi.RC_Aktif_Toplam__c = 100;
                afi.RC_Donen_Varliklar__c = 100;
                afi.RC_Hazir_Degerler__c = 100;
                afi.RC_Ticari_Alacaklar__c = 100;
                afi.RC_Supheli_Ticari_Alacaklar__c = 10;
                afi.RC_Stoklar__c = 100 - i * 10;
                afi.RC_Duran_Varliklar__c = 100;
                afi.RC_Ticari_Alacaklar_Duran_Varl_k__c = 100;
                afi.RC_Maddi_Duran_Varliklar__c = 100;
                afi.RC_KV_Yabanci_Kaynaklar__c = 100;
                afi.RC_Banka_Kredileri__c = 100;
                afi.RC_Ticari_Borc_lar__c = 100;
                afi.RC_UV_Yabanci_Kaynaklar__c = 100;
                afi.RC_Banka_Kredileri_UV__c = 100;
                afi.RC_Ticari_Borclar_UV__c = 100;
                afi.RC_Ozkaynaklar__c = 100;
                afi.RC_Odenmis_Sermaye__c = 100;
                afi.RC_Yil__c = String.valueOf(yil + 1);
                afi.RC_Net_Kar__c = 100 - i * 5;
                afi.RC_Net_Satislar__c = 100;
                afi.RC_Satilan_Malin_Maliyeti__c = 100;
                afiList.add(afi);
            }
            
            for(Integer i=0; i<=10; i++){
                RC_Account_Financial_Information__c afi = new RC_Account_Financial_Information__c();
                Decimal yil = 2019;
                afi.Account__c = acc.Id;
                afi.RecordTypeId = Schema.SObjectType.RC_Account_Financial_Information__c.getRecordTypeInfosByDeveloperName().get('Gelir_Tablosu').getRecordTypeId();
                afi.RC_Yil__c = String.valueOf(yil + 1);
                afi.RC_Net_Kar__c = 100 - i * 5;
                afi.RC_Net_Satislar__c = 100;
                afi.RC_Satilan_Malin_Maliyeti__c = 100;
                afi.RC_Faaliyet_Kari__c = 100;
                afiList.add(afi);
            }
            List<Database.SaveResult> svresultList = Database.insert(afiList, false);
            for(Database.SaveResult sv : svresultList){
                system.debug('SV : ' + JSON.serialize(sv));
                if(sv.isSuccess()){
                    system.debug('ayşaaaaaa');
                }
                else{
                    system.debug('ınıııııııııl');
                }
            }
        }catch(exception e){
            system.debug('Exception : ' + e.getMessage());
        }
        RC_CreditAnalysisFormPDFController.oranAnaliziWrapper oaw = new RC_CreditAnalysisFormPDFController.oranAnaliziWrapper();
        oaw.ortalamaTahsilatSuresi1 = 10;
        oaw.ortalamaTahsilatSuresi2 = 10;
        oaw.ortalamaTahsilatSuresi3 = 10;
        oaw.stokTutmaSuresi1 = 10;
        oaw.stokTutmaSuresi2 = 10;
        oaw.stokTutmaSuresi3 = 10;
        
        RC_CreditAnalysisFormPDFController.bilancoWrapper bw = new RC_CreditAnalysisFormPDFController.bilancoWrapper();
        bw.aktifToplam1 = 10;
        bw.aktifToplam2 = 10;
        bw.aktifToplam3 = 10;
        bw.bankaKredileriKV1 = 10;
        bw.bankaKredileriKV2 = 10;
        bw.bankaKredileriKV3 = 10;
        bw.bankaKredileriUV1 = 10;
        bw.bankaKredileriUV2 = 10;
        bw.bankaKredileriUV3 = 10;
        bw.donenVarliklar1 = 10;
        bw.donenVarliklar2 = 10;
        bw.donenVarliklar3 = 10;
        bw.duranVarliklar1 = 10;
        bw.duranVarliklar2 = 10;
        bw.duranVarliklar3 = 10;
        bw.hazirDegerler1 = 10;
        bw.hazirDegerler2 = 10;
        bw.hazirDegerler3 = 10;
        bw.kvYabanciKaynaklar1 = 10;
        bw.kvYabanciKaynaklar2 = 10;
        bw.kvYabanciKaynaklar3 = 10;
        bw.maddiDuranVarliklar1 = 10;
        bw.maddiDuranVarliklar2 = 10;
        bw.maddiDuranVarliklar3 = 10;
        bw.odenmisSermaye1 = 10;
        bw.odenmisSermaye2 = 10;
        bw.odenmisSermaye3 = 10;
        bw.ozKaynaklar1 = 10;
        bw.ozKaynaklar2 = 10;
        bw.ozKaynaklar3 = 10;
        bw.stoklar1 = 10;
        bw.stoklar2 = 10;
        bw.stoklar3 = 10;
        bw.supheliTicariAlacaklar1 = 10;
        bw.supheliTicariAlacaklar2 = 10;
        bw.supheliTicariAlacaklar3 = 10;
        bw.ticariAlacaklar1 = 10;
        bw.ticariAlacaklar2 = 10;
        bw.ticariAlacaklar3 = 10;
        bw.ticariAlacaklarduranVarliklar1 = 10;
        bw.ticariAlacaklarduranVarliklar2 = 10;
        bw.ticariAlacaklarduranVarliklar3 = 10;
        bw.ticariBorclarKV1 = 10;
        bw.ticariBorclarKV2 = 10;
        bw.ticariBorclarKV3 = 10;
        bw.ticariBorclarUV1 = 10;
        bw.ticariBorclarUV2 = 10;
        bw.ticariBorclarUV3 = 10;
        bw.uvYabanciKaynaklar1 = 10;
        bw.uvYabanciKaynaklar2 = 10;
        bw.uvYabanciKaynaklar3 = 10;
        bw.yil1 = '10';
        bw.yil2 = '10';
        bw.yil3 = '10';
        
        RC_CreditAnalysisFormPDFController.gelirTablosuWrapper gtw = new RC_CreditAnalysisFormPDFController.gelirTablosuWrapper();
        gtw.faaliyetKari1 = 10;
        gtw.faaliyetKari2 = 10;
        gtw.faaliyetKari3 = 10;
        gtw.netKar1 = 10;
        gtw.netKar2 = 10;
        gtw.netKar3 = 10;
        gtw.netSatislar1 = 10;
        gtw.netSatislar2 = 10;
        gtw.netSatislar3 = 10;
        gtw.satilanMalMaliyeti1 = 10;
        gtw.satilanMalMaliyeti2 = 10;
        gtw.satilanMalMaliyeti3 = 10;
    }
    
    static testMethod void unitTest(){
        Test.startTest(); 
        
        RC_Credit_Analysis_Form__c caf = [SELECT Id FROM RC_Credit_Analysis_Form__c LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new RC_BayiCekSenetMock());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(caf);
        RC_CreditAnalysisFormPDFController ext = new RC_CreditAnalysisFormPDFController(sc);
        
        Test.stopTest();
    }
}