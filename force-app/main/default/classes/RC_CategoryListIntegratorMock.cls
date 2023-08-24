@isTest
global class RC_CategoryListIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('{"Success":true,"Message":"","Result":{"TreeList":[{"ID":1,"IsSelected":false,"DisplayName":"Beyaz Eşya","Code":"v_beyaz-esya","ImageUri":"","IsNotHyperlink":false,"IsBrandCategory":false,"HasProduct":true,"Count":12,"SubCategoryList":[{"ID":11,"IsSelected":false,"DisplayName":"Bulaşık Makineleri","Code":"v_bulasik-makineleri","ImageUri":"","IsNotHyperlink":false,"IsBrandCategory":false,"HasProduct":true,"Count":2,"SubCategoryList":[{"ID":49,"IsSelected":false,"DisplayName":"Bulaşık Makinesi","Code":"v_profesyonel--makinesi","ImageUri":"","IsNotHyperlink":false,"IsBrandCategory":false,"HasProduct":false,"Count":0,"SubCategoryList":[]}]}]}]},"Exception":null}');
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}