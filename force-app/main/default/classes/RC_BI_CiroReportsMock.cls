@isTest
global class RC_BI_CiroReportsMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('VESHNABO.zh.corp%3a6400%4024166521JkaYCToei64u6D6UVhxSeqaH7pxsrsWxa24166519J0TTESeRQ5K6Fqb8BpKJ8uWclGv2eiiUI');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}