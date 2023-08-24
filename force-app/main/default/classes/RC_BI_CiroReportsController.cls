public class RC_BI_CiroReportsController {

    public class Wrapper
    {
        @AuraEnabled
        public Account acc;
        @AuraEnabled
        public string token_info;
    }
    @AuraEnabled
    public static Wrapper initialize(string recordId)
    {
        Wrapper response = new Wrapper();
        
        string token = RC_BI_GetTokenCiroIntegrator.GetToken();

        if(string.isBlank(recordId)){
            string usr = UserInfo.getUserId();
            User usrInfo = [SELECT Id,AccountId FROM User Where Id=:usr LIMIT 1];
            string accountId;
            if(usrInfo!=null && !string.isBlank(usrInfo.AccountId))
            {
                accountId = usrInfo.AccountId;
            }

            if(!string.isBlank(accountId)){
                system.debug('accountId:' + accountId);
                recordId=accountId;
            }
        }
        Account acc = new Account();
        if(!string.isBlank(recordId))
        {
            acc= [SELECT Id,RC_SAP_ID__c FROM Account Where Id=:recordId LIMIT 1];
        }
        
        
        response.acc=acc;
        response.token_info=string.isNotBlank(token) ? token.replace('"','') : '';
        
        return response;
    }
}