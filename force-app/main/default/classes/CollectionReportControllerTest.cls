@isTest
public class CollectionReportControllerTest {
    
    
    @testSetup
    public static void prepareData(){
        RC_Financial_Process_Definition__c financePayment = new RC_Financial_Process_Definition__c();
        financePayment.RecordTypeId 	  			 = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Payment_Forms').getRecordTypeId();
        financePayment.RC_Fiscal_Year__c 			 = 3131;
		financePayment.RC_Payment_Form__c            = 'financePayment';
        financePayment.RC_Comments__c                = 'financePayment';
        insert financePayment;
        
        RC_Financial_Process_Definition__c financeDoc = new RC_Financial_Process_Definition__c();
        financeDoc.RecordTypeId 	  			  	 = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Document_Types').getRecordTypeId();
        financeDoc.RC_Document_Type__c 			  	 = 'financeDoc';
		financeDoc.RC_Document_Type_Defination__c 	 = 'financeDoc';
        insert financeDoc;
        
        RC_Financial_Process_Definition__c financeProcess = new RC_Financial_Process_Definition__c();
        financeProcess.RecordTypeId 	  			  = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Process_Types').getRecordTypeId();
        financeProcess.RC_Process_Type__c 			  = '31';
		financeProcess.RC_Process_Type_Definition__c  = 'process';
        insert financeProcess;
        
        RC_Financial_Process_Definition__c financeCredit = new RC_Financial_Process_Definition__c();
        financeCredit.RecordTypeId 	  			      	 = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Credit_Control_Sales_Organization').getRecordTypeId();
        financeCredit.RC_KKA__c 			    		 = 'Credit';
        financeCredit.RC_KKA_Defination__c      		 = 'Credit';
        insert financeCredit;
        
        Account acc  = new Account();      
        acc.RC_SAP_ID__c = '313131';
        acc.Name  = 'jhonny Sins';
        acc.OwnerId = userInfo.getUserId();
        acc.RC_Mobile__c = '05313313131';
        insert acc;
        
    }

	@isTest
    public static void unitTest(){
        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());

        Account acc = [SELECT id,RC_Mobile__c FROM Account WHERE RC_SAP_ID__c = '313131' LIMIT 1 ];
		string ortVadeJson = '[{"BELNR":1020220441,"BUZEI":"001","KUNNR":"0022200596","BUDAT":"30-09-2021","ZFBDT":"30-09-2021","WAERS":"TRY","DMBTR":"12000.00","SGTXT":"Satış faturası","BLART":"RV","AWKEY":"0516379302","GJAHR":2021,"ZLSPR":"","ZLSCH":"","LTEXT":"SD-Satış Faturası","MATNR":{"item":[{"MATNR":"000000000020282593","MAKTX":"VESTEL AKILLI TAHTA 65","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291812","MAKTX":"A.T. PARÇA 1","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291814","MAKTX":"A.T. PARÇA 3","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291813","MAKTX":"A.T. PARÇA 2","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291815","MAKTX":"A.T. PARÇA 4","FKIMG":"2.000","VRKME":"ST"}]},"MAKTX":"","KKBER":"0011"},{"BELNR":1020202087,"BUZEI":"001","KUNNR":"0022200596","BUDAT":"25-03-2020","ZFBDT":"25-03-2021","WAERS":"USD","DMBTR":1053301.68,"SGTXT":"Satış faturası","BLART":"RV","AWKEY":"0516128000","GJAHR":2020,"ZLSPR":"","ZLSCH":"","LTEXT":"SD-Satış Faturası","MATNR":{"item":[{"MATNR":"000000000020273297","MAKTX":"DRPM-DVB245/S7820(R5)-DT","FKIMG":"3600.000","VRKME":"ST"}]},"MAKTX":"","KKBER":"0011"}]';        
        test.startTest();
        CollectionReportController.initModel                     initResult             = CollectionReportController.initialize();
        CollectionReportController.dataTableModel                dataModel 	            = CollectionReportController.getDocumentOnDemand(acc.id,'','','','','',1,1);
        CollectionReportController.OrtalamaVadeModel             ortVadeResult          = CollectionReportController.ortalamaVadeBul(ortVadeJson);
        RC_FI_BordroGirIntegrator.responseModel                  bordroResult           = CollectionReportController.BordroKaydet(acc.id,'','','',ortVadeJson);
       
        
        test.stopTest();
        
    }

    @isTest
    public static void unitTest2(){
        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        Account acc = [SELECT id,RC_Mobile__c FROM Account WHERE RC_SAP_ID__c = '313131' LIMIT 1 ];
        string ortVadeJson = '[{"BELNR":1020220441,"BUZEI":"001","KUNNR":"0022200596","BUDAT":"30-09-2021","ZFBDT":"30-09-2021","WAERS":"TRY","DMBTR":"12000.00","SGTXT":"Satış faturası","BLART":"RV","AWKEY":"0516379302","GJAHR":2021,"ZLSPR":"","ZLSCH":"","LTEXT":"SD-Satış Faturası","MATNR":{"item":[{"MATNR":"000000000020282593","MAKTX":"VESTEL AKILLI TAHTA 65","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291812","MAKTX":"A.T. PARÇA 1","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291814","MAKTX":"A.T. PARÇA 3","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291813","MAKTX":"A.T. PARÇA 2","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291815","MAKTX":"A.T. PARÇA 4","FKIMG":"2.000","VRKME":"ST"}]},"MAKTX":"","KKBER":"0011"},{"BELNR":1020202087,"BUZEI":"001","KUNNR":"0022200596","BUDAT":"25-03-2020","ZFBDT":"25-03-2021","WAERS":"USD","DMBTR":1053301.68,"SGTXT":"Satış faturası","BLART":"RV","AWKEY":"0516128000","GJAHR":2020,"ZLSPR":"","ZLSCH":"","LTEXT":"SD-Satış Faturası","MATNR":{"item":[{"MATNR":"000000000020273297","MAKTX":"DRPM-DVB245/S7820(R5)-DT","FKIMG":"3600.000","VRKME":"ST"}]},"MAKTX":"","KKBER":"0011"}]';
        test.startTest();
        CollectionReportController.bordroYaratDTSResponseModel   bordroYaratDTSResponse = CollectionReportController.BordroYaratDTS(acc.id,ortVadeJson ,ortVadeJson,'3131','0001','2022-05-01');
        test.stopTest();
    }

}