public with sharing class RC_BordroPdf {
    
    @AuraEnabled
    public static String getEmail(String musteriNo) {
        system.debug('musteriNo : ' + musteriNo);
        
        List<Account> accountList = [SELECT RC_Email__c FROM Account WHERE RC_SAP_Id__c =: musteriNo];
        if(accountList != null && accountList.size() > 0){
            return accountList.get(0).RC_Email__c;
        }
        return null;
    }
    
    @AuraEnabled
    public static Boolean sendEmail(String sendEmail, String bordroId){
        try {
            system.debug('sendEmail : ' + sendEmail);
            system.debug('bordroId : ' + bordroId);
            
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            Blob b = null;
            if(Test.isRunningTest()) { 
                b = blob.valueOf('Unit.Test');
            } else {
                PageReference pdf = new PageReference('/apex/RC_BordroPdf?bid=' + bordroId);
                pdf.setRedirect(true);
                b = pdf.getContent();
            }
            
            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('attachment.pdf');
            efa.setBody(b);
            
            String addresses;
            email.setSubject('subject');
            
            string[] test = new String[] {sendEmail};
                email.setToAddresses( test );
            email.setPlainTextBody('pdf');
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            // Send it
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            return  true;
            
        } catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
            return false;
        } 
    }
}