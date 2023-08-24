public class RC_IptalIadeReturnOrderCreateIntegrator {
     public class IS_HEADER
     {
         public string REF_SIP_NO { get; set; }
         public string NEW_VKORG { get; set; }
         public string NEW_VTWEG { get; set; }
         public string NEW_SPART { get; set; }
         public string NEW_AUART { get; set; }
         public string NEW_USAGE { get; set; }
         public string NEW_BSTKD { get; set; }
         public string LIFSP { get; set; }
         public string NEW_VSART { get; set; }
         public string SIMULATION { get; set; }
         public string NEW_FAT_KUNNR { get; set; }
     }
     public class Item
     {
         public string REF_POSNR { get; set; }
         public string NEW_MENGE { get; set; }
         public string NEW_WERKS { get; set; }
         public string NEW_LGORT { get; set; }
         public string REF_FATURA { get; set; }
         public string REF_FAT_KALEM { get; set; }
     }

     public class Item2
     {
         public string TYPE { get; set; }
         public string ID { get; set; }        
         public string MESSAGE { get; set; }
         public string LOG_NO { get; set; }
         public string LOG_MSG_NO { get; set; }
         public string MESSAGE_V1 { get; set; }
         public string MESSAGE_V2 { get; set; }
         public string MESSAGE_V3 { get; set; }
         public string MESSAGE_V4 { get; set; }
         public string PARAMETER { get; set; }
         public Integer ROW { get; set; }
         public string FIELD { get; set; }        
         public string PARTN_ROLE { get; set; }
         public string PARTN_NUMB { get; set; }
         public string ITM_NUMBER { get; set; }
         public string TITLE { get; set; }
         public string NAME { get; set; }
         public string NAME_2 { get; set; }
         public string NAME_3 { get; set; }
         public string NAME_4 { get; set; }
         public string STREET { get; set; }
         public string COUNTRY { get; set; }
         public string COUNTR_ISO { get; set; }
         public string POSTL_CODE { get; set; }
         public string POBX_PCD { get; set; }
         public string POBX_CTY { get; set; }
         public string CITY { get; set; }
         public string DISTRICT { get; set; }
         public string REGION { get; set; }
         public string PO_BOX { get; set; }
         public string TELEPHONE { get; set; }
         public string TELEPHONE2 { get; set; }
         public string TELEBOX { get; set; }
         public string FAX_NUMBER { get; set; }
         public string TELETEX_NO { get; set; }
         public string TELEX_NO { get; set; }
         public string LANGU { get; set; }
         public string LANGU_ISO { get; set; }
         public string UNLOAD_PT { get; set; }
         public string TRANSPZONE { get; set; }
         public string TAXJURCODE { get; set; }
         public string ADDRESS { get; set; }
         public string PRIV_ADDR { get; set; }
         public string ADDR_TYPE { get; set; }
         public string ADDR_ORIG { get; set; }
         public string ADDR_LINK { get; set; }
         public string REFOBJTYPE { get; set; }
         public string REFOBJKEY { get; set; }
         public string REFLOGSYS { get; set; }
     }

     public class IT_ITEM
     {
         public List<Item> item { get; set; }
     }
     public class ET_SALES_PARTNERS
     {
         public List<Item2> item { get; set; }
     } 
    
     public IS_HEADER IS_HEADER { get; set; }
     public IT_ITEM IT_ITEM { get; set; }
     public ET_SALES_PARTNERS ET_SALES_PARTNERS { get; set; }           

     public class requestModel   {   
     public IS_HEADER IS_HEADER { get; set; }
     public IT_ITEM IT_ITEM { get; set; }
     public ET_SALES_PARTNERS ET_SALES_PARTNERS{get; set;}
}

public class responseModel{
    @AuraEnabled
    public RC_IptalIadeReturnOrderCreateParser.ET_MESSAGE ET_MESSAGE {get;set;}
    public string EV_DELIVERYDOCUMENT {get;set;}
    public string EV_SALESDOCUMENT {get;set;}
    public string EV_SUCCESS {get;set;}
    public RC_IptalIadeReturnOrderCreateParser.ET_SALES_PARTNERS ET_SALES_PARTNERS {get;set;}
} 

public static responseModel getIptalIadeReturnOrderCreate(requestModel req){

    try {
        responseModel resp = new responseModel();
        resp.ET_MESSAGE = new RC_IptalIadeReturnOrderCreateParser.ET_MESSAGE();
        resp.EV_DELIVERYDOCUMENT = '';
        resp.EV_SALESDOCUMENT = '';
        resp.EV_SUCCESS = '';
        resp.ET_SALES_PARTNERS = new RC_IptalIadeReturnOrderCreateParser.ET_SALES_PARTNERS();


        String url = 'RESTAdapter/salesforce/sd_iade_return_order_create';
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
            RC_IptalIadeReturnOrderCreateParser parseResult = RC_IptalIadeReturnOrderCreateParser.parse(response.getBody());   
            system.debug(response.getBody());
            resp.ET_MESSAGE = parseResult.ET_MESSAGE;        
            resp.ET_SALES_PARTNERS = parseResult.ET_SALES_PARTNERS;    
            resp.EV_DELIVERYDOCUMENT = parseResult.EV_DELIVERYDOCUMENT;     
            resp.EV_SALESDOCUMENT = parseResult.EV_SALESDOCUMENT;     
            resp.EV_SUCCESS = parseResult.EV_SUCCESS;   
        }
        else
        {
            system.debug('Return Order Create Result error : ' + response.getBody());     
        }
        
        
        return resp;
    }
    catch(Exception e){
            system.debug('RC_IptalIadeReturnOrderCreateIntegrator Error : ' + e.getMessage());    
        RC_Logger.LOG_EXCEPTION('RC_IptalIadeReturnOrderCreateIntegrator  Error', e.getMessage(), e.getStackTraceString(), 'RC_IptalIadeReturnOrderCreateIntegrator', 'finish', '');
        return null;
        }   
    }

}