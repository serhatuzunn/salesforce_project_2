@isTest
global class RC_GetGiftVoucherUseMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');

        if(req.getEndpoint().contains('sd_create_order_parametrik')){
            res.setBody('{ "ET_RETURN": {"item":[{"TYPE": "","ID": "","NUMBER": "","MESSAGE": "","LOG_NO": "","LOG_MSG_NO": "","MESSAGE_V1": "","MESSAGE_V2": "","MESSAGE_V3": "","MESSAGE_V4": "","PARAMETER": "","ROW": "","FIELD": "","SYSTEM": ""}]}}');
        }
        
        return res;
    }
}