public with sharing class SAPServiceIntegrator {
    public static HttpResponse callSAPService(String url, Map<String, String> header, String method, String body) {
        HttpResponse response = null;

            HttpRequest request = new HttpRequest();
            request.setBody(body);
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod(method);
            request.setTimeout(120000);
            
            if(header != null){
                for(String key : header.keySet()){
                    request.setHeader(key, header.get(key));                
                }
            }

            response = new Http().send(request);

            return response;
    }
}