public class RC_BillingIntegratorQueueable implements Queueable, Database.AllowsCallouts {
    
    private RC_BillingIntegratorParser.ET_RETURN responseBillingList {get; set;}
    private RC_BillingIntegrator.RequestWrapper req {get; set;}
    private Integer totalIndex {get; set;}
    private Integer currentIndex {get; set;}
    
    public RC_BillingIntegratorQueueable(RC_BillingIntegrator.RequestWrapper requestData, Integer tIndex, Integer cIndex){
        System.debug('Current Index : ' + cIndex + ' || Total Index : ' + tIndex + ' || Request Model : ' + requestData);
        req = requestData;
        totalIndex = tIndex;
        currentIndex = cIndex + 1;
    }
    
    public void execute(QueueableContext cntx){
        RC_BillingIntegrator.ResponseWrapper respWrapper = RC_BillingIntegrator.getBilling(req);
        RC_BillingIntegratorParser.ET_RETURN responseBillingList = respWrapper.response;
        
        if(responseBillingList!=null && responseBillingList.item.size() > 0)
        {                
            Set<string> orderSet = new Set<string>();
            Set<string> productSet = new Set<string>();
            
            for(RC_BillingIntegratorParser.Item item : responseBillingList.item)
            {
                orderSet.add(item.VGBEL);
                if(item.MATNR.length() > 11) productSet.add(RC_UtilitiesClass.getFormattedProductCode(item.MATNR));
            }
            
            Map<string,string> mappedOrder = new Map<string,string>();
            
            for(Order order : [SELECT Id,RC_Order_No__c FROM Order WHERE RC_Order_No__c IN: orderSet])
            {
                mappedOrder.put(order.RC_Order_No__c,order.Id);
            }
            
            Map<string,RC_Delivery_And_Billing__c> mappedDelivery = new Map<string,RC_Delivery_And_Billing__c>();
            
            for(RC_Delivery_And_Billing__c delivery : [SELECT Id,Name,RC_Delivery_ExternalID__c FROM RC_Delivery_And_Billing__c WHERE RC_Delivery_ExternalID__c!=null AND Name IN: orderSet])
            {	
                if(!mappedDelivery.containsKey(delivery.Name))
                    mappedDelivery.put(delivery.Name,delivery);
            }
            system.debug('mappedDelivery:' + mappedDelivery);
            
            List<RC_Delivery_And_Billing__c> billingList= new List<RC_Delivery_And_Billing__c>();
            
            Map<string,string> mappedOrderRec = new Map<string,string>();
            Map<string,string> mappedDeliveryRec = new Map<string,string>();
            
            List<string> dateList = new List<string>();
            dateList.addAll(req.IV_ERDAT_BEG.split('\\.'));
            
            for(RC_BillingIntegratorParser.Item item : responseBillingList.item)
            {
                if(mappedOrder.containsKey(item.VGBEL) && !mappedOrderRec.containsKey(item.VGBEL))
                {
                    RC_Delivery_And_Billing__c billing = new RC_Delivery_And_Billing__c();
                    
                    
                    if(dateList.size()>2)
                        billing.RC_Invoice_Date__c = date.newInstance(integer.valueOf(dateList.get(2)),integer.valueOf(dateList.get(1)),integer.valueOf(dateList.get(0)));
                    
                    billing.RC_Invoice_No__c	       = item.VBELN;
                    billing.RC_Delivery_ExternalID__c  = item.VGBEL + '-' + item.POSNR;
                    billing.RC_Order_Number__c	       = mappedOrder.get(item.VGBEL);
                    billing.RC_UUID__c				   = item.ENC_INV_NO;
                    billingList.add(billing);
                    mappedOrderRec.put(item.VGBEL,item.VBELN);
                }
                
                if(mappedDelivery.containsKey(item.VGBEL) && !mappedDeliveryRec.containsKey(item.VBELN))
                {
                    RC_Delivery_And_Billing__c deliveryRec = mappedDelivery.get(item.VGBEL);
                    
                    if(dateList.size()>2)
                        deliveryRec.RC_Invoice_Date__c = date.newInstance(integer.valueOf(dateList.get(2)),integer.valueOf(dateList.get(1)),integer.valueOf(dateList.get(0)));
                    
                    deliveryRec.RC_Invoice_No__c	       = item.VBELN;
                    deliveryRec.RC_UUID__c 				   = item.ENC_INV_NO;
                    billingList.add(deliveryRec);
                    
                    mappedDeliveryRec.put(item.VBELN,item.VGBEL);
                }
                
            }
            
            Set<RC_Delivery_And_Billing__c> removeDuplication = new Set<RC_Delivery_And_Billing__c>();
            List<RC_Delivery_And_Billing__c> result = new List<RC_Delivery_And_Billing__c>();
            removeDuplication.addAll(billingList);
            result.addAll(removeDuplication);
            
            Set<Id> billingIds = new Set<Id>();
            
            if(result.size()>0)
            {
                Schema.SObjectField billingNo = RC_Delivery_And_Billing__c.Fields.RC_Delivery_ExternalID__c;
                system.debug('billingList: ' + result);
                Database.UpsertResult[] srList = Database.upsert(result,billingNo, false);
                List<RC_Logger__c> deliveryLoggerList = new List<RC_Logger__c>();
                for (Database.UpsertResult sr : srList) {
                    if (sr.isSuccess()) {
                        billingIds.add(sr.getId());
                        System.debug('Successfully inserted billing. Billing ID: ' + sr.getId());
                    }
                    else {          
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('error: ' + err.getFields());
                            
                            RC_Logger__c rcLogger = new RC_Logger__c();
                            rcLogger.RC_Message__c = 'Error: RC_BillingIntegratorQueueable';
                            rcLogger.RC_Message_Detail__c = 'upsert Error';
                            rcLogger.RC_StackTrace__c = err.getMessage();
                            rcLogger.RC_LogLevel__c = 'EXCEPTION';
                            rcLogger.CreateDate__c = DateTime.now();
                            rcLogger.RC_ClassName__c = 'RC_BillingIntegratorQueueable';
                            rcLogger.RC_FunctionName__c = 'execute';
                            rcLogger.RC_ComponentName__c = '';      
                            
                            deliveryLoggerList.add(rcLogger);
                        }
                    }
                }
                insert deliveryLoggerList;
            }
            
            if(billingIds.size()>0)
            {
                List<RC_Billing_Item__c> billingItemList = new List<RC_Billing_Item__c>();
                Map<string,string> mappedBillings = new Map<string,string>();
                Map<string,string> mappedProducts = new Map<string,string>();
                
                for(RC_Delivery_And_Billing__c billing : [SELECT Id,RC_Invoice_No__c FROM RC_Delivery_And_Billing__c where Id IN:billingIds])
                {
                    mappedBillings.put(billing.RC_Invoice_No__c,billing.Id);
                }
                
                for(Product2 product : [SELECT Id,ProductCode FROM Product2 where ProductCode IN:productSet])
                {
                    mappedProducts.put(product.ProductCode, product.Id);
                }
                
                List<RC_Billing_Item__c> relatedBillingItems = [Select Id From RC_Billing_Item__c Where RC_Delivery_And_Billing__c IN: billingIds];
                if(relatedBillingItems.size()>0)
                {
                    delete relatedBillingItems;
                }
                
                for(RC_BillingIntegratorParser.Item item : responseBillingList.item)
                {
                    if(mappedBillings.containsKey(item.VBELN))
                    {
                        RC_Billing_Item__c billingItem = new RC_Billing_Item__c();
                        billingItem.Name						  = item.VBELN;
                        billingItem.RC_Delivery_and_Billing__c    = mappedBillings.get(item.VBELN);
                        billingItem.RC_Billing_Item_Product__c	  = mappedProducts.get(RC_UtilitiesClass.getFormattedProductCode(item.MATNR));
                        billingItem.RC_Billing_Document_Type__c   = item.FKART;
                        billingItem.RC_Reference_Item_No__c       = item.VGPOS;
                        billingItem.RC_Billing_Item_No__c         = item.POSNR;
                        billingItem.RC_Billing_Item_Quantity__c   = decimal.valueOf(item.FKIMG);
                        billingItem.RC_Distribution_Channel__c    = item.VTWEG;
                        billingItem.RC_Payment_Condition__c       = item.ZTERM;
                        billingItem.RC_Reference_Document_Type__c = item.VGTYP;
                        billingItem.RC_Unit_Of_Measure__c         = item.VRKME;
                        billingItem.RC_Tax_Total__c               = decimal.valueOf(item.MWSBP);
                        billingItem.RC_Net_Price__c				  = decimal.valueOf(item.NETWR);
                        billingItem.RC_Total__c					  = decimal.valueOf(item.NET_VALUE);
                        billingItem.RC_BillingItem_ExternalId__c  = item.VBELN + '-' + item.POSNR;
                        billingItemList.add(billingItem);
                    }
                }
                
                if(billingItemList.size()>0)
                {
                    Schema.SObjectField billingItemNo = RC_Billing_Item__c.Fields.RC_BillingItem_ExternalId__c;
                    Database.UpsertResult[] srList = Database.upsert(billingItemList, billingItemNo, false);
                    List<RC_Logger__c> rcLoggerList = new List<RC_Logger__c>();
                    for (Database.UpsertResult sr : srList) {
                        if (sr.isSuccess()) {
                            System.debug('Successfully inserted billing items. BillingItem ID: ' + sr.getId());
                        }
                        else {          
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('error: ' + err.getFields());
                                
                                RC_Logger__c rcLogger = new RC_Logger__c();
                                rcLogger.RC_Message__c = 'Error: RC_BillingIntegratorQueueable';
                                rcLogger.RC_Message_Detail__c = 'upsert Error';
                                rcLogger.RC_StackTrace__c = err.getMessage();
                                rcLogger.RC_LogLevel__c = 'EXCEPTION';
                                rcLogger.CreateDate__c = DateTime.now();
                                rcLogger.RC_ClassName__c = 'RC_BillingIntegratorQueueable';
                                rcLogger.RC_FunctionName__c = 'execute';
                                rcLogger.RC_ComponentName__c = '';      
                                
                                rcLoggerList.add(rcLogger);
                            }
                        }
                    }
                    insert rcLoggerList;
                }
            }
            
            RC_SchedulableSettings__c setting = RC_SchedulableSettings__c.getValues('Billing Schedulable Settings');
            if(totalIndex == null && setting != null && setting.RC_Package_Size__c != null){    
                totalIndex = Integer.valueOf(respWrapper.totalIndex / setting.RC_Package_Size__c) + 1; 
            }
            
            if(currentIndex < totalIndex){
                req.IV_INDEX = Integer.valueOf(currentIndex * setting.RC_Package_Size__c);                
                
                RC_BillingIntegratorQueueable queue = new RC_BillingIntegratorQueueable(req, totalIndex, currentIndex);
                
                System.enqueueJob(queue);
            }
            else{
                RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Billing Migration Values');
                
                if(migrationSetting != null){                    
                    if(migrationSetting.RC_Begin_Time__c < DateTime.now()){
                        RC_BillingIntegratorSchedulable sch = new RC_BillingIntegratorSchedulable(); sch.execute(null);
                    }                     
                }
            }
        }
        else{
            RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Billing Migration Values');
            
            if(migrationSetting.RC_Begin_Time__c < DateTime.now()){
                RC_BillingIntegratorSchedulable sch = new RC_BillingIntegratorSchedulable(); sch.execute(null);
            } 
        }
    }
}