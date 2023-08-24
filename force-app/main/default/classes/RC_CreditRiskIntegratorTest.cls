@isTest
public class RC_CreditRiskIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_CreditRiskIntegrator.requestModel req = new RC_CreditRiskIntegrator.requestModel();
        
        req.IV_BUKRS = '';
        req.IV_KKBER = '';
        req.IV_KUNNR = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_CreditRiskIntegratorMock());
        
        Test.startTest();
        
        RC_CreditRiskIntegrator.responseModel resp =  RC_CreditRiskIntegrator.getCreditRiskReport(req);
        RC_CreditRiskIntegrator.responseModel respCatch =  RC_CreditRiskIntegrator.getCreditRiskReport(null);
        
        Test.stopTest();
    }
}