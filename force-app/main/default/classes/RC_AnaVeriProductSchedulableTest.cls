@isTest(SeeAllData=false)
private class RC_AnaVeriProductSchedulableTest {
    static testmethod void testScheduledJob() {
        
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriProductSchedulable sch1 = new RC_AnaVeriProductSchedulable('2201', '01');
        sch1.execute(null);
        
        Test.stopTest();
    }
}