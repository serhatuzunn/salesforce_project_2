public class RC_DTSBordroKalemSilIntegrator {

    public class requestModel {
        @AuraEnabled
        public T_ITEMS T_ITEMS {get;set;}
    }

    public class T_ITEMS {
        public List<item> item {get;set;}
    }

    public class item {
        @AuraEnabled
        public string BORDRO {get;set;}
        @AuraEnabled
        public string BELNR {get;set;}
        @AuraEnabled
        public string GJAHR {get;set;}
    }

    public class responseModel {
        @AuraEnabled
        public RC_DTSBordroKalemSilParser kalemSilResponse {get;set;}
    }

    public static responseModel DTSBordroKalemSil(requestModel reqModel){
        responseModel result = new responseModel();

        String url = 'RESTAdapter/salesforce/fi_dts_bordro_kalem_sil';
        HttpRequest request = new HttpRequest();
        request.setBody(json.serialize(reqModel,true));
        request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;');
        request.setTimeout(120000);
        Http http = new Http();
        System.debug('DTSBordroKalemSil Req : ' + request.getBody());
        HttpResponse response = http.send(request);
        System.debug('DTSBordroKalemSil Resp : ' + response.getBody());
        
        RC_DTSBordroKalemSilParser parseResult = RC_DTSBordroKalemSilParser.parse(response.getBody());
        result.kalemSilResponse = parseResult;
        return result;
        
    }
    
}