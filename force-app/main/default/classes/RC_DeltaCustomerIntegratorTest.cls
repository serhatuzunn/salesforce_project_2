@isTest
public class RC_DeltaCustomerIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_DeltaCustomerIntegrator.requestModel req = new RC_DeltaCustomerIntegrator.requestModel();
        req.IV_YARAT_TRH = '';     
        req.IV_TANIM = '';
        req.IV_DEGIS_TRH = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_DeltaCustomerIntegratorMock());
        
        Test.startTest();
        
        RC_DeltaCustomerIntegrator.getDeltaCustomer(req);
        
        Test.stopTest();
    }
}