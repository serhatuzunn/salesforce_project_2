@isTest
global class RC_BankaTeminatIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_RETURN":{"item":[{"BUKRS":2002,"KKBER":"0001","KUNNR":"0020400236","DMBTR":"500.00","WAERS":"TRY","NETDT":"24-04-2021","XBLNR":"ALBARAKA"}]},"EV_TOTAL_IND":10}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}