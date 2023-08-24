@isTest
public class RC_ProductListIntegratorTest {
    @isTest
    public static void UnitTest(){

        Test.setMock(HttpCalloutMock.class, new RC_ProductListIntegratorMock());
        
        Test.startTest();
        
        RC_ProductListIntegrator.responseModel resp = RC_ProductListIntegrator.getProductList('1', '1');
        
        Test.stopTest();
    }
}