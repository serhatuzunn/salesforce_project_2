@isTest
global class RC_GetGiftVoucherCheckMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');

        if(req.getEndpoint().contains('crm_hedcek_kontrol')){
            res.setBody('{    "ES_CEK_S": {        "MANDT": 125,        "CEKNO": 8018474122,        "CEKTIPI": "00",        "MUSTNO": "0055401252",        "TCKNO": "",        "ADSOYAD": "AZİZ ŞAVLI",        "WAERS": "TRY",        "TUTAR": 87.33,        "SERVISNO": "0028001398",       "CDATE": "15-04-2011",        "CTIME": "10:42:14",       "CUSER": "MIM_5",        "CHDATE": "16-04-2011",        "CHTIME": "10:53:57",        "CHUSER": "MIM_1",        "DURUM": 1,        "BAYI": "",        "MATBUNO": 186    }}');
        }
        
        return res;
    }
}