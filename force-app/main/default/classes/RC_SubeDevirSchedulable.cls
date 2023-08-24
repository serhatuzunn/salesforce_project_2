global class RC_SubeDevirSchedulable implements Schedulable, Database.AllowsCallouts{	
    
    //ŞUBE DEVIR ICIN YAPILACAKLAR
    //1- Şube Sil API çalıştırılır. Başarılı ise 
    //2- account ve organization bloke edilir
    //3- SdOrganization bloke edilir.
    //4- yeni account oluşturulur.(bloke olmuş account ve mys bilgileri ile yeni account oluşturulur.)
    //5- account oluştuğu anda sd_organization oluşur.  Eski sd_organization üzerindekiler yeni sd_organization üzerine taşınır.
    //6- Şube Yarat API çalıştırılır yeni account için
    //7- MYS approved yapıldı.
    //8- Account SapId update yapılır
    
    global void execute(SchedulableContext sc){        
        List<MYS_Open_Request__c> mysOpenRequestList = [SELECT Id, Name, RC_Account__c,RC_Dealer_Phone__c, RC_Account__r.Parent.RC_SAP_ID__c, RC_Dealer_Fax__c,RC_Dealer_Email__c,Country__c,RC_Geolocation__Latitude__s, RC_Geolocation__Longitude__s,RC_City__r.RC_Code__c, RC_District__r.Name, RC_Region__r.Name, RC_Changing_Type__c,RC_Company__c,RC_Postal_Code__c,RC_Region__r.RC_Code__c, MYS_Status__c, RC_Dealer__r.RC_SAP_ID__c, RC_Dealer__c, RC_New_Name__c, RC_Tax_Number__c, RC_Tax_Office__c
                                                        FROM MYS_Open_Request__c 
                                                        WHERE MYS_Status__c = 'Waiting SAP' and RC_Changing_Type__c = 'Code Change' and RC_Account_Sub_Type__c = 'Şube'];
        system.debug('mysOpenRequestList : ' + mysOpenRequestList);
        
        if(mysOpenRequestList != null && mysOpenRequestList.size() > 0){
            for(MYS_Open_Request__c mysOpenRequestItem : mysOpenRequestList){
                RC_SubeDevirBatchable sBatch = new RC_SubeDevirBatchable(mysOpenRequestItem);
                Database.executeBatch(sBatch);
            } 
        }
        else{
            system.debug('HATA : mysOpenRequestList');
        }
    }
    
    
}