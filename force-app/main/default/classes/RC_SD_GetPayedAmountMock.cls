@isTest
global class RC_SD_GetPayedAmountMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        if(request.getEndpoint().contains('sd_entg_servis_belirle')){
            String json = '{'+
		'    \"ET_SERVIS\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"SERVIS_KODU\": \"\",'+
		'                \"SERVIS_ADI\": \"\",'+
		'                \"TELEFON1\": \"\",'+
		'                \"TELEFON2\": \"\",'+
		'                \"TELEFON3\": \"\",'+
		'                \"IL\": \"\",'+
		'                \"ILCE\": \"\",'+
		'                \"SEMT\": \"\",'+
		'                \"ADRES\": \"\",'+
		'                \"EMAIL\": \"\",'+
		'                \"IL_KODU\": \"\",'+
		'                \"ILCE_KODU\": \"\",'+
		'                \"SEMT_KODU\": \"\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"EV_MESAJ_NO\": \"003\",'+
		'    \"EV_MESAJ_TXT\": \"Hatalı ürün kodu!\"'+
		'}';
                    response.setBody(json);
        }
        else if(request.getEndpoint().contains('sd_iade_open_order_list')){
            String fakeResult ='{ "ET_MESSAGE": { "item": [ { "TYPE": "S", "ID": "", "NUMBER": "000", "MESSAGE": "Girdiğiniz kriterlere uygun iade alınabilecek fatura bulunamadı.", "LOG_NO": "", "LOG_MSG_NO": "000000", "MESSAGE_V1": "", "MESSAGE_V2": "", "MESSAGE_V3": "", "MESSAGE_V4": "", "PARAMETER": "", "ROW": 0, "FIELD": "", "SYSTEM": "" } ] } }';
            response.setBody(fakeResult);
        }
        else{            
        string body = '{ "ET_RESULTS" : {"item" : [{ "SIP_NO" : 6800022, "FAT_NO" : "6800022", "PROVN" : "", "RTRFN" : "", "TUTAR" : "1", "FAIZT" : 0, "WAERS" : "" },{ "SIP_NO" : 6800022, "FAT_NO" : "6800022", "PROVN" : "", "RTRFN" : "", "TUTAR" : "1", "FAIZT" : 0, "WAERS" : "" }]}}'; 
        response.setBody(body);
        }        
        response.setHeader('Content-Type', 'application/json');
        response.setStatus('OK');
        response.setStatusCode(200);
        return response; 
    }
}