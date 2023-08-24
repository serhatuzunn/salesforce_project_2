public class RC_DealerBonusCalculatorController {
    
    //Constructor with no arguments
    public RC_DealerBonusCalculatorController() 
    {        
    }
    
    //Bayiden sevk prim ekranındaki DataTable'a setlenen header kaydı icin olusturuldu.
    public class DealerShipmentBonusDT{
        @AuraEnabled
        public string PERIOD{get;set;} 
        @AuraEnabled
        public string ORTGUN{get;set;} 
        @AuraEnabled
        public Integer TOTALORDERCOUNT{get;set;} 
        @AuraEnabled
        public Decimal TOTALBONUSWITHOUTTAX{get;set;} 
        @AuraEnabled
        public Decimal KDV{get;set;} 
        @AuraEnabled
        public Decimal TOTALBONUS{get;set;} 
        @AuraEnabled
        public string INVOICENO{get;set;} 
        @AuraEnabled
        public string DESCRIPTION{get;set;}
        @AuraEnabled
        public Boolean EDITABLE{get;set;} 
    }
    
    public class initWrapper{
        @AuraEnabled
        public DealerShipmentBonusDT headerData{get;set;} 
        @AuraEnabled
        public List<RC_DealerBonusShipmentJsonParser.Item> item{get;set;}        
    }
    
    @AuraEnabled
    public static String getDealerBonusShipment(string startDate, string endDate){
        initWrapper wrp = new initWrapper();
        List<initWrapper> resultData = new List<initWrapper>();
        
        RC_GetDealerBonusShipmentIntegrator.requestModel req  = new RC_GetDealerBonusShipmentIntegrator.requestModel();
        RC_GetDealerBonusShipmentIntegrator.responseModel resp = new RC_GetDealerBonusShipmentIntegrator.responseModel();
        
        
        Account relatedAccount = RC_UtilitiesClass.getUserRelatedAccount(); 
        String userId = '';
        if(test.isRunningTest()){
            userId ='20300066';
        }else{
           userId = relatedAccount.RC_SAP_ID__c;    
        }
        
        
         
        String piStartDate = ToPIDateString(startDate);
        String piEndDate = ToPIDateString(endDate);
        userId = ToSAPString10Digits(userId);
        
        req.IV_BEGIN_DATE = piStartDate;
        req.IV_END_DATE = piEndDate;
        req.IV_KUNNR = userId; 
        
        System.debug('startDate: '+piStartDate);   
        System.debug('endDate: '+piEndDate);        
        System.debug('userId : '+userId);
        
        resp = RC_GetDealerBonusShipmentIntegrator.getDealerBonusShipment(req);
        if(resp != null){
            resultData = GetListOfResult(resp.ET_RETURN,startDate,endDate, relatedAccount.Id);  
        }
        
        
        return JSON.serialize(resultData);        
    }
    //Bu method servisten dönen item objesini dönem bazında item listi ayırıp göndermesi icin yapıldı.
    public static List<initWrapper> GetListOfResult(RC_DealerBonusShipmentJsonParser.ET_RETURN data, String startDate, String endDate, Id relatedAccountId){
        
        initWrapper resultData = new initWrapper();
        List<initWrapper> resultDataList = new List<initWrapper>();
        List<RC_DealerBonusShipmentJsonParser.Item> itemDataList = new List<RC_DealerBonusShipmentJsonParser.Item>();
        
        Date dtFirst = CDate(startDate);  Date dtSecond = CDate(endDate);        
        
        Integer firstYear = dtFirst.year();    Integer secondYear = dtSecond.year();
        Integer firstMonth = dtFirst.month();  Integer secondMonth = dtSecond.month();
        if(data.item.size()>0){
            if(firstYear == secondYear){//Filtre aynı yıllar icinde secilmisse, yıl sonlarında case değişecektir.
                Integer differenceMonths = secondMonth - firstMonth;
                for (Integer i=0; i <differenceMonths + 1; i++) {
                    
                    itemDataList = new List<RC_DealerBonusShipmentJsonParser.Item>();
                    resultData = new initWrapper();
                    
                    Date filteredDate =  dtFirst.addMonths(i);
                    String monthName = GetMonthName(filteredDate);
                    String period = String.format('{0} - {1}',new List<String>{monthName, String.valueOf(firstYear)} );//Dt'da filtreli ay ve yıl bilgisi
                    
                    //initWrapper classının List item objesi dolduruluyor.
                    for (RC_DealerBonusShipmentJsonParser.Item item : data.item) {
                        
                        Date zDate = CDate(item.ERDAT);
                        if(zDate.month() == filteredDate.month() && zDate.year() == filteredDate.year()){
                            itemDataList.Add(item);                            
                        }
                    }
                    
                    resultData.item = itemDataList;
                    
                    DealerShipmentBonusDT headerValues = getDealerShipmentBonusDT(period, itemDataList, firstYear, filteredDate.month(), relatedAccountId);
                    resultData.headerData = headerValues;
                    
                    resultDataList.Add(resultData);                    
                }
            }
        }
        
        Integer j = 0;
        while (j < resultDataList.size())
        {
            if(resultDataList.get(j).item.size() < 1)
            {
                resultDataList.remove(j);
            }else
            {
                j++;
            }
        }
        
        
        System.debug('resultDataList : '+JSON.serialize(resultDataList));
        return resultDataList;
    }
    //Bu method getDealerBonusShipment fonksiyonunda result değerini doldurur.
    @AuraEnabled
    public static DealerShipmentBonusDT getDealerShipmentBonusDT(String period, List<RC_DealerBonusShipmentJsonParser.Item> incomingData, Integer currYear, Integer currMonth, Id relatedAccountId){
        
        String bonusType = 'shipmentBonus';
        DealerShipmentBonusDT wrapper = new DealerShipmentBonusDT();
        
        System.debug('incomingData : '+JSON.serialize(incomingData));
        
        if(incomingData.size()>0){
            String q = 
                'SELECT Id, Invoice_Number__c, Description__c FROM Prim_Invoices__c Where RC_Year__c = \''+currYear+'\' and RC_Month__c = \''+currMonth+'\' and Account__c =\''+relatedAccountId+'\' and Type__c =\''+bonusType+'\' ';
            System.debug('q : '+q);
            List<Prim_Invoices__c> prim = Database.query(q);                    
            System.debug('prim : '+JSON.serialize(prim));            
            
            wrapper = new DealerShipmentBonusDT();            
            wrapper.PERIOD = period;
            wrapper.TOTALORDERCOUNT = incomingData.size(); 
            wrapper.TOTALBONUSWITHOUTTAX = CalcSumBonus(incomingData);
            wrapper.KDV = wrapper.TOTALBONUSWITHOUTTAX * (0.18);
            wrapper.TOTALBONUS = wrapper.TOTALBONUSWITHOUTTAX * (1.18);
            wrapper.INVOICENO =  prim.size()>0 ? prim[0].Invoice_Number__c : '';
            wrapper.DESCRIPTION = prim.size()>0 ? prim[0].Description__c : '';
            wrapper.EDITABLE = String.isNotBlank(wrapper.INVOICENO) || String.isNotEmpty(wrapper.INVOICENO) ? false : true;
        }
        
        System.debug('wrapper : '+JSON.serialize(wrapper));
        return  wrapper;        
    }
    
    //Bu method Community Prim ekranındaki 'Bayiden Sevk' datatable'dan Fatura Matbu No ve Açıklama alanını db'ye kaydetmesi icin yapildi.
    @AuraEnabled
    public static Boolean updateDealerBonusShipment(List<DealerShipmentBonusDT> draftValues, string bonusType, List<DealerShipmentBonusDT> headerData ){
        Boolean isSuccess = false;
        
        System.debug('DealerShipmentBonusDT: '+JSON.serialize(draftValues)); 
        System.debug('bonusType : '+bonusType);        
        System.debug('headerData : '+JSON.serialize(headerData));   
        
        if(draftValues != null && draftValues.size()>0){
            
            List<Prim_Invoices__c>  objList = new List<Prim_Invoices__c>();
            Prim_Invoices__c  obj = new Prim_Invoices__c();
            
            for(DealerShipmentBonusDT draft : draftValues){
                DealerShipmentBonusDT prim = draft;
                
                Decimal amountWithoutTax=0;
                List<String> periodList = prim.PERIOD.split('-');
                String monthString = periodList[0].Trim();
                String yearString =periodList[1].Trim();
                
                System.debug('year : '+yearString);    
                System.debug('monthString : '+monthString);
                
                for(DealerShipmentBonusDT header : headerData){
                    System.debug('header.PERIOD : '+header.PERIOD);
                    System.debug('prim.PERIOD : '+prim.PERIOD);
                    
                    if(header.PERIOD == prim.PERIOD){
                       amountWithoutTax = header.TOTALBONUSWITHOUTTAX;
                        break;
                    }
                }
                
                obj = new Prim_Invoices__c();
                obj.Account__c = RC_UtilitiesClass.getUserRelatedAccount().Id;//[select Id,RC_SAP_ID__c from Account where Id = '0013M00000QeUhbQAF' limit 1].Id;//TODO yorum satırı değişecek                
                obj.Amount_Without_Tax__c = amountWithoutTax;              
                obj.Invoice_Number__c = prim.INVOICENO;
                obj.Description__c = prim.DESCRIPTION;           
                obj.Inprogress__c = false;
                obj.RC_Month__c = GetMonthValue(monthString);
                obj.RC_Year__c	 = yearString;
                //obj.Month_of_Invoice__c = period;
                //obj.Year_of_Inovice__c = year;
                obj.Type__c =bonusType;
                
                objList.add(obj);                
            }
            
            List<Database.SaveResult>  srList = Database.insert(objList,true);
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    isSuccess = true;
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {            
                        isSuccess = false;
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
        return isSuccess;
    }
    
    
    
    @AuraEnabled
    public static String getDealerBonus(string startDate, string endDate, string period, string bonusType, string preYear){
        DealerShipmentBonusDT wrp = null;
        List<DealerShipmentBonusDT> listWrp = new List<DealerShipmentBonusDT>();
         System.debug('startDate: '+startDate);   
        System.debug('endDate: '+endDate);        
        String piStartDate =''; String piEndDate='';
        String currentYear = String.valueOf( DateTime.now().year());
        
        String onceki = preYear != currentYear ? 'X' : '';
        
        RC_GetDealerBonusIntegrator.requestModel req  = new RC_GetDealerBonusIntegrator.requestModel();
        RC_GetDealerBonusIntegrator.responseModel resp = new RC_GetDealerBonusIntegrator.responseModel();
        
        
        Account relatedAccount = RC_UtilitiesClass.getUserRelatedAccount();//;[select Id,RC_SAP_ID__c from Account where Id = '0013M00000QeUhbQAF' limit 1];//TODO yorum satırı değişecek
        String userId = '';
        if(test.isRunningTest()){
            userId ='20300066';
        }else{
           userId = relatedAccount.RC_SAP_ID__c;    
        }       
        /* userId ='20100340'; */
        
        if(!String.isBlank(startDate)&& !String.isEmpty(startDate)) piStartDate = ToYearMonth(startDate);
        if(!String.isBlank(endDate)&& !String.isEmpty(endDate)) piEndDate = ToYearMonth(endDate);
        
        userId = ToSAPString10Digits(userId);
        
        req.PA_KUNNR = userId;
        req.PA_TIP = bonusType;
        req.PA_DONEM = period; 
        req.PA_BAST = piStartDate;
        req.PA_BITT = piEndDate;
        req.PA_ONCEKI = onceki;
        
        System.debug('userId : '+userId);
        System.debug('bonusType: '+bonusType);
        System.debug('period : '+period);
        System.debug('startDate: '+piStartDate);   
        System.debug('endDate: '+piEndDate);
        System.debug('onceki: '+onceki);
        
        resp = RC_GetDealerBonusIntegrator.getDealerBonus(req);
        System.debug('resp: '+ JSON.serialize(resp));
        if(resp != null){
            wrp = new DealerShipmentBonusDT();
            wrp = getDealerBonusDT(resp,relatedAccount.Id, period, bonusType, preYear);
        }
        
        return JSON.serialize(wrp);        
    }
    
    @AuraEnabled
    public static DealerShipmentBonusDT getDealerBonusDT(RC_GetDealerBonusIntegrator.responseModel resp, Id relatedAccountId, string period, string bonusType, string preYear){
        
        DealerShipmentBonusDT wrapper = null;
        
        System.debug('resp : '+JSON.serialize(resp));
        
        if(resp.ET_RESULT_GRUP.item != null && resp.ET_RESULT_GRUP.item.size()>0){
            if(
                //  (String.isBlank(resp.ET_RESULT_GRUP.item[0].FATURALANDI) || String.isEmpty(resp.ET_RESULT_GRUP.item[0].FATURALANDI)) &&
                resp.ET_RESULT_GRUP.item[0].PRIMD!=''){
                    
                    String q = 'SELECT Id, Invoice_Number__c, Description__c FROM Prim_Invoices__c Where RC_Year__c = \''+preYear+'\' and RC_Quarter__c = \''+period+'\' and Account__c =\''+relatedAccountId+'\' and Type__c =\''+bonusType+'\' ';
                    System.debug('q : '+q);
                    List<Prim_Invoices__c> prim = Database.query(q);                    
                    System.debug('prim : '+JSON.serialize(prim));
                    
                    wrapper = new DealerShipmentBonusDT();
                    
                    Decimal primd = Decimal.valueOf(resp.ET_RESULT_GRUP.item[0].PRIMD);
                    
                    wrapper.PERIOD = resp.ET_RESULT_GRUP.item[0].YIL + ' - ' + resp.ET_RESULT_GRUP.item[0].DONEM+ '. Dönem';            
                    wrapper.ORTGUN = resp.ET_RESULT_GRUP.item[0].ORTGUN;
                    wrapper.TOTALBONUSWITHOUTTAX = primd;
                    wrapper.KDV = primd * (0.18);
                    wrapper.TOTALBONUS =  primd * (1.18);
                    wrapper.INVOICENO= prim.size()>0 ? prim[0].Invoice_Number__c : '';
                    wrapper.DESCRIPTION =  prim.size()>0 ? prim[0].Description__c : '';
                    wrapper.EDITABLE = String.isNotBlank(wrapper.INVOICENO) || String.isNotEmpty(wrapper.INVOICENO) ? false : true;
                    
                    
                }
        }
        
        System.debug('wrapper : '+JSON.serialize(wrapper));
        return  wrapper;        
    }
    
    //Bu method Community Prim ekranındaki 'Bayiden Ciro ve Bayi Mağaza Prim' datatable'larından Fatura Matbu No ve Açıklama alanını db'ye kaydetmesi icin yapildi.
    @AuraEnabled
    public static Boolean updateDealerBonus(List<DealerShipmentBonusDT> draftValues, string bonusType, List<DealerShipmentBonusDT> headerData ){
        Boolean isSuccess = false;
        
        System.debug('DealerShipmentBonusDT: '+JSON.serialize(draftValues)); 
        System.debug('bonusType : '+bonusType);        
        
        if(draftValues != null && draftValues.size()>0){ 
            
            Prim_Invoices__c  obj = new Prim_Invoices__c();
            
            DealerShipmentBonusDT prim = draftValues[0];
            
            Decimal amountWithoutTax=0;
            List<String> periodList = prim.PERIOD.split('-');
            String year = periodList[0].Trim();
            String period =periodList[1].Split('. Dönem')[0].Trim();
            
            System.debug('year : '+year);    
            System.debug('period : '+period); 
            
            for(DealerShipmentBonusDT header : headerData){
                    System.debug('header.PERIOD : '+header.PERIOD);
                    System.debug('prim.PERIOD : '+prim.PERIOD);
                    
                    if(header.PERIOD == prim.PERIOD){
                       amountWithoutTax = header.TOTALBONUSWITHOUTTAX;
                        break;
                    }
            }
            
            obj = new Prim_Invoices__c();
            obj.Account__c = RC_UtilitiesClass.getUserRelatedAccount().Id;//[select Id,RC_SAP_ID__c from Account where Id = '0013M00000QeUhbQAF' limit 1].Id;//TODO yorum satırı değişecek
            obj.Amount_Without_Tax__c = amountWithoutTax;
            obj.Invoice_Number__c = prim.INVOICENO;
            obj.Description__c = prim.DESCRIPTION;           
            obj.Inprogress__c = false;
            obj.RC_Quarter__c = period;
            obj.RC_Year__c	 = year;
            //obj.Month_of_Invoice__c = period;
            //obj.Year_of_Inovice__c = year;
            obj.Type__c =bonusType;    
            
            Database.SaveResult result = Database.insert(obj);
            isSuccess = result.isSuccess();
        }
        return isSuccess;
    }
    
    
    
    
    
    public static String ToYearMonth(string dt){
        String dateFormat = 'yyyyMM';
        
        String tempDate = String.valueOf(dt);
        List<String> parsedDate = tempDate.split('-');
        String strYear = parsedDate[0];
        String strMonth = String.valueOf(parsedDate[1]).length()<2 ? '0'+parsedDate[1] : parsedDate[1];
        
        return strYear+strMonth;
    }
    
    public static Decimal CalcSumBonus(List<RC_DealerBonusShipmentJsonParser.Item> itemList){
        Decimal totalSum = 0;
        
        for (RC_DealerBonusShipmentJsonParser.Item item : itemList) {
            totalSum += Decimal.valueOf(item.ZPRIM);
        }
        
        return totalSum;
    }
    
    public static String ToPIDateString(string dt){
        String SAPDateFormat = 'yyyy-MM-dd';
        
        String tempDate = String.valueOf(dt);
        List<String> parsedDate = tempDate.split('-');
        String strYear = parsedDate[0];
        String strMonth = String.valueOf(parsedDate[1]).length()<2 ? '0'+parsedDate[1] : parsedDate[1];
        String strDay = String.valueOf(parsedDate[2]).length()<2 ? '0'+parsedDate[2] : parsedDate[2];
        
        return strYear+strMonth+strDay;
    }
    
    public static String ToSAPString10Digits(string code){        
        Integer length = code.length();
        Integer diff = 10 - length;
        
        for (integer i=0; i<diff; i++){
            code = '0'+code;
        }
        
        return code;
    }
    
    public static String GetMonthValue(String monthString){
        String monthValue = '0';
        
        switch on monthString{
            when 'Ocak'{   monthValue ='1' ;  }
            when 'Şubat'{   monthValue = '2'; }
            when 'Mart'{   monthValue = '3';  }
            when 'Nisan'{   monthValue = '4';  }
            when 'Mayıs'{   monthValue ='5';  }
            when 'Haziran'{   monthValue ='6' ;  }
            when 'Temmuz'{   monthValue ='7' ;  }
            when 'Ağustos'{   monthValue = '8' ;  }
            when 'Eylül'{   monthValue = '9';  }
            when 'Ekim'{  monthValue = '10' ;  }
            when 'Kasım'{  monthValue = '11';  }
            when 'Aralık'{  monthValue = '12';}
            when else{  monthValue = '0';    }
        }
        
        return monthValue;
    }
    
    public static String GetMonthName(Datetime dt){
        Integer month = dt.month();
        String monthString='';
        
        switch on month{
            when 1{   monthString = 'Ocak';  }
            when 2{   monthString = 'Şubat'; }
            when 3{   monthString = 'Mart';  }
            when 4{   monthString = 'Nisan';  }
            when 5{   monthString = 'Mayıs';  }
            when 6{   monthString = 'Haziran';  }
            when 7{   monthString = 'Temmuz';  }
            when 8{   monthString = 'Ağustos';  }
            when 9{   monthString = 'Eylül';  }
            when 10{  monthString = 'Ekim';  }
            when 11{  monthString = 'Kasım';  }
            when 12{  monthString = 'Aralık';}
            when else{  monthString = '';    }
        }
        
        return monthString;
    }
    
    public static Date CDate(string dateInfo){
        
        List<String> parsedDate = dateInfo.split('-');
        return  Date.newInstance(integer.valueof(parsedDate[0]), integer.valueof(parsedDate[1]), integer.valueof(parsedDate[2]));
    }
}