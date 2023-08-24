public class RC_FI_DTS_BordroSilIntegrator {
    public class requestModel{
        @AuraEnabled
        public T_BORDRO T_BORDRO {get;set;}
    }

    public class T_BORDRO {
        @AuraEnabled
        public List<item> item {get;set;}
    }

    public class item{
        @AuraEnabled
        public string BORDRO {get;set;}
    }

    public class responseModel{
        @AuraEnabled
        public string DURUM {get;set;}
    }

    @AuraEnabled
    public static string bordroSil(requestModel reqModel){
        String url = 'RESTAdapter/salesforce/fi_dts_bordrosil';
        HttpRequest request = new HttpRequest();
        request.setBody(json.serialize(reqModel,true));
        request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;');
        request.setTimeout(120000);
        Http http = new Http();
        System.debug('BordroSil Req : ' + request.getBody());
        HttpResponse response = http.send(request);
        System.debug('BordroSil Resp : ' + response.getBody());
        if(response.getStatus() == 'OK'){
            responseModel result = (responseModel)JSON.deserialize(response.getBody(), responseModel.class);
            return result.DURUM;
        }
        return 'error';
       
    }

    
}