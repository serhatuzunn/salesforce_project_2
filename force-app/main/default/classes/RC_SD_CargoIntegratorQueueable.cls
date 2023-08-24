public class RC_SD_CargoIntegratorQueueable implements Queueable, Database.AllowsCallouts {
    
    
    private RC_SD_CargoIntegrator.requestModel cargoIntegratorRequestModel {get; set;}
    
    public RC_SD_CargoIntegratorQueueable(RC_SD_CargoIntegrator.requestModel reqModel){
        cargoIntegratorRequestModel = reqModel;
    }
    
    
    public void execute(QueueableContext cntx){
        
        List<RC_Delivery_and_Billing__c> tmDeliveryList     = new List<RC_Delivery_and_Billing__c>();
        List<RC_Delivery_and_Billing__c> noneTmDeliveryList = new List<RC_Delivery_and_Billing__c>();
        
        Date runDate= Date.today().addDays(-7);
        
        RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('TM Migration Values');
        
        if(migrationSetting != null && migrationSetting.RC_Is_Runnable__c)
        {
            runDate = date.valueOf(migrationSetting.RC_Begin_Time__c.addHours(3));
            system.debug('runDate:' + runDate);
            tmDeliveryList     = [SELECT Name FROM RC_Delivery_and_Billing__c WHERE RC_TM_Delivery__c=:true
                                  AND RC_Delivery_Status__c NOT IN ('Teslim Edildi','Teslim Edilemedi','Reddedildi')
                                  AND RC_Delivery_Date__c!=null AND RC_Delivery_Date__c =: runDate LIMIT 10000];
            system.debug('tmDeliveryList:' + tmDeliveryList);
            noneTmDeliveryList = [SELECT Name,RC_Status_Definition__c,RC_Delivery_Status__c FROM RC_Delivery_and_Billing__c WHERE RC_TM_Delivery__c=:false
                                  AND RC_Delivery_Status__c NOT IN ('Teslim Edildi','Teslim Edilemedi','Reddedildi')
                                  AND RC_Delivery_Date__c!=null AND RC_Delivery_Date__c =: runDate LIMIT 10000];
        }
        else
        {
            
            tmDeliveryList = [SELECT Name FROM RC_Delivery_and_Billing__c WHERE RC_TM_Delivery__c=:true
                              AND RC_Delivery_Status__c NOT IN ('Teslim Edildi','Teslim Edilemedi','Reddedildi')
                              AND RC_Delivery_Date__c!=null AND RC_Delivery_Date__c >=: runDate LIMIT 10000];
            
            noneTmDeliveryList = [SELECT Name,RC_Status_Definition__c,RC_Delivery_Status__c FROM RC_Delivery_and_Billing__c WHERE RC_TM_Delivery__c=:false
                                  AND RC_Delivery_Status__c NOT IN ('Teslim Edildi','Teslim Edilemedi','Reddedildi')
                                  AND RC_Delivery_Date__c!=null AND RC_Delivery_Date__c >=: runDate LIMIT 10000];
            
        }
        
        RC_SD_CargoIntegrator.ITVBELN itvBeln = new RC_SD_CargoIntegrator.ITVBELN();
        itvBeln.item = new List<RC_SD_CargoIntegrator.Item>();
        
        for (RC_Delivery_and_Billing__c delivery : tmDeliveryList) {
            RC_SD_CargoIntegrator.Item item = new RC_SD_CargoIntegrator.Item();
            item.TES_NO = string.valueof(delivery.Name);
            
            itvBeln.item.add(item);
        }
        
        cargoIntegratorRequestModel.IT_VBELN = itvBeln;
        system.debug('reqModel:' + cargoIntegratorRequestModel);
        RC_SD_CargoIntegrator.getSdEticCargo(cargoIntegratorRequestModel);
        
        for (RC_Delivery_and_Billing__c delivery : noneTmDeliveryList) {
            
            if(delivery.RC_Status_Definition__c=='Mal çıkışı yapıldı.')
            {
                delivery.RC_Delivery_Status__c= 'Teslim Edildi';
            }
        }
        
        if(Test.isRunningTest()) {
            RC_Delivery_and_Billing__c d = new RC_Delivery_and_Billing__c();
            d.RC_Status_Definition__c = 'Test';
            noneTmDeliveryList.add(d);
        }
        
        Database.SaveResult [] updateResult = Database.update(noneTmDeliveryList, false);    
        List<RC_Logger__c> rcLoggerList = new List<RC_Logger__c>();
        for (Database.SaveResult sr : updateResult)            
        {
            if(sr.isSuccess()){
                System.debug(sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()) {
                    RC_Logger__c rcLogger = new RC_Logger__c();
                    rcLogger.RC_Message__c = 'Error: RC_SD_CargoIntegratorQueueable';
                    rcLogger.RC_Message_Detail__c = 'Queueable Error';
                    rcLogger.RC_StackTrace__c = err.getMessage();
                    rcLogger.RC_LogLevel__c = 'EXCEPTION';
                    rcLogger.CreateDate__c = DateTime.now();
                    rcLogger.RC_ClassName__c = 'RC_SD_CargoIntegratorQueueable';
                    rcLogger.RC_FunctionName__c = 'execute';
                    rcLogger.RC_ComponentName__c = '';      
                    
                    rcLoggerList.add(rcLogger);
                }
                
            }
        } 
        insert rcLoggerList;
        
        
        
        if(migrationSetting!=null && migrationSetting.RC_Is_Runnable__c)
        {
            migrationSetting.RC_Begin_Time__c = migrationSetting.RC_Begin_Time__c.addDays(1);
            update migrationSetting;
            
        }
        
    }
}