global class RC_BankaTeminatSchedulable implements Schedulable{
    public String IV_BUKRS {get;set;} 
    public String IV_KKBER {get;set;} 
    public String IV_KUNNR {get;set;} 
    
    global RC_BankaTeminatSchedulable(){
        
    }
    
    global RC_BankaTeminatSchedulable(string IV_BUKRS,string IV_KKBER,string IV_KUNNR){
        this.IV_BUKRS = IV_BUKRS;
        this.IV_KKBER = IV_KKBER;
        this.IV_KUNNR = IV_KUNNR;
    }
    
    global void execute(SchedulableContext ctx) {
        
        if(this.IV_BUKRS != null && this.IV_KKBER != null && this.IV_KUNNR != null){
            RC_BankaTeminatIntegrator.RequestModel req = new RC_BankaTeminatIntegrator.RequestModel();
            req.IV_BUKRS   = this.IV_BUKRS;
            req.IV_KKBER   = this.IV_KKBER;
            req.IV_KUNNR   = this.IV_KUNNR;
            req.IV_INDEX   = '0';
            req.IV_PACKAGE = '1000'; 
            req.IV_DAYS    = '365';
            
            RC_BankaTeminatBatchable batch = new RC_BankaTeminatBatchable(req);
            system.debug('INTEGER PACKAGE :: ' + integer.valueOf(req.IV_PACKAGE));
            Database.executeBatch(batch,integer.valueOf(req.IV_PACKAGE));
        }else{
            RC_BankaTeminatIntegrator.RequestModel req = new RC_BankaTeminatIntegrator.RequestModel();
            req.IV_INDEX   = '0';
            req.IV_PACKAGE = '1000';
            req.IV_BUKRS   = '2002';
            req.IV_KKBER   = '';
            req.IV_KUNNR   = '';
            req.IV_DAYS    = '365';
            
            RC_BankaTeminatBatchable batch = new RC_BankaTeminatBatchable(req);
            system.debug('INTEGER PACKAGE :: ' + integer.valueOf(req.IV_PACKAGE));
            Database.executeBatch(batch,integer.valueOf(req.IV_PACKAGE));
            
        }
        
    }
    
}