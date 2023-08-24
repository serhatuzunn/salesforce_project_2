global class RC_UpdateOrdersStatusSchedulable  implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
    	try
        {
            RC_UpdateOrderStatus.UpdateOrders();
        }
        catch(exception ex)
        {
            system.debug('exception:' + ex);
        }
    }
}