@isTest
public class RC_SelectPricebookControllerTest {
    @isTest
    public static void unitTest1(){
        Account acc = new Account();
        acc.Name='test';
        acc.RC_SAP_ID__c='2000000496';
        insert acc;
        
        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = acc.id;
        testOpp.Name = 'Test Opp';
        testOpp.StageName = 'Qualification';
        testOpp.CloseDate = System.Date.today();
        insert testOpp;
        
        RC_SelectPricebookController.updateOPP(Test.getStandardPricebookId(),testOpp.id);

    }
}