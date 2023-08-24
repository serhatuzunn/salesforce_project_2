@IsTest
public class RC_AssociatedChequeControllerTest {

    @TestSetup
    static void prepareData(){
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
        
        definitionInsertList.add(newApprovalStatus);
        definitionInsertList.add(newApprovalStatus2);
        
        RC_Financial_Process_Definition__c newBordroStatus = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Bordro_Status').getRecordTypeId(),
            RC_SAP_ID__c = 'Plan', 
            RC_Text__c  = 'Bağlantı planlaması yapılıyor',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newBordroStatus2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Bordro_Status').getRecordTypeId(),
            RC_SAP_ID__c = 'Onay', 
            RC_Text__c  = 'Bağlantı plan girişi onaylandı',
            RC_IsActive__c = true
        );
        
        definitionInsertList.add(newBordroStatus);
        definitionInsertList.add(newBordroStatus2);
        
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
        
        RC_Financial_Process_Definition__c newBordroType = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Bordro_Types').getRecordTypeId(),
            RC_Portfolio_Code__c = 'C51', 
            RC_Bordro_Types__c = 'B', 
            RC_Bordro_Type_Definations__c = 'Bağlantı Fiziki Çek',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newBordroType2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Bordro_Types').getRecordTypeId(),
            RC_Portfolio_Code__c = 'C98', 
            RC_Bordro_Types__c = 'D', 
            RC_Bordro_Type_Definations__c = 'Bağlantı DTS Çek',
            RC_IsActive__c = true
        );
        
        definitionInsertList.add(newBordroType);
        definitionInsertList.add(newBordroType2);
        
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
        
        RC_Financial_Process_Definition__c newPaymentForm = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Payment_Forms').getRecordTypeId(),
            RC_Payment_Form__c = 'A', 
            RC_Fiscal_Year__c = 2021, 
            RC_Comments__c = 'Q1 Orta Ölçekli Bağlantı', 
            RC_Text__c = 'Q1 Orta Ölçekli Bağlantı',
            RC_IsActive__c = true
        );
        
        RC_Financial_Process_Definition__c newPaymentForm2 = new RC_Financial_Process_Definition__c(
        	RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Payment_Forms').getRecordTypeId(),
            RC_Payment_Form__c = 'Y', 
            RC_Fiscal_Year__c = 2020, 
            RC_Comments__c = 'Q2 Orta Ölçekli Bağlantı', 
            RC_Text__c = 'Q2 Orta Ölçekli Bağlantı',
            RC_IsActive__c = true
        );
        
        definitionInsertList.add(newPaymentForm);
        definitionInsertList.add(newPaymentForm2);
        
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
        
        insert definitionInsertList;
        
        List<RC_Financial_Process_Definition__c> cariRelatedInsertList = new List<RC_Financial_Process_Definition__c>();
        RC_Financial_Process_Definition__c cariRelatedOdemeKosul1 = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Period_Payment_Terms').getRecordTypeId(),
        	RC_Term_ID__c = newCariDonem.Id,
            RC_Payment_Term__c = 'VPNK'
        );
        
        RC_Financial_Process_Definition__c cariRelatedOdemeKosul2 = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Period_Payment_Terms').getRecordTypeId(),
        	RC_Term_ID__c = newCariDonem.Id,
            RC_Payment_Term__c = '1/3'
        );
        
        cariRelatedInsertList.add(cariRelatedOdemeKosul1);   
        cariRelatedInsertList.add(cariRelatedOdemeKosul2);  
        
        RC_Financial_Process_Definition__c cariRelatedBordroType1 = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Period_Bordro_Type').getRecordTypeId(),
        	RC_Term_ID__c = newCariDonem.Id,
            RC_Bordro_Types__c = 'B'
        );
        
        RC_Financial_Process_Definition__c cariRelatedBordroType2 = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Period_Bordro_Type').getRecordTypeId(),
        	RC_Term_ID__c = newCariDonem.Id,
            RC_Bordro_Types__c = 'D'
        );

        cariRelatedInsertList.add(cariRelatedBordroType1);         
        cariRelatedInsertList.add(cariRelatedBordroType2);   
        
        RC_Financial_Process_Definition__c cariRelatedKrediKontrol1 = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Period_Credit_Control').getRecordTypeId(),
        	RC_Term_ID__c = newCariDonem.Id,
            RC_KKA__c = '0001'
        );
        
        RC_Financial_Process_Definition__c cariRelatedKrediKontrol2 = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Period_Credit_Control').getRecordTypeId(),
        	RC_Term_ID__c = newCariDonem.Id,
            RC_KKA__c = '0006'
        );

        cariRelatedInsertList.add(cariRelatedKrediKontrol1);         
        cariRelatedInsertList.add(cariRelatedKrediKontrol2); 
        
		insert cariRelatedInsertList;        
        
        Account newAccount = new Account(
        	Name = 'ÖMER AKBAYIR LALE HALI MOBİLYA',
            RC_SAP_ID__c = '20100035',
            RC_Dealer_Type__c = 'BAYI'
        );
        
        insert newAccount;
        
        RC_SD_Organization__c newSDOrg = new RC_SD_Organization__c(
        	RC_Account__c = newAccount.Id,
            Distribution_Channel__c = '06',
            RC_Sales_Organization__c = '2201',
            RC_Sales_Expert__c = UserInfo.getUserId()         
        );
        
        insert newSDOrg;
        
        List<Cheque_Parameters__c> cpInsertList = new List<Cheque_Parameters__c>();
        Cheque_Parameters__c cp1 = new Cheque_Parameters__c(
        	Name = 'BaglantiGunFarkPlanYansitma',
            Value__c = '1'
        );
        
        Cheque_Parameters__c cp2 = new Cheque_Parameters__c(
        	Name = 'BaglantiGunFarkNegative',
            Value__c = '-7'
        );
        
        Cheque_Parameters__c cp3 = new Cheque_Parameters__c(
        	Name = 'BaglantiGunFarkPositive',
            Value__c = '7'
        );
        
        cpInsertList.add(cp1);
        cpInsertList.add(cp2);
        cpInsertList.add(cp3);
        
        insert cpInsertList;        
    }
    
    @IsTest
    static void unitTestForInitialize(){               
        Test.startTest();
        
        RC_AssociatedChequeController.InitialWrapper initWrapper = RC_AssociatedChequeController.initComponent();
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForSearch(){        
        Account selectedBayi = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        
        RC_AssociatedChequeController.ResultWrapper result = RC_AssociatedChequeController.searchData(selectedBayi.Id, null, null);
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForSaveDraft(){
        Account selectedBayi = [SELECT Id FROM Account LIMIT 1];
        
        RC_AssociatedChequeController.ResultWrapper initialResult = RC_AssociatedChequeController.searchData(selectedBayi.Id, null, null);
        
        Test.startTest();
        
        List<RC_AssociatedChequeController.ChildWrapper> saveList = new List<RC_AssociatedChequeController.ChildWrapper>();
        for(RC_AssociatedChequeController.MainDataWrapper main : initialResult.resultList){
            if(main.childs != null && main.childs.size() > 0){
                RC_AssociatedChequeController.ChildWrapper firstChild = main.childs.get(0);
                firstChild.isChecked = true;
                firstChild.tutar = 10000;
                firstChild.aciklama = 'Test işlemi';
                
                saveList.add(firstChild);
            }
        }
        
        if(saveList.size() > 0){            
            RC_AssociatedChequeController.ResponseWrapper saveResponse = RC_AssociatedChequeController.saveAsDraft(saveList, true, true);
            
            RC_AssociatedChequeController.ResultWrapper resultAfterSaveProcess = RC_AssociatedChequeController.searchData(selectedBayi.Id, null, null);
        }
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForSaveApprove(){
        Account selectedBayi = [SELECT Id FROM Account LIMIT 1];
        RC_Financial_Process_Definition__c selectedCari = [SELECT Id FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Current_Period' LIMIT 1];
        
        RC_AssociatedChequeController.ResultWrapper initialResult = RC_AssociatedChequeController.searchData(selectedBayi.Id, null, null);
        
        Test.startTest();
        
        List<RC_AssociatedChequeController.ChildWrapper> saveList = new List<RC_AssociatedChequeController.ChildWrapper>();
        for(RC_AssociatedChequeController.MainDataWrapper main : initialResult.resultList){
            if(main.childs != null && main.childs.size() > 0){
                RC_AssociatedChequeController.ChildWrapper firstChild = main.childs.get(0);
                firstChild.isChecked = true;
                firstChild.tutar = 10000;
                firstChild.aciklama = 'Test işlemi';
                
                saveList.add(firstChild);
            }
        }
        
        if(saveList.size() > 0){            
            RC_AssociatedChequeController.ResponseWrapper saveResponse = RC_AssociatedChequeController.saveAsDraft(saveList, false, true);
            
            RC_AssociatedChequeController.ResultWrapper resultAfterSaveProcess = RC_AssociatedChequeController.searchData(selectedBayi.Id, null, null);
            
            List<RC_AssociatedChequeController.HistoryWrapper> historyInfo = RC_AssociatedChequeController.getHistory(selectedBayi.Id, 'B', selectedCari.Id, 'Vestel');
        }
        
        Test.stopTest();
    }
}