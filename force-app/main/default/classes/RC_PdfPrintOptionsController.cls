public class RC_PdfPrintOptionsController {

    public static List<Quote> quote {get;set;}
    public static Quote quote2 {get;set;}
    public static List<Quote> quote3 {get;set;}
        
    public class initWrapper{
        @AuraEnabled
        public RC_PdfPrintOptionsController.ResponseWrapper responseWrp {get;set;}
    }
    
    public class ResponseWrapper
    {
        @AuraEnabled
        public boolean isShow {get;set;}
        @AuraEnabled
        public boolean activeVPO {get;set;}
         @AuraEnabled
        public boolean activeKamu {get;set;}
         @AuraEnabled
        public boolean activeOther {get;set;}
        @AuraEnabled
        public string canalName {get;set;}
        /*@AuraEnabled
        public string DeliveryTime {get;set;}
        @AuraEnabled
        public string RC_DeliveryTime {get;set;}
        @AuraEnabled
        public string WarrantyPeriod {get;set;}
        @AuraEnabled
        public string RC_Term {get;set;}*/
        
        @AuraEnabled
        public string ReturnValue {get;set;}
    }
    @AuraEnabled
    public static RC_PdfPrintOptionsController.ResponseWrapper getDataControl(string recordId)
    {
       ResponseWrapper cells =new ResponseWrapper();
       quote = [SELECT Delivery_time__c,RC_Delivery_time__c,RC_Warranty_Period__c,RC_Term__c FROM Quote WHERE id =: recordId];
        cells.isShow = false;
        cells.ReturnValue = '';
       
        if(quote.size() > 0)
        {
           
            if(quote.get(0).Delivery_time__c == null)
            {
                cells.isShow = true;
                cells.ReturnValue = 'Teslim Süresi (Gün/Hafta)'; 
            }
            if(quote.get(0).RC_Delivery_time__c == null)
            {
                cells.isShow = true;
                cells.ReturnValue += ' ,Teslim Süresi'; 
            }
            if(quote.get(0).RC_Warranty_Period__c == null)
            {
                cells.isShow = true;
                cells.ReturnValue += ' ,Garanti Süresi'; 
            }
            if(quote.get(0).RC_Term__c == null)
            {
                cells.isShow = true;
                cells.ReturnValue += ' ,Vade'; 
            }
        }
        return cells;
        
    }
    
    @AuraEnabled
  
    public static initWrapper initialize(string recordId){
        initWrapper initWrp = new initWrapper();
        
        initWrp.responseWrp = getDataControl(recordId);
        system.debug('responseWrp:' + initWrp.responseWrp);
        return initWrp;
        
    }
    
   @AuraEnabled
    public static RC_PdfPrintOptionsController.ResponseWrapper getCanalDataControl(string recordId)
    {
        ResponseWrapper cells =new ResponseWrapper();
         cells.activeVPO = false; 
         cells.activeKamu = false; 
         cells.activeOther = false; 
         cells.canalName = 'Nonvestel PDF';
      
              
        quote = [SELECT RC_VPO__c,RC_Quote_Sales_Org__c,toLabel(RC_Quote_Distribution_Channel__c) FROM Quote WHERE id =: recordId];
        quote3 = [SELECT RC_Quote_Distribution_Channel__c FROM Quote WHERE id =: recordId];
        
        if(quote.size() > 0)
        {
         
            
            if(quote3.get(0).RC_Quote_Distribution_Channel__c == '24')
            {
               cells.activeVPO = true; 
               cells.canalName = quote.get(0).RC_Quote_Distribution_Channel__c;
            }
            else if(quote3.get(0).RC_Quote_Distribution_Channel__c == '11')
            {
               cells.activeKamu = true;
                cells.canalName = quote.get(0).RC_Quote_Distribution_Channel__c;
            }
            else
            {
               cells.activeOther = true;
                cells.canalName = 'Nonvestel PDF';
            }
            
            if(!String.isEmpty(quote.get(0).RC_VPO__c))
            {
               cells.activeVPO = true; 
               cells.canalName = quote.get(0).RC_VPO__c;
               cells.activeOther = false;
            }
            return cells;
    	}
        return cells;
        
    }
		
    @AuraEnabled
    public static initWrapper getCanalData(string recordId){
        
         initWrapper initWrp = new initWrapper();
        
        initWrp.responseWrp = getCanalDataControl(recordId);
        system.debug('responseWrp:' + initWrp.responseWrp);
        return initWrp;
        
    }
    
    @AuraEnabled
    public static boolean savePdf(string recordId, string selectedPdf, string selectedPdfLanguage){
       
       // PageReference thePDF;
        if(selectedPdf == 'RV_VestelQuoteKamuPdf')
        {
           
            PageReference thePDF = Page.RV_VestelQuoteKamuPdfView;
             
            thePDF.getParameters().put('id',recordId);
            thePDF.setRedirect(true);
            
            Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : thePDF.getContentAsPDF(); 
            QuoteDocument qd = new QuoteDocument(quoteId = recordId, Document = content);
            
            insert qd;
        }
        else if(selectedPdf == 'RC_NonVestelQuotePdf')
        {
           
            PageReference thePDF = Page.RC_NonVestelQuotePdfView;
             
            thePDF.getParameters().put('id',recordId);
            thePDF.setRedirect(true);
            
            Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : thePDF.getContentAsPDF(); 
            QuoteDocument qd = new QuoteDocument(quoteId = recordId, Document = content);
            
            insert qd;
        }
        else if(selectedPdf == 'RC_VestelQuotePdf')
        {
           if(selectedPdfLanguage == 'TR')
           {
            PageReference thePDF = Page.RC_VestelQuotePdfView;
            thePDF.getParameters().put('id',recordId);
            thePDF.setRedirect(true);
            
            Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : thePDF.getContentAsPDF(); 
            QuoteDocument qd = new QuoteDocument(quoteId = recordId, Document = content);
            
            insert qd;
           }
           else
           {
            PageReference thePDF = Page.RC_VestelQuotePdfENGView;
            thePDF.getParameters().put('id',recordId);
            thePDF.setRedirect(true);
            
            Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : thePDF.getContentAsPDF(); 
            QuoteDocument qd = new QuoteDocument(quoteId = recordId, Document = content);
            
            insert qd;
           }
            
        }
          return true;
    }
    

}