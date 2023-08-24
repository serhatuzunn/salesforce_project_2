@isTest
public class RC_FI_BordroGirIntegratorTest {
    @isTest
    public static void UnitTest(){
        RC_FI_BordroGirIntegrator.Item itm = new RC_FI_BordroGirIntegrator.Item();
        itm.BELNR = '';
        itm.BUZEI = '';
        itm.KUNNR = '';
        itm.BUDAT = '';
        itm.ZFBDT = '';
        itm.WAERS = '';
        itm.DMBTR = '';
        itm.SGTXT = '';
        itm.BLART = '';
        itm.VKBUR = '';
        itm.UMSKZ = '';
        
        RC_FI_BordroGirIntegrator.IT_ITEMS IT_ITEMS = new RC_FI_BordroGirIntegrator.IT_ITEMS();
        IT_ITEMS.item = new List<RC_FI_BordroGirIntegrator.Item>();
        
        RC_FI_BordroGirIntegrator.requestModel req = new RC_FI_BordroGirIntegrator.requestModel();
        
        req.IT_ITEMS = IT_ITEMS;
        req.IV_ODK   = '';
        req.IV_KUNNR = '';
        req.IV_KKBER = '';
        
        RC_FI_BordroGirIntegrator.responseModel resp = new RC_FI_BordroGirIntegrator.responseModel();
        resp.BORDRONO = '';
        resp.EV_BAKIYE = '';
        resp.EV_KKBER = '';
        resp.EV_MESSAGE = '';
        resp.EV_ORTVADE = '';
        resp.EV_SUCCESS = '';
        

        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        
        Test.startTest();
        resp =  RC_FI_BordroGirIntegrator.BordroGir(req);
        Test.stopTest();
    }
}