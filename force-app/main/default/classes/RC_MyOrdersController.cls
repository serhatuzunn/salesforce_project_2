public inherited sharing class RC_MyOrdersController {
    
    public class OrdersWrapper{
        @AuraEnabled
        public Id id {get; set;}
        
        @AuraEnabled
        public String orderNo {get; set;}
        
      
        @AuraEnabled
        public Datetime orderDate {get; set;}
        
        @AuraEnabled
        public String statu {get; set;}
           
        @AuraEnabled
        public Decimal totalAmount {get; set;}
        
        @AuraEnabled
        public Decimal payedAmount {get; set;}
        
        @AuraEnabled
        public Decimal payableAmount {get; set;}
        
        @AuraEnabled
        public Boolean canPayable {get; set;}
          
        @AuraEnabled
        public String category {get; set;}
        
        @AuraEnabled
        public string productCode {get; set;}
        
        @AuraEnabled
        public String productName {get; set;}
        
        @AuraEnabled
        public Decimal quantity {get; set;}
        
        @AuraEnabled
        public Decimal totalPrice {get; set;} 
        @AuraEnabled
        public Decimal unitPrice {get; set;}
        
        public OrdersWrapper(Id id, String orderNo,  Datetime orderDate, String statu, Decimal totalAmount, Decimal payedAmount, Decimal payableAmount, Boolean canPayable,String category, string productCode, String productName, Decimal quantity, Decimal totalPrice, Decimal unitPrice)
        {
            this.id = id;
            this.orderNo = orderNo;            
            this.orderDate = orderDate;
            this.statu = statu;            
            this.totalAmount = totalAmount;
            this.payedAmount = payedAmount;
            this.payableAmount = payableAmount;
            this.canPayable = canPayable;
            this.category = category;
            this.productCode = productCode;
            this.productName = productName;
            this.quantity = quantity;
            this.totalPrice = totalPrice;
            this.unitPrice = unitPrice;
        }
    }  
    
    @AuraEnabled(cacheable = true)
    public static List<OrdersWrapper> GetOrders(Date startDate, Date endDate, String orderNo, String orderReason, 
    String orderStatus, String category1, String category2, String category3, String listType,string productId ){
        List<OrdersWrapper> ordersList = new List<OrdersWrapper>();
        Account relatedAccount = RC_UtilitiesClass.getUserRelatedAccount();        
        List<Order> orderList = null;
        List<AggregateResult> orderItem = null;
        try 
        {
             string searchedQuery='';
             if(listType=='2')   
             {
                 searchedQuery = 'SELECT Id, ToLabel(Status),RC_Order_No__c,EffectiveDate,TotalAmount,RC_Mobile_Product__c FROM Order';
             
                 if(relatedAccount != null)
                 {
                    searchedQuery += ' WHERE TYPE NOT IN (\'V23\',\'V12\',\'V99\',\'V14\',\'ZHDC\')'; 

                     if (startDate != null || endDate != null || string.isNotBlank(orderNo)
                     || string.isNotBlank(orderReason) || string.isNotBlank(orderStatus)
                     || string.isNotBlank(category1) || string.isNotBlank(productId) || string.isNotBlank(category2) || string.isNotBlank(category3)) 
                     {                
                         if (startDate != null) {
                             searchedQuery += ' and EffectiveDate >= ' + formatDateForQuery(startDate);                        
                         }                
                         if(endDate != null){                        
                             searchedQuery += ' AND EffectiveDate <= ' + formatDateForQuery(endDate);                        
                         }                 
                         if (string.isNotBlank(orderNo) ) {                        
                             searchedQuery += ' AND RC_Order_No__c = \'' + orderNo + '\'';                        
                         }
                         if (string.isNotBlank(orderReason)) {                        
                             searchedQuery += ' AND RC_Order_Justification__c = \'' + orderReason + '\'';                        
                         }
                         if (string.isNotBlank(orderStatus)) {                        
                             searchedQuery += ' AND Status = \'' + orderStatus + '\'';                        
                         }
                         if (string.isNotBlank(category3)) {                        
                             searchedQuery += ' AND Id in (select orderId from OrderItem where Product2.RC_Product_hiy_Level_3__c = \'' + category3 + '\')';                        
                          }
                         else if (string.isNotBlank(category2) ) {                        
                             searchedQuery +=  ' And Id in (select orderId from OrderItem where Product2.RC_Product_hiy_Level_2__c = \'' + category2 + '\')';                        
                         }
                         else if (string.isNotBlank(category1)) {                        
                             searchedQuery += ' AND  Id in (select orderId from OrderItem where Product2.RC_Product_hiy_Level_1__c = \'' + category1 + '\')';                                             
                         }
                         if (string.isNotBlank(productId))
                         {
                             searchedQuery +=' AND id in (select OrderId from OrderItem where Product2Id =\''+ productId +'\')';
                         }
                       
                    }
                    system.debug('searchedQuery : '+productId+'_'+ searchedQuery);
                    searchedQuery += ' AND AccountId = \'' + relatedAccount.Id  + '\'';
                    orderList = Database.query(searchedQuery);
                 }
                 if(orderList == null || orderList.size() < 1){
                    return null;
                 }
                 else{
                     List<String> sipNoList = new List<String>();
                     for (Order data : orderList) {
                         if (String.isNotBlank(data.RC_Order_No__c)) {
                             sipNoList.add(data.RC_Order_No__c);
                        }
                     }
                    
                    RC_SD_GetPayedAmount.PayedAmountResponseModel parm = null;
                     if (sipNoList != null && sipNoList.size() > 0) {
                         system.debug('orderno:'+sipNoList);
                         parm = RC_SD_GetPayedAmount.CheckPayedAmount(sipNoList, 'Siparis');
                         system.debug('parm;' + parm);
                     }
                    
                    Map<String, Decimal> payedAmountMap = new Map<String, Decimal>();
                    if(parm != null && parm.ET_RESULTS != null && parm.ET_RESULTS.item != null && parm.ET_RESULTS.item.size() > 0)
                    {
                         for (RC_SD_GetPayedAmount.MainItemResultModel data : parm.ET_RESULTS.item) 
                         {
                             Decimal convertedTutar = Double.valueOf(data.TUTAR);                        
                             if (!payedAmountMap.containsKey(String.valueOf(data.SIP_NO))) 
                             {
                                 payedAmountMap.put(String.valueOf(data.SIP_NO), convertedTutar);
                             }
                             else
                             {
                                 Decimal foundedTutar = payedAmountMap.get(String.valueOf(data.SIP_NO));                            
                                 payedAmountMap.put(String.valueOf(data.SIP_NO), foundedTutar + convertedTutar);
                             }
                         }
                     }                
                     for (Order data : orderList) 
                     {                    
                         Decimal payedAmount = payedAmountMap.containsKey(data.RC_Order_No__c) ? payedAmountMap.get(data.RC_Order_No__c) : 0;                    
                         Boolean isPayable = data.RC_Mobile_Product__c > 0;
                         system.debug('RC_Mobile_Product__c : '+ data.RC_Mobile_Product__c);
                         OrdersWrapper preparedOrder = new OrdersWrapper(
                             data.Id,
                             data.RC_Order_No__c,                          
                             data.EffectiveDate,
                             data.Status,                         
                             data.TotalAmount,
                             payedAmount,
                             data.TotalAmount - payedAmount,
                             !isPayable,
                             null,
                             null,
                             null,
                             null,
                             null,
                             null

                         );                    
                         ordersList.add(preparedOrder);
                     }
                 }                    
                 return ordersList; 
             }  
             else
             {
                 searchedQuery = 'select product2.RC_Product_hie_Level_3__r.Name category, product2.ProductCode, Product2.Name,Sum(Quantity)Quantity, sum(TotalPrice)TotalPrice,RC_Unit_of_Measure__c from OrderItem';
                 if(relatedAccount != null)
                 {
                    searchedQuery += ' WHERE RC_ExternalId__c !=\'\' '; 

                     if (startDate != null || endDate != null || string.isNotBlank(orderNo) || string.isNotBlank(orderReason) || string.isNotBlank(orderStatus) || string.isNotBlank(category1) || string.isNotBlank(productId) || string.isNotBlank(category2) || string.isNotBlank(category3)) 
                     {                
                         if (startDate != null) {
                             searchedQuery += ' and Order.EffectiveDate >= ' + formatDateForQuery(startDate);                        
                         }                
                         if(endDate != null){                        
                             searchedQuery += ' AND Order.EffectiveDate <= ' + formatDateForQuery(endDate);                        
                         }                
                         if (string.isNotBlank(orderNo) ) {                        
                             searchedQuery += ' AND Order.RC_Order_No__c = \'' + orderNo + '\'';                        
                         }
                         if (string.isNotBlank(orderReason)) {                        
                             searchedQuery += ' AND Order.RC_Order_Justification__c = \'' + orderReason + '\'';                        
                         }
                         if (string.isNotBlank(orderStatus)) {                        
                             searchedQuery += ' AND Order.Status = \'' + orderStatus + '\'';                        
                         }
                         if (string.isNotBlank(category3)) {                        
                             searchedQuery += ' AND Product2.RC_Product_hiy_Level_3__c = \'' + category3 + '\'';                        
                         }
                         else if (string.isNotBlank(category2) ) {                        
                             searchedQuery +=  ' And Product2.RC_Product_hiy_Level_2__c = \'' + category2 + '\'';                        
                         }
                         else if (string.isNotBlank(category1)) {                        
                             searchedQuery += ' AND  Product2.RC_Product_hiy_Level_1__c = \'' + category1 + '\'';                                             
                         }     
                         if (string.isNotBlank(productId)) {                        
                            searchedQuery += ' AND  Product2Id = \'' + productId + '\'';                                             
                        }                         
                     }
                     searchedQuery += ' AND Order.AccountId = \'' + relatedAccount.Id  + '\'';
                         searchedQuery +=' group by product2.RC_Product_hie_Level_3__r.Name,product2.ProductCode,Product2.Name ,RC_Unit_of_Measure__c ';

                         orderItem = Database.query(searchedQuery);
                 }
                 if(orderItem == null || orderItem.size() < 1){
                    return null;
                 }
                 else{                                     
                     for (AggregateResult data : orderItem) 
                     {   
                        OrdersWrapper preparedOrder = new OrdersWrapper(
                            null,
                            null,                            
                            null,
                            null,
                            null,
                            null,
                            null,
                            null,
                            string.valueof(data.get('category')) ,
                            string.valueof(data.get('ProductCode')),
                            string.valueof(data.get('Name')),
                            (Decimal)data.get('Quantity'),
                            (Decimal)data.get('TotalPrice'),                            
                            null

                        );        
                        ordersList.add(preparedOrder);
                     }
                 }                    
                 return ordersList;                 
             }                    
         }    
         catch (Exception ex){throw new AuraHandledException(ex.getMessage());}
     }
    
    private static String formatDateForQuery(Date formatDate){
        return ((Datetime)formatDate).format('yyyy-MM-dd');
    }
    private static String formatDateForScreen(Datetime formatDate){
        return ((Datetime)formatDate).format('dd-MM-yyyy');
    }
    
    public class OrderDetailsWrapper{
        @AuraEnabled
        public Id id {get; set;}
        
        @AuraEnabled
        public String orderNo {get; set;}
        
        @AuraEnabled
        public String productName {get; set;}
        
        @AuraEnabled
        public String productCode {get; set;}  
        
        @AuraEnabled
        public String orderProductNo {get; set;}   
        
        @AuraEnabled
        public Decimal quantity {get; set;}
        
        @AuraEnabled
        public Decimal unitPrice {get; set;}
        
        @AuraEnabled
        public Decimal totalPrice {get; set;}
        @AuraEnabled
        public string itemStatuDefinition {get; set;}
        
        public OrderDetailsWrapper(Id id, String orderNo, String orderProductNo, String productName, String productCode, Decimal quantity, Decimal unitPrice, Decimal totalPrice,string itemStatuDefinition)
        {
            this.id = id;
            this.orderNo = orderNo;
            this.orderProductNo = orderProductNo;
            this.productName = productName;
            this.productCode = productCode;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.totalPrice = totalPrice;
            this.itemStatuDefinition = itemStatuDefinition;
        }
    }

    public class OrderDeliveryBillingsWrapper{
        @AuraEnabled
        public Id id {get; set;}        
        
        @AuraEnabled
        public String deliveryNo {get; set;}
        
        @AuraEnabled
        public String deliveryStatus {get; set;}  
        
        @AuraEnabled
        public Date deliveryDate {get; set;}     
        @AuraEnabled
        public string invoiceNo{get; set;}     
        @AuraEnabled
        public string productInfo{get; set;} 
        public OrderDeliveryBillingsWrapper(Id id, String deliveryNo, String deliveryStatus, Date deliveryDate,string invoiceNo,string productInfo)
        {
            this.id = id;            
            this.deliveryNo = deliveryNo;
            this.deliveryStatus = deliveryStatus;
            this.deliveryDate = deliveryDate;
            this.invoiceNo = invoiceNo;
            this.productInfo = productInfo;
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static List<OrderDetailsWrapper> GetOrderDetails(Id orderId,Boolean addresTransfer){
        system.debug('orderId'+ orderId);
        List<OrderDetailsWrapper> orderDeatilList = new List<OrderDetailsWrapper>();
        String searchedQuery = 'SELECT Id, Order.RC_Order_No__c, Product2.Name, Product2.ProductCode,RC_Order_Product_No__c, Quantity, UnitPrice, TotalPrice,RC_SAP_Status_Definition__c   FROM OrderItem Where RC_Reason_for_Rejection__c =\'\'  and OrderId = \'' + orderId  + '\'';
        List<OrderItem> orderDeatils = Database.query(searchedQuery);
        List<RC_Delivery_and_Billing__c> delivery = new List<RC_Delivery_and_Billing__c>();
        if(addresTransfer)
        {
            searchedQuery ='select Product_Code__c,RC_Delivery_Quantity__c from RC_Delivery_and_Billing__c where RC_Order_Number__c =\'' + orderId  + '\'';
           delivery = Database.query(searchedQuery);

        }
        

        for (OrderItem data : orderDeatils) 
        {
            if(addresTransfer)
            {
                 decimal quant =0;
                 for(RC_Delivery_and_Billing__c db : delivery)
                 {
                     if (data.Product2.ProductCode == db.Product_Code__c)
                     {
                         quant+=db.RC_Delivery_Quantity__c;
                     }
                 }
                 if(data.Quantity > quant)
                 {
                     OrderDetailsWrapper preparedOrderDetail = new OrderDetailsWrapper(
                         data.Id,
                         data.Order.RC_Order_No__c,
                         data.RC_Order_Product_No__c,
                         data.Product2.Name,
                         data.Product2.ProductCode,
                         data.Quantity - quant,
                         data.UnitPrice,
                         data.TotalPrice,
                         data.RC_SAP_Status_Definition__c
                  );  
            orderDeatilList.add(preparedOrderDetail);

                 }
                 
            }
            else
            {
                 OrderDetailsWrapper preparedOrderDetail = new OrderDetailsWrapper(
                     data.Id,
                     data.Order.RC_Order_No__c,
                     data.RC_Order_Product_No__c,
                     data.Product2.Name,
                     data.Product2.ProductCode,
                     data.Quantity,
                     data.UnitPrice,
                     data.TotalPrice,
                     data.RC_SAP_Status_Definition__c
                );           
            orderDeatilList.add(preparedOrderDetail);

            }
                 
        }
        return orderDeatilList;
    }

    @AuraEnabled(cacheable = true)
    public static List<OrderDeliveryBillingsWrapper> GetOrderDeliveryBillings(Id orderId){
        system.debug('orderId'+ orderId);
        List<OrderDeliveryBillingsWrapper> orderDeliveryBillings = new List<OrderDeliveryBillingsWrapper>();
        String searchedQuery = 'SELECT Id, Name,RC_Delivery_Status__c,RC_Delivery_Date__c, RC_Invoice_No__c,Product_Code__c,RC_Product__c FROM RC_Delivery_and_Billing__c where RC_Order_Number__c =\'' + orderId  + '\'';
        List<RC_Delivery_and_Billing__c> searchOrderDeliveryBillings = Database.query(searchedQuery);
        
        for (RC_Delivery_and_Billing__c data : searchOrderDeliveryBillings) 
        {
            OrderDeliveryBillingsWrapper preparedDeliveryBillings = new OrderDeliveryBillingsWrapper(
                data.Id,
                data.Name,
                data.RC_Delivery_Status__c,
                data.RC_Delivery_Date__c,
                data.RC_Invoice_No__c,
                data.Product_Code__c + '-' + data.RC_Product__c
                
            );                    
            orderDeliveryBillings.add(preparedDeliveryBillings);
        }
        return orderDeliveryBillings;
    }

    @AuraEnabled(cacheable = true)
    public static List<OrdersWrapper> GetOrderDetailsProduct(string productCode){
        Account relatedAccount = RC_UtilitiesClass.getUserRelatedAccount();        
        List<OrdersWrapper> orderList = new List<OrdersWrapper>();
        List<OrderItem>  orderItem = null;
        string searchedQuery='SELECT order.Id, order.RC_Order_No__c ,order.EffectiveDate,TotalPrice ,UnitPrice, Quantity FROM orderItem Where RC_Reason_for_Rejection__c =\'\' and order.RC_Reason_for_Rejection__c =\'\' and  Product2.ProductCode=\''+ productCode + '\' and order.AccountId = \'' + relatedAccount.Id  + '\'';
        system.debug('Product Query:' + searchedQuery);
        orderItem = Database.query(searchedQuery);
        
        for (OrderItem data : orderItem) 
        {
            OrdersWrapper preparedDetail = new OrdersWrapper(
               data.Order.Id,
               data.Order.RC_Order_No__c,               
               data.Order.EffectiveDate,               
               null,
               data.TotalPrice ,
               null,
               null,
               null,
               null,
               null,
               null,
               data.Quantity,
               null,
               data.UnitPrice

            );                    
            orderList.add(preparedDetail);
        system.debug('Product Query2:' + orderList);

        }
        return orderList;
    }
    @AuraEnabled
    public static Map<String, Object> GetRequestParameters(String site, String returnUrl, String orderNo, String amount,string listType)
    {
        try
        {
            system.debug(site);
            
            string saleOrganisationCode = '';
            string distributionCode = '';
            if(listType =='2')
            {
                List<Order> orders = new List<Order>();                 
                string searchedQuery = 'select  Sales_Organization__c, Distribution_Channel__c from Order  where RC_Order_No__c =\''+ orderNo+ '\' limit 1';                       
                System.debug('order info: ' + searchedQuery);
                List<Order> foundedList = Database.query(searchedQuery);                           
                for (Order data : foundedList) {                 
                    saleOrganisationCode = data.Sales_Organization__c;
                    distributionCode = data.Distribution_Channel__c;
               }  
            }
            else
            {
                List<RC_Delivery_and_Billing__c> orders = new List<RC_Delivery_and_Billing__c>();                 
                string searchedQuery = 'SELECT Id, RC_Order_Number__r.Sales_Organization__c, RC_Order_Number__r.Distribution_Channel__c  FROM RC_Delivery_and_Billing__c where RC_Invoice_No__c   =\''+ orderNo+ '\' limit 1';                       
                System.debug('order info: ' + searchedQuery);
                List<RC_Delivery_and_Billing__c> foundedList = Database.query(searchedQuery);                           
                for (RC_Delivery_and_Billing__c data : foundedList) {                 
                    saleOrganisationCode = data.RC_Order_Number__r.Sales_Organization__c;
                    distributionCode = data.RC_Order_Number__r.Distribution_Channel__c;
               }  
            }
                 
               
            AssecoInformation__c relatedAssecoInfo =  [SELECT SecretKey__c, AssecoApiMerchFormat__c, AzamiParcaSayisi__c, DirectLoginJWT__c, FaturadaOdemeOlabilir__c, FaturadanOdemeUrunKodu__c, Kanal__c, LinkSuresi__c, MaksTaksitSayisi__c, Profil__c, SessionSuresi__c, SiparistenOdemeOlabilir__c, SureId__c, TamEslesme__c,Distribution_Channel__c,Sales_Organisation__c FROM AssecoInformation__c WHERE Sales_Organisation__c =: saleOrganisationCode AND Distribution_Channel__c =: distributionCode];
            
            Account relatedAccount = RC_UtilitiesClass.getUserRelatedAccount();               
            system.debug('order Controller account info' + relatedAccount);           
            system.debug('relatedAssecoInfo:' + relatedAssecoInfo);
            
            String channel = String.format(relatedAssecoInfo.AssecoApiMerchFormat__c, new String[]{relatedAssecoInfo.Kanal__c});
            String bayikodu =  relatedAccount.RC_SAP_ID__c; //RC_Customer_No__c
            system.debug(bayikodu);
            String random = RC_Asseco_Integrator.GenerateRandomKey(64);
            String secretKey = relatedAssecoInfo.SecretKey__c;
            
            Map<String, Object> requestData = new Map<String, Object>();
            requestData.put('channel', channel);
            requestData.put('bayikodu', bayikodu);
            // if(listType =='3')
            // {
            //     requestData.put('faturano', orderNo);

            // }
            // else
            // {
                requestData.put('siparisno', orderNo);

            // }
            requestData.put('maxsplitcount', '0');
            requestData.put('personalmaxinst', '6');
            requestData.put('businessmaxinst', '6');
            requestData.put('currency', 'TRY');
            requestData.put('customer', bayikodu);
            requestData.put('random', random);
            requestData.put('secretKey', secretKey);
            requestData.put('hash', RC_Asseco_Integrator.GenerateHashCode(channel, bayikodu, random, secretKey));
            requestData.put('expirationtime', relatedAssecoInfo.SessionSuresi__c);
            requestData.put('returnUrl', returnUrl);
            requestData.put('linkredirecturl', returnUrl);
            requestData.put('ispaybylink', 'No');
            requestData.put('amount', String.valueOf(amount).replace('.', ','));
            requestData.put('isdirectpayment', '');
            requestData.put('surid', relatedAssecoInfo.SureId__c);
            requestData.put('commercecodes', '1');
            requestData.put('customername', '');
            requestData.put('customeremail', '');
            requestData.put('customerphone', '');
            system.debug('ordercontroller requestdata '+ Json.serialize(requestData));
            return requestData;
        }
        catch (Exception e){throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getOrderStatuses(){  
       
        try {      
                 List<PickListValues> lstOrderStasuses = new List<PickListValues>();              
                 Schema.DescribeFieldResult fieldResult = Order.Status.getDescribe();
                 List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
                    for (Schema.PicklistEntry data : values) {            
                        PickListValues prepared = new PickListValues(
                             data.getValue(),
                             data.getLabel()
                         );                      
                         lstOrderStasuses.add(prepared);
                     }
                    
            system.debug(lstOrderStasuses);
            return lstOrderStasuses;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
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

                   PickListValues prepared = new PickListValues( data.RC_Value__c,data.name);                
                    lstCategory3.add(prepared);
                }                    
             return lstCategory3;
            }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
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
    public static List<CargoStatuWrapper> CargoStatuDetails(string deliveryNo){        
        List<CargoStatuWrapper> cargStatuses = new List<CargoStatuWrapper>();
        String searchedQuery = 'select Id from RC_Delivery_and_Billing__c where Name =\'' + deliveryNo  + '\'';        
        List<RC_Delivery_and_Billing__c> listObje = Database.query(searchedQuery);
        id deliveryId;

        for (RC_Delivery_and_Billing__c datanew : listObje) 
        {
             deliveryId = datanew.id;
        }

         searchedQuery = 'select CreatedDate, Field,  NewValue from RC_Delivery_and_Billing__History where ParentId =\'' + deliveryId  + '\' order by CreatedDate';

        List<RC_Delivery_and_Billing__History> listObj = Database.query(searchedQuery);
        Boolean flagCreated=false;
        Boolean flagPreaparing= false;
        boolean flagGivenCargo= false;
        boolean flagDelivered = false;

        for (RC_Delivery_and_Billing__History data : listObj) 
        {
            string crDate= formatDateForScreen(data.CreatedDate);
            if(data.Field=='created')
            {
                     CargoStatuWrapper ent = new CargoStatuWrapper( 'StepProgress-item is-done','Sipariş Alındı',crDate); 
                 
                 cargStatuses.add(ent);
                 flagCreated=true;            
             }
             else if(data.NewValue=='Siparişiniz Hazırlanıyor')
             {
                    CargoStatuWrapper ent = new CargoStatuWrapper('StepProgress-item is-done','Sipariş Hazırlanıyor',crDate); 
                 cargStatuses.add(ent);
                 flagPreaparing=true;  
             }
             else if(data.NewValue !='Siparişiniz Teslim Edildi')
             {
                    CargoStatuWrapper ent = new CargoStatuWrapper('StepProgress-item is-done','Sipariş Kargoya Verildi',crDate);

                 cargStatuses.add(ent);
                 flagGivenCargo=true;   
             }       
             else if(data.NewValue =='Siparişiniz Teslim Edildi')
             {
                    CargoStatuWrapper ent = new CargoStatuWrapper('StepProgress-item is-done','Sipariş Tamamlandı',crDate);

                 cargStatuses.add(ent);
                 flagDelivered=true;   
             }               
        }
        if(flagCreated == false)
        {
            CargoStatuWrapper ent = new CargoStatuWrapper(                
                'StepProgress-item',
                'Sipariş Alındı',
                ''                 
            );             
            cargStatuses.add(ent);
        }
        if(flagPreaparing == false)
        {
            CargoStatuWrapper ent = new CargoStatuWrapper(                
                'StepProgress-item',
                'Sipariş Hazırlanıyor',
                ''                 
            );             
            cargStatuses.add(ent);
        }
        if(flagGivenCargo == false)
        {
            CargoStatuWrapper ent = new CargoStatuWrapper(                
                'StepProgress-item',
                'Sipariş Kargoya Verildi',
                ''                 
            );             
            cargStatuses.add(ent);
        }
        if(flagDelivered == false)
        {
            CargoStatuWrapper ent = new CargoStatuWrapper(                
                'StepProgress-item',
                'Sipariş Tamamlandı',
                ''                 
            );             
            cargStatuses.add(ent);
        }
        return cargStatuses;
    }

    public class CargoStatuWrapper{
        @AuraEnabled
        public string new_class {get; set;}        
        
        @AuraEnabled
        public String Statu {get; set;}
        
        @AuraEnabled
        public string createDate {get; set;}       
        
        public CargoStatuWrapper( String new_class, String Statu, string createDate)
        {        
            this.new_class = new_class;
            this.Statu = Statu;
            this.createDate = createDate;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getCities(){  
       
        try {      
            List<PickListValues> lst = new List<PickListValues>();     
            string searchedQuery = 'SELECT RC_Code__C, Name FROM RC_City_Region__c where RC_Type__c =\'city\' and RC_Code__C != \'\' and RC_Code__C != \'999\' order by Name ';            
            system.debug('city query:' + searchedQuery);
            List<RC_City_Region__c> foundedList = Database.query(searchedQuery);       
            system.debug('city list:' + foundedList);
            for (RC_City_Region__c data : foundedList) {                 

                 PickListValues prepared = new PickListValues(data.RC_Code__c,data.name);                
                 lst.add(prepared);
             }                   
            return lst;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getCounties(string cityCode){  
       
        try {      
            List<PickListValues> lst = new List<PickListValues>();     
            string searchedQuery = 'SELECT RC_Code__C, Name FROM RC_City_Region__c where RC_Type__c =\'region\' and RC_City__r.RC_Code__c = \''+cityCode+'\' order by Name ';            
            List<RC_City_Region__c> foundedList = Database.query(searchedQuery);  
                    for (RC_City_Region__c data : foundedList) {            
                        PickListValues prepared = new PickListValues(data.RC_Code__c,data.name);                      
                         lst.add(prepared);
                     }
            return lst;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getDistricts(string countyCode ){  
       
        try {      
            List<PickListValues> lst = new List<PickListValues>();     
            string searchedQuery = 'SELECT RC_Code__C, Name FROM RC_City_Region__c where RC_Type__c =\'district\' and RC_Region__r.RC_Code__c = \''+countyCode+'\' order by Name ';            
            List<RC_City_Region__c> foundedList = Database.query(searchedQuery);  
                    for (RC_City_Region__c data : foundedList) {            
                        PickListValues prepared = new PickListValues(data.RC_Code__c,data.name);                      
                         lst.add(prepared);
                     }
                    
            system.debug(lst);
            return lst;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled(cacheable = true)
    public static List<PickListValues> getServices(string cityCode,string countyCode,string districtCode, string productCode){  
         try {      
            List<PickListValues> lst = new List<PickListValues>();                  
             RC_CRMServiceBelirleIntegrator.requestModel req = new RC_CRMServiceBelirleIntegrator.requestModel();

             req.IV_ILCE_KODU=countyCode;
             req.IV_IL_KODU=cityCode;
             req.IV_SEMT_KODU=districtCode;
             req.IV_URUN_KODU=productCode;
             RC_CRMServiceBelirleIntegrator.responseModel resp = new RC_CRMServiceBelirleIntegrator.responseModel();
             resp = RC_CRMServiceBelirleIntegrator.getServices(req); 

             if(resp != null && resp.ET_SERVIS != null && resp.ET_SERVIS.item != null){            
                for (RC_CRMServiceBelirleJsonParser.Item data : resp.ET_SERVIS.item) {            
                    PickListValues prepared = new PickListValues(data.SERVIS_KODU,data.SERVIS_ADI);                      
                     lst.add(prepared);
                     }
            }
                
        system.debug(lst);
        return lst;
        }
        catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled(cacheable = true)
    public static string shipToAddress(string orderNo,string positionNo,integer quantity,
    string countyName, string districtName,string name, string surname, string deliveryAddress, string areaCode,
    string phone, string cityCode, string serviceCode ){  
         try {      
                          
             RC_SDSiparisBolmeIntegrator.requestModel req = new RC_SDSiparisBolmeIntegrator.requestModel();

             RC_SDSiparisBolmeIntegrator.Item_1 item1= new RC_SDSiparisBolmeIntegrator.Item_1();
             item1.SIP_NO =orderNo;
             item1.SIP_KALEM = positionNo;
             item1.MIKTAR = quantity;

             RC_SDSiparisBolmeIntegrator.IT_BELGE belge = new RC_SDSiparisBolmeIntegrator.IT_BELGE();
             belge.item = new List<RC_SDSiparisBolmeIntegrator.Item_1>();
             belge.item.add(item1);
             req.IT_BELGE = belge;
             system.debug('belge:'+ belge);
             string nameSurname = name + ' '+ surname;
             system.debug('nameSurname:'+ nameSurname);
             string name1 = '';
             string name2 = '';
             

             if(nameSurname.length() >35)
             {
                name1= nameSurname.Substring(0,35);
                name2= (nameSurname.Substring(34, nameSurname.length() - 35)).Substring(0,35);
             }
             else
             {
                name1 = nameSurname;                
             }            
             
             RC_SDSiparisBolmeIntegrator.Item_2 item2= new RC_SDSiparisBolmeIntegrator.Item_2();
             item2.CITY = countyName;
             item2.COUNTRY = 'TR';
             item2.DISTRICT = districtName;
             item2.ITM_NUMBER = '000000';
             item2.LANGU = 'TR';
             item2.NAME = name1;
             item2.NAME_2 = name2;
             item2.STREET = deliveryAddress;             
             item2.TELEPHONE=areaCode+phone;
             item2.PARTN_ROLE ='Z1';
             item2.PARTN_NUMB='0000010000';
             item2.REGION = cityCode;
             item2.TITLE ='BAY VE BAYAN';

             RC_SDSiparisBolmeIntegrator.Item_2 item2_2= new RC_SDSiparisBolmeIntegrator.Item_2();
             system.debug('ITem2:'+item2);
             item2_2.ITM_NUMBER = '000000';             
             item2_2.PARTN_ROLE ='WE';
             item2_2.PARTN_NUMB=serviceCode;

             RC_SDSiparisBolmeIntegrator.SALES_PARTNERS sp = new RC_SDSiparisBolmeIntegrator.SALES_PARTNERS();
             sp.item = new List<RC_SDSiparisBolmeIntegrator.Item_2>();
             sp.item.add(item2);
             sp.item.add(item2_2);
             system.debug('sp:'+ sp);
             req.SALES_PARTNERS = sp;
             system.debug('req:'+ req);
             RC_SDSiparisBolmeIntegrator.responseModel resp = new RC_SDSiparisBolmeIntegrator.responseModel();
             resp = RC_SDSiparisBolmeIntegrator.ShipToAddress(req); 
             system.debug('resp:'+ resp);
             string message='';
             if(resp != null && resp.ET_MESSAGE != null && resp.ET_MESSAGE.item != null){  
                for(RC_SDSiparisBolmeJsonParser.Item p : resp.ET_MESSAGE.item)
                {       
                    if(p.TYPE =='E'){message += p.MESSAGE+' - ';}                  
                } 
            }
                
        return message;
        }
        catch (Exception e) {throw new AuraHandledException(e.getStackTraceString());}
    }

    @AuraEnabled
    public static String getAssecoPaymentLink(){
        String assecoLink='';
        try
        {             
            NamedCredential oAssecoPayment = [SELECT DeveloperName, Endpoint FROM NamedCredential where DeveloperName ='assecoPayment' limit 1];
            assecoLink = oAssecoPayment.Endpoint;
            system.debug('assecoLink : ' + assecoLink);
        }
        catch (Exception e){throw new AuraHandledException(e.getMessage());}
        
        return assecoLink;
    }
}