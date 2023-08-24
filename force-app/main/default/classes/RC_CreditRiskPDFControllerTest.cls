@isTest
public class RC_CreditRiskPDFControllerTest {

    static testMethod void unitTest(){
        RC_CreditRiskComponentController.initWrapper initWrp = new RC_CreditRiskComponentController.initWrapper();
        RC_CreditRiskPDFController.creditRiskResponse creditRiskResp = new RC_CreditRiskPDFController.creditRiskResponse();
        creditRiskResp.ACIK_BAGSIZ = 10;
        creditRiskResp.FARK_ASIM = 10;
        creditRiskResp.TOP_KREDI = 10;
        creditRiskResp.TOP_RISK = 10;
        creditRiskResp.odemeGunSayisi = 10 * 365;
        creditRiskResp.ACIK_BAGSIZ_VALOR = 10;
        creditRiskResp.ACIK_BKY = 10;
        creditRiskResp.ACIK_VALOR = 10;
        creditRiskResp.ACIK_KREDI = 10;
        creditRiskResp.IPOTEK = 10;
        creditRiskResp.TEMINAT = 10;
        creditRiskResp.AVAL_KREDI = 10;
        creditRiskResp.EKYONETIM_LMT2 = 10;
        creditRiskResp.ALACAK_SIGORTA = 10;
        creditRiskResp.KMH_LIMIT = 10;
        creditRiskResp.KMH = 10;
        creditRiskResp.DBS_LIMIT = 10;
        creditRiskResp.DBSBORC = 10;
        creditRiskResp.DTSTEMCEK = 10;
        creditRiskResp.AVAL_BONOSU = 10;
        creditRiskResp.YENILENECEK_TMNT = 10;
        creditRiskResp.KUL_KLIMA_LMT = 10;
        creditRiskResp.EK_KLIMA_LMT = 10;
        creditRiskResp.KUL_CEPTEL_LMT = 10;
        creditRiskResp.EK_CEPTEL_LMT = 10;
        creditRiskResp.KUL_KEA_LMT = 10;
        creditRiskResp.EK_KEA_LMT = 10;
        creditRiskResp.KUL_ACM_LMT = 10;
        creditRiskResp.EK_ACM_LMT = 10;
        creditRiskResp.KARSILIKSIZ_CEKLER = 10;
        creditRiskResp.PROTESTOLU_SENETLER = 10;
        creditRiskResp.IADELI_CEKLER = 10;
        creditRiskResp.IADELI_SENETLER = 10;
        creditRiskResp.KONSINYE = 10;
        creditRiskResp.EMANET = 10;
		creditRiskResp.TEMINATIPOTEK = 10;
        creditRiskResp.TEMINAT = 10;
        
        Account acc = new Account();
        acc.Name = 'test account';
        acc.RC_SAP_ID__c = '20100340';
        insert acc;
        
        RC_SD_Organization__c SD = new RC_SD_Organization__c();
        SD.RC_Account__c = acc.id;
        SD.RC_Sales_Organization__c = '0001';
        SD.Distribution_Channel__c = '06';
        insert SD; 
        
        RC_CreditRiskPDFController.Item itm = new RC_CreditRiskPDFController.Item();
        itm.BOENO = '';
        itm.VADE = '';
        itm.WAERS = '';
        itm.PORTF = '';
        itm.BOENO = '';
        itm.TUTAR = 0;
        itm.BORALA = '';
        
        List<RC_CreditRiskPDFController.Item> itmList = new List<RC_CreditRiskPDFController.Item>();
        itmList.add(itm);
        
        RC_CreditRiskPDFController.GroupedCheckByMonth GroupedCheckByMonth = new RC_CreditRiskPDFController.GroupedCheckByMonth();
        GroupedCheckByMonth.MonthAndYear = '';       
        GroupedCheckByMonth.TotalValue = 0.0;  
        GroupedCheckByMonth.ItemList = itmList;
        
        RC_CreditRiskPDFController.GroupedCheckTypes GroupedCheckTypes = new RC_CreditRiskPDFController.GroupedCheckTypes();
        GroupedCheckTypes.CheckType = '';
        GroupedCheckTypes.TotalValueByMonthAndYear = new List< RC_CreditRiskPDFController.GroupedCheckByMonth>();
        
        Test.setMock(HttpCalloutMock.class, new RC_BayiCekSenetMock());
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        RC_CreditRiskPDFController ext = new RC_CreditRiskPDFController(sc);
        
        Test.stopTest();
    }
}