@isTest
public class RC_AnaVeriProductBatchableTest {
    @isTest 
    static void test() {
        
        RC_Definition__c defHy1 = new RC_Definition__c();
        defHy1.Type__c = 'Product Hierarchy';
        defHy1.RC_Hierarchy_Level__c = 1;
        defHy1.Name = 'test';
        defHy1.RC_Value__c = '01';
        insert defHy1;
        
        RC_Definition__c defHy2 = new RC_Definition__c();
        defHy2.Type__c = 'Product Hierarchy';
        defHy2.RC_Hierarchy_Level__c = 2;
        defHy2.Name = 'test';
        defHy2.RC_Value__c = '0103';
        insert defHy2;
        
        RC_Definition__c defHy3 = new RC_Definition__c();
        defHy3.Type__c = 'Product Hierarchy';
        defHy3.RC_Hierarchy_Level__c = 3;
        defHy3.Name = 'test';
        defHy3.RC_Value__c = '010302';
        insert defHy3;
        
        RC_Definition__c defHy4 = new RC_Definition__c();
        defHy4.Type__c = 'Product Hierarchy';
        defHy4.RC_Hierarchy_Level__c = 4;
        defHy4.Name = 'test';
        defHy4.RC_Value__c = '01020105';
        insert defHy4;
        
        RC_Definition__c defHy5 = new RC_Definition__c();
        defHy5.Type__c = 'Product Hierarchy';
        defHy5.RC_Hierarchy_Level__c = 5;
        defHy5.Name = 'test';
        defHy5.RC_Value__c = '0102010506';
        insert defHy5;
        
        RC_Definition__c defHy6 = new RC_Definition__c();
        defHy6.Type__c = 'Product Hierarchy';
        defHy6.RC_Hierarchy_Level__c = 6;
        defHy6.Name = 'test';
        defHy6.RC_Value__c = '010201050601';
        insert defHy6;
        
        RC_Definition__c defHy7 = new RC_Definition__c();
        defHy7.Type__c = 'Product Hierarchy';
        defHy7.RC_Hierarchy_Level__c = 7;
        defHy7.Name = 'test';
        defHy7.RC_Value__c = '01020105060101';
        insert defHy7;
        
        RC_Definition__c defHy8 = new RC_Definition__c();
        defHy8.Type__c = 'Product Hierarchy';
        defHy8.RC_Hierarchy_Level__c = 8;
        defHy8.Name = 'test';
        defHy8.RC_Value__c = '0102010506010102';
        insert defHy8;
        
        RC_Definition__c defHy9 = new RC_Definition__c();
        defHy9.Type__c = 'Product Hierarchy';
        defHy9.RC_Hierarchy_Level__c = 9;
        defHy9.Name = 'test';
        defHy9.RC_Value__c = '010201050601010201';
        insert defHy9;

        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriIntegrator.RequestModel req = new RC_AnaVeriIntegrator.RequestModel();
        req.IV_TANIM   = '';
        req.IV_VKORG   = '2201';
        req.IV_VTWEG   = '01';
        req.IV_INDEX   = '0';
        req.IV_PACKAGE = '1000'; 
        
        RC_AnaVeriProductBatchable obj = new RC_AnaVeriProductBatchable(req);
        DataBase.executeBatch(obj, integer.valueOf(req.IV_PACKAGE)); 
        
        Test.stopTest();
    }
}