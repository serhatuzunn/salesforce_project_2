@isTest
global class RC_DocFlowMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');

        if(req.getEndpoint().contains('sd_doc_flow')){
           res.setBody('{"ET_RETURN":{"item":[{"VBELN_VA":"0011072364","POSNR_VA":"000010","BLOKAJ":"","VBELN_VL":"","POSNR_VL":"000000","VBELN_CKS":4916120270,"VBELN_VF":"","POSNR_VF":"000000"},{"VBELN_VA":"0011072364","POSNR_VA":"000020","BLOKAJ":"","VBELN_VL":"","POSNR_VL":"000000","VBELN_CKS":4916120270,"VBELN_VF":"","POSNR_VF":"000000"},{"VBELN_VA":"0011072364","POSNR_VA":"000030","BLOKAJ":"","VBELN_VL":"0319406300","POSNR_VL":"000001","VBELN_CKS":4916120270,"VBELN_VF":"0331226339","POSNR_VF":"000030"},{"VBELN_VA":"0011072364","POSNR_VA":"000040","BLOKAJ":"","VBELN_VL":"0319406301","POSNR_VL":"000001","VBELN_CKS":4916120270,"VBELN_VF":"0331226338","POSNR_VF":"000040"}]}}');
        }
        else if(req.getEndpoint().contains('sd_etic_cargo')){
            res.setBody('{"ET_DATA":{"item":[{"ZTM_DELIVEY_NO":"","ZZ_CODE1":"","ZZ_ENH_DELIVERY_ST_TXT":"","ZZ_CODE2":"","ZZ_ENH_TRNS_ST_TXT":"","CARGO_COMPANY":"","REQ_END":0},{"ZTM_DELIVEY_NO":319406301,"ZZ_CODE1":"","ZZ_ENH_DELIVERY_ST_TXT":"Holding POD","ZZ_CODE2":"05","ZZ_ENH_TRNS_ST_TXT":"In Transit","CARGO_COMPANY":"N20603536 / EKOL LOJİSTİK A.Ş. / 34935 SULTANBEYLİ-İSTANBUL","REQ_END":20210319215959},{"ZTM_DELIVEY_NO":319406300,"ZZ_CODE1":"","ZZ_ENH_DELIVERY_ST_TXT":"Holding POD","ZZ_CODE2":"05","ZZ_ENH_TRNS_ST_TXT":"In Transit","CARGO_COMPANY":"N20603536 / EKOL LOJİSTİK A.Ş. / 34935 SULTANBEYLİ-İSTANBUL","REQ_END":20210319215959}]},"ET_MESSAGE":{"item":[{"TYPE":"","ID":"","NUMBER":"000","MESSAGE":"","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":0,"FIELD":"","SYSTEM":""}]}}');
        }
        
        return res;
    }
}