public class RC_BordroCekGirIntegrator {
    
    public class Item {
        public String BOENUM {get;set;}
        public String BUDAT {get;set;}
        public String PORTFO {get;set;}
        public String KUNNR {get;set;}
        public String ZFBDT {get;set;}
        public String XSIWE {get;set;}
        public String WAERS {get;set;}
        public String WRBTR {get;set;}
        public String BANKL {get;set;}
        public String BANKN {get;set;}
        public String NAME1 {get;set;}
        public String BOLGE {get;set;}
        public String STCEG {get;set;}
        public String FATURA {get;set;}
        public String VKBUR {get;set;}
        public String HZUON {get;set;}
    }
    
    public class ET_ITEMS {
        public Item_Z item {get;set;}
    }
    
    public class Item_Z {
        public String BELNR {get;set;}
        public String BUZEI {get;set;}
        public String KUNNR {get;set;}
        public String BUDAT {get;set;}
        public String ZFBDT {get;set;}
        public String WAERS {get;set;}
        public String DMBTR {get;set;}
        public String SGTXT {get;set;}
        public String BLART {get;set;}
        public String AWKEY {get;set;}
        public String GJAHR {get;set;}
        public String ZLSPR {get;set;}
        public String ZLSCH {get;set;}
        public String LTEXT {get;set;}
        public String MATNR {get;set;}
        public String MAKTX {get;set;}
        public String FKIMG {get;set;}
        public String VRKME {get;set;}
        public String KKBER {get;set;}
    }
    
    public class CEK_ITEMS {
        public List<Item> item;
    }
    
    public class RequestModel {
        @AuraEnabled
        public String BORDRONO {get;set;}
        @AuraEnabled
        public String BORDROTYPE {get;set;}
        @AuraEnabled
        public String IV_BAKIYE {get;set;}
        @AuraEnabled
        public String IV_ORTVADE {get;set;}
        @AuraEnabled
        public String IV_SFBAKIYE {get;set;}
        @AuraEnabled
        public String IV_SFORTVADE {get;set;}
        @AuraEnabled
        public CEK_ITEMS CEK_ITEMS {get;set;}
        @AuraEnabled
        public ET_ITEMS ET_ITEMS {get;set;}
    }
    
    public class ResponseModel{
        @AuraEnabled
        public RC_BordroCekGirParser bordroCekGirResponse {get;set;}
    }
    
    public static ResponseModel getBordroCekGir(requestModel req){
        try {
            String url = 'RESTAdapter/salesforce/fi_bordro_cek_gir';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();            
            system.debug('Get getBordroCekGir req Body : ' + req);
            
            HttpResponse response = http.send(request); 
            
            ResponseModel resp = new ResponseModel();            
            
            system.debug('Get getBordroCekGir Result Body : ' + response.getBody());
             
                if(response.getStatus() == 'OK'){
                    RC_BordroCekGirParser parseResult = RC_BordroCekGirParser.parse(response.getBody());
                    
                    resp.bordroCekGirResponse = parseResult;
                    return resp;
                }
        /*    }
            else{       
                String fakeResult = '{ "ET_RETURN": { "item": [ { "TYPE": "S", "ID": "", "NUMBER": "000", "MESSAGE": "Giriş işlemi başarılı.", "LOG_NO": "", "LOG_MSG_NO": "000000", "MESSAGE_V1": "", "MESSAGE_V2": "", "MESSAGE_V3": "", "MESSAGE_V4": "", "PARAMETER": "", "ROW": 0, "FIELD": "", "SYSTEM": "" } ] }, "CEK_ITEMS": { "item": [ { "BOENUM": 99076543, "BUDAT": "10-09-2021", "PORTFO": "C01", "KUNNR": 22201781, "ZFBDT": "30-06-2021", "XSIWE": "", "WAERS": "TRY", "WRBTR": 56.01, "BANKL": "0064-01260", "BANKN": 177005, "NAME1": "", "BOLGE": "İSTANBUL", "STCEG": 11223344789, "FATURA": "", "VKBUR": "", "HZUON": 11223344789 }, { "BOENUM": 99076544, "BUDAT": "11-09-2021", "PORTFO": "C01", "KUNNR": 22201781, "ZFBDT": "30-06-2021", "XSIWE": "", "WAERS": "TRY", "WRBTR": 56.01, "BANKL": "0064-01260", "BANKN": 177005, "NAME1": "", "BOLGE": "İSTANBUL", "STCEG": 11223344789, "FATURA": "", "VKBUR": "", "HZUON": 11223344789 }, { "BOENUM": 99076545, "BUDAT": "12-09-2021", "PORTFO": "C01", "KUNNR": 22201781, "ZFBDT": "30-06-2021", "XSIWE": "", "WAERS": "TRY", "WRBTR": 56.01, "BANKL": "0064-01260", "BANKN": 177005, "NAME1": "", "BOLGE": "İSTANBUL", "STCEG": 11223344789, "FATURA": "", "VKBUR": "", "HZUON": 11223344789 } ] }, "ET_ITEMS": { "item": [ { "BELNR": "", "BUZEI": "", "KUNNR": "", "BUDAT": "", "ZFBDT": "", "WAERS": "", "DMBTR": "", "SGTXT": "", "BLART": "", "AWKEY": "", "GJAHR": "", "ZLSPR": "", "ZLSCH": "", "LTEXT": "", "MATNR": "", "MAKTX": "", "FKIMG": "", "VRKME": "", "KKBER": "" } ] } }';
                RC_BordroCekGirParser parse = RC_BordroCekGirParser.parse(fakeResult);
                
                resp.bordroCekGirResponse = parse;
                return resp;
            }*/
            
            return resp;
            
        }
        
        catch(Exception ex){
            system.debug('ex : ' + ex);
            return null;
        }
    }
    
}