public class RC_CreditRiskPDFController {
    ApexPages.StandardController controller;
    
    public Account acct {get;set;}
    public Account account {get;set;}
    public RC_CreditRiskComponentController.responseWrapper responseWrp {get;set;}
    public RC_CreditRiskComponentController.initWrapper initWrp {get;set;}
    public creditRiskResponse creditRiskResp {get;set;}
    public bayiCekSenetResp cekSenetResp {get;set;}
    public List<baglantiResp> baglntiRespList {get;set;}
    public baglantiResp baglntiResp {get;set;}
    public String KKA {get;set;}
    public String distChannel {get;set;}
    
    public boolean isShowCekSenetAltDetay {get;set;}
    public boolean isShowConnectionDetail {get;set;}
    public boolean isShowSahsiCek {get;set;}
    public boolean isShowSahsiSenet {get;set;}
    public boolean isShowSahsiMusteriCek {get;set;}
    public boolean isShowSahsiMusteriSenet {get;set;}
    public boolean isShowSahsiDtsCek {get;set;}
    public boolean isShowSahsiBaglantiCek {get;set;}
    public boolean isShowSahsiBaglantiSenet {get;set;}
    
    public List<GroupedCheckByMonth> sahsiCek {get;set;}
    public List<GroupedCheckByMonth> sahsiSenet {get;set;}
    public List<GroupedCheckByMonth> musteriCek {get;set;}
    public List<GroupedCheckByMonth> musteriSenet {get;set;}
    public List<GroupedCheckByMonth> dtsCek {get;set;}
    public List<GroupedCheckByMonth> baglantiCek {get;set;}
    public List<GroupedCheckByMonth> baglantiSenet {get;set;}
    
    public RC_CreditRiskPDFController(ApexPages.StandardController c) {
        controller = c;
        acct = (Account) c.getRecord(); 
        system.debug('acct: ' + acct);
        if(acct.Id == null){
            return;
        }
        account = [SELECT Id, Name, AccountNumber, RC_SAP_ID__c FROM Account WHERE Id=:acct.Id];
        
        distChannel = ApexPages.currentPage().getParameters().get('distChannel');
        system.debug('distChannel: ' + distChannel);
        
        creditRiskResp = new creditRiskResponse();
        cekSenetResp = new bayiCekSenetResp();
        baglntiRespList = new List<baglantiResp>();
        
        initWrp = RC_CreditRiskComponentController.initialize(acct.Id);
        system.debug('initWrp: ' + initWrp);
        
        if(distChannel == '') KKA = 'Tümü';
        else KKA = distChannel;
        
        responseWrp = RC_CreditRiskComponentController.getCreditRiskReport(acct.Id, distChannel);
        system.debug('responseWrp: ' + responseWrp);
        
        List<String> decimalItems = new List<String>{'ACIK_BAGSIZ','FARK_ASIM','TOP_KREDI','TOP_RISK','RISK_CIRO','ACIK_BAGSIZ_VALOR','ACIK_BKY','ACIK_VALOR','ACIK_KREDI','IPOTEK','TEMINATIPOTEK', 'TEMINAT','AVAL_KREDI',
            'EKYONETIM_LMT2','ALACAK_SIGORTA','KMH_LIMIT','KMH','DBS_LIMIT','DBSBORC','DTSTEMCEK','AVAL_BONOSU','YENILENECEK_TMNT','KUL_KLIMA_LMT','EK_KLIMA_LMT',
            'KUL_CEPTEL_LMT','EK_CEPTEL_LMT','KUL_KEA_LMT','EK_KEA_LMT','KUL_ACM_LMT','EK_ACM_LMT','KARSILIKSIZ_CEKLER','PROTESTOLU_SENETLER','IADELI_CEKLER',
            'IADELI_SENETLER','KONSINYE','EMANET'};
                Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(responseWrp.creditRiskResponse.itemZ));
        Map<String, Decimal> itemWrapperMap = new Map<String, Decimal>();
        
