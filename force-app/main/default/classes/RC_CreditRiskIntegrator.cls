public class RC_CreditRiskIntegrator {
    public class requestModel{
        public string IV_BUKRS 	{get;set;}
        public string IV_KKBER 	{get;set;}
        public string IV_KUNNR 	{get;set;}
    }
    public class responseModel{
        @AuraEnabled
        public RC_CreditRiskJsonParser.Item_Y itemZ {get;set;}
        @AuraEnabled
        public List<RC_CreditRiskJsonParser.Item> riskItems {get;set;}
    }
    
    public static responseModel getCreditRiskReport(requestModel req){
        try {
            responseModel resp = new responseModel();
            resp.riskItems = new List<RC_CreditRiskJsonParser.Item>();
            String url = 'RESTAdapter/salesforce/bayi_risk';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
                HttpResponse response = http.send(request);
                if(response.getStatus() == 'OK'){
                    RC_CreditRiskJsonParser parseResult = RC_CreditRiskJsonParser.parse(response.getBody());
                    if(parseResult.ET_RETURN.item.size()>0)
                    {
                        resp.itemZ       = parseResult.ET_RETURN.item[0];
                        if(resp.itemZ.RISK_SINIFI_T!=null)
                            resp.riskItems   = resp.itemZ.RISK_SINIFI_T.item;  
                    }
                }

            return resp;
            
        }
        
        catch(Exception e){
            system.debug('excp:' + e);
            return null;
        }
    }
    
}