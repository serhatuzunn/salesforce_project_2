@isTest
global class RC_ServicesVPIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_INFO":{"item":[{"YETKINLIK2":", Angel, Whirlpool, Kondisyon_Aletleri, PC","YETKINLIK":{"item":[{"YETKI_KODU":"06","DESCRIPTION":""},{"YETKI_KODU":"07","DESCRIPTION":"Angel"},{"YETKI_KODU":"08","DESCRIPTION":"Whirlpool"},{"YETKI_KODU":"14","DESCRIPTION":"Kondisyon_Aletleri"},{"YETKI_KODU":"18","DESCRIPTION":"PC"}]},"TELEFON2":"","TELEFON1":"8502224123","SERVIS_KODU":"0028001733","SERVIS_ADI":"NECMETTİN ERBAKAN DİLSİZ .","SEMT_KODU":"53109049","SEMT":"ÇAYIRLI KÖYÜ","MIMDE_GORUNSUN":"X","LONGITUDE":40.512072,"LATITUDE":41.030174,"ILCE_KODU":"000000053109","ILCE":"KALKANDERE","IL_KODU":"053","IL":"RİZE","FAKS":"4642130545","EMAIL":"28001733@servisvestel.com","ALAN_KODU":"850","ADRES":"EMİNETTİN MAH. LOKMAN HEKİM SOK. SERAP APT. NO:4 MERKEZ / RİZE"},{"YETKINLIK2":"Ankastre_Komple, Elektronik, Beyaz Eşya, Klima, Yangın","YETKINLIK":{"item":[{"YETKI_KODU":"04","DESCRIPTION":"Ankastre_Komple"},{"YETKI_KODU":"16","DESCRIPTION":"Elektronik"},{"YETKI_KODU":"17","DESCRIPTION":"Beyaz Eşya"},{"YETKI_KODU":"19","DESCRIPTION":"Klima"},{"YETKI_KODU":"20","DESCRIPTION":"Yangın"}]},"TELEFON2":"","TELEFON1":"8502224123","SERVIS_KODU":"0028002247","SERVIS_ADI":"MUHAMMET ALİ ULUSOY RİZE ULUSOY TEKNİK","SEMT_KODU":"53109049","SEMT":"ÇAYIRLI KÖYÜ","MIMDE_GORUNSUN":"X","LONGITUDE":40.5069284,"LATITUDE":41.0373799,"ILCE_KODU":"000000053109","ILCE":"KALKANDERE","IL_KODU":"053","IL":"RİZE","FAKS":"","EMAIL":"28002247@servisvestel.com","ALAN_KODU":"850","ADRES":"CAMİÖNÜ MAH. CUMHURİYET CD.NO:2/A MERKEZ / RİZE"}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}