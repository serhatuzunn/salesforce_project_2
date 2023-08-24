@isTest
public class RC_SubeDevirBatchableTest {
    @isTest 
    static void test() {
        
        Account acc = new Account();
        acc.Name = 'Test';
        
       MYS_Open_Request__c mysOpenRequest = new MYS_Open_Request__c();
       mysOpenRequest.RC_Account__c = acc.Id;
     
        
        Test.setMock(HttpCalloutMock.class, new RC_SubeYaratIntegratorMock());
        
        Test.startTest();
        
        

        RC_SubeDevirBatchable sBatch = new RC_SubeDevirBatchable(mysOpenRequest);
        DataBase.executeBatch(sBatch); 
        
        Test.stopTest();
    }
}