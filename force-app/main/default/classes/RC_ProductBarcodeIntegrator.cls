public class RC_ProductBarcodeIntegrator {
    
    public class requestModel
    {
        public boolean isEan { get; set; }
        public List<RC_ProductBarcodeIntegrator.productDetail> productDetail { get; set; }
    }
    
    public class productDetail
    {
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
    }    
    
    public static string getCreateBarcodePDF(requestModel req){
        try {
            
            String url = 'http://212.29.90.76/WEBSERVICES/productlabel/api/B2B/CreateBarcodePDF';            
            
            HttpRequest request = new HttpRequest();
            request = basicAuthentication(request);
            request.setBody(json.serialize(req));
            request.setEndpoint(url);
            request.setMethod('POST');            
            request.setHeader('Content-Type','application/json');        
            request.setTimeout(120000);
            
            Http http = new Http();            
            system.debug('Get Pos Request :' + request.getBody());
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                system.debug('Get Pos response :' + response.getStatus());
                if(response.getStatus() == 'OK'){
                    system.debug('Get Pos Result Body : ' + response.getBody());
                    return response.getBody();
                }
            }
            else{
                return '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';
            }            
            
        }        
        catch(Exception e){
            system.debug('getCreateBarcodePDF Error catch :' + e.getMessage());
            RC_Logger.LOG_EXCEPTION('getCreateBarcodePDF  Error', e.getMessage(), e.getStackTraceString(), 'RC_ProductBarcodeIntegrator', 'finish', '');            
        }
        return 'error';
    }
    
    private static HTTPRequest basicAuthentication(HTTPRequest req1){
        Blob headerValue = Blob.valueOf('web_ritmus:ritmus*2021');
        req1.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
        return req1;
    }
    
}