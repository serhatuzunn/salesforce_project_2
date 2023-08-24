trigger RC_MusteriTrigger on Account (before update) {
    
    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            for(Account a : Trigger.New) {
                
                List<Account> accountList = [SELECT RC_IsDTS__c, RC_DTS_Bank__c FROM Account WHERE Id =: a.Id LIMIT 1];
                if(accountList != null && accountList.size() > 0){
                    system.debug('beforeDts : ' + accountList.get(0).RC_IsDTS__c);
                    
                    String accKunnr = a.RC_SAP_ID__c ;
                    String op = '';
                    
                    Boolean beforeDts = null, afterDts = null;
                    String beforeBank = null, afterBank = null;
                    
                    system.debug('afterDts : ' + a.RC_IsDTS__c);
                    afterDts = a.RC_IsDTS__c;
                    afterBank = a.RC_DTS_Bank__c; 
                    
                    beforeDts = accountList.get(0).RC_IsDTS__c;
                    beforeBank = accountList.get(0).RC_DTS_Bank__c;
                    
                    if( (a.RC_IsDTS__c == false && accountList.get(0).RC_IsDTS__c == true) || 
                        (a.RC_IsDTS__c == true && accountList.get(0).RC_IsDTS__c == false) || 
                        (a.RC_IsDTS__c == true && accountList.get(0).RC_IsDTS__c == true && (afterBank != null && (beforeBank != afterBank)))
                      ){
                           if(beforeDts == false && afterDts == true && (afterBank != null && (beforeBank == afterBank))){
                               op = 'C';
                           }
                           else if(beforeDts == false && afterDts == true && (afterBank != null && (beforeBank != afterBank))){
                               op = 'C';
                           }
                           else if(beforeDts == true && afterDts == false && (afterBank != null && (beforeBank == afterBank))){
                               op = 'D';
                           }
                           else if(beforeDts == true && afterDts == false && (afterBank != null && (beforeBank != afterBank))){
                               op = 'D';
                           }
                           else if(beforeDts == true && afterDts == true && (afterBank != null && (beforeBank != afterBank))){
                               op = 'U';
                           }
                           
                           RC_MusteriIntegrator.Item item = new RC_MusteriIntegrator.Item();
                           item.KUNNR = accKunnr;
                           
                           RC_MusteriIntegrator.INTKUNN intKunnr = new RC_MusteriIntegrator.INTKUNN();
                           intKunnr.item = item;
                           
                           RC_MusteriIntegrator.RequestModel req = new RC_MusteriIntegrator.RequestModel();
                           req.OP = op;
                           req.PBANKA = 'GRN';
                           req.IN_TKUNN = intKunnr;
                           
                           system.debug('req : ' + req);
                           
                           RC_MusteriCommon.getMusteri(Json.serialize(req));
                       }

                }
                                
            }
        }
    }
}