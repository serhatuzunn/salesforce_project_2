@isTest
global class RC_GetDealerBonusIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_BUYUME_PERAKENDE":{"item":[{"MANDT":"","KUNNR":"","BAST":"","BITT":"","VKBUR":"","VKBUR_TXT":"","VKGRP":"","VKGRP_TXT":"","NAME1":"","KATEGORI1":"","KATEGORI2":"","KATEGORI3":"","KATEGORI4":"","KATEGORI5":"","NETCIRO":"","TOPCIRO":"","PRIM_TUTAR_KTG1":"","PRIM_TUTAR_KTG2":"","PRIM_TUTAR_KTG3":"","PRIM_TUTAR_KTG4":"","PRIM_TUTAR_KTG5":"","PRIM":"","PRIMD":"","PB":"","PRIMORANI":"","USTPRIMORANI":"","KALAN":"","ORTVADE":"","FATURALANDI":"","ORTGUN":""}]},"ET_RESULT":{"item":[{"MANDT":"","KUNNR":"","BAST":"","BITT":"","VKBUR":"","VKBUR_TXT":"","VKGRP":"","VKGRP_TXT":"","NAME1":"","GIBECIRO":"","GITVCIRO":"","GIEECIRO":"","GDBECIRO":"","GDTVCIRO":"","GDEECIRO":"","NETCIRO":"","TOPCIRO":"","GIBEPRIM":"","GITVPRIM":"","GIEEPRIM":"","GDBEPRIM":"","GDTVPRIM":"","GDEEPRIM":"","PRIM":"","PRIMD":"","PB":"","PRIMORANI":"","USTPRIMORANI":"","KALAN":"","ORTVADE":"","FATURALANDI":"","ORTGUN":""}]},"ET_RESULT_GRUP":{"item":[{"MANDT":"021","KUNNR":"0020300066","YIL":2020,"DONEM":1,"VKBUR":"0072","VKBUR_TXT":"ORTA ve DOĞU ANADOLU","VKGRP":724,"VKGRP_TXT":"Ankara(YunusCan E.)","NAME1":"ADALILAR DAYANIKLI TÜKETİM MALLARI","GRUP1CIRO":2052119.38,"GRUP2CIRO":2745257.32,"FIRSATCIRO":1574468.25,"PRIMSIZCIRO":0,"NETCIRO":6371844.95,"TOPCIRO":6399102.15,"GRUP1PRIM":88368.72,"GRUP2PRIM":143117.68,"FIRSATPRIM":"103002.60","PRIM":"334489.00","PRIMD":"334489.00","PB":"TRY","GRUP1PRIMO":"4.500","GRUP2PRIMO":"5.500","FIRSATPRIMO":"7.000","KALAN":0,"ORTVADE":"01-08-2020","FATURALANDI":"X","ORTGUN":120}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}