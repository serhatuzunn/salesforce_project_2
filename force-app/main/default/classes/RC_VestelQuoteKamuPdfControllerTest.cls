@isTest
public class RC_VestelQuoteKamuPdfControllerTest {
    
    static testMethod void unitTest(){
        test.startTest();
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        
        //Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User testUser = new User();
        testUser.LastName = 'test';
        testUser.Username = 'testemail132@email.com';
        testUser.Email = 'testemail132@email.com';
        testUser.Alias='testuser';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.ProfileId = '00e4K000001Rxv6QAC';
        testUser.LanguageLocaleKey = 'en_US';
        insert testUser;
        
        Contact cnt = new Contact();
        cnt.LastName = 'test';
        cnt.AccountId = acc.id;
        insert cnt;
        
    
        
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
        
        /*Opportunity singleOpp = [Select Id from Opportunity WHERE AccountId = :acc.id];*/
        
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
        testQuote.OwnerId = testUser.id;
        testQuote.OpportunityId = opp.id;
        insert testQuote;
        
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = testQuote.id;
        qli.Quantity=1;
        qli.Product2Id = p2.id;
        qli.PricebookEntryId = standardPrice.id;
        qli.UnitPrice = 1500;
        insert qli;
        
        
        ApexPages.StandardController testSC  = new ApexPages.StandardController(testQuote);
        RC_VestelQuoteKamuPdfController pdf = new RC_VestelQuoteKamuPdfController(testSC);
        
        PageReference testPage = pdf.savePdf();
        
        test.stopTest();
    }
    
}