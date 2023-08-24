@isTest
public class RC_OrtalamaVadeIntegratorTest {
    @isTest
    public static void UnitTest(){

        RC_OrtalamaVadeIntegrator.Item item = new RC_OrtalamaVadeIntegrator.Item();
        item.BELNR = '';
        item.BUZEI = '';
        item.KUNNR = '';
        item.BUDAT = '';
        item.ZFBDT = '';
        item.WAERS = '';
        item.DMBTR = '';
        item.SGTXT = '';
        item.BLART = '';
        item.AWKEY = '';
        item.GJAHR = '';
        item.ZLSPR = '';
        item.ZLSCH = '';
        item.LTEXT = '';
        item.MATNR = '';
        item.MAKTX = '';
        item.MENGE = '';
        item.MEINS = '';
        
        RC_OrtalamaVadeIntegrator.RequestModel req = new RC_OrtalamaVadeIntegrator.RequestModel();
        req.IV_BUKRS = '';
        req.IV_KEYDATE = '';
        req.IV_KKBER = '';
        req.ET_ITEMS = new RC_OrtalamaVadeIntegrator.ET_ITEMS();
        req.ET_ITEMS.item = item;

        Test.setMock(HttpCalloutMock.class, new RC_OrtalamaVadeIntegratorMock());
        
        Test.startTest();
        
        RC_OrtalamaVadeIntegrator.responseModel resp =  RC_OrtalamaVadeIntegrator.getAcikKalemler(req);
        
        
        Test.stopTest();
    }
}