public class RC_CreateOrdersQueueable implements Queueable, Database.AllowsCallouts {
    
    private RC_CreateOrdersIntegrator.createOrdersRequestModel request {get; set;}
    private Integer totalIndex {get; set;}
    private Integer currentIndex {get; set;}
    
    public RC_CreateOrdersQueueable(RC_CreateOrdersIntegrator.createOrdersRequestModel reqModel, Integer tIndex, Integer cIndex){
        System.debug('Current Index : ' + cIndex + ' || Total Index : ' + tIndex + ' || Request Model : ' + reqModel);
        request = reqModel;
        totalIndex = tIndex;
        currentIndex = cIndex + 1;
    }
    
    public void execute(QueueableContext cntx){
       	RC_CreateOrdersIntegrator.getOrders(request, totalIndex, currentIndex);  
    }
}