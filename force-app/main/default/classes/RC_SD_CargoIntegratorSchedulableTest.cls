@isTest(SeeAllData=false)
private class RC_SD_CargoIntegratorSchedulableTest {
    
    static testmethod void testScheduledJob() {
        
        RC_Delivery_and_Billing__c deliveryAndBilling = new RC_Delivery_and_Billing__c();
        deliveryAndBilling.RC_Delivery_Status__c = 'Kurye Dağıtımda';
        deliveryAndBilling.RC_Invoice_Date__c = Date.today().addDays(-1);
        deliveryAndBilling.Name = '0318482833';
        deliveryAndBilling.RC_TM_Delivery__c = true;
        deliveryAndBilling.RC_Delivery_Date__c = date.newInstance(2021,07,01);
        insert deliveryAndBilling;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new RC_SD_CargoIntegratorMock());
        
                
        
        RC_SD_CargoIntegrator.RequestModel req = new RC_SD_CargoIntegrator.RequestModel();
        RC_SD_CargoIntegrator.getTMCodeCargo(req);
        
        RC_SD_CargoIntegratorSchedulable sch = new RC_SD_CargoIntegratorSchedulable();
        sch.execute(null);

        
        Test.stopTest();
    }
    
    static testmethod void testScheduledJob2() {
        
        RC_Delivery_and_Billing__c deliveryAndBilling = new RC_Delivery_and_Billing__c();
        deliveryAndBilling.RC_Delivery_Status__c = 'Kurye Dağıtımda';
        deliveryAndBilling.RC_Invoice_Date__c = Date.today().addDays(-1);
        deliveryAndBilling.Name = '0318482833';
        deliveryAndBilling.RC_TM_Delivery__c = true;
        deliveryAndBilling.RC_Delivery_Date__c = date.newInstance(2021,07,01);
        insert deliveryAndBilling;
        
        RC_SchedulableSettings__c sc = new RC_SchedulableSettings__c();
        sc.Name = 'SD Delivery Schedulable Settings';
        sc.RC_IsRunnable__c = true;
        sc.RC_Job_Run_Date__c = date.newInstance(2021,07,01);
        insert sc;
        
        
        RC_Migration_Values__c cs1 = new RC_Migration_Values__c();
        cs1.Name='TM Migration Values';
        cs1.RC_Begin_Time__c = DateTime.newInstance(2021, 3, 16, 7, 8 , 16);
        cs1.RC_End_Time__c = date.today();
        cs1.RC_Is_Runnable__c = true;
        insert cs1;
                                          
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new RC_SD_CargoIntegratorMock());
        

        RC_SD_CargoIntegratorSchedulable sch = new RC_SD_CargoIntegratorSchedulable();
        sch.execute(null);

  
        
        Test.stopTest();
    }
    
    
}