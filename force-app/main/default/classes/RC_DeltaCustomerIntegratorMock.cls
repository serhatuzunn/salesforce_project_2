@isTest
global class RC_DeltaCustomerIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_TNM_DGTM_KANAL":{"item":[{"VTWEG":"01","VTEXT":"Toptan"}]},"ET_TNM_FTR_BLG_TR":{"item":[{"FKART":"APIA","VTEXT":"Apart İade Fatura"}]},"ET_TNM_KREDI_KNTR":{"item":[{"KKBER":"0001","KKBTX":"Bayi"}]},"ET_TNM_MUST_GRUBU":{"item":[{"KDGRP":"K1","KTEXT":"Kargo Şirketleri"}]},"ET_TNM_SATIS_BURO":{"item":[{"VKBUR":"0061","BEZEI":"FINLUX ve ÇEYİZ"}]},"ET_TNM_SATIS_MDR":{"item":[{"VKGRP":"001","BEZEI":"Satıcı grubu 001"}]},"ET_TNM_SATIS_ORG":{"item":[{"VKORG":"0001","VTEXT":"Satış org. 0001"}]},"ET_TNM_TESL_BLG_TR":{"item":[{"LFART":"APIA","VTEXT":"Apart İade Teslimat"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}