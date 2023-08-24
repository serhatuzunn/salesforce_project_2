@isTest
public class RC_DtsBordroHesapControllerTest {

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
            RC_Process_Type__c = '03',
            RC_Bordro_Type__c = 'D',
            RC_IsSend__c = false
        );
        insert newBordro;
        
        RC_Bordro__c newBordro2 = new RC_Bordro__c(
            RC_Bordro_No__c = '1000011665',
            RC_Dealer_Number__c = '20102242',
            RC_Average_Due_Date__c = Date.newInstance(2021, 09, 30),
            RC_Amount__c = 12178.52,
            RC_Bordro_Status_ID__c = '1',
            RC_Connected__c = false,
            RC_Process_Type__c = '03',
            RC_Bordro_Type__c = 'D',
            RC_IsSend__c = false
        );
        insert newBordro2;
        
        RC_Cheques__c newCheque = new RC_Cheques__c(
            RC_City__c = crCity.Id,
            RC_Due_Date__c = Date.newInstance(2021, 09, 12),
            RC_Cheque_Number__c = '4356254822',
            RC_Amount__c = 6000,
            RC_Identification_Number__c = '12485464618',
            RC_Cheque_Bill__c = 'Cheque',
            RC_Bordro__c = newBordro.Id,
            RC_Type__c = 'Cheque'
        );
        insert newCheque;
        
        RC_Cheque_Payment_Plan__c newPlan = new RC_Cheque_Payment_Plan__c(
            RC_Bordro__c = newBordro.id, 
            RC_Payment_Plan_Due_Date__c = Date.today(),
            RC_Payment_Plan_Amount__c= 3131,
            RC_Payment_Plan_Number__c = '31'
        );
        insert newPlan;
    }


    @IsTest
    static void unitTest(){
        Id bordroId = [SELECT Id FROM RC_Bordro__c LIMIT 1].Id;
        RC_Bordro__c bordro = [SELECT Id,RC_Average_Due_Date__c,RC_Amount__c , (SELECT RC_Amount__c, RC_Due_Date__c FROM Cheques__r WHERE RC_Type__c = 'Cheque') FROM RC_Bordro__c LIMIT 1];
        List<RC_Cheque_Payment_Plan__c> planListFromDB = [SELECT Id,CreatedDate ,RC_Payment_Plan_Number__c, RC_Bordro__r.RC_Bordro_No__c,RC_Payment_Plan_Due_Date__c,RC_Payment_Plan_Amount__c FROM RC_Cheque_Payment_Plan__c]; 
        
        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        Test.startTest();
        
        List<RC_Bordro__c> bordroList  = RC_DtsBordroHesapController.getBordroList('true','20102242');
        List<RC_Bordro__c> bordroList2 = RC_DtsBordroHesapController.getBordroList('false','20102242');
        List<RC_Cheques__c> cekList    = RC_DtsBordroHesapController.getRelatedInvoice(bordroId);
        Decimal testDec = 1.1;
        Date testDate = RC_DtsBordroHesapController.getAverageMaturity(bordro,testDec, Date.today());
        RC_DtsBordroHesapController.InitializePlanModel plan = RC_DtsBordroHesapController.initializeOdemePlan(bordroId,'313131','3131/31/31');
        plan.chequeType = '';
        plan.bordroType = '';
        plan.message = '';
        plan.calculatedDate = '';
        plan.calculatedDate = '';
        plan.calculatedAmount = '';
        plan.isSuccess = true;
		
        List<RC_Cheque_Payment_Plan__c> planList = [Select id FROM RC_Cheque_Payment_Plan__c where RC_Bordro__c =: bordroId];
        Database.delete(planList);
        
        
        RC_DtsBordroHesapController.calculatePlan(bordroId, true, 5, 10);
        RC_DtsBordroHesapController.calculatePlan(bordroId, true, 6, 10);
       

        
        
        
        RC_DtsBordroHesapController.calculateGeneralInfo(bordroId, plan.paymentPlan);
        RC_DtsBordroHesapController.checkPlan(bordroId, plan.paymentPlan);
        
        for(RC_Cheque_Payment_Plan__c p : plan.paymentPlan){
            p.id = null;
            p.RC_Bordro__c = bordroId;
        }
        
        RC_DtsBordroHesapController.processPaymentPlan(plan.paymentPlan);
        RC_DtsBordroHesapController.deletePlan(bordroId);
        
        
        
        Test.stopTest();
    }
     @IsTest
    static void unitTest2(){
        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        List<RC_Cheque_Payment_Plan__c> planListFromDB = [SELECT Id,CreatedDate ,RC_Payment_Plan_Number__c, RC_Bordro__r.RC_Bordro_No__c,RC_Payment_Plan_Due_Date__c,RC_Payment_Plan_Amount__c FROM RC_Cheque_Payment_Plan__c]; 
        Test.startTest();
        Id bordroId = [SELECT Id FROM RC_Bordro__c WHERE RC_Bordro_No__c = '1000011665' LIMIT 1].Id;
        RC_DtsBordroHesapController.InitializePlanModel plan2 = RC_DtsBordroHesapController.initializeOdemePlan(bordroId,'313131','3131/31/31');
        RC_DtsBordroHesapController.sendPlanToSapResponseWrapper wrp =  RC_DtsBordroHesapController.sendPaymentPlanToSAP(planListFromDB);
        Test.stopTest();
    }
    

}