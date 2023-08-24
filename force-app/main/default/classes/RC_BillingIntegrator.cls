public class RC_BillingIntegrator {
    
    public class RequestWrapper
    {
        public string IV_VBELN {get;set;}
        public string IV_ERDAT_BEG{get;set;}
        public string IV_ERDAT_END{get;set;}
        public string IV_TIME_BEG{get;set;}
        public string IV_TIME_END{get;set;}
        public Integer IV_PACKAGE {get; set;}
        public Integer IV_INDEX {get; set;}
    }
    
    
    public class ResponseWrapper{
        public RC_BillingIntegratorParser.ET_RETURN response {get;set;}
        public Integer totalIndex {get; set;}
    }
    
    public static ResponseWrapper getBilling(RequestWrapper requestData) { 
        
            ResponseWrapper rw = new ResponseWrapper();
        try
        {
            String url = 'RESTAdapter/salesforce/sd_billing';            
            HttpRequest req = new HttpRequest();
            system.debug('req:' + json.serialize(requestData));
            req.setBody(json.serialize(requestData));
            req.setEndpoint(('callout:PoqaZorluAPI' + '/' + url));
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.setTimeout(120000);        
            Http http = new Http();    
            
            
            HttpResponse res = http.send(req);
            system.debug(res.getBody()); 
            
            if(res.getStatus() == 'OK')
            {
                Map < String,Object > resultsMap = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
                Map<String, Object> parseResult = (Map<String, Object>) resultsMap.get('ET_RETURN');
                string str = JSON.serialize(parseResult);
                RC_BillingIntegratorParser billings = RC_BillingIntegratorParser.parse(res.getBody()); 
                system.debug('billings: ' + billings);
                rw.response = billings.ET_RETURN;
                rw.totalIndex = billings.EV_TOTAL_IND;
                
                return rw;
            }
            return rw;
        }
        catch(Exception e){
            RC_Logger.LOG_EXCEPTION('Error : RC_BillingIntegrator', 'Integrator Error', e.getMessage(), 'RC_BillingIntegrator', 'getBilling', '');
            return rw;
        }
    }
}