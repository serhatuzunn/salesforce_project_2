@isTest(SeeAllData=false)
public class RC_DealerPaymentDeleteSchedulableTest {
    static testmethod void testScheduledJob() {
        
        RC_Dealer_Payment__c d = new RC_Dealer_Payment__c();
        d.RC_Date__c = Date.newInstance(1960, 2, 17);
        insert d;
        
        Test.startTest();
        
        RC_DealerPaymentDeleteSchedulable sch1 = new RC_DealerPaymentDeleteSchedulable();
        sch1.execute(null);
        
        Test.stopTest();
    }
}