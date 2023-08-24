public class RC_SD_DeliveryIntegrator {
    
    public class SdDeliveryRequestModel{
        public Integer IV_PACKAGE {get; set;}
        public Integer IV_INDEX {get; set;}
        public string IV_VBELN {get;set;}
        public string IV_ERDAT_BEG{get;set;}
        public string IV_ERDAT_END{get;set;}
        public string IV_TIME_BEG{get;set;}
        public string IV_TIME_END{get;set;}
    }
    public class SdDeliveryResponseModel{
        public List<RC_SD_DeliveryParser.Item> itemList {get;set;}
        public Integer totalIndex {get; set;}
    }
    
    public static SdDeliveryResponseModel getDelivery(SdDeliveryRequestModel req) {      
        try {
            
            
            SdDeliveryResponseModel respModel = new SdDeliveryResponseModel();
            respModel.itemList = new List<RC_SD_DeliveryParser.Item>();
            
            String url = 'RESTAdapter/salesforce/sd_delivery';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            system.debug('Get Delivery Request :' + request.getBody());
            
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                system.debug('Get Delivery Result Body : ' + response.getBody());
                if(response.getBody()!='{"ET_RETURN":""}')
                {
                    RC_SD_DeliveryParser parseResult = RC_SD_DeliveryParser.parse(response.getBody());   
                    respModel.itemList       = parseResult.ET_RETURN.item;
                    respModel.totalIndex = parseResult.EV_TOTAL_IND;
                }else{
                    RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Delivery Migration Values');
                    
                    if(migrationSetting.RC_Begin_Time__c < DateTime.now()){
                        RC_SD_DeliveryIntegratorSchedulable sch = new RC_SD_DeliveryIntegratorSchedulable(); sch.execute(null);
                    } 
                }                
            }            
            
            return respModel;
        }
        
        catch(Exception ex){
            RC_Logger.LOG_EXCEPTION('Error: RC_SD_DeliveryIntegrator', 'integrator error', ex.getMessage(), 'RC_SD_DeliveryIntegrator', 'getDelivery', '');
            return null;
        }
    }
}