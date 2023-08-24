@isTest
public class RC_PdfPrintOptionsControllerTest {
		
	static boolean sonuc = false;    
    static testMethod void unitTest(){
         
            
        test.startTest();
         
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        
        Product2 p2 = new Product2();
        p2.Name = 'test ürün';
        p2.IsActive = true;
        p2.ProductCode = '123123';
        insert p2;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = p2.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        string selectedPdf = 'RV_VestelQuoteKamuPdf';
        string selectedPdf2 = 'RC_NonVestelQuotePdf';
        string selectedPdf3 = 'RC_VestelQuotePdf';
        
        Opportunity opp = new Opportunity();
        opp.name = 'testOpp';
        opp.StageName = 'test';
        opp.CloseDate = date.today();
        opp.AccountId = acc.id;
        opp.Pricebook2Id = standardPrice.Pricebook2Id;
        insert opp;
        
        OpportunityLineItem lineItem1 = new OpportunityLineItem();
        lineItem1.OpportunityID=opp.id;
        lineItem1.PricebookEntryId=standardPrice.Id; 
        lineItem1.quantity=4;
        lineItem1.totalprice=200;
		insert lineItem1;
        
        
        Quote testQuote = new Quote();
        testQuote.Name = 'test';
        testQuote.Delivery_time__c = 'Gün';
        testQuote.RC_Delivery_time__c = 3;
        testQuote.RC_Warranty_Period__c = '3';
        testQuote.RC_Term__c = '30 Gün';
        testQuote.OpportunityId = opp.id;

        insert testQuote;
        
        ApexPages.StandardController testSC  = new ApexPages.StandardController(testQuote);
        
        /* save PDF */
       sonuc = RC_PdfPrintOptionsController.savePdf(testSC.getId(),selectedPdf,'TR');
       system.debug('pdf :' + sonuc);
        sonuc = RC_PdfPrintOptionsController.savePdf(testSC.getId(),selectedPdf2,'TR');
       system.debug('pdf 2 :' + sonuc);
        sonuc = RC_PdfPrintOptionsController.savePdf(testSC.getId(),selectedPdf3,'TR');
       system.debug('pdf 3 :' + sonuc);
  
       /* getCanalDataControl */
        RC_PdfPrintOptionsController.ResponseWrapper resw = new RC_PdfPrintOptionsController.ResponseWrapper();  
        resw =  RC_PdfPrintOptionsController.getCanalDataControl(testSC.getId());

        /* getCanalData */
        RC_PdfPrintOptionsController.initWrapper inw = new RC_PdfPrintOptionsController.initWrapper();  
        inw =  RC_PdfPrintOptionsController.getCanalData(testSC.getId()); 

       /* initialize */ 
        RC_PdfPrintOptionsController.initWrapper inw2 = new RC_PdfPrintOptionsController.initWrapper();  
        inw2 = RC_PdfPrintOptionsController.initialize(testSC.getId());
        
        
        test.stopTest();
       
        system.debug('pdf :' + sonuc);
        system.debug('getCanalDataControl:' + resw);
        system.debug('getCanalData:' + inw); 
        system.debug('initialize:' + inw2); 
            
        }    
}