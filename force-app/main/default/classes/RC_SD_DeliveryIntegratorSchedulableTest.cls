@isTest(SeeAllData=false)
private class RC_SD_DeliveryIntegratorSchedulableTest {
    @testSetup static void prepareData(){
        Product2 testProduct = new Product2(
        	Name = 'Test Product',
            RC_Unit_Test__c = true
        );
        
        insert testProduct;
        
        PriceBookEntry testPricebookEntry = new PriceBookEntry(
            Product2Id = testProduct.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            UnitPrice = 2000,
            IsActive = true
        );
        
        insert testPricebookEntry;
        
        Account testAccount = new Account(
            Name = '000010',
            Type = 'Test'
        );
        
        insert testAccount;
        
        Order testOrder = new Order(
            RC_Order_No__c = '0010298965',
            AccountId = testAccount.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId()
        );
        
        insert testOrder;
        
        OrderItem testOrderItem = new OrderItem(
        	OrderId = testOrder.Id,
            PricebookEntryId = testPricebookEntry.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            Quantity = 10,
            RC_Order_Product_No__c = '000010'
        );
        
        insert testOrderItem;
        
        RC_Delivery_And_Billing__c testDAB = new RC_Delivery_And_Billing__c(
            Name = '0010298965'
        );
        
        insert testDAB;
        
        RC_Migration_Values__c cs1 = new RC_Migration_Values__c();
        cs1.Name='Delivery Migration Values';
        cs1.RC_Begin_Time__c = date.today();
        cs1.RC_End_Time__c = date.today();
        cs1.RC_Is_Runnable__c = true;
        //cs.Other fiels values
        insert cs1;
    }
    
    static testmethod void testScheduledJob() {
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new RC_BillingIntegratorMock());
    
        RC_SD_DeliveryIntegratorSchedulable sch = new RC_SD_DeliveryIntegratorSchedulable();
        sch.execute(null);
            
        Test.stopTest();
    }
    
    static testmethod void testScheduledJobWithSetting() {
        RC_SchedulableSettings__c testSetting = new RC_SchedulableSettings__c(
        	Name = 'SD Delivery Schedulable Settings',
            RC_Job_Run_Date__c = Date.today(),
            RC_IsRunnable__c = true,
            RC_Begin_Day__c ='01.07.2021'
        );
        
        insert testSetting;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new RC_BillingIntegratorMock());
       
        RC_SD_DeliveryIntegratorSchedulable sch = new RC_SD_DeliveryIntegratorSchedulable();
        sch.execute(null);
        
        
        Test.stopTest();
    }
}