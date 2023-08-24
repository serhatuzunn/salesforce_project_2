@IsTest
public class RC_AssociatedChequeApproveTest {
	
    @TestSetup
    static void prepareData(){                
        Account newAccount = new Account(
            Name = 'ÖMER AKBAYIR LALE HALI MOBİLYA',
            RC_SAP_ID__c = '20100035',
            RC_Dealer_Type__c = 'BAYI'
        );
        
        insert newAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(
            Alias = 'anilo', 
            Email='anilo@testorg.com', 
           	EmailEncodingKey='UTF-8', 
            LastName='Test', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='anilo@testorg.com', 
            ManagerId= UserInfo.getUserId());
        
        insert u;        
        
        RC_SD_Organization__c newSDOrg = new RC_SD_Organization__c(
            RC_Account__c = newAccount.Id,
            Distribution_Channel__c = '06',
            RC_Sales_Organization__c = '2201',
            RC_Credit_Control_Field__c = '0001',
            RC_Sales_Expert__c = u.Id         
        );
        
        insert newSDOrg;
        
        List<RC_Financial_Process_Definition__c> definitionInsertList = new List<RC_Financial_Process_Definition__c>();
        RC_Financial_Process_Definition__c newApprovalStatus = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Approval_Status').getRecordTypeId(),
            RC_SAP_ID__c = '5', 
            RC_Text__c  = 'Taslak olarak kaydet',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newApprovalStatus2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Approval_Status').getRecordTypeId(),
            RC_SAP_ID__c = '4', 
            RC_Text__c  = 'Satış müdürü onayında',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newApprovalStatus3 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Approval_Status').getRecordTypeId(),
            RC_SAP_ID__c = '3', 
            RC_Text__c  = 'bm onay',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newApprovalStatus4 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Approval_Status').getRecordTypeId(),
            RC_SAP_ID__c = '2', 
            RC_Text__c  = 'gmy onay',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newApprovalStatus5 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Approval_Status').getRecordTypeId(),
            RC_SAP_ID__c = '0', 
            RC_Text__c  = 'red',
            RC_IsActive__c = true
        );
        
        
        RC_Financial_Process_Definition__c newApprovalStatus6 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Approval_Status').getRecordTypeId(),
            RC_SAP_ID__c = '1', 
            RC_Text__c  = 'onay',
            RC_IsActive__c = true
        );
        
        definitionInsertList.add(newApprovalStatus);
        definitionInsertList.add(newApprovalStatus2);
        definitionInsertList.add(newApprovalStatus3);
        definitionInsertList.add(newApprovalStatus4);
        definitionInsertList.add(newApprovalStatus5);
        definitionInsertList.add(newApprovalStatus6);
        
        RC_Financial_Process_Definition__c newCariDonem = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Current_Period').getRecordTypeId(),
            RC_KKA__c = 'Vestel, Regal, Çeyiz', 
            RC_Comments__c = 'TEST', 
            RC_Payment_Term__c = 'PTOP, VPNK, 1/3, 1/5, 1/7', 
            RC_Start_Date__c = Date.newInstance(2021, 01, 01), 
            RC_End_Date__c = Date.newInstance(2021, 12, 31), 
            RC_Entry_End_Date__c = Date.newInstance(2021, 12, 31), 
            RC_Average_Due_Date__c = Date.newInstance(2021, 07, 15), 
            RC_Priority__c = '1', 
            RC_Document_Type__c = 'Bağlantı Fiziki Çek, Bağlantı DTS Çeki', 
            RC_Payment_Form__c = '2021A',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newCariDonem2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Current_Period').getRecordTypeId(),
            RC_KKA__c = 'Vestel', 
            RC_Comments__c = 'Q2 Orta Ölçekli Bağlantı', 
            RC_Payment_Term__c = 'PTOP, VPNK, 1/3, 1/5, 1/7', 
            RC_Start_Date__c = Date.newInstance(2020, 04, 01), 
            RC_End_Date__c = Date.newInstance(2020, 06, 30), 
            RC_Entry_End_Date__c = Date.newInstance(2020, 06, 28), 
            RC_Average_Due_Date__c = Date.newInstance(2020, 10, 15), 
            RC_Priority__c = '1', 
            RC_Document_Type__c = 'Bağlantı Fiziki Çek, Bağlantı DTS Çeki', 
            RC_Payment_Form__c = '2020Y',
            RC_IsActive__c = true
        );
        
        definitionInsertList.add(newCariDonem);
        definitionInsertList.add(newCariDonem2);
        
        RC_Financial_Process_Definition__c newCreditControl = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Credit_Control_Sales_Organization').getRecordTypeId(),
            RC_Sales_Organization__c = '2201', 
            RC_Distribution_Channel__c = '0006', 
            RC_KKA__c = '0006', 
            RC_KKA_Defination__c = 'Vestel',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newCreditControl2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Credit_Control_Sales_Organization').getRecordTypeId(),
            RC_Sales_Organization__c = '2201', 
            RC_Distribution_Channel__c = '0001', 
            RC_KKA__c = '0001', 
            RC_KKA_Defination__c = 'Çeyiz',
            RC_IsActive__c = true
        );
        
        definitionInsertList.add(newCreditControl);
        definitionInsertList.add(newCreditControl2);
        
        RC_Financial_Process_Definition__c newPaymentType = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Payment_Terms').getRecordTypeId(),
            RC_Payment_Term__c = 'VPNK', 
            RC_Expiry__c = 0,
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newPaymentType2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Payment_Terms').getRecordTypeId(),
            RC_Payment_Term__c = 'PTOP', 
            RC_Expiry__c = 1,
            RC_IsActive__c = true
        );
        
        definitionInsertList.add(newPaymentType);
        definitionInsertList.add(newPaymentType2);
        
        insert definitionInsertList;
        
        RC_Financial_Process_Definition__c bordroEntry = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Bordro_Entry').getRecordTypeId(),
            RC_Payment_Term__c = 'VPNK',             
            RC_Start_Date__c = Date.newInstance(2021, 01, 01), 
            RC_End_Date__c = Date.newInstance(2021, 12, 31), 
            RC_Entry_End_Date__c = Date.newInstance(2021, 12, 31), 
            RC_Average_Due_Date__c = Date.newInstance(2021, 07, 15),
            RC_KKA__c = '0006', 
            RC_KKA_Defination__c = 'Vestel',
            RC_Term_ID__c = newCariDonem.Id,
            RC_Bordro_Status__c = 'Plan',
            RC_Approval_Status__c = '4',
            RC_Account__c = newAccount.Id,
            RC_Amount__c = 30000
        );
        
        RC_Financial_Process_Definition__c bordroEntry2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Bordro_Entry').getRecordTypeId(),
            RC_Payment_Term__c = 'VPNK',             
            RC_Start_Date__c = Date.newInstance(2021, 01, 01), 
            RC_End_Date__c = Date.newInstance(2021, 12, 31), 
            RC_Entry_End_Date__c = Date.newInstance(2021, 12, 31), 
            RC_Average_Due_Date__c = Date.newInstance(2021, 07, 15),
            RC_KKA__c = '0006', 
            RC_KKA_Defination__c = 'Vestel',
            RC_Term_ID__c = newCariDonem.Id,
            RC_Bordro_Status__c = 'Plan',
            RC_Approval_Status__c = '2',
            RC_Account__c = newAccount.Id,
            RC_Amount__c = 50000
        );
        
        System.runAs(u){
            insert bordroEntry;
            insert bordroEntry2;
        }
    }
    
    @IsTest
    static void unitTestForInitialize(){
        Test.startTest();
        
        RC_AssociatedChequeApproveController.initialize();
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForGetUserInfo(){
        RC_SD_Organization__c sdOrg = [SELECT RC_Sales_Expert__c FROm RC_SD_Organization__c LIMIT 1];
        
        Test.startTest();
        
        RC_AssociatedChequeApproveController.getUserInfo('all', new List<String>{sdOrg.RC_Sales_Expert__c});
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForGetEntries(){        
        RC_SD_Organization__c sdOrg = [SELECT RC_Sales_Expert__c FROm RC_SD_Organization__c LIMIT 1];
        RC_Financial_Process_Definition__c cariDonem = [SELECT Id FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Current_Period' AND RC_Payment_Form__C = '2021A' LIMIT 1];
        
        Test.startTest();
        
        RC_AssociatedChequeApproveController.getEntries('0001', cariDonem.Id, new List<String>{sdOrg.RC_Sales_Expert__c});
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForApprovalProcess(){
        List<RC_Financial_Process_Definition__c> bordroList = [SELECT Id FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Entry'];
        
        Test.startTest();
        
        RC_AssociatedChequeApproveController.handleApproveRejectProcess('onay', 'onaylandı', JSON.serialize(bordroList));
        RC_AssociatedChequeApproveController.handleApproveRejectProcess('red', 'reddedildi', JSON.serialize(bordroList));
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForSAPSend(){
        UserRole p = [SELECT Id FROM UserRole WHERE DeveloperName ='Bayi_Genel_Mudur_Yardimcisi']; 
        
        user updateCurrentUser = new User(Id = UserInfo.getUserId(), UserRoleId = p.Id);
        
        update updateCurrentUser;
        
        Test.startTest();
        List<RC_Financial_Process_Definition__c> bordroList = [SELECT Id FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Entry' AND RC_Approval_Status__c = '2'];
        
        RC_AssociatedChequeApproveController.handleApproveRejectProcess('onay', 'onaylandı', JSON.serialize(bordroList));
        
        Test.stopTest();
    }
}