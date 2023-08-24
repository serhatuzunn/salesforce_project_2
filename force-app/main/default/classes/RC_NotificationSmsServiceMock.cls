@isTest
global class RC_NotificationSmsServiceMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            
            
            NotificationSMSService.SendSMSResponse_element respElement = new NotificationSMSService.SendSMSResponse_element();
            
            NotificationSMSService.SendSMSResponse res = new NotificationSMSService.SendSMSResponse();
            
            res.ValidToCount = 1;
            res.QueueID = 'test';
            res.TaskCanceled = true;
            res.TaskDate = system.today();
            res.ReferenceData = 'test';

            respElement.SendSMSResult = res;
            response.put('response_x', respElement); 
        }
}