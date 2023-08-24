public class RC_IptalIadeOpenRetOrderIntegrator{
    public class requestModel   {       
        public String IV_BEGDA  { get; set; } //Başlangıç Tarihi
        public String IV_ENDDA  { get; set; } //Bitiş Tarhii
        public String IV_KUNNR  { get; set; } //Bayi No
        public String IV_VKGRP  { get; set; } //Satış grubu
        public String IV_VKORG  { get; set; } //Satış Organizasyonu
        public String IV_VTWEG  { get; set; } //Dağıtım Kanalı
    }
    
    public class responseModel{
        @AuraEnabled
        public RC_IptalIadeOpenRetOrderParser.ET_RESULT ET_RESULT {get;set;}
        
        public string EV_SUCCESS {get;set;}
    }   
    
    public static responseModel getIptalIadeOpenRetOrder(requestModel req){        
        try {
            responseModel resp = new responseModel();
            resp.ET_RESULT = new RC_IptalIadeOpenRetOrderParser.ET_RESULT();           
            resp.EV_SUCCESS ='';
    
            String url = 'RESTAdapter/salesforce/sd_iade_open_ret_order';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            system.debug('Request :' + request.getBody());
            
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                RC_IptalIadeOpenRetOrderParser parseResult = RC_IptalIadeOpenRetOrderParser.parse(response.getBody());   
                resp.ET_RESULT = parseResult.ET_RESULT;        
                resp.EV_SUCCESS = parseResult.EV_SUCCESS;                 
            }
            else
            {
                system.debug('Get Iptal Iade Open Ret Order Result error : ' + response.getBody());     
            }
            
            
            return resp;
        }        
        catch(Exception e){                 
            RC_Logger.LOG_EXCEPTION('RC_IptalIadeOpenRetOrderIntegrator  Error', e.getMessage(), e.getStackTraceString(), 'RC_BayiRiskIntegrator', 'finish', '');
            return null;
        }
    }
}