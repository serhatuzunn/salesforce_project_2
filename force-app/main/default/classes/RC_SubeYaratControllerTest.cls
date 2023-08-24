@isTest
public class RC_SubeYaratControllerTest {
    
    @istest 
    public static void unitTest()
    {   
        Id idAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
        system.debug('idAccount : ' + idAccount);
        
        Account acc = new Account();
        acc.Name='test';
        acc.RC_SAP_ID__c='2000000496';
        acc.RecordTypeId = idAccount;
        insert acc;
        
        Id idLead = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Dealer_Branch').getRecordTypeId();
        system.debug('idLead : ' + idLead);
        
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.Company = 'test';
        lead.MobilePhone = '05051234567';
        lead.Email = 'test_subeyarat@test.com';
        lead.RecordTypeId = idLead;
        insert lead;
        
        Id idMys = Schema.SObjectType.MYS_Open_Request__c.getRecordTypeInfosByDeveloperName().get('Dealer_Branch').getRecordTypeId();
        system.debug('idMys : ' + idMys);
        
        
        MYS_Open_Request__c myOpenRequest = new MYS_Open_Request__c();
        myOpenRequest.RecordTypeId = idMys;
        myOpenRequest.RC_Company__c = '12345';
        myOpenRequest.RC_Last_Name__c = 'test';
        myOpenRequest.RC_Dealer__c = acc.Id;
        myOpenRequest.Lead__c = lead.Id;
        insert myOpenRequest;   

        
        RC_SD_Organization__c organization = new RC_SD_Organization__c();
        organization.RC_Sales_Organization__c = '2201';
        organization.RC_Account__c = acc.Id;
        insert organization;
        
        
        Test.setMock(HttpCalloutMock.class, new RC_SubeYaratIntegratorMock());
        
        
        Test.startTest();
        
        List<MYS_Open_Request__c> mList = [SELECT Id, Lead__c FROM MYS_Open_Request__c WHERE Id =: myOpenRequest.Id];
        system.debug('mList : ' + mList.get(0));
        
        RC_SubeYaratController.initialize(mList.get(0).Lead__c);
        
        Test.stopTest();
        
        
    }
}