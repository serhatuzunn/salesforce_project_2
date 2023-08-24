@isTest
public class RC_CreateBarcodeControllerTest {
    @isTest
    public static void unitTest(){
        String selectedHierarchy='01';
        String selectedHierarchy2='0102';
        String selectedHierarchy3='010203';
        String productCode ='20262918';
        
        String addedProducts ='[{"ProductCode":"20262918","Name":"VF KM 7010"}]';
        Product2 product = new Product2();
        product.ProductCode=productCode;
        product.Name='VF KM 7010';
        product.Description='VF KM 7010';
        product.RC_Product_hiy_Level_1__c=selectedHierarchy;
        product.RC_Product_hiy_Level_2__c=selectedHierarchy2;
        product.RC_Product_hiy_Level_3__c=selectedHierarchy3;
        insert product;        
        
        Test.startTest(); 
        
        RC_CreateBarcodeController.fillHierarchy();
        RC_CreateBarcodeController.fillHierarchy2(selectedHierarchy);
        RC_CreateBarcodeController.fillHierarchy3(selectedHierarchy2);
        RC_CreateBarcodeController.getProducts(selectedHierarchy,selectedHierarchy2,selectedHierarchy3,productCode);
        RC_CreateBarcodeController.createBarcodePDF(addedProducts,false);        
        
        Test.stopTest();
    }
}