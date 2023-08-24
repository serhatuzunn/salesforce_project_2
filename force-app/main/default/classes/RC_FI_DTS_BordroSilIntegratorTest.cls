@isTest
public class RC_FI_DTS_BordroSilIntegratorTest {
    @isTest
    public static void UnitTest(){
        RC_FI_DTS_BordroSilIntegrator.item itm = new RC_FI_DTS_BordroSilIntegrator.item();
        itm.BORDRO = '';
        
        
        RC_FI_DTS_BordroSilIntegrator.T_BORDRO T_BORDRO = new RC_FI_DTS_BordroSilIntegrator.T_BORDRO();
        T_BORDRO.item = new List<RC_FI_DTS_BordroSilIntegrator.item>();
        
        RC_FI_DTS_BordroSilIntegrator.requestModel req = new RC_FI_DTS_BordroSilIntegrator.requestModel();
        req.T_BORDRO = T_BORDRO;
        
        RC_FI_DTS_BordroSilIntegrator.responseModel resp = new RC_FI_DTS_BordroSilIntegrator.responseModel();
        resp.DURUM = 'OK';
        
        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        
        Test.startTest();
        resp.DURUM =  RC_FI_DTS_BordroSilIntegrator.bordroSil(req);
        Test.stopTest();
    }
}