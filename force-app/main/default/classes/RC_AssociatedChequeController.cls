public with sharing class RC_AssociatedChequeController {
    
    private static Date keyDate = Date.today().addYears(-1);
    
    public RC_AssociatedChequeController() {}
    
    @AuraEnabled
    public static InitialWrapper initComponent(){
        InitialWrapper init = new InitialWrapper();
        
        try {
            List<RC_Financial_Process_Definition__c> krediKontrol = getCreditControls(null);
            List<RC_Financial_Process_Definition__c> baglantiDonem = getBaglantiCariDonem(null);
            List<RC_Financial_Process_Definition__c> odemeKosul = getPaymentTypes();
            List<RC_SD_Organization__c> dealer = getUserDealers(null, null);
            
            if(krediKontrol != null && krediKontrol.size() > 0){
                SelectOptionWrapper empty = new SelectOptionWrapper(
                    'Hepsi',
                    'all',
                    ''
                );
                init.krediKontrol.add(empty);
                for(RC_Financial_Process_Definition__c kk : krediKontrol){
                    SelectOptionWrapper sow = new SelectOptionWrapper(
                        String.format('{0} - {1}', new List<String>{kk.RC_KKA__c, kk.RC_KKA_Defination__c}),
                        kk.RC_KKA__c,
                        ''
                    );
                    
                    init.krediKontrol.add(sow);
                }
            }
            
            if(baglantiDonem != null && baglantiDonem.size() > 0){
                SelectOptionWrapper empty = new SelectOptionWrapper(
                    'Hepsi',
                    'all',
                    ''
                );
                init.baglantiDonem.add(empty);
                for(RC_Financial_Process_Definition__c bd : baglantiDonem){
                    SelectOptionWrapper sow = new SelectOptionWrapper(
                        String.format('{0} - {1}', new List<String>{bd.RC_Payment_Form__c, bd.RC_Comments__c}),
                        bd.Id,
                        ''
                    );
                    
                    init.baglantiDonem.add(sow);
                }
            }
            
            if(dealer != null && dealer.size() > 0){
                SelectOptionWrapper empty = new SelectOptionWrapper(
                    'Hepsi',
                    'all',
                    ''
                );
                init.bayi.add(empty);
                for(RC_SD_Organization__c d : dealer){
                    SelectOptionWrapper sow = new SelectOptionWrapper(
                        d.RC_Account__r.Name,
                        d.RC_Account__c,
                        ''
                    );
                    
                    init.bayi.add(sow);
                }
            }          
            
            String paramYansit = Cheque_Parameters__c.getValues('BaglantiGunFarkPlanYansitma').Value__c;

            List<RC_Financial_Process_Definition__c> paramList = [SELECT RC_Bordro_No__C, RC_Amount_Negative__c, RC_Amount_Positive__c, RC_Due_Date_Negative__c, RC_Due_Date_Positive__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'RC_Cheque_Parameters' AND RC_Process_Type__c = '03'];

            RC_Financial_Process_Definition__c param = null;
            if(paramList != null && paramList.size() > 0){
                param = paramList.get(0);
            }

            if(paramYansit == '1'){
                if(param != null){
                    init.paramNegative = Integer.valueOf(param.RC_Due_Date_Negative__c);
                    init.paramPositive = Integer.valueOf(param.RC_Due_Date_Positive__c);
                }
                else{
                    init.paramNegative = 7;
                    init.paramPositive = -7;
                }
            }
            else{
                init.paramNegative = 0;
                init.paramPositive = 0;
            }
            
            User currentUser = [SELECT UserRoleId, UserRole.DeveloperName FROM User WHERE Id =: UserInfo.getUserId()];
            if(currentUser.UserRoleId != null && currentUser.UserRole.DeveloperName == 'Bayi_Satis_Uzmani'){
                init.isSatisUzmani = true;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        return init;
    }
    
    @AuraEnabled
    public static ResultWrapper searchData(String bayiId, String krediKontrolCode, String baglantiDonemId){
        Integer negativeDay = 0;
        Integer positiveDay = 0;
        
        //Sorulacak
        String paramYansit = Cheque_Parameters__c.getValues('BaglantiGunFarkPlanYansitma').Value__c;

            List<RC_Financial_Process_Definition__c> paramList = [SELECT RC_Bordro_No__C, RC_Amount_Negative__c, RC_Amount_Positive__c, RC_Due_Date_Negative__c, RC_Due_Date_Positive__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'RC_Cheque_Parameters' AND RC_Process_Type__c = '03'];

            RC_Financial_Process_Definition__c param = null;
            if(paramList != null && paramList.size() > 0){
                param = paramList.get(0);
            }

            if(paramYansit == '1'){
                if(param != null){
                    negativeDay = Integer.valueOf(param.RC_Due_Date_Negative__c);
                    positiveDay = Integer.valueOf(param.RC_Due_Date_Positive__c);
                }
                else{
                    negativeDay = 7;
                    positiveDay = -7;
                }
            }
            else{
                negativeDay = 0;
                positiveDay = 0;
            }
        
        ResultWrapper rw = new ResultWrapper();
        List<MainDataWrapper> result = new List<MainDataWrapper>();
        List<String> selectedBayi = String.isNotBlank(bayiId) ? new List<String>{bayiId} : null;
        List<String> selectedKrediKontrol = String.isNotBlank(krediKontrolCode) ? new List<String>{krediKontrolCode} : null;
        List<String> selectedBaglantiDonem = String.isNotBlank(baglantiDonemId) ? new List<String>{baglantiDonemId} : null;
        
        /*
Süreçte Kullanılan Ana Veri
*/
        List<RC_Financial_Process_Definition__c> odemeKosulList = getPaymentTypes();            
        List<RC_Financial_Process_Definition__c> paymentFormList = getPaymentForms();
        List<RC_Financial_Process_Definition__c> bordroTipList = getBordroTypes();
        List<RC_Financial_Process_Definition__c> krediKontrolList = getCreditControls(selectedKrediKontrol);
        
        List<RC_Financial_Process_Definition__c> cariDonemList =  getBaglantiCariDonem(selectedBaglantiDonem);            
        
        List<String> donemIDList = new List<String>();
        for(RC_Financial_Process_Definition__c cd : cariDonemList){
            donemIDList.add(cd.Id);
        }
        
        Map<String, List<String>> cariDonemKosulMap = new Map<String, List<String>>();
        List<RC_Financial_Process_Definition__c> cariDonemOdemeKosulList = getCariDonemOdemeKosul(donemIDList);
        for(RC_Financial_Process_Definition__c cdokl : cariDonemOdemeKosulList){                
            List<String> relatedOdemeKosul = new List<String>();
            
            if(cariDonemKosulMap.containsKey(cdokl.RC_Term_ID__c)){
                relatedOdemeKosul = cariDonemKosulMap.get(cdokl.RC_Term_ID__c);
            }
            
            relatedOdemeKosul.add(cdokl.RC_Payment_Term__c);
            cariDonemKosulMap.put(cdokl.RC_Term_ID__c, relatedOdemeKosul);
        }
        
        
        Set<String> bordroTipKeySet = new Set<String>();
        Map<String, List<RC_Financial_Process_Definition__c>> cariDonemBordroTypeMap = new Map<String, List<RC_Financial_Process_Definition__c>>();
        List<RC_Financial_Process_Definition__c> cariDonemBordroTipList = getCariDonemBordroType(donemIDList);
        for(RC_Financial_Process_Definition__c cdbtl : cariDonemBordroTipList){                
            List<RC_Financial_Process_Definition__c> relatedBordroType = new List<RC_Financial_Process_Definition__c>();
            
            if(cariDonemBordroTypeMap.containsKey(cdbtl.RC_Term_ID__c)){
                relatedBordroType = cariDonemBordroTypeMap.get(cdbtl.RC_Term_ID__c);
            }
            
            bordroTipKeySet.add(cdbtl.RC_Bordro_Types__c);
            
            relatedBordroType.add(cdbtl);
            cariDonemBordroTypeMap.put(cdbtl.RC_Term_ID__c, relatedBordroType);
        }
        
        Map<String, List<RC_Financial_Process_Definition__c>> cariDonemKrediKontrolMap = new Map<String, List<RC_Financial_Process_Definition__c>>();
        List<RC_Financial_Process_Definition__c> cariDonemKrediKontrolList = getCariDonemKrediKontrol(donemIDList);
        for(RC_Financial_Process_Definition__c cdkkl : cariDonemKrediKontrolList){                
            List<RC_Financial_Process_Definition__c> relatedKrediKontrol = new List<RC_Financial_Process_Definition__c>();
            
            if(cariDonemKrediKontrolMap.containsKey(cdkkl.RC_Term_ID__c)){
                relatedKrediKontrol = cariDonemKrediKontrolMap.get(cdkkl.RC_Term_ID__c);
            }
            
            relatedKrediKontrol.add(cdkkl);
            cariDonemKrediKontrolMap.put(cdkkl.RC_Term_ID__c, relatedKrediKontrol);
        }
        
        List<RC_SD_Organization__c> bilgiler = getUserDealers(selectedBayi, selectedKrediKontrol);
        
        if(bilgiler != null && bilgiler.size() > 0){
            /*
Süreçte İhtiyaç Duyulan Mappingler
*/
            Map<String, String> approvalStatuMap = new Map<String, String>();
            for(RC_Financial_Process_Definition__c fpd : getApprovalStatus()){
                approvalStatuMap.put(fpd.RC_SAP_ID__c, fpd.RC_Text__c);
            }
            
            Map<String, String> bordroStatuMap = new Map<String, String>();
            for(RC_Financial_Process_Definition__c fpd : getBordroStatus()){
                bordroStatuMap.put(fpd.RC_SAP_ID__c, fpd.RC_Text__c);
            }                
            
            Map<String, RC_Financial_Process_Definition__c> odemeKosulMap = new Map<String, RC_Financial_Process_Definition__c>();
            for(RC_Financial_Process_Definition__c ok : odemeKosulList){
                odemeKosulMap.put(ok.RC_Payment_Term__c, ok);
            }
            
            Map<String, RC_Financial_Process_Definition__c> paymentFormMap = new Map<String, RC_Financial_Process_Definition__c>();
            for(RC_Financial_Process_Definition__c pf : paymentFormList){
                paymentFormMap.put(pf.RC_Fiscal_Year__c + pf.RC_Payment_Form__c, pf);
            }                
            
            Map<String, RC_Financial_Process_Definition__c> krediKontrolMap = new Map<String, RC_Financial_Process_Definition__c>();
            for(RC_Financial_Process_Definition__c kk : krediKontrolList){
                krediKontrolMap.put(kk.RC_KKA__c, kk);
            }
            
            Map<String, RC_Financial_Process_Definition__c> bordroTipMap = new Map<String, RC_Financial_Process_Definition__c>();
            for(RC_Financial_Process_Definition__c bt : bordroTipList){
                bordroTipMap.put(bt.RC_Bordro_Types__c, bt);
            }             
            
            List<String> bayiIDList = new List<String>();
            for(RC_SD_Organization__c sdo : bilgiler){
                bayiIDList.add(sdo.RC_Account__c);
            }
            
            List<RC_Financial_Process_Definition__c> baglantiBordroGiris = getBaglantiBordroGiris(bayiIDList, donemIDList, krediKontrolMap.keySet(), bordroTipKeySet);
            
            Decimal genelTutar = 0;
            Decimal genelAdat = 0;
            
            Map<String, Map<String, List<RC_Financial_Process_Definition__c>>> baglantiBordroGirisMap = new Map<String, Map<String, List<RC_Financial_Process_Definition__c>>>();
            for(RC_Financial_Process_Definition__c bbg : baglantiBordroGiris){
                genelTutar += bbg.RC_Amount__c;
                genelAdat += bbg.RC_Average_Due_Date__c != null ? (-1 * bbg.RC_Average_Due_Date__c.daysBetween(keyDate) * bbg.RC_Amount__c) : 0;
                
                String code = String.format('{0}-{1}-{2}-{3}', new List<String>{bbg.RC_Account__c, bbg.RC_Bordro_Types__c, bbg.RC_Term_ID__c, bbg.RC_KKA__c});
                
                if(baglantiBordroGirisMap.containsKey(bbg.RC_Account__c)){
                    Map<String, List<RC_Financial_Process_Definition__c>> baglantiMap = baglantiBordroGirisMap.get(bbg.RC_Account__c);
                    
                    if(baglantiMap.containsKey(code)){
                        List<RC_Financial_Process_Definition__c> baglantiList = baglantiMap.get(code);
                        baglantiList.add(bbg);
                        
                        baglantiMap.put(code, baglantiList);                        
                        baglantiBordroGirisMap.put(bbg.RC_Account__c, baglantiMap);
                    }
                    else{
                        List<RC_Financial_Process_Definition__c> baglantiList = new List<RC_Financial_Process_Definition__c>();
                        baglantiList.add(bbg);
                        
                        baglantiMap.put(code, baglantiList);
                        baglantiBordroGirisMap.put(bbg.RC_Account__c, baglantiMap);
                    }
                }
                else{
                    List<RC_Financial_Process_Definition__c> baglantiList = new List<RC_Financial_Process_Definition__c>();
                    baglantiList.add(bbg);
                    
                    Map<String, List<RC_Financial_Process_Definition__c>> baglantiMap = new Map<String, List<RC_Financial_Process_Definition__c>>();
                    baglantiMap.put(code, baglantiList);
                    baglantiBordroGirisMap.put(bbg.RC_Account__c, baglantiMap);
                }
            }
            
            /*
Ana Süreç Başlangıç
*/               
            
            rw.genelTutar = genelTutar;
            rw.genelOrtVade = genelTutar != 0 ? keyDate.addDays(Integer.valueOf(genelAdat / genelTutar)) : null;
            
            List<MainDataWrapper> mdwList = new List<MainDataWrapper>();
            Integer mainId = 0;
            for(RC_SD_Organization__c sdo : bilgiler){
                
                Decimal headerTutar = 0;
                Decimal headerAdat = 0;
                MainDataWrapper mdw = new MainDataWrapper();
                
                Map<String, List<RC_Financial_Process_Definition__c>> baglantiMap = baglantiBordroGirisMap.get(sdo.RC_Account__c);
                
                List<ChildWrapper> childs = new List<ChildWrapper>();
                Integer childId = 0;
                for(RC_Financial_Process_Definition__c cd : cariDonemList){
                    RC_Financial_Process_Definition__c paymentForm = paymentFormMap.get(cd.RC_Payment_Form__c);
                    
                    List<SelectOptionWrapper> odemeKosulOptions = new List<SelectOptionWrapper>();
                    for(String odemeKosul : cariDonemKosulMap.get(cd.Id)){
                        RC_Financial_Process_Definition__c ok = odemeKosulMap.containsKey(odemeKosul) ? odemeKosulMap.get(odemeKosul) : null;
                        
                        if(ok != null){
                            SelectOptionWrapper sow = new SelectOptionWrapper(
                                ok.RC_Payment_Term__c,
                                ok.Id,
                                String.valueOf(ok.RC_Expiry__c)
                            );
                            
                            odemeKosulOptions.add(sow);
                        }
                    }
                    
                    List<String> relatedKrediKontrolList = new List<String>();
                    for(RC_Financial_Process_Definition__c cdkk : cariDonemKrediKontrolMap.get(cd.Id)){
                        relatedKrediKontrolList.add(cdkk.RC_KKA__c);
                    }
                    
                    for(String krediKontrol : relatedKrediKontrolList){
                        RC_Financial_Process_Definition__c kk = krediKontrolMap.get(krediKontrol);
                        
                        if(kk == null) 
                            continue;
                        else{
                            if(kk.RC_Sales_Organization__c != sdo.RC_Sales_Organization__c || kk.RC_Distribution_Channel__c.right(2) != sdo.Distribution_Channel__c) {
                                continue;
                            }
                        }
                        
                        List<String> relatedBordroTypeList = new List<String>();
                        for(RC_Financial_Process_Definition__c cdbt : cariDonemBordroTypeMap.get(cd.Id)){
                            relatedBordroTypeList.add(cdbt.RC_Bordro_Types__c);
                        }
                        
                        for(String bordroTip : relatedBordroTypeList){
                            ChildWrapper child = new ChildWrapper();
                            
                            RC_Financial_Process_Definition__c bordroType = bordroTipMap.get(bordroTip);
                            
                            if(bordroType.RC_Bordro_Types__c == 'D' && !sdo.RC_Account__r.RC_IsDTS__c)
                                continue;
                            
                            String code = String.format('{0}-{1}-{2}-{3}', new List<String>{sdo.RC_Account__c, bordroTip, cd.Id, kk.RC_KKA__c});
                            
                            List<RC_Financial_Process_Definition__c> baglantiGirisList = baglantiMap != null && baglantiMap.containsKey(code) ? baglantiMap.get(code) : null;
                            
                            RC_Financial_Process_Definition__c latestBaglanti = null;
                            Decimal mainTutar = 0.00;
                            if(baglantiGirisList != null && baglantiGirisList.size() > 0){
                                latestBaglanti = baglantiGirisList.get(baglantiGirisList.size() - 1);
                                
                                for(RC_Financial_Process_Definition__c bge : baglantiGirisList){
                                    headerTutar += bge.RC_Amount__c;
                                    headerAdat += bge.RC_Average_Due_Date__c != null ? (-1 * bge.RC_Average_Due_Date__c.daysBetween(keyDate)) * bge.RC_Amount__c : 0;
                                    mainTutar += bge.RC_Amount__c;
                                }  
                            }
                            
                            child.Id = childId;
                            child.bayiNo =   sdo.RC_Account__r.RC_SAP_ID__c;
                            child.bayiId = sdo.RC_Account__c;
                            child.readonly = false;
                            child.canDelete = false;
                            child.showHistory = false;
                            
                            if(latestBaglanti != null){
                                child.aciklama = latestBaglanti.RC_Comments__c;
                                child.onayDurum = approvalStatuMap.get(latestBaglanti.RC_Approval_Status__c);
                                child.bordroDurum = bordroStatuMap.get(latestBaglanti.RC_Bordro_Status__c);
                                child.entityId = latestBaglanti.Id;
                                child.baglantiBaslangicTarih = latestBaglanti.RC_Start_Date__c;
                                child.readonly = latestBaglanti.RC_Approval_Status__c == '0' || latestBaglanti.RC_Approval_Status__c == '5' ? false : true;
                                child.canDelete =  latestBaglanti.RC_Approval_Status__c == '0' || latestBaglanti.RC_Approval_Status__c == '5' ? true : false;
                                child.showHistory = String.isNotBlank(latestBaglanti.RC_Approval_Status__c) && latestBaglanti.RC_Approval_Status__c != '0' && latestBaglanti.RC_Approval_Status__c != '5' ? true : false;
                                child.tutar = !child.readonly ? latestBaglanti.RC_Amount__c : mainTutar;
                                child.cekVade = latestBaglanti.RC_Average_Due_Date__c;
                                child.baseVade = latestBaglanti.RC_Average_Due_Date__c;
                                child.minVade = negativeDay != 0 ? latestBaglanti.RC_Average_Due_Date__c.addDays(negativeDay) : cd.RC_Average_Due_Date__c;
                                child.maxVade = positiveDay != 0 ? latestBaglanti.RC_Average_Due_Date__c.addDays(positiveDay) : cd.RC_Average_Due_Date__c;
                                child.odemeKosul = latestBaglanti.RC_Payment_Term__c;
                                child.baseOdemeKosul = latestBaglanti.RC_Payment_Term__c;
                                
                                child.isMultiple = String.isNotBlank(latestBaglanti.RC_Bordro_No__c) ? true : false;
                            }
                            else{
                                child.cekVade = cd.RC_Average_Due_Date__c;
                                child.baseVade = cd.RC_Average_Due_Date__c;
                                child.minVade = negativeDay != 0 ? cd.RC_Average_Due_Date__c.addDays(negativeDay) : cd.RC_Average_Due_Date__c;
                                child.maxVade = positiveDay != 0 ? cd.RC_Average_Due_Date__c.addDays(positiveDay) : cd.RC_Average_Due_Date__c;
                                child.tutar = 0;
                                child.baglantiBaslangicTarih = cd.RC_Start_Date__c;
                                child.odemeKosul = odemeKosulMap.values().get(0).Id;
                                child.baseOdemeKosul = odemeKosulMap.values().get(0).Id;
                            }
                            
                            child.isDTS = sdo.RC_Account__r.RC_IsDTS__c;
                            child.bayiTur = sdo.RC_Account__r.RC_IsDTS__c ? 'DTS' : 'OÇT';
                            child.krediKontrolID = krediKontrol;
                            child.krediKontrolCode = kk.RC_KKA_Defination__c;
                            child.donemID = cd.Id;
                            child.bordroType = bordroType.RC_Bordro_Types__c;
                            child.bordroTypeDesc = bordroType.RC_Bordro_Type_Definations__c;
                            child.donem = String.format('{0}-{1}', new List<String>{cd.RC_Payment_Form__c, paymentForm.RC_Comments__c});
                            child.isChecked = false;
                            child.odemeKosulOptions = odemeKosulOptions;
                            
                            childs.add(child);
                            childId++;
                        }
                    }
                }
                
                if(childs != null && childs.size() > 0){
                    HeaderWrapper hw = new HeaderWrapper(
                        sdo.RC_Account__r.RC_SAP_ID__c,
                        sdo.RC_Account__r.Name,
                        headerTutar,
                        headerTutar != 0 ? keyDate.addDays(Integer.valueOf(headerAdat / headerTutar)) : null,
                        mainId
                    );
                    
                    mdw.Id = mainId;
                    mdw.header = hw;
                    mdw.childs = childs;
                    mdwList.add(mdw);
                    mainId++;
                }
            }
            rw.resultList = mdwList;
        }
        
        return rw;
    }
    
    @AuraEnabled
    public static ResponseWrapper saveAsDraft(List<ChildWrapper> saveList, Boolean isDraft, Boolean isExtra){
        ResponseWrapper rw = new ResponseWrapper();
        
        List<String> bayiIDList = new List<String>();
        List<String> termIDList = new List<String>(); 
        Set<String> krediKontrolIDList = new Set<String>();
        Set<String> bordroTipIDList = new Set<String>();
        
        for(ChildWrapper cw : saveList){
            bayiIDList.add(cw.bayiId);
            termIDList.add(cw.donemId);
            krediKontrolIDList.add(cw.krediKontrolId);
            bordroTipIDList.add(cw.bordroType);
        }
        
        List<RC_Financial_Process_Definition__c> baglantiBordroGiris = getBaglantiBordroGiris(bayiIDList, termIDList, krediKontrolIDList, bordroTipIDList);
        
        Map<String, Map<String, List<RC_Financial_Process_Definition__c>>> baglantiBordroGirisMap = new Map<String, Map<String, List<RC_Financial_Process_Definition__c>>>();
        for(RC_Financial_Process_Definition__c bbg : baglantiBordroGiris){
            String code = String.format('{0}-{1}-{2}-{3}', new List<String>{bbg.RC_Account__c, bbg.RC_Bordro_Types__c, bbg.RC_Term_ID__c, bbg.RC_KKA__c});
            
            if(baglantiBordroGirisMap.containsKey(bbg.RC_Account__c)){
                Map<String, List<RC_Financial_Process_Definition__c>> baglantiMap = baglantiBordroGirisMap.get(bbg.RC_Account__c);
                
                if(baglantiMap.containsKey(code)){
                    List<RC_Financial_Process_Definition__c> baglantiList = baglantiMap.get(code);
                    baglantiList.add(bbg);
                    
                    baglantiMap.put(code, baglantiList);                        
                    baglantiBordroGirisMap.put(bbg.RC_Account__c, baglantiMap);
                }
                else{
                    List<RC_Financial_Process_Definition__c> baglantiList = new List<RC_Financial_Process_Definition__c>();
                    baglantiList.add(bbg);
                    
                    baglantiMap.put(code, baglantiList);
                    baglantiBordroGirisMap.put(bbg.RC_Account__c, baglantiMap);
                }
            }
            else{
                List<RC_Financial_Process_Definition__c> baglantiList = new List<RC_Financial_Process_Definition__c>();
                baglantiList.add(bbg);
                
                Map<String, List<RC_Financial_Process_Definition__c>> baglantiMap = new Map<String, List<RC_Financial_Process_Definition__c>>();
                baglantiMap.put(code, baglantiList);
                baglantiBordroGirisMap.put(bbg.RC_Account__c, baglantiMap);
            }
        }
        
        try {
            List<RC_Financial_Process_Definition__c> saveEntryList = new List<RC_Financial_Process_Definition__c>();
            for(ChildWrapper cw : saveList){
                RC_Financial_Process_Definition__c entry = null;
                String code = String.format('{0}-{1}-{2}-{3}', new List<String>{cw.bayiId, cw.bordroType, cw.donemId, cw.krediKontrolId});
                
                Map<String, List<RC_Financial_Process_Definition__c>> baglantiMap = baglantiBordroGirisMap.containsKey(cw.bayiId) ? baglantiBordroGirisMap.get(cw.bayiId) : null;
                
                List<RC_Financial_Process_Definition__c> baglantiList = null;
                if(baglantiMap != null){
                    baglantiList = baglantiMap.containsKey(code) ? baglantiMap.get(code) : null;
                    
                    if(baglantiList != null && baglantiList.size() > 0){
                        entry = baglantiList.get(0);
                    }
                }
                
                if(entry == null){
                    entry = new RC_Financial_Process_Definition__c();
                    entry.RC_isExtra__c = 0;
                    entry.RC_Bordro_Types__c = cw.bordroType;
                    entry.RecordTypeId = Schema.SObjectType.RC_Financial_Process_Definition__c.getRecordTypeInfosByDeveloperName()
                        .get('Connection_Bordro_Entry').getRecordTypeId();
                    entry.RC_Account__c = cw.bayiId;
                    entry.RC_Comments__c = cw.aciklama;
                    entry.RC_Average_Due_Date__c = cw.cekVade;
                    entry.RC_Start_Date__c = cw.baglantiBaslangicTarih;
                    entry.RC_Amount__c = cw.tutar;  
                    entry.RC_isDTS__c = cw.isDTS;
                    entry.RC_Payment_Term__c = cw.odemeKosul;
                    entry.RC_Term_ID__c = cw.donemId;
                    entry.RC_KKA_Defination__c = cw.krediKontrolCode;
                    entry.RC_KKA__c = cw.krediKontrolId;
                    entry = assignApprovalStatus(entry, isDraft);
                }
                else{
                    entry.Id = isExtra ? null : cw.entityId;
                    entry.RC_isExtra__c = isExtra ? baglantiList.size() : 0;
                    entry.RC_Comments__c = cw.aciklama;
                    entry.RC_Average_Due_Date__c = cw.cekVade;
                    entry.RC_Amount__c = cw.tutar;  
                    entry.RC_Bordro_No__c = null;
                    entry = assignApprovalStatus(entry, isDraft);
                }
                
                saveEntryList.add(entry);
            }
            
            if(saveEntryList.size() > 0){
                Set<Id> successIDSet = new Set<Id>();
                List<Database.UpsertResult> urList = Database.upsert(saveEntryList, true);
                for(Database.UpsertResult ur : urList){
                    if(!ur.isSuccess()){
                        String errorMessage = '';
                        for(Database.Error err : ur.getErrors()){
                            errorMessage += err.getMessage() + '. ';
                        }
                        
                        rw.isSuccess = false;
                        rw.message = errorMessage;
                    }
                    else
                        successIDSet.add(ur.getId());
                }
                
                List<RC_Financial_Process_Definition__c> entryList = [SELECT Id, RC_Comments__c, RC_Approval_Status__c FROM RC_Financial_Process_Definition__c WHERE Id =: successIDSet];
                
                
                if(saveList.size() == entryList.size()){
                    List<RC_Bordro_Approval_History__c> historyList = new List<RC_Bordro_Approval_History__c>();
                    for(RC_Financial_Process_Definition__c savedEntry : entryList){
                        RC_Financial_Process_Definition__c approvalStatu = null;
                        for(RC_Financial_Process_Definition__c statu : getApprovalStatus()){
                            if(statu.RC_SAP_ID__c == savedEntry.RC_Approval_Status__c){
                                approvalStatu = statu;
                            }
                        }
                        
                        RC_Bordro_Approval_History__c newHistoryEntry = new RC_Bordro_Approval_History__c(
                            RC_Description__c = savedEntry.RC_Comments__c, 
                            RC_Bordro_Entry_Id__c = savedEntry.Id, 
                            RC_Approval_Status__c = approvalStatu.Id
                        );
                        
                        historyList.add(newHistoryEntry);
                    }
                    
                    if(historyList.size() > 0){
                        insert historyList;
                    }
                    
                    rw.isSuccess = true;
                    rw.message = 'İşlem başarıyla gerçekleşti.';
                    
                    List<RC_Financial_Process_Definition__c> savedEntries = [SELECT Id, RC_isDTS__c, RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c, RC_Comments__c, RC_Amount__c, RC_Average_Due_Date__c, RC_Bordro_Types__c, RC_Payment_Term__c, RC_KKA__c, RC_KKA_Defination__c, CreatedById, CreatedBy.Name FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Entry' AND Id =: successIDSet];
                    
                    RC_AssociatedChequeApproveController.ControlWrapper cw = RC_AssociatedChequeApproveController.prepareMailForApprovedData(savedEntries, true, false);
                }
                else{
                    rw.isSuccess = false;
                    rw.message = 'Onaya gönderim işleminde hata gerçekleşti.';
                }
            }
        } 
        catch (Exception e) {
            rw.isSuccess = false;
            rw.message = e.getMessage();
        }
        
        return rw;
    }
    
    public static RC_Financial_Process_Definition__c assignApprovalStatus(RC_Financial_Process_Definition__c entity, Boolean isDraft){
        
        User currentUser = [SELECT Id, UserRole.DeveloperName, ManagerId, Manager.ManagerId FROM User WHERE Id =: UserInfo.getUserId()];
        Boolean isParentBolgeMd = true;
        
        if(currentUser.ManagerId != currentUser.Manager.managerId){
            isParentBolgeMd = false;
        }
        
        if(!isDraft){
            if(currentUser.UserRole.DeveloperName.contains('Bayi_Satis_Muduru')){
                entity.RC_Approval_Status__c = '3';
            }
            else if(currentUser.UserRole.DeveloperName.contains('Bayi_Bolge_Muduru')){
                entity.RC_Approval_Status__c = '2';
            }
            else if(currentUser.UserRole.DeveloperName.contains('Bayi_Genel_Mudur_Yardimcisi')){
                entity.RC_Approval_Status__c = '1';
            }
            else{
                if(isParentBolgeMd){
                    entity.RC_Approval_Status__c = '3';
                }
                else{
                    entity.RC_Approval_Status__c = '4';
                }
            }
        }
        else{
            entity.RC_Approval_Status__c = '5';
        }
        
        entity.RC_Bordro_Status__c = 'Plan';        
        entity.RC_Approver__c = currentUser.ManagerId;
        
        return entity;
    }
    
    @AuraEnabled
    public static List<HistoryWrapper> getHistory(String accId, String bordroTip, String cariDonemId, String kka){
        List<HistoryWrapper> result = new List<HistoryWrapper>();
        
        List<RC_Financial_Process_Definition__c> baglantiEntryList = getBaglantiBordroGiris(new List<String>{accId}, new List<String>{cariDonemId}, new Set<String>{kka}, new Set<String>{bordroTip});
        
        List<RC_SD_Organization__c> bayiList = getUserDealers(new List<String>{accId}, null);
        
        for(RC_Financial_Process_Definition__c entry : baglantiEntryList){
            RC_SD_Organization__c bayi = bayiList.get(0);
            
            HistoryWrapper hw = new HistoryWrapper();
            hw.bayiInfo = bayi.RC_Account__r.RC_SAP_ID__c + ' - ' + bayi.RC_Account__r.Name;
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
    
    // Yardımcı Fonksiyonlar
    public static List<RC_Financial_Process_Definition__c> getApprovalStatus(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_SAP_ID__c, RC_Text__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Approval_Status'];
        
        return result;
    }
    
    public static List<RC_Financial_Process_Definition__c> getBordroStatus(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_SAP_ID__c, RC_Text__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Bordro_Status'];
        
        return result;
    }
    
    private static List<RC_SD_Organization__c> getUserDealers(List<String> bayiIDList, List<String> krediIDList){
        List<RC_SD_Organization__c> result = new List<RC_SD_Organization__c>();
        
        RC_Financial_Process_Definition__c krediKontrol = null;
        if(krediIDList != null && krediIDList.size() > 0){
            krediKontrol = [SELECT Id, RC_Sales_Organization__c, RC_Distribution_Channel__c, RC_KKA__c, RC_KKA_Defination__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Credit_Control_Sales_Organization' AND RC_KKA__c =: krediIDList];
        }
        
        if(bayiIDList != null && bayiIDList.size() > 0){
            if(krediKontrol != null){
                result = [SELECT RC_Account__c, RC_Account__r.RC_IsDTS__c, RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c, Distribution_Channel__c, RC_Sales_Organization__c FROM RC_SD_Organization__c WHERE (RC_Sales_Expert__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.ManagerId =: UserInfo.getUserId() OR RC_Sales_Expert__r.RC_ManagerId_2__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_3__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_4__c =: UserInfo.getUserId()) AND RC_Account__c =: bayiIDList AND Distribution_Channel__c =: krediKontrol.RC_Distribution_Channel__c.right(2) AND RC_Sales_Organization__c =: krediKontrol.RC_Sales_Organization__c AND RC_Account__r.RC_Dealer_Type__c = 'BAYI'];
            }
            else{
                result = [SELECT RC_Account__c, RC_Account__r.RC_IsDTS__c, RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c, Distribution_Channel__c, RC_Sales_Organization__c FROM RC_SD_Organization__c WHERE (RC_Sales_Expert__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.ManagerId =: UserInfo.getUserId() OR RC_Sales_Expert__r.RC_ManagerId_2__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_3__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_4__c =: UserInfo.getUserId()) AND RC_Account__c =: bayiIDList  AND RC_Account__r.RC_Dealer_Type__c = 'BAYI'];
            }
        }
        else{            
            if(krediKontrol != null){
                result = [SELECT RC_Account__c, RC_Account__r.RC_IsDTS__c, RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c, Distribution_Channel__c, RC_Sales_Organization__c FROM RC_SD_Organization__c WHERE (RC_Sales_Expert__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.ManagerId =: UserInfo.getUserId() OR RC_Sales_Expert__r.RC_ManagerId_2__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_3__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_4__c =: UserInfo.getUserId()) AND Distribution_Channel__c =: krediKontrol.RC_Distribution_Channel__c.right(2) AND RC_Sales_Organization__c =: krediKontrol.RC_Sales_Organization__c AND RC_Account__r.RC_Dealer_Type__c = 'BAYI'];
            }
            else{
                result = [SELECT RC_Account__c, RC_Account__r.RC_IsDTS__c, RC_Account__r.Name, RC_Account__r.RC_SAP_ID__c, Distribution_Channel__c, RC_Sales_Organization__c FROM RC_SD_Organization__c WHERE (RC_Sales_Expert__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.ManagerId =: UserInfo.getUserId() OR RC_Sales_Expert__r.RC_ManagerId_2__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_3__c =: UserInfo.getUserId() OR RC_Sales_Expert__r.Manager_4__c =: UserInfo.getUserId()) AND RC_Account__r.RC_Dealer_Type__c = 'BAYI'];
            }
        }
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getBaglantiCariDonem(List<String> cariDonemIDLis){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        if(cariDonemIDLis != null){
            result = [SELECT Id, RC_KKA__c, RC_Comments__c, RC_Payment_Term__c, RC_Start_Date__c, RC_End_Date__c, RC_Entry_End_Date__c, RC_Average_Due_Date__c, RC_Priority__c, RC_Document_Type__c, RC_Payment_Form__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Current_Period' AND Id =: cariDonemIDLis AND RC_IsActive__c = true AND RC_Start_Date__c <= :Date.today() AND RC_Entry_End_Date__c >= :Date.today()];
        }
        else{
            result = [SELECT Id, RC_KKA__c, RC_Comments__c, RC_Payment_Term__c, RC_Start_Date__c, RC_End_Date__c, RC_Entry_End_Date__c, RC_Average_Due_Date__c, RC_Priority__c, RC_Document_Type__c, RC_Payment_Form__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Current_Period' AND RC_IsActive__c = true AND RC_Start_Date__c <= :Date.today() AND RC_Entry_End_Date__c >= :Date.today()];
        }
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getPaymentTypes(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_Payment_Term__c, RC_Expiry__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Payment_Terms' ORDER BY RC_Expiry__c];
        
        return result;
    } 
    
    private static List<RC_Financial_Process_Definition__c> getBordroTypes(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_Portfolio_Code__c, RC_Document_Type__c, RC_Bordro_Types__c, RC_Bordro_Type_Definations__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Bordro_Types' AND RC_IsActive__c = true];
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getCreditControls(List<String> krediKontrolIDList){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        if(krediKontrolIDList != null){
            result = [SELECT Id, RC_Sales_Organization__c, RC_Distribution_Channel__c, RC_KKA__c, RC_KKA_Defination__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Credit_Control_Sales_Organization' AND RC_KKA__c =:krediKontrolIDList];
        }
        else{            
            result = [SELECT Id, RC_Sales_Organization__c, RC_Distribution_Channel__c, RC_KKA__c, RC_KKA_Defination__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Credit_Control_Sales_Organization' AND RC_IsActive__c = true ORDER BY RC_Distribution_Channel__c];
        }
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getPaymentForms(){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_Payment_Form__c, RC_Fiscal_Year__c,	RC_Comments__c,	RC_Text__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Payment_Forms'];
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getCariDonemOdemeKosul(List<String> selectedBaglantiDonem){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_Payment_Term__c, RC_Term_ID__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Period_Payment_Terms' AND RC_Term_ID__c =: selectedBaglantiDonem];
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getCariDonemBordroType(List<String> selectedBaglantiDonem){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_Bordro_Types__c, RC_Term_ID__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Period_Bordro_Type' AND RC_Term_ID__c =: selectedBaglantiDonem];
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getCariDonemKrediKontrol(List<String> selectedBaglantiDonem){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        result = [SELECT Id, RC_KKA__c, RC_Term_ID__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = 'Connection_Period_Credit_Control' AND RC_Term_ID__c =: selectedBaglantiDonem];
        
        return result;
    }
    
    private static List<RC_Financial_Process_Definition__c> getBaglantiBordroGiris(List<String> bayiIDList, List<String> termIDList, Set<String> krediKontrolIDList, Set<String> bordroTipIDList){
        List<RC_Financial_Process_Definition__c> result = new List<RC_Financial_Process_Definition__c>();
        
        String query = 'SELECT Id, RC_Start_Date__c, RC_Bordro_Status__c, RC_Approval_Status__c, RC_Comments__c, RC_Amount__c, RC_Average_Due_Date__c, RC_Account__c, RC_Bordro_Types__c, RC_Payment_Term__c, RC_Term_ID__c, RC_KKA__c, RC_KKA_Defination__c, RC_Bordro_No__c FROM RC_Financial_Process_Definition__c WHERE RecordType.DeveloperName = \'Connection_Bordro_Entry\'';
        
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
            query += ' AND RC_KKA__c IN (';
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
    
    // Ekran Üzerinde ve Süreç İçerisinde Kullanılan Model Classlar
    
    public class ResultWrapper{
        @AuraEnabled
        public List<MainDataWrapper> resultList {get; set;}
        @AuraEnabled
        public Decimal genelTutar {get; set;}
        @AuraEnabled
        public Date genelOrtVade {get; set;}
    }
    
    public class MainDataWrapper{
        @AuraEnabled
        public Integer Id {get; set;}
        @AuraEnabled
        public HeaderWrapper header {get; set;}
        @AuraEnabled
        public List<ChildWrapper> childs {get; set;}
        
        public MainDataWrapper(){
            this.header = new HeaderWrapper();
            this.childs = new List<ChildWrapper>();
        }
    }
    
    public class HeaderWrapper{
        @AuraEnabled
        public String bayiNo {get; set;}
        @AuraEnabled
        public String bayiAd {get; set;}
        @AuraEnabled
        public Decimal totalTutar {get; set;}
        @AuraEnabled
        public Date ortVade {get; set;}
        @AuraEnabled
        public Integer Id {get; set;}
        
        public HeaderWrapper(){}
        public HeaderWrapper(String bn, String ba, Decimal tt, Date ov, Integer i){
            this.bayiNo = bn;
            this.bayiAd = ba;
            this.totalTutar = tt;
            this.ortVade = ov;
            this.Id = i;
        }
    }
    
    public class ChildWrapper{
        @AuraEnabled
        public Integer Id {get; set;}
        @AuraEnabled
        public Boolean readonly {get; set;}
        @AuraEnabled
        public Boolean canDelete {get; set;}
        @AuraEnabled
        public Boolean showHistory {get; set;}
        @AuraEnabled
        public Boolean isChecked {get; set;}
        @AuraEnabled
        public Boolean isMultiple {get; set;}
        @AuraEnabled
        public Date cekVade {get; set;}
        @AuraEnabled
        public Date baseVade {get; set;}
        @AuraEnabled
        public Date minVade {get; set;}
        @AuraEnabled
        public Date maxVade {get; set;}
        @AuraEnabled
        public Decimal tutar {get; set;}
        @AuraEnabled
        public Date baglantiBaslangicTarih {get; set;}
        @AuraEnabled
        public Boolean isDTS {get; set;}
        @AuraEnabled
        public String bayiTur {get; set;}
        @AuraEnabled
        public String krediKontrolID {get; set;}
        @AuraEnabled
        public String krediKontrolCode {get; set;}
        @AuraEnabled
        public String odemeKosul {get; set;}
        @AuraEnabled
        public String baseOdemeKosul {get; set;}
        @AuraEnabled
        public List<SelectOptionWrapper> odemeKosulOptions {get; set;}
        @AuraEnabled
        public String donemID {get; set;}
        @AuraEnabled
        public String bordroType {get; set;}
        @AuraEnabled
        public String bordroTypeDesc {get; set;}
        @AuraEnabled
        public String donem {get; set;}
        @AuraEnabled
        public Date donemOrtVade {get; set;}
        @AuraEnabled
        public String aciklama {get; set;}
        @AuraEnabled
        public String onayDurum {get; set;}
        @AuraEnabled
        public String bordroDurum {get; set;}
        @AuraEnabled
        public String entityId {get; set;}
        @AuraEnabled
        public String bayiNo {get; set;}
        @AuraEnabled
        public String bayiId {get; set;}
    }
    
    public class InitialWrapper{
        @AuraEnabled
        public List<SelectOptionWrapper> krediKontrol {get; set;}
        @AuraEnabled
        public List<SelectOptionWrapper> baglantiDonem {get; set;}
        @AuraEnabled
        public List<SelectOptionWrapper> odemeKosul {get; set;}
        @AuraEnabled
        public List<SelectOptionWrapper> bayi {get; set;}
        @AuraEnabled
        public Boolean isSatisUzmani {get; set;}
        @AuraEnabled
        public Integer paramPositive {get; set;}
        @AuraEnabled
        public Integer paramNegative {get; set;}
        
        public InitialWrapper(){
            this.krediKontrol = new List<SelectOptionWrapper>();
            this.baglantiDonem = new List<SelectOptionWrapper>();
            this.odemeKosul = new List<SelectOptionWrapper>();
            this.bayi = new List<SelectOptionWrapper>();
            this.isSatisUzmani = false;
            this.paramNegative = 0;
            this.paramPositive = 0;
        }
    }
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
        @AuraEnabled
        public String code {get; set;}
        
        public SelectOptionWrapper(){}
        
        public SelectOptionWrapper(String l, String v, String c){
            this.label = l;
            this.value = v;
            this.code = c;
        }
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
    
    public class ResponseWrapper{
        @AuraEnabled
        public String message {get; set;}
        @AuraEnabled
        public Boolean isSuccess {get; set;}
    }
}