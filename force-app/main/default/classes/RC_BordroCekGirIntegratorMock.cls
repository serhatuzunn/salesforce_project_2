@isTest
global class RC_BordroCekGirIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains('fi_cek_gir')){
            String json = '{'+
                '"ET_RETURN": { "item": [ { "TYPE": "S", "ID": "", "NUMBER": "000", "MESSAGE": "Giriş işlemi başarılı.", "LOG_NO": "", "LOG_MSG_NO": "000000", "MESSAGE_V1": "", "MESSAGE_V2": "", "MESSAGE_V3": "", "MESSAGE_V4": "", "PARAMETER": "", "ROW": 0, "FIELD": "", "SYSTEM": "" } ] },'+
		'    \"BATCHMOD\": \"N\",'+
		'    \"DEBUG\": \"\",'+
		'    \"EKSIKKAYIT\": \"\",'+
		'    \"FORCE\": \"\",'+
		'    \"LOG\": \"X\",'+
		'    \"UPDCOUNT\": \"0\",'+
		'    \"Name\": \"X\",'+
		'    \"TextMsg\": \"X\",'+
		'    \"OPERASYON\": \"C\",'+
                '    \"BORDROLAR\": {'+
		'        \"item\": [{'+
		'            \"MANDT\": \"021\",'+
		'            \"BORDRO\": \"1000009556\",'+
		'            \"BORDROTYP\": \"C\",'+
		'            \"TARIH_BAS\": \"20211102\",'+
		'            \"TARIH_BIT\": \"20211102\",'+
		'            \"TUTAR\": \"56.013,13\",'+
		'            \"STATUS\": \"C\",'+
		'            \"KUNNR\": \"22201781\",'+
		'            \"NAME1\": \"SEREN DAYANIKLI TÜKETİM MAMÜLLERİ\",'+
		'            \"NAME2\": \"PAZARLAMA LİMİTED ŞİRKETİ\",'+
		'            \"VADE\": \"20211201\",'+
		'            \"VADE_KUN\": \"test\",'+
		'            \"WAERS\": \"TRY\",'+
		'            \"SALLAMA\": \"0\",'+
		'            \"ERDAT\": \"test\",'+
		'            \"ERNAM\": \"test\",'+
		'            \"KKBER\": \"Vestel\",'+
		'            \"VKBUR\": \"2201\",'+
		'            \"ZLSCH\": \"test\",'+
		'            \"MONAT\": \"test\",'+
		'            \"GJAHR\": \"test\"'+
		'        }'+
                '    ]},'+
		'    \"CEKLER\": {'+
		'        \"item\": ['+
		'            {'+
		'            \"CEKNO\": \"9907669\",'+
		'            \"TARIH\": \"20210910\"'+
		'        },'+
		'        {'+
		'            \"CEKNO\": \"9907670\",'+
		'            \"TARIH\": \"20210910\"'+
		'        },'+
		'        {'+
		'            \"CEKNO\": \"9907671\",'+
		'            \"BANKL\": \"20210910\",'+                
		'            \"TARIH\": \"20210910\"'+
		'        }'+
		'        ]'+
		'    }'+
		'}';
            res.setBody(json);
        }
        else{
            res.setBody('{ "ET_RETURN": { "item": [ { "TYPE": "S", "ID": "", "NUMBER": "000", "MESSAGE": "Giriş işlemi başarılı.", "LOG_NO": "", "LOG_MSG_NO": "000000", "MESSAGE_V1": "", "MESSAGE_V2": "", "MESSAGE_V3": "", "MESSAGE_V4": "", "PARAMETER": "", "ROW": 0, "FIELD": "", "SYSTEM": "" } ] }, "CEK_ITEMS": { "item": [ { "BOENUM": 99076543, "BUDAT": "10-09-2021", "PORTFO": "C01", "KUNNR": 22201781, "ZFBDT": "30-06-2021", "XSIWE": "", "WAERS": "TRY", "WRBTR": 56.01, "BANKL": "0064-01260", "BANKN": 177005, "NAME1": "", "BOLGE": "İSTANBUL", "STCEG": 11223344789, "FATURA": "", "VKBUR": "", "HZUON": 11223344789 }, { "BOENUM": 99076544, "BUDAT": "11-09-2021", "PORTFO": "C01", "KUNNR": 22201781, "ZFBDT": "30-06-2021", "XSIWE": "", "WAERS": "TRY", "WRBTR": 56.01, "BANKL": "0064-01260", "BANKN": 177005, "NAME1": "", "BOLGE": "İSTANBUL", "STCEG": 11223344789, "FATURA": "", "VKBUR": "", "HZUON": 11223344789 }, { "BOENUM": 99076545, "BUDAT": "12-09-2021", "PORTFO": "C01", "KUNNR": 22201781, "ZFBDT": "30-06-2021", "XSIWE": "", "WAERS": "TRY", "WRBTR": 56.01, "BANKL": "0064-01260", "BANKN": 177005, "NAME1": "", "BOLGE": "İSTANBUL", "STCEG": 11223344789, "FATURA": "", "VKBUR": "", "HZUON": 11223344789 } ] }, "ET_ITEMS": { "item": [ { "BELNR": "", "BUZEI": "", "KUNNR": "", "BUDAT": "", "ZFBDT": "", "WAERS": "", "DMBTR": "", "SGTXT": "", "BLART": "", "AWKEY": "", "GJAHR": "", "ZLSPR": "", "ZLSCH": "", "LTEXT": "", "MATNR": "", "MAKTX": "", "FKIMG": "", "VRKME": "", "KKBER": "" } ] } }');
        }
        
        res.setHeader('Content-Type', 'application/json');        
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}