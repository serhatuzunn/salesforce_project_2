@isTest
global class RC_TeslimatBekleyenIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"TESLIMATTABEKLEYEN":{"item":[{"BAYINO":"20101342","URUNKODU":"20217928","URUNTANIM":"","TESLIMATTABEKLEYEN":"0","BIRIM":"","VSART":"","KDVSIZ":"0","FIYATBIRIM":"","SIPARISNO":"","SIPARISKLM":"000000","ZADRESTESL":"","TESLIMATNO":"","TESLIMATKLM":"000000","WERKS":"","IL":"","ILCE":"","SEMT":"","AD":"","SOYAD":"","TEL":"","ADRES":"","GUN":"0000-00-00"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}