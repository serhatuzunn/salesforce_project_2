public class RC_SD_GetPayedAmount {

    @AuraEnabled(cacheable = true)
    public static PayedAmountResponseModel CheckPayedAmount(List<String> sipNoList, String type){
        PayedAmountResponseModel response = null;
        try
        {
            PayedAmountRequestModel parm = new PayedAmountRequestModel();
            for(String data : sipNoList){
                parm.IT_ITEMS.item.add(new MainItemRequestModel(data, type));
            }
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:PoqaZorluAPI' + '/RESTAdapter/salesforce/sd_send_amount');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setTimeout(120000);
            req.setBody(JSON.serialize(parm, true));
            System.debug('Request : ' + req.getBody());
            
            HTTPResponse res = new Http().send(req);
            System.debug('Response : ' + res.getStatus());
            System.debug('Response : ' + res.getBody());
            
            if(String.isNotBlank(res.getBody()) && res.getBody().contains('ET_RESULTS')){
                response = (RC_SD_GetPayedAmount.PayedAmountResponseModel)JSON.deserialize(res.getBody(), RC_SD_GetPayedAmount.PayedAmountResponseModel.class);        
                System.debug('Response : ' + response);
            }            
        }
        catch(Exception ex)
        {
            System.debug('Exception : ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        return response;
    }
    
    public class PayedAmountRequestModel{
        public MainRequestModel IT_ITEMS {get; set;}
        public String IV_DETAY {get; set;}
        
        public PayedAmountRequestModel(){
            this.IT_ITEMS = new MainRequestModel();
            this.IV_DETAY = '';
        }
    }
    
    public class MainRequestModel {
        public List<MainItemRequestModel> item {get; set;}
        
        public MainRequestModel(){
            this.item = new List<MainItemRequestModel>();
        }
    }
    
    public class MainItemRequestModel{
        public String SIP_NO {get; set;}
        public String FAT_NO {get; set;}
        
        public MainItemRequestModel(String sn, String type){
            if(type == 'Siparis'){
                this.SIP_NO = sn;
            }
            else {
                this.FAT_NO = sn;
            }
        }
    }
    
    public class PayedAmountResponseModel{
        public MainResultModel ET_RESULTS {get; set;}
    }
    
    public class MainResultModel{
        public List<MainItemResultModel> item {get; set;}
    }
    
    public class MainItemResultModel{
        public String SIP_NO {get; set;}
        public String FAT_NO {get; set;}
        public String PROVN {get; set;}
        public String RTRFN {get; set;}
        public String TUTAR {get; set;}
        public Integer FAIZT {get; set;}
        public String WAERS {get; set;}
    }
}