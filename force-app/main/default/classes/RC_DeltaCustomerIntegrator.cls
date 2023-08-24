public class RC_DeltaCustomerIntegrator {
    public class RequestModel   {
        public String IV_YARAT_TRH { get; set; }
        public String IV_TANIM { get; set; } 
        public String IV_DEGIS_TRH { get; set; } 
    }
    
    public static RC_DeltaCustomerIntegratorParser getDeltaCustomer(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_delta_customer';
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
                RC_DeltaCustomerIntegratorParser parseResult = RC_DeltaCustomerIntegratorParser.parse(response.getBody());
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