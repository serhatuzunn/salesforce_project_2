@isTest
public class RC_ConnectionApprovalFlow_Test {
	@isTest
    public static void unitTest(){
        
        RC_ConnectionApprovalFlow.SelectOptionWrapper selectWrapper = new  RC_ConnectionApprovalFlow.SelectOptionWrapper();
        selectWrapper.Label = '';
        selectWrapper.Value = '';
        
        RC_ConnectionApprovalFlow.InitWrapper InitWrapper = new  RC_ConnectionApprovalFlow.InitWrapper();
        InitWrapper.ConnectionPeriods = new List<RC_ConnectionApprovalFlow.SelectOptionWrapper>();
        InitWrapper.BordroTypes = new List<RC_ConnectionApprovalFlow.SelectOptionWrapper>();
        
        RC_ConnectionApprovalFlow.OrtalamaVadeModel OrtalamaVadeModel = new  RC_ConnectionApprovalFlow.OrtalamaVadeModel();
        OrtalamaVadeModel.BAKIYE = '';
        OrtalamaVadeModel.ORTVADE = '';
        
        RC_ConnectionApprovalFlow.Approver Approver = new  RC_ConnectionApprovalFlow.Approver();
        Approver.UserId = '';
        Approver.UserName = '';
        
        RC_ConnectionApprovalFlow.ApprovalModal ApprovalModal = new  RC_ConnectionApprovalFlow.ApprovalModal();
        ApprovalModal.selectedStatus = '';
        ApprovalModal.statusUserMap = new Map<string,RC_ConnectionApprovalFlow.Approver>();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User usr = new User();
        usr.Username = 'test123321@123.com'; 
        usr.LastName = 'test'; 
        usr.Email = 'test@123.com'; 
        usr.Alias = 'test'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.EmailEncodingKey = 'UTF-8'; 
        usr.ProfileId = p.Id;
        usr.LanguageLocaleKey = 'en_US';
		insert usr;
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.RC_SAP_ID__c = 'test';
        insert acc;
        
        RC_Financial_Process_Definition__c connTerm = new RC_Financial_Process_Definition__c();
        connTerm.RC_Payment_Form__c = 'test_deneme';
        connTerm.RC_Start_Date__c = Date.newInstance(2021,11,11);
        connTerm.RC_End_Date__c  = Date.newInstance(2021,11,11);
        insert connTerm;
        
        RC_Financial_Process_Definition__c connPortfolio = new RC_Financial_Process_Definition__c();
        Id connPortfolio_recordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Bordro_Types').getRecordTypeId();
        connPortfolio.RecordTypeId  = connPortfolio_recordTypeId;
        connPortfolio.RC_Portfolio_Code__c = '11';
        connPortfolio.RC_IsActive__c = true;
        //connection bordro type ile aynı olmalı!!
        connPortfolio.RC_Bordro_Types__c = '1';
        insert connPortfolio;
        
        
        RC_Financial_Process_Definition__c connection = new RC_Financial_Process_Definition__c();
        Id connection_recordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Bordro_Entry').getRecordTypeId();
        connection.RecordTypeId  = connection_recordTypeId;
        connection.RC_TERM_ID__c = connTerm.Id;
        connection.RC_Bordro_Types__c= '1';
        connection.RC_Average_Due_Date__c = Date.newInstance(2021,11,11);
        connection.RC_Start_Date__c = Date.newInstance(2021,11,11);
        connection.RC_End_Date__c =  Date.newInstance(2021,11,11);
        connection.RC_Payment_Term__c = connTerm.Id;
        connection.RC_Amount__c = 1000.0;
        insert connection;
        
        RC_Financial_Process_Definition__c statusCon = new RC_Financial_Process_Definition__c();
        Id statusCon_recordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Approval_Status').getRecordTypeId();
        statusCon.RecordTypeId  = statusCon_recordTypeId;
        statusCon.RC_SAP_ID__c = '0';
        insert statusCon;
        
    
        RC_Financial_Process_Definition__c connDate = new RC_Financial_Process_Definition__c();
        Id connDate_recordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Period').getRecordTypeId();
        connDate.RecordTypeId  = connDate_recordTypeId;
        connDate.RC_TERM_ID__c = connTerm.Id;
        insert connDate;
          
        
        RC_SD_Organization__c sdOrg = new RC_SD_Organization__c();
        sdOrg.RC_Account__c = acc.Id;
        sdOrg.Distribution_Channel__c = '01';
        insert sdOrg;
        
        RC_Bordro__c bordro = new RC_Bordro__c();
        bordro.RC_Average_Due_Date__c = Date.newInstance(2021,11,11);
        bordro.RC_Amount__c = 1000.0;
        bordro.RC_Bordro_No__c = '123';
        insert bordro;
        
        RC_Bordro__c bordro2 = new RC_Bordro__c();
        bordro2.RC_Average_Due_Date__c = Date.newInstance(2021,11,11);
        bordro2.RC_Amount__c = 1000.0;
        insert bordro2;
        
        RC_Cheques__c chq = new RC_Cheques__c();
        chq.RC_Amount__c = 10000.0;
        chq.RC_Due_Date__c = Date.newInstance(2021,11,11);
        chq.RC_Cheque_Number__c = 'test';
        insert chq;
        
        List<String> chqList = new List<String>();
        chqList.add(chq.RC_Cheque_Number__c);
        

        RC_ConnectionApprovalFlow.Initialize();
        RC_ConnectionApprovalFlow.GetConnections(acc.Id,'test','test','123');
        RC_ConnectionApprovalFlow.GetApprovalStatus();
        RC_ConnectionApprovalFlow.GetApprovalData(connection.Id, acc.Id);
        RC_ConnectionApprovalFlow.GetChequeData('');
        RC_ConnectionApprovalFlow.GetPayrollTotalAmountAndAvg(bordro.Id);
        RC_ConnectionApprovalFlow.CalculateAvgMaturity(chqList);
        RC_ConnectionApprovalFlow.DeletePayroll(bordro.Id, connection.Id, '');
        RC_ConnectionApprovalFlow.UpdateConnection(bordro2.Id, chqList, '100000', '2021-11-11', connection.Id, '');
        RC_ConnectionApprovalFlow.ChangeApprovalStatus('' ,  ApprovalModal.statusUserMap);
        RC_ConnectionApprovalFlow.SaveApprovalChange('', '0', connection.Id, usr.Id);
        }
}