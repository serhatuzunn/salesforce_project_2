public with sharing class RC_SD_DeltaCustomerReaderSchedulable implements Schedulable, Database.AllowsCallouts {
    public RC_SD_DeltaCustomerReaderSchedulable() { }
    
    public void execute(SchedulableContext sc){
        try {            
            RC_SchedulableSettings__c schSetting = RC_SchedulableSettings__c.getValues('Delta_Customer_Settings');
            
            RC_SD_DeltaCustomerIntegrator.RequestModel request = null;
            
            Date runDate = null;
            if(schSetting.RC_isRunnable__c){
                runDate = schSetting.RC_Job_Run_Date__c;
                
                request = new RC_SD_DeltaCustomerIntegrator.RequestModel(
                    null,
                    Datetime.newInstance(runDate.year(), runDate.month(), runDate.day()).format('yyyyMMdd')
                );
            }
            else{
                request = new RC_SD_DeltaCustomerIntegrator.RequestModel(
                    null,
                    Datetime.now().AddDays(-1).format('yyyyMMdd')
                );
            }
            
            
            System.debug('Queue Started.');
            String runDateVal = runDate != null ? Datetime.newInstance(runDate.year(), runDate.month(), runDate.day()).format('yyyyMMdd') : Datetime.now().format('yyyyMMdd');
            
            RC_SD_DeltaCustomerReaderQueueable queue = new RC_SD_DeltaCustomerReaderQueueable(
                null,
                'Değişen',
                runDateVal,
                request
            );
            
            System.enqueueJob(queue);
            
        } catch (Exception e) {
            RC_Logger.LOG_EXCEPTION('RC_SD_DeltaCustomerReaderSchedulable Error', e.getMessage(), e.getStackTraceString(), 'RC_SD_DeltaCustomerReaderSchedulable', 'execute', '');
        }
    }
}