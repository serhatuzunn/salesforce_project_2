@isTest
global class RC_CekGirIntegratorMock {
global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "ET_RETURN": "", "UPDCOUNT": 0, "BORDROLAR": { "item": [ { "MANDT": "021", "BORDRO": 1000009624, "BORDROTYP": "C", "TARIH_BAS": "30-11-0002", "TARIH_BIT": "04-11-2021", "TUTAR": 6093.35, "STATUS": "C", "KUNNR": "0020800406", "NAME1": "Test Bayi SAP LTD ŞTİ S.U", "NAME2": "", "VADE": "30-11-2021", "VADE_KUN": "30-11-0002", "WAERS": "TRY", "SALLAMA": 0, "ERDAT": "30-11-0002", "ERNAM": "", "KKBER": "0023", "VKBUR": "0072", "ZLSCH": "", "MONAT": "00", "GJAHR": "0000" } ] }, "CEKLER": { "item": [ { "CEKNO": 5454545, "BANKL": "067-00723", "TARIH": "03-11-2021" }, { "CEKNO": 4455334, "BANKL": "0067-00744", "TARIH": "03-11-2021" } ] } }');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}