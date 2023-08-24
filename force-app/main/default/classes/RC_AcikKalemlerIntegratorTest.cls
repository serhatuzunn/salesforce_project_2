@isTest
public class RC_AcikKalemlerIntegratorTest {
    @isTest
    public static void UnitTest(){

        RC_AcikKalemlerIntegrator.Item item = new RC_AcikKalemlerIntegrator.Item();
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
        
        RC_AcikKalemlerIntegrator.RequestModel req = new RC_AcikKalemlerIntegrator.RequestModel();
        req.IV_BUKRS = '';
        req.IV_KEYDATE = '';
        req.IV_KKBER = '';
        req.IV_KUNNR = '';
        req.IV_ODK = '';
        req.IV_SURID = '';



        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        
        Test.startTest();
        
        RC_AcikKalemlerIntegrator.responseModel resp =  RC_AcikKalemlerIntegrator.getAcikKalemler(req);
        
        
        Test.stopTest();
    }
}