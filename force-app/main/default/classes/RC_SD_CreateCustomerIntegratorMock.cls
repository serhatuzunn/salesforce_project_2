@isTest
global class RC_SD_CreateCustomerIntegratorMock  implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_MESSAGES":{"item":[{"TYPE":"","ID":"","NUMBER":"000","MESSAGE":"Genişletme başarılı","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":0,"FIELD":"","SYSTEM":""}]},"EV_CUSTOMER_NO":"0020302153"}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}