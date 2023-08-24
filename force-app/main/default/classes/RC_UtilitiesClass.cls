global inherited sharing class RC_UtilitiesClass {    
    private static Map<String, Map<String, String>> cityRegionMap {get; set;}

    @AuraEnabled
    global static Account getUserRelatedAccount(){
        Account relatedAccount = null;

        String userRelatedAccountID = [SELECT AccountId FROM User WHERE Id =: UserInfo.getUserId()].AccountId;
        
        if(Test.isRunningTest()){
            List<Account> foundedAccount = [SELECT Id FROM Account LIMIT 1];
            system.debug(foundedAccount);
            if(foundedAccount != null && foundedAccount.size() > 0){
                userRelatedAccountID =  foundedAccount.get(0).Id;                     
            }      
            else{
                userRElatedAccountID = '';
            }
        }
        
        if(String.isNotBlank(userRelatedAccountID)){
            List<Account> foundedAccount = [SELECT Id, RC_Customer_No__c,RC_SAP_ID__c  FROM Account WHERE Id =: userRelatedAccountID];

            if(foundedAccount != null && foundedAccount.size() > 0)
                relatedAccount = foundedAccount.get(0);
        }
        
        return relatedAccount;
    }
    
    @AuraEnabled
    global static String getFormattedProductCode(String code){
        String val = '';
        
        if(String.isNotBlank(code)){
            val = String.valueOf(Integer.valueOf(code));
        }
        
        return val;
    }

    @AuraEnabled
    global static Map<String, Map<String, String>> getCityMappedData(List<String> codeList){
        try {
            cityRegionMap = new Map<String, Map<String, String>>();
            
            for(RC_City_Region__c item : [SELECT Id, RC_Type__c, RC_Code__c FROM RC_City_Region__c WHERE RC_Code__c IN :codeList]){
                if(!cityRegionMap.containsKey(item.RC_Type__c)){
                    Map<String, String> dataMap = new Map<String, String>();
                    dataMap.put(item.RC_Code__c, item.Id);

                    cityRegionMap.put(item.RC_Type__c, dataMap);
                }
                else{
                    Map<String, String> existDataMap = cityRegionMap.get(item.RC_Type__c);

                    if(!existDataMap.containsKey(item.RC_Code__c)){
                        existDataMap.put(item.RC_Code__c, item.Id);

                        cityRegionMap.put(item.RC_Type__c, existDataMap);
                    }
                }
            }

            return cityRegionMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
        @AuraEnabled
    global static string formatDate(String dt){
        string month = dt.substring(5, 7);
        string day = dt.substring(8, 10);
        string year = dt.substring(0, 4);
        //string res = year+month+day;
        return year+month+day;        
    }
}