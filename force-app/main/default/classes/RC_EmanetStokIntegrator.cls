public class RC_EmanetStokIntegrator {

     public class Item    {
         
       public string MATNR {get;set;}     
    }
    
    public class Item_W    {
         
        public string WERKS {get;set;} 
         
    }
    
      public class IT_INPUT    {
        public List<Item> item { get; set; } 
    }
    
    public class IT_INPUT_W    {
        public List<Item_W> item { get; set; } 
    }
    
    
    public class requestModel   {
        public IT_INPUT IT_MATNR { get; set; }  
      	public IT_INPUT_W IT_WERKS { get; set; } 
        public string IV_YALNIZCA_STOKLU {get;set;}
        public string IV_SOBKZ 	{get;set;}
        public string IV_KUNNR 	{get;set;}
        
    }

    public static RC_EmanetStokIntegratorParser getEmanetStok(requestModel req) {    
        
        try{
            String url = 'RESTAdapter/salesforce/sd_emnt_stok_list';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            system.debug('request.setBody() :' + json.serialize(req));
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
                RC_EmanetStokIntegratorParser  parseResult = RC_EmanetStokIntegratorParser.parse(response.getBody());
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