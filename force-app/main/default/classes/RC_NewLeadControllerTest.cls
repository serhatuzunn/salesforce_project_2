@isTest
public class RC_NewLeadControllerTest {

    @istest public static void unitTest()
    {
        string id = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Draft').getRecordTypeId();
        RC_NewLeadController.getRecordTypeIdByDeveloperName(id);
        RC_NewLeadController.getRecordTypes();
    }
}