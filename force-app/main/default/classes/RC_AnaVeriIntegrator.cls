public class RC_AnaVeriIntegrator {
    
    public class RequestModel   {
        public String IV_TANIM { get; set; }
        public String IV_VKORG { get; set; } 
        public String IV_VTWEG { get; set; } 
        public String IV_PACKAGE { get; set; } 
        public String IV_INDEX { get; set; } 
    }
    
    public static RC_AnaVeriIntegratorParser getAnaVeri(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_entg_anaveri_malz';
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
                RC_AnaVeriIntegratorParser parseResult = RC_AnaVeriIntegratorParser.parse(response.getBody());
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