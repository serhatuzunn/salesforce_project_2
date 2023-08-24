public class RC_CreditRiskComponentController {
    
    @AuraEnabled
    public static List<Schema.PicklistEntry> portfList{get;set;}
    @AuraEnabled
    public static Map<string,string> portfolioMap{get;set;}
    
    public class initWrapper{
        @AuraEnabled
        public List<SelectOptionWrapper> DistChannelList {get;set;}
        @AuraEnabled
        public RC_CreditRiskComponentController.responseWrapper responseWrp {get;set;}
    }
    public class SelectOptionWrapper{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value {get;set;}
    }
    public class responseWrapper 
    {
        @AuraEnabled
        public RC_CreditRiskIntegrator.responseModel creditRiskResponse {get;set;}
        @AuraEnabled
        public RC_BayiCekSenetIntegrator.responseModel bayiCekSenetResponse {get;set;}
        @AuraEnabled
        public RC_BaglantiIntegrator.responseModel baglantiResponse {get;set;}
        @AuraEnabled
        public List<GroupedCheckTypes> groupedBayiCekSenet {get;set;}
        @AuraEnabled
        public SelectedKarsiliksizCekSenet SelectedKarsiliksizCekSenet {get;set;}
    }
    public class GroupedCheckTypes
    {
        @AuraEnabled
        public List<GroupedCheckByMonth> TotalValueByMonthAndYear{get;set;}
        @AuraEnabled
        public string CheckType{get;set;}
    }
    public class GroupedCheckByMonth
    {
        @AuraEnabled
        public string MonthAndYear{get;set;}
        @AuraEnabled
        public double TotalValue{get;set;}
        @AuraEnabled
        public List<RC_BayiCekSenetIntegratorParser.Item> ItemList{get;set;}
    }
    public class SelectedCekSenet
    {
        @AuraEnabled
        public List<RC_BayiCekSenetIntegratorParser.Item> SelectedCekSenetList{get;set;}
    }
    public class GroupedKarsiliksizCheckByYear
    {
        @AuraEnabled
        public string Year{get;set;}
        @AuraEnabled
        public List<RC_CreditRiskJsonParser.Item_P> ItemList{get;set;}
    }
    public class SelectedKarsiliksizCekSenet
    {
        @AuraEnabled
        public List<GroupedKarsiliksizCheckByYear> SelectedKarsiliksizCekSenetList{get;set;}
        @AuraEnabled
        public List<GroupedKarsiliksizCheckByYear> SelectedProtestoluSenetList{get;set;}
        @AuraEnabled
        public List<GroupedKarsiliksizCheckByYear> SelectedIadeliCekList{get;set;}
        @AuraEnabled
        public List<GroupedKarsiliksizCheckByYear> SelectedIadeliSenetList{get;set;}
        
        @AuraEnabled
        public List<GroupedKarsiliksizCheckByYear> SelectedModalKarsiliksizList{get;set;}
    }
    public class SelectedGroupedCheckTypes
    {
        @AuraEnabled
        public List<GroupedCheckByMonth> TotalValueByMonthAndYear{get;set;}
    }
    @AuraEnabled
    public static initWrapper initialize(string recordId){
        initWrapper initWrp = new initWrapper();
        List<SelectOptionWrapper> distChannels = new List<SelectOptionWrapper>();
        system.debug('recordId:' + recordId);
        if(string.isBlank(recordId)){
            string usr = UserInfo.getUserId();
            string accountId = [SELECT Id,AccountId FROM User Where Id=:usr LIMIT 1].AccountId;
            
            if(!string.isBlank(accountId)){
                system.debug('accountId:' + accountId);
                recordId=accountId;
            }
        }
        
        
        List<RC_SD_Organization__c> sdOrgList = [SELECT RC_Credit_Control_Field__c FROM RC_SD_Organization__c where RC_Account__c =:recordId];
        
        Set<String> distSet = new Set<String>();
        for(RC_SD_Organization__c sdOrg : sdOrgList ){
            distSet.add(sdOrg.RC_Credit_Control_Field__c);
        }
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Tümü';
        EmptyValue.value = '';
        distChannels.add(EmptyValue);
        
        Schema.DescribeFieldResult fieldResultForCompany = RC_SD_Organization__c.RC_Credit_Control_Field__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            for(String c :distSet){ 
                if(c == pickListVal.getValue()){
                    SelectOptionWrapper tempValues = new SelectOptionWrapper();
                    tempValues.label = pickListVal.getLabel();
                    tempValues.value = pickListVal.getValue() == '0024' ? '0025' : pickListVal.getValue();
                    distChannels.add(tempValues);
                }
            }
        }
        
        initWrp.DistChannelList = distChannels;
        initWrp.responseWrp = getCreditRiskReport(recordId,'');
        system.debug('responseWrp:' + initWrp.responseWrp);
        return initWrp;
    }
    
    
    @AuraEnabled
    public static RC_CreditRiskComponentController.responseWrapper getCreditRiskReport(string accountId,string distChannel){
        
        Schema.DescribeFieldResult portfolioList = RC_Dealer_Payment_Detail__c.RC_Portfolio__c.getDescribe();
        portfList = portfolioList.getPicklistValues();
        portfolioMap = new Map<string,string>();
        for( Schema.PicklistEntry pickListVal : portfList)
        {
            portfolioMap.put(pickListVal.getValue(), pickListVal.getLabel());
        }
        
        responseWrapper responseCls = new responseWrapper();
        RC_CreditRiskIntegrator.requestModel req = new RC_CreditRiskIntegrator.requestModel();
        
        Account acc = [SELECT RC_SAP_ID__c FROM Account WHERE id =: accountId LIMIT 1];
        
        if(string.isNotBlank(acc.RC_SAP_ID__c)){
            req.IV_BUKRS = '2002';
            req.IV_KKBER = distChannel;
            req.IV_KUNNR = acc.RC_SAP_ID__c;
            system.debug('request : ' + req);
            
            //BayiCekSenet - API:bayi_cek_senet
            RC_BayiCekSenetIntegrator.responseModel cekSenetResponse= RC_BayiCekSenetIntegrator.getBayiCekSenet(req);
            system.debug('cekSenetResponse : ' + cekSenetResponse);
            responseCls.bayiCekSenetResponse = cekSenetResponse;
            
            //BayiCekSenet - group
            if(cekSenetResponse != null)
            {
                if(cekSenetResponse.etReturn != null && cekSenetResponse.etReturn.item.size() > 0)
                {
                    
                    Map<String,List<RC_BayiCekSenetIntegratorParser.Item>> mapCheckTypes= new Map<String,List<RC_BayiCekSenetIntegratorParser.Item>>();
                    
                    List<GroupedCheckTypes> groupedCheckTypesList = new List<GroupedCheckTypes>();
                    system.debug('response  1 : ' + cekSenetResponse.etReturn.item[0]);
                    
                    if(cekSenetResponse.etReturn.item[0].CEK_DTS != null && cekSenetResponse.etReturn.item[0].CEK_DTS.item[0].VADE != ''){
                        for(RC_BayiCekSenetIntegratorParser.Item item : cekSenetResponse.etReturn.item[0].CEK_DTS.item){
                            item.PORTF = GetPortfolioName(item.PORTF);
                        }
                        mapCheckTypes.put('CEK_DTS',cekSenetResponse.etReturn.item[0].CEK_DTS.item);
                    }
                    if(cekSenetResponse.etReturn.item[0].CEK_SAHSI != null && cekSenetResponse.etReturn.item[0].CEK_SAHSI.item[0].VADE != ''){
                        for(RC_BayiCekSenetIntegratorParser.Item item : cekSenetResponse.etReturn.item[0].CEK_SAHSI.item){
                            item.PORTF = GetPortfolioName(item.PORTF);
                        }
                        mapCheckTypes.put('CEK_SAHSI',cekSenetResponse.etReturn.item[0].CEK_SAHSI.item);
                    }
                    if(cekSenetResponse.etReturn.item[0].CEK_MUSTERI != null && cekSenetResponse.etReturn.item[0].CEK_MUSTERI.item[0].VADE != ''){
                        for(RC_BayiCekSenetIntegratorParser.Item item : cekSenetResponse.etReturn.item[0].CEK_MUSTERI.item){
                            item.PORTF = GetPortfolioName(item.PORTF);
                        }
                        mapCheckTypes.put('CEK_MUSTERI',cekSenetResponse.etReturn.item[0].CEK_MUSTERI.item);
                    }
                    if(cekSenetResponse.etReturn.item[0].CEK_BAGLANTI != null && cekSenetResponse.etReturn.item[0].CEK_BAGLANTI.item[0].VADE != ''){
                        for(RC_BayiCekSenetIntegratorParser.Item item : cekSenetResponse.etReturn.item[0].CEK_BAGLANTI.item){
                            item.PORTF = GetPortfolioName(item.PORTF);
                        }
                        mapCheckTypes.put('CEK_BAGLANTI',cekSenetResponse.etReturn.item[0].CEK_BAGLANTI.item);
                    }
                    if(cekSenetResponse.etReturn.item[0].SENET_SAHSI != null && cekSenetResponse.etReturn.item[0].SENET_SAHSI.item[0].VADE != ''){
                        for(RC_BayiCekSenetIntegratorParser.Item item : cekSenetResponse.etReturn.item[0].SENET_SAHSI.item){
                            item.PORTF = GetPortfolioName(item.PORTF);
                        }
                        mapCheckTypes.put('SENET_SAHSI',cekSenetResponse.etReturn.item[0].SENET_SAHSI.item);
                    }
                    if(cekSenetResponse.etReturn.item[0].SENET_MUSTERI != null && cekSenetResponse.etReturn.item[0].SENET_MUSTERI.item[0].VADE != ''){
                        for(RC_BayiCekSenetIntegratorParser.Item item : cekSenetResponse.etReturn.item[0].SENET_MUSTERI.item){
                            item.PORTF = GetPortfolioName(item.PORTF);
                        }
                        mapCheckTypes.put('SENET_MUSTERI',cekSenetResponse.etReturn.item[0].SENET_MUSTERI.item);
                    }
                    if(cekSenetResponse.etReturn.item[0].SENET_BAGLANTI != null && cekSenetResponse.etReturn.item[0].SENET_BAGLANTI.item[0].VADE != ''){
                        for(RC_BayiCekSenetIntegratorParser.Item item : cekSenetResponse.etReturn.item[0].SENET_BAGLANTI.item){
                            item.PORTF = GetPortfolioName(item.PORTF);
                        }
                        mapCheckTypes.put('SENET_BAGLANTI',cekSenetResponse.etReturn.item[0].SENET_BAGLANTI.item);
                    }
                    
                    system.debug('mapCheckTypes : ' + mapCheckTypes);
                    for(string checkType : mapCheckTypes.keySet()){
                        
                        Map<String,GroupedCheckByMonth> checkTypeMonthAndYearMap = new Map<String,GroupedCheckByMonth>();     //key = checkTypeMonthAndYearMap
                        
                        system.debug('checkType : ' + checkType);
                        for(RC_BayiCekSenetIntegratorParser.Item item : mapCheckTypes.get(checkType)){
                            
                            //tarihe göre grupla
                            string maturityMonth = item.VADE.SubString(3,5);
                            string maturityYear = item.VADE.SubString(6,10);
                            string monthAndYear = maturityMonth + '-' + maturityYear;
                            String checkTypeMonthAndYear = checkType + '-' + monthAndYear;
                            system.debug('checkType - monthAndYear : ' + checkTypeMonthAndYear);
                            if(!checkTypeMonthAndYearMap.containsKey(checkTypeMonthAndYear)){
                                
                                GroupedCheckByMonth groupedCheckByMonth = new GroupedCheckByMonth();
                                groupedCheckByMonth.MonthAndYear = monthAndYear;
                                groupedCheckByMonth.TotalValue = Double.valueOf(item.Tutar);
                                groupedCheckByMonth.ItemList = new List<RC_BayiCekSenetIntegratorParser.Item>();
                                groupedCheckByMonth.ItemList.add(item);
                                
                                checkTypeMonthAndYearMap.put(checkTypeMonthAndYear, groupedCheckByMonth);
                            }
                            else{
                                GroupedCheckByMonth selectGroupedCheckByMonth = checkTypeMonthAndYearMap.get(checkTypeMonthAndYear);
                                selectGroupedCheckByMonth.MonthAndYear = monthAndYear;
                                selectGroupedCheckByMonth.TotalValue += Double.valueOf(item.Tutar);
                                selectGroupedCheckByMonth.ItemList.add(item);
                                
                                checkTypeMonthAndYearMap.put(checkTypeMonthAndYear, selectGroupedCheckByMonth);
                            }
                        }
                        
                        List<GroupedCheckByMonth> totalValueByMonthAndYearList = new List<GroupedCheckByMonth>();
                        for(String checkTypeMonthYearMapKey : checkTypeMonthAndYearMap.keySet()){
                            totalValueByMonthAndYearList.add(checkTypeMonthAndYearMap.get(checkTypeMonthYearMapKey));
                        }
                        
                        GroupedCheckTypes groupedCheckTypes = new GroupedCheckTypes();
                        groupedCheckTypes.CheckType = checkType;
                        groupedCheckTypes.TotalValueByMonthAndYear = totalValueByMonthAndYearList;
                        
                        system.debug('groupedCheckTypes : ' + groupedCheckTypes);
                        
                        groupedCheckTypesList.add(groupedCheckTypes);
                        system.debug('groupedCheckTypesList : ' + groupedCheckTypesList);
                    }
                    
                    responseCls.groupedBayiCekSenet = groupedCheckTypesList;
                    system.debug('responseCls.groupedBayiCekSenet :' + responseCls.groupedBayiCekSenet);
                }
            }
            
            //CreditRisk - API:bayi_risk
            responseCls.creditRiskResponse = RC_CreditRiskIntegrator.getCreditRiskReport(req);
            system.debug('responseCls.creditRiskResponse : ' +  responseCls.creditRiskResponse);
            if(responseCls.creditRiskResponse != null && responseCls.creditRiskResponse.riskItems != null){
                responseCls.creditRiskResponse.riskItems = sortCreditRiskList(responseCls.creditRiskResponse.riskItems);  
            }  
            
            //CreditRisk - PortfolioName
            if(responseCls.creditRiskResponse!=null)
            {
                if(responseCls.creditRiskResponse.itemZ.KARSILIKSIZ_CEKLER_DETAY!=null)
                {
                    for(RC_CreditRiskJsonParser.Item_P item : responseCls.creditRiskResponse.itemZ.KARSILIKSIZ_CEKLER_DETAY.item)
                    {
                        item.PORTF =  GetPortfolioName(item.PORTF);
                    }  
                }
                if(responseCls.creditRiskResponse.itemZ.PROTESTOLU_SENETLER_DETAY!=null)
                {
                    for(RC_CreditRiskJsonParser.Item_P item : responseCls.creditRiskResponse.itemZ.PROTESTOLU_SENETLER_DETAY.item)
                    {
                        item.PORTF =  GetPortfolioName(item.PORTF);
                    }
                }
                if(responseCls.creditRiskResponse.itemZ.IADELI_CEKLER_DETAY!=null)
                {
                    for(RC_CreditRiskJsonParser.Item_P item : responseCls.creditRiskResponse.itemZ.IADELI_CEKLER_DETAY.item)
                    {
                        item.PORTF =  GetPortfolioName(item.PORTF);
                    }
                }
                if(responseCls.creditRiskResponse.itemZ.IADELI_SENETLER_DETAY!=null)
                {
                    for(RC_CreditRiskJsonParser.Item_P item : responseCls.creditRiskResponse.itemZ.IADELI_SENETLER_DETAY.item)
                    {
                        item.PORTF =  GetPortfolioName(item.PORTF);
                    }
                }
                
                //CreditRisk - group
                SelectedKarsiliksizCekSenet selectedKarsiliksizCekSenet = new SelectedKarsiliksizCekSenet();
                if(responseCls.creditRiskResponse != null){
                    if(responseCls.creditRiskResponse.itemZ.KARSILIKSIZ_CEKLER_DETAY.item  != null){
                        selectedKarsiliksizCekSenet.SelectedKarsiliksizCekSenetList = groupedKarsiliksizCheck(responseCls.creditRiskResponse.itemZ.KARSILIKSIZ_CEKLER_DETAY.item);
                    }
                    if(responseCls.creditRiskResponse.itemZ.PROTESTOLU_SENETLER_DETAY.item  != null){
                        selectedKarsiliksizCekSenet.SelectedProtestoluSenetList = groupedKarsiliksizCheck(responseCls.creditRiskResponse.itemZ.PROTESTOLU_SENETLER_DETAY.item);
                    }
                    if(responseCls.creditRiskResponse.itemZ.IADELI_CEKLER_DETAY.item  != null){
                        selectedKarsiliksizCekSenet.SelectedIadeliCekList = groupedKarsiliksizCheck(responseCls.creditRiskResponse.itemZ.IADELI_CEKLER_DETAY.item);
                    }
                    if(responseCls.creditRiskResponse.itemZ.IADELI_SENETLER_DETAY.item  != null){
                        selectedKarsiliksizCekSenet.SelectedIadeliSenetList = groupedKarsiliksizCheck(responseCls.creditRiskResponse.itemZ.IADELI_SENETLER_DETAY.item);
                    }
                }
                
                responseCls.SelectedKarsiliksizCekSenet = selectedKarsiliksizCekSenet;
                
                system.debug('selectedKarsiliksizCekSenet : ' + selectedKarsiliksizCekSenet);
                
                system.debug('IADELI_CEKLER_DETAY : ' + responseCls.SelectedKarsiliksizCekSenet.SelectedIadeliCekList);
            }
            
            
            //Baglanti - API:fi_baglanti
            RC_BaglantiIntegrator.requestModel reqBaglanti = new RC_BaglantiIntegrator.requestModel();
            reqBaglanti.IV_BUKRS = '2002';
            reqBaglanti.IV_KKBER = distChannel;
            reqBaglanti.IV_KUNNR = acc.RC_SAP_ID__c;
            RC_BaglantiIntegrator.responseModel baglantiResponse= RC_BaglantiIntegrator.getBaglanti(reqBaglanti);
            system.debug('baglantiResponse : ' + baglantiResponse);
            
            //Baglanti - PortfolioName
            if(baglantiResponse!=null && baglantiResponse.etReturn != null && baglantiResponse.etReturn.item[0] != null)
            {
                system.debug('cekdetay : ' + baglantiResponse.etReturn.item[0].CEK_DETAY.item);
                for(RC_SD_BaglantiParser.Item_Z item : baglantiResponse.etReturn.item[0].CEK_DETAY.item){
                    item.PORTF =  GetPortfolioName(item.PORTF);
                }
                
                responseCls.baglantiResponse = baglantiResponse;
            }
            
        }
        return responseCls;
    }
    
    private static List<RC_CreditRiskJsonParser.Item> sortCreditRiskList(List<RC_CreditRiskJsonParser.Item> data){
        List<RC_CreditRiskJsonParser.Item> sortedList = new List<RC_CreditRiskJsonParser.Item>();
        
        List<Integer> sortList = new List<Integer>();
        Map<Integer, RC_CreditRiskJsonParser.Item> sortMap = new Map<Integer, RC_CreditRiskJsonParser.Item>();
        for(RC_CreditRiskJsonParser.Item item : data){
            if(string.isNotBlank(item.GJAHR))
            {
                sortList.add(Integer.valueOf(item.GJAHR));
                sortMap.put(Integer.valueOf(item.GJAHR), item);
            }
            
        }
        
        sortList.sort();
        
        for(Integer item : sortList){          
            sortedList.add(sortMap.get(item));
        }
        
        return sortedList;
    }
    
    private static List<GroupedKarsiliksizCheckByYear> groupedKarsiliksizCheck(List<RC_CreditRiskJsonParser.Item_P> karsiliksizCheckList){
        system.debug('karsiliksizCheckList : ' + karsiliksizCheckList);
        Map<String,List<RC_CreditRiskJsonParser.Item_P>> checkYearMap = new Map<String,List<RC_CreditRiskJsonParser.Item_P>>(); //Year, list
        
        for(RC_CreditRiskJsonParser.Item_P item : karsiliksizCheckList){
            if(!String.isBlank(item.VADE)){
                
                
                string maturityMonth = item.VADE.SubString(3,5);
                string maturityYear = item.VADE.SubString(6,10);
                string monthAndYear = maturityMonth + '-' + maturityYear;
                
                if(!checkYearMap.containsKey(monthAndYear)){
                    List<RC_CreditRiskJsonParser.Item_P> itempList = new List<RC_CreditRiskJsonParser.Item_P>();
                    itempList.add(item);
                    
                    checkYearMap.put(monthAndYear, itempList);
                }
                else{
                    List<RC_CreditRiskJsonParser.Item_P> itempList = checkYearMap.get(monthAndYear);
                    itempList.add(item);
                    
                    checkYearMap.put(monthAndYear, itempList);
                }
            }
        }
        
        system.debug('checkYearMap : ' + checkYearMap);
        
        List<GroupedKarsiliksizCheckByYear> groupedByYearList = new List<GroupedKarsiliksizCheckByYear>(); 
        
        for(String key : checkYearMap.keyset()){
            List<RC_CreditRiskJsonParser.Item_P> checkItemList = checkYearMap.get(key);
            
            GroupedKarsiliksizCheckByYear groupedKarsiliksizCheckByYear = new GroupedKarsiliksizCheckByYear();
            groupedKarsiliksizCheckByYear.Year = key;
            groupedKarsiliksizCheckByYear.ItemList = checkItemList;
            
            groupedByYearList.add(groupedKarsiliksizCheckByYear);
        }
        
        system.debug('groupedByYearList : ' + groupedByYearList);
        
        return groupedByYearList;
    }
    
    @AuraEnabled
    public static string GetPortfolioName(string portfolioCode)
    {
        system.debug('portf:' + portfolioCode);
        system.debug('porftMap:' + portfolioMap);
        if(portfolioMap.containsKey(portfolioCode))
            return portfolioMap.get(portfolioCode);
        else
            return '';
    }
    @AuraEnabled
    public static string GetMonthName(string month)
    {
        if(month=='01') return 'Ocak';
        if(month=='02') return 'Şubat';
        if(month=='03') return 'Mart';
        if(month=='04') return 'Nisan';
        if(month=='05') return 'Mayıs';
        if(month=='06') return 'Haziran';
        if(month=='07') return 'Temmuz';
        if(month=='08') return 'Ağustos';
        if(month=='09') return 'Eylül';
        if(month=='10') return 'Ekim';
        if(month=='11') return 'Kasım';
        if(month=='12') return 'Aralık';
        return 'Unexpected';
    }
}