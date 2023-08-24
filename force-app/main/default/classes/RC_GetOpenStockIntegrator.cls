public class RC_GetOpenStockIntegrator {
 public class Item    {
        public String VSTEL { get; set; }
        public String MATNR { get; set; } 
        public String KUNNR { get; set; } 
        public string VKBUR 	{get;set;}
        public string VKGRP 	{get;set;}
        public string VKORG 	{get;set;}
        public string VTWEG 	{get;set;}
    }
    
    public class IT_INPUT    {
        public List<Item> item { get; set; } 
    }
    
    public class RequestModel   {
        public IT_INPUT IT_INPUT { get; set; } 
    }
    
    public static RC_GetOpenStockParser getSendOpenStock(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_open_orders';
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
                RC_GetOpenStockParser parseResult = RC_GetOpenStockParser.parse(response.getBody());
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