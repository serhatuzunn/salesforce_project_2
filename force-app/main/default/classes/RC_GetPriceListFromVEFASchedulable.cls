global class RC_GetPriceListFromVEFASchedulable implements Schedulable, Database.AllowsCallouts
{
    global void execute(SchedulableContext ctx) {     
        RC_GetPriceListFromVEFAIntegrator.requestModel req = new RC_GetPriceListFromVEFAIntegrator.requestModel();
        req.Month= Datetime.now().month();
        req.Year= Datetime.now().year();
        req.SalesOrgCode='';
        req.DeliveryChanCode='';
        req.SaleOfficeCode='';
        req.SaleGroupCode='';
        req.PackageSize = 10;
        req.CurrentIndex = 0;
        RC_GetPriceListFromVEFAQueueable q = new RC_GetPriceListFromVEFAQueueable(req);     
        system.enqueueJob(q);              
    }
}