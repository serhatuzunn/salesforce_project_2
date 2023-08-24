@isTest
public class NotificationSMSServiceTest {
	@isTest
    public static void  unitTestMethod1(){
        NotificationSMSService.BasicHttpBinding_IService smsService  = new NotificationSMSService.BasicHttpBinding_IService();
        NotificationSMSService.SendSMSRequest 			 req 		 = new NotificationSMSService.SendSMSRequest();

		Test.startTest();
        
        Test.setMock(WebServiceMock.class, new RC_NotificationSmsServiceMock());
        
        smsService.SendSMS(req);
        
        Test.stopTest();
    }
}