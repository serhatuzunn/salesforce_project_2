public class RC_BI_GetTokenCiroIntegrator {
    
    public static string GetToken(){
        try {
            
            String url = 'http://212.29.90.76/WEBSERVICES/bipapp/BIPapp/getBWToken';
            
            HttpRequest request = new HttpRequest();
            request = basicAuthentication(request);
            
            request.setEndpoint(url);
            request.setMethod('POST');            
            request.setHeader('Content-Type','application/json');        
            request.setTimeout(120000);
            request.setHeader('Content-Length','0');   
            Http http = new Http();            
            system.debug('Get Pos Request :' + request.getBody());
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                system.debug('Get Pos response :' + response.getStatus());
                if(response.getStatus() == 'OK'){
                    system.debug('Get Pos Result Body : ' + response.getBody());
                    string result = response.getBody();
                    return result;
                }
            }
            else{
                HttpResponse response = http.send(request);
                system.debug('Get Pos response catch :' + response.getStatus());
                
            }
            
            
        }
        
        catch(Exception e){
            system.debug('createToken Error catch :' + e.getMessage());
            RC_Logger.LOG_EXCEPTION('createToken  Error', e.getMessage(), e.getStackTraceString(), 'RC_BI_GetTokenCiroIntegrator', 'finish', '');            
        }
        
        return null; 
    }
    
    private static HTTPRequest basicAuthentication(HTTPRequest req1){
        Blob headerValue = Blob.valueOf('web_ritmus:ritmus*2021');
        req1.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
        return req1;
    }
    
}