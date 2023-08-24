@isTest
public class RC_CreditRiskComponentControllerTest {
    
    @isTest
    public static void unitTest(){
        
        RC_CreditRiskComponentController.initWrapper initWrp = new RC_CreditRiskComponentController.initWrapper();
        RC_CreditRiskComponentController.SelectOptionWrapper sow = new RC_CreditRiskComponentController.SelectOptionWrapper();
             
        Account acc = new Account();
        acc.Name='test';
        acc.RC_SAP_ID__c='20100340';
        insert acc;

        RC_SD_Organization__c SD = new RC_SD_Organization__c();
        SD.RC_Account__c = acc.id;
        SD.RC_Sales_Organization__c = '0001';
        SD.Distribution_Channel__c = '06';
        insert SD;       
        
        Test.setMock(HttpCalloutMock.class, new RC_BayiCekSenetMock());
        
        Test.startTest();

        RC_CreditRiskComponentController.initialize(acc.id);
        RC_CreditRiskComponentController.getCreditRiskReport(acc.id, '06');     
        
        Test.stopTest();     
        

    }
}