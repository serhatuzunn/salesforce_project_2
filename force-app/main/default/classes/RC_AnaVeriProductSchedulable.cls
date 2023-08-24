global class RC_AnaVeriProductSchedulable implements Schedulable{

    public String IV_VKORG {get;set;} 
    public String IV_VTWEG {get;set;} 

    global RC_AnaVeriProductSchedulable(String IV_VKORG, String IV_VTWEG){
        this.IV_VKORG = IV_VKORG;
        this.IV_VTWEG = IV_VTWEG;
    }
    
    global void execute(SchedulableContext ctx) {
        if(this.IV_VKORG != null && this.IV_VTWEG != null){
            RC_AnaVeriIntegrator.RequestModel req = new RC_AnaVeriIntegrator.RequestModel();
            req.IV_TANIM   = '';
            req.IV_VKORG   = this.IV_VKORG;
            req.IV_VTWEG   = this.IV_VTWEG;
            req.IV_INDEX   = '0';
            req.IV_PACKAGE = '1000'; 
            
            RC_AnaVeriProductBatchable batch = new RC_AnaVeriProductBatchable(req);
            system.debug('INTEGER PACKAGE : ' + integer.valueOf(req.IV_PACKAGE));
            Database.executeBatch(batch,integer.valueOf(req.IV_PACKAGE));
        }
    }  
}