@isTest(SeeAllData=false)
private class RC_BillingIntegratorSchedulableTest {
    @testSetup static void prepareData(){
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        
        insert testAccount;
        
        Order testOrder2 = new Order(
            RC_Order_No__c = '0340303731',
            AccountId = testAccount.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        
        insert testOrder2;
        
        RC_Delivery_And_Billing__c testDAB = new RC_Delivery_And_Billing__c(
            Name = '0340303730',
            RC_Delivery_ExternalID__c = '0340303730' + '-' + '000020'
        );
        
        insert testDAB;
        
    }
    
    static testmethod void testScheduledJob() {
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new RC_BillingIntegratorMock());
        
        RC_BillingIntegratorSchedulable sch = new RC_BillingIntegratorSchedulable();
        sch.execute(null);
        
        
        Test.stopTest();
    }
    
    static testmethod void testScheduledJobWithSetting() {
        RC_SchedulableSettings__c testSetting = new RC_SchedulableSettings__c(
            Name = 'Billing Schedulable Settings',
            RC_Job_Run_Date__c = Date.today(),
            RC_IsRunnable__c = true,
            RC_Begin_Day__c ='01.07.2021'
        );
        
        insert testSetting;
        
        RC_Migration_Values__c cs1 = new RC_Migration_Values__c();
        cs1.Name='Billing Migration Values';
        cs1.RC_Begin_Time__c = date.today();
        cs1.RC_End_Time__c = date.today();
        cs1.RC_Is_Runnable__c = true;
        //cs.Other fiels values
        insert cs1;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new RC_BillingIntegratorMock());
        
        RC_BillingIntegratorSchedulable sch = new RC_BillingIntegratorSchedulable();
        sch.execute(null);
        
        
        Test.stopTest();
    }
}