public class RC_SD_CargoIntegrator {
    
    public class Item    {
        public String TES_NO { get; set; } 
    }
    
    public class ITVBELN    {
        public List<Item> item { get; set; } 
    }
    
    public class requestModel   {
        public ITVBELN IT_VBELN { get; set; } 
    }
    
    
    public static void getSdEticCargo(requestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_etic_cargo';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('req:' + request.getBody());
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                response.getBody().Replace('NUMBER','NUMBER_Z');
                response.getBody().Replace('TYPE','TYPE_Z');
                response.getBody().Replace('ROW','ROW_Z');
                response.getBody().Replace('SYSTEM','SYSTEM_Z');
                response.getBody().Replace('FIELD','FIELD_Z');
                system.debug('response.getBody():' + response.getBody());
                RC_SD_CargoIntegratorParser parseResult = RC_SD_CargoIntegratorParser.parse(response.getBody());
                system.debug('parse:' + parseResult);
                Map<String,List<String>> mapList = new Map<String,List<String>>();  //key= name(ZTM_DELIVEY_NO)  value= ZZ_CODE1,CARGO_COMPANY
                for (RC_SD_CargoIntegratorParser.Item item : parseResult.ET_DATA.Item){
                    if(item.ZTM_DELIVEY_NO.length()==8) item.ZTM_DELIVEY_NO ='00' + item.ZTM_DELIVEY_NO;
                    if(item.ZTM_DELIVEY_NO.length()==9) item.ZTM_DELIVEY_NO ='0' + item.ZTM_DELIVEY_NO;
                    mapList.put(item.ZTM_DELIVEY_NO, new List<String>{item.ZZ_CODE2, item.CARGO_COMPANY, item.ZZ_CODE1});
                }
                system.debug('mapList:' + mapList);
                List<RC_Delivery_and_Billing__c> deliveryBillingList = [SELECT Id, Name, RC_Delivery_Status__c, RC_Delivery_Cargo_Company__c, RC_Order_Number__c FROM RC_Delivery_and_Billing__c WHERE Name IN :mapList.keySet()];
                system.debug('deliveryBillingList:' + deliveryBillingList);
                for (RC_Delivery_and_Billing__c item : deliveryBillingList)
                {
                    List<String> statusAndCompany =  mapList.get(item.Name);
                    
                    item.RC_Delivery_Cargo_Company__c  = getCompanyNo(statusAndCompany[1]); 
                    
                    if(statusAndCompany[2]=='01')
                    {
                        item.RC_Delivery_Status__c= 'Teslim Edildi';
                    }
                    else if(statusAndCompany[2]=='14')
                    {
                        item.RC_Delivery_Status__c= 'Teslim Edilemedi';
                    }
                    else
                    {
                        item.RC_Delivery_Status__c = getStatus(statusAndCompany[0]);
                    }
                    
                    
                }
                
                if(Test.isRunningTest()) {
                    RC_Delivery_and_Billing__c d = new RC_Delivery_and_Billing__c();
                    d.Name = 'Test';
                    d.RC_Delivery_Status__c = 'Test';
                    
                    deliveryBillingList.add(d);
                    system.debug('deliveryBillingList : ' + deliveryBillingList);
                }
                
                Database.SaveResult [] updateResult = Database.update(deliveryBillingList, false); 
                List<RC_Logger__c> rcLoggerList = new List<RC_Logger__c>();
                for (Database.SaveResult sr : updateResult)            
                {
                    if(sr.isSuccess()){
                        System.debug(sr.getId());
                    }
                    else{
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('error: ' + err.getFields());
                            
                            RC_Logger__c rcLogger = new RC_Logger__c();
                            rcLogger.RC_Message__c = 'Error: RC_SD_CargoIntegrator';
                            rcLogger.RC_Message_Detail__c = 'Update Error';
                            rcLogger.RC_StackTrace__c = err.getMessage();
                            rcLogger.RC_LogLevel__c = 'EXCEPTION';
                            rcLogger.CreateDate__c = DateTime.now();
                            rcLogger.RC_ClassName__c = 'RC_SD_CargoIntegrator';
                            rcLogger.RC_FunctionName__c = 'getSdEticCargo';
                            rcLogger.RC_ComponentName__c = '';      
                            
                            rcLoggerList.add(rcLogger);
                        }
                        
                    }
                } 
                insert rcLoggerList;
                system.debug('RCLOgger:' + rcLoggerList);
            }
        }
        catch(Exception e){
            system.debug('error:' +e);
            RC_Logger.LOG_EXCEPTION('Error : RC_SD_CargoIntegrator', 'getSdEticCargo error', e.getMessage(), 'RC_SD_CargoIntegrator', 'getSdEticCargo', '');
        }
        
    }
    
    public static String getTMCodeCargo(requestModel req){
        try{
            String url = 'RESTAdapter/salesforce/sd_etic_cargo';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('req:' + request.getBody());
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                response.getBody().Replace('NUMBER','NUMBER_Z');
                response.getBody().Replace('TYPE','TYPE_Z');
                response.getBody().Replace('ROW','ROW_Z');
                response.getBody().Replace('SYSTEM','SYSTEM_Z');
                response.getBody().Replace('FIELD','FIELD_Z');
                system.debug('response.getBody():' + response.getBody());
                RC_SD_CargoIntegratorParser parseResult = RC_SD_CargoIntegratorParser.parse(response.getBody());
                
                Map<String,List<String>> mapList = new Map<String,List<String>>();  //key= name(ZTM_DELIVEY_NO)  value= ZZ_CODE1,CARGO_COMPANY
                for (RC_SD_CargoIntegratorParser.Item item : parseResult.ET_DATA.Item){
                    if(item.ZTM_DELIVEY_NO.length()==8) item.ZTM_DELIVEY_NO ='00' + item.ZTM_DELIVEY_NO;
                    if(item.ZTM_DELIVEY_NO.length()==9) item.ZTM_DELIVEY_NO ='0' + item.ZTM_DELIVEY_NO;
                    if(item.ZTM_DELIVEY_NO == req.IT_VBELN.item[0].TES_NO)
                    {
                        return item.ZZ_CODE1;
                    }
                }
                return '';  
            }
            return '';
            
        }
        catch(Exception e){
            RC_Logger.LOG_EXCEPTION('Error : RC_SD_CargoIntegrator', 'getTMCodeCargo error', e.getMessage(), 'RC_SD_CargoIntegrator', 'getTMCodeCargo', '');
            return '';
        }
        
    }
    
    public static String getStatus(String ZZ_CODE2){
        Switch on ZZ_CODE2 {
            when '1','01' {
                return 'Hazırlanıyor';
            }
            when '13','14'{
                return 'Dağıtımı Hazırlanıyor';
            }
            when '2','3','4','02','03','04' {
                return 'Yola Çıkmak Üzere';
            }
            when '5','6','7','8','9','05','06','07','08','09','17'{
                return 'Yolda';
            }
            when '10'{
                return 'Transfer Merkezinde';
            }
            when '16' {
                return 'Kurye Dağıtımında';
            }
            when '18'{
                return 'Teslim Edildi';
            }
            when else {
                System.debug('No Value match:' + ZZ_CODE2);
                return null;
            }
        }
    }
    
    public static String getCompanyNo(String companyText){
        try
        {
            return companyText.split('/')[0].trim();
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
            RC_Logger.LOG_EXCEPTION('Error : RC_SD_CargoIntegrator', 'getCompanyNo error', ex.getMessage(), 'RC_SD_CargoIntegrator', 'getCompanyNo', '');
        }
        return null;
    }
}