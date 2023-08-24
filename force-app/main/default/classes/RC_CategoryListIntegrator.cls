public class RC_CategoryListIntegrator {
    
    public class ResponseModel{
        @AuraEnabled
        public RC_CategoryListIntegratorParser CategoryListResponse {get;set;}
    }
    
    public static ResponseModel getCategoryList(){
        try {
            String url = ' https://www.vestel.com.tr/Mobile2/mbProduct/CategoryList';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            ResponseModel resp = new ResponseModel();
            if(response.getStatus() == 'OK'){
                RC_CategoryListIntegratorParser parseResult = RC_CategoryListIntegratorParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);
                
                resp.CategoryListResponse = parseResult;
            }
            
            return resp;
        }      
        catch(Exception ex){
            system.debug('ex : ' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_CategoryListIntegrator', 'Integrator Error', ex.getMessage(), 'RC_CategoryListIntegrator', 'getCategoryList', '');

            return null;
        }
    }
    
}