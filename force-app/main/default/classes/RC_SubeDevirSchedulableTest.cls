@isTest(SeeAllData=false)
private class RC_SubeDevirSchedulableTest {
    static testmethod void testScheduledJob() {
        
        Account account = new Account();
        account.Name = 'Test';
        account.RC_Sub_Type__c = 'Şube';
        insert account;
        
        Account account2 = new Account();
        account2.Name = 'Test';
        account2.RC_Sub_Type__c = 'Şube';
        insert account2;
        
        
        RC_SD_Organization__c oldScOrganization = new RC_SD_Organization__c();
        oldScOrganization.RC_Account__c = account2.Id;
        insert oldScOrganization;
        
        MYS_Open_Request__c mysOpenRequest = new MYS_Open_Request__c();
        mysOpenRequest.MYS_Status__c = 'Waiting SAP';
        mysOpenRequest.RC_Changing_Type__c = 'Code Change';
        mysOpenRequest.RC_Account__c = account.Id;
        mysOpenRequest.RC_New_Name__c = 'test';
        insert mysOpenRequest;
        
        RC_SD_Organization__c sdOragnization = new RC_SD_Organization__c();
        sdOragnization.RC_Account__c = mysOpenRequest.RC_Account__c;
        insert sdOragnization;
        
        Test.setMock(HttpCalloutMock.class, new RC_SubeSilIntegratorMock());
        
        Test.startTest();
        
        RC_SubeDevirSchedulable sch = new RC_SubeDevirSchedulable();
        sch.execute(null);
        
        
        Test.stopTest();
    }
}