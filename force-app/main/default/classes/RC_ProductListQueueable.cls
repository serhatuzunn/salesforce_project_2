public with sharing class RC_ProductListQueueable implements Finalizer, Queueable, Database.AllowsCallouts {
    
    Set<Integer> categorySet{get; set;}
    Set<Integer> processCategorySet{get; set;}
    
    List<Product2> productUpdateList {get; set;}
    Map<Id, Product2> productMap {get; set;}
    public RC_ProductListQueueable(){        
        productUpdateList = new List<Product2>(); 
        productMap = new Map<Id, Product2>();
    }
    
    public RC_ProductListQueueable(Set<Integer> cs) {
        
        Set<Integer> itemList = new Set<Integer>();
        
        if(cs.size() > 5){
            Integer count = 1;
            for(Integer categoryId : cs){
                itemList.add(categoryId);
                cs.remove(categoryId);
                if(count == 5) break;
                else count++;
            }
            this.processCategorySet = itemList;
            this.categorySet = cs;
        }
        else{
            this.categorySet = null;
            this.processCategorySet = cs;
        }
        
    }
    
    public void execute(QueueableContext qc){
        RC_ProductListQueueable f = new RC_ProductListQueueable();
        System.attachFinalizer(f);
        System.debug('Process Category : ' + processCategorySet);
        for (Integer categoryId : processCategorySet) {
            RC_ProductListIntegrator.ResponseModel productListResponseModel = RC_ProductListIntegrator.getProductList(String.valueOf(categoryId), String.valueOf(1));
            
            if(productListResponseModel.ProductListResponse.Success){
                system.debug('productListResponseModel.ProductListResponse.Result.TotalPageCount : ' + productListResponseModel.ProductListResponse.Result.TotalPageCount);
                
                for(Integer i=1; i<=productListResponseModel.ProductListResponse.Result.TotalPageCount; i++){
                    RC_ProductListIntegrator.ResponseModel productListItemResponseModel = RC_ProductListIntegrator.getProductList(String.valueOf(categoryId), String.valueOf(i));
                    if(productListItemResponseModel.ProductListResponse.Result.ProductList != null && productListItemResponseModel.ProductListResponse.Result.ProductList.size() > 0){
                        for(RC_ProductListIntegratorParser.ProductList productItem : productListItemResponseModel.ProductListResponse.Result.ProductList){
                            if(!String.isBlank(productItem.FirstProductImageURL) && !String.isBlank(productItem.ExternalSystemCode)){
                                List<Product2> productList = [SELECT Id, RC_Image_URL__c FROM Product2 WHERE IsActive = true AND ProductCode =: productItem.ExternalSystemCode LIMIT 1];
                                if(productList != null && productList.size() > 0){
                                    productList.get(0).RC_Image_URL__c = productItem.FirstProductImageURL;
                                    productList.get(0).RC_External_System_ProductID__c = productItem.Id;
                                    system.debug('categoryId : ' + categoryId);
                                    system.debug('productItem.ExternalSystemCode : ' + productItem.ExternalSystemCode);
                                    f.addProductToList(productList.get(0));
                                }
                            }
                        }
                    }
                    System.debug('SOQL Limit : ' + Limits.getQueries());
                }
                
            }
            else{
                system.debug('HATA : ' + productListResponseModel.ProductListResponse);
            }
        }
        
        
        
        if(this.categorySet != null && this.categorySet.size() > 0){
            RC_ProductListQueueable queueable = new RC_ProductListQueueable(this.categorySet);
            System.enqueueJob(queueable);
        }
    }
    
    public void execute(FinalizerContext ctx) {
        for(Product2 productItem : this.productUpdateList){
            system.debug('productItem : ' + productItem);
        }
        system.debug('Product Update List : ' + this.productMap.values());
        
        if(Test.isRunningTest()) {
            Product2 p = new Product2();
            p.Name = 'Test';
            this.productMap.put('01t4K000000b1NEQAY', p);
        }
        
        Database.SaveResult [] updateResult = Database.update(this.productMap.values(), false);   
        List<RC_Logger__c> updateLoggerList = new List<RC_Logger__c>();
        for (Database.SaveResult sr : updateResult)            
        {
            if(sr.isSuccess()){
                System.debug(sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()) {
                    System.debug('error: ' + err.getFields());
                    
                    RC_Logger__c rcLogger = new RC_Logger__c();
                    rcLogger.RC_Message__c = 'Error: RC_ProductListQueueable';
                    rcLogger.RC_Message_Detail__c = 'update Error';
                    rcLogger.RC_StackTrace__c = err.getMessage();
                    rcLogger.RC_LogLevel__c = 'EXCEPTION';
                    rcLogger.CreateDate__c = DateTime.now();
                    rcLogger.RC_ClassName__c = 'RC_ProductListQueueable';
                    rcLogger.RC_FunctionName__c = 'execute';
                    rcLogger.RC_ComponentName__c = '';      
                    
                    updateLoggerList.add(rcLogger);
                }
                
            }
        }
        insert updateLoggerList;
        
    }    
    
    public void addProductToList(Product2 item){
        this.productUpdateList.add(item);
        
        if(this.productMap.containsKey(item.Id)){
            system.debug('Duplicate Val : ' + item);
        }
        else{
            this.productMap.put(item.Id, item);
        }
    }
}