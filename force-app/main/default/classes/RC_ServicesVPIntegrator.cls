public class RC_ServicesVPIntegrator {
    public class requestModel{
        public String IV_ILCE_KODU;
        public String IV_IL_KODU;
        public String IV_SEMT_KODU;
        public String IV_YETKI_KODU;
    }
    public class responseModel{        
        @AuraEnabled
        public RC_ServicesVPJsonParser.ET_INFO ET_INFO {get;set;}        
    }
    
    
    public static responseModel getServicesVP(requestModel req){
        try {
            responseModel resp = new responseModel();
            resp.ET_INFO = new RC_ServicesVPJsonParser.ET_INFO();
            
            String url = 'RESTAdapter/salesforce/crm_competence_list';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                RC_ServicesVPJsonParser parseResult = RC_ServicesVPJsonParser.parse(response.getBody());
                
                if(parseResult.ET_INFO.item !=null && parseResult.ET_INFO.item.size()>0){
                    resp.ET_INFO.item = parseResult.ET_INFO.item;
                }
            }
            
            system.debug('resp getServicesVP:' + resp);  
            
            return resp;
            
        }
        catch(Exception e){
            system.debug('excp getServicesVP :' + e);
            return null;
        }
    }
}