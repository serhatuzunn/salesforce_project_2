public class RC_ConnectionApprovalFlow {
    
    public class SelectOptionWrapper
    {
        @AuraEnabled
        public string Label{get;set;}
        @AuraEnabled
        public string Value{get;set;}
    }
    
    public class InitWrapper
    {
        @AuraEnabled
        public List<SelectOptionWrapper> ConnectionPeriods {get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> BordroTypes      {get;set;}
    }
    
    public class OrtalamaVadeModel
    {
        @AuraEnabled
        public string BAKIYE { get; set; }
        @AuraEnabled
        public string ORTVADE { get; set; }
    }
    
    public class ApprovalModal
    {
        @AuraEnabled
        public string selectedStatus {get;set;}
        @AuraEnabled
        public Approver approverUser{get;set;}
        @AuraEnabled
        public Map<string,Approver> statusUserMap {get;set;}
    }
    
    public class Approver
    {
        @AuraEnabled
        public string UserId{get;set;}
        @AuraEnabled
        public string UserName{get;set;}
    }
    
    
    @AuraEnabled
    public static InitWrapper Initialize()
    {
        InitWrapper initData = new InitWrapper();
        
        List<RC_Financial_Process_Definition__c> selectDatas = [SELECT Id, Name, RecordTypeId, RC_Comments__c, RC_IsActive__c, RC_Payment_Term__c, RC_Priority__c, RC_KKA__c, RC_Payment_Form__c,
                                                                RC_Bordro_Type_Definations__c, RC_Bordro_Types__c,RecordType.DeveloperName
                                                                FROM RC_Financial_Process_Definition__c Where (RecordType.DeveloperName='Connection_Current_Period' OR RecordType.DeveloperName='Bordro_Types')
                                                                AND RC_IsActive__c=:true ORDER BY RC_Priority__c];
        
        List<SelectOptionWrapper> connectionPeriodList = new List<SelectOptionWrapper>();
        List<SelectOptionWrapper> bordroTypeList       = new List<SelectOptionWrapper>();
        system.debug('selectDatas:' + selectDatas);
        for(RC_Financial_Process_Definition__c item : selectDatas)
        {
            SelectOptionWrapper selectItem = new SelectOptionWrapper();
            
            if(item.RecordType.DeveloperName == 'Connection_Current_Period')
            {
                selectItem.label = item.RC_Payment_Form__c + ' - ' + item.RC_Comments__c;
                selectItem.value = item.RC_Payment_Form__c;
                connectionPeriodList.add(selectItem);
            }
            
            else if(item.RecordType.DeveloperName == 'Bordro_Types')
            {
                selectItem.label = item.RC_Bordro_Type_Definations__c;
                selectItem.value = item.RC_Bordro_Types__c;
                bordroTypeList.add(selectItem);
            }
        }
        system.debug('connectionPeriods:' + connectionPeriodList);
        system.debug('BordroTypes:' + bordroTypeList);
        initData.ConnectionPeriods = connectionPeriodList;
        initData.BordroTypes	   = bordroTypeList;
        
        return initData;
    }
    
    @AuraEnabled
    public static List<RC_Financial_Process_Definition__c> GetConnections(string selectedAccount, string selectedConnectionPeriod,string selectedBordroType, string selectedPayroll)
    {
        String searchedQuery = '';
        string recordType = 'Connection_Bordro_Entry';
        searchedQuery = 'SELECT Id, RC_Account__r.RC_SAP_Id__c,RC_Account__r.Name, RC_Account__r.Id, RC_Bordro_No__r.RC_Bordro_No__c, RC_Amount__c, RC_Average_Due_Date__c, RC_Bordro_Status__c,RC_Distribution_Channel__c,RC_Approval_Status__c,RC_Text__c,RC_Payment_Form__c From RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName=\'' + recordType + '\'';
        
        if(String.isNotBlank(selectedAccount) || String.isNotBlank(selectedConnectionPeriod) || String.isNotBlank(selectedBordroType) || String.isNotBlank(selectedPayroll) )
        {
            if(string.isNotBlank(selectedAccount))
            {
                searchedQuery += ' AND RC_Account__c =\''+selectedAccount+'\'';
            }
            if(string.isNotBlank(selectedConnectionPeriod))
            {
                searchedQuery += ' AND RC_TERM_ID__r.RC_Payment_Form__c =\''+selectedConnectionPeriod+'\'';
            }
            if(string.isNotBlank(selectedBordroType))
            {
                searchedQuery += ' AND RC_Bordro_Types__c =\''+selectedBordroType+'\'';
            }
            if(string.isNotBlank(selectedPayroll))
            {
                List<RC_Bordro__c> payroll = [Select Id From RC_Bordro__c where RC_Bordro_No__c =: selectedPayroll];
                if(payroll!=null && payroll.size()>0)
                    searchedQuery += ' AND RC_Bordro_No__c =\''+payroll[0].Id +'\'';
                else
                    return new List<RC_Financial_Process_Definition__c>();
            }
        }
        
        if(String.isNotBlank(searchedQuery)){
            List<RC_Financial_Process_Definition__c> connectionList = Database.query(searchedQuery);
            if(connectionList!=null && connectionList.size()>0)
            {
                //Alan lookUp olduğunda gerek kalmayacak.
                List<RC_Financial_Process_Definition__c> approvalStatusList = GetApprovalStatus();
                Map<String,String> approvalStatusMap = new Map<string,string>();
                for(RC_Financial_Process_Definition__c aStatus : approvalStatusList)
                {
                    approvalStatusMap.put(aStatus.RC_SAP_ID__c,aStatus.RC_Text__c);
                }
                for(RC_Financial_Process_Definition__c conn : connectionList)
                {
                    conn.RC_Text__c = approvalStatusMap.get(conn.RC_Approval_Status__c);
                }
                
                return connectionList;
            }
        }
        return new List<RC_Financial_Process_Definition__c>();
    }
    
    @AuraEnabled
    public static List<RC_Financial_Process_Definition__c> GetApprovalStatus()
    {
        List<RC_Financial_Process_Definition__c> approvalStatusList = [SELECT RC_SAP_ID__c, RC_Text__c From RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName='Connection_Approval_Status'];
        system.debug('statuslist:' + approvalStatusList);
        return approvalStatusList;
    }
    
    @AuraEnabled
    public static ApprovalModal GetApprovalData(string connId, string accountId)
    {
        system.debug('accountId:' + accountId + ' - connId: ' + connId);
        RC_Financial_Process_Definition__c connection = [SELECT Id, RC_Account__r.RC_SAP_Id__c, RC_Bordro_No__r.RC_Bordro_No__c, RC_Amount__c, RC_Due_Date__c,
                                                         RC_Bordro_Status__c,RC_Distribution_Channel__c,RC_KKA__c,RC_Approval_Status__c
                                                         From RC_Financial_Process_Definition__c WHERE Id=:connId];
        system.debug('connection:' + connection);
        system.debug('connectionDistChannel:' + connection.RC_Distribution_Channel__c);
        List<RC_SD_Organization__c> sdOrgList = [SELECT RC_Account__c, Id,RC_Sales_Expert__r.ManagerId,
                                                 RC_Sales_Expert__r.RC_ManagerId_2__c,RC_Sales_Expert__r.Manager_3__c,RC_Sales_Expert__r.Manager_4__c
                                                 FROM RC_SD_Organization__c WHERE RC_Account__c=: accountId AND RC_Credit_Control_Field__c=:connection.RC_KKA__c];
        
        List<String> userIdList = new List<String>();
        
        if(sdOrgList!=null && sdOrgList.size()>0)
        {
            userIdList.add(sdOrgList[0].RC_Sales_Expert__r.Id);
            userIdList.add(sdOrgList[0].RC_Sales_Expert__r.ManagerId);
            userIdList.add(sdOrgList[0].RC_Sales_Expert__r.RC_ManagerId_2__c);
            userIdList.add(sdOrgList[0].RC_Sales_Expert__r.Manager_3__c);
            userIdList.add(sdOrgList[0].RC_Sales_Expert__r.Manager_4__c);
        }
        
        
        Map<string,Approver> userAndRoleMap = new Map<string,Approver>();
        List<User> userList = [Select Id,UserRole.DeveloperName,Name From User WHERE Id=: userIdList];
        for(User us : userList)
        {
            Approver usr = new Approver();
            usr.UserId = us.Id;
            usr.UserName = us.Name;
            
            system.debug('userRoleDeveloperName:' + us.UserRole.DeveloperName);
            
            if(us.UserRole.DeveloperName == 'Bayi_Genel_Mudur_Yardimcisi')
            {    
                userAndRoleMap.put('2', usr);
            }
            else if(us.UserRole.DeveloperName =='Bayi_Bolge_Muduru')
            {
                userAndRoleMap.put('3', usr);
            }
            else if(us.UserRole.DeveloperName =='Bayi_Satis_Muduru_Satis_Sorumlusu')
            {
                userAndRoleMap.put('4', usr); 
            }
            else if (us.UserRole.DeveloperName =='Bayi_Satis_Uzmani')
            {
                userAndRoleMap.put('0', usr); 
            }
        }
        
        system.debug('approvalStatus: ' + connection.RC_Approval_Status__c);
        system.debug('userRoleAndMap:'  + userAndRoleMap);
        ApprovalModal appM = new ApprovalModal();
        appM.selectedStatus = connection.RC_Approval_Status__c;
        appM.statusUserMap = userAndRoleMap;
        appM.approverUser  = userAndRoleMap.get(connection.RC_Approval_Status__c);
        
        return appM;
    }
    
    @AuraEnabled
    public static List<RC_Cheques__c> GetChequeData(string bordroNo)
    {
        List<RC_Cheques__c> chequeList = [SELECT RC_Bordro__c, Name, Id, RC_Cheque_Number__c, RC_Due_Date__c,RC_Amount__c FROM RC_Cheques__c where RC_Bordro__c=: bordroNo AND RC_Type__c='Cheque'];
        if(chequeList.size()>0)
        {
            return chequeList;
        }
        return new List<RC_Cheques__c>();
    }
    
    @AuraEnabled
    public static OrtalamaVadeModel GetPayrollTotalAmountAndAvg(string payrollId)
    {
        OrtalamaVadeModel model = new OrtalamaVadeModel();
        RC_Bordro__c payrollInfo = [SELECT Id, RC_Average_Due_Date__c, RC_Amount__c  FROM RC_Bordro__c WHERE Id=: payrollId];
        model.ORTVADE = string.valueOf(payrollInfo.RC_Average_Due_Date__c);
        model.BAKIYE  = string.valueOf(payrollInfo.RC_Amount__c);
        return model;
    }
    
    @AuraEnabled
    public static OrtalamaVadeModel CalculateAvgMaturity(List<string> chequeNumbers)
    {
        OrtalamaVadeModel ortVadeModel = new OrtalamaVadeModel();
        
        List<RC_Cheques__c> chequeList = [SELECT Id,RC_Amount__c,RC_Due_Date__c,RC_Cheque_Number__c FROM RC_Cheques__c WHERE RC_Cheque_Number__c IN: chequeNumbers];
        if(chequeList.size()>0)
        {
            RC_FI_OrtalamaVadeIntegrator.requestModel reqModel = new RC_FI_OrtalamaVadeIntegrator.requestModel();
            reqModel.IT_LINEITEMS = new RC_FI_OrtalamaVadeIntegrator.IT_LINEITEMS();
            reqModel.IT_LINEITEMS.item = new List<RC_FI_OrtalamaVadeIntegrator.item>();
            
            List<RC_FI_OrtalamaVadeIntegrator.item> chequeItemList = new List<RC_FI_OrtalamaVadeIntegrator.item>();
            
            for(RC_Cheques__c cheque : chequeList){
                
                RC_FI_OrtalamaVadeIntegrator.item chequeItem = new RC_FI_OrtalamaVadeIntegrator.item();
                chequeItem.LC_AMOUNT  = string.valueOf(cheque.RC_Amount__c);
                chequeItem.DB_CR_IND  = 'S';
                chequeItem.BLINE_DATE = string.valueOf(cheque.RC_Due_Date__c);
                chequeItem.PSTNG_DATE = string.valueOf(cheque.RC_Due_Date__c);
                reqModel.IT_LINEITEMS.item.add(chequeItem);
            }
            
            RC_FI_OrtalamaVadeIntegrator.responseModel responseIntegrator = RC_FI_OrtalamaVadeIntegrator.FI_OrtalamaVadeBul(reqModel);
            if(responseIntegrator!=null){
                
                ortVadeModel.BAKIYE = responseIntegrator.EV_BAKIYE;
                ortVadeModel.ORTVADE = responseIntegrator.EV_ORTVADE; 
            }
        }
        
        return ortVadeModel;
    }
    
    @AuraEnabled
    public static boolean DeletePayroll(string bordroId, string connId, string description)
    {
        boolean result = false;
        
        RC_Financial_Process_Definition__c status =  [SELECT Id, Name, RC_SAP_Id__c, RC_Text__c From RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName='Connection_Approval_Status' AND RC_SAP_ID__c ='0'];
        
        if(status!=null)
        {
            if(SendConnectionToFI(connId,'DeleteConnection',null))
            {
                RC_Bordro_Approval_History__c trackHistory = new RC_Bordro_Approval_History__c();
                trackHistory.RC_Description__c     = description;
                trackHistory.RC_Approval_Status__c = status.Id;
                trackHistory.RC_Bordro_Entry_Id__c = connId;
                Database.SaveResult insertResult = Database.insert(trackHistory);
                
                if(insertResult.isSuccess())
                {
                    RC_Financial_Process_Definition__c conn = [SELECT Id, RC_Bordro_Status__c From RC_Financial_Process_Definition__c WHERE Id=:connId];
                    conn.RC_Approval_Status__c = status.RC_SAP_Id__c;
                    conn.RC_Bordro_Status__c   = 'Plan';
                    Database.SaveResult updateResult = Database.update(conn);
                    
                    if(updateResult.isSuccess())
                    {
                        RC_Bordro__c payroll =  [SELECT Id FROM RC_Bordro__c where Id=:bordroId];
                        Database.DeleteResult dr = Database.delete(payroll);
                        if(dr.isSuccess())
                            result = true;
                    } 
                }
            }		
            
        }
        
        return result;        
    }
    
    @AuraEnabled
    public static boolean UpdateConnection(string selectedPayroll,List<string> chequesToBeDeleted, string totalAmount , string avgMaturity, string selectedConn, string description)
    {
        system.debug('updateconn:');
        boolean result = false;
        
        if(chequesToBeDeleted.size()>0)
        { 
            system.debug('checks:' + chequesToBeDeleted);
            system.debug('bordroId:' + selectedPayroll);
            
            if(SendConnectionToFI(selectedConn ,'UpdateCheques',chequesToBeDeleted))
            {
                
                RC_Financial_Process_Definition__c connection = [Select Id From RC_Financial_Process_Definition__c Where Id=:selectedConn];
                List<RC_Cheques__c> chequeList = [SELECT Id,RC_Amount__c,RC_Due_Date__c,RC_Cheque_Number__c FROM RC_Cheques__c WHERE RC_Cheque_Number__c IN: chequesToBeDeleted];
                List<Database.DeleteResult> drList = Database.delete(chequeList,true);
                if(drList[0].isSuccess())
                {
                    RC_Bordro__c payroll  = [Select Id From RC_Bordro__c WHERE ID =: selectedPayroll];
                    
                    payroll.RC_Average_Due_Date__c = date.valueOf(avgMaturity);
                    payroll.RC_Amount__c           = decimal.valueOf(totalAmount);
                    Database.SaveResult ur = Database.update(payroll);
                    
                    if(ur.isSuccess())
                    {
                        connection.RC_Average_Due_Date__c = date.valueOf(avgMaturity);
                        connection.RC_Amount__c           = decimal.valueOf(totalAmount);
                        Database.SaveResult urC = Database.update(connection);
                        if(urC.isSuccess())
                        {
                            RC_Financial_Process_Definition__c status =  [SELECT Id From RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName='Connection_Approval_Status' AND RC_SAP_ID__c ='0'];
                            RC_Bordro_Approval_History__c trackHistory = new RC_Bordro_Approval_History__c();
                            trackHistory.RC_Description__c     = description;
                            trackHistory.RC_Approval_Status__c = status.Id;
                            trackHistory.RC_Bordro_Entry_Id__c = selectedConn;
                            Database.SaveResult insertResult = Database.insert(trackHistory);
                            
                            if(insertResult.isSuccess())
                            {
                                return true;
                            }
                            
                        }
                        
                    }
                }
            }	
            
        }
        
        return result;
    }
    
    @AuraEnabled
    public static Approver ChangeApprovalStatus(string selectedSt,Map<string,Approver> approvalUserMap)
    {
        
        Approver approverUser = approvalUserMap.get(selectedSt);
        return approverUser;
    }
    
    @AuraEnabled
    public static boolean SaveApprovalChange(string description,string newApprovalStatus,string connId,string approver)  
    {
        boolean result = false;
        
        system.debug('desc: ' + description + ' ,newApprovalStatus:' + newApprovalStatus + ' ,connId: ' + connId + ' ,approver:' + approver);
        RC_Financial_Process_Definition__c connection = [Select Id,RC_Approval_Status__c From RC_Financial_Process_Definition__c WHERE Id=: connId];
        RC_Financial_Process_Definition__c status =  [SELECT Id,RC_Text__c,RC_SAP_ID__c From RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName='Connection_Approval_Status' AND RC_SAP_ID__c =: newApprovalStatus];
        
        if(SendConnectionToFI(connection.Id,'ApproverChange',null))
        {
            
            connection.RC_Approval_Status__c = newApprovalStatus;
            connection.RC_Approver__c = approver;
            connection.RC_Bordro_Status__c = 'Plan';
            Database.SaveResult updateResult = Database.update(connection);
            
            if(updateResult.isSuccess())
            {
                system.debug('success conn rec');
                RC_Bordro_Approval_History__c trackHistory = new RC_Bordro_Approval_History__c();
                
                trackHistory.RC_Description__c     = description;
                trackHistory.RC_Approval_Status__c = status.Id;
                trackHistory.RC_Bordro_Entry_Id__c = connId;
                Database.SaveResult insertResult = Database.insert(trackHistory);
                
                if(insertResult.isSuccess())
                {
                    system.debug('success history rec:');
                    result = true;
                }
                else
                {
                    system.debug('insertError : ' + insertResult.getErrors());
                }
            }
            else
            {
                system.debug('updateError : ' + updateResult.getErrors());
            }
        }
        
        
        return result;
    }
    
    @AuraEnabled
    public static boolean SendConnectionToFI(string connectionId,string type,List<string> chequesToBeDeleted)
    {
        //Sadece bağlantı plan girişi onaylandı statüsünden BM, SM veya GMY onayına geçerse çağrılacak.
        double chequesAmount = 0.00;
        boolean result = false;
        
        RC_FI_ConnectionAndContractIntegrator.RequestWrapper req = new RC_FI_ConnectionAndContractIntegrator.RequestWrapper();
        List<RC_FI_ConnectionAndContractIntegrator.Item> odemePlanItemList = new List<RC_FI_ConnectionAndContractIntegrator.Item>();
        List<RC_FI_ConnectionAndContractIntegrator.Item> sozlesmeItemList = new List<RC_FI_ConnectionAndContractIntegrator.Item>();
        
        RC_Financial_Process_Definition__c connection = [SELECT Id,RC_Approval_Status__c, RC_Account__c, RC_Bordro_Status__c, RC_Account__r.RC_SAP_ID__c,RC_Account__r.Name, 
                                                         RC_TERM_ID__r.RC_Payment_Form__c, RC_TERM_ID__r.RC_Comments__c, RC_KKA__c, RC_KKA_Defination__c,
                                                         RC_Payment_Term__c, RC_Comments__c, RC_Bordro_Types__c, RC_Average_Due_Date__c, RC_Amount__c, RC_IsExtra__c, 
                                                         RC_TERM_ID__c, RC_TERM_ID__r.RC_Start_Date__c, RC_TERM_ID__r.RC_End_Date__c,RC_Bordro_No__c 
                                                         FROM RC_Financial_Process_Definition__c  WHERE RecordType.DeveloperName='Connection_Bordro_Entry'  AND Id=:connectionId];
        
        //Onay Atlatma işleminde bağlantı statüsü sadece Bağlantı plan girişi onaylandı ise SAP'ye gönderim yapılır.
        if(connection.RC_Approval_Status__c != '1' && type=='ApproverChange')
            return true;
        
        if(type=='UpdateCheques' && chequesToBeDeleted!=null && chequesToBeDeleted.size()>0)
        {
            List<RC_Cheques__c> chequeList = [SELECT RC_Bordro__c, Name, Id, RC_Cheque_Number__c, RC_Due_Date__c,RC_Amount__c FROM RC_Cheques__c
                                              WHERE RC_Bordro__c=: connection.RC_Bordro_No__c AND RC_Type__c='Cheque' AND RC_Cheque_Number__c NOT IN:chequesToBeDeleted];
            
            for(RC_Cheques__c cheque : chequeList){
                chequesAmount += Double.ValueOf(cheque.RC_Amount__c);
            }
        }
        
        
        List<RC_Financial_Process_Definition__c> similarPayrolls = [SELECT RC_Amount__c FROM RC_Financial_Process_Definition__c
                                                                    WHERE RC_KKA__c =:connection.RC_KKA__c AND  RC_Approval_Status__c = '1' 
                                                                    AND RC_Account__c =: connection.RC_Account__c AND RecordType.DeveloperName = 'Connection_Bordro_Entry' 
                                                                    AND RC_IsExtra__c =: connection.RC_IsExtra__c AND RC_TERM_ID__c =: connection.RC_TERM_ID__c];
        
        
        
        Double totalCurrency = 0.00;
        Double remainCurrency = 0.00;
        for(RC_Financial_Process_Definition__c sPayroll : similarPayrolls){
            totalCurrency += Double.ValueOf(sPayroll.RC_Amount__c);
        }
        if(chequesAmount > 0.00)
        {
            double deletedChequesAmount = 0.00;
            List<RC_Cheques__c> cheques = [SELECT RC_Bordro__c, Name, Id, RC_Cheque_Number__c, RC_Due_Date__c,RC_Amount__c FROM RC_Cheques__c
                                           WHERE RC_Bordro__c=: connection.RC_Bordro_No__c AND RC_Type__c='Cheque' AND RC_Cheque_Number__c IN:chequesToBeDeleted];
            for(RC_Cheques__c c : cheques){
                deletedChequesAmount += Double.ValueOf(c.RC_Amount__c);
            }
            
            remainCurrency = totalCurrency - deletedChequesAmount;
        }
        else
        {
            remainCurrency = totalCurrency - Double.valueOf(connection.RC_Amount__c);  
        }
        
        
        
        
        RC_FI_ConnectionAndContractIntegrator.item itemBody = new RC_FI_ConnectionAndContractIntegrator.item();
        itemBody.MANDT= '021';
        itemBody.GJAHR = connection.RC_TERM_ID__r.RC_Payment_Form__c.substring(0,4); 
        itemBody.KUNNR = connection.RC_Account__r.RC_SAP_ID__c;
        itemBody.ZLSCH = connection.RC_TERM_ID__r.RC_Payment_Form__c.substring(4,5); 		
        itemBody.KKBER = connection.RC_KKA__c; 									
        itemBody.ROW_NO = String.valueOf(connection.RC_IsExtra__c);
        itemBody.BORDROTIPI = connection.RC_Bordro_Types__c;
        itemBody.PORTFOY = [SELECT Id,RC_Portfolio_Code__c  FROM RC_Financial_Process_Definition__c WHERE 	RC_Bordro_Types__c =:connection.RC_Bordro_Types__c and RecordType.DeveloperName = 'Bordro_Types'].RC_Portfolio_Code__c;
        itemBody.SMCTR = chequesAmount > 0.00 ? string.valueOf(chequesAmount) : '0';
        itemBody.CVDTE = RC_UtilitiesClass.formatDate(String.valueOf(connection.RC_Average_Due_Date__c));
        
        odemePlanItemList.add(itemBody);
        
        RC_FI_ConnectionAndContractIntegrator.item sozlesmeBody = new RC_FI_ConnectionAndContractIntegrator.item();
        sozlesmeBody.MANDT= '021';
        sozlesmeBody.GJAHR = connection.RC_TERM_ID__r.RC_Payment_Form__c.substring(0,4); 	// ex: 2021A => 2021
        sozlesmeBody.KUNNR = connection.RC_Account__r.RC_SAP_ID__c;
        sozlesmeBody.ZLSCH = connection.RC_TERM_ID__r.RC_Payment_Form__c.substring(4,5); 		// ex: 2021A => A
        sozlesmeBody.KKBER = connection.RC_KKA__c; 									// ex:0001, 0006
        sozlesmeBody.ROW_NO = String.valueOf(connection.RC_IsExtra__c);
        sozlesmeBody.SMCTR	= String.valueOf(remainCurrency);
        sozlesmeBody.CVDTE = RC_UtilitiesClass.formatDate(String.valueOf(connection.RC_Average_Due_Date__c));
        sozlesmeBody.START_DATE = RC_UtilitiesClass.formatDate(String.valueOf(connection.RC_TERM_ID__r.RC_Start_Date__c));
        sozlesmeBody.END_DATE = RC_UtilitiesClass.formatDate(String.valueOf(connection.RC_TERM_ID__r.RC_End_Date__c));
        sozlesmeBody.TIMESTAMP = '0';
        sozlesmeBody.USERNAME = '';
        sozlesmeBody.VARIANT = '';
        sozlesmeBody.ZTERM =  [SELECT Id, RC_Payment_Term__c  FROM RC_Financial_Process_Definition__c  WHERE Id =:connection.RC_Payment_Term__c].RC_Payment_Term__c;
        sozlesmeBody.GJAHR_ZLSCH = connection.RC_TERM_ID__r.RC_Payment_Form__c;
        sozlesmeBody.LAST_DATE = '';
        sozlesmeBody.LAST_TIME = '';
        
        sozlesmeItemList.add(sozlesmeBody);
        
        
        RC_FI_ConnectionAndContractIntegrator.IT_SOZLESME sozlesme = new RC_FI_ConnectionAndContractIntegrator.IT_SOZLESME();
        sozlesme.item = sozlesmeItemList;
        
        RC_FI_ConnectionAndContractIntegrator.IT_ODEME_PLAN odemePlan = new RC_FI_ConnectionAndContractIntegrator.IT_ODEME_PLAN();
        odemePlan.item = odemePlanItemList;
        
        req.IT_ODEME_PLAN = odemePlan;
        req.IT_SOZLESME = sozlesme;
        system.debug('request:' + req);
        RC_BordroCancelIntegratorParser response = RC_FI_ConnectionAndContractIntegrator.FI_ConnectionAndContractFunction(req);
        
        if(response.EV_FLAG == 'S'){
            try
            {
                result=true;
            }
            catch(exception e)
            {
                RC_Logger.LOG_EXCEPTION(response.EV_FLAG, response.EV_RETURN, string.valueOf(e), 'RC_ConnectionApprovalFlow', 'RC_FI_ConnectionAndContractIntegrator', 'RC_ConnectionApprovalFlow');
                
            }            
        }
        
        return result;
        
    }
}