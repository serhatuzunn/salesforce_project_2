@isTest
global class RC_EmanetStokMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_OUTPUT":{"item":[{"MATNR": "000000000020263211","MAKTX": "BM 4201","WERKS": "D270","KULAB": 15,"OMENG": 0,"CHARG": "0319186481"},{"MATNR": "000000000020219975","MAKTX": "AF-5651 S","WERKS": "D270","KULAB": 10,"OMENG": 0,"CHARG": "0318234271"},{"MATNR": "000000000020217928","MAKTX": "CDE-M1102 W A+ ÇEKMECELİ DERİN DONDURUCU","WERKS": "D270","KULAB": 1,"OMENG": 0,"CHARG": "0318859015"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}