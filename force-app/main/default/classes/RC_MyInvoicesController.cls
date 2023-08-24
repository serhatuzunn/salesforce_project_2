public inherited sharing class RC_MyInvoicesController {
    
    public RC_MyInvoicesController(){}

    @AuraEnabled
    public static initModel initialize()
    {
        initModel result = new initModel();
        result.isCommunity = false;
        if(String.isNotBlank(Network.getNetworkId())){
          result.isCommunity = true;
          
          result.selectedAccountId = [SELECT id, AccountId, Account.RC_SAP_ID__c  FROM User WHERE id =: UserInfo.getUserId()].AccountId;         
          
        }
        
         return result;
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getCategory1(){  
        
        
        
        
        try {      
            List<PickListValues> lstCategory1 = new List<PickListValues>();     
            string searchedQuery = 'SELECT RC_Value__c, name FROM RC_Definition__c';
            searchedQuery += ' WHERE Type__c =\'Product Hierarchy\' and RC_Hierarchy_Level__c = 1  and RC_External_ID__c  !=null and RC_Value__c IN (\'01\',\'02\',\'10\')';             
            List<RC_Definition__c> foundedList = Database.query(searchedQuery);
            PickListValues pv = new PickListValues(
                       '',
                       'Hepsi'
                   );   
                   lstCategory1.add(pv);
                         for (RC_Definition__c data : foundedList) { 
                  PickListValues prepared = new PickListValues(data.RC_Value__c,data.name);
                   lstCategory1.add(prepared);
               }                   
         
            return lstCategory1;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getCategory2(string category1){  
        
        try {      
            List<PickListValues> lstCategory2 = new List<PickListValues>();     
            string searchedQuery = 'SELECT RC_Value__c, name FROM RC_Definition__c';
            searchedQuery += ' WHERE Type__c =\'Product Hierarchy\' and RC_Hierarchy_Level__c = 2  and RC_External_ID__c  !=null and RC_Upper_Hierarchy__c =\''+ category1+ '\'';             
            List<RC_Definition__c> foundedList = Database.query(searchedQuery);
            PickListValues pv = new PickListValues(
                '',
                'Hepsi'
            );   
            lstCategory2.add(pv);
            for (RC_Definition__c data : foundedList) {
                PickListValues prepared = new PickListValues(data.RC_Value__c,data.name);                
                lstCategory2.add(prepared);
            }                    
            system.debug('liste:' +lstCategory2);
            return lstCategory2;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getCategory3(string category2){  
       
        try {      
             List<PickListValues> lstCategory3 = new List<PickListValues>();     
             string searchedQuery = 'SELECT RC_Value__c, name FROM RC_Definition__c';
             searchedQuery += ' WHERE Type__c =\'Product Hierarchy\' and RC_Hierarchy_Level__c = 3  and RC_External_ID__c  !=null and RC_Upper_Hierarchy__c =\''+ category2+ '\'';
             
             List<RC_Definition__c> foundedList = Database.query(searchedQuery);
             PickListValues pv = new PickListValues(
                '',
                'Hepsi'
            );   
            lstCategory3.add(pv);
             for (RC_Definition__c data : foundedList) {
                 PickListValues prepared = new PickListValues(data.RC_Value__c,data.name);                
                    lstCategory3.add(prepared);
                }                    
             return lstCategory3;
            }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }


    @AuraEnabled
    public static List<BillingWrapper> getInvoicesNew(Date startDate, Date endDate, String invoiceNo, Id accountId, string productCode,String category1, String category2, String category3){
         system.debug('accountId_:'+ accountId);
        List<BillingWrapper> invoiceList = new List<BillingWrapper>();       
        
        
        try {            
            String searchedQuery = '';
            
            Account relatedAccount = RC_UtilitiesClass.getUserRelatedAccount();   
            if(accountId==null){
              accountId = relatedAccount.Id;
            }
            
            if(accountId != null){
                searchedQuery = 'SELECT Id, Name, RC_Invoice_No__c ,RC_Invoice_Date__c ,RC_Invoice_Quantity__c ,Product_Total_Without_Tax__c,RC_Net_Total__c, RC_Billing_Item_Products__c, RC_Order_Number__c, RC_Order_Number__r.OrderNumber, RC_Order_Number__r.RC_Mobile_Product__c, RC_UUID__c,(select RC_Billing_Item_Product__r.ProductCode , RC_Billing_Item_Product__r.Name , RC_Billing_Item_Quantity__c from Billing_Items__r ) FROM RC_Delivery_and_Billing__c';
                searchedQuery += ' WHERE Id != null AND RC_Invoice_No__c != null AND RC_Invoice_No__c != \'\' ';
                if(String.isNotBlank(accountId)){
                    searchedQuery += ' AND RC_Order_Number__r.AccountId = \'' + accountId + '\'';
                }  
                if (startDate != null || endDate != null || String.isNotBlank(invoiceNo)||String.isNotBlank(productCode)  ||String.isNotBlank(category1)  ||String.isNotBlank(category2)  ||String.isNotBlank(category3) ) {
                                        
                    if (startDate != null) {
                        searchedQuery += ' and RC_Invoice_Date__c >= ' + formatDateForQuery(startDate);                        
                    }                
                    if(endDate != null){                        
                        searchedQuery += ' AND RC_Invoice_Date__c <= ' + formatDateForQuery(endDate);                        
                    }  
                    
                    if(String.isNotBlank(invoiceNo)){                        
                            searchedQuery += ' AND RC_Invoice_No__c = \'' + invoiceNo + '\'';                        
                    }                                   

                     if(String.isNotBlank(productCode)){
                         searchedQuery += ' AND Id in(select RC_Delivery_and_Billing__c from RC_Billing_Item__c  where RC_Billing_Item_Product__c   =  \'' + productCode + '\')'; 
                     }

                     if(String.isNotBlank(category1)){
                         searchedQuery += ' AND Id in(select RC_Delivery_and_Billing__c from RC_Billing_Item__c  where RC_Billing_Item_Product__r.RC_Product_hiy_Level_1__c =  \'' + category1+ '\')'; 
                     }
                     if(String.isNotBlank(category2)){
                         searchedQuery += ' AND RC_Billing_Item_Product__r.RC_Product_hiy_Level_2__c =  \'' + category2 + '\')'; 
                     }
                     if(String.isNotBlank(category3)){
                         searchedQuery += ' AND RC_Billing_Item_Product__r.RC_Product_hiy_Level_3__c =  \'' + category3 + '\')'; 
                     }
                 }
            }
            
            if(String.isNotBlank(searchedQuery)){
                system.debug('searchedQuery3: ' + searchedQuery);
                List<RC_Delivery_and_Billing__c> foundedInvoiceList = Database.query(searchedQuery);
                
                if(foundedInvoiceList == null || foundedInvoiceList.size() < 1){
                    return null;
                }
                else{
                    List<String> sipNoList = new List<String>();
                    for (RC_Delivery_and_Billing__c data : foundedInvoiceList) {
                        if (String.isNotBlank(data.RC_Invoice_No__c)) {
                            sipNoList.add(data.RC_Invoice_No__c);
                        }
                    }
                    
                    RC_SD_GetPayedAmount.PayedAmountResponseModel parm = null;
                    if (sipNoList != null && sipNoList.size() > 0) {                    
                        parm = RC_SD_GetPayedAmount.CheckPayedAmount(sipNoList, 'Fatura');
                    }
                    
                    Map<String, Decimal> payedAmountMap = new Map<String, Decimal>();
                    if(parm != null && parm.ET_RESULTS != null && parm.ET_RESULTS.item != null && parm.ET_RESULTS.item.size() > 0){
                        for (RC_SD_GetPayedAmount.MainItemResultModel data : parm.ET_RESULTS.item) {
                            Decimal convertedTutar = Double.valueOf(data.TUTAR);
                            
                            if (!payedAmountMap.containsKey(String.valueOf(data.FAT_NO))) {
                                payedAmountMap.put(String.valueOf(data.FAT_NO), convertedTutar);
                            }
                            else{
                                Decimal foundedTutar = payedAmountMap.get(String.valueOf(data.FAT_NO));
                                
                                payedAmountMap.put(String.valueOf(data.FAT_NO), foundedTutar + convertedTutar);
                            }
                        }
                    }
                    
                    for (RC_Delivery_and_Billing__c data : foundedInvoiceList) {
                        Boolean isOrderExist = data.RC_Order_Number__c != null ? true : false;
                        Boolean canPayable = isOrderExist ? (data.RC_Order_Number__r.RC_Mobile_Product__c > 0 ? false : true ) : true;
                        string productInfo= '';
                          for(RC_Billing_Item__c  dataDetail : data.Billing_Items__r)
                          {
                              productinfo += dataDetail.RC_Billing_Item_Product__r.ProductCode + ' '+
                              dataDetail.RC_Billing_Item_Product__r.Name + ' ('+ dataDetail.RC_Billing_Item_Quantity__c +')'
                              +'\n';
                          }
                        if(canPayable)
                            canPayable = String.isNotBlank(data.RC_Invoice_No__c) ? true : false;
                        
                        Decimal payedAmount = isOrderExist ? payedAmountMap.containsKey(data.RC_Invoice_No__c) ? payedAmountMap.get(data.RC_Invoice_No__c) : 0 : 0;

                        BillingWrapper preparedInvoice = new BillingWrapper(
                            data.Id,
                            data.Name,
                            data.RC_Invoice_No__c,
                            data.RC_Invoice_Date__c,
                            data.RC_Invoice_Quantity__c,
                            data.Product_Total_Without_Tax__c,
                            productinfo,
                            isOrderExist ? data.RC_Order_Number__r.OrderNumber : '',
                            data.RC_Net_Total__c != null ? data.RC_Net_Total__c - payedAmount : 0,
                            canPayable,
                            data.RC_UUID__c,
                            payedAmount
                        );
                        
                        invoiceList.add(preparedInvoice);
                    }
                }
            }
            
            return invoiceList;
        } 
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }
    

    @AuraEnabled
    public static Map<String, Object> prepareMapForPayActionNew(String site, String returnUrl, String invoiceNo, String amount){
        
        //relatedsite faturanın satış organizasyonuna göre gelsin.
        String relatedSite = site.containsIgnoreCase('Regal') ? 'Regal' : 'Vestel';
        
        System.debug(relatedSite);
        AssecoInformation__c relatedAssecoInfo = AssecoInformation__c.getValues(relatedSite);
        Account relatedAccount = RC_UtilitiesClass.getUserRelatedAccount();
        System.debug(relatedAssecoInfo);
        try {
            String channel = relatedAssecoInfo != null ? String.format(relatedAssecoInfo.AssecoApiMerchFormat__c, new String[]{relatedAssecoInfo.Kanal__c}) : '';
            String bayikodu = relatedAccount != null ? relatedAccount.RC_SAP_ID__c : '20101384';
            String random = RC_Asseco_Integrator.GenerateRandomKey(64);
            String secretKey = '7189489278796668';
            
            Map<String, Object> payDataMap = new Map<String, Object>();
            payDataMap.put('channel', channel);
            payDataMap.put('bayikodu', bayikodu);
            payDataMap.put('faturano', invoiceNo);
            payDataMap.put('exactmatch', '');
            payDataMap.put('maxsplitcount', '0');
            payDataMap.put('personalmaxinst', '4');
            payDataMap.put('businessmaxinst', '4');
            payDataMap.put('currency', 'TRY');
            payDataMap.put('customer', bayikodu);
            payDataMap.put('random', random);
            payDataMap.put('secretKey', secretKey);
            payDataMap.put('hash', RC_Asseco_Integrator.GenerateHashCode(channel, bayikodu, random, secretKey));
            payDataMap.put('expirationtime', relatedAssecoInfo != null ? relatedAssecoInfo.SessionSuresi__c : '');
            payDataMap.put('returnUrl', returnUrl);
            payDataMap.put('ispaybylink', 'No');
            payDataMap.put('amount', String.valueOf(amount).replace('.', ','));
            payDataMap.put('isdirectpayment', '');
            payDataMap.put('surId', relatedAssecoInfo != null ? relatedAssecoInfo.SureId__c : '');
            payDataMap.put('commercecodes', '[{"commercecode" : "1"}]');
            payDataMap.put('linkredirecturl', returnUrl);
            payDataMap.put('customername', '');
            payDataMap.put('customeremail', '');
            payDataMap.put('customerphone', '');
            
            return payDataMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<RC_Billing_Item__c> getBillingDetail(String billingId){
        try {
            if(String.isNotBlank(billingId)){
                List<RC_Billing_Item__c> foundedItems = [SELECT Id, RC_Billing_Item_No__c, RC_Billing_Item_Quantity__c, RC_Billing_Item_Product__c, RC_Reference_Item_No__c, RC_Distribution_Channel__c, RC_Net_Price__c, RC_Payment_Condition__c, RC_SD_Organization__c, RC_Tax_Total__c, RC_Total__c,RC_Billing_Item_Product__r.ProductCode, RC_Billing_Item_Product__r.Name FROM RC_Billing_Item__c WHERE RC_Delivery_and_Billing__c =: billingId];                
                return foundedItems;
            }
            
            return null;
        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }
    
    @AuraEnabled(cacheable=true)
    public static List<IptIadeDetail> getBillingIptIade(String deliveryNo){
        try {
            system.debug(deliveryNo);
            if(String.isNotBlank(deliveryNo)){
                
                RC_Delivery_and_Billing__c billing = [SELECT Id, Name, RC_Invoice_Date__c FROM RC_Delivery_and_Billing__c WHERE Name =: deliveryNo limit 1];
                if(billing != null)
                {
                    RC_IptalIadeGetOrdersIntegrator.requestModel req = new RC_IptalIadeGetOrdersIntegrator.requestModel();
                    RC_IptalIadeGetOrdersIntegrator.Item_9 a = new RC_IptalIadeGetOrdersIntegrator.Item_9();
                    a.VBELN_VL =billing.Name;
                    RC_IptalIadeGetOrdersIntegrator.IT_VBELNVL tes = new RC_IptalIadeGetOrdersIntegrator.IT_VBELNVL();    
                    tes.Item = new List<RC_IptalIadeGetOrdersIntegrator.Item_9>();
                    tes.Item.Add(a);
                    req.IT_VBELN_VL = tes;
                    if(billing.RC_Invoice_Date__c == null){billing.RC_Invoice_Date__c = Date.newInstance(2021, 3, 30);}    
                    req.IV_FKDAT_F = formatDate(billing.RC_Invoice_Date__c);
                    req.IV_FKDAT_S = formatDate(billing.RC_Invoice_Date__c.addDays(-90));
                    
                    RC_IptalIadeGetOrdersIntegrator.responseModel resp = new RC_IptalIadeGetOrdersIntegrator.responseModel();
                    resp.Result = new RC_IptalIadeGetOrdersParser.ET_RESULT();
                    resp.Message = new RC_IptalIadeGetOrdersParser.ET_MESSAGE();          
                    resp = RC_IptalIadeGetOrdersIntegrator.getIptalIade(req); 
                    if(resp != null && resp.Result != null)
                    {
                        //for (RC_IptalIadeGetOrdersParser.Item data : resp.Result.item) {
                        //RC_IptalIadeGetPackagedSalesIntegrator.requestModel req2 = new RC_IptalIadeGetPackagedSalesIntegrator.requestModel();
                        //req2.IV_AUGRU=data.SIP_GRKC;
                        //system.debug(req2);
                        //RC_IptalIadeGetPackagedSalesIntegrator.responseModel respPackages = new RC_IptalIadeGetPackagedSalesIntegrator.responseModel();
                        //respPackages.export1 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT1();
                        //respPackages.export2 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT2();
                        //respPackages.export3 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT3();
                        //respPackages.export4 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT4();
                        //respPackages.export5 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT5();
                        //respPackages.export6 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT6();         
                        //respPackages.EV_ID = '';          
                        //respPackages.EV_PACKAGE = '';          
                        //respPackages = RC_IptalIadeGetPackagedSalesIntegrator.getIptalIadePackages(req2);  
                        //}
                    }
                    List<IptIadeDetail> lstDetail= new List<IptIadeDetail>();
                    if(resp != null && resp.Result!=null && resp.Result.item!=null && resp.Result.item.size()>0){
                      for(RC_IptalIadeGetOrdersParser.Item i : resp.Result.item)
                    {
                        IptIadeDetail b = new IptIadeDetail(i.SIP_GRKC,i.PAKET_TANIM,i.FAT_IADE_MIK,i.FAT_AL_MIK,0,i.MATNR.remove('0000000000'),i.MAKTX,i.FAT_NO+ '_' + i.FAT_KLM,string.valueOf(i.SATIS_ORG),i.DGTM_KANALI,string.valueOf(i.BOLUM),i.SIP_NO,string.valueOf(i.SIP_KLM),i.FAT_NO,string.valueOf(i.FAT_KLM),i.KUNAG,i.SIP_TUR);
                        
                        lstDetail.add(b);
                    }  
                    }
                    
                    system.debug(lstDetail);
                    
                    return lstDetail;
                }
                return null;
                
            }
            return null;
        }            
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }
    
    
    @AuraEnabled(cacheable=true)
    public static CreateOrderRetVal sendSap(List<IptIadeDetail> lst,       
                                            String depoYeri,string uretimYeri,string toplamaYeri,string tmEventCode,string refundReason,string invoiceCustomer,string teslimEden){
                                                try {        
                                                    
                                                    RC_IptalIadeReturnOrderCreateIntegrator.requestModel req = new RC_IptalIadeReturnOrderCreateIntegrator.requestModel();
                                                    
                                                    RC_IptalIadeReturnOrderCreateIntegrator.IS_HEADER is_header = new RC_IptalIadeReturnOrderCreateIntegrator.IS_HEADER();
                                                    RC_IptalIadeReturnOrderCreateIntegrator.IT_ITEM it_item = new RC_IptalIadeReturnOrderCreateIntegrator.IT_ITEM();
                                                    RC_IptalIadeReturnOrderCreateIntegrator.ET_SALES_PARTNERS partner = new RC_IptalIadeReturnOrderCreateIntegrator.ET_SALES_PARTNERS();
                                                    for(IptIadeDetail i : lst)
                                                    {
                                                        is_header.REF_SIP_NO = i.SIP_NO;
                                                        is_header.NEW_VKORG  = i.SATIS_ORG;
                                                        is_header.NEW_VTWEG  = i.DGTM_KANALI;
                                                        is_header.NEW_SPART  = i.BOLUM;
                                                        is_header.NEW_AUART  = 'V14';//İADE SIPARIŞ GEREKÇESİ  SIP_TUR une göre karşılık gelen data gönderilecek
                                                        is_header.NEW_USAGE  = refundReason; //İPTAL NEDENİ
                                                        is_header.NEW_BSTKD  = RC_Asseco_Integrator.GenerateRandomKey(20); 
                                                        is_header.LIFSP      ='ZI';//sabit
                                                        is_header.NEW_VSART  ='';//bişey gitmiyor sanırım.
                                                        is_header.SIMULATION ='';
                                                        is_header.NEW_FAT_KUNNR=invoiceCustomer;//ürünün yeni faturalanacağı kişi.
                                                        
                                                        it_item.item = new List<RC_IptalIadeReturnOrderCreateIntegrator.Item>();
                                                        
                                                        RC_IptalIadeReturnOrderCreateIntegrator.Item item = new RC_IptalIadeReturnOrderCreateIntegrator.Item();
                                                        item.REF_POSNR = i.SIP_KLM;
                                                        item.NEW_MENGE = string.valueOf(i.IAD_AL_MIK);//adet
                                                        item.NEW_WERKS = uretimYeri;//uretim yeri
                                                        item.NEW_LGORT = depoYeri;//depo yeri
                                                        item.REF_FATURA= i.FAT_NO;
                                                        item.REF_FAT_KALEM=i.FAT_KLM;
                                                        it_item.item.Add(item);
                                                        
                                                        partner.item = new List<RC_IptalIadeReturnOrderCreateIntegrator.Item2>();
                                                        
                                                        RC_IptalIadeReturnOrderCreateIntegrator.Item2 item2 = new RC_IptalIadeReturnOrderCreateIntegrator.Item2();
                                                        item2.PARTN_ROLE ='WE';
                                                        if (tmEventCode == '04' || tmEventCode == '05')
                                                        {
                                                            item2.PARTN_NUMB = ('00'+teslimEden).Right(10);
                                                        }
                                                        else
                                                        {
                                                            item2.PARTN_NUMB = toplamaYeri;
                                                        }
                                                        partner.item.Add(item2);
                                                        
                                                        req.IS_HEADER = is_header;
                                                        req.IT_ITEM = it_item;
                                                        req.ET_SALES_PARTNERS = partner;
                                                    }
                                                    system.debug('req'+req);
                                                    RC_IptalIadeReturnOrderCreateIntegrator.responseModel resp = new RC_IptalIadeReturnOrderCreateIntegrator.responseModel();
                                                    
                                                    resp.ET_MESSAGE = new  RC_IptalIadeReturnOrderCreateParser.ET_MESSAGE();
                                                    resp.EV_DELIVERYDOCUMENT='';
                                                    resp.EV_SALESDOCUMENT='';
                                                    resp.EV_SUCCESS='';
                                                    resp.ET_SALES_PARTNERS = new  RC_IptalIadeReturnOrderCreateParser.ET_SALES_PARTNERS();
                                                    resp = RC_IptalIadeReturnOrderCreateIntegrator.getIptalIadeReturnOrderCreate(req);       
                                                    system.debug(resp);
                                                    system.debug(resp.EV_SALESDOCUMENT);
                                                    system.debug(resp.EV_DELIVERYDOCUMENT);
                                                    string message='';
                                                    if(resp != null && resp.ET_MESSAGE != null && resp.ET_MESSAGE.item != null){
                                                        for(RC_IptalIadeReturnOrderCreateParser.Item p : resp.ET_MESSAGE.item)
                                                        {
                                                            if(p.TYPE =='E'){message +=p.MESSAGE+' - ';}
                                                        }
                                                    }
                                                    CreateOrderRetVal ret = new CreateOrderRetVal(resp.EV_SUCCESS,message,resp.EV_SALESDOCUMENT);
                                                    return ret;
                                                }           
                                                catch (Exception e) {throw new AuraHandledException(e.getMessage());}
                                            }
    
    
    private static String formatDateForQuery(Date formatDate){ 
        // return ((Datetime)formatDate).format('yyyy-MM-dd HH:mm:ss').replace(' ', 'T') + '.0000+0000';
        return ((Datetime)formatDate).format('yyyy-MM-dd');
    }
    
    public static String formatDate(Date d) {
        return ((Datetime)d).format('yyyyMMdd');
    }
    

public class BillingWrapper{
    @AuraEnabled
    public Id id {get; set;}
    @AuraEnabled
    public String deliveryNo {get; set;}
    @AuraEnabled
    public String invNo {get; set;}
    @AuraEnabled
    public Datetime invDate {get; set;}
    @AuraEnabled
    public Decimal invQuantity {get; set;}
    @AuraEnabled
    public Decimal totalWithoutTaxx {get; set;}
    @AuraEnabled
    public string productNames {get; set;}
    @AuraEnabled
    public String orderNo {get; set;}
    @AuraEnabled
    public Decimal payableAmount {get; set;}
    @AuraEnabled
    public Boolean canPayable {get; set;}
    @AuraEnabled
    public String uuid {get; set;}
    @AuraEnabled
    public Decimal payedAmount {get; set;}

    public BillingWrapper(){}
        
        public BillingWrapper(Id id, String Name,  String invNo, Datetime invDate, Decimal invQuantity, Decimal totalWithoutTaxx, String productNames, String OrderNumber, Decimal payableAmount, Boolean canPayable, String uuid,decimal payedAmount){
            this.id = id;
            this.deliveryNo = Name;
            this.invNo = invNo;
            this.invDate = invDate;
            this.invQuantity = invQuantity;
            this.totalWithoutTaxx = totalWithoutTaxx;
            this.productNames = productNames;
            this.orderNo = OrderNumber;
            this.payableAmount = payableAmount;
            this.canPayable = canPayable;
            this.uuid = uuid;
            this.payedAmount = payedAmount;

        }
}

    public class IptIadeDetail{
        @AuraEnabled
        public string SIP_GRKC {get; set;}    
        @AuraEnabled
        public string PAKET_TANIM {get; set;}
        @AuraEnabled
        public integer FAT_IADE_MIK {get; set;}
        @AuraEnabled
        public string FAT_AL_MIK {get; set;}
        @AuraEnabled
        public integer IAD_AL_MIK {get; set;}
        @AuraEnabled
        public string MATNR {get; set;}
        @AuraEnabled
        public string MAKTX {get; set;}
        @AuraEnabled
        public string UNIQECODE {get; set;}
        @AuraEnabled
        public string SATIS_ORG {get; set;}
        @AuraEnabled
        public string DGTM_KANALI {get; set;}
        @AuraEnabled
        public string BOLUM {get; set;}
        @AuraEnabled
        public string SIP_NO {get; set;}
        @AuraEnabled
        public string SIP_KLM {get; set;}    
        @AuraEnabled
        public string FAT_NO {get; set;}
        @AuraEnabled
        public string FAT_KLM {get; set;}
        @AuraEnabled
        public string KUNAG {get; set;}
        @AuraEnabled
        public string SIP_TUR {get; set;}
        public IptIadeDetail(){}
        
        public IptIadeDetail(string SIP_GRKC,String PAKET_TANIM,integer FAT_IADE_MIK,string FAT_AL_MIK,integer IAD_AL_MIK,String MATNR, string MAKTX,string UNIQECODE,
                             string SATIS_ORG,string DGTM_KANALI,string BOLUM,string SIP_NO,string SIP_KLM,string FAT_NO,string FAT_KLM,
                             string KUNAG,String SIP_TUR){        
                                 this.SIP_GRKC = SIP_GRKC;   
                                 this.PAKET_TANIM = PAKET_TANIM;   
                                 this.FAT_IADE_MIK = FAT_IADE_MIK;   
                                 this.FAT_AL_MIK = FAT_AL_MIK;   
                                 this.IAD_AL_MIK = IAD_AL_MIK; 
                                 this.MATNR = MATNR;   
                                 this.MAKTX = MAKTX;  
                                 this.UNIQECODE = UNIQECODE;
                                 this.SATIS_ORG = SATIS_ORG;   
                                 this.DGTM_KANALI = DGTM_KANALI;   
                                 this.BOLUM = BOLUM;   
                                 this.SIP_NO = SIP_NO;   
                                 this.SIP_KLM = SIP_KLM;   
                                 this.FAT_NO = FAT_NO;   
                                 this.FAT_KLM = FAT_KLM;   
                                 this.KUNAG = KUNAG;
                                 this.SIP_TUR = SIP_TUR;
                             }
    }
    
    public class CreateOrderRetVal{
        @AuraEnabled
        public string EV_SUCCESS {get; set;}    
        @AuraEnabled
        public string MESSAGE {get; set;}
        @AuraEnabled
        public string EV_SALESDOCUMENT {get; set;}
        
        public CreateOrderRetVal(){}
        
        public CreateOrderRetVal(string EV_SUCCESS,String MESSAGE,string EV_SALESDOCUMENT){        
            this.EV_SUCCESS = EV_SUCCESS;   
            this.MESSAGE = MESSAGE;   
            this.EV_SALESDOCUMENT = EV_SALESDOCUMENT;        
        }
    }
    
    public class CancelRefundReason{
        @AuraEnabled
        public string CODE {get; set;}
        
        @AuraEnabled
        public string NAME {get; set;}
        
        public CancelRefundReason(){}
        
        public CancelRefundReason(string CODE,String NAME){        
            this.CODE = CODE;   
            this.NAME = NAME;  
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static List<CancelRefundReason> getCancelRefundReason(string isInvoiceStatus,string status){
        List<CancelRefundReason> cancelRefundReasons = new List<CancelRefundReason>();
        try {      
            system.debug(isInvoiceStatus+'_'+ status);
            String searchedQuery = 'SELECT  Name, RC_Value__c FROM RC_Definition__c WHERe type__c=\'Cancel Refund Reason\' ';
            if (isInvoiceStatus =='1') {
                searchedQuery += ' AND RC_Has_It_Billing__c = true';
            }
            else if (isInvoiceStatus =='2') {
                searchedQuery += ' AND RC_Has_It_Billing__c = false';
            }
            if (status =='2') {                
                searchedQuery += ' AND (Name like\''+ '%hasar%\' or RC_Value__c =\'E3\' )';
            }   
            searchedQuery +=' ORDER BY RC_Value__c';        
            
            if(String.isNotBlank(searchedQuery)){
                system.debug(searchedQuery);
                List<RC_Definition__c> foundedList = Database.query(searchedQuery);
                
                if(foundedList == null || foundedList.size() < 1){
                    return null;
                }
                else{
                    for (RC_Definition__c data : foundedList) {            
                        CancelRefundReason prepared = new CancelRefundReason(
                            data.RC_Value__c,
                            data.RC_Value__c+' - '+data.Name
                        );
                        cancelRefundReasons.add(prepared);
                    }
                }
            }
            return cancelRefundReasons;
        } 
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }
    
    @AuraEnabled(cacheable = true)
    public static CancelRefundProductionPlaceStorePlace getInfoByCancelRefundCode(string isInvoiceStatus,string status,string cancelRefundCode,string deliveryNo){
        CancelRefundProductionPlaceStorePlace cancelRefund = new CancelRefundProductionPlaceStorePlace();
        try {          
            
            RC_SD_CargoIntegrator.Item item = new RC_SD_CargoIntegrator.Item();
            item.TES_NO = deliveryNo;            
            RC_SD_CargoIntegrator.ITVBELN itvBeln = new RC_SD_CargoIntegrator.ITVBELN();
            itvBeln.item = new List<RC_SD_CargoIntegrator.Item>();
            itvBeln.item.add(item);            
            RC_SD_CargoIntegrator.requestModel req = new RC_SD_CargoIntegrator.requestModel();
            req.IT_VBELN = itvBeln;            
            string tmCode= RC_SD_CargoIntegrator.getTMCodeCargo(req);
            if(!string.isNotBlank(tmcode) || test.isRunningTest())
            {
                tmcode='14';
            }
            string tmLocalCode='';
            string query ='SELECT  Name, RC_Value__c FROM RC_Definition__c WHERE type__c=\'Event Map\' AND Name=\''+tmcode+ '\'';        
            List<RC_Definition__c> foundedTM = Database.query(query);
            if(foundedTM == null || foundedTM.size() < 1){
                return null;
            }
            else{
                for (RC_Definition__c data : foundedTM) {            
                    tmLocalCode =data.RC_Value__c;
                }
            }    
            system.debug('tmLocalCode:'+ tmLocalCode);
            String searchedQuery = 'SELECT  RC_Production_Place__c,Store_Place__c,Toplama_Yeri__c FROM RC_Definition__c';
            searchedQuery += ' WHERE Name =\''+ cancelRefundCode +'\'';
            searchedQuery += ' and RC_TM_Event_Code__c = \''+ tmLocalCode +'\' ';
            
            if (isInvoiceStatus =='1') {
                searchedQuery += ' AND RC_Has_It_Billing__c = true';
            }
            
            if (isInvoiceStatus =='2') {
                searchedQuery += ' AND RC_Has_It_Billing__c = false';
            }
            
            if (status =='1') {                
                searchedQuery += ' and RC_IS_DAMAGED__c = False ';
            }  
            if (status =='2') {                
                searchedQuery += ' and RC_IS_DAMAGED__c = True ';
            }
            if(String.isNotBlank(searchedQuery)){    
                system.debug('searchedQuery : ' + searchedQuery);
                List<RC_Definition__c> foundedList = Database.query(searchedQuery);
                
                if(foundedList == null || foundedList.size() < 1){
                    return null;
                }
                else{
                    for (RC_Definition__c data : foundedList) {            
                        CancelRefundProductionPlaceStorePlace prepared = new CancelRefundProductionPlaceStorePlace(
                            data.RC_Production_Place__c,
                            data.Store_Place__c,
                            data.Toplama_Yeri__c,
                            tmLocalCode
                        );
                        cancelRefund = prepared;
                    }  
                }
            }
            return cancelRefund;
        } 
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }
    
    @AuraEnabled(cacheable = true)
    public static List<CancelRefundDelivering> getDelivering(string accountId){  
        List<CancelRefundDelivering> cancelRefundDelivering = new List<CancelRefundDelivering>();
        try {      
            
            system.debug('myinvoiceGetDelAccId:' + accountId);
            if(accountId !='')
            {
                string searchedQuery = 'SELECT Name, RC_SAP_ID__c FROM Account';
                searchedQuery += ' WHERE id =\''+ accountId +'\' or ParentId=\''+ accountId+ '\'';
                if(String.isNotBlank(searchedQuery)){    
                    system.debug(searchedQuery);
                    
                    List<Account> foundedListAccount = Database.query(searchedQuery);
                    system.debug(foundedListAccount);
                    if(foundedListAccount == null || foundedListAccount.size() < 1){
                        return null;
                    }
                    else{
                        for (Account data : foundedListAccount) {            
                            CancelRefundDelivering prepared = new CancelRefundDelivering(
                                data.RC_SAP_ID__c,
                                data.RC_SAP_ID__c + ' - '+ data.Name
                            );
                            
                            cancelRefundDelivering.add(prepared);
                        }
                    }
                }
            }
            system.debug(cancelRefundDelivering);
            return cancelRefundDelivering;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }
    
    public class CancelRefundProductionPlaceStorePlace{
        @AuraEnabled
        public string PRODUCTIONPLACE {get; set;}
        
        @AuraEnabled
        public string STOREPLACE {get; set;}
        @AuraEnabled
        public string TOPLAMAYERI {get; set;}
        @AuraEnabled
        public string TMLOCALCODE {get; set;}
        public CancelRefundProductionPlaceStorePlace(){}
        
        public CancelRefundProductionPlaceStorePlace(string PRODUCTIONPLACE,String STOREPLACE,String TOPLAMAYERI,string TMLOCALCODE){        
            this.PRODUCTIONPLACE = PRODUCTIONPLACE;   
            this.STOREPLACE = STOREPLACE;  
            this.TOPLAMAYERI=TOPLAMAYERI;
            this.TMLOCALCODE=TMLOCALCODE;
            
        }
    }

    public class initModel {      
        @AuraEnabled  
        public Boolean isCommunity {get;set;}
        @AuraEnabled  
        public String selectedAccountId {get;set;}
      }
    
    public class CancelRefundDelivering{
        @AuraEnabled
        public string value {get; set;}
        @AuraEnabled
        public string label {get; set;}
        
        public CancelRefundDelivering(){}
        
        public CancelRefundDelivering(string CODE,String NAME){        
            this.value = CODE;   
            this.label = NAME;  
        }
    }

    public class PickListValues{
        @AuraEnabled
        public string value {get; set;}
        @AuraEnabled
        public string label {get; set;}
        
        public PickListValues(){}
        
        public PickListValues(string CODE,String NAME){        
            this.value = CODE;   
            this.label = NAME;  
        }
    }

    @AuraEnabled(cacheable = true)
    public static String getInvoicePDFLink(){
        String invoicePDFLink='';
        try
        {             
            NamedCredential oInvoicePDFLink = [SELECT DeveloperName, Endpoint FROM NamedCredential where DeveloperName ='InvoicePDFLink' limit 1];
            invoicePDFLink = oInvoicePDFLink.Endpoint;
            system.debug('invoicePDFLink : ' + invoicePDFLink);
        }
        catch (Exception e){throw new AuraHandledException(e.getMessage());}
        
        return invoicePDFLink;
    }
 }