@isTest
public class RC_Rnbx_ProductComponentControllerTest {
    
    @isTest
    public static void unitTest(){
        
        
        
        RC_Rnbx_ProductComponentController.HiyObject hiyObject = new RC_Rnbx_ProductComponentController.HiyObject();
        hiyObject.hiy1 = '01';
        hiyObject.hiy2 = '0101';
        hiyObject.hiy3 = '010101';
        
        
        Test.startTest();
        RC_Rnbx_ProductComponentController.initialize();
        
        RC_Rnbx_ProductComponentController.GetProducts(JSON.serialize(hiyObject));
        Test.stopTest();     
    }
    
    @isTest
    public static void unitTest2(){
        String externalSystemProductId = '1';
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.RC_External_System_ProductID__c = externalSystemProductId;
        insert p;        
        
        
        
        Test.startTest();
        RC_Rnbx_ProductComponentController.GetShareUrl(externalSystemProductId);
        
        Test.stopTest();     
    }
    
    
    
}