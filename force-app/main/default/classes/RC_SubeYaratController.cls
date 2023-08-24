public class RC_SubeYaratController {
    
    public class initWrapper{
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public String accountId {get;set;}
    }
    
    @AuraEnabled
    public static initWrapper initialize(string recordId){
        initWrapper initWrp = new initWrapper();
        system.debug('recordId:' + recordId);
        
        
        if(!string.isBlank(recordId)){
            
            Id idMys = Schema.SObjectType.MYS_Open_Request__c.getRecordTypeInfosByDeveloperName().get('Dealer_Branch').getRecordTypeId();
            
            List<MYS_Open_Request__c> openRequestList = [SELECT Id, OwnerId, RC_Account__c, RC_SAP_Message__c, Name, Lead__c, RC_Dealer__c, RC_Dealer__r.RC_SAP_ID__c, RC_City__r.RC_Code__c, RC_Dealer_Email__c, RC_Region__r.Name, RC_Region__r.RC_Code__c, RC_Company__c, Country__c, RC_District__r.Name, RC_Phone__c, RC_Dealer_Mobile__c, RC_Dealer_Fax__c, RC_Postal_Code__c, RC_Geolocation__Latitude__s, RC_Geolocation__Longitude__s 
                                                         FROM MYS_Open_Request__c
                                                         WHERE Lead__c =: recordId and RecordTypeId =: idMys
                                                         LIMIT 1];
            
            
            
            system.debug('openRequestList : ' + openRequestList);
            
            
            if(openRequestList != null && openRequestList.size() > 0 && openRequestList.get(0) != null){
                
                List<Account> accountList = [SELECT Id, ParentId FROM Account WHERE ParentId =: openRequestList.get(0).RC_Dealer__c];
                
                List<RC_SD_Organization__c> organizationList = [SELECT RC_Sales_Organization__c, RC_Division__c, Distribution_Channel__c 
                                                                FROM RC_SD_Organization__c
                                                                WHERE RC_Sales_Organization__c = '2201' and RC_Account__c =: openRequestList.get(0).RC_Dealer__c
                                                                LIMIT 1];
                
                system.debug('organizationList : ' + organizationList);
                
                if(organizationList != null && organizationList.size() > 0  && organizationList.get(0) != null){
                    RC_SubeYaratIntegrator.IS_SUBE_VERILERI subeVerileri = new RC_SubeYaratIntegrator.IS_SUBE_VERILERI();
                    subeVerileri.ADRNR = '';
                    
                    
                    String companyText = openRequestList.get(0).RC_Company__c;
                    
                    if(companyText != null){
                        if(companyText.length() <= 50){
                            subeVerileri.NAME1 = companyText.substring(0, companyText.length());
                        }
                        else if(companyText.length() > 50 && companyText.length() <= 100){
                            subeVerileri.NAME1 = companyText.substring(0, 50);
                            subeVerileri.NAME2 = companyText.substring(50, companyText.length());
                        }
                        else if(companyText.length() > 100 && companyText.length() <= 150){
                            subeVerileri.NAME1 = companyText.substring(0, 50);
                            subeVerileri.NAME2 = companyText.substring(50, 100);
                            subeVerileri.NAME3 = companyText.substring(100, companyText.length());
                        }
                    }
                    
                    
                    subeVerileri.ERDAT = String.valueOf(DateTime.Now());
                    subeVerileri.LOCCO = openRequestList.get(0).RC_Postal_Code__c;
                    subeVerileri.CITY1 = openRequestList.get(0).RC_Region__r.Name;
                    subeVerileri.CITY2 = openRequestList.get(0).RC_District__r.Name;                  
                    subeVerileri.REGION = openRequestList.get(0).RC_City__r.RC_Code__c;
                    subeVerileri.TEL_NUMBER = openRequestList.get(0).RC_Phone__c;
                    subeVerileri.FAX_NUMBER = openRequestList.get(0).RC_Dealer_Fax__c;
                    subeVerileri.SMTP_ADDR = openRequestList.get(0).RC_Dealer_Email__c;
                    subeVerileri.VKORG = organizationList.get(0).RC_Sales_Organization__c;
                    subeVerileri.VTWEG = organizationList.get(0).Distribution_Channel__c;
                    subeVerileri.SPART = organizationList.get(0).RC_Division__c;
                    subeVerileri.ENLEM = String.valueOf(openRequestList.get(0).RC_Geolocation__Longitude__s);
                    subeVerileri.BOYLAM = String.valueOf(openRequestList.get(0).RC_Geolocation__Latitude__s);
                    subeVerileri.ORT01 = openRequestList.get(0).RC_Region__r.RC_Code__c;
                    subeVerileri.LAND1 = openRequestList.get(0).Country__c;
                    
                    RC_SubeYaratIntegrator.RequestModel requestModel = new RC_SubeYaratIntegrator.RequestModel();
                    requestModel.IS_SUBE_VERILERI = subeVerileri;
                    requestModel.IV_BAYI = openRequestList.get(0).RC_Dealer__r.RC_SAP_ID__c;
                    
                    if(String.valueOf(accountList.size() + 1).length() == 1){  //Şube 1 arttırılır
                        requestModel.IV_SUBE = '0' + String.valueOf(accountList.size() + 1);
                    }
                    else{
                        requestModel.IV_SUBE = String.valueOf(accountList.size() + 1);  
                    }
                    
                    system.debug('requestModel : ' + requestModel);
                    
                    
                    RC_SubeYaratIntegratorParser integratorParser = RC_SubeYaratIntegrator.getSubeYarat(requestModel);
                    system.debug('integratorParser : ' + integratorParser);
                    
                    //API Result
                    if(integratorParser.EV_SUCCESS == 'X'){
                        
                        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                        Lead foundedLead = [SELECT ID, Company FROM Lead WHERE Id =: recordId];
                        Id rcId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
                        
                        Account convertAccount = new Account(RecordTypeId = rcId, OwnerId = openRequestList.get(0).OwnerId, RC_Dealer_Type__c = 'BAYI', RC_Sub_Type__c = 'Şube', Name = foundedLead.Company, RC_SAP_ID__c = String.valueOf(integratorParser.EV_SUBE), ParentId = openRequestList.get(0).RC_Dealer__c, RC_Account_Type__c = 'Potential');
                        insert convertAccount;
                        
                        RC_SD_Organization__c newSdOrganization = new RC_SD_Organization__c();
                        newSdOrganization.RC_Sales_Organization__c = '2201';
                        newSdOrganization.Distribution_Channel__c = '01';
                        newSdOrganization.RC_Division__c = '21';
                        newSdOrganization.RC_Account__c = convertAccount.Id;
                        insert newSdOrganization;
                         
                        openRequestList.get(0).RC_Express_Status__c = 'Renting Control';
                        openRequestList.get(0).RC_Account__c = convertAccount.Id;
                        update openRequestList.get(0);
                        
                        
                        Database.LeadConvert lc = new database.LeadConvert();
                        lc.setLeadId(foundedLead.id);
                        lc.setAccountId(convertAccount.id);
                        lc.setdonotcreateopportunity(true);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        
                        Database.LeadConvertResult lcr = Database.convertLead(lc);
                        system.debug(Json.serialize(lcr));
                        
                        initWrp.accountId = convertAccount.Id;
                        initWrp.isSuccess = true;
                    }
                    else{
                        initWrp.isSuccess = false;
                        
                        //Hata mesajı yazdırılır.
                        openRequestList.get(0).RC_SAP_Message__c = integratorParser.ET_RETURN.item[0].MESSAGE;
                        update openRequestList.get(0);
                        
                        system.debug('openRequestList : ' + openRequestList.get(0));
                        
                        openRequestList.get(0).addError('lead addError : ' + integratorParser.ET_RETURN.item[0].MESSAGE);
                    }
                }
                else{
                    initWrp.isSuccess = false;
                }
            }
            else{
                initWrp.isSuccess = false;
            }
            
        }
        else{
            initWrp.isSuccess = false;
        }
        
        return initWrp;
    }
}