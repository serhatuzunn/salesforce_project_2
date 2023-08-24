public class RC_BordroReportIntegrator {
    
    public class item {
        public List<RC_BordroReportController.item> item {get;set;}
    }
    
    public static RC_BordroCancelIntegratorParser bordroCancelInt(RC_BordroReportController.cancelRequestWrapper req) {    
        try{
            
            String url = 'RESTAdapter/salesforce/fi_blg_sozlesme';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('request : ' + json.serialize(req));
            RC_BordroCancelIntegratorParser res = new RC_BordroCancelIntegratorParser();
            
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                if(response.getStatus() == 'OK'){
                    system.debug('Get Pos Result Body : ' + response.getBody());
                    res = RC_BordroCancelIntegratorParser.parse(response.getBody());
                    system.debug('response:::' + res);	     
                }
            }
            else{
                res = RC_BordroCancelIntegratorParser.parse('{"EV_FLAG":"S","EV_RETURN":"İşlem başarılı bir şekilde tamamlandı.","IT_ODEME_PLAN":{"item":[{"MANDT":1,"GJAHR":"0001","KUNNR":"0020300066","ZLSCH":"A","KKBER":1,"ROW_NO":1,"BORDROTIPI":1,"PORTFOY":1,"SMCTR":"1.00","CVDTE":"01.01.2021"}]},"IT_SOZLESME":{"item":[{"MANDT":1,"GJAHR":"0001","KUNNR":"0020300066","ZLSCH":"A","KKBER":1,"ROW_NO":1,"SMCTR":"1.00","CVDTE":"01.01.2021","START_DATE":"01.01.2021","END_DATE":"01.01.2021","TIMESTAMP":1,"USERNAME":1,"VARIANT":1,"ZTERM":1,"GJAHR_ZLSCH":1,"LAST_DATE":"01.01.2021","LAST_TIME":"11:00:00"}]}}');
            }
          
            return res;
        }
        catch(Exception e){
            system.debug('bordroCancelException::: ' + e);
            return null;
        }
        
    }
    
    
    public static RC_BordroApproveIntegratorParser bordroApproveInt(RC_BordroReportController.approveRequestWrapper req) {    
        try{
            system.debug('BZrequest : ' + json.serialize(req));            
            RC_BordroApproveIntegratorParser res = new RC_BordroApproveIntegratorParser();
            
            String url = 'RESTAdapter/salesforce/fi_oct_bordro_bagl_gir';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
           
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                if(response.getStatus() == 'OK'){
                    system.debug('Get BZ Result Body : ' + response.getBody());
                    res = RC_BordroApproveIntegratorParser.parse(response.getBody());
                    system.debug('BZresponse:::' + res);	     
                }
            }
            else{
                res = RC_BordroApproveIntegratorParser.parse('{"ET_RETURN":{"item":[{"KUNNR":"0020101877","KKBER":"0001","ODK":"B","MONAT":11,"GJAHR":2021,"BORDRO":3000003794,"RMESS":"","RTYPE":"S"}]}}}');
            }
            
            return res;
        }
        catch(Exception e){
            system.debug('bordroAppproveException::: ' + e);
            return null;
        }
        
    }
    
    
    
     public static RC_BordroDTSAppIntegratorParser bordroDTSApproveInt(RC_BordroReportController.DTSApproveRequestWrapper req) {    
        try{
            system.debug('DTSrequest : ' + json.serialize(req));
            RC_BordroDTSAppIntegratorParser res = new RC_BordroDTSAppIntegratorParser();
            
            String url = 'RESTAdapter/salesforce/fi_dts_baglanti_cek';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                if(response.getStatus() == 'OK'){
                    system.debug('Get DTS Result Body : ' + response.getBody());
                    res = RC_BordroDTSAppIntegratorParser.parse(response.getBody());
                    system.debug('DTSesponse:::' + res);	     
                }
            }
            else{
                res = RC_BordroDTSAppIntegratorParser.parse('{"CT_BAGLANTI_CEK":{"item":[{"BORDRO":1000207077,"KUNNR":20501267,"TAKST":6,"ORTVD":"2022-06-01","KKBER":"0001","WRBTR":"60000.00","WAERS":"TRY"},{"BORDRO":1000207078,"KUNNR":20201170,"TAKST":5,"ORTVD":"2022-05-01","KKBER":"0001","WRBTR":"5000.00","WAERS":"TRY"}]},"ET_RESULT":""}');
            }
            
            return res;
        }
        catch(Exception e){
            system.debug('bordroDTSAppproveException::: ' + e);
            return null;
        }
        
    }

}