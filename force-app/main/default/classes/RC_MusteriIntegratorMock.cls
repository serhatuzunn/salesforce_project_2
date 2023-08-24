@isTest
global class RC_MusteriIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"EV_MESSAGE":"","IN_TKUNN":{"item":[{"KUNNR":"0007001032"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}