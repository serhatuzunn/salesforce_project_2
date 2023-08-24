public class RC_EmanetStokListIntegrator {
    
    public class Item {
		public String MATNR;
	}

	public class IT_MATNR  {
		public List<Item> item;
	}

	public class IT_WERKS  {
		public List<Item_Z> item;
	}

	public class Item_Z {
		public String WERKS;
	}

    public class RequestModel{
        @AuraEnabled      
        public IT_MATNR IT_MATNR { get; set; }
        @AuraEnabled
        public IT_WERKS IT_WERKS { get; set; }
        @AuraEnabled
        public string IV_KUNNR { get; set; }
        @AuraEnabled
        public string IV_SOBKZ { get; set; }
        @AuraEnabled
        public string IV_YALNIZCA_STOKLU { get; set; }
    }

     public static RC_EmanetStokListIntegratorParser getEmanetStokList(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_emnt_stok_list';
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
                RC_EmanetStokListIntegratorParser parseResult = RC_EmanetStokListIntegratorParser.parse(response.getBody());
                system.debug('parseResult : ' + parseResult);
                
                return parseResult;
            }
        }
        catch(Exception ex){
            System.debug('Hata : ' + ex.getMessage());
            RC_Logger.LOG_EXCEPTION('Error : RC_EmanetStokListIntegrator', 'Integrator Error', ex.getMessage(), 'RC_EmanetStokListIntegrator', 'getEmanetStokList', '');
        }
        return null;
    }
    
    
}