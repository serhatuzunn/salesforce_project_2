public class RC_AcikKalemlerIntegrator {
    
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
        public String IV_KUNNR {get;set;}
        public String IV_ODK {get;set;}
        public String IV_SURID {get;set;}
        public integer IV_PACKAGE {get;set;}
        public integer IV_INDEX {get;set;}
        public string IV_VADET {get;set;}
    }
    
    public class ResponseModel{
        @AuraEnabled
        public RC_AcikKalemlerParser acikKalemlerResponse {get;set;}
    }
    
    public static ResponseModel getAcikKalemler(RequestModel req){
        try {
            String url = 'RESTAdapter/salesforce/fi_acik_kalemler';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req,true));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            ResponseModel resp = new ResponseModel();
            if(response.getStatus() == 'OK'){
                System.debug('Acikkalemler responseBody : ' + response.getBody());
                RC_AcikKalemlerParser serializedData = (RC_AcikKalemlerParser)JSON.deserialize(response.getBody(), RC_AcikKalemlerParser.class);
                // RC_AcikKalemlerParser parseResult = RC_AcikKalemlerParser.parse(response.getBody());
                // System.debug('Acikkalemler parseResult : ' + parseResult);
                resp.acikKalemlerResponse = serializedData;
                return resp;
                
            }
            
            return resp;
            
        }
        
        catch(Exception ex){
            system.debug('ex : ' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_AcikKalemlerIntegrator', 'Integrator Error', ex.getMessage(), 'RC_AcikKalemlerIntegrator', 'getAcikKalemler', '');

            return null;
        }
    }
    
}