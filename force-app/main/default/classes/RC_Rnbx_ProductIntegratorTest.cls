@isTest
public class RC_Rnbx_ProductIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        Test.setMock(HttpCalloutMock.class, new RC_Rnbx_ProductIntegratorMock());
        
        Test.startTest();
        
        RC_Rnbx_ProductIntegrator.responseModel resp =  RC_Rnbx_ProductIntegrator.getProduct('123');
        
        Test.stopTest();
    }
}