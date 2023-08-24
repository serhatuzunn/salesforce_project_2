@isTest
global class RC_SD_GetStockIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');

        if(req.getEndpoint().contains('sd_send_stock')){
            res.setBody('{"ET_OUTPUT":{"item":[{"WERKS":2204,"MAL_TANIM":"Diğer Beyaz Eşya","LGORT":"0011","LGOBE":"Kamu","MATNR":"000000000020210127","MALZEME_TANIM":"MS NFY280 E A+","MARKA":"VST","SAT_STOK":500,"VESTEL_STOK":500,"URETICI_STOK":0,"TES_MIK":0,"TAHDITSIZ":"1270770.000"}]},"EV_MESSAGE":""}');
        }
        
        return res;
    }
}