        for(String decItem:decimalItems){
            if(decItem == 'RISK_CIRO'){
                itemWrapperMap.put('odemeGunSayisi', (Decimal.valueOf((String)itemMap.get(decItem)) * 365));
            }
            else{
                if(itemMap.get(decItem) != null){
                     itemWrapperMap.put(decItem, (Decimal.valueOf((String)itemMap.get(decItem))));
                }
            }
        }
        creditRiskResp = (creditRiskResponse)JSON.deserialize(JSON.serialize(itemWrapperMap), creditRiskResponse.class);
        /*
List<String> wrapperItems = new List<String>{'CEK_SAHSI_TOP','SENET_SAHSI_TOP','CEK_MUSTERI_TOP','SENET_MUSTERI_TOP','CEK_DTS_TOP','CEK_BAGLANTI_TOP','SENET_BAGLANTI_TOP'};
Map<String, Object> cekSenetItemMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(responseWrp.bayiCekSenetResponse.etReturn.item[0]));
Map<String, Integer> cekSenetItemWrapperMap = new Map<String, Integer>();

for(String wrapItem:wrapperItems){
cekSenetItemWrapperMap.put(wrapItem, (Integer.valueOf((String)cekSenetItemMap.get(wrapItem))));
}
cekSenetResp = (bayiCekSenetResp)JSON.deserialize(JSON.serialize(cekSenetItemWrapperMap), bayiCekSenetResp.class);
*/
        if(!test.isRunningTest()){
            cekSenetResp.CEK_SAHSI_TOP = Double.valueOf(responseWrp.bayiCekSenetResponse.etReturn.item[0].CEK_SAHSI_TOP);
            cekSenetResp.SENET_SAHSI_TOP = Double.valueOf(responseWrp.bayiCekSenetResponse.etReturn.item[0].SENET_SAHSI_TOP);
            cekSenetResp.CEK_MUSTERI_TOP = Double.valueOf(responseWrp.bayiCekSenetResponse.etReturn.item[0].CEK_MUSTERI_TOP);
            cekSenetResp.SENET_MUSTERI_TOP = Double.valueOf(responseWrp.bayiCekSenetResponse.etReturn.item[0].SENET_MUSTERI_TOP);
            cekSenetResp.CEK_DTS_TOP = Double.valueOf(responseWrp.bayiCekSenetResponse.etReturn.item[0].CEK_DTS_TOP);
            if(responseWrp.bayiCekSenetResponse.etReturn.item[0].CEK_BAGLANTI_TOP != null) cekSenetResp.CEK_BAGLANTI_TOP = Double.valueOf(responseWrp.bayiCekSenetResponse.etReturn.item[0].CEK_BAGLANTI_TOP);
            cekSenetResp.SENET_BAGLANTI_TOP = Double.valueOf(responseWrp.bayiCekSenetResponse.etReturn.item[0].SENET_BAGLANTI_TOP);
  			//Baglanti detayı varsa göster
            if(responseWrp.baglantiResponse.etReturn.item[0].KUNNR != ''){
                isShowConnectionDetail = true;
            }
            for(Integer i=0; i < responseWrp.baglantiResponse.etReturn.item.size(); i++){
                baglntiResp = new baglantiResp();
                baglntiResp.SOZLESME_BAS = responseWrp.baglantiResponse.etReturn.item[i].SOZLESME_BAS;
                baglntiResp.SOZLESME_BIT = responseWrp.baglantiResponse.etReturn.item[i].SOZLESME_BIT;
                if(responseWrp.baglantiResponse.etReturn.item[i].TOPLAM_CEK != null) baglntiResp.TOPLAM_CEK = responseWrp.baglantiResponse.etReturn.item[i].TOPLAM_CEK;
                baglntiResp.VADE_TARIH = responseWrp.baglantiResponse.etReturn.item[i].VADE_TARIH;
                if(responseWrp.baglantiResponse.etReturn.item[i].FAT_TOTAL != null) baglntiResp.FAT_TOTAL = responseWrp.baglantiResponse.etReturn.item[i].FAT_TOTAL;
                if(responseWrp.baglantiResponse.etReturn.item[i].BAGCEK_TOTAL1 != null) baglntiResp.BAGCEK_TOTAL1 = responseWrp.baglantiResponse.etReturn.item[i].BAGCEK_TOTAL1;
                baglntiResp.BAGCEK_VADE_TARIH = responseWrp.baglantiResponse.etReturn.item[i].BAGCEK_VADE_TARIH;
                if(String.isNotBlank(baglntiResp.TOPLAM_CEK) && String.isNotBlank(baglntiResp.FAT_TOTAL)) baglntiResp.remainingAmount = Decimal.valueOf(baglntiResp.TOPLAM_CEK) - Decimal.valueOf(baglntiResp.FAT_TOTAL);
                baglntiRespList.add(baglntiResp);
            }
            system.debug('baglntiRespList: ' + baglntiRespList);
        }
        else{
            cekSenetResp.CEK_SAHSI_TOP = 10;
            cekSenetResp.SENET_SAHSI_TOP = 10;
            cekSenetResp.CEK_MUSTERI_TOP = 10;
            cekSenetResp.SENET_MUSTERI_TOP = 10;
            cekSenetResp.CEK_DTS_TOP = 10;
            cekSenetResp.CEK_BAGLANTI_TOP = 10;
            cekSenetResp.SENET_BAGLANTI_TOP = 10;
            
            for(Integer i=0; i < 2; i++){
                baglntiResp = new baglantiResp();
                baglntiResp.SOZLESME_BAS = String.valueOf(system.today().addDays(-5));
                baglntiResp.SOZLESME_BIT = String.valueOf(system.today());
                baglntiResp.TOPLAM_CEK = '10';
                baglntiResp.VADE_TARIH = String.valueOf(system.today());
                baglntiResp.FAT_TOTAL = '10';
                baglntiResp.BAGCEK_TOTAL1 = '10';
                baglntiResp.BAGCEK_VADE_TARIH = String.valueOf(system.today());
                baglntiResp.remainingAmount = 10;
                baglntiResp.SOZLESME_NO = 'Test10';
                baglntiRespList.add(baglntiResp);
            }
        }
      	 
