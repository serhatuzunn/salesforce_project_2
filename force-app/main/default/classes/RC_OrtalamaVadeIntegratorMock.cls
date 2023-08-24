@isTest
global class RC_OrtalamaVadeIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"EV_BAKIYE":0,"EV_ORTVADE":"30-11-0002","ET_ITEMS":{"item":[{"BELNR":"1","BUZEI":"001","KUNNR":"1","BUDAT":"30-11-0002","ZFBDT":"30-11-0002","WAERS":"1","DMBTR":"1","SGTXT":"1","BLART":"1","AWKEY":"1","GJAHR":"0000","ZLSPR":"1","ZLSCH":"1","LTEXT":"1","MATNR":"1","MAKTX":"1","MENGE":"1.000","MEINS":"1"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}