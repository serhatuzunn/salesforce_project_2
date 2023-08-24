@isTest
public class RC_PortfoyCeklerIntegratorTest {
    @isTest
    public static void getBayiCekSenetTest(){  
        
        RC_PortfoyCeklerIntegrator.RequestModel req = new RC_PortfoyCeklerIntegrator.RequestModel();
        req.IV_BUKRS = '';
        req.IV_INDEX = '';
        req.IV_KKBER = '';
        req.IV_KUNNR = '';
        req.IV_PACKAGE = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_PortfoyCeklerIntegratorMock());
        
      	Test.startTest();
        
		RC_PortfoyCeklerIntegrator.ResponseModel responseModel = RC_PortfoyCeklerIntegrator.getPortfoyCekler(req);
                    
		Test.stopTest();
     }
}