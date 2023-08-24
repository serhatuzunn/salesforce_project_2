public with sharing class RC_SD_DeltaCustomerReaderQueueable implements Queueable, Database.AllowsCallouts {
    // TODO: Account Warehouse setlemesinde Definition uyarlaması yapılacak.
    private RC_SD_DeltaCustomerIntegrator.HeaderModel updatedDataForDegisen = new RC_SD_DeltaCustomerIntegrator.HeaderModel();
    private RC_SD_DeltaCustomerIntegrator.HeaderModel updatedDataForYeni = new RC_SD_DeltaCustomerIntegrator.HeaderModel();
    private List<RC_Logger__c> errorLogList = new List<RC_Logger__c>();
    
    private RC_SD_DeltaCustomerIntegrator.RequestModel requestData {get; set;}
    private String processType {get; set;}
    private String runDateVal {get; set;}
    
    private Boolean alreadyRun = false;
    
    private List<RC_SD_DeltaCustomerIntegrator.DetailModel> processableDataList {get; set;}
    private Map<String, Map<String, String>> cityRegionMap {get; set;}
    
    private static final Integer processableDataCount = 5;
    
    public RC_SD_DeltaCustomerReaderQueueable(RC_SD_DeltaCustomerIntegrator.HeaderModel udfd, String proctype, String runDate, RC_SD_DeltaCustomerIntegrator.RequestModel reqData) {
        if(proctype == 'Değişen'){
            updatedDataForDegisen = udfd;
            processType = proctype;
            runDateVal = runDate;
            requestData = reqData;
        }
    }
    
    public void execute(QueueableContext qc){
        try {           
            RC_SD_DeltaCustomerIntegrator.ResponseModel response = null;
            if(this.requestData != null){
                response = RC_SD_DeltaCustomerIntegrator.getDeltaCustomer(requestData);
                
                if(response != null && response.ET_DEGISEN != null && response.ET_DEGISEN.item != null){
                    this.updatedDataForDegisen = response.ET_DEGISEN;
                }      
                
                if(this.updatedDataForDegisen != null){
                    processableDataList = prepareDataList(this.processType);
                    
                    updateAccountAndRelatedData();                    
                }
            }else{
                processableDataList = prepareDataList(this.processType);
                
                updateAccountAndRelatedData();
            }
        } catch (Exception e) {
            RC_Logger.LOG_EXCEPTION('RC_SD_DeltaCustomerReaderQueueable Error', e.getMessage(), e.getStackTraceString(), 'RC_SD_DeltaCustomerReaderQueueable', 'execute', '');
        }
    }
    
    // ET_DEGISEN datasının işlendiği ana method.
    private void updateAccountAndRelatedData(){
        MuhatapControlSetting__c mcs = MuhatapControlSetting__c.getValues('MuhatapSapIDList');
        String sapIdVal = mcs != null ? mcs.MuhatapSapID__c : '';
        
        Set<String> processAccountIDSet = new Set<String>();
        Map<String, Id> foundedAccountMap = new Map<String, Id>();
        Map<String, String> relatedRoleMap = new Map<String, String>();
        Map<String, User> relatedUserMap = new Map<String, User>();
        Map<String, Map<String, String>> accountRelatedRoleMapOld = new Map<String, Map<String, String>>();
        Map<String, Boolean> weRoleControlMap = new Map<String, Boolean>();
        
        List<Account> updateAccountList = new List<Account>();
        List<RC_SD_Organization__c> insertSDOrgList = new List<RC_SD_Organization__c>();
        Set<String> relatedChildAccountSet = new Set<String>();
        List<RC_Account_Role__c> insertAccountRoleList = new List<RC_Account_Role__c>();
        List<RC_Account_Warehouse__c> insertWarehouseList = new List<RC_Account_Warehouse__c>();
        
        List<String> codeList = new List<String>();
        for(RC_SD_DeltaCustomerIntegrator.DetailModel item : this.processableDataList){ 
            do {
                item.KUNNR = item.KUNNR.removeStart('0');
            } while (item.KUNNR.startsWith('0'));     
            
            if(sapIdVal.contains(item.KUNNR)) continue;
            
            processAccountIDSet.add(item.KUNNR);
            
            codeList.add(item.CITYP_CODE);
            codeList.add(item.CITY_CODE);
            codeList.add(item.REGION);
            codeList.add(item.LZONE);
            
            for(RC_SD_DeltaCustomerIntegrator.PARVWDetail detail : item.PARVW_TT.item){
                do {
                    detail.KUNN2 = detail.KUNN2.removeStart('0');
                } while (detail.KUNN2.startsWith('0'));        
                
                processAccountIDSet.add(detail.KUNN2);
                
                if(detail.PARVW == 'BS'){
                    weRoleControlMap.put(item.KUNNR, true);
                }
            }
        }
        
        this.cityRegionMap = RC_UtilitiesClass.getCityMappedData(codeList);
        
        for(Account item : [SELECT Id, RC_SAP_ID__c, (SELECT Id, RC_Unique_ID__c FROM Account_Roles1__r) FROM Account WHERE RC_SAP_ID__c =: processAccountIDSet]){
            foundedAccountMap.put(item.RC_SAP_ID__c, item.Id);
            
            for(RC_Account_Role__c role : item.Account_Roles1__r){
                if(!accountRelatedRoleMapOld.containsKey(item.RC_SAP_ID__c)){
                    Map<String, String> itemMap = new Map<String, String>();
                    itemMap.put(role.RC_Unique_ID__c, role.Id);
                    
                    accountRelatedRoleMapOld.put(item.RC_SAP_ID__c, itemMap);
                }
                else{
                    Map<String, String> itemMap = accountRelatedRoleMapOld.get(item.RC_SAP_ID__c);
                    itemMap.put(role.RC_Unique_ID__c, role.Id);
                    
                    accountRelatedRoleMapOld.put(item.RC_SAP_ID__c, itemMap);
                }
            }
        }
        
        for(RC_SD_DeltaCustomerIntegrator.DetailModel item : this.processableDataList){ 
            do {
                item.KUNNR = item.KUNNR.removeStart('0');
            } while (item.KUNNR.startsWith('0'));
            
            if(sapIdVal.contains(item.KUNNR)) continue;
            
            // Account yaratılırken gerekli dataların hazırlığı
            Id districtID = this.cityRegionMap.containsKey('District') ? this.cityRegionMap.get('District').get(item.CITYP_CODE) : null;
            Id regionID = this.cityRegionMap.containsKey('Region') ? this.cityRegionMap.get('Region').get(item.CITY_CODE) : null;
            Id cityID = this.cityRegionMap.containsKey('City') ? this.cityRegionMap.get('City').get(item.REGION) : null;
            Id zoneID = this.cityRegionMap.containsKey('Transport Zone') ? this.cityRegionMap.get('Transport Zone').get(item.LZONE) : null;
            
            DeltaCustomerGroup__c relatedGroupInfo = DeltaCustomerGroup__c.getValues(item.BU_GROUP);
            
            String blockData = '';
            if(item.XBLCK == 'X'){blockData = 'XBLCK';}
            
            if(item.SPERR == 'X'){blockData = 'SPERR';}
            
            Id existAccountId = foundedAccountMap.containsKey(item.KUNNR) ? foundedAccountMap.get(item.KUNNR) : null;
            
            String recordTypeId = '';
            if(relatedGroupInfo.DealerType__c == 'SUBE/DEPO' || relatedGroupInfo.DealerType__c == 'KURUMSAL MAGAZA'){
                recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Store').getRecordTypeId();
            }else{                
                recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            }
            
            //Account Yaratma
            Account newAccount = new Account(
                RC_SAP_ID__c = item.KUNNR,
                Name = String.format('{0} {1}', new String[]{item.NAME1, item.NAME2}),
                RC_SORTL__c = item.SORTL,
                RC_Street__c = String.format('{0} {1}', new String[]{item.STREET, item.HOUSE_NUM1}),
                RC_District__c = districtID,
                RC_Postal_Code__c = item.POST_CODE1,
                RC_Region__c = regionID,
                RC_City__c = cityID,
                RC_Country__c = item.COUNTRY,
                RC_Transport_Zone__c = zoneID,
                RC_Email__c = item.SMTP_ADDR.remove(' '),
                Phone = item.TEL_NUMBER,
                RC_Tax_Number__c = item.TAXNUM_NO,
                RC_Tax_Office__c = item.TAXNUM_DR,
                RC_Block__c = blockData,
                RC_Location_Code__c = item.LOCCO,
                RC_Geolocation__Latitude__s = item.ZZLATITUDE,
                RC_Geolocation__Longitude__s = item.ZLONGITUDE,
                RC_Dealer_Type__c = relatedGroupInfo.DealerType__c,
                RecordTypeId = recordTypeId
            );
            
            if(existAccountId != null)                
                newAccount.Id = existAccountId;
            
            if(String.isNotBlank(relatedGroupInfo.SubType__c))
                newAccount.RC_Sub_Type__c = relatedGroupInfo.SubType__c;
            
            updateAccountList.add(newAccount);
        }
        
        Map<String, Id> relatedAccountMap = upsertAndRetrieveAccountMap(updateAccountList, false);    
        
        for(String item : relatedAccountMap.keySet()){
            foundedAccountMap.put(item, relatedAccountMap.get(item));
        }
        
        Map<String, Boolean> roleControlMap = createRoleControlMap(this.processableDataList, processAccountIDSet);
        
        Map<String, Account> updateAccountMap = new Map<String, Account>();
        for (RC_SD_DeltaCustomerIntegrator.DetailModel item : this.processableDataList) {   
            do {
                item.KUNNR = item.KUNNR.removeStart('0');
            } while (item.KUNNR.startsWith('0')); 
            
            if(sapIdVal.contains(item.KUNNR)) continue;
            
            System.debug('---------------------------| Process Start For : ' + item.KUNNR + ' |---------------------------------------');
            DeltaCustomerGroup__c relatedGroupInfo = DeltaCustomerGroup__c.getValues(item.BU_GROUP);
            
            if(item.ZMM_NOPT_CT0002 != null){
                for(RC_SD_DeltaCustomerIntegrator.ZMMNOPTCTDetail data : item.ZMM_NOPT_CT0002.item){   
                    do {
                        data.MUSTERI_ADI = data.MUSTERI_ADI.removeStart('0');
                    } while (data.MUSTERI_ADI.startsWith('0')); 
                    
                    Id relatedAccountID = foundedAccountMap.containsKey(data.MUSTERI_ADI) ? foundedAccountMap.get(data.MUSTERI_ADI) : null;
                    
                    String uniqueKey = String.format('{0}-{1}-{2}', new String[]{data.MUSTERI_ADI, data.DEPO_TIPI, data.URETIM_YERI});
                    
                    if(relatedAccountID == null || uniqueKey.contains('null')) continue;
                    
                    RC_Account_Warehouse__c newWarehouse = new RC_Account_Warehouse__c(
                        RC_Account__c = relatedAccountID,
                        RC_Warehouse_Type__c = data.DEPO_TIPI,
                        RC_Production_Place__c = data.URETIM_YERI,
                        RC_Sales_Organization__c = data.VKORG,
                        RC_Distribution_Channel__c = data.VTWEG,
                        RC_Unique_ID__c = uniqueKey
                    );
                    
                    insertWarehouseList.add(newWarehouse);
                }
            }
            
            Map<String, String> oldRoleMap = accountRelatedRoleMapOld.get(item.KUNNR);
            for(RC_SD_DeltaCustomerIntegrator.PARVWDetail detail : item.PARVW_TT.item){
                do {
                    detail.KUNN2 = detail.KUNN2.removeStart('0');
                } while (detail.KUNN2.startsWith('0')); 
                
                relatedChildAccountSet.add(detail.KUNN2);
                Id parentAccountID = foundedAccountMap.containsKey(item.KUNNR) ? foundedAccountMap.get(item.KUNNR) : null;
                Id childAccountID = foundedAccountMap.containsKey(detail.KUNN2) ? foundedAccountMap.get(detail.KUNN2) : null;
                Boolean isBSExist = weRoleControlMap.containsKey(item.KUNNR) ? weRoleControlMap.get(item.KUNNR) : false;
                
                String uniqueKey = String.format('{0}-{1}-{2}-{3}-{4}-{5}', new String[]{item.KUNNR, detail.KUNN2, detail.VKORG, detail.VTWEG, detail.PARVW, detail.SPART});
                System.debug('Child Acc : '+ detail.KUNN2 + ' || Role Unique Key : ' + uniqueKey);
                
                
                if(parentAccountID== null || uniqueKey.contains('null')) continue;
                
                if(oldRoleMap != null && oldRoleMap.containsKey(uniqueKey)){oldRoleMap.remove(uniqueKey);}
                
                if(detail.PARVW == 'SS'){                    
                    relatedRoleMap.put(String.format('{0}-{1}-{2}-{3}', new String[]{detail.PARVW, item.KUNNR, detail.VKORG, detail.VTWEG}), detail.KUNN2);
                }
                else{ 
                    RC_Account_Role__c newAccountRole = new RC_Account_Role__c(
                        RC_Parent_Account__c = parentAccountID,
                        RC_Sales_Organization__c = detail.VKORG,
                        RC_Distribution_Channel__c = detail.VTWEG,
                        RC_Role__c = detail.PARVW,
                        RC_Account__c = childAccountID,
                        RC_Unique_ID__c = uniqueKey,
                        RC_Division__c = detail.SPART
                    );
                    
                    if (detail.PARVW == 'BS') {
                        if(item.KUNNR != detail.KUNN2) {
                            System.debug('BS Process SAP : ' + item.KUNNR + ' || ' + detail.KUNN2);
                            System.debug('BS Process ID : ' + parentAccountID + ' || ' + childAccountID);
                            
                            Account updateAccount = new Account(
                                Id = childAccountID,
                                RC_Sub_Type__c = 'Şube',
                                ParentId = parentAccountID
                            );
                            
                            updateAccountMap.put(childAccountID, updateAccount);
                        }
                    }
                    
                    if(!isBSExist){
                        if(relatedGroupInfo.SubType__c == 'Regal' && detail.PARVW == 'WE'){
                            Boolean isBSRoleExist = roleControlMap.containsKey(detail.KUNN2) ? roleControlMap.get(detail.KUNN2) : false;
                            
                            if(!isBSRoleExist){
                                Account updateAccount = new Account(
                                    Id = childAccountID,
                                    RC_Sub_Type__c = 'Şube',
                                    ParentId = parentAccountID
                                );
                                
                                updateAccountMap.put(childAccountID, updateAccount);
                            }
                        }                        
                    }
                    
                    insertAccountRoleList.add(newAccountRole);
                }
            }
            
            if(oldRoleMap != null)
                accountRelatedRoleMapOld.put(item.KUNNR, oldRoleMap);
        }
        
        System.debug('Update PA : ' + updateAccountMap.values().size());
        if(updateAccountMap.values().size() > 0){
            for(Account acc : updateAccountMap.values()){
                System.debug('PA Acc : ' + acc);
            }
            List<Database.UpsertResult> paUpsertResult = Database.upsert(updateAccountMap.values(), false);
            for(Database.UpsertResult ur : paUpsertResult){
                if (!ur.isSuccess()) {
                    System.debug('Değişen PA : ' + ur.getErrors());
                }
                else{
                    System.debug('Başarılı PA : ' + ur.getId());
                }
            }             
        }
        
        System.debug('Insert AR : ' + insertAccountRoleList.size());
        Integer countForAR = 0;
        List<Database.UpsertResult> arUpsertResult = Database.upsert(insertAccountRoleList, RC_Account_Role__c.RC_Unique_ID__c, false);
        for(Database.UpsertResult ur : arUpsertResult){
            if (!ur.isSuccess()) {                
                RC_Account_Role__c errorAR = insertAccountRoleList.get(countForAR);
                
                String errorMessage = String.format('Job Run Date : {0} || Combined Unique Key : {1} || Error : {2}', new String[]{this.runDateVal, errorAR.RC_Unique_ID__c, JSON.serialize(ur.getErrors())});
                    
                RC_Logger__c logItem = RC_Logger.LOG_INFOFORPROCESSES('Upsert Process Failed For Account Role', errorMessage, 'RC_SD_DeltaCustomerReaderQueueable', 'updateAccountAndRelatedDAta', '', 'Account Role');
            
                if(logItem != null)
            		this.errorLogList.add(logItem);
            }
            else{
                System.debug('Başarılı AR : ' + ur.getId());
            }
            
            countForAR++;
        } 
        
        System.debug('Insert WH : ' + insertWarehouseList.size());
        Integer countForWH = 0;
        List<Database.UpsertResult> whUpsertResult = Database.upsert(insertWarehouseList, RC_Account_Warehouse__c.RC_Unique_ID__c, false);
        for(Database.UpsertResult ur : whUpsertResult){
            if (!ur.isSuccess()) {              
                RC_Account_Warehouse__c errorWH = insertWarehouseList.get(countForWH);
                
                String errorMessage = String.format('Job Run Date : {0} || Combined Unique Key : {1} || Error : {2}', new String[]{this.runDateVal, errorWH.RC_Unique_ID__c, JSON.serialize(ur.getErrors())});
                    
                RC_Logger__c logItem = RC_Logger.LOG_INFOFORPROCESSES('Upsert Process Failed For Account Warehouse', errorMessage, 'RC_SD_DeltaCustomerReaderQueueable', 'updateAccountAndRelatedDAta', '', 'Account Warehouse');
            
                if(logItem != null)
            		this.errorLogList.add(logItem);
            }
            else{
                System.debug('Başarılı WH : ' + ur.getId());
            }
            
            countForWH++;
        }          
        
        for(User item : [SELECT Id, EmployeeNumber FROM User WHERE EmployeeNumber =: relatedChildAccountSet]){
            relatedUserMap.put(item.EmployeeNumber, item);
        }
        System.debug('relatedRoleMap : ' + relatedRoleMap.keySet());
        for(RC_SD_DeltaCustomerIntegrator.DetailModel item : this.processableDataList){            
            do {
                item.KUNNR = item.KUNNR.removeStart('0');
            } while (item.KUNNR.startsWith('0'));
            
            if(sapIdVal.contains(item.KUNNR)) continue;
            
            for(RC_SD_DeltaCustomerIntegrator.SaleDetail data : item.SATIS_ANAVERILERI.item){  
                do {
                    data.KUNNR = data.KUNNR.removeStart('0');
                } while (data.KUNNR.startsWith('0'));
                
                String key = String.format('{0}-{1}-{2}-{3}', new String[]{'SS', data.KUNNR, data.VKORG, data.VTWEG});
                String uniqueKey = String.format('{0}-{1}-{2}-{3}', new String[]{data.KUNNR, data.VKORG, data.VTWEG, data.SPART});               
                
                Id relatedAccountID = foundedAccountMap.containsKey(data.KUNNR) ? foundedAccountMap.get(data.KUNNR) : null;
                
                if(relatedAccountID == null || uniqueKey.contains('null')) continue;
                System.debug('Key : ' + key);
                Boolean isSSData = relatedRoleMap.containsKey(key) ? true : false;
                String userKey = isSSData ? String.valueOf(relatedRoleMap.get(key)) : '';
                Id userId = null;
                if(isSSData && String.IsNotBlank(userKey))
                    userId = relatedUserMap.containsKey(userKey) ? relatedUserMap.get(userKey).Id : null;
                System.debug('isSSData : ' + isSSData + ' || UserKey : ' + userKey);
                RC_SD_Organization__c newSDOrg = new RC_SD_Organization__c(
                    RC_Account__c = relatedAccountID,
                    RC_Sales_Organization__c = data.VKORG,
                    Distribution_Channel__c = data.VTWEG,
                    Sales_Directorate__c = data.VKGRP,
                    RC_Regional_Directorate__c = data.VKBUR,
                    RC_BZIRK__c = data.BZIRK,
                    CurrencyIsoCode = data.WAERS,
                    RC_Price_Group__c = data.KONDA,
                    RC_Order_Blockage__c = data.AUFSD,
                    RC_Delivery_Blockage__c = data.LIFSD,
                    RC_Invoice_Blockage__c = data.FAKSD,
                    RC_Sales_Expert__c = isSSData ? userId : null,
                    RC_Unique_ID__c = uniqueKey,
                    RC_Division__c = data.SPART
                );
                
                insertSDOrgList.add(newSDOrg);
            }
        }        
        
        System.debug('Insert SD : ' + insertSDOrgList.size());
        Integer countForSD = 0;
        List<Database.UpsertResult> accUpsertResult = Database.upsert(insertSDOrgList, RC_SD_Organization__c.RC_Unique_ID__c, false);
        for(Database.UpsertResult ur : accUpsertResult){
            if (!ur.isSuccess()) {      
                RC_SD_Organization__c errorSD = insertSDOrgList.get(countForSD);
                
                String errorMessage = String.format('Job Run Date : {0} || Combined Unique Key : {1} || Error : {2}', new String[]{this.runDateVal, errorSD.RC_Unique_ID__c, JSON.serialize(ur.getErrors())});
                    
                RC_Logger__c logItem = RC_Logger.LOG_INFOFORPROCESSES('Upsert Process Failed For SD Organization', errorMessage, 'RC_SD_DeltaCustomerReaderQueueable', 'updateAccountAndRelatedDAta', '', 'SD Organization');
            
                if(logItem != null)
            		this.errorLogList.add(logItem);
            }
            else{
                System.debug('Başarılı SD : ' + ur.getId());
            }
            
            countForSD++;
        }        
        
        List<RC_Account_Role__c> deactiveRoleList = new List<RC_Account_Role__c>();
        for(String key : accountRelatedRoleMapOld.keySet()){
            Map<String, String> relatedMap = accountRelatedRoleMapOld.get(key);
            
            for(String item : relatedMap.values()){
                RC_Account_Role__c updateAccount = new RC_Account_Role__c(
                    Id = item,
                    RC_Is_Role_Active__c = false
                );
                
                deactiveRoleList.add(updateAccount);
            }
        }        
        
        if(deactiveRoleList != null && deactiveRoleList.size() > 0)
            Database.upsert(deactiveRoleList);
       
        Database.insert(this.errorLogList);
        
        createNextQueue();
    }
    
    /*
		Aşağı bölümde bulunan methodlar helper methodlarıdır.
	*/
    
    private Map<String,Id> upsertAndRetrieveAccountMap(List<Account> accountList, Boolean allOrNothing){
        Map<String, Id> relatedAccountMap = new Map<String, Id>();
        List<Id> savedAccountIDList = new List<Id>();
        
        Integer count = 0;
        List<Database.UpsertResult> accUpsertResult = Database.upsert(accountList, allOrNothing);
        for(Database.UpsertResult ur : accUpsertResult){
            if (ur.isSuccess()) {
                savedAccountIDList.add(ur.getId());
            }
            else{
                Account errorAcc = accountList.get(count);
                
                String errorMessage = String.format('Job Run Date : {0} || Account Info : {1} - {2} || Errors : {3}', new String[]{this.runDateVal, errorAcc.RC_SAP_ID__c, errorAcc.Name, JSon.serialize(ur.getErrors())});
                    
                RC_Logger__c logItem = RC_Logger.LOG_INFOFORPROCESSES('Upsert Process Failed For Account', errorMessage, 'RC_SD_DeltaCustomerReaderQueueable', 'upsertAndRetrieveAccountMap', '', 'Account');
            
                if(logItem != null)
            		this.errorLogList.add(logItem);
            }
            
            count++;
        }
        
        if(savedAccountIDList != null && savedAccountIDList.size() > 0){
            for(Account item : [SELECT Id, RC_SAP_ID__c FROM Account WHERE Id =: savedAccountIDList]){
                relatedAccountMap.put(item.RC_SAP_ID__c, item.Id);
            }
        }
        
        return relatedAccountMap;
    }
    
    // Role Kontrol Süreci için Map oluşturma
    private Map<String, Boolean> createRoleControlMap(List<RC_SD_DeltaCustomerIntegrator.DetailModel> dataList, Set<String> processAccountIDSet){
        Map<String, Boolean> roleControlMap = new Map<String, Boolean>();
        
        for(RC_SD_DeltaCustomerIntegrator.DetailModel item : dataList){             
            DeltaCustomerGroup__c relatedGroupInfo = DeltaCustomerGroup__c.getValues(item.BU_GROUP);
            
            for(RC_SD_DeltaCustomerIntegrator.PARVWDetail data : item.PARVW_TT.item){
                String kunnr = String.valueOf(data.KUNNR);
                if(relatedGroupInfo.SubType__c == 'Regal'){   
                    if(data.PARVW == 'BS'){
                        if(!roleControlMap.containsKey(kunnr)){
                            roleControlMap.put(kunnr, true);
                        }
                    }
                }
            }
        }
        
        for(RC_Account_Role__c item : [SELECT RC_Parent_Account__r.RC_SAP_ID__c FROM RC_Account_Role__c WHERE RC_Parent_Account__r.RC_SAP_ID__c =: processAccountIDSet AND RC_Role__c = 'BS']){
            roleControlMap.put(item.RC_Parent_Account__r.RC_SAP_ID__c, true);
        }
        
        return roleControlMap;
    }
    
    // Zincir Queue Oluşturma Kontrolü
    private void createNextQueue(){
        
        System.debug('Next Queue');
        // Değişen datasının queue oluşturma kontrolü
        if(this.processType == 'Değişen'){
            System.debug('Next Queue Prepare');
            if(this.updatedDataForDegisen.item.size() > 0){
                System.debug('Next Queue Start');
                RC_SD_DeltaCustomerReaderQueueable queue = new RC_SD_DeltaCustomerReaderQueueable(
                    updatedDataForDegisen,
                    processType,
                    runDateVal,
                    null
                );
                
                System.enqueueJob(queue);
            }
        }   

    }
    
    // Zincir queue yapısı oluştururken işlencek data ayrımını yapan method
    private List<RC_SD_DeltaCustomerIntegrator.DetailModel> prepareDataList(String type){
        List<RC_SD_DeltaCustomerIntegrator.DetailModel> dataList = new List<RC_SD_DeltaCustomerIntegrator.DetailModel>();
        
        switch on type {
            when 'Değişen' {
                if(this.updatedDataForDegisen.item.size() >= processableDataCount){
                    for(RC_SD_DeltaCustomerIntegrator.DetailModel dm : this.updatedDataForDegisen.item){
                    }                    
                    
                    for(Integer index = 0; index < processableDataCount; index++){
                        dataList.add(this.updatedDataForDegisen.item.get(0));
                        this.updatedDataForDegisen.item.remove(0);
                    }
                }
                else {
                    dataList = this.updatedDataForDegisen.item;
                    this.updatedDataForDegisen.item = new List<RC_SD_DeltaCustomerIntegrator.DetailModel>();
                }
            }
        }
        
        return dataList;
    }
}