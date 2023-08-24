@isTest
global class RC_UploadExcelIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"cek_no":"8872018.0","vade_tarihi":"2019-12-12T00:00:00","tutar":"7415.0","tckn_vergi_no":"3927937932.0","banka_anahtari":"0001-00001","banka_hesap_no":"34343.0","kesideci_bolge":""}]');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}