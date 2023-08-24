public with sharing class RC_BordroReportController {
    
    //cancel request wrapper
    public class item{
        public string MANDT { get; set; }
        public string GJAHR { get; set; }
        public string KUNNR { get; set; }
        public string ZLSCH { get; set; }
        public string KKBER { get; set; }
        public string ROW_NO { get; set; }
        public string BORDROTIPI { get; set; }
        public string PORTFOY { get; set; }
        public string SMCTR { get; set; }
        public string CVDTE { get; set; }
        
        public string START_DATE { get; set; }
        public string END_DATE { get; set; }
        public string TIMESTAMP { get; set; }
        public string USERNAME { get; set; }
        public string VARIANT { get; set; }
        public string ZTERM { get; set; }
        public string GJAHR_ZLSCH { get; set; }
        public string LAST_DATE { get; set; }
        public string LAST_TIME { get; set; }
        
        public string IV_GJAHR {get;set;}
        public string IV_KKBER {get;set;}
        public string IV_KUNNR {get;set;}
        public string IV_MONAT {get;set;}
        public string IV_ODK {get;set;}
        public string IV_TUTAR {get;set;}
        public string IV_VADE {get;set;}
        public string IV_ZLSCH {get;set;}
    }
    
    public class IT_INPUT {
		public List<BZItem> item {get;set;}
	}
    
    public class approveRequestWrapper{
        public IT_INPUT IT_INPUT {get;set;}
    }    
    
    public class IT_ODEME_PLAN{
        public item item{get;set;}
    }
    
    public class IT_SOZLESME{
        public item item{get;set;}
    }
    
    public class cancelRequestWrapper{
        public IT_ODEME_PLAN IT_ODEME_PLAN {get;set;}
        public IT_SOZLESME IT_SOZLESME {get;set;}
    }
    
    // BZ approve request Item
    public class BZItem{
        public string GJAHR {get;set;}
        public string KKBER {get;set;}
        public string KUNNR {get;set;}
        public string MONAT {get;set;}
        public string ODK {get;set;}
        public string TUTAR {get;set;}
        public string VADE {get;set;}
        public string ZLSCH {get;set;}
    }
    
    //DTs approve request Item
    public class DItem{
        public string BORDRO {get;set;}
        public string KKBER {get;set;}
        public string KUNNR {get;set;}
        public string TAKST {get;set;}
        public string ORTVD {get;set;}
        public string WRBTR {get;set;}
        public string WAERS {get;set;}
    }
    
    public class CT_BAGLANTI_CEK{
        public List<DItem> item {get;set;}
    }
    
    public class DTSApproveRequestWrapper{
        public CT_BAGLANTI_CEK CT_BAGLANTI_CEK  {get;set;}
    }
    
    public class initModel{
        @AuraEnabled
        public List<RC_Financial_Process_Definition__c> allTableData {get; set;}
        @AuraEnabled
        public List<SelectOption> connectionPeriodPickList  {get; set;}
        @AuraEnabled
        public List<RC_Financial_Process_Definition__c> bordroTypes {get; set;}
    }
    
    public class SelectOption {
        @AuraEnabled
        public string label { get; set; }
        @AuraEnabled
        public string value { get; set; }
        @AuraEnabled
        public string description { get; set; }
    }
    
    public class approveReturnWrapper{
        @AuraEnabled
        public String bordroNo {get;set;}
        @AuraEnabled
        public String message { get;set;}
    }
    
    public class HistoryWrapper{
        @AuraEnabled
        public String bayiInfo {get; set;}
        @AuraEnabled
        public String entryId {get; set;}
        @AuraEnabled
        public Decimal bordroTutar {get; set;}
        @AuraEnabled
        public Date ortalamaVade {get; set;}
        @AuraEnabled
        public String aciklama {get; set;}
        @AuraEnabled
        public Boolean isHistoryExist {get; set;}
        @AuraEnabled
        public List<RC_Bordro_Approval_History__c> approvalHistory {get; set;}
    }
    
    @AuraEnabled
    public static initmodel initialize(){
        initModel result = new initModel();
        
        List<RC_Financial_Process_Definition__c> connList = [SELECT Id, RC_Account__c, RC_Account__r.RC_SAP_ID__c,RC_Account__r.Name, 
                                                               RC_TERM_ID__r.RC_Payment_Form__c, RC_TERM_ID__r.RC_Comments__c, RC_KKA__c, RC_KKA_Defination__c,
                                                               RC_Payment_Term__c, RC_Comments__c, RC_Bordro_Types__c, RC_Average_Due_Date__c, RC_Amount__c  
                                                               FROM RC_Financial_Process_Definition__c  WHERE RecordType.DeveloperName='Connection_Bordro_Entry' AND RC_Approval_Status__c = '1' AND RC_Bordro_No__c = null];
        
        // Ödeme koşulu sorgu atmadan looplar ile hallediliyor.
        List<RC_Financial_Process_Definition__c> newConnList = changeBordroList(connList);
        
        result.allTableData = newConnList;
        system.debug('tableData::: ' + result.allTableData);
        
        List<RC_Financial_Process_Definition__c> fpdPeriods = [SELECT Id, RC_Payment_Form__c, RC_Comments__c FROM RC_Financial_Process_Definition__c
                                                               WHERE RecordType.DeveloperName='Connection_Current_Period' AND RC_IsActive__c = true ];
        
        List<SelectOption> periodList = new List<SelectOption>();
        
        SelectOption optionAll = new SelectOption();
        optionAll.label = 'Hepsi';
        optionAll.value = 'H';
        optionAll.description = 'H';
        periodList.add(optionAll);

        result.bordroTypes = [SELECT Id, RC_Portfolio_Code__c, RC_Document_Type__c, RC_Bordro_Types__c, RC_Bordro_Type_Definations__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Bordro_Types' AND RC_IsActive__c = true];
        
        for(RC_Financial_Process_Definition__c fpd : fpdPeriods ){
            SelectOption option = new SelectOption();
            option.value = fpd.RC_Payment_Form__c;
            option.description = fpd.RC_Comments__c;
            option.label = fpd.RC_Payment_Form__c + ' / ' + fpd.RC_Comments__c;
            periodList.add(option);
        }
        system.debug('period List: ' + periodList);
        result.connectionPeriodPickList = periodList;
        
        return result;
    }
    
    @AuraEnabled
    public static List<RC_Financial_Process_Definition__c> getConnectionPeriodData(String paymentForm, String comment, String bordroType){
        
        String query = 'SELECT Id, RC_Account__c, RC_Account__r.RC_SAP_ID__c,RC_Account__r.Name, ';
        query += 'RC_TERM_ID__r.RC_Payment_Form__c, RC_TERM_ID__r.RC_Comments__c, RC_KKA__c, RC_KKA_Defination__c, ';
        query += 'RC_Payment_Term__c, RC_Comments__c, RC_Bordro_Types__c, RC_Average_Due_Date__c, RC_Amount__c ';
        query += 'FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName=\'Connection_Bordro_Entry\' AND RC_Approval_Status__c = \'1\'  AND RC_Bordro_No__c = null ';
        
        if(String.isNotBlank(paymentForm) && paymentForm != 'H' ){
            query += 'AND RC_TERM_ID__r.RC_Payment_Form__c =: paymentForm '; 
        }
        if(String.isNotBlank(comment) && comment != 'H'){
            query += 'AND RC_TERM_ID__r.RC_Comments__c  =: comment';
        }
        if(String.isNotBlank(bordroType) && bordroType != 'all'){
            switch on bordroType{
                when 'D'{
                    query += ' AND 	RC_isDTS__c = true';
                }
                when 'BZ'{
                    query += ' AND 	RC_isDTS__c = false';
                }
            }
        }
        system.debug('query:::' + query);
        
        List<RC_Financial_Process_Definition__c> connList = Database.query(query);
        
        
        // Ödeme koşulu sorgu atmadan looplar ile hallediliyor.
        List<RC_Financial_Process_Definition__c> newConnList = changeBordroList(connList);
        
        system.debug('result:::' + newConnList);
        
        return newConnList;
    }
    
    @AuraEnabled 
    public static string bordroApprove(List<String> bordroList){
       
        system.debug('length: ' + bordroList.size());
        approveRequestWrapper req = new approveRequestWrapper();
        List<BZItem> items = new List<BZItem>();
        List<DItem> Ditems = new List<DItem>();
        try{
            List<RC_Financial_Process_Definition__c> financialDefs =  [SELECT Id, RC_Account__c, RC_Account__r.RC_SAP_ID__c,RC_Account__r.Name, 
                                                                       RC_TERM_ID__r.RC_Payment_Form__c, RC_TERM_ID__r.RC_Comments__c, RC_KKA__c, RC_KKA_Defination__c,
                                                                       RC_Payment_Term__c, RC_Comments__c, RC_Bordro_Types__c, RC_Average_Due_Date__c, RC_Amount__c, RC_IsExtra__c 
                                                                       FROM RC_Financial_Process_Definition__c  WHERE RecordType.DeveloperName='Connection_Bordro_Entry' AND RC_Approval_Status__c = '1' AND Id IN :bordroList];
            
            List<RC_Financial_Process_Definition__c> BZFinancialDefs = new List<RC_Financial_Process_Definition__c>();
            List<RC_Financial_Process_Definition__c> DTSFinancialDefs = new List<RC_Financial_Process_Definition__c>();
            
            for(RC_Financial_Process_Definition__c fnDef : financialDefs){
                if(fnDef.RC_Bordro_Types__c == 'D'){
                    DTSFinancialDefs.add(fnDef);
                }
                else{
                    BZFinancialDefs.add(fnDef);
                }
            }
            
            List<RC_Bordro__c> newBordroList = new List<RC_Bordro__c>();
            Map<String,RC_Financial_Process_Definition__c> fnBordroNoMap = new Map<String,RC_Financial_Process_Definition__c>();
            List<Id> bordroInsertedIds = new List<Id>();
            Map<String, Id> bordroIdMap = new Map<String,Id>();
            List<RC_Financial_Process_Definition__c> financialList = new List<RC_Financial_Process_Definition__c>();
            
            List<RC_Bordro_Approval_History__c> bordroHistoryList = new List<RC_Bordro_Approval_History__c>();

            if(BZFinancialDefs.size() > 0){    
                for(RC_Financial_Process_Definition__c fnDef : BZFinancialDefs){
                    BZItem conn = new BZItem();
                    conn.GJAHR = fnDef.RC_TERM_ID__r.RC_Payment_Form__c.substring(0,4);    
                    conn.KKBER = fnDef.RC_KKA__c;   
                    conn.KUNNR = fnDef.RC_Account__r.RC_SAP_ID__c;   
                    conn.MONAT = String.valueOf(System.today().month());   
                    conn.ODK = fnDef.RC_Bordro_Types__c;   
                    conn.TUTAR = String.valueOf(fnDef.RC_Amount__c);   
                    conn.VADE = formatDate(String.valueOf(fnDef.RC_Average_Due_Date__c));  
                    conn.ZLSCH = fnDef.RC_TERM_ID__r.RC_Payment_Form__c.substring(4,5);
                    
                    items.add(conn);
                    system.debug('BZItem::: ' + conn );
                }
                IT_INPUT reqWrapperItem = new IT_INPUT();
                reqWrapperItem.item = items;
                req.IT_INPUT = reqWrapperItem;
                system.debug('B>req::: ' + req);
                
                RC_BordroApproveIntegratorParser response = RC_BordroReportIntegrator.bordroApproveInt(req);
                system.debug('response::: ' + response);
                integer index = 0;
                for(RC_BordroApproveIntegratorParser.item itm : response.ET_RETURN.item){
                    RC_Financial_Process_Definition__c fnDef = BZFinancialDefs.get(index);
                    system.debug('BZFnDef::: ' + fnDef);
                    if(itm.RTYPE == 'S'){
                        RC_Bordro__c newBordro = new RC_Bordro__c();
                        newBordro.RC_Average_Due_Date__c = fnDef.RC_Average_Due_Date__c;	
                        newBordro.RC_Bordro_No__c = String.valueOf(itm.BORDRO);
                        newBordro.RC_Bordro_Status_ID__c = '1';
                        newBordro.RC_Bordro_Type__c = fnDef.RC_Bordro_Types__c;
                        newBordro.RC_Connected__c = true;
                        newBordro.CurrencyIsoCode = 'TRY';
                        newBordro.RC_Dealer_Number__c = fnDef.RC_Account__r.RC_SAP_ID__c;
                        newBordro.RC_IsSend__c = false;
                        newBordro.RC_Kkber__c = fnDef.RC_KKA__c;
                        newBordro.RC_Process_Type__c = '03';
                        newBordro.RC_Amount__c = fnDef.RC_Amount__c;
                        
                        newBordroList.add(newBordro);
                        fnBordroNoMap.put(String.valueOf(itm.BORDRO),fnDef);
                        
                    }
                    index++;
                }
            }
            
            
            
            //---------------------
            if(DTSFinancialDefs.size() > 0){    
                for(RC_Financial_Process_Definition__c fnDef : DTSFinancialDefs){
                    
                    DItem conn = new DItem();
                    conn.BORDRO = '';    
                    conn.KKBER = fnDef.RC_KKA__c;   
                    conn.KUNNR = fnDef.RC_Account__r.RC_SAP_ID__c.leftPad(10, '0');   
                    conn.TAKST = '5'; 
                    conn.ORTVD = formatDate(String.valueOf(fnDef.RC_Average_Due_Date__c));
                    conn.WRBTR = String.valueOf(fnDef.RC_Amount__c);   
                    conn.WAERS = 'TRY';
                    
                    Ditems.add(conn);
                    system.debug('DTSitem::: ' + conn );
                }
                CT_BAGLANTI_CEK baglCek = new CT_BAGLANTI_CEK();
                baglCek.item = Ditems;	
                DTSApproveRequestWrapper DTSReq = new DTSApproveRequestWrapper();
                DTSReq.CT_BAGLANTI_CEK = baglCek;
                system.debug('DTSReq::: ' + DTSReq);
                
                RC_BordroDTSAppIntegratorParser DTSResponse = RC_BordroReportIntegrator.bordroDTSApproveInt(DTSReq);
                 system.debug('DTSResponse::: ' + DTSResponse);
                
                integer index2 = 0;
                for(RC_BordroDTSAppIntegratorParser.item itm : DTSResponse.CT_BAGLANTI_CEK.item){
                    RC_Financial_Process_Definition__c fnDef = DTSFinancialDefs.get(index2);
                    system.debug('DTSFnDef::: ' + fnDef);
                    
                    RC_Bordro__c newBordro = new RC_Bordro__c();
                    newBordro.RC_Average_Due_Date__c = fnDef.RC_Average_Due_Date__c;	
                    newBordro.RC_Bordro_No__c = String.valueOf(itm.BORDRO);
                    newBordro.RC_Bordro_Status_ID__c = '1';
                    newBordro.RC_Bordro_Type__c = fnDef.RC_Bordro_Types__c;
                    newBordro.RC_Connected__c = true;
                    newBordro.CurrencyIsoCode = 'TRY';
                    newBordro.RC_Dealer_Number__c = fnDef.RC_Account__r.RC_SAP_ID__c;
                    newBordro.RC_IsSend__c = false;
                    newBordro.RC_Kkber__c = fnDef.RC_KKA__c;
                    newBordro.RC_Process_Type__c = '03';
                    newBordro.RC_Amount__c = fnDef.RC_Amount__c;
                    
                    newBordroList.add(newBordro);
                    fnBordroNoMap.put(String.valueOf(itm.BORDRO),fnDef);
                    index2++;
                }
                
                }
               
            
            //----------------
            
            
            
            system.debug('newBordroList: '+ newBordroList);
            
            List<Database.SaveResult> srList =  Database.insert(newBordroList,true); 
            
            for(Database.SaveResult sr : srList){
                if(sr.isSuccess()){
                    bordroInsertedIds.add(sr.getId());
                }
                else{
                    return 'Bordro Insert Error';
                }
            }  
            
            system.debug('bordroInsertedIds: '+ bordroInsertedIds);
            
            List<RC_Bordro__c> InsertedBordoList = [SELECT Id, RC_Bordro_No__c FROM RC_Bordro__c WHERE Id IN :bordroInsertedIds];
            system.debug('InsertedBordoList: '+ InsertedBordoList);
            
            for(RC_Bordro__c insertedBordo : InsertedBordoList){
                bordroIdMap.put(insertedBordo.RC_Bordro_No__c,insertedBordo.Id);
            }
            system.debug('bordroIdMap:' + bordroIdMap);
            
            for(String bordroNo : bordroIdMap.keySet()){
                RC_Financial_Process_Definition__c eBordro = fnBordroNoMap.get(bordroNo);
                eBordro.RC_Bordro_No__c = bordroIdMap.get(bordroNo);
                financialList.add(eBordro);
            }
            system.debug('financialList:' + financialList);
            
            List<Database.SaveResult> sr2List = Database.update(financialList,true);
            
            for(Database.SaveResult sr2 : sr2List){
                if(sr2.isSuccess()){
                    continue;
                }
                else{
                    return 'Financial Defination Update Error';
                }
            }
        }
        catch(Exception e){
            System.debug('Approve Function Error : ' + e.getMessage());
            return e.getMessage();
        }    
        return 'Success';
    }
    
    // RC_AssociatedChequeController'den copy paste
    @AuraEnabled
    public static List<HistoryWrapper> getHistory(String accId, String bordroTip, String cariDonemId, String kka){
        List<HistoryWrapper> result = new List<HistoryWrapper>();
        
        try{
            List<RC_Financial_Process_Definition__c> baglantiEntryList = getBaglantiBordroGiris(new List<String>{accId}, new List<String>{cariDonemId}, new Set<String>{kka}, new Set<String>{bordroTip});
            
            for(RC_Financial_Process_Definition__c entry : baglantiEntryList){
                
                HistoryWrapper hw = new HistoryWrapper();
                hw.bayiInfo = entry.RC_Account__r.RC_SAP_ID__c + ' - ' + entry.RC_Account__r.Name;
                hw.entryId = entry.Id;
                hw.aciklama = entry.RC_Comments__c;
                hw.bordroTutar = entry.RC_Amount__c;
                hw.ortalamaVade = entry.RC_Average_Due_Date__c;
                
                List<RC_Bordro_Approval_History__c> onayHistoryList = [SELECT Id, RC_Description__c, RC_Bordro_Entry_Id__r.RC_Account__r.RC_SAP_ID__c, RC_Approval_Status__r.RC_Text__c, CreatedBy.Name, CreatedDate FROM RC_Bordro_Approval_History__c WHERE RC_Bordro_Entry_Id__c =: entry.Id ORDER BY CreatedDate DESC];
                System.debug('onayHistoryList : ' + onayHistoryList);
                if(onayHistoryList != null && onayHistoryList.size() > 0){
                    hw.isHistoryExist = true;
                    hw.approvalHistory = onayHistoryList;
                }
                else{                
                    hw.isHistoryExist = false;
                }
                
                result.add(hw);
                
            }
            return result;
        }
        catch(Exception e){
            system.debug('Get History Error: ' + e.getMessage());
            return result;
        }
    }
    
    @AuraEnabled 
    public static String bordroCancel(String bordroId){
        
        try{
            RC_Financial_Process_Definition__c bordro = [SELECT Id, RC_Account__c, RC_Bordro_Status__c, RC_Account__r.RC_SAP_ID__c,RC_Account__r.Name, 
                                                         RC_TERM_ID__r.RC_Payment_Form__c, RC_TERM_ID__r.RC_Comments__c, RC_KKA__c, RC_KKA_Defination__c,
                                                         RC_Payment_Term__c, RC_Comments__c, RC_Bordro_Types__c, RC_Average_Due_Date__c, RC_Amount__c, RC_IsExtra__c, 
                                                         RC_TERM_ID__c, RC_TERM_ID__r.RC_Start_Date__c, RC_TERM_ID__r.RC_End_Date__c 
                                                         FROM RC_Financial_Process_Definition__c  WHERE RecordType.DeveloperName='Connection_Bordro_Entry' AND RC_Approval_Status__c = '1' AND Id=:bordroId];
            
            system.debug('bordro:::' + bordro.RC_TERM_ID__r.RC_Payment_Form__c);
            
            List<RC_Financial_Process_Definition__c> similarBordros = [SELECT RC_Amount__c FROM RC_Financial_Process_Definition__c
                                                                       WHERE RC_KKA__c =:bordro.RC_KKA__c AND  RC_Approval_Status__c = '1' 
                                                                       AND RC_Account__c =: bordro.RC_Account__c AND RecordType.DeveloperName = 'Connection_Bordro_Entry' 
                                                                       AND RC_IsExtra__c =: bordro.RC_IsExtra__c AND RC_TERM_ID__c =: bordro.RC_TERM_ID__c];
            

            system.debug('similar bordro: ' + similarBordros);
            
            //RC_Financial_Process_Definition__c bordroTerm = new RC_Financial_Process_Definition__c();
            
            //RC_Financial_Process_Definition__c bordroTerm = [SELECT Id, RC_Start_Date__c,RC_End_Date__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName='Connection_Period' AND RC_TERM_ID__r.RC_Payment_Form__c =: bordro.RC_TERM_ID__r.RC_Payment_Form__c LIMIT 1];
            
            
            //system.debug('bordroTerm: ' + bordroTerm);
            
            Double totalCurrency = 0.00;
            for(RC_Financial_Process_Definition__c similarBordro : similarBordros){
                totalCurrency += Double.ValueOf(similarBordro.RC_Amount__c);
            }
            Double remainCurreny = totalCurrency - Double.valueOf(bordro.RC_Amount__c);
            
            system.debug('remainCurrency:::' + remainCurreny);
            
            item itemBody = new item();
            itemBody.MANDT= '021';
            itemBody.GJAHR = bordro.RC_TERM_ID__r.RC_Payment_Form__c.substring(0,4); 	// ex: 2021A => 2021
            itemBody.KUNNR = bordro.RC_Account__r.RC_SAP_ID__c;
            itemBody.ZLSCH = bordro.RC_TERM_ID__r.RC_Payment_Form__c.substring(4,5); 		// ex: 2021A => A
            itemBody.KKBER = bordro.RC_KKA__c; 									// ex:0001, 0006
            itemBody.ROW_NO = String.valueOf(bordro.RC_IsExtra__c);
            itemBody.BORDROTIPI = bordro.RC_Bordro_Types__c;
            itemBody.PORTFOY = [SELECT Id, RC_Portfolio_Code__c  FROM RC_Financial_Process_Definition__c WHERE 	RC_Bordro_Types__c =:bordro.RC_Bordro_Types__c and RecordType.DeveloperName = 'Bordro_Types'].RC_Portfolio_Code__c;
            itemBody.SMCTR = '0';
            itemBody.CVDTE = formatDate(String.valueOf(bordro.RC_Average_Due_Date__c));
            
            system.debug('itemBody::: ' + itemBody);
            
            item sozlesmeBody = new item();
            sozlesmeBody.MANDT= '021';
            sozlesmeBody.GJAHR = bordro.RC_TERM_ID__r.RC_Payment_Form__c.substring(0,4); 	// ex: 2021A => 2021
            sozlesmeBody.KUNNR = bordro.RC_Account__r.RC_SAP_ID__c;
            sozlesmeBody.ZLSCH = bordro.RC_TERM_ID__r.RC_Payment_Form__c.substring(4,5); 		// ex: 2021A => A
            sozlesmeBody.KKBER = bordro.RC_KKA__c; 									// ex:0001, 0006
            sozlesmeBody.ROW_NO = String.valueOf(bordro.RC_IsExtra__c);
            sozlesmeBody.SMCTR	= String.valueOf(remainCurreny);
            sozlesmeBody.CVDTE = formatDate(String.valueOf(bordro.RC_Average_Due_Date__c));
            sozlesmeBody.START_DATE = formatDate(String.valueOf(bordro.RC_TERM_ID__r.RC_Start_Date__c));
            sozlesmeBody.END_DATE = formatDate(String.valueOf(bordro.RC_TERM_ID__r.RC_End_Date__c));
            sozlesmeBody.TIMESTAMP = '0';
            sozlesmeBody.USERNAME = '';
            sozlesmeBody.VARIANT = '';
            sozlesmeBody.ZTERM =  [SELECT Id, RC_Payment_Term__c  FROM RC_Financial_Process_Definition__c  WHERE Id =:bordro.RC_Payment_Term__c].RC_Payment_Term__c;
            sozlesmeBody.GJAHR_ZLSCH = bordro.RC_TERM_ID__r.RC_Payment_Form__c;
            sozlesmeBody.LAST_DATE = '';
            sozlesmeBody.LAST_TIME = '';
            
            system.debug('sozlesmeBody::: ' + sozlesmeBody);
            
            IT_ODEME_PLAN odemePlan = new IT_ODEME_PLAN();
            odemePlan.item = itemBody;
            
            IT_SOZLESME sozlesme = new IT_SOZLESME();
            sozlesme.item = sozlesmeBody;
            
            cancelRequestWrapper req = new cancelRequestWrapper();
            req.IT_ODEME_PLAN = odemePlan;
            req.IT_SOZLESME = sozlesme;
            
            RC_BordroCancelIntegratorParser response = RC_BordroReportIntegrator.bordroCancelInt(req);
            system.debug('response cancel:: ' + response);
            
            if(response.EV_FLAG == 'S'){
                try{
                    bordro.RC_Bordro_Status__c = 'Red';
                    bordro.RC_Approval_Status__c = '0';
                    update bordro;
                    
                    //History kayıt
                    RC_Bordro_Approval_History__c bordroHist = new RC_Bordro_Approval_History__c();
                    bordroHist.RC_Description__c =  UserInfo.getName() + ' tarafından iptal edildi.';
                    bordroHist.RC_Bordro_Entry_Id__c = bordro.Id;
                    RC_Financial_Process_Definition__c appStatus = [SELECT Id, RC_SAP_ID__c, RC_Text__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Approval_Status' AND RC_SAP_ID__c = '0'];
                    bordroHist.RC_Approval_Status__c = appStatus.id;
                    insert bordroHist;
                    
                    return 'Success';
                }
                catch(DmlException e) {
                    System.debug('Cancel Update Error::: ' + e.getMessage());
                    return 'DML Update Error';
                }            
            }
            else{
                return 'Service Error';
            }
        }
        catch(Exception e){
            return e.getMessage();
        }
        
    }
    
    private static string formatDate(String dt){
        string month = dt.substring(5, 7);
        string day = dt.substring(8, 10);
        string year = dt.substring(0, 4);
        //string res = year+month+day;
        return year+month+day;        
    }
    
    
    private static List<RC_Financial_Process_Definition__c> changeBordroList(List<RC_Financial_Process_Definition__c> bordroList){
        List<String> paymentTermIds = new List<String>();
        for (RC_Financial_Process_Definition__c bordro : bordroList){
            if(!paymentTermIds.contains(bordro.RC_Payment_Term__c)){
                paymentTermIds.add(bordro.RC_Payment_Term__c);
            }
        }
        
        List<RC_Financial_Process_Definition__c> bordroPaymentTermList = [SELECT Id, RC_Payment_Term__c  FROM RC_Financial_Process_Definition__c  WHERE Id IN :paymentTermIds];
        
        system.debug(bordroPaymentTermList);
        
        for (RC_Financial_Process_Definition__c bordro : bordroList){
            for(RC_Financial_Process_Definition__c paymentTerm : bordroPaymentTermList ){
                if(bordro.RC_Payment_Term__c == String.valueOf(paymentTerm.Id)){
                    bordro.RC_Payment_Term__c = paymentTerm.RC_Payment_Term__c;
                }
            }
        }   
        return bordroList;
    }
    
    // RC_AssociatedChequeController'den copy paste
    private static List<RC_Financial_Process_Definition__c> getBaglantiBordroGiris(List<String> bayiIDList, List<String> termIDList, Set<String> krediKontrolIDList, Set<String> bordroTipIDList){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        system.debug('krediKontrolIDList : ' + krediKontrolIDList);
        String query = 'SELECT Id, RC_Start_Date__c, RC_Account__r.RC_SAP_ID__c,RC_Account__r.Name, RC_Bordro_Status__c, RC_Approval_Status__c, RC_Comments__c, RC_Amount__c, RC_Average_Due_Date__c, RC_Account__c, RC_Bordro_Types__c, RC_Payment_Term__c, RC_Term_ID__c, RC_KKA__c, RC_KKA_Defination__c, RC_Bordro_No__c  FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = \'Connection_Bordro_Entry\'';
        
        if(bayiIDList != null && bayiIDList.size() > 0){
            query += ' AND RC_Account__c IN (';
            for(String id : bayiIDList){
                query += '\'' + id + '\',';
            }
            query = query.removeEnd(',') + ')';
        }
        
        if(termIDList != null && termIDList.size() > 0){
            query += ' AND RC_Term_ID__c IN (';
            for(String id : termIDList){
                query += '\'' + id + '\',';
            }
            query = query.removeEnd(',') + ')';
        }
        
        if(krediKontrolIDList != null && krediKontrolIDList.size() > 0){
            query += ' AND RC_KKA_Defination__c IN (';
            for(String id : krediKontrolIDList){
                query += '\'' + id + '\',';
            }
            query = query.removeEnd(',') + ')';
        }
        
        if(bordroTipIDList != null && bordroTipIDList.size() > 0){
            query += ' AND RC_Bordro_Types__c IN (';
            for(String id : bordroTipIDList){
                query += '\'' + id + '\',';
            }
            query = query.removeEnd(',') + ') ORDER BY CreatedDate';
        }
        System.debug(query);
        result = Database.query(query);
        
        return result;
    }
    
 
    
}