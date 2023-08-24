@isTest
public class RC_MailOrderDefineControllerTest {    
    @isTest
    public static void unitTest(){
        
        Account acc = new Account();
        acc.Name='ADALILAR DAYANIKLI TÜKETİM MAL SANAYİ VE TİCARET LİMİTED ŞİRK';
        acc.RC_Account_Type__c = 'Test';
        acc.RC_SAP_ID__c='20300066';
        acc.RC_Mobile__c='5530515353';
        acc.Phone='05530515353';
        acc.RC_email__c='umity@coredet.com';
        acc.RC_Tax_Number__c ='00000000053';
        insert acc;
        
        
        Profile profile1 = [Select Id from Profile LIMIT 1];
        User us = new User();
        us.FirstName = 'TEST';
        us.LastName  = 'YAVUZ';
        us.Email     = 'umity@coredet.com';
        us.LocaleSidKey					= 'en_US';
        us.TimeZoneSidKey 					= 'GMT';
        us.LanguageLocaleKey 				= 'en_US';
        us.EmailEncodingKey 				= 'UTF-8';
        us.Alias = 'testnewu';
        us.userName = 'umity@coredet.com';
        //us.Regional_Directorate__c = '2201';//TODO: RC_Sales_Organization__c icin setlenecek
        us.ProfileId = profile1.Id;
        insert us;
        
        RC_SD_Organization__c SD = new RC_SD_Organization__c();
        SD.RC_Account__c = acc.id;
        SD.RC_Sales_Organization__c = '2201';
        SD.Distribution_Channel__c = '01';
        SD.RC_Sales_Expert__c = us.id;
        insert SD;      
        
        AssecoInformation__c a = new AssecoInformation__c ();
        a.Kanal__c = 'A010001';
        a.AssecoApiMerchFormat__c = 'Zorlu_{0}';
        a.LinkSuresi__c = '24h';
        a.SureId__c = 'MRD_SAT_02';
        a.Name = 'Vestel';
        insert a;
        
        
        String dealerName ='ADALILAR DAYANIKLI TÜKETİM MAL SANAYİ VE TİCARET LİMİTED ŞİRK';
        String site='Vestel'; 
        String returnUrl ='https://vestel--vtsbxqa.lightning.force.com/lightning/n/Mail_Order?c__isAsseco=true'; 
        String orderNo='0021206817';   
        String amount ='53';
        String email='umity@coredet.com';
        
        Test.setMock(HttpCalloutMock.class, new RC_GetCustomerOrdersIntegratorMock());
        
        Test.startTest();        
        
        RC_MailOrderDefineController.getAssecoPaymentLink();
        RC_MailOrderDefineController.GetRequestParameters(acc.Id, site, returnUrl, orderNo, amount, email);
        RC_MailOrderDefineController.getCustomerOrders(dealerName);
        
        Test.stopTest();
    }
}