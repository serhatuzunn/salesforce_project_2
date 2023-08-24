@isTest
public class RC_AnaVeriIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_AnaVeriIntegrator.requestModel req = new RC_AnaVeriIntegrator.requestModel();
        req.IV_TANIM = '';     
        req.IV_VKORG = '';
        req.IV_VTWEG = '';
        req.IV_PACKAGE = '';
        req.IV_INDEX = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriIntegrator.getAnaVeri(req);
        
        Test.stopTest();
    }
}