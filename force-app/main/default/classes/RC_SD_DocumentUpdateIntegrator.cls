public class RC_SD_DocumentUpdateIntegrator {
    public class updateOrdersRequestModel {
        public String IV_AEDAT {get;set;}            
    }
    @future(callout=true)
    public static void updateOrders(Date day) {             
        try{
            String url = 'RESTAdapter/salesforce/sd_update_doc_list';        
            
            updateOrdersRequestModel reqModel = new updateOrdersRequestModel();
            reqModel.IV_AEDAT = day.year() + '-0' +  day.month() + '-0' + day.day();

            
            
            HttpRequest req = new HttpRequest();
            // String body = '{"IV_AEDAT": "2021-03-07"}';
            
            req.setBody(JSON.serialize(reqModel));
            req.setEndpoint(('callout:PoqaZorluAPI' + '/' + url));
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.setTimeout(120000);        
            system.debug('get endpoint :' + req);
            Http http = new Http();    
            HttpResponse res = http.send(req);
            system.debug(res.getBody());  
            
            system.debug('RC_UpdateOrdersIntegrator - Response from service is  : '  + res.getBody());
            
            RC_SD_DocumentUpdateParser ordersResponse = RC_SD_DocumentUpdateParser.parse(res.getBody());
            
            
            system.debug('RC_UpdateOrdersIntegrator - Number of new orders is  : '  + (ordersResponse.ET_CHNG_ORDERS.item).size());
            
            // call create orders function for new orderss
            for( RC_SD_DocumentUpdateParser.ITEM_Z order : ordersResponse.ET_CHNG_ORDERS.item) {
                
                RC_CreateOrdersIntegrator.getOrders(null, order.VBELN);
            }
	
            /* TODO this part is gonna be completed once delivery integration is completed
            for( RC_UpdateOrdersParser.ITEM_Z delivery : ordersResponse.ET_CHNG_DELIV.item) {
                
                if(delivery.STATUS == 'U') update delivery
                
                else if(delivery.STATUS == 'D') delete delivery
            }      
			*/
            
        }
        catch(Exception ex)
        {
            RC_Logger.LOG_EXCEPTION('UpdateOrdersIntegrator  Error', ex.getMessage(), ex.getStackTraceString(), 'UpdateOrdersIntegrator', 'finish', '');
        }    
    }
}