public class RC_CiroReportsController {

    @AuraEnabled
    public static Account initialize(string recordId)
    {
        Account acc= [SELECT Id,RC_SAP_ID__c FROM Account Where Id=:recordId LIMIT 1];
        return acc;
    }
}