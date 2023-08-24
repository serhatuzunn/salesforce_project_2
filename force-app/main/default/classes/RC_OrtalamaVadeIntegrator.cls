public class RC_OrtalamaVadeIntegrator {
    
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
        public String AWKEY {get;set;}
        public String GJAHR {get;set;}
        public String ZLSPR {get;set;}
        public String ZLSCH {get;set;}
        public String LTEXT {get;set;}
        public String MATNR {get;set;}
        public String MAKTX {get;set;}
        public String MENGE {get;set;}
        public String MEINS {get;set;}
    }
    
    public class ET_ITEMS {
        public Item item {get;set;}
    }
    
    public class RequestModel {
        public String IV_BUKRS {get;set;}
        public String IV_KEYDATE {get;set;}
        public String IV_KKBER {get;set;}
        public ET_ITEMS ET_ITEMS {get;set;}
    }
    
    public class ResponseModel{
        @AuraEnabled
        public RC_OrtalamaVadeParser ortalamaVadeResponse {get;set;}
    }
    
    public static ResponseModel getAcikKalemler(requestModel req){
        try {
            String url = 'RESTAdapter/salesforce/fi_ortalama_vade';
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
                RC_OrtalamaVadeParser parseResult = RC_OrtalamaVadeParser.parse(response.getBody());
                
                resp.ortalamaVadeResponse = parseResult;
                system.debug(resp);
                return resp;
            }
            
            return resp;
            
        }
        
        catch(Exception ex){
            system.debug('ex : ' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_OrtalamaVadeIntegrator', 'Integrator Error', ex.getMessage(), 'RC_OrtalamaVadeIntegrator', 'getAcikKalemler', '');

            return null;
        }
    }
    
}