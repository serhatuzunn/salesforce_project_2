@isTest
public class RC_DealerTagPrintControllerTest {
    @isTest
    public static void unitTest(){                
        string tagTypeValue = '010102-010103-010705-010101';
        string tagTypeLabel = 'BEYAZ EŞYA DİKEY';
        
        String tagType='010102-010103-010705-010101'; 
        string productGroupe='010101';
        string productCodeName='20216126';
        
        String updateLabels = '{RC_Price_Update_Date__c=2021-10-19 00:00:00, RC_Price__c=2000.0, Id=a0w3M000000MpiNQAS}';
        
        
        string tagPriceType='Installment';
        
        
        RC_Definition__c definition = new RC_Definition__c();
        definition.RC_Product_Group__c = '010102-010103-010705-010101';
        definition.RC_Label_Type__c = 'BEYAZ EŞYA DİKEY';
        definition.RC_Standart_Label_PDF__c = 'Multi_Ticket_Buzdolabi.pdf';
        definition.RC_Special_Price_Label_PDF__c = 'Multi_Ticket_Buzdolabi_Special.pdf';
        definition.RC_Stamped_Label_PDF__c = 'Multi_Ticket_Buzdolabi_senet.pdf';
        definition.RC_Installment_Label_PDF__c = 'Multi_Etiket_Buzdolabi_Dikey_Senet_Yeni.pdf';
        definition.RC_Count__c = 3;        
        insert definition; 
        
        definition = new RC_Definition__c();
        definition.Name = '010101-Derin Dondurucu';
        definition.RC_Value__c = '010101';
        insert definition; 
        
        definition = new RC_Definition__c();
        definition.Name = '010102-Solo Buzdolabı';
        definition.RC_Value__c = '010102';
        insert definition; 
        
        definition = new RC_Definition__c();
        definition.Name = '010103-Ankastre Buzdolabı';
        definition.RC_Value__c = '010103';
        insert definition;
        
        
        Product2 product = new Product2();
        product.ProductCode='20216126';
        product.Name='SDF 2450 A+ DERİN DONDURUCU';
        product.Description='SDF 2450 A+ DERİN DONDURUCU';
        insert product;
        
        RC_Label__c lbl = new RC_Label__c (); 
        lbl.RC_Header__c='SDF 2450 A+ DERİN DONDURUCU';
        lbl.RC_Description__c='SDF 2450 A+ DERİN DONDURUCU';
        lbl.RC_Manufacture_Place__c='Türkiye';
        lbl.RC_Price_Update_Date__c= system.today();
        lbl.RC_Price__c=1333;
        lbl.RC_Terminated_Amount__c= 0;
        lbl.RC_Bill_Amount_1__c='';
        lbl.RC_Bill_Amount_2__c='';
        lbl.RC_Bill_Amount_3__c='';
        lbl.RC_Installment_Amount_1__c='1';
        lbl.RC_Installment_Amount_2__c='2';
        lbl.RC_Installment_Amount_3__c='3';
        lbl.RC_LabelType__c='';        
        insert lbl;
        
        string labelIds ='[\"'+lbl.Id+'\"]';
        
        Test.startTest();        
        
        RC_DealerTagPrintController.productGroupeRecords(tagTypeValue, tagTypeLabel);
        RC_DealerTagPrintController.fetchProductRecords(tagType, productGroupe, productCodeName);
        RC_DealerTagPrintController.updateLabels(updateLabels);
        RC_DealerTagPrintController.previewSelectedProduct(tagType, tagTypeLabel, tagPriceType, labelIds);
        
        Test.stopTest();
    }
}