@isTest
global class RC_ProductListIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('{"Success":true,"Message":"","Result":{"ProductList":[{"ID":1203,"FirstProductImageURL":"https://statics.vestel.com./productimages/.jpg","SecondProductImageURL":"https://statics.vestel.com.tr//.jpg","BrandName":"Vestel","ExternalSystemCode":"","DisplayName":"VestelCRS df No-Frost Buzdolabı","ProductType":""}],"TotalPageCount":2,"TotalItemCount":18},"Exception":""}');
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}