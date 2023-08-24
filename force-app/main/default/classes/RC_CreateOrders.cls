public class RC_CreateOrders { 
    // an object to store required fields for linking the orders to Accounts/Users
    public class mapObj {
        public String type {get;set;}            
        public String id {get;set;}
        public String org {get;set;}
    }
    public static void createOrders(RC_OrdersIntegratorParser ordersResponse) {
        
        try {           
            List<Order> orderList = new List<Order>();
            List<OrderItem> orderItemList = new List<OrderItem>();    
            Set<String> productCodeList = new Set<String>();           
            
            List<String> KUNNRList = new List<String>();                                                     
            List<Account> accountList = new List<Account>();
            Map<String, String> orderIdMap = new Map<String, String>();
            Map<String, PricebookEntry> pbeMap = new Map<String, PricebookEntry>();
            
            try
            {
                for (RC_OrdersIntegratorParser.ITEM_Z item : ordersResponse.ET_RETURN.item) {
                    
                    if(item.MATNR.isNumeric())
                        item.MATNR = String.valueOf(Integer.valueOf(item.MATNR));
                    productCodeList.add(item.MATNR);
                    
                    for (RC_OrdersIntegratorParser.Item partner : item.PARTNERS.item) {     
                        if (KUNNRList.contains(partner.KUNNR) != true) {
                            if(partner.KUNNR.isNumeric()){
                                partner.KUNNR = String.valueOf(Integer.valueOf(partner.KUNNR));
                            }
                            KUNNRList.add(partner.KUNNR);
                            
                        }
                    }
                    
                }
            }
            catch(exception ex)
            {
                system.debug('ex:' + ex);
                RC_Logger.LOG_EXCEPTION('Error : RC_CreateOrders', 'Error', ex.getMessage(), 'RC_CreateOrders', 'createOrders', '');
            }
            
            if(!test.isRunningTest())
            {
                system.debug('productCodeList:' + productCodeList);
                Pricebook2 stdPriceBook    = [select id, name from Pricebook2 where isStandard = true limit 1];
                for (PriceBookEntry pbe : [SELECT id, Product2Id, Pricebook2Id, ProductCode, Product2.id  FROM PriceBookEntry WHERE Pricebook2Id=:stdPriceBook.Id and CurrencyISOCode='TRY' and IsActive=true and ProductCode IN : productCodeList]) {               
                    
                    pbeMap.put(pbe.ProductCode, pbe);
                    
                    
                }   
            }
            else{
                system.debug('productCodeList:' + productCodeList);
                for (PriceBookEntry pbe : [SELECT id, Product2Id, Pricebook2Id, ProductCode, Product2.id  FROM PriceBookEntry WHERE  ProductCode IN : productCodeList]) {               
                    
                    pbeMap.put(pbe.ProductCode, pbe);
                    
                    
                }   
            }
            
            
            
            // create a map from KUNNR fields for associating the orders to Accounts
            Map<String, mapObj> KUNNRMap = createKUNNRMap(KUNNRList, accountList); 
            
            // create the list of newOrders
            Map<string,RC_OrdersIntegratorParser.ITEM_Z> orderMapList = new Map<string,RC_OrdersIntegratorParser.ITEM_Z>();
            for (RC_OrdersIntegratorParser.ITEM_Z item : ordersResponse.ET_RETURN.item) {         
                
                if(!orderMapList.containsKey(item.VBELN))
                {
                    orderMapList.put(item.VBELN,item);
                    
                    if(item.MATNR.isNumeric())
                        item.MATNR = String.valueOf(Integer.valueOf(item.MATNR));
                    
                    if(pbeMap.containsKey(item.MATNR) && orderMapList.containsKey(item.VBELN))
                        orderList.add(createOrder(item, pbeMap, KUNNRMap));
                    else
                        system.debug('ProductNotFound:' + item.MATNR);
                }
                
            }  
            
            
            
            Set<ID> setIds = new Set<Id>();
            
            Schema.SObjectField orderNo = Order.Fields.RC_Order_No__c;
            
            // insert the order list to database      
            
            Database.UpsertResult[] srListOrderUpdate = Database.upsert(orderList, orderNo, false);
            
            // check and log successful and failed dml operations
            List<RC_Logger__c> rcLoggerList = new List<RC_Logger__c>();
            for (Database.UpsertResult sr : srListOrderUpdate) {
                if (sr.isSuccess()) {
                    system.debug('success: ' + sr.getId());
                    setIds.add(sr.getId());
                }
                else{
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('error: ' + err.getFields());
                        
                        RC_Logger__c rcLogger = new RC_Logger__c();
                        rcLogger.RC_Message__c = 'Error: RC_CreateOrders';
                        rcLogger.RC_Message_Detail__c = 'upsert error';
                        rcLogger.RC_StackTrace__c = err.getMessage();
                        rcLogger.RC_LogLevel__c = 'EXCEPTION';
                        rcLogger.CreateDate__c = DateTime.now();
                        rcLogger.RC_ClassName__c = 'RC_CreateOrders';
                        rcLogger.RC_FunctionName__c = 'createOrders';
                        rcLogger.RC_ComponentName__c = '';      
                        
                        rcLoggerList.add(rcLogger);
                    }
                }
            }      
            insert rcLoggerList;
            
            
            for( Order o : [SELECT id, RC_Order_No__c FROM Order where Id IN:setIds]) {
                
                orderIdMap.put(o.RC_Order_No__c, o.id);
            }
            
            
            //Fonksiyona güncellenen siparişler de eklendiği için, kalemler yaratılmadan önce ilgili siparişlere ait içerideki kalemler siliniyor.
            
            List<OrderItem> orderItemLst = [Select Id From OrderItem where OrderId IN: setIds];
            Database.DeleteResult[] drList = Database.delete(orderItemLst, false);

            
            
            // create the list of newOrderItems           
            for (RC_OrdersIntegratorParser.ITEM_Z item : ordersResponse.ET_RETURN.item) {
                
                
                if(item.MATNR.isNumeric())
                    item.MATNR = String.valueOf(Integer.valueOf(item.MATNR));
                
                if(orderIdMap.containsKey(item.VBELN) && pbeMap.containsKey(item.MATNR))
                {
                    
                    orderItemList.add(createOrderItem(item, pbeMap, orderIdMap));  
                }
                
                
            }    
            
            Schema.SObjectField orderItemNo = OrderItem.Fields.RC_ExternalId__c;
            
            // insert or update the orderItem list to database                         
            Database.UpsertResult[] srListOrderItemUpdate = Database.upsert(orderItemList, orderItemNo, false);               
            // check and log successful and failed dml operations
            List<RC_Logger__c> orderItemLoggerList = new List<RC_Logger__c>();
            for (Database.UpsertResult sr : srListOrderItemUpdate) {
                if (sr.isSuccess()) {
                    System.debug(' CreateOrders - Successfully inserted orderitem . Order id: ' + sr.getId());
                }
                else{
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('error: ' + err.getFields());
                        
                        RC_Logger__c rcLogger = new RC_Logger__c();
                        rcLogger.RC_Message__c = 'Error: RC_CreateOrders';
                        rcLogger.RC_Message_Detail__c = 'upsert error';
                        rcLogger.RC_StackTrace__c = err.getMessage();
                        rcLogger.RC_LogLevel__c = 'EXCEPTION';
                        rcLogger.CreateDate__c = DateTime.now();
                        rcLogger.RC_ClassName__c = 'RC_CreateOrders';
                        rcLogger.RC_FunctionName__c = 'createOrders';
                        rcLogger.RC_ComponentName__c = '';      
                        
                        orderItemLoggerList.add(rcLogger);
                    }
                }
            } 
            insert orderItemLoggerList;
            
        }
        catch(Exception ex){        
            RC_Logger.LOG_EXCEPTION('CreateOrders  Error', 'catch error', ex.getMessage(), 'CreateOrders', 'createOrders', '');
        }      
    }
    
    // create new orders
    public static Order createOrder(RC_OrdersIntegratorParser.ITEM_Z item, Map<String, PricebookEntry> pbeMap, Map<String, mapObj> KUNNRMap) {
        
        
        List<String> dateItemList = item.ERDAT.split('-');
        
        Order newOrder = new Order(RC_Order_No__c                  = item.VBELN,
                                   Status                          = 'YS',
                                   Type                            = item.AUART,
                                   EffectiveDate                   = Date.valueOf(dateItemList[2] + '-'+ dateItemList[1] + '-' + dateItemList[0]),
                                   RC_Order_Justification__c       = item.AUGRU,
                                   RC_Payment_Condition__c         = item.ZTERM,
                                   RC_Payment_Method__c            = item.ZLSCH, 
                                   RC_Block_Delivery__c            = item.LIFSK,
                                   RC_Reason_for_Rejection__c      = item.ABGRU,
                                   RC_Block_Invoice__c             = item.FAKSK,
                                   RC_SAS_Number__c				   = item.SASNO,
                                   RC_SAS_Date__c				   = item.SASTARIHI,
                                   RC_Circular_Number__c           = item.SIRKULERNO,
                                   RC_Average_Value_Date__c 	   = item.ORTVALOR,
                                   RC_Additional_Value_Date__c	   = item.EKVALOR,
                                   RC_Delivery_Date__c 			   = item.SEVKTARIHI,
                                   Regional_Directorate__c         = item.VKBUR,
                                   Sales_Directorate__c            = item.VKGRP,
                                   Distribution_Channel__c         = item.VTWEG,
                                   Sales_Organization__c           = item.VKORG
                                  );
        
        if (pbeMap.get(item.MATNR) != null) newOrder.Pricebook2Id = (pbeMap.get(item.MATNR)).Pricebook2Id;
        
        // add partners/muhataps
        for (Integer i = 1; i < (item.PARTNERS.item).size() + 1; i++) {
            
            if(item.PARTNERS.item[i-1].PARVW=='WE')
            {
                RC_OrdersIntegratorParser.Item partnerItem =item.PARTNERS.item[i-1];
                string addressData = partnerItem.NAME1 + ' | ' + partnerItem.NAME2 + ' | ' + partnerItem.REGION + ' | ' + partnerItem.CITY1 + ' | ' + partnerItem.CITY2 + ' | ' + partnerItem.STREET + ' | ' + partnerItem.HOUSE_NUM1 + ' | ' + partnerItem.POST_CODE1;
                newOrder.RC_Address_Data__c = addressData;
            }
            
            if (KUNNRMap.get(item.PARTNERS.item[i-1].KUNNR) != null)
            {
                
                if((KUNNRMap.get(item.PARTNERS.item[i-1].KUNNR)).type == 'Account' )
                {
                    
                    if(item.PARTNERS.item[i-1].PARVW == 'AG') {
                        
                        newOrder.AccountId = (KUNNRMap.get(item.PARTNERS.item[i-1].KUNNR)).id;
                        newOrder.RC_SD_Organization__c = (KUNNRMap.get(item.PARTNERS.item[i-1].KUNNR)).org;
                    } 
                    newOrder.put('RC_Customer_Number_Account_' + i + '__c', (KUNNRMap.get(item.PARTNERS.item[i-1].KUNNR)).id);
                    
                    
                }                               
                else if ((KUNNRMap.get(item.PARTNERS.item[i-1].KUNNR)).type == 'User') {        
                    
                    newOrder.put('RC_Customer_Number_User_' + i + '__c', (KUNNRMap.get(item.PARTNERS.item[i-1].KUNNR)).id);
                    
                    
                }
                
            }
            
            newOrder.put('RC_Account_Code_' + i + '__c', item.PARTNERS.item[i-1].KUNNR);
            newOrder.put('RC_Partner_Name_' + i + '__c', item.PARTNERS.item[i-1].NAME1);
            newOrder.put('RC_Partner_Second_Name_' + i + '__c', item.PARTNERS.item[i-1].NAME2);
            newOrder.put('RC_Account_Role_' + i + '__c', item.PARTNERS.item[i-1].PARVW);
            
            
        }        
        return newOrder;        
    }
    
    // create order products associated to each order
    public static OrderItem createOrderItem (RC_OrdersIntegratorParser.ITEM_Z item, Map<String, PricebookEntry> pbeMap, Map<String, String> orderIdMap ) {
        OrderItem newOrderItem = new OrderItem (RC_Order_Product_No__c		  = item.POSNR,
                                                Quantity              		  = item.KWMENG=='0' ?  1.00 : Decimal.valueOf(item.KWMENG),
                                                RC_Unit_of_Measure__c 		  = item.VRKME,
                                                UnitPrice             		  = Decimal.valueOf(item.NET_VALUE) /  (item.KWMENG == '0' ? 1.00 : Decimal.valueOf(item.KWMENG)),
                                                RC_Line_Total__c      		  = Decimal.valueOf(item.NET_VALUE),
                                                RC_Discount__c       		  = Decimal.valueOf(item.KWERT),
                                                RC_VAT__c             		  = Decimal.valueOf(item.MWSBP),
                                                RC_Reason_for_Rejection__c    = item.ABGRU,
                                                RC_ExternalId__c			  = item.VBELN + '-' + item.POSNR,
                                                RC_SAP_Status_Definition__c   = item.STATUS_T,
                                                OrderId                       = orderIdMap.get(item.VBELN));
        
        
        if (pbeMap.get(item.MATNR) != null) {
            
            newOrderItem.Product2Id = (pbeMap.get(item.MATNR)).Product2.id;
            
            
            newOrderItem.PricebookEntryId = (pbeMap.get(item.MATNR)).id;
            
            
        } 
        
        
        return newOrderItem;       
    }
    
    // Crate a map from the unique KUNNR fields that keeps the object type, id and org(if necessary) it will be associated to
    public static Map<String, mapObj> createKUNNRMap (List<String> KUNNRList, List<Account> accountList) {
        Map<String, mapObj> KUNNRMap = new Map<String, mapObj>();
        
        for(Account acc : [SELECT Id, RC_SAP_ID__c, RC_SD_Organization__c FROM Account WHERE RC_SAP_ID__c IN : KUNNRList]) {
            
            mapObj accMap = new mapObj();
            accMap.type = 'Account';
            accMap.id = acc.id;
            accMap.org = acc.RC_SD_Organization__c;
            KUNNRMap.put(acc.RC_SAP_ID__c, accMap);    
            
        }
        
        for(User usr : [SELECT Id, RC_Registiration_No__c FROM User WHERE RC_Registiration_No__c IN : KUNNRList]) {
            
            mapObj usrMap = new mapObj();
            usrMap.type = 'User';
            usrMap.id = usr.id;
            KUNNRMap.put(usr.RC_Registiration_No__c, usrMap);
            
        }
        
        return KUNNRMap;       
    }   
}