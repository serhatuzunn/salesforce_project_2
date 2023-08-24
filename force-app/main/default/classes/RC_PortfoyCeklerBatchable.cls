public class RC_PortfoyCeklerBatchable implements Database.Stateful,Database.Batchable<RC_PortfoyCeklerParser.Item>,Database.AllowsCallouts {
    
    public RC_PortfoyCeklerIntegrator.RequestModel requestBody {get;set;}
    public Integer TOTAL {get;set;}
    public integer INDEX {get;set;}
    public integer PACKAGE_SIZE {get;set;}
    
    public RC_PortfoyCeklerBatchable(RC_PortfoyCeklerIntegrator.RequestModel req){
        
        this.PACKAGE_SIZE   = integer.valueOf(req.IV_PACKAGE);
        this.INDEX 			= integer.valueOf(req.IV_INDEX);
        this.requestBody    = req;
    }
    
    public Iterable<RC_PortfoyCeklerParser.Item> start (Database.BatchableContext BC){
        RC_PortfoyCeklerIntegrator.ResponseModel result = new  RC_PortfoyCeklerIntegrator.ResponseModel();
        
        result = RC_PortfoyCeklerIntegrator.getPortfoyCekler(this.requestBody);
        system.debug('result.EV_TOTAL_IND ::' + result.EV_TOTAL_IND);
        this.TOTAL = result.EV_TOTAL_IND;
        
        return result.Items;
    }
    
    public void execute(Database.BatchableContext info , List<RC_PortfoyCeklerParser.Item> itemList){
        
        system.debug('itemList: ' + itemList);
        
        Map<String,Id> mapList = new Map<String,Id>(); //key=KUNNR, value=AccountId
        Map<String, String> mapUserList = new Map<String, String>(); //key=user.accountId, value= user.Id
        Set<String> kunnrList = new Set<String>();
        
        for(RC_PortfoyCeklerParser.Item p : itemList){
            if(p.KUNNR.startsWith('00')){
                p.KUNNR = p.KUNNR.subString(2, p.KUNNR.length());
            } 
            kunnrList.add(p.KUNNR);
        }
        
        List<Account> selectedAccountList = [SELECT Id, RC_SAP_ID__c FROM Account Where RC_SAP_ID__c IN :kunnrList];
        
        system.debug('selectedAccountList: ' + selectedAccountList);
        
        for(Account account : selectedAccountList){
            mapList.put(account.RC_SAP_ID__c, account.Id);
        }
        
        System.debug('mapList: ' + mapList);
        
        List<User> selectedUserList = [SELECT Id, AccountId FROM User Where AccountId IN :mapList.values()];
        for(User user : selectedUserList){
            mapUserList.put(user.AccountId, user.Id);
        }
        
        Set<String> paymentSet = new Set<String>();  //KUNNR+NETDT
        for(RC_PortfoyCeklerParser.Item p : itemList){
            paymentSet.add(p.KUNNR + '_' + p.NETDT);
        }
        
        System.debug('mapUserList: ' + mapUserList);
        
        List<RC_Dealer_Payment__c> paymentInsertList = new List<RC_Dealer_Payment__c>();
        for(String s: paymentSet){
            List<String> paymentSplit = s.split('_');
            RC_Dealer_Payment__c payment = new RC_Dealer_Payment__c();
            
            if(paymentSplit[0] != null && paymentSplit[1] != null){
                if(mapList.get(paymentSplit[0]) != null){
                    payment.RC_Account__c = mapList.get(paymentSplit[0]);
                    
                    List<String> datePaymentList = paymentSplit[1].split('-');
                    payment.RC_Date__c = Date.valueOf(datePaymentList[2] + '-'+ datePaymentList[1] + '-' + datePaymentList[0]);
                    
                    payment.RC_External_ID__c = s;
                    payment.Name = s.Replace('_' , ' / ');
                    payment.Type__c = 'Cheque';
                    paymentInsertList.add(payment);   
                    
                    system.debug('payment: ' + payment);
                }
            }
            
            
            
        }
        
        
        
        system.debug('paymentInsertList : ' + paymentInsertList);
        
        Set<String> paymentIdSet = new Set<String>();
        if(paymentInsertList.size() > 0){
            Schema.SObjectField f = RC_Dealer_Payment__c.Fields.RC_External_ID__c;
            List<Database.UpsertResult> paymentSrList = Database.upsert(paymentInsertList, f, false);
            
            List<RC_Logger__c> upsertLoggerList = new List<RC_Logger__c>();
            for(Database.UpsertResult sr : paymentSrList){
                if(sr.isSuccess()){
                    System.debug(sr.getId());
                    paymentIdSet.add(sr.getId());
                }
                else{
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('error: ' + err.getFields());
                        
                        RC_Logger__c rcLogger = new RC_Logger__c();
                        rcLogger.RC_Message__c = 'Error: RC_PortfoyCeklerBatchable';
                        rcLogger.RC_Message_Detail__c = 'upsert Error';
                        rcLogger.RC_StackTrace__c = err.getMessage();
                        rcLogger.RC_LogLevel__c = 'EXCEPTION';
                        rcLogger.CreateDate__c = DateTime.now();
                        rcLogger.RC_ClassName__c = 'RC_PortfoyCeklerBatchable';
                        rcLogger.RC_FunctionName__c = 'execute';
                        rcLogger.RC_ComponentName__c = '';      
                        
                        upsertLoggerList.add(rcLogger);
                    }
                    
                }
            }
            insert upsertLoggerList;
        }
        
        
        if(paymentIdSet.size() > 0){
            List<RC_Dealer_Payment__c> paymentList = [Select Id, RC_Date__c, RC_User__c,RC_External_ID__c, RC_Account__c FROM RC_Dealer_Payment__c WHERE Id IN: paymentIdSet];
            
            if(paymentList.size() > 0){
                Map<String, String> paymentMap = new Map<String, String>();
                for(RC_Dealer_Payment__c dealerPaymentItem: paymentList){
                    paymentMap.put(dealerPaymentItem.RC_External_ID__c, dealerPaymentItem.Id + '_' + dealerPaymentItem.RC_Account__c);
                }
                
                List<RC_Dealer_Payment_Detail__c> paymentDetailList = new List<RC_Dealer_Payment_Detail__c>();
                for(RC_PortfoyCeklerParser.Item p : itemList){
                    if(paymentMap.containsKey(p.KUNNR + '_' + p.NETDT)){
                        
                        List<String> dateItemList = p.NETDT.split('-');
                        
                        RC_Dealer_Payment_Detail__c paymentDetail = new RC_Dealer_Payment_Detail__c();
                        paymentDetail.Name = p.BOENO + ' / ' + p.NETDT;
                        paymentDetail.RC_Company__c = p.BUKRS;
                        paymentDetail.RC_Portfolio__c = p.PORTF;
                        paymentDetail.RC_Cheque_Number__c = p.BOENO; 
                        paymentDetail.RC_Amount__c = decimal.valueOf(p.DMBTR);
                        paymentDetail.RC_Credit_Control_Field__c = p.KKBER;
                        paymentDetail.RC_Date__c = Date.valueOf(dateItemList[2] + '-'+ dateItemList[1] + '-' + dateItemList[0]);
                        paymentDetail.RC_Dealer_Payment__c = paymentMap.get(p.KUNNR + '_' + p.NETDT).split('_').get(0);
                        paymentDetail.RC_Account__c = paymentMap.get(p.KUNNR + '_' + p.NETDT).split('_').get(1);
                        paymentDetail.RC_Seller_Code__c = p.VENDR;
                        paymentDetail.Type__c = 'Cheque';
                        if(p.KUNNR.startsWith('00')){
                            p.KUNNR = p.KUNNR.subString(2, p.KUNNR.length());
                        }   
                        
                        paymentDetailList.add(paymentDetail);  
                    }
                    
                }
                
                if(Test.isRunningTest()) {
                    paymentDetailList.get(0).CurrencyIsoCode = 'test';
                    
                }
                
                Set<id> successResults = new Set<id>();
                List<Database.Error> errors = new List<Database.Error>();
                
                if(paymentDetailList.size() > 0){
                    List<Database.SaveResult> srList = Database.insert(paymentDetailList, false); 
                    List<RC_Logger__c> insertLoggerList = new List<RC_Logger__c>();
                    for(Database.SaveResult sr : srList){
                        if(sr.isSuccess()){
                            successResults.add(sr.getId());
                        }else{
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('error: ' + err.getFields());
                                
                                RC_Logger__c rcLogger = new RC_Logger__c();
                                rcLogger.RC_Message__c = 'Error: RC_PortfoyCeklerBatchable';
                                rcLogger.RC_Message_Detail__c = 'insert Error';
                                rcLogger.RC_StackTrace__c = err.getMessage();
                                rcLogger.RC_LogLevel__c = 'EXCEPTION';
                                rcLogger.CreateDate__c = DateTime.now();
                                rcLogger.RC_ClassName__c = 'RC_PortfoyCeklerBatchable';
                                rcLogger.RC_FunctionName__c = 'execute';
                                rcLogger.RC_ComponentName__c = '';      
                                
                                insertLoggerList.add(rcLogger);
                            }
                            
                        }
                    }
                    insert insertLoggerList;
                    
                }    
            }
            
        }
        
        
        
    }
    
    public void finish(Database.BatchableContext info){
        List<AsyncApexJob> statusList = [SELECT Status FROM AsyncApexJob where id =:info.getJobId()];
        if(statusList.size() > 0){
            AsyncApexJob status = statusList.get(0); 
            if(status.Status == 'Completed'){
                this.INDEX = this.INDEX + this.PACKAGE_SIZE;
                
                if(this.INDEX <= this.TOTAL){
                    
                    RC_PortfoyCeklerIntegrator.RequestModel req = new RC_PortfoyCeklerIntegrator.RequestModel();
                    req.IV_INDEX   = string.valueOf(this.INDEX);
                    req.IV_PACKAGE = string.valueOf(this.PACKAGE_SIZE);
                    req.IV_BUKRS   = '2002';
                    req.IV_KKBER   = '';
                    req.IV_KUNNR   = '';
                    
                    RC_PortfoyCeklerBatchable batch = new RC_PortfoyCeklerBatchable(req);
                    Database.executeBatch(batch,this.PACKAGE_SIZE);
                }
            }
        }
    }
    
}