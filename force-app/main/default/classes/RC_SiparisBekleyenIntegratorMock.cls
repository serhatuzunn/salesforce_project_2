@isTest
global class RC_SiparisBekleyenIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"SIPARISTEBEKLEYEN":{"item":[{"BELGENO":"","SIPARISTARIHI":"0000-00-00","BAYINO":"20101342","URUNKODU":"20217928","URUNTANIM":"","SIPARISADEDI":"0","SIPARISTEBEKLEYEN":"0","VSART":"","BIRIM":"","KDVSIZ":"","FIYATBIRIM":"","UST":"000000","POSNR":"000000","SEBEP":"","ZADRESTESL":"","ZADRESNAME":"","IL":"","ILCE":"","SEMT":"","AD":"","SOYAD":"","TEL":"","ADRES":""}]}}');       
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}