public class RC_GetPriceListFromVEFAQueueable implements Queueable, Database.AllowsCallouts  {
    private RC_GetPriceListFromVEFAIntegrator.requestModel reqNew{
        get;set;
    }
    
    public RC_GetPriceListFromVEFAQueueable(RC_GetPriceListFromVEFAIntegrator.requestModel req)
    {
        reqNew= req;        
    }
    
    public void execute(QueueableContext ctx)
    {
        try{
            RC_GetPriceListFromVefaParser res = RC_GetPriceListFromVEFAIntegrator.getPriceListFromVefa(reqNew);
            RC_GETPriceListFromVefaIntegrator.savePriceList(res.HeaderLists,res.DetailLists);
            
            system.debug('CURRENTINDEX' + reqNew.CurrentIndex);
            system.debug('PageCount : ' + res.PageCount);
            
            reqNew.CurrentIndex++;
            system.debug('CURRENTINDEX' + reqNew.CurrentIndex);
            
            if (res.PageCount > reqNew.CurrentIndex)
            {
                RC_GetPriceListFromVEFAQueueable q = new RC_GetPriceListFromVEFAQueueable(reqNew);     
                system.enqueueJob(q);
            }
        }
        catch(Exception e){
            system.debug('exception : '+ e.getMessage());            
        }
    }
    
}