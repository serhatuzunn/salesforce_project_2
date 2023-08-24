@IsTest
public class RC_CreateChequeAndBondTest {

    @TestSetup
    static void prepareData(){
        RC_City_Region__c crCity = new RC_City_Region__c(
        	RC_Type__c = 'City',
            Name = 'İstanbul', 
            RC_Code__c = '34'
        );
        
        insert crCity;
        
        RC_City_Region__c crRegion = new RC_City_Region__c(
        	RC_Type__c = 'Region',
            Name = 'Beşiktaş', 
            RC_City__c = crCity.Id,
            RC_Code__c = '3401'
        );
        
        insert crRegion;
        
        Account newAccount = new Account(
            RC_City__c = crCity.Id,
            RC_Region__c = crRegion.Id,
            RC_Dealer_Type__c = 'BAYI',
            Name = 'Test Account',
            RC_SAP_ID__c = '20102242'
        );
        
        insert newAccount;
        
        Cheque_Parameters__c newCP = new Cheque_Parameters__c(
            Name = 'OCTTutarFark',
        	Value__c = '100'
        );
            
        insert newCP;
        
        Cheque_Parameters__c newCP2 = new Cheque_Parameters__c(
            Name = 'OCTGunFark',
            Value__c = '5'
        );
        
        insert newCP2;        
        
        RC_Bordro__c newBordro = new RC_Bordro__c(
            RC_Bordro_No__c = '1000011664',
            RC_Dealer_Number__c = '20102242',
            RC_Average_Due_Date__c = Date.newInstance(2021, 09, 30),
            RC_Amount__c = 12178.52,
            RC_Bordro_Status_ID__c = '1',
            RC_Connected__c = false,
            RC_Bordro_Type__c = 'C',
            RC_Process_Type__c = '01'
        );
        
        insert newBordro;
        
        RC_Bordro__c newBordro2 = new RC_Bordro__c(
            RC_Bordro_No__c = '1000011664',
            RC_Dealer_Number__c = '20102242',
            RC_Average_Due_Date__c = Date.newInstance(2021, 09, 30),
            RC_Amount__c = 12178.52,
            RC_Bordro_Status_ID__c = '1',
            RC_Connected__c = false,
            RC_Bordro_Type__c = 'B',
            RC_Process_Type__c = '03'
        );
        
        insert newBordro2;
        
        RC_Cheques__c newCheque = new RC_Cheques__c(
            RC_City__c = crCity.Id,
            RC_Due_Date__c = Date.newInstance(2021, 09, 12),
            RC_Cheque_Number__c = '4356254822',
            RC_Amount__c = 6000,
            RC_Identification_Number__c = '12485464618',
            RC_Cheque_Bill__c = 'Cheque',
            RC_Bordro__c = newBordro.Id
        );
        
        insert newCheque;
        
        RC_Financial_Process_Definition__c newParam = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('RC_Cheque_Parameters').getRecordTypeId(),
        	RC_Process_Type__c = '01',
            RC_Amount_Negative__c = 0,
            RC_Amount_Positive__c = 0,
            RC_Due_Date_Negative__c = 0,
            RC_Due_Date_Positive__c = 0,
            RC_Bordro_No__c = newBordro.Id
        );
        
        insert newParam;
        
        
        RC_Financial_Process_Definition__c newParam2 = new RC_Financial_Process_Definition__c(
            RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('RC_Cheque_Parameters').getRecordTypeId(),
        	RC_Process_Type__c = '01',
            RC_Amount_Negative__c = 0,
            RC_Amount_Positive__c = 0,
            RC_Due_Date_Negative__c = 0,
            RC_Due_Date_Positive__c = 0
        );
        
