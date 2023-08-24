public class RC_SubeSilController {
    
    public class initWrapper{
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public String errorMessage {get;set;}
    }
    
    @AuraEnabled
    public static initWrapper initialize(string recordId){
        initWrapper initWrp = new initWrapper();
        system.debug('recordId:' + recordId);
        
        if(!string.isBlank(recordId)){
            
            List<RC_SD_Organization__c> organizationList = [SELECT Id, RC_Account__r.RC_SAP_ID__c, RC_Account__c, RC_Account__r.Parent.RC_SAP_ID__c, RC_Sales_Organization__c, Distribution_Channel__c, RC_Division__c, Name, RC_Closing_Request__c
                                                            FROM RC_SD_Organization__c
                                                            WHERE RC_Closing_Request__c =: recordId 
                                                            LIMIT 1];
            
            system.debug('organizationList : ' + organizationList);
            
            if(organizationList != null && organizationList.size() > 0){
                RC_SubeSilIntegrator.IS_SUBE_VERILERI subeVerileri = new RC_SubeSilIntegrator.IS_SUBE_VERILERI();    
                subeVerileri.VKORG = organizationList.get(0).RC_Sales_Organization__c;
                subeVerileri.VTWEG = organizationList.get(0).Distribution_Channel__c;
                subeVerileri.SPART = organizationList.get(0).RC_Division__c;
                
                RC_SubeSilIntegrator.RequestModel requestModel = new RC_SubeSilIntegrator.RequestModel();
                requestModel.IS_SUBE_VERILERI = subeVerileri;
                
                if(organizationList.get(0).RC_Account__r.Parent != null && organizationList.get(0).RC_Account__r.Parent.RC_SAP_ID__c.length() == 10){  //şube
                    
                    subeVerileri.KUNNR = organizationList.get(0).RC_Account__r.Parent.RC_SAP_ID__c; 
                    
                    requestModel.IV_SUBE = organizationList.get(0).RC_Account__r.RC_SAP_ID__c; 
                    requestModel.IV_BAYI = '';
                }
                else{ //bayi
                    
                    subeVerileri.KUNNR = organizationList.get(0).RC_Account__r.RC_SAP_ID__c; 
                    
                    requestModel.IV_BAYI = organizationList.get(0).RC_Account__r.RC_SAP_ID__c; 
                    requestModel.IV_SUBE = '';
                }

                system.debug('sube sil requestModel : ' + requestModel);
                
                RC_SubeSilIntegratorParser integratorParser = RC_SubeSilIntegrator.getSubeSil(requestModel);
                system.debug('integratorParser : ' + integratorParser);
                
                List<MYS_Open_Request__c> mysOpenRequest =  [SELECT Id, RC_SAP_Message__c 
                                                             FROM MYS_Open_Request__c
                                                             WHERE Id =: recordId
                                                             LIMIT 1];
                
                //API Result
                if(integratorParser.EV_SUCCESS == 'X'){
                    initWrp.isSuccess = true;
                    
                    organizationList.get(0).RC_Price_Group__c = '14';
                    organizationList.get(0).RC_Order_Blockage__c = '01';
                    organizationList.get(0).RC_Delivery_Blockage__c = '01';
                    organizationList.get(0).RC_Invoice_Blockage__c = '01';
                    update organizationList.get(0);
                    
                    if(organizationList.get(0).RC_Account__r.Parent != null && organizationList.get(0).RC_Account__r.Parent.RC_SAP_ID__c.length() == 10){ //şube
                        List<Account> accountList = [SELECT RC_Block__c 
                                                     FROM Account
                                                     WHERE Id =: organizationList.get(0).RC_Account__c
                                                     LIMIT 1];
                        
                        if(accountList != null && accountList.size() > 0){
                            accountList.get(0).RC_Block__c = 'SPERR';
                            update accountList.get(0);
                        }
                    }
                    else{  //bayi
                        List<Account> accountList = [SELECT Id, RC_Block__c 
                                                     FROM Account
                                                     WHERE ParentId =: organizationList.get(0).RC_Account__c OR Id =: organizationList.get(0).RC_Account__c];
                        
                        if(accountList != null && accountList.size() > 0){
                            
                            for(Account acc : accountList){
                                acc.RC_Block__c = 'SPERR';
                                update acc;
                            }
                        }
                    }
                    
                    if(mysOpenRequest != null && mysOpenRequest.size() > 0){
                        mysOpenRequest.get(0).MYS_Status__c = 'SAP Approved';
                        mysOpenRequest.get(0).RC_Detail__c = '<p><b style="font-size: 14px;">Kapanış talebi SAP aktarımı tamamlanmıştır. Yüklenici söküm işlemleri devam etmektedir. </b></p>';
                        update mysOpenRequest.get(0);
                    }
                    
                }
                else{
                    //Hata oluşur ise message kısmı doldurulur.
                    
                    initWrp.isSuccess = false;
                    
                    if(mysOpenRequest != null && mysOpenRequest.size() > 0){
                        mysOpenRequest.get(0).RC_SAP_Message__c = integratorParser.ET_MESSAGES.item[0].MESSAGE;
                        update mysOpenRequest.get(0);
                        
                        initWrp.errorMessage = mysOpenRequest.get(0).RC_SAP_Message__c;
                    }
                }               
            }
            else{
                initWrp.isSuccess = false;
            }
        }
        else{
            initWrp.isSuccess = false;
        }
        
        return initWrp;
    }
}