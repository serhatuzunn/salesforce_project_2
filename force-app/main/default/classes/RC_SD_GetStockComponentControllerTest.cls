@isTest
public class RC_SD_GetStockComponentControllerTest {
    @isTest
    public static void unitTest(){
        
        RC_Definition__c definition = new RC_Definition__c();
        definition.Name = 'test';
        definition.Type__c = 'Production Place';
        insert definition;
        
        
        RC_Definition__c definition2 = new RC_Definition__c();
        definition2.Name = 'test 2';
        definition2.Type__c = 'Warehouse Place';
        insert definition2;
        
        List<RC_Definition__c> definition3 = new List<RC_Definition__c>();
        definition3 = RC_SD_GetStockComponentController.getProductionPlace();
      
        List<String> definition4 = new List<String>();
		definition4.add('20210073');

        String[] uretimYeri = new List<String>(1);
        uretimYeri.add('2201');
         String[] depoYeri = new List<String>(1);
        depoYeri.add('2201|0001');
        String[] urunKodu = new List<String>(1);
        urunKodu.add('20210073');
        String[] marka = new List<String>(1);
        marka.add('VST');
        String[] malGrubu = new List<String>(1);
        malGrubu.add('202301011');
        
            
        Test.setMock(HttpCalloutMock.class, new RC_SD_GetStockIntegratorMock());
        
        Test.startTest();

        RC_SD_GetStockComponentController.initialize(definition4);
        RC_SD_GetStockComponentController.buttonClick(uretimYeri, depoYeri,urunKodu,marka,malGrubu);
   		RC_SD_GetStockComponentController.materialInfo('20210073');
        RC_SD_GetStockComponentController.CreateVariant(uretimYeri, depoYeri, urunKodu, marka, malGrubu, 'Test Variant');
        RC_SD_GetStockComponentController.GetVariantList();
        RC_SD_GetStockComponentController.getSlidingAverageRole();
        
        RC_Stock_Variant__c variant = [Select Id From RC_Stock_Variant__c LIMIT 1];
        RC_SD_GetStockComponentController.GetVariantItem(variant.Id);
        RC_SD_GetStockComponentController.DeleteVariantItem(variant.Id);
        
        
        Test.stopTest();   
    }
}