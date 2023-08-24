public class RC_BayiCekSenetIntegrator {
    
    public class responseModel{
        @AuraEnabled
        public RC_BayiCekSenetIntegratorParser.ET_RETURN etReturn {get;set;}
    }
    
    public static responseModel getBayiCekSenet(RC_CreditRiskIntegrator.requestModel req) {    
        try{
            responseModel res= new responseModel();
            String url = 'RESTAdapter/salesforce/bayi_cek_senet';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('resuest : ' + json.serialize(req));
            HttpResponse response = http.send(request);
            
            if(response.getStatus() == 'OK'){
                system.debug('Get Pos Result Body : ' + response.getBody());
                RC_BayiCekSenetIntegratorParser parseResult = RC_BayiCekSenetIntegratorParser.parse(response.getBody());
                res.etReturn = parseResult.ET_RETURN;
                system.debug('response:' + response);
                
            }
            return res;
        }
        catch(Exception e){
            system.debug('cekSenetException:' + e);
            return null;
        }
        
    }
    
}