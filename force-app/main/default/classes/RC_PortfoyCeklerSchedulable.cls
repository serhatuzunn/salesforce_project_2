global class RC_PortfoyCeklerSchedulable implements Schedulable{
    
    public String IV_BUKRS {get;set;} 
    public String IV_KKBER {get;set;} 
    public String IV_KUNNR {get;set;} 
    
    global RC_PortfoyCeklerSchedulable(){
        
    }
    
    global RC_PortfoyCeklerSchedulable(string IV_BUKRS,string IV_KKBER,string IV_KUNNR){
        this.IV_BUKRS = IV_BUKRS;
        this.IV_KKBER = IV_KKBER;
        this.IV_KUNNR = IV_KUNNR;
    }
    
    global void execute(SchedulableContext ctx) {

        if(this.IV_BUKRS != null && this.IV_KKBER != null && this.IV_KUNNR != null){
            RC_PortfoyCeklerIntegrator.RequestModel req = new RC_PortfoyCeklerIntegrator.RequestModel();
            req.IV_BUKRS   = this.IV_BUKRS;
            req.IV_KKBER   = this.IV_KKBER;
            req.IV_KUNNR   = this.IV_KUNNR;
            req.IV_INDEX   = '0';
            req.IV_PACKAGE = '1000'; 
            
            RC_PortfoyCeklerBatchable batch = new RC_PortfoyCeklerBatchable(req);
            system.debug('INTEGER PACKAGE :: ' + integer.valueOf(req.IV_PACKAGE));
            Database.executeBatch(batch,integer.valueOf(req.IV_PACKAGE));
        }else{
            RC_PortfoyCeklerIntegrator.RequestModel req = new RC_PortfoyCeklerIntegrator.RequestModel();
            req.IV_INDEX   = '0';
            req.IV_PACKAGE = '1000';
            req.IV_BUKRS   = '2002';
            req.IV_KKBER   = '';
            req.IV_KUNNR   = '';
            
            RC_PortfoyCeklerBatchable batch = new RC_PortfoyCeklerBatchable(req);
            system.debug('INTEGER PACKAGE :: ' + integer.valueOf(req.IV_PACKAGE));
            Database.executeBatch(batch,integer.valueOf(req.IV_PACKAGE));
            
        }
        
    }
}