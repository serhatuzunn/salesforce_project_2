@isTest
global class RC_RnbxMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        if(req.getEndpoint().contains('CategoryList')){
            res.setBody('{"Success":true,"Message":"","Result":{"TreeList":[{"ID":1,"IsSelected":false,"DisplayName":"Beyaz Eşya","Code":"v_beyaz-esya","ImageUri":"","IsNotHyperlink":false,"IsBrandCategory":false,"HasProduct":true,"Count":12,"SubCategoryList":[{"ID":11,"IsSelected":false,"DisplayName":"Bulaşık Makineleri","Code":"v_bulasik-makineleri","ImageUri":"","IsNotHyperlink":false,"IsBrandCategory":false,"HasProduct":true,"Count":2,"SubCategoryList":[{"ID":49,"IsSelected":false,"DisplayName":"Bulaşık Makinesi","Code":"v_profesyonel--makinesi","ImageUri":"","IsNotHyperlink":false,"IsBrandCategory":false,"HasProduct":false,"Count":0,"SubCategoryList":[]}]}]}]},"Exception":null}');
        }
        else if(req.getEndpoint().contains('ProductList')){
            res.setBody('{"Success":true,"Message":"","Result":{"ProductList":[{"ID":1203,"FirstProductImageURL":"https://statics.vestel.com./productimages/.jpg","SecondProductImageURL":"https://statics.vestel.com.tr//.jpg","BrandName":"Vestel","ExternalSystemCode":"123","DisplayName":"VestelCRS df No-Frost Buzdolabı","ProductType":""}],"TotalPageCount":2,"TotalItemCount":18},"Exception":""}');
        }
        
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}