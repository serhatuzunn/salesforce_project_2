public class RC_CekGirIntegrator {
    
    public class Item {
        public String MANDT;
        public String BORDRO;
        public String BORDROTYP;
        public String TARIH_BAS;
        public String TARIH_BIT;
        public String TUTAR;
        public String STATUS;
        public String KUNNR;
        public String NAME1;
        public String NAME2;
        public String VADE;
        public String VADE_KUN;
        public String WAERS;
        public String SALLAMA;
        public String ERDAT;
        public String ERNAM;
        public String KKBER;
        public String VKBUR;
        public String ZLSCH;
        public String MONAT;
        public String GJAHR;
    }
    
    public class BORDROLAR {
        public Item item;
    }
    
    public class Item_Z {
        public String CEKNO;
        public String TARIH;
        public String BANKL;

    }
    
    public class CEKLER {
        public List<Item_Z> item;
    }
    
    public class RequestModel {
        @AuraEnabled
        public String BATCHMOD {get;set;}
        @AuraEnabled
        public String DEBUG {get;set;}
        @AuraEnabled
        public String EKSIKKAYIT {get;set;}
        @AuraEnabled
        public String FORCE {get;set;}
        @AuraEnabled
        public String LOG {get;set;}
        @AuraEnabled
        public String OPERASYON {get;set;}
        @AuraEnabled
        public BORDROLAR BORDROLAR {get;set;}
        @AuraEnabled
        public CEKLER CEKLER {get;set;}
    }
    
    public class ResponseModel{
        @AuraEnabled
        public RC_CekGirIntegratorResponseParser CekGirResponse {get;set;}
    }
    
    public static ResponseModel getCekGir(RequestModel req){
        try {
            String url = 'RESTAdapter/salesforce/fi_cek_gir';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('Get getCekGir req Body : ' + json.serialize(req));

            HttpResponse response = http.send(request);
            system.debug('Get getCekGirresponse : ' + response);
            ResponseModel resp = new ResponseModel();
            
            system.debug('Get getCekGir Result Body : ' + JSON.Serialize( response.getBody()));
            
                if(response.getStatus() == 'OK'){
                    RC_CekGirIntegratorResponseParser parseResult = RC_CekGirIntegratorResponseParser.parse(response.getBody());                    
                    resp.CekGirResponse = parseResult;
                }
            return resp;            
        }
        
        catch(Exception ex){
            system.debug('ex cekgir: ' + ex);
            return null;
        }
    }
    
}