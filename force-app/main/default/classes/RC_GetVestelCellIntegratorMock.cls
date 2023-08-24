@isTest
global class RC_GetVestelCellIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');

        if(req.getEndpoint().contains('crm_vcell_b2b_durum')){
            res.setBody('{"EV_MESSAGE": "Hediye çeki güncellendi","EV_SUCCESS": "X"}');
        }
        
        return res;
    }
}