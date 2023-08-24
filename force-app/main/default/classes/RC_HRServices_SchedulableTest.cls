@isTest(SeeAllData=true)
public class RC_HRServices_SchedulableTest {
    static testmethod void testScheduledJob() {
        
        Test.setMock(WebServiceMock.class, new RC_HRServices_GetUpdatedEmployeeMock());
        Test.startTest();

        RC_HRServices_UpdateEmployeeSchedulable sch1 = new RC_HRServices_UpdateEmployeeSchedulable();
        sch1.execute(null);
        
        Test.stopTest();
    }
}