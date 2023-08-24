@isTest
public class RC_GetCustomerOrdersIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_GetCustomerOrdersIntegrator.requestModel req = new RC_GetCustomerOrdersIntegrator.requestModel();
        req.IV_CUSTOMER='20302010';
        req.IV_DISTRCHL='01';
        req.IV_DIVISION='21';
        req.IV_REPRESENT='1';
        req.IV_SALESORG='2201'; 
        
        Test.setMock(HttpCalloutMock.class, new RC_GetCustomerOrdersIntegratorMock());
        
        Test.startTest();
        
        RC_GetCustomerOrdersIntegrator.getMailOrderCustomerOrders(req);
        
        Test.stopTest();
    }
}