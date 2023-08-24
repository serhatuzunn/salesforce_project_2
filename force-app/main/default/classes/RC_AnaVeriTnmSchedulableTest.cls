@isTest(SeeAllData=false)
private class RC_AnaVeriTnmSchedulableTest {
    static testmethod void testScheduledJob() {
        
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriTnmSchedulable sch1 = new RC_AnaVeriTnmSchedulable();
        sch1.execute(null);
        
        Test.stopTest();
    }
}