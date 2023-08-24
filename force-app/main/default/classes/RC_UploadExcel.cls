public class RC_UploadExcel {
    
    public class ResultWrapper{
        @AuraEnabled
        public string ErrorMsg{get;set;}
        @AuraEnabled
        public boolean State{get;set;}
        @AuraEnabled
        public List<RC_Cheques__c> successList{get;set;}
        @AuraEnabled
        public List<RC_Cheques__c> errorList{get;set;}
        @AuraEnabled
        public List<RC_Bank_Informations__c> bankInfoList {get; set;}
        
    }
    
    @AuraEnabled
    public static ResultWrapper getExcelData(String base64String, String musteriNo, String bordroId) {
        ResultWrapper resultWrapper = new ResultWrapper();
        resultWrapper.successList= new List<RC_Cheques__c>();
        resultWrapper.errorList = new List<RC_Cheques__c>();
        
        RC_UploadExcelIntegrator.ResultWrapper resultIntegratorWrp = new RC_UploadExcelIntegrator.ResultWrapper();
        resultIntegratorWrp = RC_UploadExcelIntegrator.getFormattedData(base64String);
        
        if(!string.isNotBlank(resultIntegratorWrp.ErrorMessage)){
           Set<String> bankKeySet = new Set<String>();
           for(RC_UploadExcelIntegratorParser emw : resultIntegratorWrp.uploadExcelList){
                bankKeySet.add(emw.banka_anahtari);
           }

           Map<String, RC_Bank_Informations__c> bankKeyMap = new Map<String, RC_Bank_Informations__c>();
           for(RC_Bank_Informations__c bankInfo : [SELECT Id, RC_BANKL__c, RC_BANK__c, RC_BRINCH__c, RC_ORT01__c FROM RC_Bank_Informations__c WHERE RC_BANKL__c =: bankKeySet]){
                bankKeyMap.put(bankInfo.RC_BANKL__c, bankInfo);
           } 

           resultWrapper.bankInfoList = bankKeyMap.values();

            for(RC_UploadExcelIntegratorParser emw : resultIntegratorWrp.uploadExcelList){
                RC_Bank_Informations__c bankInfo = bankKeyMap.get(emw.banka_anahtari);

                RC_Cheques__c cheques = new RC_Cheques__c();
                cheques.RC_Cheque_Bill__c = 'Cheque';
                cheques.RC_Cheque_Number__c = String.valueOf(Integer.valueOf(emw.cek_no));
                cheques.RC_Due_Date__c  = Date.valueOf(emw.vade_tarihi);
                cheques.RC_Amount__c  = Decimal.valueOf(emw.tutar);
                cheques.RC_Identification_Number__c  = String.valueOf(Long.valueOf(emw.tckn_vergi_no));
                cheques.RC_Bank_Account_Number__c  = String.valueOf(Integer.valueOf(emw.banka_hesap_no));
                cheques.RC_Drawer_Region__c = emw.kesideci_bolge;
                cheques.RC_Account_No__c = musteriNo;
                cheques.RC_Bordro__c = bordroId;
                cheques.RC_Type__c = 'Cheque';
                cheques.RC_Bank_Key__c  = bankInfo != null ? bankInfo.Id : null;
                cheques.RC_City__c = bankInfo != null ? bankInfo.RC_ORT01__c : null;
                cheques.RC_Check_Status_ID__c = 'Yeni Çek';
                                
                String message = RC_CreateChequeAndBond.validateInput(cheques);
                cheques.RC_Description__c = message;

                if(String.isBlank(message)){
                    resultWrapper.successList.add(cheques);
                }
                else{
                    resultWrapper.errorList.add(cheques);
                }
            }
        }
        
        return resultWrapper;
    }
}