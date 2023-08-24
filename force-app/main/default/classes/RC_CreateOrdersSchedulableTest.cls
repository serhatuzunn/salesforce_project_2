@isTest(SeeAllData=false)
private class RC_CreateOrdersSchedulableTest {
    static testmethod void testScheduledJob() {
        
        Date day   = Date.today();
        
        
        RC_SchedulableSettings__c cs = new RC_SchedulableSettings__c();
        cs.Name='SD Orders Schedulable Settings';
        cs.RC_IsRunnable__c = true;
        cs.RC_Begin_Day__c = string.valueOf(Date.today());
        cs.RC_End_Day__c = string.valueOf(Date.today());
        //cs.Other fiels values
        insert cs;
        
        
        Account acc  = new Account();      
        acc.RC_SAP_ID__c = '105198';
        acc.Name  = 'test234';
        acc.OwnerId = userInfo.getUserId();
        acc.RC_Account_Type__c ='Test';
        insert acc;
        
        Account acc1  = new Account();      
        acc1.RC_SAP_ID__c = '22201759';
        acc1.Name  = 'test2345';
        acc1.OwnerId = userInfo.getUserId();
        acc.RC_Account_Type__c ='Test';
        insert acc1;
        
        Account acc2  = new Account();      
        acc2.RC_SAP_ID__c = '20301290';
        acc2.Name  = 'test234';
        acc2.OwnerId = userInfo.getUserId();
        acc.RC_Account_Type__c ='Test';
        insert acc2;
        
        Account acc3  = new Account();      
        acc3.RC_SAP_ID__c = '22200376';
        acc3.Name  = 'test234';
        acc3.OwnerId = userInfo.getUserId();
        acc.RC_Account_Type__c ='Test';
        insert acc3;
        
        Account acc4  = new Account();      
        acc4.RC_SAP_ID__c = '22200088';
        acc4.Name  = 'test234';
        acc4.OwnerId = userInfo.getUserId();
        acc.RC_Account_Type__c ='Test';
        insert acc4;
        
        Product2 pro= new Product2();
        pro.Name='Test Product';
        pro.ProductCode = '20210441';
        Database.insert(pro);
        
        Profile profile1 = [Select Id from Profile LIMIT 1];
        User us = new User();
        us.FirstName = 'testFirst';
        us.LastName  = 'testLast';
        us.Email     = 'testuser@example.org';
        us.LocaleSidKey					= 'en_US';
        us.TimeZoneSidKey 					= 'GMT';
        us.LanguageLocaleKey 				= 'en_US';
        us.EmailEncodingKey 				= 'UTF-8';
        us.Alias = 'testnewu';
        us.userName = 'testusername@example.org';
        us.ProfileId = profile1.Id;
        us.RC_Registiration_No__c = '20210441';
        insert us;
        
        
        User us1 = new User();
        us1.FirstName = 'test1First';
        us1.LastName  = 'test1Last';
        us1.Email     = 'test1user@example.org';
        us1.LocaleSidKey					= 'en_US';
        us1.TimeZoneSidKey 					= 'GMT';
        us1.LanguageLocaleKey 				= 'en_US';
        us1.EmailEncodingKey 				= 'UTF-8';
        us1.Alias = 'tes1newu';
        us1.userName = 'test1username@example.org';
        us1.ProfileId = profile1.Id;
        us1.RC_Registiration_No__c = '22200376';
        insert us1;
        
        /*PricebookEntry priceEntry=new PricebookEntry();
priceEntry.Pricebook2Id= test.getStandardPricebookId();
priceEntry.Product2Id=pro.Id;
priceEntry.CurrencyIsoCode='TRY';
priceEntry.UnitPrice=10;
priceEntry.UseStandardPrice=false;
priceEntry.IsActive=true;
Database.insert(priceEntry);*/
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new RC_CreateOrdersIntegratorMock());
        
        RC_CreateOrdersSchedulable sch1 = new RC_CreateOrdersSchedulable();
        sch1.execute(null);
        
        
        
        RC_Migration_Values__c cs1 = new RC_Migration_Values__c();
        cs1.Name='Order Migration Values';
        cs1.RC_Begin_Time__c = date.today();
        cs1.RC_End_Time__c = date.today();
        cs1.RC_Is_Runnable__c = true;
        //cs.Other fiels values
        insert cs1;
        
        RC_CreateOrdersSchedulable sch2 = new RC_CreateOrdersSchedulable('10.11.2021','10.11.2021','10:00','11:00',null);
        sch2.execute(null);
        
        Test.stopTest();
    }
}