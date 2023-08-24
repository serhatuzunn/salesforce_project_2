@isTest
global class RC_IptalIadeGetOrdersIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "ET_MESSAGE": { "item": [ { "TYPE": "S", "ID": "", "NUMBER": "000", "MESSAGE": "Girdiğiniz kriterlere uygun iade alınabilecek fatura bulunamadı.", "LOG_NO": "", "LOG_MSG_NO": "000000", "MESSAGE_V1": "", "MESSAGE_V2": "", "MESSAGE_V3": "", "MESSAGE_V4": "", "PARAMETER": "", "ROW": 0, "FIELD": "", "SYSTEM": "" } ] } }');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}