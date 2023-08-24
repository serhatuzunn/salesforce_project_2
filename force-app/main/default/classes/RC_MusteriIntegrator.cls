public class RC_MusteriIntegrator {
    
    public class Item
    {
        @AuraEnabled   
        public string KUNNR { get; set; }
    }
    
    public class INTKUNN
    {
        @AuraEnabled   
        public Item item { get; set; }
    }
    
    public class RequestModel{
        @AuraEnabled      
        public String OP { get; set; }
        @AuraEnabled  
        public String PBANKA { get; set; }
        @AuraEnabled  
        public INTKUNN IN_TKUNN { get; set; }
    }
    
     public class ResponseModel{
        @AuraEnabled
        public RC_MusteriIntegratorParser MusteriResponse {get;set;}
    }
    
    
    public static RC_MusteriIntegratorParser getMusteri(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/fi_musteri';
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
                RC_MusteriIntegratorParser parseResult = RC_MusteriIntegratorParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);
                
                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
            RC_Logger.LOG_EXCEPTION(ex.getMessage(), ex.getMessage(), '', 'RC_MusteriIntegrator', 'getMusteri', '');

        }
        return null;
    }
}