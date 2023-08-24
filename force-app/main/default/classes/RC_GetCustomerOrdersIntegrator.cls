public class RC_GetCustomerOrdersIntegrator {
    public class requestModel{
        public String IV_CUSTOMER;
        public String IV_DISTRCHL;
        public String IV_DIVISION;
        public String IV_REPRESENT;
        public String IV_SALESORG;
        
    }
    public class responseModel{        
        @AuraEnabled
        public RC_GetCustomerOrdersJsonParser.ET_ORDERS orderDetail {get;set;}
        @AuraEnabled
        public RC_GetCustomerOrdersJsonParser.ET_ORDERS_H orderHeader {get;set;}
    }
    
    public static responseModel getMailOrderCustomerOrders(requestModel req){
        try {
            responseModel resp = new responseModel();
            resp.orderDetail = new RC_GetCustomerOrdersJsonParser.ET_ORDERS();
            resp.orderHeader = new RC_GetCustomerOrdersJsonParser.ET_ORDERS_H();
            
            RC_GetCustomerOrdersJsonParser parseResult = null;
            
            String url = 'RESTAdapter/salesforce/sd_mail_order_get_orders';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                if(response.getStatus() == 'OK') parseResult = RC_GetCustomerOrdersJsonParser.parse(response.getBody());                
            }else{
                string responseBody = '{ \"ET_ORDERS\": { \"item\": [ { \"VBELN\": \"0011068707\", \"POSNR\": \"000010\", \"MATNR\": \"000000000020262259\", \"ARKTX\": \"SD 500 DUAL A+\", \"KWMENG\": \"25.000\", \"NETWR\": 74359.48, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0011068707\", \"POSNR\": \"000030\", \"MATNR\": \"000000000020217630\", \"ARKTX\": \"SD 400 DUAL A+  SANDIK TİPİ\", \"KWMENG\": \"10.000\", \"NETWR\": 27264.49, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0011068707\", \"POSNR\": \"000040\", \"MATNR\": \"000000000020217094\", \"ARKTX\": \"SD 300 DUAL A+  SANDIK TIPI DERIN DOND\", \"KWMENG\": \"10.000\", \"NETWR\": 23545.48, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0011068707\", \"POSNR\": \"000060\", \"MATNR\": \"000000000020216465\", \"ARKTX\": \"CD-L1103 W A+ ÇEKMECELİ DERİN DONDURUCU\", \"KWMENG\": \"5.000\", \"NETWR\": 10946.33, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0011068707\", \"POSNR\": \"000070\", \"MATNR\": \"000000000020210441\", \"ARKTX\": \"CDE-L1203 W A+ NF\", \"KWMENG\": \"3.000\", \"NETWR\": 8799.17, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0011071497\", \"POSNR\": \"000010\", \"MATNR\": \"000000000020217092\", \"ARKTX\": \"SD 200 A++ SANDIK TİPİ DERIN DONDURUCU\", \"KWMENG\": \"5.000\", \"NETWR\": 11566.12, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0021206817\", \"POSNR\": \"000010\", \"MATNR\": \"000000000020262660\", \"ARKTX\": \"AO-65104 B\", \"KWMENG\": \"5.000\", \"NETWR\": 5424.22, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0021207812\", \"POSNR\": \"000010\", \"MATNR\": \"000000000020262670\", \"ARKTX\": \"SF 8401\", \"KWMENG\": \"5.000\", \"NETWR\": 8995.02, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0021207812\", \"POSNR\": \"000020\", \"MATNR\": \"000000000020263711\", \"ARKTX\": \"SC47001\", \"KWMENG\": \"3.000\", \"NETWR\": \"8223.00\", \"UEPOS\": \"000000\" }, { \"VBELN\": \"0021207812\", \"POSNR\": \"000030\", \"MATNR\": \"000000000020264535\", \"ARKTX\": \"NFK54002 E GI WIFI\", \"KWMENG\": \"2.000\", \"NETWR\": 9112.01, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0021207812\", \"POSNR\": \"000040\", \"MATNR\": \"000000000020275258\", \"ARKTX\": \"50U9500 50\\" 4K SMART TV\", \"KWMENG\": \"5.000\", \"NETWR\": 19515.01, \"UEPOS\": \"000000\" }, { \"VBELN\": \"0021209202\", \"POSNR\": \"000010\", \"MATNR\": \"000000000020263186\", \"ARKTX\": \"CMI 108122 WIFI\", \"KWMENG\": \"5.000\", \"NETWR\": 16095.02, \"UEPOS\": \"000000\" } ] }, \"ET_ORDERS_H\": { \"item\": [ { \"VBELN\": \"0011068707\", \"AUDAT\": \"2021-02-19\", \"NETWR\": 144914.95 }, { \"VBELN\": \"0011071497\", \"AUDAT\": \"2021-03-01\", \"NETWR\": 11566.12 }, { \"VBELN\": \"0021206817\", \"AUDAT\": \"2021-03-08\", \"NETWR\": 5424.22 }, { \"VBELN\": \"0021207812\", \"AUDAT\": \"2021-03-11\", \"NETWR\": 45845.04 }, { \"VBELN\": \"0021209202\", \"AUDAT\": \"2021-03-16\", \"NETWR\": 16095.02 } ] } }';
                parseResult = (RC_GetCustomerOrdersJsonParser)JSON.deserialize(responseBody, RC_GetCustomerOrdersJsonParser.class);
            }
            
            Integer resultSize = parseResult.ET_ORDERS_H.item.size();
            if(resultSize>0)
            {
                system.debug('resultSize:' + resultSize);                    
                
                resp.orderHeader = parseResult.ET_ORDERS_H;
                resp.orderDetail = parseResult.ET_ORDERS;
                
                if(parseResult.ET_ORDERS_H.item !=null)
                    resp.orderHeader.item = parseResult.ET_ORDERS_H.item;
                
                if(parseResult.ET_ORDERS.item !=null)
                    resp.orderDetail.item = parseResult.ET_ORDERS.item;
                
                for(Integer i = 0; i < parseResult.ET_ORDERS.item.size(); i++){
                    resp.orderDetail.item[i].PURCHQUA='0';
                }                    
                system.debug('resp.orderHeader.item:' + resp.orderHeader.item);                    
            }
            
            return resp;
            
        }        
        catch(Exception e){
            system.debug('excp:' + e);
            return null;
        }
    }
    
}