@isTest
public class RC_MusteriTriggerTest {
    
    static testMethod void unitTest(){
        test.startTest();
        
        Account acc = new Account();
        acc.name = 'test';
        acc.RC_IsDTS__c = true;
        acc.RC_DTS_Bank__c = 'GRN';
        insert acc;
        
        List<Account> accountList = [SELECT Id, Name FROM Account WHERE Id =: acc.Id];
        if(accountList != null && accountList.size() > 0){
            accountList.get(0).RC_IsDTS__c = false;
            update accountList.get(0);
        }
        
        test.stopTest();
    }
    
}