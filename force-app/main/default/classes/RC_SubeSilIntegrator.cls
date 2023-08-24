public class RC_SubeSilIntegrator {
    public class IS_SUBE_VERILERI {
        public String KUNNR { get; set; } 
        public String VKORG { get; set; }
        public String VTWEG { get; set; }
        public String SPART { get; set; }
    }
    
    public class RequestModel   {
        public IS_SUBE_VERILERI IS_SUBE_VERILERI { get; set; } 
        public String IV_SUBE { get; set; } 
        public String IV_BAYI { get; set; } 
    }
    
    public static RC_SubeSilIntegratorParser getSubeSil(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_sube_sil';
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
                RC_SubeSilIntegratorParser parseResult = RC_SubeSilIntegratorParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);
                
                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
            RC_Logger.LOG_EXCEPTION(ex.getMessage(), ex.getMessage(), '', 'RC_SubeSilIntegrator', 'getSubeSil', '');

        }
        return null;
    }
}