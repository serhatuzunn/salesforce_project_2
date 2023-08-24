public class MailSender {     
    
    public static Boolean sendEmail(string sender, string fromDisplayName, string to, string subject, string bodyMail, string cc){
        Boolean isSend = false;
        
        try {
            // Step 0: Create a master list to hold the emails we'll send
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();        
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            if(!String.isBlank(to)){
                List<String> tos = to.split(';');
                for (String t : tos) {
                    sendTo.add(t);                
                }            
                mail.setToAddresses(sendTo);  
            }
            
            // Step 3: Set who the email is sent from
            mail.setReplyTo(sender);
            mail.setSenderDisplayName(fromDisplayName);
            
            // (Optional) Set list of people who should be CC'ed
            List<String> ccTo = new List<String>();
            if(!String.isBlank(cc)){
                List<String> ccs = cc.split(';');
                for (String c : ccs) {
                    ccTo.add(c);                
                }            
                mail.setCcAddresses(ccTo); 
            }
            
            
            // Step 4. Set email contents - you can use variables!
            mail.setSubject(subject);
            String body = bodyMail;
            mail.setHtmlBody(body);
            
            // Step 5. Add your email to the master list
            mails.add(mail);
            
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mails);
        }
        catch(Exception e){
            System.debug('Exception Mail Sender: '+JSON.serialize(e));
        }
        
        return isSend;
    }
    
}