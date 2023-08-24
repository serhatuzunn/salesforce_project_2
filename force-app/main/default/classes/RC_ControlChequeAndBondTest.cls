@IsTest 
public class RC_ControlChequeAndBondTest {

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
            RC_Account_Type__c = 'Test',
            RC_Mobile__c='5530515353',
        	Phone='05530515353',
            RC_Tax_Number__c ='00000000053',
            RC_SAP_ID__c = '20102242'
        );        
        insert newAccount;
        
        RC_SD_Organization__c SD = new RC_SD_Organization__c();
        SD.RC_Account__c = newAccount.id;
        SD.RC_Sales_Organization__c = '2201';
        SD.Distribution_Channel__c = '01';
        SD.RC_Regional_Directorate__c ='0072';
        insert SD;  
        
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
            RC_Process_Type__c = '03',
            RC_Average_Due_Date__c = Date.today(),
            RC_Amount__c = 12178.52,
            RC_Bordro_Status_ID__c = '2',
            RC_Connected__c = false
        );
        
        insert newBordro;
        
        RC_Cheques__c newCheque = new RC_Cheques__c(
            RC_City__c = crCity.Id,
            RC_Due_Date__c = Date.today(),
            RC_Cheque_Number__c = '4355353',
            RC_Amount__c = 6000,
            RC_Identification_Number__c = '12345678901',
            RC_Cheque_Bill__c = 'Cheque',
            RC_Account_No__c = '20102242',
            RC_Bordro__c = newBordro.Id
        );
        
        insert newCheque;
        
        
        RC_Financial_Process_Definition__c def = new RC_Financial_Process_Definition__c(
        	RC_Comments__c ='Deneme',
            RC_Text__c  ='Deneme',
            RC_IsActive__c   =true,
            RC_Fiscal_Year__c   =2021
        );
        insert def;
        
        def = new RC_Financial_Process_Definition__c(
        	RC_KKA__c ='0001',
            RC_KKA_Defination__c  ='Vestel',
            RC_IsActive__c   =true
        );
        insert def;
        
        def = new RC_Financial_Process_Definition__c(
        	RC_KKA__c ='0011',
            RC_KKA_Defination__c  ='Kamu',
            RC_IsActive__c   =true
        );
        insert def;
    }
    
    
    @isTest
    public static void unitTest(){
        
        String testDate = '2021-11-17';
        String accountCode = '20301005';
        DateTime currDate = DateTime.now();
        Boolean bValue = true;
        
        Id bordroId = [SELECT Id FROM RC_Bordro__c LIMIT 1].Id;
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        
        String creditControl ='Tümü';
        String bordroStatu = '0';
        String docType = '0';
        String accountClosing ='1';
        
        String creditControl2 ='0001-Vestel';
        String bordroStatu2 = '2';
        String docType2 = 'Cheque';
        String accountClosing2 ='0';
        
        
		Test.setMock(HttpCalloutMock.class, new RC_BordroCekGirIntegratorMock());
        
        Test.startTest();
        RC_ControlChequeAndBond.bordroCekGirSAP(bordroId);
        
        
        RC_ControlChequeAndBond.ControlWrapper cw = new RC_ControlChequeAndBond.ControlWrapper();
        
        RC_ControlChequeAndBond.GetControlChequeAndBond(accId,bordroStatu,docType,'',creditControl,accountClosing);
        RC_ControlChequeAndBond.GetControlChequeAndBond(accId,bordroStatu2,docType2,'',creditControl2,accountClosing2);
        RC_ControlChequeAndBond.getBordroRelatedCheques(bordroId);
        RC_ControlChequeAndBond.updateStatusBordroAndCheque(bordroId,'1');
        RC_ControlChequeAndBond.fillBordroStatus();
        RC_ControlChequeAndBond.fillDocType();
        RC_ControlChequeAndBond.fillBaglantiDonem();
        RC_ControlChequeAndBond.fillKKA();
        RC_ControlChequeAndBond.ToPIDateString(testDate);
        RC_ControlChequeAndBond.ToPIDateStringDT(currDate);
        RC_ControlChequeAndBond.ToSAPString10Digits(accountCode);
        RC_ControlChequeAndBond.ToSAPBool(bValue);
 		        
        Test.stopTest();
    } 
    
    
}