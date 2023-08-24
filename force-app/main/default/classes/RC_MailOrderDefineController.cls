public class RC_MailOrderDefineController {
    
    //Constructor with no arguments
    public RC_MailOrderDefineController() 
    {        
    }
    
    public class initWrapper{
        @AuraEnabled
        public RC_GetCustomerOrdersJsonParser.ET_ORDERS oDetail {get;set;} 
        @AuraEnabled
        public RC_GetCustomerOrdersJsonParser.ET_ORDERS_H oHeader {get;set;}         
    }
    
    @AuraEnabled
    public static String getCustomerOrders(string accountName){
        initWrapper wrp = new initWrapper();
        
        RC_GetCustomerOrdersIntegrator.requestModel req  = new RC_GetCustomerOrdersIntegrator.requestModel();
        RC_GetCustomerOrdersIntegrator.responseModel resp = new RC_GetCustomerOrdersIntegrator.responseModel();
        List<RC_SD_Organization__c>  accDataList = new  List<RC_SD_Organization__c>();        
        
        List<RC_GetCustomerOrdersJsonParser.Item> oDetailItemList = new List<RC_GetCustomerOrdersJsonParser.Item>();
        List<RC_GetCustomerOrdersJsonParser.Item_Z> oHeaderItemList = new List<RC_GetCustomerOrdersJsonParser.Item_Z>();
        
        
        String userId = userInfo.getUserId();
        if(!test.isRunningTest()){
            accDataList = [select RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c,  RC_Sales_Expert__c, id,Distribution_Channel__c,  RC_Sales_Organization__c  from RC_SD_Organization__c WHERE RC_Account__r.Name = :accountName 
                       AND RC_Sales_Expert__c = :userId]; //TODO: canlıya gecste acılacak
        }
        else{
            accDataList = [select RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c,  RC_Sales_Expert__c, id,Distribution_Channel__c,  RC_Sales_Organization__c  
                           from RC_SD_Organization__c 
                          // WHERE RC_Sales_Expert__c  = :userId
                          ];
        }
        
        
        System.debug('sql : '+accDataList);
        
        if(accDataList != null && accDataList.size()>0){
            RC_SD_Organization__c accData = accDataList[0];
            
            String dealerCode = accData.RC_Account__r.RC_SAP_ID__c;
            String distrChl = accData.Distribution_Channel__c;
            String salesOrg = accData.RC_Sales_Organization__c;
            String division = '21';
            String salesRepCode = '1';
            
            System.debug('dealerCode: '+dealerCode);  System.debug('distrChl: '+distrChl); 
            System.debug('salesOrg: '+salesOrg);
            
           /* TODO: Canlıya gecerken kapatilacak
            dealerCode = '20302010';
            distrChl='01';
            division='21';
            salesOrg = '2201';
            salesRepCode='1'; */
            
            req.IV_CUSTOMER = dealerCode;
            req.IV_DISTRCHL = distrChl;
            req.IV_DIVISION = division;
            req.IV_REPRESENT = salesRepCode;
            req.IV_SALESORG = salesOrg;
            
            resp = RC_GetCustomerOrdersIntegrator.getMailOrderCustomerOrders(req);
            
            oDetailItemList = resp.orderDetail.item;
            oHeaderItemList = resp.orderHeader.item;
            
            wrp.oDetail = resp.orderDetail;
            wrp.oHeader = resp.orderHeader; 
            
            wrp.oDetail.item = oDetailItemList;
            wrp.oHeader.item = oHeaderItemList;
            
            
            System.debug('wrp : '+JSON.serialize(wrp)); 
        }
        
        return JSON.serialize(wrp);        
    }
    
    @AuraEnabled
    public static Map<String, Object> GetRequestParameters(Id accountId, String site, String returnUrl, String orderNo, String amount, String email)
    {
        try
        {
            system.debug(site);
            String accountName ='';String accountPhone ='';String bayikodu ='';
            
            String relatedSite = site.containsIgnoreCase('Regal') ? 'Regal' : 'Vestel';
            
            Account accountData = [select Id, Name, Phone, RC_Mobile__c, RC_SAP_ID__c from Account
                                   WHERE Id = :accountId limit 1];
            system.debug('accountData : '+ accountData);            
            if(accountData != null){
                bayikodu = accountData.RC_SAP_ID__c;
                accountName = accountData.Name;                
                accountPhone = String.isBlank(accountData.Phone) || accountData.Phone == '' 
                    ? accountData.RC_Mobile__c
                    : accountData.Phone;
            }
            String random = RC_Asseco_Integrator.GenerateRandomKey(64);
            String secretKey = '7189489278796668';
            
            AssecoInformation__c relatedAssecoInfo = AssecoInformation__c.getValues(relatedSite);            
            String channel = String.format(relatedAssecoInfo.AssecoApiMerchFormat__c, new String[]{relatedAssecoInfo.Kanal__c});
            
            Map<String, Object> requestData = new Map<String, Object>();
            requestData.put('channel', channel);
            requestData.put('bayikodu', bayikodu);
            requestData.put('siparisno', orderNo);
            requestData.put('maxsplitcount', '0');
            requestData.put('personalmaxinst', '6');
            requestData.put('businessmaxinst', '6');
            requestData.put('currency', 'TRY');
            requestData.put('customer', bayikodu);
            requestData.put('random', random);
            requestData.put('secretKey', secretKey);
            requestData.put('hash', RC_Asseco_Integrator.GenerateHashCode(channel, bayikodu, random, secretKey));
            requestData.put('expirationtime', relatedAssecoInfo.LinkSuresi__c);
            requestData.put('returnUrl', returnUrl);
            requestData.put('linkredirecturl', returnUrl+'?c__isAsseco=true');
            requestData.put('ispaybylink', 'Yes');
            requestData.put('amount', String.valueOf(amount).replace('.', ','));
            requestData.put('isdirectpayment', 'No');
            requestData.put('surid', relatedAssecoInfo.SureId__c);
            requestData.put('commercecodes', '1');
            requestData.put('customername', accountName);
            requestData.put('customeremail', email);
            requestData.put('customerphone', '');
            system.debug('ordercontroller requestdata '+ Json.serialize(requestData));
            return requestData;
        }
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getAssecoPaymentLink(){
        String assecoLink='';
        try
        {             
            NamedCredential oAssecoPayment = [SELECT DeveloperName, Endpoint FROM NamedCredential where DeveloperName ='assecoPayment' limit 1];
            assecoLink = oAssecoPayment.Endpoint;
            system.debug('assecoLink : ' + assecoLink);
        }
        catch (Exception e) 
        {
            system.debug('assecoLink Exception: ' + e);
            throw new AuraHandledException(e.getMessage());
        }
        
        return assecoLink;
    }
}