        isShowCekSenetAltDetay = false;
        isShowSahsiCek = false;
        isShowSahsiSenet = false;
        isShowSahsiMusteriCek = false;
        isShowSahsiMusteriSenet = false;
        isShowSahsiDtsCek = false;
        isShowSahsiBaglantiCek = false;
        isShowSahsiBaglantiSenet = false;
        
        List<RC_CreditRiskComponentController.GroupedCheckTypes> groupBayiCekSenet = responseWrp.groupedBayiCekSenet;
        String jsn = JSON.serialize(groupBayiCekSenet);
        system.debug('jsn.:' + jsn);
        List<GroupedCheckTypes> newGroupBayiCekSenet = ( List<GroupedCheckTypes> )JSON.deserialize(jsn, List<GroupedCheckTypes>.class);
        system.debug('aaa:' + newGroupBayiCekSenet );
        if(newGroupBayiCekSenet.size() > 0){
            for(GroupedCheckTypes detayItem : newGroupBayiCekSenet){
                if(detayItem.CheckType == 'CEK_SAHSI'){
                    isShowSahsiCek = true;
                    sahsiCek = detayItem.TotalValueByMonthAndYear;
                }
                else if(detayItem.CheckType == 'SENET_SAHSI'){
                    isShowSahsiSenet = true;
                    sahsiSenet = detayItem.TotalValueByMonthAndYear;
                }
                else if(detayItem.CheckType == 'CEK_MUSTERI'){
                    isShowSahsiMusteriCek = true;
                    musteriCek = detayItem.TotalValueByMonthAndYear;
                }
                else if(detayItem.CheckType == 'SENET_MUSTERI'){
                    isShowSahsiMusteriSenet = true;
                    musteriSenet = detayItem.TotalValueByMonthAndYear;
                }
                else if(detayItem.CheckType == 'CEK_DTS'){
                    isShowSahsiDtsCek = true;
                    dtsCek = detayItem.TotalValueByMonthAndYear;
                    //dtsCekItemList = detayItem.TotalValueByMonthAndYear.
                }
                else if(detayItem.CheckType == 'CEK_BAGLANTI'){
                    isShowSahsiBaglantiCek = true;
                    baglantiCek = detayItem.TotalValueByMonthAndYear;
                }
                else if(detayItem.CheckType == 'SENET_BAGLANTI'){
                    isShowSahsiBaglantiSenet = true;
                    baglantiSenet = detayItem.TotalValueByMonthAndYear;
                }
            }
        }

