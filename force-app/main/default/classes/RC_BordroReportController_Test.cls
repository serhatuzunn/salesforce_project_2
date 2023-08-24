@isTest
public class RC_BordroReportController_Test {
	@isTest(SeeAllData=true)
    public static void UnitTest(){
		RC_BordroReportController.item item = new RC_BordroReportController.item();
        item.MANDT  = '';
        item.GJAHR   = '';
        item.KUNNR  = '';
        item.ZLSCH  = '';
        item.KKBER = '';
        item.ROW_NO  = '';
        item.BORDROTIPI   = '';
        item.PORTFOY  = '';
        item.SMCTR   = '';
        item.CVDTE = '';
        item.START_DATE  = '20211111';
        item.END_DATE  = '20211111';
        item.TIMESTAMP  = '';
        item.USERNAME  = '';
        item.VARIANT  = '';
        item.ZTERM  = '';
        item.GJAHR_ZLSCH  = '';
        item.LAST_DATE  = '';
        item.LAST_TIME  = '';
        item.IV_GJAHR  = '';
        item.IV_KKBER  = '';
        item.IV_KUNNR  = '';
        item.IV_MONAT  = '';
        item.IV_ODK  = '';
        item.IV_TUTAR  = '';
        item.IV_VADE  = '';
        item.IV_ZLSCH  = '';
        
        RC_BordroReportController.DItem DItem = new RC_BordroReportController.DItem();
        DItem.BORDRO = '';
        DItem.KKBER = '';
        DItem.KUNNR = '';
        DItem.TAKST = '';
        DItem.ORTVD = '';
        DItem.WRBTR = '';
        DItem.WAERS = '';
        
        RC_BordroReportController.DTSApproveRequestWrapper dtsRreq = new RC_BordroReportController.DTSApproveRequestWrapper();
        dtsRreq.CT_BAGLANTI_CEK = new RC_BordroReportController.CT_BAGLANTI_CEK();
        
        RC_BordroReportController.CT_BAGLANTI_CEK baglantiCek = new RC_BordroReportController.CT_BAGLANTI_CEK();
        baglantiCek.item = new List<RC_BordroReportController.DItem>();
        
        RC_BordroReportController.HistoryWrapper history = new RC_BordroReportController.HistoryWrapper();
        history.bayiInfo = '';
        history.entryId = '';
        history.bordroTutar = 100.0;
        history.ortalamaVade = Date.newInstance(2021,11,11);
        history.aciklama = '';
        history.isHistoryExist = true;
        history.approvalHistory = new List<RC_Bordro_Approval_History__c>();
        
        RC_Financial_Process_Definition__c financalDefMain = new RC_Financial_Process_Definition__c();
        financalDefMain.RC_Payment_Form__c = '2021A';
        financalDefMain.RC_Payment_Term__c = '';
        financalDefMain.RC_Start_Date__c = Date.newInstance(2021,11,11);
        financalDefMain.RC_End_Date__c = Date.newInstance(2021,11,11);
        insert financalDefMain;
		
        Account acc = new Account();
        acc.Name = 'test';
        acc.RC_SAP_ID__c = '';
        insert acc;
        
        RC_Financial_Process_Definition__c financalDef = new RC_Financial_Process_Definition__c();
        Id recordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Bordro_Entry').getRecordTypeId();
        financalDef.RecordTypeId  = recordTypeId;
        financalDef.RC_Approval_Status__c = '1';
        financalDef.RC_TERM_ID__c = financalDefMain.Id;
         financalDef.RC_Amount__c = 1;
        financalDef.RC_Bordro_Types__c = 'B';
        financalDef.RC_Average_Due_Date__c = Date.newInstance(2021,11,11);
        financalDef.RC_Payment_Term__c = String.valueOf(financalDefMain.Id);
        financalDef.RC_KKA__c = '0001';
        financalDef.RC_Account__c = acc.Id;
        insert financalDef;
        
        RC_Financial_Process_Definition__c financalDefDTS = new RC_Financial_Process_Definition__c();
        Id recordTypeIdDTS = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName().get('Connection_Bordro_Entry').getRecordTypeId();
        financalDefDTS.RecordTypeId  = recordTypeIdDTS;
        financalDefDTS.RC_Approval_Status__c = '1';
        financalDefDTS.RC_TERM_ID__c = financalDefMain.Id;
        financalDefDTS.RC_Amount__c = 1;
        financalDefDTS.RC_Bordro_Types__c = 'D';
        financalDefDTS.RC_Average_Due_Date__c = Date.newInstance(2021,11,11);
        financalDefDTS.RC_Payment_Term__c = String.valueOf(financalDefMain.Id);
        financalDefDTS.RC_KKA__c = '0001';
        financalDefDTS.RC_Account__c = acc.Id;
        insert financalDefDTS;
        
        RC_BordroReportController.IT_SOZLESME sozlesmeItem = new RC_BordroReportController.IT_SOZLESME();
        sozlesmeItem.item = item;
        
        RC_BordroReportController.IT_ODEME_PLAN odemeItem = new RC_BordroReportController.IT_ODEME_PLAN();
        odemeItem.item = item;
        
        RC_BordroReportController.cancelRequestWrapper cancelReq = new RC_BordroReportController.cancelRequestWrapper();
        cancelReq.IT_ODEME_PLAN = odemeItem;
        cancelReq.IT_SOZLESME = sozlesmeItem;
        
        RC_BordroReportController.SelectOption selOpt = new RC_BordroReportController.SelectOption();
        selOpt.label = '';
        selOpt.value = '';
        selOpt.description = '';
        
        RC_BordroReportController.approveReturnWrapper appRet = new RC_BordroReportController.approveReturnWrapper();
        appRet.bordroNo = '';
        appRet.message = '';
        
        RC_BordroReportController.initModel initModel = new RC_BordroReportController.initModel();
        initModel.allTableData = new List<RC_Financial_Process_Definition__c>();
        initModel.connectionPeriodPickList = new List<RC_BordroReportController.SelectOption>();
        
        RC_BordroReportController.initialize();
        RC_BordroReportController.getConnectionPeriodData('2021A','test','D');
        RC_BordroReportController.getConnectionPeriodData('2021A','test','BZ');
        
        List<String> bordroList = new List<String>();
        bordroList.add(financalDef.Id);
        bordroList.add(financalDefDTS.Id);
        RC_BordroReportController.bordroApprove(bordroList);
        RC_BordroReportController.bordroCancel(String.valueOf(financalDef.Id));
        
        Account selectedBayi = [SELECT Id FROM Account LIMIT 1];
        RC_BordroReportController.getHistory(selectedBayi.Id, 'B', '', 'Vestel');
    }
}