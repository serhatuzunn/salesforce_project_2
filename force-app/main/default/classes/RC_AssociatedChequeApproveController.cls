public with sharing class RC_AssociatedChequeApproveController {

    @AuraEnabled
    public static InitializeWrapper initialize(){
        InitializeWrapper iw = new InitializeWrapper();
        try {
            iw.baglantiDonem = getBaglantiCariDonems();
            iw.uygulamaKanal = getCreditControls();
            iw.odemeKosul = getPaymentTypes();
            iw.paymentForm = getPaymentForms();
            iw.bordroTip = getBordroTypes();
            
            iw.kullanicilar = getUsers();
            iw.anlikKullanici = [SELECT Id, Name, UserRole.DeveloperName, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];
            iw.aggrList = getUserRelatedDistributionChannel();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return iw;
    }

    @AuraEnabled
    public static List<RC_Financial_Process_Definition__c> getEntries(String uygulamaKanal, String cariDonem, List<String> salesExpert){
        List<RC_Financial_Process_Definition__c> foundedEntries = new List<RC_Financial_Process_Definition__c>();
        try {
            String userApproveLevel = retrieveApproveLevel(null);

            String query = 'SELECT Id, RC_Start_Date__c, RC_Term_ID__r.RC_Payment_Form__c, RC_TERM_ID__r.RC_Start_Date__c, RC_TERM_ID__r.RC_End_Date__c, RC_Term_ID__r.RC_Comments__c, RC_Bordro_Status__c, RC_IsExtra__c, RC_Approval_Status__c, RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c, RC_Comments__c, RC_Amount__c, RC_Average_Due_Date__c, RC_Bordro_Types__c, RC_Payment_Term__c, RC_Term_ID__c, RC_KKA__c, RC_KKA_Defination__c, RC_Bordro_No__c, CreatedById, CreatedBy.Name, CreatedBy.ManagerId, CreatedBy.RC_ManagerId_2__c, CreatedBy.Manager_3__c, CreatedBy.Manager_4__c  FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = \'Connection_Bordro_Entry\'';

            if(String.isNotBlank(uygulamaKanal) && uygulamaKanal != 'all'){
                query += ' AND RC_KKA__c = \'' +  uygulamaKanal + '\'';
            }

            if(String.isNotBlank(cariDonem) && cariDonem != 'all'){
                query += ' AND RC_Term_ID__c = \'' +  cariDonem + '\'';
            }

            if(salesExpert != null && salesExpert.size() > 0){
                query += ' AND CreatedById IN (';

                for(String se : salesExpert){
                    query += '\'' + se + '\',';
                }

                query = query.removeEnd(',') + ')';
            }

            if(String.isNotBlank(userApproveLevel)){
                query += ' AND (RC_Approval_Status__c = \'1\' OR (RC_Approval_Status__c != \'0\' AND RC_Approval_Status__c != \'5\'))';
            }
            
            foundedEntries = Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return foundedEntries;
    }

    @AuraEnabled
    public static UserMapWrapper getUsers(){
        UserMapWrapper umw = new UserMapWrapper();

        List<User> foundedUsers = new List<User>();

        List<String> userKKAMap = new List<String>();
        Set<String> userIDList = new Set<String>();
        String queryy = 'SELECT RC_Credit_Control_Field__c, RC_Sales_Expert__c, RC_Sales_Expert__r.Name, RC_Sales_Expert__r.UserRole.DeveloperName, RC_Sales_Expert__r.UserRole.Name, RC_Sales_Expert__r.ManagerId, RC_Sales_Expert__r.RC_ManagerId_2__c, RC_Sales_Expert__r.Manager_3__c, RC_Sales_Expert__r.Manager_4__c FROM RC_SD_Organization__c WHERE (RC_Sales_Expert__r.ManagerId = \'' + UserInfo.getUserId() + '\' OR RC_Sales_Expert__r.RC_ManagerId_2__c = \'' + UserInfo.getUserId() + '\' OR RC_Sales_Expert__r.Manager_3__c = \'' +  UserInfo.getUserId() + '\' OR RC_Sales_Expert__r.Manager_4__c = \'' + UserInfo.getUserId() + '\')';

        for(RC_SD_Organization__c sdOrg : Database.query(queryy)){
            if(String.isNotBlank(sdOrg.RC_Sales_Expert__c)){
                userIDList.add(sdOrg.RC_Sales_Expert__c);

                if(String.isNotBlank(sdOrg.RC_Sales_Expert__r.ManagerId))
                    userIDList.add(sdOrg.RC_Sales_Expert__r.ManagerId);
                
                if(String.isNotBlank(sdOrg.RC_Sales_Expert__r.RC_ManagerId_2__c))
                    userIDList.add(sdOrg.RC_Sales_Expert__r.RC_ManagerId_2__c);
                    
                if(String.isNotBlank(sdOrg.RC_Sales_Expert__r.Manager_3__c))
                    userIDList.add(sdOrg.RC_Sales_Expert__r.Manager_3__c);
                
                if(String.isNotBlank(sdOrg.RC_Sales_Expert__r.Manager_4__c))
                    userIDList.add(sdOrg.RC_Sales_Expert__r.Manager_4__c);
                
                String code = sdOrg.RC_Credit_Control_Field__c +'-'+ sdOrg.RC_Sales_Expert__c+'-'+ sdOrg.RC_Sales_Expert__r.ManagerId+'-'+ sdOrg.RC_Sales_Expert__r.RC_ManagerId_2__c+'-'+ sdOrg.RC_Sales_Expert__r.Manager_3__c+'-'+ sdOrg.RC_Sales_Expert__r.Manager_4__c;

                userKKAMap.add(code);
            }
        }

        String query = 'SELECT Id, Name, UserRole.DeveloperName, UserRole.Name, ManagerId, RC_ManagerId_2__c, Manager_3__c, Manager_4__c FROM User WHERE ';

        if(userIDList != null && userIDList.size() > 0){
            query += 'Id IN (';
            
            for(String id : userIDList){
                query += '\'' + id + '\',';
            }

            query = query.removeEnd(',') + ')';
        }

        foundedUsers = Database.query(query);

        umw.kullanicilar = foundedUsers;
        umw.userKKAMap = userKKAMap;

        return umw;
    }

    @AuraEnabled
    public static List<AggregateResult> getUserRelatedDistributionChannel(){
        List<AggregateResult> aggrList = new List<AggregateResult>();

        String query = 'SELECT RC_Credit_Control_Field__c FROM RC_SD_Organization__c WHERE (RC_Sales_Expert__r.ManagerId = \'' + UserInfo.getUserId() + '\' OR RC_Sales_Expert__r.RC_ManagerId_2__c = \'' + UserInfo.getUserId() + '\' OR RC_Sales_Expert__r.Manager_3__c = \'' +  UserInfo.getUserId() + '\' OR RC_Sales_Expert__r.Manager_4__c = \'' + UserInfo.getUserId() + '\') AND RC_Credit_Control_Field__c != \'\' AND RC_Sales_Expert__r.UserRoleId != \'\' GROUP BY RC_Credit_Control_Field__c';

        aggrList = Database.query(query);

        return aggrList;
    }

    @AuraEnabled
    public static List<RC_SD_Organization__c> getUserInfo(String uygulamaKanal, List<String> userIDList){
        List<RC_SD_Organization__c> foundedUsers = new List<RC_SD_Organization__c>();

        String query = 'SELECT Distribution_Channel__c, RC_Sales_Organization__c, RC_Account__c, RC_Sales_Expert__c FROM RC_SD_Organization__c WHERE RC_Sales_Expert__c != \'\'';

        if(userIDList != null && userIDList.size() > 0){
            query += ' AND RC_Sales_Expert__c IN (';
            
            for(String id : userIDList){
                query += '\'' + id + '\',';
            }

            query = query.removeEnd(',') + ')';
        }

        if(String.isNotBlank(uygulamaKanal) && uygulamaKanal != 'all'){
            List<RC_Financial_Process_Definition__c> uk = [SELECT Id, RC_Distribution_Channel__c, RC_Sales_Organization__c, RC_KKA__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Credit_Control_Sales_Organization' AND Id =: uygulamaKanal];

            if(uk.size() > 0){
                query += ' AND RC_Credit_Control_Field__c =\'' + uk.get(0).RC_KKA__c + '\'';
            }
        }
        // else if(String.isNotBlank(uygulamaKanal) && uygulamaKanal == 'all'){
        //     List<RC_Financial_Process_Definition__c> ukList = [SELECT Id, RC_Distribution_Channel__c, RC_Sales_Organization__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Credit_Control_Sales_Organization'];
            
        //     if(ukList.size() > 0){
        //         query += ' AND Distribution_Channel__c IN (';

        //         for(RC_Financial_Process_Definition__c uk : ukList){
        //             query += '\'' + uk.RC_Distribution_Channel__c.right(2) + '\',';           
        //         }

        //         query = query.removeEnd(',') + ') AND RC_Sales_Organization__c IN (';

        //         for(RC_Financial_Process_Definition__c uk : ukList){
        //             query += '\'' + uk.RC_Sales_Organization__c + '\',';           
        //         }

        //         query = query.removeEnd(',') + ')';
        //     }
        // }

        foundedUsers = Database.query(query);

        return foundedUsers;
    }

    @AuraEnabled
    public static ControlWrapper handleApproveRejectProcess(String operation, String message, String selectedDataList){
        ControlWrapper cw = new ControlWrapper();

        try {
            List<RC_Financial_Process_Definition__c> dataList = (List<RC_Financial_Process_Definition__c>)JSON.deserialize(selectedDataList, List<RC_Financial_Process_Definition__c>.class);

            String approveLevel = retrieveApproveLevel(null);
            List<RC_Bordro_Approval_History__c> newHistoryList = new List<RC_Bordro_Approval_History__c>();
            
            if(operation == 'red'){
                RC_Financial_Process_Definition__c reject = [SELECT Id, RC_SAP_ID__c, RC_Text__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Approval_Status' AND RC_SAP_ID__c = '0'];


                for(RC_Financial_Process_Definition__c data : dataList){
                    data.RC_Approval_Status__c = reject.RC_SAP_ID__c;
                    data.RC_Bordro_Status__c = 'Red';

                    RC_Bordro_Approval_History__c newHist = new RC_Bordro_Approval_History__c(
                        RC_Description__c = message, 
                        RC_Bordro_Entry_Id__c = data.Id, 
                        RC_Approval_Status__c = reject.Id
                    );

                    newHistoryList.add(newHist);
                }

                String dmMessage = '';
                List<Database.SaveResult> srListForData = Database.update(dataList, true);
                for(Database.SaveResult sr : srListForData){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()){
                            dmMessage += err.getMessage() + '. ';
                        }
                    }
                }

                List<Database.SaveResult> srListForHistory = Database.insert(newHistoryList, true);
                for(Database.SaveResult sr : srListForHistory){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()){
                            dmMessage += err.getMessage() + '. ';
                        }
                    }
                }

                if(String.isNotEmpty(dmMessage)){
                    cw.isSuccess = false;
                    cw.message = dmMessage;
                }
                else{
                    cw.isSuccess = true;
                    cw.message = 'Kayıtlar başarıyla reddedildi.';
                }
            }
            else{                
                String nextApproveLevel = String.valueOf(Integer.valueOf(approveLevel) - 1);

                RC_Financial_Process_Definition__c nextApprove = [SELECT Id, RC_SAP_ID__c, RC_Text__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Approval_Status' AND RC_SAP_ID__c =: nextApproveLevel];

                for(RC_Financial_Process_Definition__c data : dataList){

                    data.RC_Approval_Status__c = nextApproveLevel;
                    data.RC_Comments__c = message;

                    if(nextApproveLevel == '1'){
                        data.RC_Bordro_Status__c = 'Onay';
                    }

                    RC_Bordro_Approval_History__c newHist = new RC_Bordro_Approval_History__c(
                        RC_Description__c = message, 
                        RC_Bordro_Entry_Id__c = data.Id, 
                        RC_Approval_Status__c = nextApprove.Id
                    );

                    newHistoryList.add(newHist);
                }

                if(nextApproveLevel == '1'){  
                        String jsonBody = prepareDataForSAPSend(dataList);
                        
                        Map<String, String> header = new Map<String, String>();
                        header.put('Content-Type', 'application/json');
                        header.put('Authorization', 'Basic UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');

                        HttpResponse response = SAPServiceIntegrator.callSAPService('RESTAdapter/salesforce/fi_blg_sozlesme', header, 'POST', jsonBody);

                        ResponseWrapper rw = null;
                        if(response.getStatus() == 'OK'){
                            rw = (ResponseWrapper)JSON.deserialize(response.getBody(), ResponseWrapper.class);
                        }
                        else{
                            cw.isSuccess = false;
                            cw.message = 'SAP response dönüşünde dönen response ile ilgili hata meydana geldi.';
                        }
                        
                        if(rw != null){                                                  
                            String dmMessage = '';
                            List<Database.SaveResult> srListForData = Database.update(dataList, true);
                            for(Database.SaveResult sr : srListForData){
                                if(!sr.isSuccess()){
                                    for(Database.Error err : sr.getErrors()){
                                        dmMessage += err.getMessage() + '. ';
                                    }
                                }
                            }

                            List<Database.SaveResult> srListForHistory = Database.insert(newHistoryList, true);
                            for(Database.SaveResult sr : srListForHistory){
                                if(!sr.isSuccess()){
                                    for(Database.Error err : sr.getErrors()){
                                        dmMessage += err.getMessage() + '. ';
                                    }
                                }
                            }
                            
                            if(String.isNotEmpty(dmMessage)){
                                cw.isSuccess = false;
                                cw.message = dmMessage;                        
                            }else{
                                cw.isSuccess = true;
                                cw.message = rw.EV_RETURN;
                            }
                        }
                        else{
                            cw.isSuccess = false;
                            cw.message = 'Hata meydana geldi. Sistem yöneticinizle iletişime geçiniz.';
                        }       
                }
                else{
                    String dmMessage = '';
                    List<Database.SaveResult> srListForData = Database.update(dataList, true);
                    for(Database.SaveResult sr : srListForData){
                        if(!sr.isSuccess()){
                            for(Database.Error err : sr.getErrors()){
                                dmMessage += err.getMessage() + '. ';
                            }
                        }
                    }

                    List<Database.SaveResult> srListForHistory = Database.insert(newHistoryList, true);
                    for(Database.SaveResult sr : srListForHistory){
                        if(!sr.isSuccess()){
                            for(Database.Error err : sr.getErrors()){
                                dmMessage += err.getMessage() + '. ';
                            }
                        }
                    }

                    if(String.isNotEmpty(dmMessage)){
                        cw.isSuccess = false;
                        cw.message = dmMessage;
                    }
                    else{
                        cw.isSuccess = true;
                        cw.message = 'Kayıtlar başarıyla onaylandı.';
                    }
                }
                
                if(cw.isSuccess){
                    Boolean isGMY = nextApproveLevel == '1' ? true : false;
                    Boolean isApprove = operation == 'onay' ? true : false;
                    ControlWrapper mailCW = prepareMailForApprovedData(dataList, isApprove, isGMY);

                    if(String.isNotBlank(mailCW.message)){
                        cw.isSuccess = true;
                        cw.message = 'Onay süreci tamamlandı. Fakat, mail gönderiminde hata gerçekleşti. Hata : ' + mailCW.message;
                    }
                }
            }
        } catch (Exception e) {
            cw.isSuccess = false;
            cw.message = e.getMessage();
        }

        return cw;
    }

    //Helper Methods
    private static List<RC_Financial_Process_Definition__c> getBaglantiCariDonems(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_KKA__c, RC_Comments__c, RC_Payment_Term__c, RC_Start_Date__c, RC_End_Date__c, RC_Entry_End_Date__c, RC_Average_Due_Date__c, RC_Priority__c, RC_Document_Type__c, RC_Payment_Form__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Current_Period' AND RC_IsActive__c = true];
        
        return result;
    }

    private static List<RC_Financial_Process_Definition__c> getPaymentTypes(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();

        result = [SELECT Id, RC_Payment_Term__c, RC_Expiry__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Payment_Terms' ORDER BY RC_Expiry__c];
        
        return result;
    } 

    private static List<RC_Financial_Process_Definition__c> getCreditControls(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
                            
        result = [SELECT Id, RC_Sales_Organization__c, RC_Distribution_Channel__c, RC_KKA__c, RC_KKA_Defination__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Credit_Control_Sales_Organization' AND RC_IsActive__c = true ORDER BY RC_Distribution_Channel__c];
        
        return result;
    }

    private static List<RC_Financial_Process_Definition__c> getPaymentForms(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_Payment_Form__c, RC_Fiscal_Year__c,	RC_Comments__c,	RC_Text__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Payment_Forms'];
        
        return result;
    }

    private static String retrieveApproveLevel(String userID){
        String al = '';

        String selectedId = String.isNotBlank(userID) ? userID : UserInfo.getUserId();

        User currentUser = [SELECT UserRole.DeveloperName FROM User WHERE Id =: selectedId];

        switch on currentUser.UserRole.DeveloperName {
            when 'Bayi_Satis_Muduru_Satis_Sorumlusu'{
                al = '4';
            }
            when 'Bayi_Bolge_Muduru'{
                al = '3';
            }
            when 'Bayi_Genel_Mudur_Yardimcisi'{
                al = '2';
            }
            when else {
                al = '5';
            }
        }

        return al;
    }

    private static List<RC_Financial_Process_Definition__c> getBordroTypes(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_Portfolio_Code__c, RC_Document_Type__c, RC_Bordro_Types__c, RC_Bordro_Type_Definations__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Bordro_Types' AND RC_IsActive__c = true];
        
        return result;
    }

    /*
        *   Onaylanan kayıtların sap a gönderimi için json formatında verinin hazırlandığı metod
    */
    private static String prepareDataForSAPSend(List<RC_Financial_Process_Definition__c> selectedDataList){
        String reqBody = '';
        
        RequestWrapper req = new RequestWrapper();
        List<Item> odemePlanItemList = new List<Item>();
        List<Item> sozlesmeItemList = new List<Item>();
        Map<String, List<RC_Financial_Process_Definition__c>> foundedDataMap = new Map<String, List<RC_Financial_Process_Definition__c>>();

        if(selectedDataList != null && selectedDataList.size() > 0){
            // Data Search Prepare
            List<String> selectedTermList = new List<String>();
            List<String> selectedAccountList = new List<String>();
            List<String> selectedBordroTypeList = new List<String>();
            List<String> selectedPaymentTermList = new List<String>();
            List<String> selectedDataIdList = new List<String>();
            Set<Decimal> isExtraSet = new Set<Decimal>();
            Set<String> kkaSet = new Set<String>();
 
            for(RC_Financial_Process_Definition__c data : selectedDataList){
                selectedTermList.add(data.RC_Term_ID__c);
                selectedAccountList.add(data.RC_Account__c);
                selectedBordroTypeList.add(data.RC_Bordro_Types__c);
                selectedPaymentTermList.add(data.RC_Payment_Term__c);
                selectedDataIdList.add(data.Id);
                kkaSet.add(data.RC_KKA__c);
                isExtraSet.add(data.RC_IsExtra__c);

                String code = data.RC_Account__c + '-' + data.RC_Term_ID__c + '-' + data.RC_KKA__c + '-' + Integer.valueOf(data.RC_IsExtra__c);
				
                List<RC_Financial_Process_Definition__c> relatedList = new List<RC_Financial_Process_Definition__c>();

                if(foundedDataMap.containsKey(code))
                    relatedList = foundedDataMap.get(code);

                relatedList.add(data);

                foundedDataMap.put(code, relatedList);
            }

            selectedDataList = [SELECT Id, RC_Start_Date__c, RC_Term_ID__r.RC_Payment_Form__c, RC_TERM_ID__r.RC_Start_Date__c, RC_TERM_ID__r.RC_End_Date__c, RC_Term_ID__r.RC_Comments__c, RC_Bordro_Status__c, RC_IsExtra__c, RC_Approval_Status__c, RC_Account__c, RC_Account__r.RC_SAP_Id__c, RC_Comments__c, RC_Amount__c, RC_Average_Due_Date__c, RC_Bordro_Types__c, RC_Payment_Term__c, RC_Term_ID__c, RC_KKA__c, RC_Bordro_No__c, CreatedById, CreatedBy.ManagerId, CreatedBy.RC_ManagerId_2__c, CreatedBy.Manager_3__c, CreatedBy.Manager_4__c  FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Entry' AND Id =: selectedDataIdList];

            Map<String, String> portfolioMap = new Map<String, String>();
            for(RC_Financial_Process_Definition__c p : [SELECT Id, RC_Portfolio_Code__c, RC_Bordro_Types__c FROM RC_Financial_Process_Definition__c WHERE RC_Bordro_Types__c =: selectedBordroTypeList and RecordType.DeveloperName = 'Bordro_Types']){
                portfolioMap.put(p.RC_Bordro_Types__c, p.RC_Portfolio_Code__c);
            }

            Map<String, String> paymentTermMap = new Map<String, String>();
            for(RC_Financial_Process_Definition__c pt : [SELECT Id, RC_Payment_Term__c  FROM RC_Financial_Process_Definition__c  WHERE Id =: selectedPaymentTermList]){
                paymentTermMap.put(pt.Id, pt.RC_Payment_Term__c);
            }
            
            // Searched Data Map
            for(RC_Financial_Process_Definition__c fpd : [SELECT Id, RC_Amount__c, RC_Term_ID__C, RC_Account__c, RC_KKA__c, RC_IsExtra__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Entry' AND RC_Account__c =: selectedAccountList AND RC_Approval_Status__c = '1' AND RC_IsExtra__c =: isExtraSet AND RC_Term_ID__c =: selectedTermList AND RC_KKA__c =: kkaSet]){
                String code = fpd.RC_Account__c + '-' + fpd.RC_Term_ID__c + '-' + fpd.RC_KKA__c + '-' + Integer.valueOf(fpd.RC_IsExtra__c);
                
                List<RC_Financial_Process_Definition__c> relatedList = new List<RC_Financial_Process_Definition__c>();

                if(foundedDataMap.containsKey(code))
                    relatedList = foundedDataMap.get(code);

                relatedList.add(fpd);

                foundedDataMap.put(code, relatedList);
            }
            
            // Prepare Requests
            for(RC_Financial_Process_Definition__c data : selectedDataList){
                String code = data.RC_Account__c + '-' + data.RC_Term_ID__c + '-' + data.RC_KKA__c + '-' + Integer.valueOf(data.RC_IsExtra__c);
                
                Item itemBody = new Item();
                itemBody.MANDT= '021';
                itemBody.GJAHR = data.RC_TERM_ID__r.RC_Payment_Form__c.substring(0,4); 
                itemBody.KUNNR = data.RC_Account__r.RC_SAP_ID__c;
                itemBody.ZLSCH = data.RC_TERM_ID__r.RC_Payment_Form__c.substring(4,5); 
                itemBody.KKBER = data.RC_KKA__c; 							
                itemBody.ROW_NO = String.valueOf(data.RC_IsExtra__c);
                itemBody.BORDROTIPI = data.RC_Bordro_Types__c;
                itemBody.PORTFOY = portfolioMap.get(data.RC_Bordro_Types__c);
                itemBody.SMCTR = String.valueOf(Double.valueOf(data.RC_Amount__c));
                itemBody.CVDTE = formatDate(String.valueOf(data.RC_Average_Due_Date__c));

                odemePlanItemList.add(itemBody);

                Double totalCurrency = 0.00;
                List<RC_Financial_Process_Definition__c> relatedData = foundedDataMap.get(code);
                if(relatedData != null && relatedData.size() > 0){
                    for(RC_Financial_Process_Definition__c rd : relatedData){
                        totalCurrency += Double.ValueOf(rd.RC_Amount__c);
                    }
                }
                
                Item sozlesmeBody = new Item();
                sozlesmeBody.MANDT= '021';
                sozlesmeBody.GJAHR = data.RC_TERM_ID__r.RC_Payment_Form__c.substring(0,4); 
                sozlesmeBody.KUNNR = data.RC_Account__r.RC_SAP_ID__c;
                sozlesmeBody.ZLSCH = data.RC_TERM_ID__r.RC_Payment_Form__c.substring(4,5); 	
                sozlesmeBody.KKBER = data.RC_KKA__c; 								
                sozlesmeBody.ROW_NO = String.valueOf(data.RC_IsExtra__c);
                sozlesmeBody.SMCTR	= String.valueOf(totalCurrency);
                sozlesmeBody.CVDTE = formatDate(String.valueOf(data.RC_Average_Due_Date__c));
                sozlesmeBody.START_DATE = formatDate(String.valueOf(data.RC_TERM_ID__r.RC_Start_Date__c));
                sozlesmeBody.END_DATE = formatDate(String.valueOf(data.RC_TERM_ID__r.RC_End_Date__c));
                sozlesmeBody.TIMESTAMP = '0';
                sozlesmeBody.USERNAME = '';
                sozlesmeBody.VARIANT = '';
                sozlesmeBody.ZTERM =  paymentTermMap.get(data.RC_Payment_Term__c);
                sozlesmeBody.GJAHR_ZLSCH = data.RC_TERM_ID__r.RC_Payment_Form__c;
                sozlesmeBody.LAST_DATE = '';
                sozlesmeBody.LAST_TIME = '';
                
                sozlesmeItemList.add(sozlesmeBody);
            }
            
            IT_SOZLESME sozlesme = new IT_SOZLESME();
            sozlesme.item = sozlesmeItemList;
            
            IT_ODEME_PLAN odemePlan = new IT_ODEME_PLAN();
            odemePlan.item = odemePlanItemList;
            
            req.IT_ODEME_PLAN = odemePlan;
            req.IT_SOZLESME = sozlesme;
            
            if(odemePlanItemList.size() > 0 && sozlesmeItemList.size() > 0){
                reqBody = JSON.serialize(req, true);
            }
        }

        return reqBody;
    }

    /*
        *   Onay sonrası mail atımı için oluşturulmuştur.
    */
    public static ControlWrapper prepareMailForApprovedData(List<RC_Financial_Process_Definition__c> selectedDataList, Boolean isApprove, Boolean isGMY){
        ControlWrapper cw = new ControlWrapper();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        
        try {
            User currentUser = [SELECT Id, Manager.Email, Manager.Name FROM User WHERE Id =: UserInfo.getUserId()];

            // Html Body Prepare
            Map<String, List<String>> emailRowMap = new Map<String, List<String>>();
            List<String> htmlApproveList = new List<String>();
            for(RC_Financial_Process_Definition__c fpd : selectedDataList){
                String htmlBody = '<tr>';
                htmlBody += '<td>' + fpd.CreatedBy.Name + '</td>';
                htmlBody += '<td style=\'text-align: center; white-space: nowrap;\'><span>' + fpd.RC_Account__r.RC_SAP_ID__c + '</span></td>';
                htmlBody += '<td style=\'text-align: center; white-space: nowrap;\'><span>' + fpd.RC_Account__r.Name + '</span></td>';
                htmlBody += '<td style=\'text-align: center; white-space: nowrap;\'><span>' + fpd.RC_KKA_Defination__c + '</span></td>';
                htmlBody += '<td style=\'text-align: center; white-space: nowrap;\'><span>' + fpd.RC_Comments__c + '</span></td>';
                htmlBody += '<td style=\'text-align: center; white-space: nowrap;\'><span>' + (fpd.RC_isDTS__c ? 'DTS' : 'OÇT') + '</span></td>';
                htmlBody += '<td style=\'text-align: center; white-space: nowrap;\'><span>' + fpd.RC_Average_Due_Date__c + '</span></td>';
                htmlBody += '<td style=\'text-align: center; white-space: nowrap;\'><span>' + fpd.RC_Amount__c + '</span></td>';
                htmlBody += '</tr>';

                if(isApprove)
                    htmlApproveList.add(htmlBody);
                else{
                    List<String> htmlList = null;
                    if(emailRowMap.containsKey(fpd.CreatedById))
                        htmlList = emailRowMap.get(fpd.CreatedById);                
                    else
                        htmlList = new List<String>();

                    htmlList.add(htmlBody);                
                    emailRowMap.put(fpd.CreatedById, htmlList);
                }
            }

            // Mail Sending Process
            if(isApprove){
                Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
                String html = '';

                html += '<table>';
                html += '<tr>';
                html += '<td colspan=\'7\' style=\'padding: 2px;\'> Merhaba Sayın ' + currentUser.Manager.Name + '</td>'; 
                html += '</tr>';
                html += '<tr><td colspan=\'7\' style=\'padding: 2px;\'> Altta detayları bulunan bordro girişleri onayınıza sunulmuştur.</td></tr>';
                html += '<tr><td colspan=\'7\' style=\'padding: 2px;\'>';
                html += '<table><thead><tr><th>Bordro Oluşturan</th><th>Bayi Kodu</th><th>Bayi Adı</th><th>Kredi Kontrol</th><th>Açıklama</th><th>DTS</th><th>Vade</th><th>Tutar</th></tr></thead><tbody>';

                for(String h : htmlApproveList){
                    html += h;
                }

                html += '</td></tr></table>';
   
                String[] toList = new List<String>();
                toList.add(currentUser.Manager.Email);

                sem.setHtmlBody(html);
                sem.setSubject('Bağlantı Onay Hk.');  
                sem.setToAddresses(toList);   
                sem.setCcAddresses(new String[]{'serkang@coredet.com'});

                if(!isGMY){
                    mailList.add(sem);
                }
            }
            else{
                Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name, Email FROM User WHERE Id =: emailRowMap.keySet()]);

                for(String cID : emailRowMap.keySet()){
                    Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
                    
                    User relatedUser = userMap.get(cID);

                    List<String> htmlRejectList = emailRowMap.get(cID);

                    String html = '';

                    html += '<table>';
                    html += '<tr>';
                    html += '<td colspan=\'7\' style=\'padding: 2px;\'> Merhaba Sayın ' + relatedUser.Name + '</td>'; 
                    html += '</tr>';
                    html += '<tr><td colspan=\'7\' style=\'padding: 2px;\'> Altta detayları bulunan bordro girişleri reddedilmiştir.</td></tr>';
                    html += '<tr><td colspan=\'7\' style=\'padding: 2px;\'>';
                    html += '<table><thead><tr><th>Bordro Oluşturan</th><th>Bayi Kodu</th><th>Bayi Adı</th><th>Kredi Kontrol</th><th>Açıklama</th><th>DTS</th><th>Vade</th><th>Tutar</th></tr></thead><tbody>';

                    for(String h : htmlRejectList){
                        html += h;
                    }
        
                    html += '</td></tr></table>';                    
                        
                    String[] toList = new List<String>();
                    toList.add(currentUser.Manager.Email);
        
                    sem.setHtmlBody(html);
                    sem.setSubject('Bağlantı Onay Hk.');   
                    sem.setToAddresses(toList);       
                    sem.setCcAddresses(new String[]{'serkang@coredet.com'});
        
                    mailList.add(sem);
                }
            }

            if(mailList.size() > 0){
                List<Messaging.SendEmailResult> result = Messaging.sendEmail(mailList, true);
                
                for(Messaging.SendEmailResult ser : result){
                    if(!ser.isSuccess()){
                        cw.isSuccess = false;

                        for(Messaging.SendEmailError see : ser.getErrors()){
                            cw.message += see.getMessage();
                        }
                    }
                } 
            }
        } catch (Exception ex) {
            cw.isSuccess = false;
            cw.message = ex.getMessage();
        }

        return cw;
    }

    private static string formatDate(String dt){
		string month = dt.substring(5, 7);
        string day = dt.substring(8, 10);
        string year = dt.substring(0, 4);
        
        return year+month+day;        
    }

    //Wrappers
    public class InitializeWrapper{
        @AuraEnabled
        public List<RC_Financial_Process_Definition__c> uygulamaKanal {get; set;}
        @AuraEnabled
        public List<RC_Financial_Process_Definition__c> baglantiDonem {get; set;}
        @AuraEnabled
        public List<RC_Financial_Process_Definition__c> odemeKosul {get; set;}
        @AuraEnabled
        public List<RC_Financial_Process_Definition__c> paymentForm {get; set;}
        @AuraEnabled
        public List<RC_Financial_Process_Definition__c> bordroTip {get; set;}
        @AuraEnabled
        public UserMapWrapper kullanicilar {get; set;}
        @AuraEnabled
        public List<User> anlikKullanici {get; set;}
        @AuraEnabled
        public List<AggregateResult> aggrList {get; set;}
    }

    public class ControlWrapper{
        @AuraEnabled
        public Boolean isSuccess {get; set;}
        @AuraEnabled
        public String message {get; set;}

        public ControlWrapper(){
            this.message = '';
        }
    }

    public class IT_ODEME_PLAN{
        @AuraEnabled
        public List<Item> item{get;set;}
    }
    
    public class IT_SOZLESME{
        @AuraEnabled
        public List<Item> item{get;set;}
    }

    public class Item{
        @AuraEnabled
        public string MANDT { get; set; }
        @AuraEnabled
        public string GJAHR { get; set; }
        @AuraEnabled
        public string KUNNR { get; set; }
        @AuraEnabled
        public string ZLSCH { get; set; }
        @AuraEnabled
        public string KKBER { get; set; }
        @AuraEnabled
        public string ROW_NO { get; set; }
        @AuraEnabled
        public string BORDROTIPI { get; set; }
        @AuraEnabled
        public string PORTFOY { get; set; }
        @AuraEnabled
        public string SMCTR { get; set; }
        @AuraEnabled
        public string CVDTE { get; set; }
        @AuraEnabled        
        public string START_DATE { get; set; }
        @AuraEnabled
        public string END_DATE { get; set; }
        @AuraEnabled
        public string TIMESTAMP { get; set; }
        @AuraEnabled
        public string USERNAME { get; set; }
        @AuraEnabled
        public string VARIANT { get; set; }
        @AuraEnabled
        public string ZTERM { get; set; }
        @AuraEnabled
        public string GJAHR_ZLSCH { get; set; }
        @AuraEnabled
        public string LAST_DATE { get; set; }
        @AuraEnabled
        public string LAST_TIME { get; set; }
    }
    
    public class RequestWrapper{
        @AuraEnabled
        public IT_ODEME_PLAN IT_ODEME_PLAN {get;set;}
        @AuraEnabled
        public IT_SOZLESME IT_SOZLESME {get;set;}
    }

    public class ResponseWrapper{
        @AuraEnabled
        public String EV_FLAG {get; set;}
        @AuraEnabled
        public String EV_RETURN {get; set;}
    }

    public class UserMapWrapper{
        @AuraEnabled
        public List<User> kullanicilar {get; set;}
        @AuraEnabled
        public List<String> userKKAMap {get; set;}
    }
}