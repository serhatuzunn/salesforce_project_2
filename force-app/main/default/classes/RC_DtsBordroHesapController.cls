public class RC_DtsBordroHesapController {
    private static Date keyDate = Date.today().addYears(-1);

    public class InitializePlanModel{
        @AuraEnabled
        public RC_Bordro__c bordro {get; set;}
        @AuraEnabled
        public Boolean checkToday {get; set;}
        @AuraEnabled
        public String chequeType {get; set;}
        @AuraEnabled
        public String bordroType {get; set;}
        @AuraEnabled
        public List<RC_Cheque_Payment_Plan__c> paymentPlan {get; set;}
        @AuraEnabled
        public String message {get; set;}
        @AuraEnabled
        public String calculatedDate {get; set;}
        @AuraEnabled
        public String calculatedAmount {get; set;}
        @AuraEnabled
        public boolean isSuccess {get; set;}
        @AuraEnabled
        public string hesaplananTutar {get; set;}
        @AuraEnabled
        public string hesaplananVade {get; set;}
        @AuraEnabled
        public string farkVade {get; set;}
        @AuraEnabled
        public string farkTutar {get; set;}
    }

    public class GeneralInfo{
        @AuraEnabled
        public Decimal bordroTutar {get; set;}
        @AuraEnabled
        public Date bordroVade {get; set;}
        @AuraEnabled
        public Decimal girilenTutar {get; set;}
        @AuraEnabled
        public Date girilenVade {get; set;}
        @AuraEnabled
        public Decimal hesaplananTutar {get; set;}
        @AuraEnabled
        public Date hesaplananVade {get; set;}
        @AuraEnabled
        public Decimal farkTutar {get; set;}
        @AuraEnabled
        public Decimal farkVade {get; set;}
        @AuraEnabled 
        public String message {get; set;}
        @AuraEnabled
        public Integer octTutarFark {get; set;}
        

        public GeneralInfo(){
            this.bordroTutar = 0;
            this.girilenTutar = 0;
            this.hesaplananTutar = 0;
            this.farkTutar = 0;
        }
    }

    public class ControlWrapper{
        @AuraEnabled
        public Boolean isSuccess {get; set;}
        @AuraEnabled
        public String message {get; set;}
        @AuraEnabled
        public GeneralInfo info {get; set;}

        public ControlWrapper(){
            this.isSuccess = true;
            this.message = '';
        }
    }

    public class sendPlanToSapResponseWrapper{
        @AuraEnabled
        public Boolean isSuccess {get; set;}
        @AuraEnabled
        public String message {get; set;}
    }

    @AuraEnabled
    public static List<RC_Bordro__c> getBordroList(String isOpen,string selectedAccountId){
        try {
            List<RC_Bordro__c> dealerRelatedBordroList = new List<RC_Bordro__c>();
            if (String.isBlank(selectedAccountId)) {
                selectedAccountId = [Select AccountId, Account.RC_SAP_ID__c from User where id =: UserInfo.getUserId()].Account.RC_SAP_ID__c;
            }

            if(isOpen == 'true'){
                dealerRelatedBordroList = [SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate
                 FROM RC_Bordro__c
                  WHERE ((RC_Process_Type__c = '03' AND RC_Bordro_Type__c = 'D') or (RC_Process_Type__c = '02' AND RC_Bordro_Type__c = 'C')) 
                  AND   RC_Dealer_Number__c =: selectedAccountId  AND RC_IsSend__c = false];
            }else{
                dealerRelatedBordroList = [SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate FROM RC_Bordro__c 
                WHERE ((RC_Process_Type__c = '03' AND RC_Bordro_Type__c = 'D') or (RC_Process_Type__c = '02' AND RC_Bordro_Type__c = 'C')) AND RC_Dealer_Number__c =:selectedAccountId  AND RC_IsSend__c = true];
            }

            System.debug('dealerRelatedBordroList : ' + dealerRelatedBordroList);


            return dealerRelatedBordroList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<RC_Cheques__c> getRelatedInvoice(Id selectedBordroId){
        List<RC_Cheques__c> relatedInvoiceList = new List<RC_Cheques__c>();

        if(String.isNotBlank(selectedBordroId)){
            relatedInvoiceList = [SELECT Id, RC_Description__c, RC_Statu__c, RC_Product_Info__c, RC_Due_Date__c, RC_Invoice_Number__c, RC_Amount__c FROM RC_Cheques__c WHERE RC_Type__c = 'Invoice' AND RC_Bordro__c =: selectedBordroId];
        }

        return relatedInvoiceList;
    }

    @AuraEnabled
    public static List<RC_Cheque_Payment_Plan__c> getBordroRelatedPlans(Id selectedBordroId){
        
        List<RC_Cheque_Payment_Plan__c> paymentPlanList = new List<RC_Cheque_Payment_Plan__c>();

        if(String.isNotBlank(selectedBordroId)){
            paymentPlanList= [SELECT  RC_Payment_Plan_Due_Date__c, RC_Payment_Plan_Amount__c,RC_Payment_Plan_Number__c 
            FROM RC_Cheque_Payment_Plan__c WHERE RC_Bordro__c =: selectedBordroId];
        }

        return paymentPlanList;
    }

    @AuraEnabled
    public static List<RC_Cheques__c> getBordroRelatedCheques(Id selectedBordroId){
        
            List<RC_Cheques__c> bordroRelatedChequeList = new List<RC_Cheques__c>();

            if(String.isNotBlank(selectedBordroId)){
                bordroRelatedChequeList = [SELECT Id, RC_City__r.Name, RC_Drawer_Region__c, RC_Due_Date__c, RC_Cheque_Bill__c, RC_Cheque_Number__c, RC_Amount__c, RC_Identification_Number__c, RC_Bank_Key__c, RC_Bank_Key__r.RC_BANK__c, RC_Bank_Key__r.RC_BRINCH__c, RC_Bank_Key__r.RC_BANKL__c, RC_Bank_Account_Number__c, RC_IsSent__c, RC_Check_Status_ID__c, RC_Bill_Number__c FROM RC_Cheques__c WHERE RC_Type__c = 'Cheque' AND RC_Bordro__c =: selectedBordroId];
            } 

            return bordroRelatedChequeList;
    }

    @AuraEnabled
    public static Date getAverageMaturity(RC_Bordro__c bordro, Decimal cekToplam, Date cekOrtVade){
        system.debug('bordro :' + bordro);
        if(bordro.Cheques__r != null && bordro.Cheques__r.size() > 0){       
            Decimal totalDays = 0;
            Decimal totalAmount = 0;
            
            totalDays += (-1 * bordro.RC_Average_Due_Date__c.daysBetween(keyDate)) * bordro.RC_Amount__c;
            totalDays -= cekOrtVade != null ? (-1 * cekOrtVade.daysBetween(keyDate)) * cekToplam : 0;
            totalAmount = bordro.RC_Amount__c - cekToplam;
            
            Integer dayDifferance = totalDays == 0 || totalAmount == 0 ? 0 : Integer.valueOf(totalDays / totalAmount);
            
            return keyDate.addDays(dayDifferance);
        }
        else{
            return bordro.RC_Average_Due_Date__c;
        }
    }

    @AuraEnabled
    public static InitializePlanModel calculatePlan(Id selectedBordroId, Boolean checkToday, Integer count, Integer range){
        List<RC_Cheque_Payment_Plan__c> paymentPlanList = new List<RC_Cheque_Payment_Plan__c>();
        InitializePlanModel result = new InitializePlanModel();
        GeneralInfo gi = new GeneralInfo();   

       /* Boolean isDeleteSucces = true;
        List<RC_Cheque_Payment_Plan__c> deletedPlans = getBordroRelatedPlans(selectedBordroId);
        List<Database.DeleteResult> drList = Database.delete(deletedPlans,true);
        for (Database.DeleteResult dr : drList) {
            if(!dr.isSuccess()){
                isDeleteSucces = false;
                break;
            }
        }

        if(isDeleteSucces == false){
            result.isSuccess = false;
            result.message = 'Bir Hata Oluştu ! Sistem yöneticiniz ile iletişime geçiniz .';
            return result;
        }*/

        
        String message = '';

        RC_Bordro__c bordro = [SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate, RC_Connected__c, (SELECT RC_Amount__c, RC_Due_Date__c FROM Cheques__r WHERE RC_Type__c = 'Cheque') FROM RC_Bordro__c WHERE Id =: selectedBordroId];
        
        gi.bordroTutar = bordro.RC_Amount__c;
        gi.bordroVade = bordro.RC_Average_Due_Date__c;

        Decimal total = bordro.RC_Amount__c;
        Decimal topAdat = 0;
        Decimal girilenTutar = 0;
        
        for(RC_Cheques__c c : bordro.Cheques__r){
            total -= c.RC_Amount__c != null ? c.RC_Amount__c : 0;
            topAdat += c.RC_Due_Date__c != null && c.RC_Amount__c != null ? (-1 * c.RC_Due_Date__c.daysBetween(keyDate)) * c.RC_Amount__c : 0;
            girilenTutar += c.RC_Amount__c != null ? c.RC_Amount__c : 0;
        }
        
        Date girilenVade = bordro.Cheques__r != null && bordro.Cheques__r.size() > 0 ? keyDate.addDays(Integer.valueOf((topAdat / girilenTutar))) : null;

        gi.girilenTutar = girilenTutar;
        gi.girilenVade = girilenVade;

        Date midDate = getAverageMaturity(bordro, girilenTutar, girilenVade);

        Decimal rest = Math.mod(Integer.valueOf(total * 100), count * 100) / 100.0;
        Decimal unitPayment = ((total - rest) / count); 

        for(Integer i = 0; i < count; i++){
            if(Math.mod(count, 2) == 1){
                if(i == 0){
                    if(count == i + 1){
                        unitPayment = unitPayment + rest;
                    }

                    RC_Cheque_Payment_Plan__c paymentPlan = new RC_Cheque_Payment_Plan__c(
                        RC_Payment_Plan_Due_Date__c = midDate,
                        RC_Payment_Plan_Amount__c = unitPayment,
                        RC_Bordro__c = bordro.Id,
                        RC_Payment_Plan_Number__c = getUUID()
                    );

                    paymentPlanList.add(paymentPlan);
                }
                else{
                    RC_Cheque_Payment_Plan__c paymentPlan = new RC_Cheque_Payment_Plan__c(
                        RC_Payment_Plan_Due_Date__c = midDate.addDays(-1 * (((i + 1 ) / 2) * range)),
                        RC_Payment_Plan_Amount__c = unitPayment,
                        RC_Bordro__c = bordro.Id,
                        RC_Payment_Plan_Number__c = getUUID()
                    );

                    paymentPlanList.add(paymentPlan);

                    if(i == count - 2){
                        unitPayment = unitPayment + rest;
                    }

                    paymentPlan = new RC_Cheque_Payment_Plan__c(
                        RC_Payment_Plan_Due_Date__c = midDate.addDays(((i + 1) / 2) * range),
                        RC_Payment_Plan_Amount__c = unitPayment,
                        RC_Bordro__c = bordro.Id,
                        RC_Payment_Plan_Number__c = getUUID()
                    );

                    paymentPlanList.add(paymentPlan);
                    
                    i++;
                }
            }
            else{
                RC_Cheque_Payment_Plan__c paymentPlan = new RC_Cheque_Payment_Plan__c(
                    RC_Payment_Plan_Due_Date__c = midDate.addDays(-1 * ((range / 2) + ((i / 2) * range))),
                    RC_Payment_Plan_Amount__c = unitPayment,
                    RC_Bordro__c = bordro.Id,
                    RC_Payment_Plan_Number__c = getUUID()
                );

                paymentPlanList.add(paymentPlan);

                if(i == count - 2){
                    unitPayment = unitPayment + rest;
                }

                paymentPlan = new RC_Cheque_Payment_Plan__c(
                    RC_Payment_Plan_Due_Date__c = midDate.addDays(((range / 2) + ((i / 2) * range))),
                    RC_Payment_Plan_Amount__c = unitPayment,
                    RC_Bordro__c = bordro.Id,
                    RC_Payment_Plan_Number__c = getUUID()
                );

                paymentPlanList.add(paymentPlan);
                
                i++;
            }
        }

        Decimal totalDays = 0;
        totalDays += girilenTutar > 0 ? (-1 * girilenVade.daysBetween(keyDate)) * girilenTutar : 0;
        totalDays += (-1 * midDate.daysBetween(keyDate)) * total;

        Decimal totalAmount = girilenTutar + total;
        Decimal dayDifferance = totalAmount > 0 ? Math.ceil(totalDays / totalAmount) : 0;
        Date dt = keyDate.addDays(Integer.valueOf(dayDifferance));

        gi.hesaplananVade = midDate;
        result.hesaplananVade = String.ValueOf(midDate);

        system.debug(checkToday + ' || ' + bordro + ' || ' + midDate);
        midDate = checkToday ? bordro.RC_Average_Due_Date__c : midDate;

        System.debug('total :::' + total);
        System.debug('String.ValueOf(total) :::' + String.ValueOf(total));
        gi.hesaplananTutar = total;  
        result.hesaplananTutar = String.ValueOf(total); 

        gi.farkTutar = totalAmount > bordro.RC_Amount__c ? totalAmount - bordro.RC_Amount__c : bordro.RC_Amount__c - totalAmount;
        result.farkTutar = String.ValueOf(gi.farkTutar);

        gi.farkVade = dt > bordro.RC_Average_Due_Date__c ? (-1 * dt.daysBetween(bordro.RC_Average_Due_Date__c)) : (-1 * bordro.RC_Average_Due_Date__c.daysBetween(dt));
        result.farkVade = String.ValueOf(gi.farkVade);

        if(checkToday){
            for(RC_Cheque_Payment_Plan__c cpp : paymentPlanList){
                cpp.RC_Payment_Plan_Due_Date__c = Date.today();
            }
        }

        result.paymentPlan = paymentPlanList;
        //result.generalInfo = gi;
        result.checkToday = bordro.RC_Average_Due_Date__c < Date.today() ? true : false;
        result.bordro = bordro;

        return result;
    }

    @AuraEnabled
    public static ControlWrapper checkPlan(Id selectedBordroId, List<RC_Cheque_Payment_Plan__c> paymentPlanList){
        ControlWrapper result = new ControlWrapper();
        GeneralInfo info = new GeneralInfo();
        String message = '';
        System.debug('Payment Plan : ' + paymentPlanList);
        RC_Bordro__c bordro = [SELECT RC_Amount__c, RC_Average_Due_Date__c, RC_Bordro_Type__c, RC_Process_Type__c FROM RC_Bordro__c WHERE Id =: selectedBordroId];
        String bordroType = bordro.RC_Bordro_Type__c;

        info.bordroTutar = bordro.RC_Amount__c;
        info.bordroVade = bordro.RC_Average_Due_Date__c;

        if(paymentPlanList != null && paymentPlanList.size() > 0){
            List<RC_Cheques__c> relatedCheque = getBordroRelatedCheques(selectedBordroId);
            Boolean checkToday = bordro.RC_Average_Due_Date__c < Date.today() ? true : false; 

            Decimal topAdat = 0;
            Decimal topCek = 0;
            Date cekOrtVade = null;
            if(relatedCheque != null && relatedCheque.size() > 0){
                for(RC_Cheques__c c : relatedCheque){
                    topAdat += c.RC_Due_Date__c != null && c.RC_Amount__c != null ? (-1 * c.RC_Due_Date__c.daysBetween(keyDate)) * c.RC_Amount__c : 0;
                    topCek += c.RC_Amount__c;
                }
                
                cekOrtVade = keyDate.addDays(Integer.valueOf((topAdat / topCek)));

                info.girilenTutar = topCek;
                info.girilenVade = cekOrtVade;
            }

            Decimal adatSum = 0;
            Decimal userTotal = 0;
            Date minimumDate = Date.newInstance(2099, 1, 1);
            for(RC_Cheque_Payment_Plan__c cpp : paymentPlanList){
                userTotal += cpp.RC_Payment_Plan_Amount__c;
                adatSum += cpp.RC_Payment_Plan_Due_Date__c != null && cpp.RC_Payment_Plan_Amount__c != null ? (-1 * cpp.RC_Payment_Plan_Due_Date__c.daysBetween(keyDate)) * cpp.RC_Payment_Plan_Amount__c : 0;
                minimumDate = cpp.RC_Payment_Plan_Due_Date__c < minimumDate ? cpp.RC_Payment_Plan_Due_Date__c : minimumDate;
            }
            
            Decimal dateToBeAdded = adatSum / userTotal;
            Date userMiddate = checkToday ? bordro.RC_Average_Due_Date__c : keyDate.addDays(Integer.valueOf(dateToBeAdded));
            Decimal total = bordro.RC_Amount__c - topCek;
            Date dtFirstPayment = Date.today().addDays(15);

            info.hesaplananTutar = userTotal;
            info.hesaplananVade = userTotal != 0 ? userMiddate : null;

            Decimal totalDays = 0;
            totalDays += cekOrtVade != null ? (-1 * cekOrtVade.daysBetween(keyDate)) * topCek : 0;
            totalDays += (-1 * userMiddate.daysBetween(keyDate)) * total;

            Decimal totalAmount = topCek + total;
            Decimal dayDifference = totalAmount > 0 ? Math.ceil(totalDays / totalAmount) : 0;

            Date dtNew = keyDate.addDays(Integer.valueOf(dayDifference));
            userTotal += topCek;

            Integer gunFark = (-1 * dtNew.daysBetween(bordro.RC_Average_Due_Date__c));
            Decimal fark = (-1 * (bordro.RC_Amount__c - userTotal));

            info.farkTutar = fark;
            info.farkVade = gunFark;

            result.info = info;

            List<RC_Financial_Process_Definition__c> paramList = [SELECT RC_Bordro_No__C, RC_Amount_Negative__c, RC_Amount_Positive__c, RC_Due_Date_Negative__c, RC_Due_Date_Positive__c 
                                                                  FROM RC_Financial_Process_Definition__c 
                                                                  WHERE (RC_Bordro_No__c =: selectedBordroId OR RC_Bordro_No__C = '') 
                                                                  AND RC_Process_Type__c =: bordro.RC_Process_Type__c 
                                                                  AND RecordType.DeveloperName = 'RC_Cheque_Parameters'];

            RC_Financial_Process_Definition__c param = null;
            if(paramList != null && paramList.size() > 0){
                if(paramList.size() == 1){
                    param = paramList.get(0);
                }
                else{
                    for(RC_Financial_Process_Definition__c p : paramList){
                        if(p.RC_Bordro_No__C == selectedBordroId){
                            param = p;

                            break;
                        }
                    }

                    if(param == null){
                        param = paramList.get(0);
                    }
                }
            }
            
            if(param == null){
                param = new RC_Financial_Process_Definition__c(RC_Amount_Negative__c=0, RC_Amount_Positive__c=0, RC_Due_Date_Negative__c=0, RC_Due_Date_Positive__c=0);
            }

            if(-1 * fark < param.RC_Amount_Negative__c || -1 * fark > param.RC_Amount_Positive__c){
                List<RC_Cheque_Payment_Plan__c> relatedPlanList = getBordroRelatedPlans(selectedBordroId);
                    if(bordroType == 'D'){
                        message = 'Onaylanmış sözleşmenin tutar bilgisi ile giriş yapılan ödeme planının tutarı farklıdır kontrol ediniz .';
                    }
                    else{
                        message = 'Girdiğiniz çeklerin toplam tutarı bordro tutarından farklıdır.';
                    }
            }
            else if((gunFark < param.RC_Due_Date_Negative__c || gunFark > param.RC_Due_Date_Positive__c) && !checkToday){
                if(bordroType == 'D'){
                    message = 'Onaylanmış sözleşmenin vadesi ile giriş yapılan ödeme planının vadesi farklıdır kontrol Ediniz .';
                }
                else{
                    message = 'Hesaplanan Vade Tarihi, Bordro Vade Tarihinden farklıdır.';
                }
            }
            else if(minimumDate <= dtFirstPayment && !checkToday){
                message = String.format('Çek Vade Tarihi {0} tarihinden önce olamaz.', new List<Date>{dtFirstPayment});
            }
            else{
                if(!checkToday){
                    for (RC_Cheque_Payment_Plan__c cpp : paymentPlanList) {
                        if(cpp.RC_Payment_Plan_Due_Date__c <= dtFirstPayment){
                            message = String.format('Çek Vade Tarihi {0} tarihinden önce olamaz.', new List<Date>{dtFirstPayment});
                        }
                        else if(cpp.RC_Payment_Plan_Due_Date__c != null && cpp.RC_Payment_Plan_Due_Date__c.year() > Date.today().addYears(2).year()){
                            message = String.format('Çek Vade Tarihi 01.01.{0} tarihinden önce olmalıdır.', new List<Integer>{Date.today().addYears(3).year()});
                        }
                    }
                }
            }
        }

        if(String.isNotBlank(message)){
            result.isSuccess = false;
            result.message = message;
        }

        return result;
    }

    @AuraEnabled
    public static boolean deletePlan(string selectedBordroId){
        List<RC_Cheque_Payment_Plan__c> deletedPlans = getBordroRelatedPlans(selectedBordroId);

        System.debug('deletedPlans :::' + json.serialize(deletedPlans));

        if(deletedPlans.size() > 0 ){
            List<Database.DeleteResult> drList = Database.delete(deletedPlans,true);
            for (Database.DeleteResult dr : drList) {
                if(!dr.isSuccess()){
                    break;
                    return false;
                }
            }
            return true;
        }else{
            return true;
        }
        
    }

    @AuraEnabled
    public static Boolean processPaymentPlan(List<RC_Cheque_Payment_Plan__c> paymentPlanList){

        System.debug('paymentPlanList :::' + json.serialize(paymentPlanList));

            List<Database.SaveResult> srList = Database.insert(paymentPlanList,true);
            for (Database.SaveResult sr : srList) {
                if(sr.isSuccess()){
                    continue;
                }else{
                    return false;
                }
            }
            return true;
    }

    @AuraEnabled
    public static InitializePlanModel initializeOdemePlan(Id selectedBordroId,string brdBakiye , string brdOrtVade){
        InitializePlanModel ip = new InitializePlanModel();
        GeneralInfo info = new GeneralInfo();
        RC_Bordro__c bordro = new RC_Bordro__c();

        List<RC_Bordro__c> bordroList = [SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate, RC_Connected__c FROM RC_Bordro__c WHERE Id =: selectedBordroId];

        if(bordroList == null && bordroList.size() == 0){
            ip.message = 'Bordro kaydına ulaşılamadı.';
            return ip;
        }else{
            bordro = bordroList.get(0);
        }

        if(bordro.RC_Average_Due_Date__c == null || bordro.RC_Amount__c == null){
            ip.message = 'Bordro Vade veya Tutar değeri eksik. Kontrol ediniz.';
            return ip;
        }

        ip.checkToday = bordro.RC_Average_Due_Date__c < Date.today() ? true : false;   // Vade tarihi geçmişse ödeme planı tek çek ile hazırlanır. Gerisine izin verilmez . SORULAACAK

        List<RC_Cheque_Payment_Plan__c> paymentPlanList = getBordroRelatedPlans(selectedBordroId);

        if(paymentPlanList.size() > 0){
            //DB'de kayıt varsa ekrana bunları göster

            ip.paymentPlan = paymentPlanList;
            info = calculateGeneralInfo(bordro.Id, paymentPlanList);

            System.debug('info.hesaplananVade : ' + info.hesaplananVade);
            System.debug('info.hesaplananTutar : ' + info.hesaplananTutar);
            System.debug('info.farkVade : ' + info.farkVade);
            System.debug('info.farkTutar : ' + info.farkTutar);

            ip.hesaplananVade   = String.ValueOf(info.hesaplananVade);
            ip.hesaplananTutar  = String.ValueOf(info.hesaplananTutar);
            ip.farkVade         = String.ValueOf(info.farkVade);
            ip.farkTutar        = String.ValueOf(info.farkTutar);
 
        }else{  
            ip.hesaplananTutar = String.ValueOf(bordro.RC_Amount__c);
            ip.hesaplananVade =  String.ValueOf(bordro.RC_Average_Due_Date__c);

            //Yoksa SAP'den çek
            RC_DTS_OdemePlanIntegrator.requestModel req             = new RC_DTS_OdemePlanIntegrator.requestModel();
            RC_DTS_OdemePlanIntegrator.item  requestItem            = new RC_DTS_OdemePlanIntegrator.item();
            List<RC_DTS_OdemePlanIntegrator.item> requestItemList   = new List<RC_DTS_OdemePlanIntegrator.item>();
            RC_DTS_OdemePlanIntegrator.ODEMEPLANDB ODEMEPLANDB      = new RC_DTS_OdemePlanIntegrator.ODEMEPLANDB();
            
            req.BORDRONO    = bordro.RC_Bordro_No__c;
            req.DEBUG       = '';
            req.OPERASYON   = 'R';

            RC_DTS_OdemePlanIntegrator.responseModel odemePlanResponse = RC_DTS_OdemePlanIntegrator.getDTSOdemePlan(req);

            if(odemePlanResponse.ODEMEPLANDB.item.size() > 0){
                decimal planItemsTotalAmount = 0;
                List<RC_Cheque_Payment_Plan__c> paymentPlanListSAP = new List<RC_Cheque_Payment_Plan__c>();
                for (RC_DTS_OdemePlanIntegrator.item planItem : odemePlanResponse.ODEMEPLANDB.item) {
                    RC_Cheque_Payment_Plan__c cheq = new RC_Cheque_Payment_Plan__c();

                    cheq.RC_Payment_Plan_Number__c = getUUID();
                    cheq.RC_Payment_Plan_Amount__c   = Decimal.ValueOf(planItem.TUTAR);
                    cheq.RC_Payment_Plan_Due_Date__c = Date.ValueOf(planItem.TARIH);
                    paymentPlanListSAP.add(cheq);
                }

                ip.farkTutar = '0';
                ip.farkVade = '0';
                ip.paymentPlan = paymentPlanListSAP;

            
            }else{
                ip.message = 'Kayıt Bulunamadı.';
                return ip;
            }

            System.debug('odemePlanResponse :' + odemePlanResponse);
        }

        ip.bordro = bordro;
        return ip;
    }

    @AuraEnabled
    public static GeneralInfo calculateGeneralInfo(string selectedBordroId, List<RC_Cheque_Payment_Plan__c> paymentPlanList){
           GeneralInfo gi = new GeneralInfo();
        try {
            RC_Bordro__c bordro = [SELECT id ,RC_Amount__c , RC_Average_Due_Date__c FROM RC_Bordro__c WHERE Id =: selectedBordroId LIMIT 1];
            
            gi.bordroTutar = bordro.RC_Amount__c;
            gi.bordroVade  = bordro.RC_Average_Due_Date__c;

            //Eklenen Çeklere Göre Hesaplanan Bakiye ve Ortalama Vade Bilgileri
            if(paymentPlanList != null && paymentPlanList.size() > 0){
                Decimal topAdat = 0;
                Decimal topCek = 0;

                for(RC_Cheque_Payment_Plan__c cpp : paymentPlanList){
                    topCek += cpp.RC_Payment_Plan_Amount__c;
                    topAdat += cpp.RC_Payment_Plan_Due_Date__c != null && cpp.RC_Payment_Plan_Amount__c != null ? (-1 * cpp.RC_Payment_Plan_Due_Date__c.daysBetween(keyDate)) * cpp.RC_Payment_Plan_Amount__c : 0;
                }

                gi.hesaplananTutar = topCek;
                gi.hesaplananVade = topCek != 0 ? keyDate.addDays(Integer.valueOf((topAdat / topCek))) : null;
            }
            
            
            Decimal totalDays = 0;
            Decimal hesaplanan = gi.hesaplananTutar;
            totalDays += gi.girilenVade != null ? (-1 * gi.girilenVade.daysBetween(keyDate)) * gi.girilenTutar : 0;
            totalDays += gi.hesaplananVade != null ? (-1 * gi.hesaplananVade.daysBetween(keyDate)) * hesaplanan : 0;

            Decimal totalAmount = hesaplanan + gi.girilenTutar;
            Decimal dayDifferance = totalAmount > 0 ? Math.ceil(totalDays / totalAmount) : 0;

            Date dtNew = keyDate.addDays(Integer.valueOf(dayDifferance));
            
            gi.farkTutar = (-1 * (gi.bordroTutar - totalAmount)); 
            gi.farkVade = dtNew > gi.bordroVade ? (-1 * dtNew.daysBetween(gi.bordroVade)) : ( gi.bordroVade.daysBetween(dtNew)); // -1 'leri sildik unutma SEKO
                    
            gi.octTutarFark = Integer.valueOf(Cheque_Parameters__c.getValues('OCTTutarFark').Value__c);
        } catch (Exception ex) {
            gi.message = ex.getMessage();
        }

            return gi;
    }

    @AuraEnabled
    public static sendPlanToSapResponseWrapper sendPaymentPlanToSAP(List<RC_Cheque_Payment_Plan__c> paymentPlanList){
        sendPlanToSapResponseWrapper responseWrp = new sendPlanToSapResponseWrapper();
        
        RC_DTS_OdemePlanIntegrator.requestModel requestModel = new RC_DTS_OdemePlanIntegrator.requestModel();
        requestModel.ODEMEPLANDB = new RC_DTS_OdemePlanIntegrator.ODEMEPLANDB();
        requestModel.ODEMEPLANDB.item = new List<RC_DTS_OdemePlanIntegrator.item>();

        List<string> planNumberList = new List<string>();
        for (RC_Cheque_Payment_Plan__c planTemp : paymentPlanList) {
            planNumberList.add(planTemp.RC_Payment_Plan_Number__c);
        }
        List<RC_Cheque_Payment_Plan__c> planListFromDB = [SELECT Id,CreatedDate , RC_Bordro__r.RC_Bordro_No__c,RC_Payment_Plan_Due_Date__c,RC_Payment_Plan_Amount__c FROM RC_Cheque_Payment_Plan__c 
                                                          WHERE RC_Payment_Plan_Number__c IN: planNumberList]; 

        if(planListFromDB.size() > 0){
            string bordroID = planListFromDB[0].RC_Bordro__c;
            integer index = 1;
            for (RC_Cheque_Payment_Plan__c p : planListFromDB) {
                RC_DTS_OdemePlanIntegrator.item item = new RC_DTS_OdemePlanIntegrator.item();
                
    
                requestModel.BORDRONO  = p.RC_Bordro__r.RC_Bordro_No__c;
                requestModel.DEBUG     = '';
                requestModel.OPERASYON = 'W';
    
                item.CEKNO       = p.RC_Bordro__r.RC_Bordro_No__c + 'D' + string.valueOf(index);
                item.BORDRO      = p.RC_Bordro__r.RC_Bordro_No__c;
                item.BORDROTYPE  = '';      
                item.KUNNR       = '';      
                item.KALEM       = string.valueOf(index);
                item.TARIH       = String.ValueOf(p.RC_Payment_Plan_Due_Date__c).remove('-');       //çek'in vade tarihi
                item.TUTAR       = String.ValueOf(p.RC_Payment_Plan_Amount__c);                     //çek'in tutarı
                item.WAERS       = 'TRY'; 
                item.STATUS      = 'A';
                item.ISLEMTARIHI = '';      
                item.BELNR       = '';      
                item.GJAHR       = '';      
    
    
                requestModel.ODEMEPLANDB.item.add(item);
                index++;
            }

            RC_DTS_OdemePlanIntegrator.responseModel responseSAP = RC_DTS_OdemePlanIntegrator.getDTSOdemePlan(requestModel);
            //SAP OK döndüyse plandan sil , çek'e yaz.
            Boolean isDeleteSuccess = true;
            if(responseSAP.isSuccess){
                List<Database.DeleteResult> drList = Database.delete(planListFromDB,true);
                for (Database.DeleteResult dr : drList) {
                    if(!dr.isSuccess()){
                        isDeleteSuccess = false;
                        break;
                    }
                }

                if(!isDeleteSuccess){
                    responseWrp.isSuccess = false;
                    responseWrp.message = 'Planlar güncellenirken bir hata oluştu !';
                    return responseWrp;
                }else{
                    List<RC_Cheques__c> chequeList = new List<RC_Cheques__c>();
                    index = 1;
                    for (RC_Cheque_Payment_Plan__c p : planListFromDB) {
                        RC_Cheques__c cheq = new RC_Cheques__c();

                        cheq.RC_Cheque_Number__c      = p.RC_Bordro__r.RC_Bordro_No__c + 'D' + string.valueOf(index);
                        cheq.RC_Bordro__c             = p.RC_Bordro__c;
                        cheq.RC_Amount__c             = p.RC_Payment_Plan_Amount__c;
                        cheq.RC_Type__c               = 'Cheque';
                        cheq.RC_IsSent__c             = true;
                        cheq.RC_Due_Date__c           = p.RC_Payment_Plan_Due_Date__c;

                        chequeList.add(cheq);
                        index++;
                    }

                    Boolean isSaveSuccess = true;
                    if (chequeList.size() > 0) {
                        List<Database.SaveResult> srChequeList = Database.insert(chequeList, true);
                        for (Database.SaveResult sr : srChequeList) {
                            if(!sr.isSuccess()){
                                isSaveSuccess = false;
                                break;
                            }
                        }
                        if(!isSaveSuccess){
                            responseWrp.isSuccess = false;
                            responseWrp.message = 'Çekler kaydedilirken bir hata oluştu !';
                            return responseWrp;
                        }else{
                            RC_Bordro__c updateBordro = [SELECT id FROM RC_Bordro__c WHERE id =:bordroID LIMIT 1];
                            if(updateBordro != null){
                                updateBordro.RC_IsSend__c = true;
                                update updateBordro;

                                responseWrp.isSuccess = true;
                                responseWrp.message = 'Başarılı !';
                                return responseWrp;
                            }else{
                                responseWrp.isSuccess = false;
                                responseWrp.message = 'Bordro güncellenirken bir hata oluştu !';
                                return responseWrp;
                            }
                        }
                    }else{
                        responseWrp.isSuccess = false;
                        responseWrp.message = 'Çekler kaydedilirken bir hata oluştu ! !';
                        return responseWrp;
                    }
                }
            }else{
                responseWrp.isSuccess = false;
                responseWrp.message = 'Ödeme planı SAP tarafına gönderilirken bir hata oluştu !';
                return responseWrp;
            }
        }else{
            responseWrp.isSuccess = false;
            responseWrp.message = 'SAP Gönderimden Önce Çalışmayı Kaydetmeniz Gerekiyor !';
            return responseWrp;
        }
    }

    private static String getUUID(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);

        return guid;
    }

    @AuraEnabled
    public static Boolean deleteSelectedBordro(string selectedBordroId){

        RC_Bordro__c deletedBordro = [SELECT id , RC_Bordro_No__c FROM RC_Bordro__c where id =: selectedBordroId LIMIT 1];
        
        RC_FI_DTS_BordroSilIntegrator.requestModel bordroSilRequest = new RC_FI_DTS_BordroSilIntegrator.requestModel();
        bordroSilRequest.T_BORDRO = new RC_FI_DTS_BordroSilIntegrator.T_BORDRO();
        bordroSilRequest.T_BORDRO.item = new List<RC_FI_DTS_BordroSilIntegrator.Item>();

        RC_FI_DTS_BordroSilIntegrator.Item bordroSilItem = new RC_FI_DTS_BordroSilIntegrator.Item();
        bordroSilItem.BORDRO = deletedBordro.RC_Bordro_No__c;
        bordroSilRequest.T_BORDRO.item.add(bordroSilItem);
        RC_FI_DTS_BordroSilIntegrator.responseModel bordroSilResponse = new RC_FI_DTS_BordroSilIntegrator.responseModel();

        bordroSilResponse.DURUM = RC_FI_DTS_BordroSilIntegrator.bordroSil(bordroSilRequest);//Response == 'OK' ise bordro silinmiştir.
        if(bordroSilResponse.DURUM == 'OK'){
            List<RC_Cheques__c> invList = new List<RC_Cheques__c>();
            invList = [SELECT id  FROM RC_Cheques__c WHERE RC_Bordro__c =: selectedBordroId];

            if(invList.size() > 0){
                List<Database.DeleteResult> drListCheque = Database.delete(invList,true);
                for(Database.DeleteResult dr : drListCheque){
                    if(!dr.isSuccess()){
                        break;
                        return false;
                    }
                }
                Database.DeleteResult drBordro = Database.delete(deletedBordro);
                if (!drBordro.isSuccess()) {
                    return false;
                } 
            }else{
                return false;
            }
            
            
        }else{
          return false;
        }

        return true;
    }

}