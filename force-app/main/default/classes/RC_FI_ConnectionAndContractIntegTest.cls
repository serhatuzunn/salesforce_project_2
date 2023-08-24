@isTest
public class RC_FI_ConnectionAndContractIntegTest {
 @isTest
    public static void UnitTest(){
        RC_FI_ConnectionAndContractIntegrator.Item itm = new RC_FI_ConnectionAndContractIntegrator.Item();
 		 itm.MANDT = '';
        itm.GJAHR = '';
        itm.KUNNR = '';
        itm.ZLSCH = '';
        itm.KKBER = '';
        itm.ROW_NO = '';
        itm.BORDROTIPI = '';
        itm.PORTFOY = '';
        itm.SMCTR = '';
        itm.CVDTE = '';
        itm.START_DATE = '';
        itm.END_DATE = '';
        itm.TIMESTAMP = '';
        itm.USERNAME = '';
        itm.VARIANT = '';
        itm.ZTERM = '';
        itm.GJAHR_ZLSCH = '';
        itm.LAST_DATE = '';
        itm.LAST_TIME = '';
        
        RC_FI_ConnectionAndContractIntegrator.IT_SOZLESME itmSozlesme = new RC_FI_ConnectionAndContractIntegrator.IT_SOZLESME();
        itmSozlesme.item = new List<RC_FI_ConnectionAndContractIntegrator.Item>();
        
        RC_FI_ConnectionAndContractIntegrator.IT_ODEME_PLAN itmOdeme = new RC_FI_ConnectionAndContractIntegrator.IT_ODEME_PLAN();
        itmOdeme.item = new List<RC_FI_ConnectionAndContractIntegrator.Item>();
        
        RC_FI_ConnectionAndContractIntegrator.RequestWrapper req = new RC_FI_ConnectionAndContractIntegrator.RequestWrapper();
        req.IT_ODEME_PLAN = itmOdeme;
        req.IT_SOZLESME = itmSozlesme;
        
        
        
        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        
        Test.startTest();
        RC_BordroCancelIntegratorParser resp =  RC_FI_ConnectionAndContractIntegrator.FI_ConnectionAndContractFunction(req);
        Test.stopTest();
    }
}