public class RC_UpdateOrderStatus {
    
    @future(callout=true)
    public static void UpdateOrders()
    {
        try
        {
            UpdateOrdersByDeliveries();
            UpdateOrdersByRejection();
            
            RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Order Status Migration Values');
            
            if(migrationSetting!=null && migrationSetting.RC_Is_Runnable__c)
            {
                migrationSetting.RC_Begin_Time__c = migrationSetting.RC_Begin_Time__c.addDays(1);
                update migrationSetting;
                
            }
        }
        catch(Exception e)
        {
            system.debug('catch:' + e);
            RC_Logger.LOG_EXCEPTION('RC_UpdateOrderStatus  Error', e.getMessage(), e.getStackTraceString(), 'UpdateOrderStatus', 'finish', '');
        }
        
    }
    
    public static void UpdateOrdersByDeliveries()
    {
        List<RC_Delivery_And_Billing__c> deliveryList = new List<RC_Delivery_And_Billing__c>();
        
        Date runDate= Date.today().addDays(-7);
        
        RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Order Status Migration Values');
        
        if(migrationSetting != null && migrationSetting.RC_Is_Runnable__c)
        {
            runDate = date.valueOf(migrationSetting.RC_Begin_Time__c.addHours(3));
        }
        
        else
        {
            runDate= Date.today();   
        }  
        
        if(migrationSetting != null && migrationSetting.RC_Is_Runnable__c)
        {
            system.debug('rundate:' + runDate);
            deliveryList = [SELECT Id,Name,RC_Order_Number__c,RC_Delivery_Status__c  FROM RC_Delivery_And_Billing__c
                            Where RC_Delivery_Date__c!=null AND RC_Delivery_Date__c =:runDate LIMIT 10000];
        }
        else
        {
            DateTime dt = System.now().addhours(-2);
            
            deliveryList = [SELECT Id,Name,RC_Order_Number__c,RC_Delivery_Status__c  FROM RC_Delivery_And_Billing__c
                            Where RC_Delivery_Date__c!=null AND LastModifiedDate >=: dt];
        }
        
        Map<string,integer> mappedOrders= new Map<string,integer>();
        system.debug('deliveryList:' + deliveryList);
        for(RC_Delivery_And_Billing__c delItem : deliveryList)
        {
            if(!delItem.Name.StartsWith('a0'))
            {
                if(!mappedOrders.containsKey(delItem.RC_Order_Number__c))
                {
                    
                    mappedOrders.put(delItem.RC_Order_Number__c,GetStatusValue(delItem.RC_Delivery_Status__c));
                }
                else
                {
                    integer statusValue = mappedOrders.get(delItem.RC_Order_Number__c);
                    if(statusValue > GetStatusValue(delItem.RC_Delivery_Status__c))
                    {
                        mappedOrders.remove(delItem.RC_Order_Number__c);
                        mappedOrders.put(delItem.RC_Order_Number__c,GetStatusValue(delItem.RC_Delivery_Status__c));                    
                    }
                }
            }
            
        }
        system.debug('mappedOrders:' + mappedOrders);
        
        List<Order> ordersToBeUpdated = [Select Id,Name,RC_Order_No__c FROM Order WHERE Id IN:mappedOrders.keySet()];
        system.debug('ordersToBe:' + ordersToBeUpdated);
        for(Order orderItem : ordersToBeUpdated)
        {
            orderItem.Status = GetStatusDescription(mappedOrders.get(orderItem.Id));
        }
        
        Database.SaveResult[] orders = Database.update(ordersToBeUpdated, false);               
        for (Database.SaveResult sr : orders) {
            if (sr.isSuccess()) {
                System.debug(' UpdateOrderStatus - Successfully updated order: ' + sr.getId());
            }
            else
            {
                System.debug('error:' + sr.getErrors());
            }
        }
    }
    
    public static void UpdateOrdersByRejection()
    {
        List<Order> orderList = new List<Order>();
        
        Date runDate= Date.today();
        
        RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Order Status Migration Values');
        
        if(migrationSetting != null && migrationSetting.RC_Is_Runnable__c)
        {
            runDate = date.valueOf(migrationSetting.RC_Begin_Time__c.addHours(3));
            
            
            orderList = [SELECT Id,Name,Status,(Select Id,RC_SAP_Status_Definition__c From OrderItems) FROM ORDER WHERE EffectiveDate =: runDate
                         LIMIT 10000 ];
        }
        else
        {
            DateTime dt = System.now().addhours(-2);
            orderList = [SELECT Id,Name,Status,(Select Id,RC_SAP_Status_Definition__c From OrderItems) FROM ORDER WHERE LastModifiedDate >=: dt
                         LIMIT 10000 ];   
        }
        
        system.debug('orderList : ' + orderList);
        Map<Id,Order> ordersToBeUpdated = new Map<ID,Order>();
        
        for(Order item : orderList)
        {
            for(OrderItem orderItem : item.OrderItems)
            {
                if(orderItem.RC_SAP_Status_Definition__c=='Sipariş red ile kapatıldı.')
                {
                    system.debug('Red İle Kapatıldı.: ' + item.Id);
                    ordersToBeUpdated.put(item.Id,item);
                }
                else
                {
                    system.debug('??.' + item.Id);
                    ordersToBeUpdated.remove(item.Id);
                    break;
                }
            }
        }
        
        for(Order ordernew : ordersToBeUpdated.values())
        {
            ordernew.Status='Reddedildi';
        }
        Database.SaveResult[] updateList = Database.update(ordersToBeUpdated.values());
        for (Database.SaveResult sr : updateList) {
            if (sr.isSuccess()) {
                
                system.debug('success');
            }
            else{
                system.debug('sr:' + sr.getErrors());
            }
        }    
        
    }
    public static integer GetStatusValue(string status)
    {
        Switch on status {
            when 'Hazırlanıyor'  {
                return 1;
            }
            when 'Yola Çıkmak Üzere' {
                return 2;
            }
            when 'Yolda' {
                return 3;
            }
            when 'Transfer Merkezinde'{
                return 4;
            }
            when 'Dağıtımı Hazırlanıyor' {
                return 5;
            }
            when 'Kurye Dağıtımda' {
                return 6;
            }
            when 'Teslim Edildi' {
                return 7;
            }
            when 'Teslim Edilemedi' {
                return 8;
            }
            when else {
                return 0;
            }
        }
    }
    public static string GetStatusDescription(integer status)
    {
        Switch on status {
            when 1 {
                return 'Hazırlanıyor' ;
            }
            when 2 {
                return 'Yola Çıkmak Üzere';
            }
            when 3 {
                return 'Yolda';
            }
            when 4 {
                return 'Transfer Merkezinde';
            }
            when 5 {
                return 'Dağıtımı Hazırlanıyor';
            }
            when 6 {
                return 'Kurye Dağıtımda';
            }
            when 7 {
                return 'Teslim Edildi';
            }
            when 8 {
                return 'Teslim Edilemedi';
            }
            when else {
                return 'YS';
            }
        }
    }
}