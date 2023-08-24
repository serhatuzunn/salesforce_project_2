@isTest
public class RC_CategoryListIntegratorTest {
    @isTest
    public static void UnitTest(){

        Test.setMock(HttpCalloutMock.class, new RC_CategoryListIntegratorMock());
        
        Test.startTest();
        
        RC_CategoryListIntegrator.responseModel resp = RC_CategoryListIntegrator.getCategoryList();
        
        Test.stopTest();
    }
}