global class RC_SD_DocumentUpdateSchedulable implements Schedulable{
    public Date day {get; set;}
    
    global RC_SD_DocumentUpdateSchedulable(Date day){
        this.day = day;
    }
    
    global RC_SD_DocumentUpdateSchedulable(){}
    
    global void execute(SchedulableContext ctx) {    
        if(day != null){
            RC_SD_DocumentUpdateIntegrator.updateOrders(this.day);            
        }
        else{
            this.day = Date.today();
            RC_SD_DocumentUpdateIntegrator.updateOrders(this.day);  
        }
    }
}