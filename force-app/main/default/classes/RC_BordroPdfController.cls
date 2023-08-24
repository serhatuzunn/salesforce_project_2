public class RC_BordroPdfController {
    
    ApexPages.StandardController controller;
    
    public RC_Bordro__c  bordro {get;set;}
    
    public String bayiNo {get;set;}
    public String bayiAdi {get;set;}
    public String bordroNumarasi {get;set;}
    public String tarih {get;set;}
    public List<ChequeItem> chequeItemList {get;set;}
    public Double genelToplam {get;set;}
    public String ortalamaVade {get;set;}
    public Integer toplamCekSayisi {get;set;}
    
    public String userKodu {get;set;}
    public String satisGrubu {get;set;}
    public String adiSoyadi {get;set;}
    
    
    public RC_BordroPdfController(ApexPages.StandardController c) {
        
        genelToplam = 0; 
        System.debug('Param : ' + JSON.serialize(Apexpages.currentPage().getParameters()));
        String bordroId = Apexpages.currentPage().getParameters().get('bid');
        
        List<RC_Bordro__c> bordroList = [SELECT Id, RC_Dealer_Number__c, RC_Bordro_No__c, RC_Average_Due_Date__c FROM RC_Bordro__c WHERE Id=: bordroId];
        if(bordroList != null && bordroList.size() > 0){
            bordro = bordroList.get(0);
            
            bayiNo = bordro.RC_Dealer_Number__c;
            bordroNumarasi = bordro.RC_Bordro_No__c;
            
            List<Account> accountList = [SELECT Name FROM Account WHERE RC_SAP_ID__c =: bordro.RC_Dealer_Number__c LIMIT 1];
            if(accountList != null && accountList.size() > 0){
                bayiAdi = accountList.get(0).Name;
            }
            
            DateTime todaysDate = System.today();
            tarih = todaysDate.format('dd-MM-yyyy');
            
            List<RC_Cheques__c> chequeList = [SELECT Id, RC_Bordro__c, CreatedDate, Name, RC_Bank_Key__c, RC_Cheque_Bill__c, RC_Bill_Number__c, RC_Cheque_Number__c, RC_Drawer_Region__c, RC_Amount__c, RC_Due_Date__c  
                                              FROM RC_Cheques__c 
                                              WHERE RC_Bordro__c =: bordro.Id AND RC_Type__c = 'Cheque'];
            if(chequeList != null && chequeList.size() > 0){
                
                chequeItemList = new List<ChequeItem>();
                for(RC_Cheques__c cq : chequeList){
                    ChequeItem chequeItem = new ChequeItem();
                    chequeItem.tarih = String.valueOf(cq.CreatedDate.day() + '-'+ cq.CreatedDate.month() + '-'+ cq.CreatedDate.year());
                    
                    chequeItem.cekNo = cq.RC_Cheque_Number__c;
                    
                    List<RC_Bank_Informations__c> bankInformationList =  [SELECT RC_BANK__c, RC_BRINCH__c 
                                                                          FROM RC_Bank_Informations__c 
                                                                          WHERE Id =: cq.RC_Bank_Key__c 
                                                                          LIMIT 1];
                    if(bankInformationList != null && bankInformationList.size() > 0){
                        chequeItem.banka = bankInformationList.get(0).RC_BANK__c;
                        chequeItem.sube = bankInformationList.get(0).RC_BRINCH__c;
                    }
                    
                    chequeItem.kesideYeri = cq.RC_Drawer_Region__c;
                    chequeItem.cekTutari = cq.RC_Amount__c;
                    chequeItem.vadeTarihi = String.valueOf(cq.RC_Due_Date__c.day() + '-'+ cq.RC_Due_Date__c.month() + '-'+ cq.RC_Due_Date__c.year());
                    
                    chequeItemList.add(chequeItem);
                }
                
                for(ChequeItem cqItem : chequeItemList){
                    genelToplam += cqItem.cekTutari;
                }
                ortalamaVade = String.valueOf(bordro.RC_Average_Due_Date__c.day() + '-' + bordro.RC_Average_Due_Date__c.month() + '-' + bordro.RC_Average_Due_Date__c.year());
                
                toplamCekSayisi = chequeList.size();
                
                system.debug('UserInfo.getUserId() : ' + UserInfo.getUserId());
                
                List<User> userList = [SELECT EmployeeNumber, Name, AccountId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
                if(userList != null && userList.size() > 0){
                    userKodu = userList.get(0).EmployeeNumber; 
                    adiSoyadi = userList.get(0).Name;
                    
                    List<RC_SD_Organization__c> organizationList = [SELECT Sales_Directorate__c FROM RC_SD_Organization__c WHERE RC_Account__c =: userList.get(0).AccountId LIMIT 1];
                    if(organizationList != null && organizationList.size() > 0){
                        
                        Map<String, String> salesPicklistMap = new Map<String, String>();
                        
                        Schema.DescribeFieldResult fieldResult = RC_SD_Organization__c.Sales_Directorate__c.getDescribe();
                        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                        for( Schema.PicklistEntry pickListVal : ple){
                            system.debug(pickListVal.getLabel() + ' - ' + pickListVal.getValue());
                            salesPicklistMap.put(pickListVal.getValue(), pickListVal.getLabel());
                        }
                        system.debug('salesPicklistMap : ' + salesPicklistMap);
                        
                        satisGrubu = salesPicklistMap.get(organizationList.get(0).Sales_Directorate__c);
                    }
                }
            }      
        }
        
    }
    
    public class ChequeItem{
        public String tarih {get;set;}
        public String cekNo {get;set;}
        public String banka {get;set;}
        public String sube {get;set;}
        public String kesideYeri {get;set;}
        public Double cekTutari {get;set;}
        public String vadeTarihi {get;set;}
    }
    
}