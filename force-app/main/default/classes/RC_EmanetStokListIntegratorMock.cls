@isTest
global class RC_EmanetStokListIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_OUTPUT":{"item":[{"MATNR":"","MAKTX":"CD-L1103 W A+DERİN DONDURUCU","WERKS":"9205","KULAB":"1","OMENG":"0","CHARG":"","KUNNR":"","ZZMARKA":"VST","KONDM":"22"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}