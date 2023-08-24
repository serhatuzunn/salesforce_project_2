public class RC_SubeYaratIntegrator {

    public class IS_SUBE_VERILERI {
        public String ADRNR { get; set; } 
        public String NAME1 { get; set; }
        public String NAME2 { get; set; }
        public String NAME3 { get; set; }
        public String NAME4 { get; set; }
        public String ERDAT { get; set; }
        public String LOCCO { get; set; }
        public String CITY1 { get; set; }
        public String CITY2 { get; set; }
        public String LZONE { get; set; }
        public String REGION { get; set; }
        public String TEL_NUMBER { get; set; }
        public String FAX_NUMBER { get; set; }
        public String SMTP_ADDR { get; set; }
        public String VKORG { get; set; }
        public String VTWEG { get; set; }
        public String SPART { get; set; }
        public String ENLEM { get; set; }
        public String BOYLAM { get; set; }
        public String ORT01 { get; set; }
        public String LAND1 { get; set; }
    }
    
    public class RequestModel   {
        public IS_SUBE_VERILERI IS_SUBE_VERILERI { get; set; } 
        public String IV_BAYI { get; set; } 
        public String IV_SUBE { get; set; } 
    }
    
    public static RC_SubeYaratIntegratorParser getSubeYarat(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_sube_yarat';
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
                RC_SubeYaratIntegratorParser parseResult = RC_SubeYaratIntegratorParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);
                
                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
            RC_Logger.LOG_EXCEPTION(ex.getMessage(), ex.getMessage(), '', 'RC_SubeYaratIntegrator', 'getSubeYarat', '');

        }
        return null;
    }
}