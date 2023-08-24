public with sharing class  RC_CRMServiceBelirleIntegrator{
    public class requestModel{
        public String IV_ENTG_ID;
        public String IV_ILCE_KODU;
        public String IV_IL_KODU;
        public String IV_SEMT_KODU;
        public String IV_URUN_KODU;
    }
    public class responseModel{        
        @AuraEnabled
        public RC_CRMServiceBelirleJsonParser.ET_SERVIS ET_SERVIS {get;set;}  
        @AuraEnabled
        public String EV_MESAJ_NO {get;set;} 
        @AuraEnabled
        public String EV_MESAJ_TXT {get;set;}       
    }
    
    public static responseModel getServices(requestModel req){
        try {
            responseModel resp = new responseModel();
            resp.ET_SERVIS = new RC_CRMServiceBelirleJsonParser.ET_SERVIS();
            
            String url = 'RESTAdapter/salesforce/sd_entg_servis_belirle';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                RC_CRMServiceBelirleJsonParser parseResult = RC_CRMServiceBelirleJsonParser.parse(response.getBody());
                
                if(parseResult.ET_SERVIS.item !=null && parseResult.ET_SERVIS.item.size()>0){
                    resp.ET_SERVIS.item = parseResult.ET_SERVIS.item;
                }
                resp.EV_MESAJ_NO = parseResult.EV_MESAJ_NO;
                resp.EV_MESAJ_TXT = parseResult.EV_MESAJ_TXT;
            }
            
            system.debug('resp getServices:' + resp);  
            
            return resp;
            
        }
        catch(Exception e){
            system.debug('excp getServices :' + e);
            return null;
        }
    }    
}