public class RC_ProductListIntegrator {

    public class ResponseModel{
        @AuraEnabled
        public RC_ProductListIntegratorParser ProductListResponse {get;set;}
    }
    
    public static ResponseModel getProductList(String categoryId, String pageId){
        try {
            String url = 'https://www.vestel.com.tr/Mobile2/mbProduct/ProductList?CategoryID=' + categoryId + '&page=' + pageId;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            ResponseModel resp = new ResponseModel();
            if(response.getStatus() == 'OK'){
                system.debug('response.getBody() : ' + response.getBody());
                //RC_ProductListIntegratorParser parseResult = RC_ProductListIntegratorParser.parse(response.getBody().replace('NaN', '""')); //NaN değer için parser hatası giderildi.
				RC_ProductListIntegratorParser parseResult = (RC_ProductListIntegratorParser)JSON.deserialize(response.getBody().replace('NaN', '""'), RC_ProductListIntegratorParser.class);
                system.debug('parseResult : ' + parseResult);
                
                resp.ProductListResponse = parseResult;
            }
            
            return resp;
        }      
        catch(Exception ex){
            system.debug('ex : ' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_ProductListIntegrator', 'Integrator Error', ex.getMessage(), 'RC_ProductListIntegrator', 'getProductList', '');

            return null;
        }
    }
}