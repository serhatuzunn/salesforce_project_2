public class RC_IptalIadeGetOrdersIntegrator{            
    
    public class Item_1    {
        public String AUART { get; set; }          
    }
    
    public class Item_2    {      
        public String AUGRU { get; set; }     
    }public class Item_3    {           
        public String BUKRS { get; set; }         
        
    }public class Item_4    {       
        public String KUNNR { get; set; }                
    }public class Item_5    {                 
        public String MATKL { get; set; }                 
    }public class Item_6   {                
        public String MATNR { get; set; }                 
    }public class Item_7    {          
        public String VBELN_VA { get; set; }                
    }public class Item_8    {               
        public String VBELN_VF { get; set; }                 
    }public class Item_9    {              
        public String VBELN_VL { get; set; } 
    }public class Item_10   {           
        public String VKBUR { get; set; }  
    }public class Item_11    {
        
        public String VKGRP { get; set; } 
    }public class Item_12    {
        
        public String VKORG { get; set; }
    }public class Item_13    {
        
        public String VTWEG { get; set; } 
    }
    
    public class IT_AUART    {
        public List<Item_1> item { get; set; } 
    }
    
    public class IT_AUGRU    {
        public List<Item_2> item { get; set; } 
    }
    
    public class IT_BUKRS    {
        public List<Item_3> item { get; set; } 
    }
    
    public class IT_KUNNR    {
        public List<Item_4> item { get; set; } 
    }
    
    public class IT_MATKL    {
        public List<Item_5> item { get; set; } 
    }
    
    public class IT_MATNR    {
        public List<Item_6> item { get; set; } 
    }
    
    public class IT_VBELN_VA    {
        public List<Item_7> item { get; set; } 
    }
    
    public class IT_VBELN_VF    {
        public List<Item_8> item { get; set; } 
    }
    
    public class IT_VBELNVL    {
        public List<Item_9> item { get; set; } 
    }
    
    public class IT_VKBUR    {
        public List<Item_10> item { get; set; } 
    }
    
    public class IT_VKGRP    {
        public List<Item_11> item { get; set; } 
    }
    
    public class IT_VKORG    {
        public List<Item_12> item { get; set; } 
    }
    
    public class IT_VTWEG    {
        public List<Item_13> item { get; set; } 
    }
    
    public class requestModel   {
        public IT_AUART IT_AUART { get; set; } 
        public IT_AUGRU IT_AUGRU { get; set; } 
        public IT_BUKRS IT_BUKRS { get; set; } 
        public IT_KUNNR IT_KUNNR { get; set; } 
        public IT_MATKL IT_MATKL { get; set; } 
        public IT_MATNR IT_MATNR { get; set; } 
        public IT_VBELN_VA IT_VBELN_VA { get; set; } 
        public IT_VBELN_VF IT_VBELN_VF { get; set; } 
        public IT_VBELNVL IT_VBELN_VL { get; set; } 
        public IT_VKBUR IT_VKBUR { get; set; } 
        public IT_VKGRP IT_VKGRP { get; set; } 
        public IT_VKORG IT_VKORG { get; set; } 
        public IT_VTWEG IT_VTWEG { get; set; } 
        public String IV_AUDAT_F  { get; set; } 
        public String IV_AUDAT_S  { get; set; } 
        public String IV_EMANET  { get; set; } 
        public String IV_FKDAT_F  { get; set; } 
        public String IV_FKDAT_S  { get; set; } 
        
    }
    
    public class responseModel{
        @AuraEnabled
        public RC_IptalIadeGetOrdersParser.ET_RESULT Result {get;set;}
        public RC_IptalIadeGetOrdersParser.ET_MESSAGE Message {get;set;}
    }   
    
    public static responseModel getIptalIade(requestModel req){
        
        try {
            
            
            responseModel resp = new responseModel();
            resp.Result = new RC_IptalIadeGetOrdersParser.ET_RESULT();
            resp.Message = new RC_IptalIadeGetOrdersParser.ET_MESSAGE();
            
            String url = 'RESTAdapter/salesforce/sd_iade_open_order_list';
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
                    RC_IptalIadeGetOrdersParser parseResult = RC_IptalIadeGetOrdersParser.parse(response.getBody());   
                    resp.Result = parseResult.ET_RESULT;        
                    resp.Message = parseResult.ET_MESSAGE;            
                }
                else{ system.debug('Get Delivery Result error : ' + response.getBody()); }
            
            return resp;
        }
        
        catch(Exception e){
            system.debug('RC_SD_DeliveryIntegrator Error : ' + e.getMessage());    
            RC_Logger.LOG_EXCEPTION('RC_SD_DeliveryIntegrator  Error', e.getMessage(), e.getStackTraceString(), 'RC_BayiRiskIntegrator', 'finish', '');
            return null;
        }
    }
}