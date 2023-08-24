global class RC_SD_CargoIntegratorSchedulable implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        try
        {
            RC_SD_CargoIntegrator.requestModel req= new RC_SD_CargoIntegrator.requestModel();
            RC_SD_CargoIntegratorQueueable queue = new RC_SD_CargoIntegratorQueueable(req);
            System.enqueueJob(queue);
                        
        }
        catch(Exception ex){RC_Logger.LOG_EXCEPTION('Error: RC_SD_CargoIntegratorSchedulable', 'Schedulable error', ex.getMessage(), 'RC_SD_CargoIntegratorSchedulable', 'execute', '');}
    }
}