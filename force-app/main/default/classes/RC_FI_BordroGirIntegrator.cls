public with sharing class RC_FI_BordroGirIntegrator {


    public class Item {
        @AuraEnabled
        public String BELNR {get;set;}
        @AuraEnabled
        public String BUZEI {get;set;}
        @AuraEnabled
        public String KUNNR {get;set;}
        @AuraEnabled
        public String BUDAT {get;set;}
        @AuraEnabled
        public String ZFBDT {get;set;}
        @AuraEnabled
        public String WAERS {get;set;}
        @AuraEnabled
        public String DMBTR {get;set;}
        @AuraEnabled
        public String SGTXT {get;set;}
        @AuraEnabled
        public String BLART {get;set;}
        @AuraEnabled
        public String VKBUR {get;set;}
        @AuraEnabled
        public String UMSKZ {get;set;}
    }
    
    public class IT_ITEMS {
        @AuraEnabled
        public List<Item> item {get;set;}
    }
    
    public class RequestModel {
        @AuraEnabled
        public String IV_ODK {get;set;}
        @AuraEnabled
        public String IV_KUNNR {get;set;}
        @AuraEnabled
        public String IV_KKBER {get;set;}
        @AuraEnabled
        public IT_ITEMS IT_ITEMS {get;set;}
    }
    
    public class responseModel{
        @AuraEnabled
        public string BORDRONO {get;set;}
        @AuraEnabled
        public string EV_BAKIYE {get;set;}
        @AuraEnabled
        public string EV_KKBER {get;set;}
        @AuraEnabled
        public string EV_MESSAGE {get;set;}
        @AuraEnabled
        public string EV_ORTVADE {get;set;}
        @AuraEnabled
        public string EV_SUCCESS {get;set;}
        @AuraEnabled
        public string bordroId {get;set;}
    }


    @AuraEnabled
    public static responseModel BordroGir(RequestModel req){
        responseModel result = new responseModel();
        try {
            String url = 'RESTAdapter/salesforce/fi_bordro_gir';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            System.debug('BordroGir Req : ' + request.getBody());
            HttpResponse response = http.send(request);
            System.debug('BordroGir Resp : ' + response.getBody());
            if(response.getStatus() == 'OK'){
                result = (responseModel)JSON.deserialize(response.getBody(),responseModel.class);
                return result;
            }
            return result;

        }catch(Exception ex){
            system.debug('ex : ' + ex);
            return null;
        }
    }
}