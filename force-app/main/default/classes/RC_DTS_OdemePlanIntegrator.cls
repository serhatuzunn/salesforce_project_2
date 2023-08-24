public class RC_DTS_OdemePlanIntegrator {
    
    public class requestModel{
        @AuraEnabled
        public string BORDRONO {get;set;}
        @AuraEnabled
        public string DEBUG {get;set;}
        @AuraEnabled
        public string OPERASYON {get;set;}
        @AuraEnabled
        public ODEMEPLANDB ODEMEPLANDB {get;set;}
    }

    public class ODEMEPLANDB {
        @AuraEnabled
        public List<item> item {get;Set;}
    }

    public class item {
        @AuraEnabled
        public string CEKNO {get;set;}
        @AuraEnabled
        public string BORDRO {get;set;}
        @AuraEnabled
        public string BORDROTYPE {get;set;}
        @AuraEnabled
        public string KUNNR {get;set;}
        @AuraEnabled
        public string KALEM {get;set;}
        @AuraEnabled
        public string TARIH {get;set;}
        @AuraEnabled
        public string TUTAR {get;set;}
        @AuraEnabled
        public string WAERS {get;set;}
        @AuraEnabled
        public string STATUS {get;set;}
        @AuraEnabled
        public string ISLEMTARIHI {get;set;}
        @AuraEnabled
        public string BELNR {get;set;}
        @AuraEnabled
        public string GJAHR {get;set;}
    }

    public class responseModel{
        @AuraEnabled
        public string EV_MESSAGE {get;set;}
        @AuraEnabled
        public ODEMEPLANDB ODEMEPLANDB {get;set;}
        @AuraEnabled
        public Boolean isSuccess {get;set;}
    }

    @AuraEnabled
    public static responseModel getDTSOdemePlan(requestModel reqModel){
        responseModel result = new responseModel();

        String url = 'RESTAdapter/salesforce/fi_odeme_plan';
        HttpRequest request = new HttpRequest();
        request.setBody(json.serialize(reqModel,true));
        request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;');
        request.setTimeout(120000);
        Http http = new Http();
        System.debug('getDTSOdemePlan Req : ' + request.getBody());
        HttpResponse response = http.send(request);
        System.debug('getDTSOdemePlan Resp : ' + response.getBody());

        if(response.getStatus() == 'OK'){
            result = (responseModel)JSON.deserialize(response.getBody(), responseModel.class);
            result.isSuccess = true;
            return result;
        }else{
            result.isSuccess = false;
            return result;
        }
        
        
    }

}