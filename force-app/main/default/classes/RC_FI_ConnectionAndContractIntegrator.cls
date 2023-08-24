public class RC_FI_ConnectionAndContractIntegrator {
    
    public class RequestWrapper{
        public IT_ODEME_PLAN IT_ODEME_PLAN {get;set;}
        public IT_SOZLESME IT_SOZLESME {get;set;}
    }
    
    public class IT_ODEME_PLAN{
        public List<Item> item{get;set;}
    }
    
    public class IT_SOZLESME{
        public List<Item> item{get;set;}
    }
    
    public class Item{
        public string MANDT { get; set; }
        public string GJAHR { get; set; }
        public string KUNNR { get; set; }
        public string ZLSCH { get; set; }
        public string KKBER { get; set; }
        public string ROW_NO { get; set; }
        public string BORDROTIPI { get; set; }
        public string PORTFOY { get; set; }
        public string SMCTR { get; set; }
        public string CVDTE { get; set; }
        public string START_DATE { get; set; }
        public string END_DATE { get; set; }
        public string TIMESTAMP { get; set; }
        public string USERNAME { get; set; }
        public string VARIANT { get; set; }
        public string ZTERM { get; set; }
        public string GJAHR_ZLSCH { get; set; }
        public string LAST_DATE { get; set; }
        public string LAST_TIME { get; set; }
    }
    
        public static RC_BordroCancelIntegratorParser FI_ConnectionAndContractFunction(RequestWrapper req) {    
        try{
            
            String url = 'RESTAdapter/salesforce/fi_blg_sozlesme';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('request : ' + json.serialize(req));
            RC_BordroCancelIntegratorParser res = new RC_BordroCancelIntegratorParser();
            
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                if(response.getStatus() == 'OK'){
                    system.debug('Get Pos Result Body : ' + response.getBody());
                    res = RC_BordroCancelIntegratorParser.parse(response.getBody());
                    system.debug('response:::' + res);	     
                }
            }
            else{
                res = RC_BordroCancelIntegratorParser.parse('{"EV_FLAG":"S","EV_RETURN":"İşlem başarılı bir şekilde tamamlandı.","IT_ODEME_PLAN":{"item":[{"MANDT":1,"GJAHR":"0001","KUNNR":"0020300066","ZLSCH":"A","KKBER":1,"ROW_NO":1,"BORDROTIPI":1,"PORTFOY":1,"SMCTR":"1.00","CVDTE":"01.01.2021"}]},"IT_SOZLESME":{"item":[{"MANDT":1,"GJAHR":"0001","KUNNR":"0020300066","ZLSCH":"A","KKBER":1,"ROW_NO":1,"SMCTR":"1.00","CVDTE":"01.01.2021","START_DATE":"01.01.2021","END_DATE":"01.01.2021","TIMESTAMP":1,"USERNAME":1,"VARIANT":1,"ZTERM":1,"GJAHR_ZLSCH":1,"LAST_DATE":"01.01.2021","LAST_TIME":"11:00:00"}]}}');
            }
          
            return res;
        }
        catch(Exception e){
            system.debug('bordroCancelException::: ' + e);
            return null;
        }
        
    }
}