@isTest
public class RC_GetEmanetStockComponentControllerTest {
    @isTest
    public static void unitTest(){
        
        string IT_MATNR = '20262272';
        string IV_KUNNR = '22201759';
        string VKBUR = ''	;
        string VKGRP = ''	;
        string VKORG = '' 	;
        string VTWEG = ''	;
        
         String[] IT_WERKS = new List<String>(1);
         string WERKS = '9205';
        IT_WERKS.add('9205');
        
         String[] IT_MATNR2 = new List<String>(1);
        IT_MATNR2.add('20262272');
        
        String[] IV_KUNNR2 = new List<String>(1);
        IV_KUNNR2.add('22201759');
        
        String[] VKBUR2 = new List<String>(1);
    
        String[] VKGRP2 = new List<String>(1);
        
        
        String[] VKORG2 = new List<String>(1);
       
        
        String[] VTWEG2 = new List<String>(1);
    	String[] WERKS2 = new List<String>(1);
        
     
        
        RC_Definition__c definition = new RC_Definition__c();
        definition.Name = 'test';
        definition.Type__c = 'Production Place';
        insert definition;
            
        Test.setMock(HttpCalloutMock.class, new RC_EmanetStokMock());
        
        Test.startTest();

        RC_GetEmanetStockComponentController.initialize();
        RC_GetEmanetStockComponentController.getProductionPlace();
        RC_GetEmanetStockComponentController.buttonClick(IT_MATNR, IV_KUNNR,IT_WERKS);
   	    RC_GetEmanetStockComponentController.OpenStockButtonClick(IT_MATNR, IV_KUNNR,WERKS,VKBUR2,VKGRP2,VKORG2,VTWEG2);
        

        RC_GetEmanetStockComponentController.CreateVariant(IT_MATNR2,IV_KUNNR2,WERKS2,VKBUR2,VKGRP2,VKORG2,VTWEG2,'Test Variant');
        RC_GetEmanetStockComponentController.GetVariantList();
        
        RC_Stock_Variant__c variant = [Select Id From RC_Stock_Variant__c LIMIT 1];
        RC_GetEmanetStockComponentController.GetVariantItem(variant.Id);
        RC_GetEmanetStockComponentController.DeleteVariantItem(variant.Id);
        
        
        Test.stopTest();   
    }
}