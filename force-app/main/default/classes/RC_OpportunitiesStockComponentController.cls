public class RC_OpportunitiesStockComponentController {
    
    public class ProductCodeWrapper{
        @AuraEnabled
        public List<String> ProductCodeList { get; set; } 
    }

    @AuraEnabled
    public static ProductCodeWrapper initialize(String recordId){
        system.debug('opportunityId : ' + recordId);
        
        List<OpportunityLineItem> OpportunityLineItemList =  [SELECT ProductCode FROM OpportunityLineItem WHERE OpportunityId =: recordId];
        system.debug('OpportunityLineItemList : ' + OpportunityLineItemList);
        
        List<String> productCodeList = new List<String>();
        for(OpportunityLineItem opportunityLineItem : OpportunityLineItemList){
            productCodeList.add(opportunityLineItem.ProductCode);
        }
        
        ProductCodeWrapper productCodeWrapper = new ProductCodeWrapper();
        productCodeWrapper.ProductCodeList = productCodeList;
        
        return productCodeWrapper;
    }
    
}