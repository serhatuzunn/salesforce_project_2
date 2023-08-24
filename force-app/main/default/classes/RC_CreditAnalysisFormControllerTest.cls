@isTest
public class RC_CreditAnalysisFormControllerTest {
    
    @istest 
    public static void unitTest()
    {   
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.RC_SAP_ID__c = '123';
        insert acc;
        
        RC_Credit_Analysis_Form__c form = new RC_Credit_Analysis_Form__c();
        form.RC_Account__c = acc.Id;
        insert form;
        
        Test.setMock(HttpCalloutMock.class, new RC_CreditRiskIntegratorMock());
        
        Test.startTest();
        
        RC_CreditAnalysisFormController.initialize(form.Id);
        
        Test.stopTest();
        
    }
}