public class RC_SubeDevirBatchable implements Database.Stateful,Database.Batchable<MYS_Open_Request__c>,Database.AllowsCallouts {
    
    private MYS_Open_Request__c processItem;  
    private RC_Logger__c errorData;
    private String errorMessage = '';
    
    private List<Account> accountList;
    private String newAccountId;
    private String newSdOrganizationId;
    
    public RC_SubeDevirBatchable(MYS_Open_Request__c mysOpenRequest){     
        this.processItem = mysOpenRequest;
    }
    
    public Iterable<MYS_Open_Request__c> start(Database.BatchableContext BC){
        return new List<MYS_Open_Request__c>{
            this.processItem
                };
                    
                    }
    
    public void execute(Database.BatchableContext info , List<MYS_Open_Request__c> itemList){
        try{
            for(MYS_Open_Request__c mysOpenRequestItem : itemList){
                
                system.debug('mysOpenRequestItem : ' + mysOpenRequestItem);
                
                List<RC_SD_Organization__c> sdOrganizationList =  [SELECT Id, RC_Account__c, RC_Account__r.RC_SAP_ID__c, RC_Account__r.RC_Country__c, RC_Account__r.Parent.RC_SAP_ID__c, RC_Sales_Organization__c, RC_Division__c, Distribution_Channel__c 
                                                                   FROM RC_SD_Organization__c 
                                                                   WHERE RC_Account__c =: mysOpenRequestItem.RC_Account__c
                                                                   LIMIT 1];
                system.debug('sdOrganizationList : ' + sdOrganizationList);
                
                accountList = [SELECT RC_Sub_Type__c,RC_Dealer_Type__c, RC_Country__c, RC_City__c, RC_Region__c, RC_District__c, RC_Geolocation__Latitude__s, RC_Geolocation__Longitude__s,RC_Postal_Code__c,RC_Street__c,ParentId, Id 
                               FROM Account 
                               WHERE Id =: mysOpenRequestItem.RC_Account__c
                               LIMIT 1];
                system.debug('accountList : ' + accountList);
                
                if(sdOrganizationList != null && sdOrganizationList.size() > 0 && accountList != null && accountList.size() > 0){
                    
                    //1- Sube Sil API çalıştırılır.
                    RC_SubeSilIntegratorParser integratorParser = RC_DevirCommon.SubeSilApi(sdOrganizationList.get(0));
                    
                    if(integratorParser.EV_SUCCESS == 'X'){
                        //2-Account bloke edilir.
                        RC_DevirCommon.BlockAccount(accountList.get(0));
                        
                        //3- SdOrganization bloke edilir.
                        RC_DevirCommon.BlockSdOrganization(sdOrganizationList.get(0));
                        
                        //4-Yeni account oluşturulur.
                        newAccountId = RC_DevirCommon.CreateAccount(mysOpenRequestItem, accountList.get(0));
                        system.debug('newAccountId : ' + newAccountId);
                        
                        //5- account oluştuğu anda sd_organization oluşur. Eski sd_organization üzerindekiler yeni sd_organization üzerine taşınır.
                        newSdOrganizationId = RC_DevirCommon.CreateNewSdOrganization(accountList.get(0).Id, newAccountId);
                        system.debug('newSdOrganizationId : ' + newSdOrganizationId);
                    }
                    else{
                        this.errorMessage = 'HATA : RC_DevirCommon.SubeSilApi integratorParser';
                    }                 
                }
                else{
                    system.debug('HATA : sdOrganizationList - accountList');
                }
            }
        }catch(Exception e){
            this.errorData = new RC_Logger__c(
                RC_Message__c = e.getMessage()
            );
            system.debug('HATA : ' + e.getMessage());
            RC_Logger.LOG_EXCEPTION(e.getMessage(), e.getMessage(), '', 'RC_SubeDevirBatchable', 'execute', '');

        }
    }
    
    public void finish(Database.BatchableContext info){
        
        SubeYarat(Json.serialize(processItem), Json.serialize(accountList), newSdOrganizationId, newAccountId);
        
        if(this.errorData != null){
            insert this.errorData;
        }
        if(String.isNotBlank(this.errorMessage)){
            insert new RC_Logger__c(
                RC_message__c = this.errorMessage
            );
        }
    }
    
    public static void SubeYarat(String mysOpenRequestItemString, String accountListString, String newSdOrganizationId, String newAccountId){
        
        system.debug('mysOpenRequestItemString : ' + mysOpenRequestItemString);
        system.debug('accountListString : ' + accountListString);
        system.debug('newSdOrganizationId : ' + newSdOrganizationId);
        system.debug('newAccountId : ' + newAccountId);
        
        MYS_Open_Request__c mysOpenRequestItem = (MYS_Open_Request__c)Json.deserialize(mysOpenRequestItemString, MYS_Open_Request__c.class);
        List<Account> accountList = (List<Account>)Json.deserialize(accountListString, List<Account>.class);
        
        //6- Şube yarat API çalıştırılır.
        RC_SubeYaratIntegratorParser integratorSubeYaratParser = RC_DevirCommon.SubeYarat(mysOpenRequestItem, newSdOrganizationId, accountList);
        
        //API Result
        if(integratorSubeYaratParser.EV_SUCCESS == 'X'){
            
            //7- MYS approved yapılır.
            RC_DevirCommon.MysApproved(mysOpenRequestItem);
            
            //8- Account SapId update yapılır
            RC_DevirCommon.UpdateAccountSapId(newAccountId, integratorSubeYaratParser);
            
            system.debug('Şube Yarat Başarılı');
            system.debug('Şube Devir işlemi gerçekleşti.');
        }
        else{
            mysOpenRequestItem.RC_SAP_Message__c = integratorSubeYaratParser.ET_RETURN.item[0].MESSAGE;
            update mysOpenRequestItem;
            system.debug('HATA : RC_DevirCommon.SubeYarat RC_SubeYaratIntegratorParser');
        }
    }
    
}