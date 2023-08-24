public class RC_BABSOzet {
    public class requestModel{
        public string I_DONEM 	{get;set;}
        public string I_MUHATAP {get;set;}
    }
    public class responseModel{
        @AuraEnabled
        public RC_BABSOzetParser.T_BADET BA {get;set;}
        @AuraEnabled
        public RC_BABSOzetParser.T_BSDET BS {get;set;}
    }
    @AuraEnabled
    public static string getBABSOzet(string yearmonth, string accountSAPId){
        try {
            system.debug('incoming params are : ' + yearmonth + ' ' + accountSAPId);
            requestModel req = new requestModel();
            req.I_DONEM = yearmonth;
            req.I_MUHATAP = '00' + accountSAPId;
            responseModel resp = new responseModel();
            system.debug('request body is  : ' + req.I_DONEM + ' ' + req.I_MUHATAP);
            String url = 'RESTAdapter/salesforce/fi_babs_ozet_aktar';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();            
            
            system.debug('Get Pos Request :' + request.getBody());
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                if(response.getStatus() == 'OK' && response.getBody() != ''){
                    system.debug('Get Pos Result Body : ' + response.getBody());
                    RC_BABSOzetParser parseResult = RC_BABSOzetParser.parse(response.getBody());   
                    resp.BA  = parseResult.T_BADET;
                    resp.BS  = parseResult.T_BSDET;
                }
            }
            else{
                string responseBody = '{"T_BADET":{"item":[{"MANDT":"021","DONEM":"000000","SIRA":"02050","BLGTUR":"BA","MUHATAP":"0029900009","NAME1":"","ULKE":"","VKN":"","TCN":"","ADET":-9596,"MATRAH":-5683439.07},{"MANDT":"021","DONEM":"000000","SIRA":"01236","BLGTUR":"BA","MUHATAP":"0029900009","NAME1":"","ULKE":"","VKN":"","TCN":"","ADET":-6461,"MATRAH":-6816266.45}]},"T_BSDET":{"item":[{"MANDT":"021","DONEM":"000000","SIRA":"00505","BLGTUR":"BS","MUHATAP":"0029900009","NAME1":"ARIZİ","ULKE":"TR","VKN":"","TCN":"","ADET":6457,"MATRAH":2328933.94}]}}';
                RC_BABSOzetParser parseResultBody = RC_BABSOzetParser.parse(responseBody);    
                resp.BA  = parseResultBody.T_BADET;
                resp.BS  = parseResultBody.T_BSDET;
            }                       
            system.debug(resp) ; 
            return JSON.serialize(resp);
            
        }         
        catch(Exception e){
            RC_Logger.LOG_EXCEPTION('RC_BABSOzetParser  Error', e.getMessage(), e.getStackTraceString(), 'RC_BABSOzetParser', 'finish', '');
            return null;
        }
    }
    
}