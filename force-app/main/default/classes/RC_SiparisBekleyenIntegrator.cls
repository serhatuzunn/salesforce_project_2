public class RC_SiparisBekleyenIntegrator {
    
    public class Item
    {
        @AuraEnabled  
        public string BAYINO { get; set; }
        @AuraEnabled  
        public string URUNKODU { get; set; }
    }
    
    public class SIPARISTEBEKLEYEN
    {
        @AuraEnabled  
        public List<Item> item { get; set; }
    }
    
    public class RequestModel{
        @AuraEnabled      
        public string BAYINO { get; set; }
        @AuraEnabled  
        public SIPARISTEBEKLEYEN SIPARISTEBEKLEYEN { get; set; }
    }
    
    public class ResponseModel{
        @AuraEnabled
        public RC_SiparisBekleyenIntegratorParser SiparisBekleyenResponse {get;set;}
    }
    
    public static RC_SiparisBekleyenIntegratorParser getSiparisBekleyen(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_siparis_bekleyen';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            System.debug('request.getBody() :' + request.getBody());
            HttpResponse response = http.send(request);
            System.debug('response.getBody() :' + response.getBody());
            System.debug('response.getStatus() :' + response.getStatus());
            if(response.getStatus() == 'OK'){
                RC_SiparisBekleyenIntegratorParser parseResult = RC_SiparisBekleyenIntegratorParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);
                
                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
            RC_Logger.LOG_EXCEPTION('Error : RC_SiparisBekleyenIntegrator', 'Integrator Error', ex.getMessage(), 'RC_SiparisBekleyenIntegrator', 'getSiparisBekleyen', '');
        }
        return null;
    }
}