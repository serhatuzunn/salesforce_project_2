@isTest
global class RC_PortfoyCeklerIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_RETURN":{"item":[{"BUKRS":2002,"DMBTR":"500.00","KUNNR":"0020400236","KKBER":"0001","NETDT":"24-04-2021","PORTF":"S01","BOENO":534088}]},"EV_TOTAL_IND":29}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}