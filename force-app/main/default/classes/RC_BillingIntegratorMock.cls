@isTest
global class RC_BillingIntegratorMock implements HttpCalloutMock{
	global HttpResponse respond(HttpRequest req) {
        
        if(req.getEndpoint().contains('RESTAdapter/salesforce/sd_billing')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ET_RETURN":{"item":[{"VBELN":"0516092449", "MWSBP":"100", "NETWR":"100", "NET_VALUE":"100", "POSNR":"000020","VGTYP":"J","VGBEL":"0340303730","VGPOS":"000001","MATNR":"000000000020217175","FKIMG":"1.000","VRKME":"ST","ZTERM":"VPNK","FKART":"FTS","VKORG":2211,"VTWEG":42},{"VBELN":"05160924503242398429349823948349438943984394343","POSNR":"000030","VGTYP":"J","VGBEL":"0340303731","VGPOS":"000001","MATNR":"000000000020217175","FKIMG":"1.000","VRKME":"ST","ZTERM":"VPNK","FKART":"FTS","VKORG":2211,"VTWEG":42}]}}');
            res.setStatusCode(200);
            res.setStatus('OK');
            
            return res;
        }
        else if(req.getEndpoint().contains('RESTAdapter/salesforce/sd_delivery')){            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ET_RETURN":{"item":[{"VBELN":"0340303735","POSNR":"000001","VGBEL":"0010298965","VGPOS":"000010","MATNR":"000000000020274783","LFIMG":"2.000","VRKME":"ST","LIFSK":"","LIFSK_T":""},{"VBELN":"0340303736","POSNR":"000001","VGBEL":"0010298966","VGPOS":"000010","MATNR":"000000000020274783","LFIMG":"1.000","VRKME":"ST","LIFSK":"","LIFSK_T":""},{"VBELN":"0340303737","POSNR":"000001","VGBEL":"0010298967","VGPOS":"000010","MATNR":"000000000020274783","LFIMG":"2.000","VRKME":"ST","LIFSK":"","LIFSK_T":""},{"VBELN":"0340303738","POSNR":"000001","VGBEL":"0010298968","VGPOS":"000010","MATNR":"000000000020274783","LFIMG":"2.000","VRKME":"ST","LIFSK":"","LIFSK_T":""},{"VBELN":"0340303739","POSNR":"000001","VGBEL":"0010298970","VGPOS":"000010","MATNR":"000000000020210220","LFIMG":"2.000","VRKME":"ST","LIFSK":"","LIFSK_T":""},{"VBELN":"0340303740","POSNR":"000001","VGBEL":"0010298971","VGPOS":"000010","MATNR":"000000000020210220","LFIMG":"3.000","VRKME":"ST","LIFSK":"","LIFSK_T":""}]}}');
            res.setStatusCode(200);
            res.setStatus('OK');
            
            return res;
        }
        else
            return null;
    }
}