public class RC_IptalIadeGetPackagedSalesIntegrator{
    public class requestModel   {       
        public String IV_AUGRU  { get; set; } //Sipariş Gerekçesi
    }
    
    public class responseModel{
        @AuraEnabled
        public RC_IptalIadeGetPackagedSalesParser.ET_EXPORT1 export1 {get;set;}
        public RC_IptalIadeGetPackagedSalesParser.ET_EXPORT2 export2 {get;set;}
        public RC_IptalIadeGetPackagedSalesParser.ET_EXPORT3 export3 {get;set;}
        public RC_IptalIadeGetPackagedSalesParser.ET_EXPORT4 export4 {get;set;}
        public RC_IptalIadeGetPackagedSalesParser.ET_EXPORT5 export5 {get;set;}
        public RC_IptalIadeGetPackagedSalesParser.ET_EXPORT6 export6 {get;set;}
        public string EV_ID {get;set;}
        public string EV_PACKAGE{get;set;}
    }   
    
    public static responseModel getIptalIadePackages(requestModel req){        
        try {
            responseModel resp = new responseModel();
            resp.export1 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT1();
            resp.export2 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT2();
            resp.export3 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT3();
            resp.export4 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT4();
            resp.export5 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT5();
            resp.export6 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT6();
            resp.EV_ID = '';
            resp.EV_PACKAGE ='';
    
            String url = 'RESTAdapter/salesforce/sd_iade_packaged_sales';
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
                RC_IptalIadeGetPackagedSalesParser parseResult =  RC_IptalIadeGetPackagedSalesParser.parse(response.getBody());   
                resp.export1 = parseResult.ET_EXPORT1;        
                resp.export2 = parseResult.ET_EXPORT2;  
                resp.export3 = parseResult.ET_EXPORT3;                   
                resp.export4 = parseResult.ET_EXPORT4;                   
                resp.export5 = parseResult.ET_EXPORT5;                   
                resp.export6 = parseResult.ET_EXPORT6;                   
                resp.EV_ID = parseResult.EV_ID; 
                resp.EV_PACKAGE = parseResult.EV_PACKAGE;      
            }
            else
            {
                system.debug('Get Iptal Iade Packages Result error : ' + response.getBody());     
            }
            
            
            return resp;
        }        
        catch(Exception e){                 
            RC_Logger.LOG_EXCEPTION('RC_IptalIadeGetPackagedSalesIntegrator  Error', e.getMessage(), e.getStackTraceString(), 'RC_BayiRiskIntegrator', 'finish', '');
            return null;
        }
    }
}