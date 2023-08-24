global class RC_DealerPaymentDeleteSchedulable implements Schedulable, Database.AllowsCallouts{
    global void execute(SchedulableContext sc){        
        List<RC_Dealer_Payment__c> dealerPaymentList = [SELECT Id, RC_Date__c, Name FROM RC_Dealer_Payment__c WHERE RC_Date__c < TODAY];
        if(dealerPaymentList != null && dealerPaymentList.size() > 0){
            delete dealerPaymentList;
        }
    }
}