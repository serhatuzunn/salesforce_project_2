@isTest(SeeAllData=false)
private class RC_PortfoyCeklerSchedulableTest {
    static testmethod void testScheduledJob() {
        
        string IV_BUKRS = '';
        string IV_KKBER = '';
        string IV_KUNNR = '';
            
        Test.setMock(HttpCalloutMock.class, new RC_PortfoyCeklerIntegratorMock());
        
        Test.startTest();
        
        RC_PortfoyCeklerSchedulable sch1 = new RC_PortfoyCeklerSchedulable();
        sch1.execute(null);
        
        RC_PortfoyCeklerSchedulable sch2 = new RC_PortfoyCeklerSchedulable(IV_BUKRS, IV_KKBER, IV_KUNNR);
        sch2.execute(null);
        
        Test.stopTest();
    }
}