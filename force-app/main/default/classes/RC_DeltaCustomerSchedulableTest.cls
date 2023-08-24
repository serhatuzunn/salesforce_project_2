@isTest(SeeAllData=false)
private class RC_DeltaCustomerSchedulableTest {
    static testmethod void testScheduledJob() {
        
        Test.setMock(HttpCalloutMock.class, new RC_DeltaCustomerIntegratorMock());
        
        Test.startTest();
        
        RC_DeltaCustomerSchedulable sch1 = new RC_DeltaCustomerSchedulable();
        sch1.execute(null);
        
        Test.stopTest();
    }
}