@isTest
global class RC_BaglantiIntegratorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ET_RETURN":{"item":[{"BUKRS":"2002","KUNNR":"0020300066","GJAHR":"2021","SOZLESME_NO":"2021D","SOZLESME_BAS":"01-01-2021","SOZLESME_BIT":"31-12-2021","VADE_TARIH":"01-01-2022","TOPLAM_CEK":"55000000","FAT_TOTAL":"9335052.62","FAT_ORT_VADE":"248.05","FAT_ORT_TARIH":"13-02-2021","FAT_VADE_TARIH":"02-01-2022","FAT_DETAY":{"item":[{"BUKRS":"2002","BELNR":"1020017234","GJAHR":"2021","UMSKZ":"","SHKZG":"S","H_BLART":"RV","NETDT":"31-12-2021","DMBTR":"3325","KUNNR":"0020300066","H_BUDAT":"15-01-2021","H_BLDAT":"15-01-2021","ZZBGL_DNM":"2021D"}]},"BAGCEK_TOTAL1":"55000000","BAGCEK_ORT_VADE1":"247.48","BAGCEK_ORT_TARIH":"19-02-2021","BAGCEK_VADE_TARIH":"01-01-2022","CEK_DETAY":{"item":[{"BUKRS":"2002","BELNR":"2130001052","GJAHR":"2021","UMSKZ":"H","SHKZG":"H","H_BLART":"CL","NETDT":"11-09-2021","DMBTR":"1170000","KUNNR":"0020300066","H_BUDAT":"19-02-2021","ZZBGL_DNM":"2021D"}]}}]}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}