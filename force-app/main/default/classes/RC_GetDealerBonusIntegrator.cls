public class RC_GetDealerBonusIntegrator {
    public class requestModel{
        public String PA_KUNNR;
        public String PA_TIP;
        public String PA_DONEM;
        public String PA_BAST;
        public String PA_BITT;
        public String PA_ONCEKI;
        
    }
    public class responseModel{        
        @AuraEnabled
        public RC_DealerBonusJsonParser.ET_BUYUME_PERAKENDE ET_BUYUME_PERAKENDE {get;set;}
        @AuraEnabled
        public RC_DealerBonusJsonParser.ET_RESULT ET_RESULT {get;set;}
        @AuraEnabled
        public RC_DealerBonusJsonParser.ET_RESULT_GRUP ET_RESULT_GRUP {get;set;}
    }
    
    public static responseModel getDealerBonus(requestModel req){
        try {
            responseModel resp = new responseModel();
            resp.ET_BUYUME_PERAKENDE = new RC_DealerBonusJsonParser.ET_BUYUME_PERAKENDE();
            resp.ET_RESULT = new RC_DealerBonusJsonParser.ET_RESULT();
            resp.ET_RESULT_GRUP = new RC_DealerBonusJsonParser.ET_RESULT_GRUP();
            
            String url = 'RESTAdapter/salesforce/sd_get_gnl_prim_results';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            if(!test.isRunningTest()){
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                system.debug('getDealerBonus Result Body : ' + JSON.Serialize( response.getBody()));
                RC_DealerBonusJsonParser parseResult = RC_DealerBonusJsonParser.parse(response.getBody());
                
                if(parseResult.ET_BUYUME_PERAKENDE.item !=null && parseResult.ET_BUYUME_PERAKENDE.item.size()>0) resp.ET_BUYUME_PERAKENDE.item = parseResult.ET_BUYUME_PERAKENDE.item;
                
                if(parseResult.ET_RESULT.item !=null && parseResult.ET_RESULT.item.size()>0) resp.ET_RESULT.item = parseResult.ET_RESULT.item;
                
                if(parseResult.ET_RESULT_GRUP.item !=null && parseResult.ET_RESULT_GRUP.item.size()>0) resp.ET_RESULT_GRUP.item = parseResult.ET_RESULT_GRUP.item;                
            }}
            else{
             String fakeResult ='{"ET_BUYUME_PERAKENDE":{"item":[{"MANDT":"","KUNNR":"","BAST":"","BITT":"","VKBUR":"","VKBUR_TXT":"","VKGRP":"","VKGRP_TXT":"","NAME1":"","KATEGORI1":"","KATEGORI2":"","KATEGORI3":"","KATEGORI4":"","KATEGORI5":"","NETCIRO":"","TOPCIRO":"","PRIM_TUTAR_KTG1":"","PRIM_TUTAR_KTG2":"","PRIM_TUTAR_KTG3":"","PRIM_TUTAR_KTG4":"","PRIM_TUTAR_KTG5":"","PRIM":"","PRIMD":"","PB":"","PRIMORANI":"","USTPRIMORANI":"","KALAN":"","ORTVADE":"","FATURALANDI":"","ORTGUN":""}]},"ET_RESULT":{"item":[{"MANDT":"","KUNNR":"","BAST":"","BITT":"","VKBUR":"","VKBUR_TXT":"","VKGRP":"","VKGRP_TXT":"","NAME1":"","GIBECIRO":"","GITVCIRO":"","GIEECIRO":"","GDBECIRO":"","GDTVCIRO":"","GDEECIRO":"","NETCIRO":"","TOPCIRO":"","GIBEPRIM":"","GITVPRIM":"","GIEEPRIM":"","GDBEPRIM":"","GDTVPRIM":"","GDEEPRIM":"","PRIM":"","PRIMD":"","PB":"","PRIMORANI":"","USTPRIMORANI":"","KALAN":"","ORTVADE":"","FATURALANDI":"","ORTGUN":""}]},"ET_RESULT_GRUP":{"item":[{"MANDT":"021","KUNNR":"0020300066","YIL":2020,"DONEM":1,"VKBUR":"0072","VKBUR_TXT":"ORTA ve DOĞU ANADOLU","VKGRP":724,"VKGRP_TXT":"Ankara(YunusCan E.)","NAME1":"ADALILAR DAYANIKLI TÜKETİM MALLARI","GRUP1CIRO":2052119.38,"GRUP2CIRO":2745257.32,"FIRSATCIRO":1574468.25,"PRIMSIZCIRO":0,"NETCIRO":6371844.95,"TOPCIRO":6399102.15,"GRUP1PRIM":88368.72,"GRUP2PRIM":143117.68,"FIRSATPRIM":"103002.60","PRIM":"334489.00","PRIMD":"334489.00","PB":"TRY","GRUP1PRIMO":"4.500","GRUP2PRIMO":"5.500","FIRSATPRIMO":"7.000","KALAN":0,"ORTVADE":"01-08-2020","FATURALANDI":"X","ORTGUN":120}]}}';
                RC_DealerBonusJsonParser parseResult = RC_DealerBonusJsonParser.parse(fakeResult);                    
                if(parseResult.ET_BUYUME_PERAKENDE.item !=null && parseResult.ET_BUYUME_PERAKENDE.item.size()>0){
                    resp.ET_BUYUME_PERAKENDE.item = parseResult.ET_BUYUME_PERAKENDE.item;
                }
                if(parseResult.ET_RESULT.item !=null && parseResult.ET_RESULT.item.size()>0){
                    resp.ET_RESULT.item = parseResult.ET_RESULT.item;
                }
                if(parseResult.ET_RESULT_GRUP.item !=null && parseResult.ET_RESULT_GRUP.item.size()>0){
                    resp.ET_RESULT_GRUP.item = parseResult.ET_RESULT_GRUP.item;
                }  
            }
            
            system.debug('resp getDealerBonus:' + resp);  
            
            return resp;
            
        }
        catch(Exception e){
            system.debug('excp getDealerBonus :' + e);
            return null;
        }
    }
}