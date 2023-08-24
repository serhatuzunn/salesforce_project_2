public class RC_UploadExcelLabelController {
    
    public class excelModelWrapper{
        @AuraEnabled
        public string urunkodu {get;set;}
        @AuraEnabled
        public string baslik {get;set;}
        @AuraEnabled
        public string aciklama {get;set;}
        @AuraEnabled
        public string uretimyeri {get;set;}
        
    }
    
    public class ResultWrapper{
        @AuraEnabled
        public List<excelModelWrapper> excelData{get;set;}
        @AuraEnabled
        public string ErrorMsg{get;set;}
        @AuraEnabled
        public boolean State{get;set;}
        
    }
    
    @AuraEnabled
    public static ResultWrapper getExcelData(String base64String) {
        ResultWrapper result=new ResultWrapper();
        system.debug('base64: '+base64String);
        result.excelData=new List<excelModelWrapper>();
        RC_UploadLabelIntegrator.ResultWrapper resultWrp = new  RC_UploadLabelIntegrator.ResultWrapper();
        
        resultWrp = RC_UploadLabelIntegrator.getFormattedData(base64String);
        system.debug('resultWrp:' + resultWrp);
        if(!string.isNotBlank(resultWrp.ErrorMessage)){
            for(integer i=0 ; i<resultWrp.uploadStockList.size() ; i++){
                excelModelWrapper excelRow=new excelModelWrapper();
                
                
                if(resultWrp.uploadStockList[i].urunkodu != null && resultWrp.uploadStockList[i].urunkodu != ''){
                    excelRow.urunkodu 		= resultWrp.uploadStockList[i].urunkodu.deleteWhitespace().SubStringBefore('.');
                }else{
                    excelRow.urunkodu = '';
                }
                
                
                if(resultWrp.uploadStockList[i].baslik != null && resultWrp.uploadStockList[i].baslik != ''){
                    excelRow.baslik   = resultWrp.uploadStockList[i].baslik;
                }else{
                    excelRow.baslik = '';
                }
                
                
                if(resultWrp.uploadStockList[i].aciklama != null && resultWrp.uploadStockList[i].aciklama != ''){                    
                    excelRow.aciklama		= resultWrp.uploadStockList[i].aciklama;                    
                }else{
                    excelRow.aciklama = '';
                }
                
                if(resultWrp.uploadStockList[i].uretimyeri != null && resultWrp.uploadStockList[i].uretimyeri != ''){                    
                    excelRow.uretimyeri		= resultWrp.uploadStockList[i].uretimyeri.SubStringBefore('.');                    
                }else{
                    excelRow.uretimyeri = '';
                }
                
                result.excelData.Add(excelRow);
            }
            result.State = true;
            
            insertProdData(result);
            
        }else{
            result.ErrorMsg=resultWrp.ErrorMessage;
            result.State = false;
        }
        
        return result;
    }
    
    
    public static void insertProdData(ResultWrapper rw){
        
        boolean isSuccess=false;
        List<RC_Label__c> recsToBeInserted = new List<RC_Label__c>();
        Map<string, string> prdMap = new Map<string, string>();
        set<string> prdSet = new set<string>();
        for (RC_UploadExcelLabelController.excelModelWrapper v : rw.excelData) {            
            prdSet.Add(v.urunkodu);
        }
        Product2[] prdList= [SELECT Id, ProductCode FROM Product2 Where ProductCode =:prdSet]; 
        system.debug('prd : ' +prdList);
        for(Product2 pr :prdList)
        {
            prdMap.put(pr.ProductCode,pr.Id);
        }

        for (RC_UploadExcelLabelController.excelModelWrapper v : rw.excelData) {            
            
            RC_Label__c lblObj= new RC_Label__c();
            
            system.debug('v.urunkodu : ' +v.urunkodu);
            
            try{              
                
                
                if(prdMap.containsKey(v.urunkodu)){
                    lblObj.RC_Product__c= prdMap.get(v.urunkodu);                   
                }else{
                    system.debug('accountId else: ');
                    continue;
                }
                
                
                lblObj.RC_Header__c=v.baslik;            
                lblObj.RC_Description__c = v.aciklama;            
                lblObj.RC_Manufacture_Place__c= v.uretimyeri;
                lblObj.ProductCode__c = v.urunkodu;
            }
            catch(Exception ex){
                system.debug('Exception : ' +ex);
            }
            
            recsToBeInserted.add(lblObj);
        }
        
        try{            
            Schema.SObjectField productCode = RC_Label__c.Fields.ProductCode__c;
            database.upsert(recsToBeInserted,productCode,true);
            isSuccess = true;
        }
        catch(Exception ex){
            system.debug('insertExcelData Exception: ' +ex);
        }
        
        
        return;
        
    }
    
}