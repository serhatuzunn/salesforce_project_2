@isTest
global class RC_SubeYaratIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_RETURN":{"item":[{"TYPE":"E","ID":"R1","NUMBER":286,"MESSAGE":"Muhatap 2010003315 önceden mevcut","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":2010003315,"MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":0,"FIELD":"","SYSTEM":"PSQCLNT021"}]},"EV_SUBE":"","EV_SUCCESS":"X"}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}