        insert newParam2;
    }
    
    @IsTest
    static void unitTestForIOP(){
        Id bordroId = [SELECT Id FROM RC_Bordro__c where RC_Bordro_Type__c = 'C' LIMIT 1].Id;
        
        Test.startTest();
        
        RC_CreateChequeAndBond.InitializePlan plan = RC_CreateChequeAndBond.initializeOdemePlan(bordroId);
        
        RC_CreateChequeAndBond.calculateGeneralInfo(bordroId, plan.paymentPlan);
        RC_CreateChequeAndBond.checkPlan(bordroId, plan.paymentPlan);
        RC_CreateChequeAndBond.processPaymentPlan(plan.paymentPlan, 'insert');
        RC_CreateChequeAndBond.processPaymentPlan(plan.paymentPlan, 'delete');
        RC_CreateChequeAndBond.getStatus();
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForCP(){
        Id bordroId = [SELECT Id FROM RC_Bordro__c WHERE RC_Bordro_Type__c = 'C' LIMIT 1].Id;
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        
        Test.startTest();
        List<RC_Bordro__c> bordroList = RC_CreateChequeAndBond.getBordroList(accId, null, null, null);
        string bayi = RC_CreateChequeAndBond.bayiKodCheck('20102242');
        List<RC_CreateChequeAndBond.SelectOptionWrapper> citySelection = RC_CreateChequeAndBond.getCitySelectOption();
        List<RC_CreateChequeAndBond.SelectOptionWrapper> regionSelection = RC_CreateChequeAndBond.getRegionSelectOption(citySelection.get(0).Value);
        List<RC_CreateChequeAndBond.SelectOptionWrapper> bayiSelection = RC_CreateChequeAndBond.getBayiSelectOption(citySelection.get(0).Value, regionSelection.get(0).Value);
        RC_CreateChequeAndBond.calculatePlan(bordroId, false, 3, 15);
        
        RC_Cheques__c newBill = new RC_Cheques__c(
        	RC_Cheque_Bill__c = 'Bill',
            RC_Amount__c = 10000,
            RC_Due_Date__c = Date.newInstance(2022, 01, 01),
            RC_Identification_Number__c = '12905478212',
            RC_Type__c = 'Cheque',
            RC_Check_Status_ID__c = '1'
        );
        
        RC_Cheques__c newCheque = new RC_Cheques__c(
        	RC_Cheque_Bill__c = 'Cheque',
            RC_Amount__c = 10000,
            RC_Due_Date__c = Date.newInstance(2022, 01, 01),
            RC_Identification_Number__c = '12905478212',
            RC_Type__c = 'Cheque',
            RC_Check_Status_ID__c = '1',
            RC_Bordro__c = bordroId,
            RC_Drawer_Region__c = 'Istanbul',
            RC_Bank_Account_Number__c = '1231231',
            RC_Account_No__c = '20102242'
        );
        
        List<RC_Cheques__c> insList = new List<RC_Cheques__c>();
        insList.add(newBill);
        insList.add(newCheque);
        
        RC_CreateChequeAndBond.validateInput(newBill);
        RC_CreateChequeAndBond.validateInput(newCheque);
        RC_CreateChequeAndBond.validateInput(new RC_Cheques__c(RC_Cheque_Bill__c ='Cheque'));
        RC_CreateChequeAndBond.validateInput(new RC_Cheques__c(RC_Cheque_Bill__c ='Bill'));
        RC_CreateChequeAndBond.insertChequeList(insList);        
        RC_CreateChequeAndBond.checkPlan(bordroId, null);
        
        RC_Bordro__c bordro1 = [SELECT Id, RC_Average_Due_Date__c, RC_Amount__c FROM RC_Bordro__c LIMIT 1];
        RC_CreateChequeAndBond.getAverageMaturity(bordro1, 20000, Date.newInstance(2022, 01, 01));
        RC_Bordro__c bordro2 = [SELECT Id, RC_Average_Due_Date__c, RC_Amount__c, (SELECT Id, RC_Amount__c, RC_Due_Date__c FROM Cheques__r) FROM RC_Bordro__c LIMIT 1];
        RC_CreateChequeAndBond.getAverageMaturity(bordro2, 20000, Date.newInstance(2022, 01, 01));
        RC_CreateChequeAndBond.deleteCheque(null);
        RC_CreateChequeAndBond.deleteOdemePlan(null);
        RC_CreateChequeAndBond.deleteCheque([SELECT Id FROM RC_Cheques__c LIMIT 1].Id);
        RC_CreateChequeAndBond.approve(bordroId, 0, Date.newInstance(2022, 01, 01), Date.newInstance(2022, 01, 01), accId);
        RC_CreateChequeAndBond.checkVadeSystem('1000011664', Date.newInstance(2022, 01, 01));
        
        Test.stopTest();
    }
    
    
    @IsTest
    static void unitTestForDelete(){
        Test.setMock(HttpCalloutMock.class, new RC_BordroSilIntegratorMock());
        Id bordroId = [SELECT Id FROM RC_Bordro__c WHERE RC_Bordro_Type__c = 'B' LIMIT 1].Id;
        Id cityId = [Select id from RC_City_Region__c WHERE RC_Type__c = 'City'].Id;
        
        Test.startTest();
        RC_CreateChequeAndBond.getBankInfosByCity(cityId, 'Beşik');
        RC_CreateChequeAndBond.getRelatedInvoice(bordroId);        
        RC_CreateChequeAndBond.checkVadeValor(null, null, null, null);
        RC_CreateChequeAndBond.getParams(bordroId, '');
        
        RC_CreateChequeAndBond.deleteBordro(bordroId);
        RC_CreateChequeAndBond.approve(null, 0, Date.newInstance(2022, 01, 01), Date.newInstance(2022, 01, 01), null);
        
        Test.stopTest();
    }
}