@isTest
public class RC_SubeSilIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_SubeSilIntegrator.requestModel req = new RC_SubeSilIntegrator.requestModel();
        req.IV_SUBE = 'IV_SUBE';
        req.IS_SUBE_VERILERI = new RC_SubeSilIntegrator.IS_SUBE_VERILERI();
        req.IS_SUBE_VERILERI.KUNNR = 'KUNNR';
        req.IS_SUBE_VERILERI.VKORG = 'VKORG';
        req.IS_SUBE_VERILERI.VTWEG = 'VTWEG';
        req.IS_SUBE_VERILERI.SPART = 'SPART';
        
        Test.setMock(HttpCalloutMock.class, new RC_SubeSilIntegratorMock());
        
        Test.startTest();
        
        RC_SubeSilIntegrator.getSubeSil(req);
        
        Test.stopTest();
    }
}