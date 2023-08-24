public class RC_GetGiftVoucherUseIntegrator {
 
    
    
    public class LS_HEADER {
        @AuraEnabled
        public string DOC_TYPE {get;set;}
        @AuraEnabled
        public string DISTR_CHAN {get;set;}
        @AuraEnabled
        public string DIVISION {get;set;}
        @AuraEnabled
        public string DOC_DATE {get;set;}
        @AuraEnabled
        public string BILL_DATE {get;set;}
        @AuraEnabled
        public string PURCH_NO_C {get;set;}
        @AuraEnabled
        public string REQ_DATE_H {get;set;}
        @AuraEnabled
        public string SALES_ORG {get;set;}
        @AuraEnabled
        public string PMNTTRMS {get;set;}
    }
    
    public class LT_PARTNERS {
        @AuraEnabled
        public List<Item_X> item { get; set; } 
    }
    
     public class LS_HEADERSX {
         @AuraEnabled
        public string DOC_TYPE {get;set;}
         @AuraEnabled
        public string DISTR_CHAN {get;set;}
         @AuraEnabled
        public string DIVISION {get;set;}
         @AuraEnabled
        public string DOC_DATE {get;set;}
         @AuraEnabled
        public string BILL_DATE {get;set;}
         @AuraEnabled
        public string PURCH_NO_C {get;set;}
         @AuraEnabled
        public string REQ_DATE_H {get;set;}
         @AuraEnabled
        public string SALES_ORG {get;set;}
         @AuraEnabled
        public string PMNTTRMS {get;set;}
         @AuraEnabled
        public string UPDATEFLAG {get;set;}
    }
    public class LT_ITEMS    {
        @AuraEnabled
        public List<Item> item { get; set; } 
    }
    
    public class LT_ITEMSX    {
        @AuraEnabled
        public List<Item> item { get; set; } 
    }
    
     public class item {
         @AuraEnabled
        public string MATERIAL {get;set;}
         @AuraEnabled
        public string ITM_NUMBER {get;set;}
         @AuraEnabled
        public string PLANT {get;set;}
         @AuraEnabled
        public string TARGET_QTY {get;set;}
         @AuraEnabled
        public boolean TARGET_QTYSpecified {get;set;}
         @AuraEnabled
        public string UPDATEFLAG {get;set;}
       
    }
    
     public class LT_CONDS {
         
         @AuraEnabled
        public List<Item_W> item { get; set; } 
        
    }
    
    public class Item_W{
   
         @AuraEnabled
        public string ITM_NUMBER {get;set;}
         @AuraEnabled
        public string COND_TYPE {get;set;}
         @AuraEnabled
        public string CURRENCYx {get;set;}
         @AuraEnabled
        public string COND_VALUE {get;set;}
         @AuraEnabled
        public boolean COND_VALUESpecified {get;set;}
        
    }
    public class Item_X{
   
       
    }
    
    public class RequestModel   {
        @AuraEnabled
        public LS_HEADER LS_HEADER { get; set; } 
        @AuraEnabled
        public LS_HEADERSX LS_HEADERSX { get; set; }
        @AuraEnabled
        public LT_ITEMS LT_ITEMS { get; set; } 
        @AuraEnabled
        public LT_ITEMSX LT_ITEMSX { get; set; } 
        @AuraEnabled
        public LT_CONDS LT_CONDS { get; set; }  
        @AuraEnabled
        public LT_PARTNERS LT_PARTNERS { get; set; } 
        @AuraEnabled
        public string P_KUNNR { get; set; }
        @AuraEnabled
        public string P_MATBUNO { get; set; }
        @AuraEnabled
        public string P_VADE { get; set; }
                
    }
    
        public static RC_GetGiftVoucherUseParser getSendGiftUseVoucher(RequestModel req){
        try{
            system.debug('req :'+ req);
            String url = 'RESTAdapter/salesforce/sd_create_order_parametrik';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req).Replace('NUMBERx','NUMBER'));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            System.debug('request.getBody() parametric :' + request.getBody());
            HttpResponse response = http.send(request);
            System.debug('response.getBody() :' + response.getBody());
            System.debug('response.getStatus() :' + response.getStatus());
            if(response.getStatus() == 'OK'){
                RC_GetGiftVoucherUseParser parseResult = RC_GetGiftVoucherUseParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);

                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
        }
        return null;
        
    }
}