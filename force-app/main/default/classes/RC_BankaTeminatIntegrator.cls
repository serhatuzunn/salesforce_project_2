public class RC_BankaTeminatIntegrator {
    
    public class RequestModel{
        public String IV_BUKRS {get;set;} 
        public String IV_DAYS {get;set;} 
        public String IV_INDEX {get;set;} 
        public String IV_KKBER {get;set;} 
        public String IV_KUNNR {get;set;}   
        public String IV_PACKAGE {get;set;}   
    }
    
    public class ResponseModel{
        public Integer EV_TOTAL_IND {get;set;}
        public List<RC_BankaTeminatIntegratorParser.Item> Items {get;set;} 
    }
    
    public static ResponseModel getBankaTeminat(RequestModel req){
        try{
            String url = 'RESTAdapter/salesforce/fi_sforce_bnk_teminat';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            HttpResponse response = http.send(request);
            system.debug(response.getBody());
            if(response.getStatus() == 'OK'){
                RC_BankaTeminatIntegratorParser parseResult = RC_BankaTeminatIntegratorParser.parse(response.getBody());
                
                ResponseModel responseModel = new ResponseModel();
                responseModel.EV_TOTAL_IND = parseResult.EV_TOTAL_IND;
                responseModel.Items = parseResult.ET_RETURN.item;
                return responseModel;
            }
        }
        catch(Exception ex){
            system.debug('hata ' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_BankaTeminatIntegrator', 'Integrator Error', ex.getMessage(), 'RC_BankaTeminatIntegrator', 'getBankaTeminat', '');
        }
        
        return null;
        
    }
    
    
}