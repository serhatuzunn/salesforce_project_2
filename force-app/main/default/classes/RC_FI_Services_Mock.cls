@isTest
global class RC_FI_Services_Mock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
       if(req.getEndpoint().contains('fi_ortvade_bul')){
			res.setBody('{"EV_BAKIYE":"3000.0000","EV_ORTVADE":"2020-01-01","IT_LINEITEMS":{"item":[{"BLINE_DATE":"01-01-2020","DSCT_DAYS1":0,"PSTNG_DATE":"01-01-2020","DB_CR_IND":"S","LC_AMOUNT":"3000.0000"}]}}');
        }
        else if(req.getEndpoint().contains('fi_acik_kalemler')){
            string acikkalemlerJson = '{"ET_ITEMS":{"item":[{"BELNR":1020220441,"BUZEI":"001","KUNNR":"0022200596","BUDAT":"30-09-2021","ZFBDT":"30-09-2021","WAERS":"TRY","DMBTR":"12000.00","SGTXT":"Satış faturası","BLART":"RV","AWKEY":"0516379302","GJAHR":2021,"ZLSPR":"","ZLSCH":"","LTEXT":"SD-Satış Faturası","MATNR":{"item":[{"MATNR":"000000000020282593","MAKTX":"VESTEL AKILLI TAHTA 6","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291812","MAKTX":"A.T. PARÇA 1","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291814","MAKTX":"A.T. PARÇA 3","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291813","MAKTX":"A.T. PARÇA 2","FKIMG":"2.000","VRKME":"ST"},{"MATNR":"000000000020291815","MAKTX":"A.T. PARÇA 4","FKIMG":"2.000","VRKME":"ST"}]},"MAKTX":"","KKBER":"0011"},{"BELNR":1020202087,"BUZEI":"001","KUNNR":"0022200596","BUDAT":"25-03-2020","ZFBDT":"25-03-2021","WAERS":"USD","DMBTR":1053301.68,"SGTXT":"Satış faturası","BLART":"RV","AWKEY":"0516128000","GJAHR":2020,"ZLSPR":"","ZLSCH":"","LTEXT":"SD-Satış Faturası","MATNR":{"item":[{"MATNR":"000000000020273297","MAKTX":"DRPM-DVB245/S7820(R5)-DT","FKIMG":"3600.000","VRKME":"ST"}]},"MAKTX":"","KKBER":"0011"}]},"EV_BAKIYE":"52945985.5900","EV_ORTVADE":"06-11-2020","EV_TOTAL_IND":42}';
            res.setBody(acikkalemlerJson);
        }
        else if(req.getEndpoint().contains('fi_bordro_gir')){
            res.setBody('{"BORDRONO":1000009589,"EV_BAKIYE":"40.7500","EV_KKBER":"0025","EV_MESSAGE":"","EV_ORTVADE":"25-12-2021","EV_SUCCESS":"X"}');
        }
        else if(req.getEndpoint().contains('fi_bordro_yap_kkber')){
            res.setBody('{"EV_MESSAGE":"Yaratılma esnasında hata alan bordrolar mevcut.","IN_TAUGRU":{"item":[{"AUGRU":""}]},"IO_TKUNNR":{"item":[{"KUNNR":"0020500179","BORDROTYPE":"C","SONUC":-5,"BORDRONO":"1000205890","MSG":"Bordro ortalama vadesi uygun değil:20210630KK alan","KKBER":""}]}}');
        }
        else if(req.getEndpoint().contains('fi_dts_bordro_kalem_sil')){
            res.setBody('{"T_RETURN":{"item":[{"BORDRO":1000205890,"KALEM":"000000","BELNR":1020216437,"RESULT":"S","ERROR":"Bordro bulunamadı"}]}}');
        }
        else if(req.getEndpoint().contains('fi_dts_bordrosil')){
            res.setBody('{"DURUM":"OK"}');
        }
        else if(req.getEndpoint().contains('fi_odeme_plan')){
            res.setBody('{"EV_MESSAGE":"","ODEMEPLANDB":{"item":[{"CEKNO":"1000084821D0","BORDRO":1000084821,"BORDROTYPE":"C","KUNNR":"0020100086","KALEM":1,"TARIH":"2015-05-18","TUTAR":50327.95,"WAERS":"TRY","STATUS":"I","ISLEMTARIHI":"2015-02-04","BELNR":2020000025,"GJAHR":"0000"}]}}');
        }
        else if(req.getEndpoint().contains('fi_blg_sozlesme')){
            res.setBody('{"EV_FLAG":"S","EV_RETURN":"İşlem başarılı bir şekilde tamamlandı.","IT_ODEME_PLAN":{"item":[{"MANDT":1,"GJAHR":"0001","KUNNR":"0020300066","ZLSCH":"A","KKBER":1,"ROW_NO":1,"BORDROTIPI":1,"PORTFOY":1,"SMCTR":"1.00","CVDTE":"01.01.2021"}]},"IT_SOZLESME":{"item":[{"MANDT":1,"GJAHR":"0001","KUNNR":"0020300066","ZLSCH":"A","KKBER":1,"ROW_NO":1,"SMCTR":"1.00","CVDTE":"01.01.2021","START_DATE":"01.01.2021","END_DATE":"01.01.2021","TIMESTAMP":1,"USERNAME":1,"VARIANT":1,"ZTERM":1,"GJAHR_ZLSCH":1,"LAST_DATE":"01.01.2021","LAST_TIME":"11:00:00"}]}}');
        }
        
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}