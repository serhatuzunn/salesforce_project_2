public class RC_DocFlowComponentController {
    
    public class initWrapper{
        @AuraEnabled
        public CargoResponseModel cargoResponseModel { get; set; } 
    }
    
    //DocFlow Request Model
    public class RequestDocFlowModel{
        public String IV_ERDAT {get;set;} 
        public String IV_VBELN {get;set;} 
    }
    
    //Cargo Request Model
    public class Item    {
        public String TES_NO { get; set; } 
    }
    public class ITVBELN    {
        public List<Item> item { get; set; } 
    }
    public class RequestCargoModel{
        public ITVBELN IT_VBELN { get; set; } 
    }
    
    //Cargo Response Model
    public class CargoResponseModel{
        @AuraEnabled
        public List<CargoItem> CargoItemList { get; set; } 
    }
    
    public class CargoItem{
        @AuraEnabled
        public String POSNR_VA{ get; set; } 
        @AuraEnabled
        public String VBELN_VF{ get; set; } 
        @AuraEnabled
        public String VBELN_CKS{ get; set; } 
        @AuraEnabled
        public String ZTM_DELIVEY_NO{ get; set; } 
        @AuraEnabled
        public String ZZ_ENH_DELIVERY_ST_TXT{ get; set; }   
        @AuraEnabled
        public String CARGO_COMPANY{ get; set; }   
    }
    
    @AuraEnabled
    public static initWrapper initialize(string recordId){
        
        system.debug('recordId:' + recordId);
        
        if(!string.isBlank(recordId)){
            List<Order> orderTimeList = [Select EffectiveDate, RC_Order_No__c FROM Order WHERE Id =: recordId LIMIT 1];
            system.debug('orderTimeList: ' + orderTimeList);
            
            if(orderTimeList.size() > 0){
                //Doc Flow
                RequestDocFlowModel requestDocFlowModel = new RequestDocFlowModel();
                requestDocFlowModel.IV_ERDAT = string.valueOfGmt(orderTimeList.get(0).EffectiveDate).replaceAll('-', '').split(' ')[0];
                requestDocFlowModel.IV_VBELN = orderTimeList.get(0).RC_Order_No__c;
                
                system.debug('requestDocFlowModel: ' + requestDocFlowModel);
                
                Map<String, List<String>> deliveryNoMap = GetDocFlow(requestDocFlowModel);  //Doc Flow API
                system.debug('deliveryNoMap: ' + deliveryNoMap);
                if(deliveryNoMap.size() > 0){                                   
                    CargoResponseModel cargoResponseModel = GetEticCargo(deliveryNoMap);  //Cargo API
                    
                    initWrapper initWrp = new initWrapper();
                    initWrp.CargoResponseModel = cargoResponseModel; 
                    system.debug('initWrp: ' + initWrp);
                    return initWrp;
                }
                
            }
            
        }
        return null;
        
    }
    
    public static Map<String, List<String>> GetDocFlow(RequestDocFlowModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_doc_flow';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            HttpResponse response = http.send(request);
            system.debug('DocFlow Response: ' + response.getBody());
            
            if(response.getStatus() == 'OK'){
                RC_DocFlowParser resp = (RC_DocFlowParser)JSON.deserialize(response.getBody(), RC_DocFlowParser.class); 
                system.debug('DocFlow Parser: ' + resp);
                Map<String, List<String>> deliveryNoMap = new Map<String, List<String>>(); //key=VBELN_VL, value=POSNR_VA, VBELN_VF, VBELN_CKS
                
                for(RC_DocFlowParser.Item currentItem : resp.ET_RETURN.item){
                    List<String> itemValueList = new List<String>();
                    itemValueList.add(currentItem.POSNR_VA);
                    itemValueList.add(currentItem.VBELN_VF);
                    itemValueList.add(currentItem.VBELN_CKS);
                    deliveryNoMap.put(currentItem.VBELN_VL, itemValueList);
                }
                
                system.debug('return deliveryNoMap: ' + deliveryNoMap);
                return deliveryNoMap;  //teslimatNoSet 
            }
        }
        catch(Exception ex){
            system.debug('hata ' + ex);
        }
        return null;
    }
    
    public static CargoResponseModel GetEticCargo(Map<String, List<String>> deliveryNoMap){
        try{
            List<Item> itemList = new List<Item>();
            for(String deliveryNoItemKey: deliveryNoMap.keySet()){
                Item item = new Item();
                item.TES_NO = deliveryNoItemKey;
                
                itemList.add(item);
            }
            
            
            ITVBELN itvBeln = new ITVBELN();
            itvBeln.item = itemList;
            
            RequestCargoModel cargoReqModel = new RequestCargoModel();
            cargoReqModel.IT_VBELN = itvBeln;
            
            String url = 'RESTAdapter/salesforce/sd_etic_cargo';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(cargoReqModel));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            system.debug('request : ' + request.getBody());
            HttpResponse response = http.send(request);
            system.debug('response : ' + response.getBody());
            if(response.getStatus() == 'OK'){
                
                response.getBody().Replace('NUMBER','NUMBER_Z');
                response.getBody().Replace('TYPE','TYPE_Z');
                response.getBody().Replace('ROW','ROW_Z');
                response.getBody().Replace('SYSTEM','SYSTEM_Z');
                response.getBody().Replace('FIELD','FIELD_Z');
                system.debug('cargo response.getBody():' + response.getBody());
                
                RC_SD_CargoIntegratorParser parseResult = RC_SD_CargoIntegratorParser.parse(response.getBody());                
                system.debug('parse result  : '+ parseResult);
                
                CargoResponseModel cargoResponseModel = new CargoResponseModel();
                cargoResponseModel.CargoItemList = new List<CargoItem>();
                
                for (RC_SD_CargoIntegratorParser.Item currentItem : parseResult.ET_DATA.item){
                    if(!String.isBlank(currentItem.ZTM_DELIVEY_NO)){
                        if(currentItem.ZTM_DELIVEY_NO.length()==8) currentItem.ZTM_DELIVEY_NO ='00' + currentItem.ZTM_DELIVEY_NO;
                        if(currentItem.ZTM_DELIVEY_NO.length()==9) currentItem.ZTM_DELIVEY_NO ='0' + currentItem.ZTM_DELIVEY_NO;
                        
                        CargoItem cargoItem = new CargoItem();
                        
                        List<String> deliveryNoMapValueList = deliveryNoMap.get(currentItem.ZTM_DELIVEY_NO);
                        cargoItem.POSNR_VA = deliveryNoMapValueList.get(0);
                        cargoItem.VBELN_VF = deliveryNoMapValueList.get(1);
                        cargoItem.VBELN_CKS = deliveryNoMapValueList.get(2);
                        cargoItem.ZTM_DELIVEY_NO = currentItem.ZTM_DELIVEY_NO;
                        cargoItem.ZZ_ENH_DELIVERY_ST_TXT = currentItem.ZZ_ENH_DELIVERY_ST_TXT;
                        List<String> companyList = currentItem.CARGO_COMPANY.split('/');
                        cargoItem.CARGO_COMPANY = companyList.size() > 2 ? companyList.get(1) : '';
                        
                        cargoResponseModel.CargoItemList.add(cargoItem);                        
                    }
                    
                }
                
                return cargoResponseModel;
            }
        }
        catch(Exception ex){
            system.debug('hata ' + ex);
        }
        return null;
    }
}