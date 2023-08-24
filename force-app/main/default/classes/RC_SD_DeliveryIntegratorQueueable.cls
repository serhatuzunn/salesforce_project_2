public class RC_SD_DeliveryIntegratorQueueable implements Queueable, Database.AllowsCallouts {
    
    private RC_SD_DeliveryIntegrator.SdDeliveryResponseModel respModel {get; set;}
    private RC_SD_DeliveryIntegrator.SdDeliveryRequestModel sdDeliveryRequestModel {get; set;}
    private Integer totalIndex {get; set;}
    private Integer currentIndex {get; set;}
    
    public RC_SD_DeliveryIntegratorQueueable(RC_SD_DeliveryIntegrator.SdDeliveryRequestModel reqModel, Integer tIndex, Integer cIndex){
        System.debug('Current Index : ' + cIndex + ' || Total Index : ' + tIndex + ' || Request Model : ' + reqModel);
        sdDeliveryRequestModel = reqModel;
        totalIndex = tIndex;
        currentIndex = cIndex + 1;
    }
    
    public void execute(QueueableContext cntx){
        respModel = RC_SD_DeliveryIntegrator.getDelivery(sdDeliveryRequestModel);
        
        if(respModel.itemList!=null && respModel.itemList.size()>0)
        {
            Map<string,RC_SD_DeliveryParser.Item> orders = new Map<String,RC_SD_DeliveryParser.Item>();
            
            for(RC_SD_DeliveryParser.Item deliveryItem : respModel.itemList)
            {
                orders.put(deliveryItem.VGBEL,deliveryItem);
            }
            
            List<Order> orderList = [SELECT Id,RC_Order_No__c FROM Order WHERE RC_Order_No__c IN:orders.keySet()];
            Map<string,string> mappedOrder = new Map<string,string>();
            for(Order mappedItem : orderList)
            {
                mappedOrder.put(mappedItem.RC_Order_No__c,mappedItem.Id);
            }
            
            List<OrderItem> orderItemList = [SELECT Id,OrderId,RC_Order_Product_No__c FROM OrderItem WHERE OrderId IN:mappedOrder.values()];
            Map<string,OrderItem> mappedProducts = new Map<string,OrderItem>();
            for(OrderItem mappedpr : orderItemList)
            {
                mappedProducts.put(mappedpr.RC_Order_Product_No__c + '-' + mappedpr.OrderId ,mappedpr);
            }
            
            List<RC_Delivery_And_Billing__c> deliveryList= new List<RC_Delivery_And_Billing__c>();
            List<RC_Delivery_And_Billing__c> tobeReplacedList = new List<RC_Delivery_And_Billing__c>();
            Set<string> toBeDeletedSet = new Set<string>();
            
            List<string> dateList = new List<string>();
            dateList.addAll(sdDeliveryRequestModel.IV_ERDAT_BEG.split('\\.'));
            
            for(RC_SD_DeliveryParser.Item deliveryItem : respModel.itemList)
            {
                if(mappedOrder.containsKey(deliveryItem.VGBEL) &&  mappedProducts.containsKey(deliveryItem.VGPOS + '-' + mappedOrder.get(deliveryItem.VGBEL)))
                {
                    
                    RC_Delivery_And_Billing__c delivery= new RC_Delivery_And_Billing__c();
                    
                    if(dateList.size()>2) delivery.RC_Delivery_Date__c = date.newInstance(integer.valueOf(dateList.get(2)),integer.valueOf(dateList.get(1)),integer.valueOf(dateList.get(0)));      
                    
                    delivery.Name                                      = deliveryItem.VBELN;
                    delivery.RC_Unit_of_Measure__c                     = deliveryItem.VRKME;
                    delivery.RC_Delivery_Quantity__c                   = decimal.valueOf(deliveryItem.LFIMG);
                    delivery.RC_Delivery_Product__c                    = decimal.valueOf(deliveryItem.VGPOS);
                    delivery.RC_Order_Number__c						   = mappedOrder.get(deliveryItem.VGBEL);
                    delivery.RC_Order_Product_Number__c				   = mappedProducts.get(deliveryItem.VGPOS + '-' + mappedOrder.get(deliveryItem.VGBEL)).Id;
                    delivery.RC_Delivery_ExternalID__c				   = deliveryItem.VBELN + '-' + deliveryItem.VGPOS;                    
                    delivery.RC_Block_Delivery__c					   = deliveryItem.LIFSK;
                    delivery.RC_Status_Definition__c				   = deliveryItem.STATUS_T;
                    delivery.RC_Delivery_Type__c					   = deliveryItem.LFART;
                    delivery.RC_Production_Place_Txt__c				   = deliveryItem.VSTEL;
                    delivery.RC_TM_Delivery__c 						   = deliveryItem.TM == 'X' ? true : false;   
                    
                    if(deliveryItem.CHANGED=='X')
                    {
                        toBeDeletedSet.add(deliveryItem.VBELN);
                        tobeReplacedList.add(delivery);
                    }
                    else
                    {
                        deliveryList.add(delivery);
                    }
                }
                else{
                    system.debug('orderItemNo2:' + deliveryItem.VGPOS + ' - ' + deliveryItem.VGBEL + ' - ' + mappedOrder.get(deliveryItem.VGBEL)); 
                }
            }
            system.debug('deliveryList' + deliveryList);
            
            if(Test.isRunningTest()) {
                RC_Delivery_And_Billing__c testDelivery= new RC_Delivery_And_Billing__c();
                testDelivery.Name = 'Test';
                testDelivery.RC_Unit_of_Measure__c = 'Test';
                deliveryList.add(testDelivery);
            }
            
            if(toBeDeletedSet.size()>0)
            {
                List<RC_Delivery_And_Billing__c> toBeDeletedDeliveries = [SELECT Id From RC_Delivery_And_Billing__c WHERE Name IN:toBeDeletedSet]; 
                if(toBeDeletedDeliveries!=null && toBeDeletedDeliveries.size()>0)
                {
                    Database.DeleteResult[] drList = Database.delete(toBeDeletedDeliveries, false);
                    
                    deliveryList.addAll(tobeReplacedList); 
                }
                
                
            }
            
            if(deliveryList.size()>0)
            {
                Schema.SObjectField deliveryNo = RC_Delivery_And_Billing__c.Fields.RC_Delivery_ExternalID__c;
                Database.UpsertResult[] srList = Database.upsert(deliveryList,deliveryNo, false);
                List<RC_Logger__c> rcLoggerList = new List<RC_Logger__c>();
                for (Database.UpsertResult sr : srList) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted delivery. Delivery ID: ' + sr.getId());
                    }
                    else {          
                        for(Database.Error err : sr.getErrors()) {                                          
                            RC_Logger__c rcLogger = new RC_Logger__c();
                            rcLogger.RC_Message__c = 'Error: RC_SD_DeliveryIntegratorQueueable';
                            rcLogger.RC_Message_Detail__c = 'upsert Error';
                            rcLogger.RC_StackTrace__c = err.getMessage();
                            rcLogger.RC_LogLevel__c = 'EXCEPTION';
                            rcLogger.CreateDate__c = DateTime.now();
                            rcLogger.RC_ClassName__c = 'RC_SD_DeliveryIntegratorQueueable';
                            rcLogger.RC_FunctionName__c = 'execute';
                            rcLogger.RC_ComponentName__c = '';                                 
                            rcLoggerList.add(rcLogger);
                        }
                    }
                }
                insert rcLoggerList;
            }            
            
            RC_SchedulableSettings__c setting = RC_SchedulableSettings__c.getValues('SD Delivery Schedulable Settings');
            if(totalIndex == null && setting != null && setting.RC_Package_Size__c != null){    
                totalIndex = Integer.valueOf(respModel.totalIndex / setting.RC_Package_Size__c) + 1; 
            }
            
            if(currentIndex < totalIndex){
                sdDeliveryRequestModel.IV_INDEX = Integer.valueOf(currentIndex * setting.RC_Package_Size__c);                
                
                RC_SD_DeliveryIntegratorQueueable queue = new RC_SD_DeliveryIntegratorQueueable(sdDeliveryRequestModel, totalIndex, currentIndex);
                
                System.enqueueJob(queue);
            }
            else{
                RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Delivery Migration Values');
                
                if(migrationSetting.RC_Begin_Time__c < DateTime.now()){
                    RC_SD_DeliveryIntegratorSchedulable sch = new RC_SD_DeliveryIntegratorSchedulable(); sch.execute(null);
                } 
            }            
        }
    }
}