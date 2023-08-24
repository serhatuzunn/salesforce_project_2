public class RC_GetAddressDeltaIntegrator {
    public class regionInfo {
        
        public string id {get;set;} 
        public string ilce {get;set;} 
        public string il {get;set;} 
        public string mahalle {get;set;} 
        public string code   {get;set;} 
    }
    public class getAddressDeltaRequestModel {
        public string IV_DATE_HGH {get;set;} 
        public string IV_DATE_LOW {get;set;} 
    
    }
    public static void getAddresses(Date startDate, Date endDate) {      
        try{
            
            String url = 'RESTAdapter/salesforce/get_delta_address';                   
            HttpRequest req = new HttpRequest();
            // string body = '{"IV_DATE_HGH" : "20210128", "IV_DATE_LOW" : "20210127"}';
             
            GetAddressDeltaRequestModel reqModel = new GetAddressDeltaRequestModel();
            if(startDate.month() < 10) reqModel.IV_DATE_LOW = startDate.year() + '0' +  startDate.month() + '0' + startDate.day(); 
            else reqModel.IV_DATE_LOW = String.valueOF(startDate.year())  +  string.valueof(startDate.month())  + String.valueOf(startDate.day()); 
            if(startDate.day() < 10) reqModel.IV_DATE_HGH = endDate.year() + '0' +  endDate.month() + '0' + endDate.day(); 
            else reqModel.IV_DATE_HGH = String.valueOF(endDate.year())  +  string.valueof(endDate.month())  + String.valueOf(endDate.day()); 
            
             
            req.setBody(JSON.serialize(reqModel));
            req.setEndpoint(('callout:PoqaZorluAPI' + '/' + url));
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.setTimeout(120000);        
            Http http = new Http();    
            
            string resBody = '';
            
            if(!test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatus() == 'OK'){                   
					resBody = res.getBody();
                }
            }
            else{
                resBody = '{"ITEM":[{"ZDURUM":"INSERT","REGION":"026","CITY_CODE":"000000026114","MC_CITY":"TEPEBAŞI","ADRCITYPRT":{"ITEM":[{"CITY_CODE":"000000026114","CITYP_CODE":26999999,"CITY_PART":"semt ekleme test"}]}},{"ZDURUM":"INSERT","REGION":"026","CITY_CODE":"000000026114","MC_CITY":"TEPEBAŞI","ADRCITYPRT":{"ITEM":[{"CITY_CODE":"000000026114","CITYP_CODE":26999998,"CITY_PART":"SUHEYLA TEST 2"}]}},{"ZDURUM":"INSERT","REGION":"026","CITY_CODE":"000000026114","MC_CITY":"TEPEBAŞI","ADRCITYPRT":{"ITEM":[{"CITY_CODE":"000000026114","CITYP_CODE":26114093,"CITY_PART":"ŞEKER MAH."}]}},{"ZDURUM":"DELETE","REGION":"026","CITY_CODE":"000000026114","MC_CITY":"TEPEBAŞI","ADRCITYPRT":{"ITEM":[{"CITY_CODE":"000000026114","CITYP_CODE":26114092,"CITY_PART":"SUHEYLA TEST 2"}]}},{"ZDURUM":"DELETE","REGION":"026","CITY_CODE":"000000026114","MC_CITY":"TEPEBAŞI","ADRCITYPRT":{"ITEM":[{"CITY_CODE":"000000026114","CITYP_CODE":26113088,"CITY_PART":"ŞARKİYE MAH."}]}},{"ZDURUM":"DELETE","REGION":"026","CITY_CODE":"000000026114","MC_CITY":"TEPEBAŞI","ADRCITYPRT":{"ITEM":[{"CITY_CODE":"000000026114","CITYP_CODE":26113001,"CITY_PART":"71 EVLER MAH."},{"CITY_CODE":"000000026114","CITYP_CODE":26113001,"CITY_PART":"71 EVLER MAH."}]}}]}';
                
            }
             
            Map < String,Object > resultsMap = (Map < String, Object > ) JSON.deserializeUntyped(resBody);
            Map<String, Object> parseResult = (Map<String, Object>) resultsMap.get('ET_RETURN');
            RC_AddressDeltaIntegratorParser addressDelta = RC_AddressDeltaIntegratorParser.parse(JSON.serialize(resultsMap));
            
            system.debug(' RC_GetAddressDeltaIntegrator - parsed response : ' + addressDelta);
            
            List<String> addIds= new List<String>();
            List<String> deleteIds= new List<String>();
            List<RC_City_Region__c> newAddressList = new List<RC_City_Region__c>();
            List<RC_City_Region__c> deleteList = new List<RC_City_Region__c>();
            String addressId;
            
           //  Map<String, regionInfo> regionMap = new Map<String, regionInfo>(); 
            List<String> regionNames= new List<String>();
            
            for (RC_AddressDeltaIntegratorParser.ITEM_Z item : addressDelta.ITEM) {
                
                regionNames.add(item.MC_CITY);
                
                for(RC_AddressDeltaIntegratorParser.ITEM item2 : item.ADRCITYPRT.ITEM) {
                    
                    regionNames.add(item2.CITY_PART);
                    
                }
                
                
            }
            
            system.debug('region name list is : ' + regionNames);
            
            /*
            for (  RC_City_Region__c region : [SELECT id, RC_City__c, RC_Region__c, RC_District__c, Name, RC_Code__c  FROM RC_City_Region__c WHERE Name IN : regionNames ]) {
                 
                RegionInfo regionInfo = new regionInfo();
                
                regionInfo.id         = region.id;
                regionInfo.ilce       = region.RC_Region__c;
                regionInfo.il         = region.RC_City__c;
                regionInfo.mahalle    = region.RC_District__c;
                regionInfo.code       = region.RC_Code__c;
                    
                    
                regionMap.put(region.Name, regionInfo); 
                
            }
            
            system.debug('region map is : ' + regionMap);
            */
            //  create one list for the addresses we are gonna add and one for the ones we are gonna delete
            //  
            Map<string, RC_City_Region__c> adresMap = new Map<string, RC_City_Region__c>();
            
            for (RC_City_Region__c adres : [SELECT id, RC_City__c, Name, RC_Region__c, RC_District__c, RC_Code__c FROM RC_City_Region__c]) {
                
                adresMap.put(adres.RC_Code__c, adres);
            }
            
            
            for (RC_AddressDeltaIntegratorParser.ITEM_Z item : addressDelta.ITEM) {
                /*
                if (item.ZDURUM == 'DELETE') {
                    deleteIds.add(item.ADRCITYPRT.ITEM[0].CITYP_CODE);
                }
                */
                if (item.ZDURUM == 'INSERT') {
                    
                    
                    for(RC_AddressDeltaIntegratorParser.ITEM item2 : item.ADRCITYPRT.ITEM) {
                        
                        RC_City_Region__c x = new RC_City_Region__c(Name = item2.CITY_PART, 
                                                                    RC_City__c = adresMap.get(item.CITY_CODE).RC_City__c,
                                                                    RC_Region__c = adresMap.get(item.CITY_CODE).RC_Region__c);    
                        newAddressList.add(x);
                         
                    }
                    
                }
                 
            }
            
            /*
            for (RC_City_Region__c a : [SELECT Id, RC_Code__c FROM RC_City_Region__c WHERE RC_Code__c IN : deleteIds]) {
                deleteList.add(a);
            }
            */
            Database.SaveResult[] srList = Database.insert(newAddressList, false);
                         
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the id of the record that was processed
                    System.debug(' RC_AddressDeltaIntegrator - Successfully inserted address. Address id: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('RC_AddressDeltaIntegrator - The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('RC_AddressDeltaIntegrator - Address fields that affected this error: ' + err.getFields());
                    }
                }
            }
            /*
            Database.DeleteResult[] deleteAddressList = Database.delete(deleteList, false);
            
            
            // Iterate through each returned result
            for (Database.DeleteResult dr : deleteAddressList) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the id of the record that was processed
                    System.debug(' RC_AddressDeltaIntegrator - Successfully inserted address. Address id: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('RC_AddressDeltaIntegrator - The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('RC_AddressDeltaIntegrator - Address fields that affected this error: ' + err.getFields());
                    }
                }
            }
*/
            
        }
        catch(Exception ex)
        {
            system.debug(ex);
            RC_Logger.LOG_EXCEPTION('RC_GetAddressDeltaIntegrator  Error', ex.getMessage(), ex.getStackTraceString(), 'RC_GetAddressDeltaIntegrator', 'finish', '');
        }
    }
    
}