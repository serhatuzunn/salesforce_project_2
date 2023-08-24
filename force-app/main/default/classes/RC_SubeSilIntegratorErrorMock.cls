@isTest
global class RC_SubeSilIntegratorErrorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_MESSAGES":{"item":[{"TYPE":"E","ID":"ZSD_VKT","NUMBER":572,"MESSAGE":"Şube daha önceden silinmiştir!","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":0,"FIELD":"","SYSTEM":""}]},"ET_DELETED":{"item":[{"KUNNR":"1000000000"}]},"EV_SUCCESS":"Y"}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}