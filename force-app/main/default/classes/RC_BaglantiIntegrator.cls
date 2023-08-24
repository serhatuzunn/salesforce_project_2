public class RC_BaglantiIntegrator {
    public class requestModel{
        public string IV_BUKRS 	{get;set;}
        public string IV_KKBER 	{get;set;}
        public string IV_KUNNR 	{get;set;}
    }
    public class responseModel{
        @AuraEnabled
        public RC_SD_BaglantiParser.ET_RETURN etReturn {get;set;}
    }
    
    public static responseModel getBaglanti(requestModel req){
        try {
            responseModel resp = new responseModel();
            String url = 'RESTAdapter/salesforce/fi_baglanti';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            HttpResponse response = http.send(request);            
            if(response.getStatus() == 'OK'){
                RC_SD_BaglantiParser parseResult = RC_SD_BaglantiParser.parse(response.getBody());
                system.debug('getBaglanti parseResult : ' + parseResult);
                resp.etReturn = parseResult.ET_RETURN;
                system.debug('response:' + response);
            }
            return resp; 
        }
        
        catch(Exception e){
            system.debug('exception:' + e);
            return null;
        }
    }
}