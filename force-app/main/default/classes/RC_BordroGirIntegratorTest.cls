@isTest
public class RC_BordroGirIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_BordroGirIntegrator.Item item = new RC_BordroGirIntegrator.Item();
        item.BELNR = '';
        item.BUZEI = '';
        item.KUNNR = '';
        item.BUDAT = '';
        item.ZFBDT = '';
        item.WAERS = '';
        item.DMBTR = '';
        item.SGTXT = '';
        item.BLART = '';
        item.VKBUR = '';
        
        RC_BordroGirIntegrator.IT_ITEMS items = new RC_BordroGirIntegrator.IT_ITEMS();
        items.Item = item;
        
        RC_BordroGirIntegrator.RequestModel req = new RC_BordroGirIntegrator.RequestModel();
        
        req.IV_KKBER = '';
        req.IV_KUNNR = '';
        req.IV_ODK = '';
        req.IT_ITEMS = items;
        
        Test.setMock(HttpCalloutMock.class, new RC_BordroGirIntegratorMock());
        
        Test.startTest();
        
        RC_BordroGirIntegrator.responseModel resp = RC_BordroGirIntegrator.getBordroGir(req);
        
        Test.stopTest();
    }
}