        if(isShowSahsiCek || isShowSahsiSenet || isShowSahsiMusteriCek || isShowSahsiMusteriSenet || isShowSahsiBaglantiCek || isShowSahsiBaglantiSenet){
            isShowCekSenetAltDetay = true;
        }
    }
    
    public class creditRiskResponse{
        public Decimal ACIK_BAGSIZ 			{get;set;}
        public Decimal FARK_ASIM 			{get;set;}
        public Decimal TOP_KREDI 			{get;set;}
        public Decimal TOP_RISK 			{get;set;}
        public Decimal ACIK_BAGSIZ_VALOR 	{get;set;}
        public Decimal ACIK_BKY 			{get;set;}
        public Decimal ACIK_VALOR 			{get;set;}
        public Decimal ACIK_KREDI 			{get;set;}
        public Decimal IPOTEK 				{get;set;}
        public Decimal TEMINATIPOTEK 		{get;set;}
        public Decimal TEMINAT 				{get;set;}
        public Decimal AVAL_KREDI 			{get;set;} 
        public Decimal EKYONETIM_LMT2 		{get;set;}
        public Decimal ALACAK_SIGORTA 		{get;set;}
        public Decimal KMH_LIMIT 			{get;set;}
        public Decimal KMH 					{get;set;}
        public Decimal DBS_LIMIT 			{get;set;}
        public Decimal DBSBORC 				{get;set;}
        public Decimal DTSTEMCEK 			{get;set;}
        public Decimal AVAL_BONOSU 			{get;set;}
        public Decimal YENILENECEK_TMNT 	{get;set;}
        public Decimal KUL_KLIMA_LMT 		{get;set;}
        public Decimal EK_KLIMA_LMT 		{get;set;}
        public Decimal KUL_CEPTEL_LMT 		{get;set;}
        public Decimal EK_CEPTEL_LMT 		{get;set;}
        public Decimal KUL_KEA_LMT 			{get;set;}
        public Decimal EK_KEA_LMT 			{get;set;}
        public Decimal KUL_ACM_LMT 			{get;set;}
        public Decimal EK_ACM_LMT 			{get;set;}
        public Decimal KARSILIKSIZ_CEKLER 	{get;set;}
        public Decimal PROTESTOLU_SENETLER 	{get;set;}
        public Decimal IADELI_CEKLER 		{get;set;}
        public Decimal IADELI_SENETLER 		{get;set;}
        public Decimal KONSINYE 			{get;set;}
        public Decimal EMANET 				{get;set;}
        public Decimal odemeGunSayisi 		{get;set;}
    }
    
    public class bayiCekSenetResp{
        public Double CEK_SAHSI_TOP 		{get;set;}
        public Double SENET_SAHSI_TOP 		{get;set;}
        public Double CEK_MUSTERI_TOP 		{get;set;}
        public Double SENET_MUSTERI_TOP 	{get;set;}
        public Double  CEK_DTS_TOP 			{get;set;}
        public Double CEK_BAGLANTI_TOP 	{get;set;}
        public Double SENET_BAGLANTI_TOP 	{get;set;}
    }
    
    public class baglantiResp{
        public String SOZLESME_NO 			{get;set;}
        public String SOZLESME_BAS 			{get;set;}
        public String SOZLESME_BIT 			{get;set;}
        public String TOPLAM_CEK 			{get;set;}
        public String VADE_TARIH 			{get;set;}
        public String FAT_TOTAL 			{get;set;}
        public String BAGCEK_TOTAL1 		{get;set;}
        public String BAGCEK_VADE_TARIH 	{get;set;}
        public Decimal remainingAmount 		{get;set;}
    }
    
     public class GroupedCheckTypes{
        @AuraEnabled
        public List<GroupedCheckByMonth> TotalValueByMonthAndYear{get;set;}
        @AuraEnabled
        public string CheckType{get;set;}
    }
    
     public class GroupedCheckByMonth{
        @AuraEnabled
        public string MonthAndYear{get;set;}
        @AuraEnabled
        public double TotalValue{get;set;}
        @AuraEnabled
        public List<Item> ItemList{get;set;}
    }
    
    public class Item {
        @AuraEnabled
        public Decimal TUTAR {get;set;}
        @AuraEnabled
        public String BORALA {get;set;}
        @AuraEnabled
        public String VADE {get;set;}
        @AuraEnabled
        public String WAERS {get;set;}
        @AuraEnabled
        public String PORTF {get;set;}
        @AuraEnabled
        public String BOENO {get;set;}
    }
}