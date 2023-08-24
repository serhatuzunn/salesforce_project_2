global class RC_BillingIntegratorSchedulable implements Schedulable{
    
    global void execute(SchedulableContext ctx) {  
        try{
            RC_BillingIntegrator.RequestWrapper req = new RC_BillingIntegrator.RequestWrapper();
            RC_SchedulableSettings__c schSetting = RC_SchedulableSettings__c.getValues('Billing Schedulable Settings');
            
            string bDay,eDay,bTime,eTime = ''; 
            RC_Migration_Values__c migrationSetting = RC_Migration_Values__c.getValues('Billing Migration Values');
            if(migrationSetting!=null)
            {
                if(migrationSetting.RC_Is_Runnable__c)
                {
                    system.debug(migrationSetting.RC_Begin_Time__c.addHours(3));
                    string byear = string.valueOf(migrationSetting.RC_Begin_Time__c).substring(0,4);
                    string bmonth = string.valueOf(migrationSetting.RC_Begin_Time__c).substring(5,7);
                    string begday = string.valueOf(migrationSetting.RC_Begin_Time__c).substring(8,10);
                    string bhour = string.valueOf(migrationSetting.RC_Begin_Time__c).substring(11,13);
                    string bminute = string.valueOf(migrationSetting.RC_Begin_Time__c).substring(14,16);
                    
                    bDay = begday + '.' + bmonth +  '.' + byear;
                    bTime = bhour + ':' + bminute;
                    
                    system.debug(migrationSetting.RC_End_Time__c.addHours(3));
                    string endyear = string.valueOf(migrationSetting.RC_End_Time__c).substring(0,4);
                    string endmonth = string.valueOf(migrationSetting.RC_End_Time__c).substring(5,7);
                    string endday = string.valueOf(migrationSetting.RC_End_Time__c).substring(8,10);
                    string endhour = string.valueOf(migrationSetting.RC_End_Time__c).substring(11,13);
                    string endminute = string.valueOf(migrationSetting.RC_End_Time__c).substring(14,16);
                    
                    eDay = endday + '.' + endmonth +  '.' + endyear;
                    eTime = endhour + ':' + endminute;
                    
                    migrationSetting.RC_Begin_Time__c = migrationSetting.RC_Begin_Time__c.addDays(1);
                    migrationSetting.RC_End_Time__c = migrationSetting.RC_End_Time__c.addDays(1);
                    /*
                    if(eTime=='23:30')
                    {
                        
                        migrationSetting.RC_End_Time__c = migrationSetting.RC_End_Time__c.addMinutes(29);
                    }
                    else if(eTime=='23:59')
                    {
                        migrationSetting.RC_End_Time__c = migrationSetting.RC_End_Time__c.addMinutes(31);
                    }
                    else
                    {
                        migrationSetting.RC_End_Time__c = migrationSetting.RC_End_Time__c.addMinutes(30);
                    }
*/
                }
            }
            else {
                system.debug('test:');
                bDay  = Date.today().day() + '.' + date.today().month() + '.' + date.today().year();
                eDay    = datetime.now().time().hour()==00 ? Date.today().addDays(1) + '.' + date.today().month() + '.' + date.today().year() : bDay;
                bTime   = String.valueOf(datetime.now().time().addHours(-1)).substring(0,2) + ':00';
                eTime = String.valueOf(datetime.now().time()).substring(0,2) + ':00';   
            }
            
            req.IV_ERDAT_BEG = bDay;
            req.IV_ERDAT_END = eDay;
            req.IV_TIME_BEG  = bTime;
            req.IV_TIME_END  = eTime;
            req.IV_VBELN     = '';
            req.IV_PACKAGE   = schSetting != null ? Integer.valueOf(schSetting.RC_Package_Size__c) : 0;
            req.IV_INDEX	 = 0;
            
            RC_BillingIntegratorQueueable queue = new RC_BillingIntegratorQueueable(req, null, 0);
            
            System.enqueueJob(queue);
            
            if(migrationSetting!=null && migrationSetting.RC_Is_Runnable__c)
                update migrationSetting;
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
            RC_Logger.LOG_EXCEPTION('Error: RC_BillingIntegratorSchedulable', 'Schedulable Error', ex.getMessage(), 'RC_BillingIntegratorSchedulable', 'execute', '');
        }
    }
}