@isTest(SeeAllData=false)
private class RC_GetAddressDeltaSchedulableTest {
    static testmethod void testScheduledJob() {
        Test.setMock(HttpCalloutMock.class, new RC_GetAddressDeltaIntegratorMock());
        
        
        
        Date startDate = Date.today().addDays(-1);
        Date endDate   = Date.today();
		List<String> deleteIds= new List<String>();
        
        RC_GetAddressDeltaIntegrator.RegionInfo newRegion = new RC_GetAddressDeltaIntegrator.RegionInfo();

		newRegion.ilce =   'a083L000000MtMvQAK';
        newRegion.il =   'a083L000000MtMvQAK';
        newRegion.mahalle =   'a083L000000MtMvQAK';
        newRegion.code =   'a083L000000MtMvQAK';
        newRegion.id =   'a083L000000MtMvQAK';
        
        
        RC_City_Region__c x = new RC_City_Region__c(RC_Region__c = 'a083L000000MtMvQAK', 
                                                    RC_District__c = 'a083L000000MtMvQAK');                        
        
        
        Test.startTest();
        
        RC_GetAddressDeltaSchedulable sch1 = new RC_GetAddressDeltaSchedulable();
        sch1.execute(null);
        
        
        RC_GetAddressDeltaSchedulable sch2 = new RC_GetAddressDeltaSchedulable(startDate, endDate);
        sch2.execute(null);
        
        Test.stopTest();
    }
}