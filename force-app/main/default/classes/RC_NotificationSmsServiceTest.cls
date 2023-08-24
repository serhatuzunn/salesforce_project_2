@isTest
public class RC_NotificationSmsServiceTest{
    @isTest
    public static void UnitTestMethod1(){
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new RC_NotificationSmsServiceMock());
        
        string str1 = '1';
        string str2 = '2';
        
        RC_NotificationSmsService.sendSMS(str1,str2);
        
        Test.stopTest();
    }

}