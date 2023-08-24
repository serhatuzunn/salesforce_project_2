public class RC_IptalIadeConfirmOrderIntegrator {

public class Item{
    public string VBELN_VA { get; set; }
}

public class IT_HEADER    {
    public List<Item> item { get; set; }
}

public IT_HEADER IT_HEADER { get; set; }



public class requestModel   {   
    public IT_HEADER IT_HEADER { get; set; }
}

public class responseModel{
@AuraEnabled
public RC_IptalIadeConfirmOrderParser.ET_ERROR_VBELN ET_ERROR_VBELN {get;set;}
public RC_IptalIadeConfirmOrderParser.ET_MESSAGE ET_MESSAGE {get;set;}
public string Success {get;set;}
} 

public static responseModel getIptalIadeConfirmOrder(requestModel req){

try {
    
    
    responseModel resp = new responseModel();
    resp.ET_ERROR_VBELN = new RC_IptalIadeConfirmOrderParser.ET_ERROR_VBELN();
    resp.ET_MESSAGE = new RC_IptalIadeConfirmOrderParser.ET_MESSAGE();
    resp.Success = '';

    String url = 'RESTAdapter/salesforce/sd_iade_confirm_order';
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
        RC_IptalIadeConfirmOrderParser parseResult = RC_IptalIadeConfirmOrderParser.parse(response.getBody());   
                resp.ET_ERROR_VBELN = parseResult.ET_ERROR_VBELN;        
                resp.ET_MESSAGE = parseResult.ET_MESSAGE;  
                resp.Success = parseResult.EV_SUCCESS;     

    }
    else
    {
        system.debug('Get Confirm Order Result error : ' + response.getBody());     
    }
    
    
    return resp;
}

catch(Exception e){
        system.debug('RC_IptalIadeConfirmOrderIntegrator Error : ' + e.getMessage());    
    RC_Logger.LOG_EXCEPTION('RC_IptalIadeConfirmOrderIntegrator  Error', e.getMessage(), e.getStackTraceString(), 'RC_IptalIadeConfirmOrderIntegrator', 'finish', '');
    return null;
}
}
}