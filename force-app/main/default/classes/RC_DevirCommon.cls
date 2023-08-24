public class RC_DevirCommon {
    
    public static RC_SubeSilIntegratorParser SubeSilApi(RC_SD_Organization__c sdOrganization){
        RC_SubeSilIntegrator.IS_SUBE_VERILERI subeSilVerileri = new RC_SubeSilIntegrator.IS_SUBE_VERILERI();
        subeSilVerileri.KUNNR = sdOrganization.RC_Account__r.Parent.RC_SAP_ID__c; 
        subeSilVerileri.VKORG = sdOrganization.RC_Sales_Organization__c;
        subeSilVerileri.VTWEG = sdOrganization.Distribution_Channel__c;
        subeSilVerileri.SPART = sdOrganization.RC_Division__c;
        
        RC_SubeSilIntegrator.RequestModel requestModel = new RC_SubeSilIntegrator.RequestModel();
        requestModel.IS_SUBE_VERILERI = subeSilVerileri;
        requestModel.IV_SUBE = sdOrganization.RC_Account__r.RC_SAP_ID__c; 
        
        system.debug('sube sil requestModel : ' + requestModel);
        
        RC_SubeSilIntegratorParser integratorParser = RC_SubeSilIntegrator.getSubeSil(requestModel);
        system.debug('integratorParser : ' + integratorParser);
        
        return integratorParser;
    }
    
    public static RC_SubeSilIntegratorParser BayiSilApi(RC_SD_Organization__c sdOrganization){
        RC_SubeSilIntegrator.IS_SUBE_VERILERI subeSilVerileri = new RC_SubeSilIntegrator.IS_SUBE_VERILERI();
        subeSilVerileri.KUNNR = sdOrganization.RC_Account__r.Parent.RC_SAP_ID__c; 
        subeSilVerileri.VKORG = sdOrganization.RC_Sales_Organization__c;
        subeSilVerileri.VTWEG = sdOrganization.Distribution_Channel__c;
        subeSilVerileri.SPART = sdOrganization.RC_Division__c;
        
        RC_SubeSilIntegrator.RequestModel requestModel = new RC_SubeSilIntegrator.RequestModel();
        requestModel.IS_SUBE_VERILERI = subeSilVerileri;
        requestModel.IV_BAYI = sdOrganization.RC_Account__r.RC_SAP_ID__c; 
        
        system.debug('bayi sil requestModel : ' + requestModel);
        
        RC_SubeSilIntegratorParser integratorParser = RC_SubeSilIntegrator.getSubeSil(requestModel);
        system.debug('integratorParser : ' + integratorParser);
        
        return integratorParser;
    }
    
    public static void BlockAccount(Account account){
        account.RC_Block__c = 'SPERR';
        update account;
    }
    
    public static void BlockSdOrganization(RC_SD_Organization__c sdOrganization){
        sdOrganization.RC_Price_Group__c = '14';
        sdOrganization.RC_Order_Blockage__c = '01';
        sdOrganization.RC_Delivery_Blockage__c = '01';
        sdOrganization.RC_Invoice_Blockage__c = '01';
        update sdOrganization;
    }
    
    public static String CreateAccount(MYS_Open_Request__c mysOpenRequest, Account account){
        Account acc = new Account(Name = mysOpenRequest.RC_New_Name__c,
                                  RC_Country__c =  account.RC_Country__c,
                                  RC_City__c = account.RC_City__c,
                                  RC_Region__c = account.RC_Region__c,
                                  RC_District__c = account.RC_District__c,
                                  RC_Geolocation__Latitude__s = account.RC_Geolocation__Latitude__s,
                                  RC_Geolocation__Longitude__s = account.RC_Geolocation__Longitude__s,
                                  RC_Postal_Code__c = account.RC_Postal_Code__c,
                                  RC_Street__c = account.RC_Street__c,
                                  ParentId = account.ParentId,
                                  RC_Tax_Number__c = mysOpenRequest.RC_Tax_Number__c,
                                  RC_Tax_Office__c = mysOpenRequest.RC_Tax_Office__c,
                                  RC_New_Old_Account__c = account.Id);
        system.debug('New Account : ' + acc);
        insert acc;
        
        RC_SD_Organization__c newSdOrganization = new RC_SD_Organization__c();
        newSdOrganization.RC_Sales_Organization__c = '2201';
        newSdOrganization.Distribution_Channel__c = '01';
        newSdOrganization.RC_Division__c = '21';
        newSdOrganization.RC_Account__c = acc.Id;
        insert newSdOrganization;
        
        return acc.Id;
    }
    
    public static String CreateNewSdOrganization(String oldAccountId, String newAccountId){
        List<RC_SD_Organization__c> oldOrganizationList = [SELECT Name,RC_Sales_Organization__c,Distribution_Channel__c,RC_Regional_Directorate__c,Sales_Directorate__c,RC_Sales_Expert__c,RC_BZIRK__c,RC_Credit_Control_Field__c,RC_Division__c,RC_Payable__c
                                                           FROM RC_SD_Organization__c
                                                           WHERE RC_Account__c =: oldAccountId];
        system.debug('oldOrganizationList : ' + oldOrganizationList);
        
        
        if(oldOrganizationList != null && oldOrganizationList.size() > 0){
            List<RC_SD_Organization__c> newOrganizationList = [SELECT Name FROM RC_SD_Organization__c WHERE RC_Account__c =: newAccountId];
            system.debug('newOrganizationList : ' + newOrganizationList);
            if(newOrganizationList != null && newOrganizationList.size() > 0){
                newOrganizationList.get(0).RC_Sales_Organization__c = oldOrganizationList.get(0).RC_Sales_Organization__c;
                newOrganizationList.get(0).Distribution_Channel__c = oldOrganizationList.get(0).Distribution_Channel__c;
                newOrganizationList.get(0).RC_Regional_Directorate__c  = oldOrganizationList.get(0).RC_Regional_Directorate__c;
                newOrganizationList.get(0).Sales_Directorate__c  = oldOrganizationList.get(0).Sales_Directorate__c;
                newOrganizationList.get(0).RC_Sales_Expert__c  = oldOrganizationList.get(0).RC_Sales_Expert__c;
                newOrganizationList.get(0).RC_BZIRK__c  = oldOrganizationList.get(0).RC_BZIRK__c;
                newOrganizationList.get(0).RC_Credit_Control_Field__c  = oldOrganizationList.get(0).RC_Credit_Control_Field__c;
                newOrganizationList.get(0).RC_Division__c  = oldOrganizationList.get(0).RC_Division__c;
                newOrganizationList.get(0).RC_Payable__c  = oldOrganizationList.get(0).RC_Payable__c;
                
                update newOrganizationList.get(0);
                
                return newOrganizationList.get(0).Id;
            }
            
        }
        return null;
    }
    
    public static RC_SubeYaratIntegratorParser SubeYarat(MYS_Open_Request__c mysOpenRequest, String newSdOrganizationId,  List<Account> accountList){
        List<RC_SD_Organization__c> newOrganizationList = [SELECT Name, RC_Sales_Organization__c, Distribution_Channel__c, RC_Division__c
                                                           FROM RC_SD_Organization__c 
                                                           WHERE Id =: newSdOrganizationId
                                                           LIMIT 1];
        
        if(newOrganizationList != null && newOrganizationList.size() > 0){
            RC_SubeYaratIntegrator.IS_SUBE_VERILERI subeVerileri = new RC_SubeYaratIntegrator.IS_SUBE_VERILERI();
            subeVerileri.ADRNR = '';
            String companyText = mysOpenRequest.RC_Company__c;
            
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
            subeVerileri.LOCCO = mysOpenRequest.RC_Postal_Code__c;
            subeVerileri.CITY1 = mysOpenRequest.RC_Region__r.Name;
            subeVerileri.CITY2 = mysOpenRequest.RC_District__r.Name;
            subeVerileri.LZONE = '4000000005';
            subeVerileri.REGION = mysOpenRequest.RC_City__r.RC_Code__c;
            subeVerileri.TEL_NUMBER = mysOpenRequest.RC_Dealer_Phone__c;
            subeVerileri.FAX_NUMBER = mysOpenRequest.RC_Dealer_Fax__c;
            subeVerileri.SMTP_ADDR = mysOpenRequest.RC_Dealer_Email__c;
            subeVerileri.VKORG = newOrganizationList.get(0).RC_Sales_Organization__c;
            subeVerileri.VTWEG = newOrganizationList.get(0).Distribution_Channel__c;
            subeVerileri.SPART = newOrganizationList.get(0).RC_Division__c;
            subeVerileri.ENLEM = String.valueOf(mysOpenRequest.RC_Geolocation__Longitude__s);
            subeVerileri.BOYLAM = String.valueOf(mysOpenRequest.RC_Geolocation__Latitude__s);
            subeVerileri.ORT01 = mysOpenRequest.RC_Region__r.RC_Code__c;
            subeVerileri.LAND1 = mysOpenRequest.Country__c;
            
            RC_SubeYaratIntegrator.RequestModel requestSubeYaratModel = new RC_SubeYaratIntegrator.RequestModel();
            requestSubeYaratModel.IS_SUBE_VERILERI = subeVerileri;
            requestSubeYaratModel.IV_BAYI = mysOpenRequest.RC_Dealer__r.RC_SAP_ID__c;
            
            if(String.valueOf(accountList.size() + 1).length() == 1){  //Şube 1 arttırılır
                requestSubeYaratModel.IV_SUBE = '0' + String.valueOf(accountList.size() + 1);
            }
            else{
                requestSubeYaratModel.IV_SUBE = String.valueOf(accountList.size() + 1);  
            }
            
            system.debug('requestSubeYaratModel : ' + requestSubeYaratModel);
            
            
            RC_SubeYaratIntegratorParser integratorSubeYaratParser = RC_SubeYaratIntegrator.getSubeYarat(requestSubeYaratModel);
            system.debug('integratorSubeYaratParser : ' + integratorSubeYaratParser);
            
            return integratorSubeYaratParser;
        }
        
        return null;
        
    }
    
    public static void MysApproved(MYS_Open_Request__c mysOpenRequest){
        mysOpenRequest.MYS_Status__c = 'Approved';
        update mysOpenRequest;
    }
    
    public static void UpdateAccountSapId(String accountId, RC_SubeYaratIntegratorParser integratorSubeYaratParser){
        List<Account> accList = [SELECT RC_SAP_ID__c 
                                 FROM Account
                                 WHERE Id =: accountId LIMIT 1];
        if(accList != null && accList.size() > 0){
            accList.get(0).RC_SAP_ID__c = String.valueOf(integratorSubeYaratParser.EV_SUBE);
            update accList.get(0);
        }
    }
    
}