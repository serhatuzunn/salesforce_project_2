public class RC_CreateOrdersIntegrator {
    public class createOrdersRequestModel {
        public string IV_VBELN {get;set;}
        public string IV_ERDAT_BEG{get;set;}
        public string IV_ERDAT_END{get;set;}
        public string IV_TIME_BEG{get;set;}
        public string IV_TIME_END{get;set;}
        public Integer IV_PACKAGE {get; set;}
        public Integer IV_INDEX {get; set;}
    }
    
    public static void getOrders(createOrdersRequestModel reqModel, Integer totalIndex, Integer currentIndex) {             
        try{            
            String url = 'RESTAdapter/salesforce/sd_orders';        
            
            HttpRequest req = new HttpRequest();
            
            req.setBody(JSON.serialize(reqModel));
            
            req.setEndpoint(('callout:PoqaZorluAPI' + '/' + url));
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setTimeout(120000);        
            
            Http http = new Http();    
            HttpResponse res = http.send(req);
            system.debug('req:' + req);
            system.debug('res:' + res.getBody());
            
            DateTime controlDate = DateTime.now();
            if(res.getBody()!='{"ET_RETURN":"","EV_TOTAL_IND":0}')
            {
                RC_OrdersIntegratorParser ordersResponse = RC_OrdersIntegratorParser.parse(res.getBody());
                
                RC_CreateOrders.createOrders(ordersResponse);  
                
                RC_SchedulableSettings__c setting = RC_SchedulableSettings__c.getValues('SD Orders Schedulable Settings');
                if(totalIndex == null && setting != null && setting.RC_Package_Size__c != null){ totalIndex = Integer.valueOf(ordersResponse.EV_TOTAL_IND / setting.RC_Package_Size__c) + 1; }
                
                if(currentIndex < totalIndex){
                    reqModel.IV_INDEX = Integer.valueOf(currentIndex * setting.RC_Package_Size__c);                
                    
                    RC_CreateOrdersQueueable queue = new RC_CreateOrdersQueueable(reqModel, totalIndex, currentIndex);
                    
                    System.enqueueJob(queue);
                }  
                else{
                    RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Order Migration Values');
                    
                    if(migrationSetting.RC_Begin_Time__c < controlDate){
                        RC_CreateOrdersSchedulable sch = new RC_CreateOrdersSchedulable(); sch.execute(null);
                    }                    
                }
            }
            else{                
                RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Order Migration Values');
                if(migrationSetting.RC_Begin_Time__c < controlDate){
                    RC_CreateOrdersSchedulable sch = new RC_CreateOrdersSchedulable(); sch.execute(null);
                }
            }
        }
        catch(Exception ex)
        {
            system.debug('ex:' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_CreateOrdersIntegrator', 'Integrator Error', ex.getMessage(), 'RC_CreateOrdersIntegrator', 'finish', '');
        }    
    }
}