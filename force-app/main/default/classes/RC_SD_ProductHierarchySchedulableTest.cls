@isTest(SeeAllData=false)
private class RC_SD_ProductHierarchySchedulableTest {
    static testmethod void testScheduledJob() {
        
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_SD_ProductHierarchySchedulable sch1 = new RC_SD_ProductHierarchySchedulable();
        sch1.execute(null);
        
        Test.stopTest();
    }
}