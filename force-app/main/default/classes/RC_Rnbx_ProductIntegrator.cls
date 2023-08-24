public class RC_Rnbx_ProductIntegrator {

    public class ResponseModel{
        @AuraEnabled
        public RC_Rnbx_ProductIntegratorParser productIntegratorParser {get;set;}
    }

    public static ResponseModel getProduct(String productId){
        try {
            String url = 'https://www.vestel.com.tr/Mobile2/mbProduct/ProductDetail?productId=' + productId;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            ResponseModel responseModel = new ResponseModel();
            if(response.getStatus() == 'OK'){
                RC_Rnbx_ProductIntegratorParser parseResult = RC_Rnbx_ProductIntegratorParser.parse(response.getBody());
                responseModel.productIntegratorParser = parseResult;
            }
            
            
            system.debug('responseModel : ' + responseModel);
            return responseModel;
            
        }
        
        catch(Exception ex){
            system.debug('excp:' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_Rnbx_ProductIntegrator', 'ntegrator Error', ex.getMessage(), 'RC_Rnbx_ProductIntegrator', 'getProduct', '');

            return null;
        }
    }
}