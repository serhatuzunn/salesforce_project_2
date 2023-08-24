public class RC_NotificationSmsService {
    
  @future(callout=true)
  public static void sendSMS(string accMobileNumber, string msgBody) {
    try {
      NotificationSMSService.BasicHttpBinding_IService smsService = new NotificationSMSService.BasicHttpBinding_IService();

      NotificationSMSService.SendSMSRequest req = new NotificationSMSService.SendSMSRequest();
      NotificationSMSService.SendSMSResponse res = new NotificationSMSService.SendSMSResponse();

      req.AppId = '4E99F2934FC14D87A41C4BD666454677';
      req.AppKeyHash = '5E5EEB4E291165D46F4EF9539912420AA6ECF572';
      req.Body = msgBody;
      req.ReferenceData = '#_OTP# SMS gönderim';
      req.SPName = 'VESTEL_Bildirim';

      NotificationSMSService.ArrayOfstring aos = new NotificationSMSService.ArrayOfstring();
      aos.string_x = new List<String>{ accMobileNumber };
      req.ToList = aos;
      res = smsService.SendSMS(req);

      System.debug('SMS res : ' + JSON.serialize(res));
      System.debug('SMS req : ' + JSON.serialize(req));

    } catch (Exception ex) {
        System.debug('SMS Exception : ' + ex.getMessage());
    }
  }
}