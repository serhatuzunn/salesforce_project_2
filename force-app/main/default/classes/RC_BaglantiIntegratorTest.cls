@isTest
public class RC_BaglantiIntegratorTest {
	@isTest
    public static void UnitTest(){
        
        RC_BaglantiIntegrator.requestModel req = new RC_BaglantiIntegrator.requestModel();
        
        req.IV_BUKRS = '';
        req.IV_KKBER = '';
        req.IV_KUNNR = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_CreditRiskIntegratorMock());
        
        Test.startTest();
        
       RC_BaglantiIntegrator.getBaglanti(req);

        
        Test.stopTest();
    }
}