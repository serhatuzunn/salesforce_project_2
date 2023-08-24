@isTest(SeeAllData=true)
public class RC_BI_CiroReportsControllerTest {
    @isTest static void unitTest(){
        
        
        
        Account acc = new Account();
        acc.Name='test';
        acc.RC_SAP_ID__c='2000000496';
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new RC_BI_CiroReportsMock());
        test.startTest();
        
        RC_BI_CiroReportsController.initialize(acc.id);
        RC_BI_CiroReportsController.initialize(null);
        test.stopTest();
        
    }
}