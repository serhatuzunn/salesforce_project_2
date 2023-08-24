public class RC_BordroGirIntegrator {
    
    public class Item {
        public String BELNR {get;set;}
        public String BUZEI {get;set;}
        public String KUNNR {get;set;}
        public String BUDAT {get;set;}
        public String ZFBDT {get;set;}
        public String WAERS {get;set;}
        public String DMBTR {get;set;}
        public String SGTXT {get;set;}
        public String BLART {get;set;}
        public String VKBUR {get;set;}
    }
    
    public class IT_ITEMS {
        public Item item {get;set;}
    }
    
    public class RequestModel{
        @AuraEnabled
        public String IV_KKBER {get;set;}
        @AuraEnabled
        public String IV_KUNNR {get;set;}
        @AuraEnabled
        public String IV_ODK {get;set;}
        @AuraEnabled
        public IT_ITEMS IT_ITEMS {get;set;}
        
    }
    
    public class ResponseModel{
        @AuraEnabled
        public RC_BordroGirParser bordroGirResponse {get;set;}
    }
    
    public static ResponseModel getBordroGir(requestModel req){
        try {
            String url = 'RESTAdapter/salesforce/fi_bordro_gir';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            ResponseModel resp = new ResponseModel();
            if(response.getStatus() == 'OK'){
                RC_BordroGirParser parseResult = RC_BordroGirParser.parse(response.getBody());
                
                resp.bordroGirResponse = parseResult;
                return resp;
            }
            
            return resp;
            
        }
        
        catch(Exception ex){
            system.debug('ex : ' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_BordroGirIntegrator', 'Integrator Error', ex.getMessage(), 'RC_BordroGirIntegrator', 'getBordroGir', '');

            return null;
        }
    }
    
}