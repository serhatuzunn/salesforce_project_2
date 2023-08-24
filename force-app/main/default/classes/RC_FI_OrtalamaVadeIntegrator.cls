public with sharing class RC_FI_OrtalamaVadeIntegrator {
    public class item {
        @AuraEnabled
        public string BLINE_DATE {get;set;}
        @AuraEnabled
        public string DSCT_DAYS1 {get;set;}
        @AuraEnabled
        public string PSTNG_DATE {get;set;}
        @AuraEnabled
        public string DB_CR_IND {get;set;}
        @AuraEnabled
        public string LC_AMOUNT {get;set;}

    }
    public class requestModel {
        public IT_LINEITEMS IT_LINEITEMS {get;set;}
    }

    public class IT_LINEITEMS{
        @AuraEnabled
        public List<item> item {get;set;}
    }

    public class responseModel{
        @AuraEnabled
        public List<RC_FI_OrtalamaVadeJsonParser.Item> respItemList {get;set;}
        @AuraEnabled
        public string EV_BAKIYE {get;set;}
        @AuraEnabled
        public string EV_ORTVADE {get;set;}
    }

    @AuraEnabled
    public static responseModel FI_OrtalamaVadeBul(requestModel req){
        try {
            String url = 'RESTAdapter/salesforce/fi_ortvade_bul';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            System.debug('OrtalamaVadeBul request : ' + request.getBody());
            HttpResponse response = http.send(request);
            
            responseModel resp = new responseModel();
            if(response.getStatus() == 'OK'){
                System.debug('OrtalamaVadeBul responseBody : ' + response.getBody());
                RC_FI_OrtalamaVadeJsonParser parseResult = RC_FI_OrtalamaVadeJsonParser.parse(response.getBody());
                System.debug('OrtalamaVadeBul parseResult : ' + parseResult);
                resp.respItemList = parseResult.IT_LINEITEMS.item;
                resp.EV_BAKIYE    = parseResult.EV_BAKIYE;
                resp.EV_ORTVADE   = parseResult.EV_ORTVADE;
                return resp;
            }
            
            return resp;
            
        }
        
        catch(Exception ex){
            system.debug('ex : ' + ex);
            return null;
        }
        
    }

}