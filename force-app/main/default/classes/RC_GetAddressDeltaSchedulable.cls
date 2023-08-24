global class RC_GetAddressDeltaSchedulable implements Schedulable {
    
    public Date startDate {get; set;}
    public Date endDate {get; set;}
    
    global RC_GetAddressDeltaSchedulable(Date startDate, Date endDate){
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    global RC_GetAddressDeltaSchedulable(){}
    
    global void execute(SchedulableContext ctx) {    
        if(startDate != null && endDate != null){
            RC_GetAddressDeltaIntegrator.getAddresses(this.startDate, this.endDate);            
        }
        else{
            this.StartDate = Date.today().addDays(-1);
            this.EndDate = Date.today();
            RC_GetAddressDeltaIntegrator.getAddresses(this.startDate, this.endDate);  
        }
    }

}