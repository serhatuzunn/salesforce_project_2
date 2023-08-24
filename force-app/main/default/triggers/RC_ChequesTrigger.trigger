trigger RC_ChequesTrigger on RC_Cheques__c (before insert) {

    List<RC_Cheques__c> lastBond = [SELECT Id, RC_Cheque_Number__c FROM RC_Cheques__c WHERE RC_Cheque_Bill__c = 'Bill' ORDER BY CreatedDate DESC LIMIT 1];
    
    Integer billNum = 2020000;
    
    if(lastBond != null && lastBond.size() > 0){
        billNum = lastBond.get(0).RC_Cheque_Number__c != null ? Integer.valueOf(lastBond.get(0).RC_Cheque_Number__c) : billNum;
    }
    
    for(RC_Cheques__c newCheque : Trigger.new){
        if(newCheque.RC_Cheque_Bill__c == 'Bill'){
            billNum++;
            newCheque.RC_Cheque_Number__c = String.valueOf(billNum);
        }
    }
}