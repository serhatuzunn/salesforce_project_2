@isTest
global class RC_SD_CargoIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_DATA":{"item":[{"ZTM_DELIVEY_NO":"340338276","ZZ_CODE1":"","ZZ_ENH_DELIVERY_ST_TXT":"","ZZ_CODE2":"","ZZ_ENH_TRNS_ST_TXT":"","CARGO_COMPANY":"","REQ_END":0},{"ZTM_DELIVEY_NO":318482833,"ZZ_CODE1":"","ZZ_ENH_DELIVERY_ST_TXT":"Holding POD","ZZ_CODE2":10,"ZZ_ENH_TRNS_ST_TXT":"Unloading Begin","CARGO_COMPANY":"N21300001 / HOROZ NAKLİYAT TİCARET VE / AVCILAR-İSTANBUL","REQ_END":20190621205959}]},"ET_MESSAGE":{"item":{"TYPE":"","ID":"","NUMBER":"000","MESSAGE":"","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":0,"FIELD":"","SYSTEM":""}}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}