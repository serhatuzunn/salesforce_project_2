@isTest
public class RC_BankaTeminatIntegratorTest {
    @isTest
    public static void getBankaTeminatTest(){  
        
        RC_BankaTeminatIntegrator.RequestModel req = new RC_BankaTeminatIntegrator.RequestModel();
        req.IV_BUKRS = '';
        req.IV_DAYS = '';
        req.IV_INDEX = '';
        req.IV_KKBER = '';
        req.IV_KUNNR = '';
        req.IV_PACKAGE = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_BankaTeminatIntegratorMock());
        
      	Test.startTest();
        
		RC_BankaTeminatIntegrator.ResponseModel responseModel = RC_BankaTeminatIntegrator.getBankaTeminat(req);
                    
		Test.stopTest();
     }
}