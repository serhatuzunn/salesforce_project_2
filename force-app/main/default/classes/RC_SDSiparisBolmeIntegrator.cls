public with sharing class RC_SDSiparisBolmeIntegrator {
    public class Item_1    {
        public String SIP_NO { get; set; }
        public String SIP_KALEM { get; set; }
        public integer MIKTAR { get; set; }
    }
    public class Item_2{
        public String PARTN_ROLE { get; set; }
        public String PARTN_NUMB { get; set; }
        public String ITM_NUMBER { get; set; }
        public String TITLE { get; set; }
        public String NAME { get; set; }
        public String NAME_2 { get; set; }
        public String NAME_3 { get; set; }
        public String NAME_4 { get; set; }
        public String STREET { get; set; }
        public String COUNTRY { get; set; }
        public String COUNTR_ISO { get; set; }
        public String POSTL_CODE { get; set; }
        public String POBX_PCD { get; set; }
        public String POBX_CTY { get; set; }
        public String CITY { get; set; }
        public String DISTRICT { get; set; }
        public String REGION { get; set; }
        public String PO_BOX { get; set; }
        public String TELEPHONE { get; set; }
        public String TELEPHONE2 { get; set; }
        public String TELEBOX { get; set; }
        public String FAX_NUMBER { get; set; }
        public String TELETEX_NO { get; set; }
        public String TELEX_NO { get; set; }
        public String LANGU { get; set; }
        public String LANGU_ISO { get; set; }
        public String UNLOAD_PT { get; set; }
        public String TRANSPZONE { get; set; }
        public String TAXJURCODE { get; set; }
        public String ADDRESS { get; set; }
        public String PRIV_ADDR { get; set; }
        public String ADDR_TYPE { get; set; }
        public String ADDR_ORIG { get; set; }
        public String ADDR_LINK { get; set; }
        public String REFOBJTYPE { get; set; }
        public String REFOBJKEY { get; set; }
        public String REFLOGSYS { get; set; }
    }
    
    public class IT_BELGE    {
        public List<Item_1> item { get; set; } 
    }
    public class SALES_PARTNERS    {
        public List<Item_2> item { get; set; } 
    }
    public class requestModel{
        public IT_BELGE IT_BELGE { get; set; } 
        public SALES_PARTNERS SALES_PARTNERS { get; set; } 
    }

    public class responseModel{        
        @AuraEnabled
        public RC_SDSiparisBolmeJsonParser.ET_MESSAGE ET_MESSAGE {get;set;}  
        
    }
    
    public static responseModel ShipToAddress(requestModel req){
        try {
            responseModel resp = new responseModel();
            resp.ET_MESSAGE = new RC_SDSiparisBolmeJsonParser.ET_MESSAGE();
            
            String url = 'RESTAdapter/salesforce/sd_siparis_bolme';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('request:'+ request);
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){                
                RC_SDSiparisBolmeJsonParser parseResult = RC_SDSiparisBolmeJsonParser.parse(response.getBody());
                if(parseResult.ET_MESSAGE.item !=null && parseResult.ET_MESSAGE.item.size()>0){
                    resp.ET_MESSAGE.item = parseResult.ET_MESSAGE.item;
                }                
            }
            
            return resp;
            
        }
        catch(Exception e){
            system.debug('excp ShipToAddress :' + e);
            return null;
        }
    }    
}