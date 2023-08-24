global class RC_BordroSilIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"DURUM":"OK","T_BORDRO":{"item":[{"MANDT":"1","BORDRO":"1","BORDROTYP":"1","TARIH_BAS":"19-10-2020","TARIH_BIT":"19-10-2020","TUTAR":"1.00","STATUS":"1","KUNNR":"","NAME1":"1","NAME2":"1","VADE":"19-10-2020","VADE_KUN":"19-10-2020","WAERS":"1","SALLAMA":"1.00","ERDAT":"19-10-2020","ERNAM":"1","KKBER":"1","VKBUR":"1","ZLSCH":"1","MONAT":"01","GJAHR":"0001"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}