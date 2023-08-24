public class RC_TeslimatBekleyenIntegrator {

    public class Item
    {
        @AuraEnabled  
        public string BAYINO { get; set; }
        @AuraEnabled  
        public string URUNKODU { get; set; }
    }
    
    public class TESLIMATTABEKLEYEN
    {
        @AuraEnabled  
        public List<Item> item { get; set; }
    }
    
    public class RequestModel{
        @AuraEnabled      
        public string BAYINO { get; set; }
        @AuraEnabled  
        public TESLIMATTABEKLEYEN TESLIMATTABEKLEYEN { get; set; }
    }
    
     public class ResponseModel{
        @AuraEnabled
        public RC_TeslimatBekleyenIntegratorParser TeslimatBekleyenResponse {get;set;}
    }
    
    public static RC_TeslimatBekleyenIntegratorParser getTeslimatBekleyen(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_teslimat_bekleyen';
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
                RC_TeslimatBekleyenIntegratorParser parseResult = RC_TeslimatBekleyenIntegratorParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);
                
                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
            RC_Logger.LOG_EXCEPTION('Error : RC_TeslimatBekleyenIntegrator', 'Integrator Error', ex.getMessage(), 'RC_TeslimatBekleyenIntegrator', 'getTeslimatBekleyen', '');
        }
        return null;
    }
    
}