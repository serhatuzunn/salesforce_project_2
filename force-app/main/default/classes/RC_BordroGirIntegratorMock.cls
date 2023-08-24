@isTest
global class RC_BordroGirIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"BORDRONO":"","EV_BAKIYE":0,"EV_KKBER":"","EV_MESSAGE":"Sadece OÇT çek ve senedi için giriş yapılabilir!","EV_ORTVADE":"30-11-0002","EV_SUCCESS":"","IT_ITEMS":{"item":[{"BELNR":"5130009361","BUZEI":"001","KUNNR":"0020200742","BUDAT":"26-10-2018","ZFBDT":"23-02-2019","WAERS":"TRY","DMBTR":"5.65","SGTXT":"","BLART":"0","VKBUR":""}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}