public with sharing class RC_CreateChequeAndBond {

    private static Date keyDate = Date.today().addYears(-1);
    
    // Main Methods
    @AuraEnabled
    public static InitializePlan initializeOdemePlan(Id selectedBordroId){
            InitializePlan ip = new InitializePlan();
            
            try {
                RC_Bordro__c bordro = null;
                List<RC_Bordro__c> bordroList = [SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate, RC_Connected__c, (SELECT Id, RC_City__c, RC_City__r.Name, RC_Drawer_Region__c, RC_Due_Date__c, RC_Cheque_Bill__c, RC_Cheque_Number__c, RC_Amount__c, RC_Identification_Number__c, RC_Bank_Key__c, RC_Bank_Key__r.Name, RC_Bank_Key__r.RC_BANK__c, RC_Bank_Key__r.RC_BRINCH__c, RC_Bank_Key__r.RC_BANKL__c, RC_Bank_Account_Number__c, RC_IsSent__c, RC_Check_Status_ID__c, RC_Bill_Number__c
                FROM Cheques__r WHERE RC_Type__c = 'Cheque') FROM RC_Bordro__c WHERE Id =: selectedBordroId];

                if(bordroList == null && bordroList.size() == 0){
                    ip.message = 'Bordro kaydına ulaşılamadı.';

                    return ip;
                }
                else{
                    bordro = bordroList.get(0);
                }

                if(bordro.RC_Average_Due_Date__c == null || bordro.RC_Amount__c == null){
                    ip.message = 'Bordro Vade veya Tutar değeri eksik. Kontrol ediniz.';

                    return ip;
                }  

            List<RC_Cheque_Payment_Plan__c> paymentPlanList = getBordroRelatedPlans(selectedBordroId);

            ip.bordroType = bordro.RC_Bordro_Type__c;

            ip.checkToday = bordro.RC_Average_Due_Date__c < Date.today() ? true : false;            
            ip.bordro = bordro;
                
            Integer count = ip.checkToday ? 1 : 6;
            Integer range = ip.checkToday ? 0 : 30;

            InitializePlan processResult = new InitializePlan();
            if(paymentPlanList != null && paymentPlanList.size() > 0){
                ip.paymentPlan = paymentPlanList;

                ip.generalInfo = calculateGeneralInfo(selectedBordroId, paymentPlanList);
            }
            else{
                processResult = calculatePlan(selectedBordroId, ip.checkToday, count, range);

                ip.paymentPlan = processResult.paymentPlan;
                ip.generalInfo = processResult.generalInfo;
            }
            
            } catch (Exception ex) {
                ip.message = ex.getMessage();
            }

            return ip;
    }

    @AuraEnabled
    public static InitializePlan calculatePlan(Id selectedBordroId, Boolean checkToday, Integer count, Integer range){
        List<RC_Cheque_Payment_Plan__c> paymentPlanList = new List<RC_Cheque_Payment_Plan__c>();
        InitializePlan result = new InitializePlan();
        GeneralInfo gi = new GeneralInfo();   
        
        String message = '';

        RC_Bordro__c bordro = [SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, RC_Bordro_Type__c, CreatedDate, (SELECT RC_Amount__c, RC_Due_Date__c FROM Cheques__r WHERE RC_Type__c = 'Cheque') FROM RC_Bordro__c WHERE Id =: selectedBordroId];
        
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
        system.debug(checkToday + ' || ' + bordro + ' || ' + midDate);
        midDate = checkToday ? bordro.RC_Average_Due_Date__c : midDate;

        gi.hesaplananTutar = total;        
        gi.farkTutar = (-1 * (bordro.RC_Amount__c - totalAmount));
        gi.farkVade = dt > bordro.RC_Average_Due_Date__c ? (-1 * dt.daysBetween(bordro.RC_Average_Due_Date__c)) : (-1 * bordro.RC_Average_Due_Date__c.daysBetween(dt));

        if(checkToday){
            for(RC_Cheque_Payment_Plan__c cpp : paymentPlanList){
                cpp.RC_Payment_Plan_Due_Date__c = Date.today();
            }
        }

        result.paymentPlan = paymentPlanList;
        result.generalInfo = gi;
        result.checkToday = bordro.RC_Average_Due_Date__c < Date.today() ? true : false;
        result.bordro = bordro;

        result.bordroType = bordro.RC_Bordro_Type__c;

        return result;
    }

    @AuraEnabled
    public static GeneralInfo calculateGeneralInfo(Id selectedBordroId, List<RC_Cheque_Payment_Plan__c> paymentPlanList){
        GeneralInfo gi = new GeneralInfo();

        try {
            RC_Bordro__c bordro = null;
        List<RC_Bordro__c> bordroList = [SELECT RC_Amount__c, RC_Average_Due_Date__c, RC_Bordro_Type__c, RC_Process_Type__c FROM RC_Bordro__c WHERE Id =: selectedBordroId];

        if(bordroList == null || bordroList.size() == 0){
            gi.message = 'Bordro Kaydı bulunamadı.';

            return gi;
        }
        else
            bordro = bordroList.get(0);

        if(bordro.RC_Average_Due_Date__c == null || bordro.RC_Amount__c == null){
            gi.message = 'Bordro Vadesi veya Tutarı boş olamaz.';

            return gi;
        }


        List<RC_Cheques__c> relatedCheque = getBordroRelatedCheques(selectedBordroId);
        if(paymentPlanList == null){
            paymentPlanList = getBordroRelatedPlans(selectedBordroId);
        }

        gi.bordroTutar = bordro.RC_Amount__c;
        gi.bordroVade = bordro.RC_Average_Due_Date__c;

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
        
        if(relatedCheque != null && relatedCheque.size() > 0){
            Decimal topAdat = 0;
            Decimal topCek = 0;

            for(RC_Cheques__c c : relatedCheque){
                topAdat += c.RC_Due_Date__c != null && c.RC_Amount__c != null ? (-1 * c.RC_Due_Date__c.daysBetween(keyDate)) * c.RC_Amount__c : 0;
                topCek += c.RC_Amount__c != null ? c.RC_Amount__c : 0;
            }

            gi.girilenTutar = topCek;
            gi.girilenVade = keyDate.addDays(Integer.valueOf((topAdat / topCek)));
        }      
        
        Decimal totalDays = 0;
        Decimal hesaplanan = gi.hesaplananTutar;
        totalDays += gi.girilenVade != null ? (-1 * gi.girilenVade.daysBetween(keyDate)) * gi.girilenTutar : 0;
        totalDays += gi.hesaplananVade != null ? (-1 * gi.hesaplananVade.daysBetween(keyDate)) * hesaplanan : 0;

        Decimal totalAmount = hesaplanan + gi.girilenTutar;
        Decimal dayDifferance = totalAmount > 0 ? Math.ceil(totalDays / totalAmount) : 0;

        Date dtNew = keyDate.addDays(Integer.valueOf(dayDifferance));
        
        gi.farkTutar = (-1 * (gi.bordroTutar - totalAmount));
        gi.farkVade = dtNew > gi.bordroVade ? (-1 * dtNew.daysBetween(gi.bordroVade)) : (-1 * gi.bordroVade.daysBetween(dtNew));
                
        List<RC_Financial_Process_Definition__c> paramList = [SELECT RC_Bordro_No__C, RC_Amount_Negative__c, RC_Amount_Positive__c, RC_Due_Date_Negative__c, RC_Due_Date_Positive__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'RC_Cheque_Parameters' AND (RC_Bordro_No__c =: selectedBordroId OR RC_Bordro_No__C = '') AND RC_Process_Type__c =: bordro.RC_Process_Type__c];

        RC_Financial_Process_Definition__c octTutarFark = null;
        if(paramList != null && paramList.size() > 0){
            if(paramList.size() == 1){
                octTutarFark = paramList.get(0);
            }
            else{
                for(RC_Financial_Process_Definition__c p : paramList){
                    if(p.RC_Bordro_No__C == selectedBordroId){
                        octTutarFark = p;

                        break;
                    }
                }

                if(octTutarFark == null){
                    octTutarFark = paramList.get(0);
                }
            }
        }

        gi.octTutarFark = octTutarFark;
        } catch (Exception ex) {
            gi.message = ex.getMessage();
        }

        return gi;
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
            Date dtFirstPayment = Date.today().addDays(5);

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
            Decimal fark = (- 1 * (bordro.RC_Amount__c - userTotal));

            info.farkTutar = fark;
            info.farkVade = gunFark;

            result.info = info;

            List<RC_Financial_Process_Definition__c> paramList = [SELECT RC_Bordro_No__C, RC_Amount_Negative__c, RC_Amount_Positive__c, RC_Due_Date_Negative__c, RC_Due_Date_Positive__c FROM RC_Financial_Process_Definition__c WHERE (RC_Bordro_No__c =: selectedBordroId OR RC_Bordro_No__C = '') AND RC_Process_Type__c =: bordro.RC_Process_Type__c AND RecordType.DeveloperName = 'RC_Cheque_Parameters'];

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

            if(fark != 0 && (((-1 * fark) < param.RC_Amount_Negative__c) || ((-1 * fark) > param.RC_Amount_Positive__c))){
                List<RC_Cheque_Payment_Plan__c> relatedPlanList = getBordroRelatedPlans(selectedBordroId);
    
                if(relatedPlanList != null && relatedPlanList.size() > 0){
                    message = 'Eksik çek girişlerini yapınız.';
                }
                else{
                    if(bordroType == 'B'){
                        message = 'Onaylı plan giriş ile gerçekleşen giriş uyumlu değildir. Kontrol Ediniz .';
                    }
                    else{
                        message = 'Girdiğiniz çeklerin toplam tutarı bordro tutarından farklıdır.';
                    }
                }
            }
            else if((-1 * gunFark < param.RC_Due_Date_Negative__c || -1 * gunFark > param.RC_Due_Date_Positive__c) && !checkToday){
                if(bordroType == 'B'){
                    message = 'Onaylı plan giriş ile gerçekleşen giriş uyumlu değildir. Kontrol Ediniz .';
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
    public static void processPaymentPlan(List<RC_Cheque_Payment_Plan__c> paymentPlanList, String processType){
        if(paymentPlanList != null){
            switch on processType {
                when 'insert' {
                    Database.upsert(paymentPlanList);
                }
                when else {
                    if(paymentPlanList.get(0).Id != null){
                        Database.delete(paymentPlanList);
                    }
                }
            }
        }
    }

    @AuraEnabled
    public static void deleteOdemePlan(String relatedOPId){
        try {
            if(String.isNotBlank(relatedOPId)){
                RC_Cheque_Payment_Plan__c updatedPlan = new RC_Cheque_Payment_Plan__c(Id = relatedOPId, RC_Is_Created__c = true);
                Database.update(updatedPlan);
            }
        } catch (Exception e) {
            system.debug(e.getMessage());
        }
    }

    @AuraEnabled
    public static ControlWrapper deleteCheque(String chequeId){
        ControlWrapper cw = new ControlWrapper();
        try {
            RC_Cheques__c relatedCheque = new RC_Cheques__c(Id = chequeId);
            Database.DeleteResult dr = Database.delete(relatedCheque);
                    if(dr.isSuccess()){
                        cw.isSuccess = true;
                    }
                    else{
                        for(Database.Error err : dr.getErrors()){
                            cw.isSuccess = false;
                            cw.message = err.getMessage();
                        }
                    }
            
        } catch (Exception e) {
            cw.isSuccess = false;
            cw.message = e.getMessage();
        }

        return cw;
    }

    @AuraEnabled
    public static List<RC_Bordro__c> getBordroList(String bayiId, Date baslangic, Date bitis, String bordroNo){
        try {
            List<RC_Bordro__c> dealerRelatedBordroList = new List<RC_Bordro__c>();
            String query = 'SELECT Id, RC_Bordro_No__c, RC_Dealer_Number__c, RC_Bordro_Type__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, CreatedDate, (Select Id, RC_Check_Status_ID__c FROM Cheques__r) FROM RC_Bordro__c WHERE ((RC_Process_Type__c = \'01\' AND RC_Bordro_Type__c = \'C\') OR (RC_Process_Type__c = \'03\' AND RC_Bordro_Type__c = \'B\') OR (RC_Process_Type__c = \'03\' AND RC_Bordro_Type__c = \'Z\'))';

            String bayiKod = '';
            if(String.isNotBlank(bayiId)){
                bayiKod = [SELECT RC_SAP_ID__c FROM Account WHERE Id =: bayiId].RC_SAP_ID__c;
            }

            if(String.isNotBlank(bayiKod)){
                query += ' AND RC_Dealer_Number__c = \'' + bayiKod + '\' '; 
            }

            if(baslangic != null){
                query += ' AND CreatedDate >= ' + baslangic + ' ';
            }

            if(bitis != null){
                query += ' AND CreatedDate <= ' + bitis + ' ';
            }

            if(String.isNotBlank(bordroNo)){
                query += ' AND RC_Bordro_No__c = \'' + bordroNo + '\'';
            }

            dealerRelatedBordroList = Database.query(query);

            return dealerRelatedBordroList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ControlWrapper approve(String selectedBordroId, Decimal fark, Date girilenVade, Date bordroVade, String bayiId){
        ControlWrapper approveResult = new ControlWrapper();

        try {
            RC_Bordro__c bordro = [SELECT Id, RC_Bordro_No__c, RC_Process_Type__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, CreatedDate, RC_Bordro_Type__c, (SELECT RC_Amount__c, RC_Due_Date__c, RC_Cheque_Bill__c, RC_Bill_Number__c, RC_Cheque_Number__c, RC_Bank_Key__r.RC_BANKL__c, CreatedDate, RC_Bank_Key__r.RC_BANK__c, RC_Drawer_Region__c, RC_Bank_Key__r.RC_BRINCH__c FROM Cheques__r WHERE RC_Type__c = 'Cheque') FROM RC_Bordro__c WHERE Id =: selectedBordroId];

            String bordroType = bordro.RC_Bordro_Type__c;

            List<RC_Financial_Process_Definition__c> paramList = [SELECT RC_Bordro_No__C, RC_Amount_Negative__c, RC_Amount_Positive__c, RC_Due_Date_Negative__c, RC_Due_Date_Positive__c FROM RC_Financial_Process_Definition__c WHERE (RC_Bordro_No__c =: bordro.Id OR RC_Bordro_No__C = '') AND RC_Process_Type__c =: bordro.RC_Process_Type__c AND RecordType.DeveloperName = 'RC_Cheque_Parameters'];

            RC_Financial_Process_Definition__c param = null;
            if(paramList != null && paramList.size() > 0){
                if(paramList.size() == 1){
                    param = paramList.get(0);
                }
                else{
                    for(RC_Financial_Process_Definition__c p : paramList){
                        if(p.RC_Bordro_No__C == bordro.Id){
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

            List<Account> selectedBayi = null;

                    if(String.isBlank(bayiId))
                        selectedBayi = [SELECT Id FROM Account WHERE RC_Dealer_Type__c = 'BAYI' AND RC_SAP_ID__c =: bordro.RC_Dealer_Number__c];                       

                    if(selectedBayi != null && selectedBayi.size() > 0)
                        bayiId = selectedBayi.get(0).Id;

            ControlWrapper checkInputResult = checkInput(bordroType, fark, param);

            if(checkInputResult.isSuccess){
                ControlWrapper checkVadeValorResult = checkVadeValor(bordroType, girilenVade, bordroVade, param);

                if(checkVadeValorResult.isSuccess){
                    if(bordroType == 'C'){
                        for(RC_Cheques__c cheque : bordro.Cheques__r){
                            cheque.RC_Check_Status_ID__c = '2';
                        }

                        bordro.RC_Bordro_Status_ID__c = '2';

                        List<Database.SaveResult> chequeSaveResult = Database.update(bordro.Cheques__r, true);
                        for(Database.SaveResult sr : chequeSaveResult){
                            if(!sr.isSuccess()){
                                approveResult.isSuccess = false;
                                
                                for(Database.Error err : sr.getErrors()){
                                    approveResult.message += '|>| Message : ' + err.getMessage() + ' || Field : ' + err.getFields() + ' |<|';
                                }
                            }
                        }

                        if(approveResult.isSuccess){
                            Database.SaveResult bordroSaveResult = Database.update(bordro);
                            if(!bordroSaveResult.isSuccess()){
                                approveResult.isSuccess = false;
                                
                                for(Database.Error err : bordroSaveResult.getErrors()){
                                    approveResult.message += '|>| Message : ' + err.getMessage() + ' || Field : ' + err.getFields() + ' |<|';
                                }
                            } 
                        }

                        if(approveResult.isSuccess){
                            sendEmail(bordro, 'Hesap Kapama OÇT Çek bildirimi', bayiId);
                        }
                    }
                    else{
                        ControlWrapper checkVadeSystemResult = checkVadeSystem(selectedBordroId, girilenVade);

                        if(checkVadeSystemResult.isSuccess){
                            for(RC_Cheques__c cheque : bordro.Cheques__r){
                                cheque.RC_Check_Status_ID__c = '2';
                            }
    
                            bordro.RC_Bordro_Status_ID__c = '2';
    
                            List<Database.SaveResult> chequeSaveResult = Database.update(bordro.Cheques__r, true);
                            for(Database.SaveResult sr : chequeSaveResult){
                                if(!sr.isSuccess()){
                                    approveResult.isSuccess = false;
                                    
                                    for(Database.Error err : sr.getErrors()){
                                        approveResult.message += '|>| Message : ' + err.getMessage() + ' || Field : ' + err.getFields() + ' |<|';
                                    }
                                }
                            }
    
                            if(approveResult.isSuccess){
                                Database.SaveResult bordroSaveResult = Database.update(bordro);
                                if(!bordroSaveResult.isSuccess()){
                                    approveResult.isSuccess = false;
                                    
                                    for(Database.Error err : bordroSaveResult.getErrors()){
                                        approveResult.message += '|>| Message : ' + err.getMessage() + ' || Field : ' + err.getFields() + ' |<|';
                                    }
                                } 
                            }
    
                            if(approveResult.isSuccess){
                                sendEmail(bordro, 'Bağlantı OÇT Çek bildirimi', bayiId);
                            }
                        }
                        else{
                            approveResult = checkVadeSystemResult;
                        }
                    }
                }
                else{
                    approveResult.isSuccess = false;

                    if(bordroType == 'B'){
                        approveResult.message = 'Onaylı plan giriş ile gerçekleşen giriş uyumlu değildir. Kontrol ediniz.';
                    }
                    else{
                        approveResult.message = 'Girilen Çek Ortalama Vade Tarihi, Bordro Ortalama Vade Tarihinden farklıdır.';
                    }
                }
            }
            else{
                return checkInputResult;
            }

        } catch (Exception e) {
            approveResult.isSuccess = false;
            approveResult.message = 'Message : ' + e.getMessage() + ' |>| Stack Trace : ' + e.getStackTraceString();
        }

        return approveResult;
    }

    // Main Helper Methods
    @AuraEnabled
    public static Date getAverageMaturity(RC_Bordro__c bordro, Decimal cekToplam, Date cekOrtVade){
        
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
    public static List<RC_Cheque_Payment_Plan__c> getBordroRelatedPlans(Id selectedBordroId){
        
        List<RC_Cheque_Payment_Plan__c> paymentPlanList = new List<RC_Cheque_Payment_Plan__c>();

        if(String.isNotBlank(selectedBordroId)){
            paymentPlanList= [SELECT Id, RC_Payment_Plan_Due_Date__c, RC_Payment_Plan_Amount__c, RC_Payment_Plan_Number__c FROM RC_Cheque_Payment_Plan__c WHERE RC_Bordro__c =: selectedBordroId AND RC_Is_Created__c = false];
        }

        return paymentPlanList;
    }

    @AuraEnabled
    public static List<RC_Cheques__c> getBordroRelatedCheques(Id selectedBordroId){
        
            List<RC_Cheques__c> bordroRelatedChequeList = new List<RC_Cheques__c>();

            if(String.isNotBlank(selectedBordroId)){
                bordroRelatedChequeList = [
                    SELECT Id, RC_City__c, RC_City__r.Name, RC_Drawer_Region__c, RC_Due_Date__c, RC_Cheque_Bill__c, RC_Cheque_Number__c, RC_Amount__c, RC_Identification_Number__c, RC_Bank_Key__c, RC_Bank_Key__r.Name, RC_Bank_Key__r.RC_BANK__c, RC_Bank_Key__r.RC_BRINCH__c, RC_Bank_Key__r.RC_BANKL__c, RC_Bank_Account_Number__c, RC_IsSent__c, RC_Check_Status_ID__c, RC_Bill_Number__c
                    FROM RC_Cheques__c
                    WHERE RC_Type__c = 'Cheque' AND RC_Bordro__c =: selectedBordroId];
            } 

            return bordroRelatedChequeList;
    }

    @AuraEnabled
    public static List<RC_Cheques__c> getRelatedInvoice(Id selectedBordroId){
        List<RC_Cheques__c> relatedInvoiceList = new List<RC_Cheques__c>();

        if(String.isNotBlank(selectedBordroId)){
            relatedInvoiceList = [SELECT Id, RC_Description__c, RC_Statu__c, RC_Product_Info__c, RC_Due_Date__c, RC_Invoice_Number__c, RC_Amount__c FROM RC_Cheques__c WHERE RC_Type__c = 'Invoice' AND RC_Bordro__c =: selectedBordroId];
        }

        return relatedInvoiceList;
    }

    public static ControlWrapper checkInput(String bordroType, Decimal fark, RC_Financial_Process_Definition__c param){
        ControlWrapper result = new ControlWrapper();
        result.isSuccess = false;

        try {
            
            if(fark != 0 && (((-1 * fark) < param.RC_Amount_Negative__c) || ((-1 * fark) > param.RC_Amount_Positive__c))){                
                if(bordroType == 'B'){
                    result.message = 'Onaylı plan giriş ile gerçekleşen giriş uyumlu değildir. Kontrol ediniz.';
                }
                else{
                    result.message = 'Bakiye problem mevcut.';
                }
            }
            else{
                result.isSuccess = true;
            }
        } catch (Exception e) {
            result.isSuccess = false;
            result.message = 'Message : ' + e.getMessage() + ' |>| Stack Trace : ' + e.getStackTraceString();
        }

        return result;
    }

    public static ControlWrapper checkVadeValor(String bordroType, Date girilenVade, Date bordroVade, RC_Financial_Process_Definition__c param){
        ControlWrapper result = new ControlWrapper();
        System.debug('HV : ' + girilenVade + ' | GV : ' + bordroVade);
        try {
            if(girilenVade != null && bordroVade != null){
                Integer diff = (-1 * girilenVade.daysBetween(bordroVade));
                
                if((-1 * diff < param.RC_Due_Date_Negative__c || -1 * diff > param.RC_Due_Date_Positive__c) ){
                    result.isSuccess = false;
                    result.message = 'Vade kontrollerinde tutarsızlık çıktı.';
                }
            }
            else {
                result.isSuccess = false;
                result.message = 'Girilen ve Hesaplanan Vade bilgilerini kontrol ediniz.';                
            }
        } catch (Exception e) {
            result.isSuccess = false;
            result.message = 'Message : ' + e.getMessage() + ' |>| Stack Trace : ' + e.getStackTraceString();            
        }

        return result;
    }

    public static ControlWrapper checkVadeSystem(String bordroNo, Date girilenVade){
        ControlWrapper result = new ControlWrapper();
        
        try {
            List<RC_Financial_Process_Definition__c> baglantiList = [SELECT Id, RC_Term_ID__c, RC_Bordro_No__c, RC_KKA__c, RC_Account__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Entry' AND RC_Bordro_No__c =: bordroNo];

            if(baglantiList != null && baglantiList.size() > 0){
                RC_Financial_Process_Definition__c baglanti = baglantiList.get(0);

                List<RC_Financial_Process_Definition__c> foundedBaglantiList = [SELECT Id, RC_Bordro_No__r.RC_Bordro_No__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Entry' AND RC_Term_ID__c = :baglanti.RC_Term_ID__c AND RC_KKA__c = :baglanti.RC_KKA__c AND RC_Account__c = :baglanti.RC_Account__c AND RC_Bordro_No__c != :baglanti.RC_Bordro_No__c AND RC_Average_Due_Date__c != :girilenVade];

                if(foundedBaglantiList != null && foundedBaglantiList.size() > 0){
                    result.isSuccess = false;
                    result.message = 'Aynı döneme ait farklı ortalama vadeler girilemez. Bordro No : ' + foundedBaglantiList[0].RC_Bordro_No__r.RC_Bordro_No__c;
                }
            }
            else{
                result.isSuccess = false;
                result.message = 'Bağlantı bilgisi bulunamadı.';
            }
        } catch (Exception e) {
            result.isSuccess = false;
            result.message = 'Message : ' + e.getMessage() + ' |>| Stack Trace : ' + e.getStackTraceString();               
        }

        return result;
    }

    @AuraEnabled
    public static ControlWrapper insertChequeList(List<RC_Cheques__c> insertList){
        ControlWrapper cw = new ControlWrapper();
        cw.message = '';
        try {
            List<Database.UpsertResult> srList = Database.upsert(insertList, true);
            for(Database.UpsertResult sr : srList){
                if(!sr.isSuccess()){
                    cw.isSuccess = false;
                    
                    for(Database.Error err : sr.getErrors()){
                        cw.message += '|| Field : ' + err.getFields() + ' Message : ' + err.getMessage();
                    }
                }
            }
        } catch (Exception e) {
            cw.isSuccess = false;
            cw.message = e.getMessage();
        }

        return cw;
    }

    @AuraEnabled
    public static string validateInput(RC_Cheques__c data){
        String message = '';
        system.debug(data);
        try {
            if(data.RC_Cheque_Bill__c == 'Bill'){
                if(data.RC_Amount__c == null || data.RC_Amount__c == 0){
                    message += 'Senet tutarını giriniz. ';
                }
                if(data.RC_Due_Date__c == null){
                    message += 'Senet tarihini giriniz. ';
                }
                if(String.isBlank(data.RC_Account_No__c)){
                    message += 'Müşteri kodunu giriniz. ';
                }
                if(String.isBlank(data.RC_Identification_Number__c)){
                    message += 'TCKN/VKN numarasını giriniz. ';
                }
                else{
                    if(data.RC_Identification_Number__c.length() > 11 && data.RC_Identification_Number__c.length() < 10){                        
                        message += 'TCKN/VKN numarası 11 karakterden uzun, 10 karakterden kısa olamaz.';
                    }
                }
            }
            else if(data.RC_Cheque_Bill__c == 'Cheque'){
                if(String.isNotBlank(data.RC_Cheque_Number__c)){
                    if(data.RC_Cheque_Number__c.length() > 7){
                        message += 'Çek numarası 7 karakterden büyük olamaz. ';
                    }
                }
                else{
                    message += 'Lütfen çek numarasını giriniz. ';
                }

                if(data.RC_Amount__c == null || data.RC_Amount__c == 0){
                    message += 'Çek tutarını giriniz. ';
                }

                if(data.RC_Due_Date__c < Date.today().addDays(5)){
                    message += 'Girilen çek tarihi 5 günden erken olamaz. ';
                }
                // Banka Anahtarı kontrolü eklenecek
                
                if(String.isBlank(data.RC_Account_No__c)){
                    message += 'Müşteri kodunu giriniz. ';
                }

                if(String.isBlank(data.RC_Identification_Number__c)){
                    message += 'TCKN/VKN numarasını giriniz. ';
                }
                else{
                    if(data.RC_Identification_Number__c.length() > 11 && data.RC_Identification_Number__c.length() < 10){                        
                        message += 'TCKN/VKN numarası 11 karakterden uzun, 10 karakterden kısa olamaz.';
                    }
                }

                if(String.isBlank(data.RC_Bank_Account_Number__c)){
                    message += 'Banka hesap numarasını giriniz.';
                }

                if(String.isBlank(data.RC_Drawer_Region__c)){
                    message += 'Keşideci bölgesi bilgisini giriniz. ';
                }

                //List<RC_Cheques__c> foundedDataList = [SELECT Id FROM RC_Cheques__c WHERE RC_Bank_Account_Number__c =: data.RC_Bank_Account_Number__c OR RC_Cheque_Number__c =: data.RC_Cheque_Number__c];
                List<RC_Cheques__c> foundedDataList = [SELECT Id FROM RC_Cheques__c WHERE RC_Bank_Key__c =: data.RC_Bank_Key__c and  RC_Cheque_Number__c =: data.RC_Cheque_Number__c];
    
                if(foundedDataList != null && foundedDataList.size() > 0){
                    message += 'Girilen Çek Numarası ve Banka Anahtarı sistemde mevcut.';
                }
            }
        } catch (Exception e) {
            message = e.getMessage();
        }

        return message;
    }

    // Helper Methods
    private static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);

        return guid;
    }

    public static Boolean sendEmail(RC_Bordro__c bordro, String subject, String bayiId){
        Account acc = [SELECT Id, Name, RC_SAP_ID__c FROM Account WHERE Id =: bayiId];

        String body = 'Bayi No : ' + acc.RC_SAP_ID__c + '<br /><br />' + 
        'Bayi Adı : ' + acc.Name + '<br /><br />' + 
        'Bordro Numarası : ' + bordro.RC_Bordro_No__c + '<br /><br /><br />';
        
        List<String> toAddress = new List<String>{'tugce.tanyeri@zorlu.com'};
        
        String mailBody = '<table style=\'border:1px solid #e6e6e6;font-size:12px\'>' + 
        '<tr>' + '<th style=\'border:1px solid #e6e6e6;\'>Tarih</th>' +
           '<th style=\'border:1px solid #e6e6e6;\'>Çek Numarası</th>' +
           '<th style=\'border:1px solid #e6e6e6;\'>Banka</th>' +
           '<th style=\'border:1px solid #e6e6e6;\'>Şube</th>' +
           '<th style=\'border:1px solid #e6e6e6;\'>Keşide Yeri</th>' +
           '<th style=\'border:1px solid #e6e6e6;\'>Tutar</th>' +
           '<th style=\'border:1px solid #e6e6e6;\'>Vade Tarihi</th></tr>';

        Decimal total = 0;
        for(RC_Cheques__c c : bordro.Cheques__r){            
            System.debug('ÇEK : ' + c);
            mailBody += '<tr>';
            mailBody += '<td style=\'border:1px solid #e6e6e6;\'>' + c.CreatedDate.format('dd.MM.yyyy') + '</td>';            
            
            mailBody += '<td style=\'border:1px solid #e6e6e6;\'>' +  c.RC_Cheque_Number__c + '</td>';
            
            if(c.RC_Bank_Key__c != null){
                mailBody += '<td style=\'border:1px solid #e6e6e6;\'>' + c.RC_Bank_Key__r.RC_BANK__c + '</td>';
            }
            else{                
                mailBody += '<td style=\'border:1px solid #e6e6e6;\'>-</td>';
            }
            
            if(c.RC_Bank_Key__c != null){
                mailBody += '<td style=\'border:1px solid #e6e6e6;\'>' + c.RC_Bank_Key__r.RC_BRINCH__c + '</td>';
            }
            else{                
                mailBody += '<td style=\'border:1px solid #e6e6e6;\'>-</td>';
            }
            
            if(String.isNotBlank(c.RC_Drawer_Region__c)){
                mailBody += '<td style=\'border:1px solid #e6e6e6;\'>' + c.RC_Drawer_Region__c + '</td>';
            }
            else{
                mailBody += '<td style=\'border:1px solid #e6e6e6;\'>-</td>';                
            }
            
            mailBody += '<td style=\'border:1px solid #e6e6e6;\'>' + c.RC_Amount__c + ' ' + '</td>';            
            mailBody += '<td style=\'border:1px solid #e6e6e6;\'>' + Datetime.newInstance(c.RC_Due_Date__c.year(), c.RC_Due_Date__c.month(), c.RC_Due_Date__c.day()).format('dd.MM.yyyy') + '</td></tr>';
            
            total += c.RC_Amount__c;
        }

        mailBody +='<tr><td colspan="3"></td><td></td><td><b>Genel Toplam</b></td><td>' + total + '</td><td></td></tr>';
        mailBody +='<tr><td colspan="3"></td><td></td><td><b>Ortalama Vade</b></td><td></td><td>' + Datetime.newInstance(bordro.RC_Average_Due_Date__c.year(), bordro.RC_Average_Due_Date__c.month(), bordro.RC_Average_Due_Date__c.day()).format('dd.MM.yyyy') + '</td></tr>';

        mailBody += '</table><br />';
        body += mailBody;

        Messaging.SingleEmailMessage preparedMail = new Messaging.SingleEmailMessage();
        preparedMail.setToAddresses(toAddress);
        preparedMail.setSubject(subject);
        preparedMail.setHtmlBody(body);

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        messages.add(preparedMail);

        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        return results[0].success;
    }

    // Input Methods
    @AuraEnabled
    public static string bayiKodCheck(String bayiKod){
        String bayiAd = '';

        if(String.isNotBlank(bayiKod)){
            List<AggregateResult> dataCheck = Database.query(String.format('SELECT count(Id) dataCount FROM Account WHERE RC_Dealer_Type__c = \'BAYI\' AND RC_SAP_ID__c LIKE \'%{0}%\'', new List<String>{bayiKod}));

            if(dataCheck != null && dataCheck.size() > 0){
                Integer dataCount = (Integer)dataCheck.get(0).get('dataCount');

                if(dataCount == 1){
                    List<Account> foundedAccount = Database.query(String.format('SELECT Name FROM Account WHERE RC_Dealer_Type__c = \'BAYI\' AND RC_SAP_ID__c LIKE \'%{0}%\'', new List<String>{bayiKod}));

                    if(foundedAccount != null && foundedAccount.size() == 1)
                        bayiAd = foundedAccount.get(0).Name;
                }
            }
        }

        return bayiAd;
    }
    
    @AuraEnabled
    public static List<RC_Bank_Informations__c> getBankInfosByCity(String cityId, String searchedKey){
        List<RC_Bank_Informations__c> bankList = new List<RC_Bank_Informations__c>();

        if(String.isNotBlank(cityId)){
            String query = 'SELECT Id, RC_BANKL__c, RC_BANK__c, RC_BRINCH__c FROM RC_Bank_Informations__c WHERE RC_ORT01__c = \'' + cityId + '\' AND RC_BANK__c LIKE \'%' + searchedKey.toUpperCase() + '%\' LIMIT 8';
            system.debug('Query : ' + query);
            bankList = Database.query(query);


        }

        return bankList;
    }

    @AuraEnabled
    public static List<SelectOptionWrapper> getCitySelectOption(){
        List<SelectOptionWrapper> preparedList = new List<SelectOptionWrapper>();

        for(RC_City_Region__c cr : [SELECT Id, Name, RC_Code__c FROM RC_City_Region__c WHERE RC_Type__c = 'City' ORDER BY Name]){            
            SelectOptionWrapper sow = new SelectOptionWrapper();
            sow.label = cr.Name;
            sow.value = cr.Id;

            preparedList.add(sow);
        }

        return preparedList;
    }

    @AuraEnabled
    public static List<SelectOptionWrapper> getRegionSelectOption(String cityId){
        List<SelectOptionWrapper> preparedList = new List<SelectOptionWrapper>();

        for(RC_City_Region__c cr : [SELECT Id, Name, RC_Code__c FROM RC_City_Region__c WHERE RC_Type__c = 'Region' AND RC_City__c =: cityId ORDER BY Name]){            
            SelectOptionWrapper sow = new SelectOptionWrapper();
            sow.label = cr.Name;
            sow.value = cr.Id;

            preparedList.add(sow);
        }

        return preparedList;
    }

    @AuraEnabled
    public static List<SelectOptionWrapper> getBayiSelectOption(String cityId, String regionId){
        List<SelectOptionWrapper> preparedList = new List<SelectOptionWrapper>();

        for(Account acc : [SELECT Id, Name, RC_SAP_ID__c FROM Account WHERE RC_Dealer_Type__c = 'BAYI' AND RC_City__c =: cityId AND RC_Region__c =: regionId ORDER BY Name]){            
            SelectOptionWrapper sow = new SelectOptionWrapper();
            sow.label = acc.Name;
            sow.value = acc.Id;
            sow.code = acc.RC_SAP_ID__c;

            preparedList.add(sow);
        }

        return preparedList;
    }

    @AuraEnabled
    public static ControlWrapper deleteBordro(String bordroId){
        ControlWrapper cw = new ControlWrapper();
        try {
            system.debug('Bordro ID : ' + bordroId); 
            
            RC_Bordro__c bordro = [SELECT Id, RC_Bordro_No__c FROM RC_Bordro__c WHERE Id =: bordroId];

            BordroSilRequestWrapper bsrw = new BordroSilRequestWrapper();
            ItemWrapper iw = new ItemWrapper();
            iw.BORDRO = bordro.RC_Bordro_No__c;

            bsrw.T_BORDRO.item.add(iw);
            
            Map<String, String> header = new Map<String, String>();
            header.put('Content-Type', 'application/json');

            HttpResponse response = SAPServiceIntegrator.callSAPService('RESTAdapter/salesforce/fi_bordro_sil', header, 'POST', JSON.serialize(bsrw, true));

            if(response.getStatusCode() == 200){
                BordroSilResponseWrapper parsedResponse = (BordroSilResponseWrapper)JSON.deserialize(response.getBody(), BordroSilResponseWrapper.class);

                if(parsedResponse.DURUM == 'OK'){
                    Database.DeleteResult dr = Database.delete(bordro);
                    if(dr.isSuccess()){
                        cw.isSuccess = true;
                    }
                    else{
                        for(Database.Error err : dr.getErrors()){
                            cw.isSuccess = false;
                            cw.message = err.getMessage();
                        }
                    }
                }
            }
            else{
                cw.isSuccess = false;
                cw.message = response.getBody();
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage() + ' | ' + e.getStackTraceString());
        }

        return cw;
    }

    @AuraEnabled
    public static StatuWrapper getStatus(){
        List<SelectOptionWrapper> bordroStatuList = new List<SelectOptionWrapper>();
        Schema.DescribeFieldResult fieldResult = RC_Bordro__c.RC_Bordro_Status_ID__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            SelectOptionWrapper sow = new SelectOptionWrapper();
            sow.label = pickListVal.getLabel();
            sow.value = pickListVal.getValue();
            bordroStatuList.add(sow);
        }

        List<SelectOptionWrapper> cekStatuList = new List<SelectOptionWrapper>();
        Schema.DescribeFieldResult fieldResult1 = RC_Cheques__c.RC_Check_Status_ID__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple1){
            SelectOptionWrapper sow = new SelectOptionWrapper();
            sow.label = pickListVal.getLabel();
            sow.value = pickListVal.getValue();
            cekStatuList.add(sow);
        }

        List<SelectOptionWrapper> chequeTypeList = new List<SelectOptionWrapper>();
        Schema.DescribeFieldResult fieldResult2 = RC_Cheques__c.RC_Cheque_Bill__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple2){
            SelectOptionWrapper sow = new SelectOptionWrapper();
            sow.label = pickListVal.getLabel();
            sow.value = pickListVal.getValue();
            chequeTypeList.add(sow);
        }

        StatuWrapper sw = new StatuWrapper();
        sw.bordroStatus = bordroStatuList;
        sw.cekStatus = cekStatuList;
        sw.chequeTypes = chequeTypeList;

        return sw;
    }

    @AuraEnabled
    public static ParameterWrapper getParams(String selectedBordroId, String bayiId){
        ParameterWrapper sw = new ParameterWrapper();

        RC_Bordro__c bordro = [SELECT Id, RC_Bordro_No__c, RC_Process_Type__c, RC_Dealer_Number__c, RC_Average_Due_Date__c, RC_Amount__c, RC_Bordro_Status_ID__c, CreatedDate, RC_Bordro_Type__c, (SELECT RC_Amount__c, RC_Due_Date__c, RC_Cheque_Bill__c, RC_Bill_Number__c, RC_Cheque_Number__c, RC_Bank_Key__r.RC_BANKL__c, CreatedDate, RC_Bank_Key__r.RC_BANK__c, RC_Drawer_Region__c, RC_Bank_Key__r.RC_BRINCH__c FROM Cheques__r WHERE RC_Type__c = 'Cheque') FROM RC_Bordro__c WHERE Id =: selectedBordroId];

        String bordroType = bordro.RC_Bordro_Type__c;

        List<RC_Financial_Process_Definition__c> paramList = [SELECT RC_Bordro_No__C, RC_Amount_Negative__c, RC_Amount_Positive__c, RC_Due_Date_Negative__c, RC_Due_Date_Positive__c FROM RC_Financial_Process_Definition__c WHERE (RC_Bordro_No__c =: bordro.Id OR RC_Bordro_No__C = '') AND RC_Process_Type__c =: bordro.RC_Process_Type__c AND RecordType.DeveloperName = 'RC_Cheque_Parameters'];

        RC_Financial_Process_Definition__c param = null;
        if(paramList != null && paramList.size() > 0){
            if(paramList.size() == 1){
                param = paramList.get(0);
            }
            else{
                for(RC_Financial_Process_Definition__c p : paramList){
                    if(p.RC_Bordro_No__C == bordro.Id){
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

        List<Account> selectedBayi = null;

                    if(String.isNotBlank(bayiId))
                        selectedBayi = [SELECT RC_Tax_Number__c FROM Account WHERE Id =: bayiId];
                    else
                        selectedBayi = [SELECT RC_Tax_Number__c FROM Account WHERE RC_Dealer_Type__c = 'BAYI' AND RC_SAP_ID__c =: bordro.RC_Dealer_Number__c];

                    if(selectedBayi != null && selectedBayi.size() > 0)
                        sw.bayiTaxNumber = selectedBayi.get(0).RC_Tax_Number__c;


        sw.positiveAmount = param.RC_Amount_Positive__c;
        sw.negativeAmount = param.RC_Amount_Negative__c;

        return sw;
    }

    // Custom Model's For Processes
    public class InitializePlan{
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
        public GeneralInfo generalInfo {get; set;}
        @AuraEnabled
        public String message {get; set;}
    }

    public class ParameterWrapper{
        @AuraEnabled
        public decimal positiveAmount {get; set;}
        @AuraEnabled
        public decimal negativeAmount {get; set;}
        @AuraEnabled
        public String bayiTaxNumber {get; set;}
    }

    public class StatuWrapper{
        @AuraEnabled
        public List<SelectOptionWrapper> bordroStatus {get; set;}
        @AuraEnabled
        public List<SelectOptionWrapper> cekStatus {get; set;}
        @AuraEnabled
        public List<SelectOptionWrapper> chequeTypes {get; set;}
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
        public RC_Financial_Process_Definition__c octTutarFark {get; set;}

        public GeneralInfo(){
            this.bordroTutar = 0;
            this.girilenTutar = 0;
            this.hesaplananTutar = 0;
            this.farkTutar = 0;
        }
    }

    public class SelectOptionWrapper{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
        @AuraEnabled
        public String code {get; set;}
    }

    public class BordroSilRequestWrapper{
        public BordroWrapper T_BORDRO {get; set;}

        public BordroSilRequestWrapper(){
            this.T_BORDRO = new BordroWrapper();
        }
    }

    public class BordroSilResponseWrapper{
        public String DURUM {get; set;}
    }

    public class BordroWrapper{
        public List<ItemWrapper> item {get; set;}

        public BordroWrapper(){
            this.item = new List<ItemWrapper>();
        }
    }

    public class ItemWrapper{
        public String BORDRO {get; set;}
    }
}