@isTest
public class RC_DocFlowComponentControllerTest {
    @isTest
    public static void unitTest(){
        
        Account acc = new Account();
        acc.Name='test';
        acc.RC_SAP_ID__c='2000000496';
        insert acc;
        
        Order order = new Order();
        order.AccountId = acc.id;
        order.Status = 'YS';
        order.EffectiveDate = Date.newInstance(2021, 03, 23);
        order.RC_Order_No__c = '0010318803';
        insert order;
        
        Test.setMock(HttpCalloutMock.class, new RC_DocFlowMock());

        Test.startTest();
        
        RC_DocFlowComponentController.initialize(order.id);
      
        Test.stopTest();  
        
    }
}