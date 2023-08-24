@isTest
global class RC_EmanetSiparisMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        if(req.getEndpoint().contains('sd_siparis_bekleyen')){
            res.setBody('{"SIPARISTEBEKLEYEN":{"item":[{"BELGENO":"","SIPARISTARIHI":"0000-00-00","BAYINO":"20101342","URUNKODU":"20217928","URUNTANIM":"","SIPARISADEDI":"0","SIPARISTEBEKLEYEN":"0","VSART":"08","BIRIM":"","KDVSIZ":"","FIYATBIRIM":"","UST":"000000","POSNR":"000000","SEBEP":"","ZADRESTESL":"","ZADRESNAME":"","IL":"","ILCE":"","SEMT":"","AD":"","SOYAD":"","TEL":"","ADRES":""}]}}');       
        }
        else if(req.getEndpoint().contains('sd_teslimat_bekleyen')){
            res.setBody('{"TESLIMATTABEKLEYEN":{"item":[{"BAYINO":"20101342","URUNKODU":"20217928","URUNTANIM":"","TESLIMATTABEKLEYEN":"0","BIRIM":"","VSART":"08","KDVSIZ":"0","FIYATBIRIM":"","SIPARISNO":"","SIPARISKLM":"000000","ZADRESTESL":"","TESLIMATNO":"","TESLIMATKLM":"000000","WERKS":"","IL":"","ILCE":"","SEMT":"","AD":"","SOYAD":"","TEL":"","ADRES":"","GUN":"0000-00-00"}]}}');
        }
        else if(req.getEndpoint().contains('sd_emnt_stok_list')){
            res.setBody('{"ET_OUTPUT":{"item":[{"MATNR":"01","MAKTX":"CD-L1103 W A+DERİN DONDURUCU","WERKS":"9205","KULAB":"1","OMENG":"0","CHARG":"","KUNNR":"","ZZMARKA":"VST","KONDM":"22"}]}}');
        }
        
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}