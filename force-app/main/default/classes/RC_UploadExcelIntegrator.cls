public with sharing class RC_UploadExcelIntegrator {
    public class ResultWrapper{
        @AuraEnabled
        public List<RC_UploadExcelIntegratorParser> uploadExcelList {get;set;}
        @AuraEnabled
        public string ErrorMessage{get;set;}
    }

    @AuraEnabled
    public static ResultWrapper  getFormattedData (string excelFormattedBase64){
        system.debug('excelFormattedBase64 :' + excelFormattedBase64);
        ResultWrapper result= new ResultWrapper();

        string dataBody = '\"'+excelFormattedBase64+'\"';
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setEndpoint('callout:Excel_Upload_Service');
        req.setBody(dataBody);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');

        if(!test.isRunningTest()){
            HttpResponse response = http.send(req);
            
            system.debug('response ::' + response.getBody());   
            
            string message = checkField(response.getBody());
                        
            if(string.isNotBlank(message))
             message += 'kolon isimleri şablon ile uyumlu değildir. Lütfen kontrol edip tekrar yükleyiniz.';
            
            List<RC_UploadExcelIntegratorParser> parseResult = RC_UploadExcelIntegratorParser.parse(response.getBody());
            system.debug('parseResult 11:' + parseResult);
            result.uploadExcelList = parseResult;
            result.ErrorMessage=message;
        }else{
            string ErrorMessage='';
            string testResponse = '[{"cek_no":"8872018.0","vade_tarihi":"2019-12-12T00:00:00","tutar":"7415.0","tckn_vergi_no":"3927937932.0","banka_anahtari":"0001-00001","banka_hesap_no":"34343.0","kesideci_bolge":""}]';
             

            string message = checkField(testResponse);
            

            List<RC_UploadExcelIntegratorParser> parseResult = RC_UploadExcelIntegratorParser.parse(testResponse);
            result.uploadExcelList = parseResult;
            result.ErrorMessage=message;
        }
        
        return result;
    }

    public static string checkField(string responseBody){
        string ErrorMessage='';
            string jsonInput =responseBody;
            
            Set<String> fieldSet = new Set<String>{
                'cek_no',
                'vade_tarihi',
                'tutar',
                'tckn_vergi_no',   
                'banka_anahtari',  
                'banka_hesap_no',  
                'kesideci_bolge'
            };
                        
            List<Object> jsonData = (List<Object>)JSON.deserializeUntyped(jsonInput);
            
            for (Object obj : jsonData) {
                system.debug('obj :' + obj);
                Map<String, Object> tempObj = (Map<String, Object>)obj;
                system.debug('tempObj :' + tempObj);
                system.debug('tempObj.keySet() :' + tempObj.keySet());
                for (string key : tempObj.keySet()){
                    
                    if(fieldSet.contains(key) == false){
                        ErrorMessage += key + ' ' ;
                    }
                }
                break;
            }
		return ErrorMessage;
    }
}