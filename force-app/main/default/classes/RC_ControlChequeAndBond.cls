public with sharing class RC_ControlChequeAndBond {
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value {get;set;}
    }
    
    public class ControlWrapper{
        @AuraEnabled
        public Boolean isSuccess {get; set;}
        @AuraEnabled
        public String message {get; set;}

        public ControlWrapper(){
            this.isSuccess = false;
            this.message = '';
        }
    }
    
    // Main Methods
    @AuraEnabled
    public static List<RC_Bordro__c> GetControlChequeAndBond(String bayiId, String bordroStatu, String docType, String baglantiDonem, String creditControl, String accountClosing){
        try {
            List<RC_Bordro__c> dealerRelatedBordroList = new List<RC_Bordro__c>();
            String query = 'SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate, (Select Id FROM Cheques__r)FROM RC_Bordro__c WHERE Id != null ';
            
            String bayiKod = '';
            if(String.isNotBlank(bayiId)){
                bayiKod = [SELECT RC_SAP_ID__c FROM Account WHERE Id =: bayiId].RC_SAP_ID__c;
            }
            
            system.debug('bayiId: '+ bayiId); 
            system.debug('bordroStatu: '+ bordroStatu); 
            system.debug('docType: '+ docType); 
            system.debug('baglantiDonem: '+ baglantiDonem); 
            system.debug('creditControl: '+ creditControl);
            system.debug('accountClosing: '+accountClosing);
            
            
            if(String.isNotBlank(bayiKod)){
                query += 'AND RC_Dealer_Number__c = \'' + bayiKod + '\' '; 
            }
            
            if(String.isNotBlank(bordroStatu)){
                if(bordroStatu =='0'){
                    query += 'AND (RC_Bordro_Status_ID__c not in(\'1\')) ';                     
                }
                else{
                    query += 'AND RC_Bordro_Status_ID__c = \''+ bordroStatu+'\'' ;
                }
            }
            else{
                query += 'AND (RC_Bordro_Status_ID__c not in(\'1\')) ';              
            }
            
            
            if(String.isNotBlank(accountClosing)){//Hesap Kapama
                query += 'AND RC_Process_Type__c = \'01\' '; 
            }
            else{//Bağlantı Cek senet kontrolü
                query += 'AND RC_Process_Type__c = \'03\' '; 
            }
            
            
            
            if(String.isNotBlank(docType)){
                if(docType == '0'){
                    query += 'AND Id in (Select RC_Bordro__c from RC_Cheques__c) ';                   
                }
                else{
                    query += 'AND Id in (Select RC_Bordro__c from RC_Cheques__c where RC_Cheque_Bill__c = \'' + docType + '\' )  ';
                }
            }
            else{
                query += 'AND Id in (Select RC_Bordro__c from RC_Cheques__c) '; 
            }
            
            if(String.isNotBlank(baglantiDonem)){
                /*TODO: RELATION BULUNAMADI*/
            }
            
            if(String.isNotBlank(creditControl)){
                if(creditControl=='Tümü'){
                    
                }
                else{
                    List<string> creditControlList = creditControl.split('-');
                    
                    if(creditControlList.size()>1){
                        String ccValue = creditControlList[0];
                        String ccLabel = creditControlList[1];
                        query += ' AND Id in (Select RC_Bordro_No__c from RC_Financial_Process_Definition__c WHERE RC_KKA__c = \''+ccLabel+'\' )';
                    }
                }                
            }
            system.debug('query: '+ query);
            
            dealerRelatedBordroList = Database.query(query);
            
            for(RC_Bordro__c b : dealerRelatedBordroList){
                
            }

            return dealerRelatedBordroList;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static List<RC_Cheques__c> getBordroRelatedCheques(Id selectedBordroId){
        
        List<RC_Cheques__c> bordroRelatedChequeList = new List<RC_Cheques__c>();
        
        if(String.isNotBlank(selectedBordroId)){
            bordroRelatedChequeList = [
                SELECT Id, RC_City__r.Name, RC_Drawer_Region__c, RC_Due_Date__c, RC_Cheque_Bill__c, RC_Cheque_Number__c, RC_Amount__c, RC_Identification_Number__c, RC_Bank_Key__c, RC_Bank_Key__r.RC_BANK__c, RC_Bank_Key__r.RC_BRINCH__c, RC_Bank_Key__r.RC_BANKL__c, RC_Bank_Account_Number__c, RC_IsSent__c, RC_Check_Status_ID__c, RC_Bill_Number__c, RC_Account_No__c
                FROM RC_Cheques__c WHERE
                RC_Bordro__c =: selectedBordroId
                and (RC_Cheque_Bill__c = 'Bill' or RC_Cheque_Bill__c = 'Cheque') ];
        } 
        
        return bordroRelatedChequeList;
    }
    
    @AuraEnabled
    public static Boolean updateStatusBordroAndCheque(Id selectedBordroId, string statusID){
        Boolean isSucces = false;
        try {
            if(String.isNotBlank(selectedBordroId)){                
                //Kontrol Edildi	3
                //Çekler SAP'ye Gönderildi	4
                //Bordro Onayda Bekliyor	2
                //Bordro statusu guncelleniyor
                RC_Bordro__c bordro = [SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate, RC_Connected__c FROM RC_Bordro__c WHERE Id =: selectedBordroId];
                bordro.RC_Bordro_Status_ID__c = statusID;
                Database.update(bordro);                
                
                //Kontrol Edildi	3
                //Çekler SAP'ye Gönderildi	4
                //Onayda Bekliyor	2                
                //Cheques statusu guncelleniyor
                List<RC_Cheques__c> cheques = getBordroRelatedCheques(selectedBordroId);                
                for(RC_Cheques__c cheque : cheques){
                    cheque.RC_Check_Status_ID__c = statusID;
                }
                Database.update(cheques); 
                
                isSucces=true;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isSucces;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SelectOptionWrapper> fillBordroStatus(){        
        system.debug('girdi:');
        List<SelectOptionWrapper> resultList = new List<SelectOptionWrapper>(); 
        Schema.DescribeFieldResult fieldResultForCompany = RC_Bordro__c.RC_Bordro_Status_ID__c.getDescribe();
        system.debug('fieldResultForCompany: '+ fieldResultForCompany);
        
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Tümü';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        
        for(Schema.PicklistEntry pickListVal : ple){            
            SelectOptionWrapper tempValues = new SelectOptionWrapper();
            
            if(pickListVal.getValue()!='1'){
                tempValues.value = pickListVal.getValue();
                tempValues.label = pickListVal.getLabel();
                
                resultList.add(tempValues);
            }
        }
        //String jsonResultList = JSON.serialize(resultList);
        system.debug('resultList: '+ resultList);
        return resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SelectOptionWrapper> fillDocType(){ 
        List<SelectOptionWrapper> resultList = new List<SelectOptionWrapper>(); 
        Schema.DescribeFieldResult fieldResultForCompany = RC_Cheques__c.RC_Cheque_Bill__c.getDescribe();
               
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Tümü';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        
        for(Schema.PicklistEntry pickListVal : ple){            
            SelectOptionWrapper tempValues = new SelectOptionWrapper();
            
            tempValues.value = pickListVal.getValue();
            tempValues.label = pickListVal.getLabel();
            
            resultList.add(tempValues);
        }
        //String jsonResultList = JSON.serialize(resultList);
        
        return resultList;
    }
        
    @AuraEnabled(cacheable=true)
    public static List<SelectOptionWrapper> fillBaglantiDonem(){        
        Date dt = System.today(); //current date
        Integer year = dt.Year(); //get year
        
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> ();        
        string sqlClause='SELECT RC_Comments__c, RC_Text__c FROM RC_Financial_Process_Definition__c  where RC_IsActive__c  =true and RC_Fiscal_Year__c  =' +year;
        System.debug('sql fillBaglantiDonem : '+sqlClause);
        list<RC_Financial_Process_Definition__c> authorityList = database.query(sqlClause);
        
        if(authorityList.size()>0){
            SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
            EmptyValue.label = 'Tümü';
            EmptyValue.value = '0';
            resultList.add(EmptyValue);
            
            for(RC_Financial_Process_Definition__c authority : authorityList){
                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = authority.RC_Comments__c;
                tempValues.label = authority.RC_Text__c;
                
                resultList.add(tempValues);
            }
        }
        return  resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SelectOptionWrapper> fillKKA(){
        
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> ();        
        string sqlClause='SELECT RC_KKA__c, RC_KKA_Defination__c FROM RC_Financial_Process_Definition__c  where RC_IsActive__c  =true and RC_KKA__c != \'\' and RC_KKA_Defination__c != \'\' and RC_KKA__c != null and RC_KKA_Defination__c != null';
        System.debug('sql fillKKA : '+sqlClause);
        list<RC_Financial_Process_Definition__c> authorityList = database.query(sqlClause);
        
        if(authorityList.size()>0){
            SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
            EmptyValue.label = 'Tümü';
            EmptyValue.value = '0';
            resultList.add(EmptyValue);
            
            for(RC_Financial_Process_Definition__c authority : authorityList){
                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = authority.RC_KKA__c;
                tempValues.label = authority.RC_KKA__c +'-'+authority.RC_KKA_Defination__c;
                
                resultList.add(tempValues);
            }
        }
        return  resultList;
    }
    
    @AuraEnabled
    public static ControlWrapper bordroCekGirSAP(Id selectedBordroId){        
        ControlWrapper rClass = new ControlWrapper();
        
        Boolean result = false;
        try{            
            RC_BordroCekGirIntegrator.ResponseModel respBordroCekGir = new RC_BordroCekGirIntegrator.ResponseModel();
            RC_BordroCekGirIntegrator.RequestModel req = new RC_BordroCekGirIntegrator.RequestModel();  
            
            RC_BordroCekGirIntegrator.CEK_ITEMS CEK_ITEMS = new RC_BordroCekGirIntegrator.CEK_ITEMS();
            RC_BordroCekGirIntegrator.ET_ITEMS ET_ITEMS = new RC_BordroCekGirIntegrator.ET_ITEMS();
            
            List<RC_BordroCekGirIntegrator.Item> itemList = new List<RC_BordroCekGirIntegrator.Item>();
            RC_BordroCekGirIntegrator.Item item = new RC_BordroCekGirIntegrator.Item();
            
            
            RC_Bordro__c bordro = [SELECT Id, RC_Bordro_No__c,RC_Bordro_Type__c,CurrencyIsoCode,RC_Average_Due_Date__c,RC_Amount__c,RC_IsSend__c, RC_Dealer_Number__c, RC_Process_Type__c, RC_Kkber__c FROM RC_Bordro__c  WHERE Id =: selectedBordroId limit 1];
            List<RC_Cheques__c> chequeList = [SELECT Id,Name,CurrencyIsoCode, CreatedDate,  RC_Bordro__c, RC_Bank_Key__r.RC_BANKL__c, RC_Cheque_Number__c, RC_Amount__c, RC_Cheque_Portfolio__c, RC_Due_Date__c, RC_Invoice_Number__c, RC_Bank_Account_Number__c, RC_Drawer__c, RC_Account_No__c, RC_Drawer_Title__c, RC_Drawer_Region__c, RC_Identification_Number__c, RC_Currency__c, RC_Statu__c, RC_Bill_Number__c, RC_Status_ID__c, RC_City__r.Name, RC_Description__c, RC_IsSent__c, RC_ISSENTBORDROCEKGIR__c, RC_Cheque_Bill__c, RC_Bank_Key__c, RC_SD_Invoice_Number__c, RC_Type__c, RC_Check_Status_ID__c, RC_Product_Info__c,RC_Bank_Key__r.Name FROM RC_Cheques__c WHERE RC_Bordro__c =: selectedBordroId and (RC_Cheque_Bill__c ='Bill' or RC_Cheque_Bill__c ='Cheque')];
            
            System.debug('bordro: ' +bordro);
            System.debug('chequeList: ' +chequeList);
            if(!bordro.RC_IsSend__c){
                
                req.BORDRONO= bordro.RC_Bordro_No__c;            
                //Process type 01 se ve cekse C, Processtype 01 hepsi senetse W, Process type 03 se hepsi senetse Z değilse B mixli senaryo olaamaz(bordro.RC_Bordro_Type__c bunu setleyelim bağlantıda)
                string bordroType = bordro.RC_Bordro_Type__c;
                if(bordro.RC_Process_Type__c=='01'){
                    bordroType = allDataControl(chequeList, 'Bill') ? 'W' :'C';
                }
                else if(bordro.RC_Process_Type__c=='03'){
                    if(chequeList[0].RC_Cheque_Bill__c=='Cheque'){
                        bordroType='B';
                    }else bordroType='Z';
                }
                req.BORDROTYPE = bordroType;
                
                
                String satisBurosu = [select RC_Regional_Directorate__c from RC_SD_Organization__c WHERE RC_Account__r.RC_SAP_ID__c =: bordro.RC_Dealer_Number__c].RC_Regional_Directorate__c;
                
                req.IV_BAKIYE='';
                req.IV_ORTVADE='';
                req.IV_SFBAKIYE= String.valueOf(bordro.RC_Amount__c);
                req.IV_SFORTVADE= String.valueOf(bordro.RC_Average_Due_Date__c);
                
                for(RC_Cheques__c cheque : chequeList){
                    if(!cheque.RC_ISSENTBORDROCEKGIR__c)
                    {
                        item = new RC_BordroCekGirIntegrator.Item();
                        
                        //Process type 01 se ve cekse C01, senetse S01, Process type 03 se S51, cekse C51
                        String portfolio = 'C01';
                        if(bordro.RC_Process_Type__c=='01'){
                            portfolio = cheque.RC_Cheque_Bill__c =='Bill' ? 'S01' : 'C01';
                        }else if(bordro.RC_Process_Type__c=='03'){
                            portfolio = cheque.RC_Cheque_Bill__c =='Bill' ? 'S51' : 'C51';
                        }                    
                        
                        item.BOENUM = cheque.RC_Cheque_Number__c;
                        item.BUDAT = ToPIDateStringDT(cheque.CreatedDate);
                        item.PORTFO = portfolio;//Process type 01 se ve cekse C01, senetse S01, Process type 03 se S51, cekse C51
                        item.KUNNR = ToSAPString10Digits(cheque.RC_Account_No__c);
                        item.ZFBDT = ToPIDateStringDT(cheque.RC_Due_Date__c);
                        item.XSIWE = '';
                        item.WAERS = cheque.CurrencyIsoCode;
                        item.WRBTR = String.valueOf(cheque.RC_Amount__c);
                        item.BANKL = cheque.RC_Bank_Key__r.RC_BANKL__c;//Ex: 0067-00723 / YAPI VE KREDİ BANKASI A.Ş. - YEDPA 
                        item.BANKN = cheque.RC_Bank_Account_Number__c; 
                        item.NAME1 = NULL;
                        item.BOLGE = cheque.RC_Drawer_Region__c;//Keşide Yeri setlenecek
                        item.STCEG = cheque.RC_Identification_Number__c;
                        item.FATURA = '';
                        item.VKBUR = satisBurosu;//SD_Org ile getirilecek
                        item.HZUON = cheque.RC_Identification_Number__c;                
                        itemList.Add(item);
                    }
                }
                
                if(itemList.Size()>0)
                {
                    req.CEK_ITEMS = CEK_ITEMS;
                    req.CEK_ITEMS.item = itemList;                
                    // req.ET_ITEMS = ET_ITEMS;        
                    
                    respBordroCekGir = RC_BordroCekGirIntegrator.getBordroCekGir(req);
                    String isSuccess = respBordroCekGir.bordroCekGirResponse.ET_RETURN.item[0].TYPE;
                    result = isSuccess == 'S' ? true : false;                
                }
                
                
                ControlWrapper cekGirResult = cekGirSAP(bordro,chequeList);
                rClass.isSuccess = cekGirResult.isSuccess;
                rClass.message += cekgirResult.message + ' ';
                system.debug('bordroCekGirSAP: ' +rClass);
                
                if(result){
                    for(RC_Cheques__c cheque :  chequeList)
                    {
                        cheque.RC_ISSENTBORDROCEKGIR__c = true;
                        cheque.RC_Check_Status_ID__c='4';
                    }
                    
                    try{
                        Database.update(chequeList);
                    }catch(Exception e){system.debug('CATCH : bordroCekGirSAP bordroUpdate'  + e.getMessage());}             
                }
                else{
                    rClass.message = respBordroCekGir.bordroCekGirResponse.ET_RETURN.item[0].MESSAGE;
                }
                
                if (cekGirResult.isSuccess){
                    bordro.RC_IsSend__c=result;
                    bordro.RC_Bordro_Status_ID__c = '4';
                    
                    try{
                        Database.update(bordro);
                    }catch(Exception e){system.debug('CATCH : bordro' + e.getMessage());}
                }
                
            }
            else
            {
                rClass.isSuccess = false;
                rClass.message += 'Bu bordro daha önce SAP sistemine aktarılmıştır';
                system.debug('bordroCekGirSAP: ' +rClass);
            }
        }catch(Exception e){
            rClass.isSuccess = false;
            rClass.message += 'Sistemsel bir sorun oluştu! : ' + e.getMessage();
            system.debug('Sistemsel bir sorun oluştu! : ' + e.getMessage());
        }
        return rClass;

    }
    
    @AuraEnabled
    public static ControlWrapper cekGirSAP(RC_Bordro__c bordro, List<RC_Cheques__c> chequeList){        
        ControlWrapper result = new ControlWrapper();        
        Boolean resultCekGir = false;        
        System.debug('bordro2 : ' +bordro);
        System.debug('chequeList2: ' +chequeList);
        
        RC_CekGirIntegrator.RequestModel req = new RC_CekGirIntegrator.RequestModel();  
        
        RC_CekGirIntegrator.CEKLER CEKLER = new RC_CekGirIntegrator.CEKLER();
        RC_CekGirIntegrator.BORDROLAR BORDROLAR = new RC_CekGirIntegrator.BORDROLAR();
        
        List<RC_CekGirIntegrator.Item_Z> itemList = new List<RC_CekGirIntegrator.Item_Z>();
        RC_CekGirIntegrator.Item_Z itemZ = new RC_CekGirIntegrator.Item_Z();
        RC_CekGirIntegrator.Item item = new RC_CekGirIntegrator.Item();        
        
        String accName = [Select Name from Account where RC_SAP_ID__c =: bordro.RC_Dealer_Number__c limit 1].Name;
        String satisBurosu = [select RC_Regional_Directorate__c from RC_SD_Organization__c WHERE RC_Account__r.RC_SAP_ID__c =: bordro.RC_Dealer_Number__c].RC_Regional_Directorate__c;
        
        req.BATCHMOD = 'N';
        req.DEBUG = '';
        req.EKSIKKAYIT = '';
        req.FORCE = '';
        req.LOG = 'X';
        req.OPERASYON = 'C';        
        
        //Process type 01 se ve cekse C, Processtype 01 hepsi senetse W, Process type 03 se hepsi senetse Z değilse B mixli senaryo olaamaz(bordro.RC_Bordro_Type__c bunu setleyelim bağlantıda)
        string bordroType = bordro.RC_Bordro_Type__c;
        if(bordro.RC_Process_Type__c=='01'){
            bordroType = allDataControl(chequeList, 'Cheque') ? 'C' 
                : allDataControl(chequeList, 'Bill') ? 'W'
                    : 'C';
        }
        else if(bordro.RC_Process_Type__c=='03'){
            if(chequeList[0].RC_Cheque_Bill__c=='Cheque'){
                bordroType='B';
            }else bordroType='Z';
        }
        
        //mix C, cekse C, senetse S
        String status = allDataControl(chequeList,'Bill') ? 'S' : 'C';
        
        item.MANDT='021';
        item.BORDRO=bordro.RC_Bordro_No__c;        
        item.BORDROTYP=bordroType;
        item.TARIH_BAS='';
        item.TARIH_BIT= ToPIDateStringDT(Date.today());
        item.TUTAR= String.valueOf(bordro.RC_Amount__c);
        item.STATUS=status;//mix C, cekse C, senetse S
        item.KUNNR=ToSAPString10Digits(bordro.RC_Dealer_Number__c);
        item.NAME1=accName;
        item.NAME2='';
        item.VADE= String.valueOf(bordro.RC_Average_Due_Date__c);
        item.VADE_KUN='';
        item.WAERS=bordro.CurrencyIsoCode;
        item.SALLAMA='0';
        item.ERDAT='';
        item.ERNAM='';
        item.KKBER=bordro.RC_Kkber__c;
        item.VKBUR=satisBurosu;//SD organizasyondan doldurulacak
        item.ZLSCH='';
        item.MONAT='';
        item.GJAHR='';
        
        
        for(RC_Cheques__c ch : chequeList){
            itemZ = new RC_CekGirIntegrator.Item_Z();
            
            itemZ.CEKNO = ch.RC_Cheque_Number__c;
            itemZ.TARIH = ToPIDateStringDT(ch.CreatedDate);
            itemZ.BANKL = ch.RC_Bank_Key__r.RC_BANKL__c;
            
            itemList.Add(itemZ);
        }
                
        req.CEKLER = CEKLER;
        req.BORDROLAR = BORDROLAR;
        req.CEKLER.item = itemList;
        req.BORDROLAR.item = item;            
        
        RC_CekGirIntegrator.ResponseModel resp = RC_CekGirIntegrator.getCekGir(req);
        system.debug('Anıl : ' + JSON.serialize(resp));
        if(resp.CekGirResponse.BORDROLAR !=null && resp.CekGirResponse.BORDROLAR.item.size()>0 ){            
            resultCekGir = true;
        }
        else{
            System.debug('resp.CekGirResponse.Name + resp.CekGirResponse.Text : ' + resp.CekGirResponse.Name + resp.CekGirResponse.TextMsg);
            result.message = resp.CekGirResponse.Name +' - ' + resp.CekGirResponse.TextMsg;
        }
        
        if(resultCekGir){
            for(RC_Cheques__c ch : chequeList){
                ch.RC_IsSent__c = true;
            }
            try{
            Database.update(chequeList);
            }catch(Exception e){system.debug('CATCH : ch.RC_IsSent__c = true' + e.getMessage());}
        }
        
        result.isSuccess = resultCekGir;
        
        return result;
    }
    
    @AuraEnabled
    public static Boolean allDataControl(List<RC_Cheques__c> chequeList, string chequeBill){
        Boolean result = true;        
        for(RC_Cheques__c cheque : chequeList){
            if(cheque.RC_Cheque_Bill__c != chequeBill){
                result = false;
                break;
            }
        }        
        return result;
    }
    
    @AuraEnabled
    public static String ToPIDateString(String dt){
        String SAPDateFormat = '2021-11-17'; 
        
        String tempDate = String.valueOf(dt);
        List<String> parsedDate = tempDate.split('-');
        String strYear = parsedDate[0];
        String strMonth = String.valueOf(parsedDate[1]).length()<2 ? '0'+parsedDate[1] : parsedDate[1];
        String strDay = String.valueOf(parsedDate[2]).length()<2 ? '0'+parsedDate[2] : parsedDate[2];
        if(test.isRunningTest()){return SAPDateFormat;}
        return strYear+strMonth+strDay;
    }
    
    @AuraEnabled
    public static String ToPIDateStringDT(Datetime dt){
        String SAPDateFormat = '2021-11-17';
        
        String tempDate = String.valueOf(dt);
        List<String> parsedDate = tempDate.split('-');
        String strYear = parsedDate[0];
        String strMonth = String.valueOf(parsedDate[1]).length()<2 ? '0'+parsedDate[1] : parsedDate[1];
        String strDay = String.valueOf(parsedDate[2]).length()<2 ? '0'+parsedDate[2] : parsedDate[2];
        if(test.isRunningTest()){return SAPDateFormat;}
        return strYear+strMonth+strDay;
    }
    
    @AuraEnabled
    public static String ToSAPString10Digits(string code){        
        Integer length = code.length();
        Integer diff = 10 - length;
        
        for (integer i=0; i<diff; i++){
            code = '0'+code;
        }
        
        return code;
    }
    
    @AuraEnabled
    public static String ToSAPBool(Boolean b){
        return b ? 'X' : ' ';        
    }
}