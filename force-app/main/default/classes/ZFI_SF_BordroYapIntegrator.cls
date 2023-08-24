public class ZFI_SF_BordroYapIntegrator {
    
    public class requestModel{
        @AuraEnabled
        public string IV_BEG_DATE 	{get;set;}
        @AuraEnabled
        public string IV_END_DATE 	{get;set;}
        @AuraEnabled
        public string PBANKA 		{get;set;}
        @AuraEnabled
        public string PBGLNT 		{get;set;}
        @AuraEnabled
        public string PBRDTYP 		{get;set;}
        @AuraEnabled
        public string PKUNSCR 		{get;set;}
        @AuraEnabled
        public string PSIMUL 		{get;set;}
        @AuraEnabled
        public string PTAKSIT 		{get;set;}
        @AuraEnabled
        public string PKKBER 		{get;set;}
        @AuraEnabled
        public IN_TAUGRU IN_TAUGRU 		{get;set;}
        @AuraEnabled
        public IO_TKUNNR IO_TKUNNR 		{get;set;}
        
        
    }
    
    public class IN_TAUGRU {
        @AuraEnabled
        public List<item> item {get;set;}
    }
    
    public class IO_TKUNNR {
        @AuraEnabled
        public List<item> item {get;set;}
    }
    
    public class item {
        @AuraEnabled
        public string AUGRU 	  {get;set;}
        @AuraEnabled
        public string KUNNR 	  {get;set;}
        @AuraEnabled
        public string BORDROTYPE  {get;set;}
        @AuraEnabled
        public string SONUC 	  {get;set;}
        @AuraEnabled
        public string BORDRONO 	  {get;set;}
        @AuraEnabled  
        public string MSG 	      {get;set;}
        @AuraEnabled
        public string KKBER       {get;set;}
    }
    
    public class responseModel{
        @AuraEnabled
        public ZFI_SF_BordroYapParser bordroYapResponse {get;Set;}
    }
    
    
    @AuraEnabled
    public static responseModel bordroYap(requestModel reqModel){
        responseModel result = new responseModel();
        
        String url = 'RESTAdapter/salesforce/fi_bordro_yap_kkber';
        HttpRequest request = new HttpRequest();
        request.setBody(json.serialize(reqModel,true));
        request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;');
        request.setTimeout(120000);
        Http http = new Http();
        System.debug('BordroYap Req : ' + request.getBody());
        HttpResponse response = http.send(request);
        System.debug('BordroYap Resp : ' + response.getBody());
        if(response.getStatus() == 'OK'){
            ZFI_SF_BordroYapParser serializedData = (ZFI_SF_BordroYapParser)JSON.deserialize(response.getBody(), ZFI_SF_BordroYapParser.class);
            //ZFI_SF_BordroYapParser parseResult = ZFI_SF_BordroYapParser.parse(response.getBody());
            result.bordroYapResponse = serializedData;
            return result;
        }
        return result;
        
    }
    

}