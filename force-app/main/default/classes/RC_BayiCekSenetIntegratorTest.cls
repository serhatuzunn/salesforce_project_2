@isTest
public class RC_BayiCekSenetIntegratorTest {
    @isTest
        public static void getBayiCekSenetTest(){
            
            RC_CreditRiskIntegrator.requestModel req = new RC_CreditRiskIntegrator.requestModel();
        
       		req.IV_BUKRS = '';
       		req.IV_KKBER = '';
        	req.IV_KUNNR = '';
            
            Test.setMock(HttpCalloutMock.class, new RC_BayiCekSenetMock());
        
        	Test.startTest();

            RC_BayiCekSenetIntegrator.getBayiCekSenet(req);
            
            Test.stopTest();     
             
        }
}