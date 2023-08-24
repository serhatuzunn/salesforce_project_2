public class RC_GetGiftVoucherStatuIntegrator{
 	
    public class RequestModel{
        public String IV_BAYI { get; set; } 
        public String IV_CEKNO { get; set; } 
        public String IV_DURUM { get; set; } 
    }
    
    public static RC_GetGiftVoucherStatuParser getSendGiftVoucherStatu(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/crm_hedcek_b2b_durum';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            System.debug('request.getBody() :' + request.getBody());
            HttpResponse response = http.send(request);
            System.debug('response.getBody() :' + response.getBody());
            System.debug('response.getStatus() :' + response.getStatus());
            if(response.getStatus() == 'OK'){
                RC_GetGiftVoucherStatuParser parseResult = RC_GetGiftVoucherStatuParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);

                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
        }
        return null;
        
    }
}