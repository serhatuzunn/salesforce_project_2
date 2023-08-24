public class RC_Rnbx_ProductComponentController {
    
    public class InitWrapper{
        @AuraEnabled
        public List<RC_Definition__c> definitionHierarcy1List {get;set;}
        @AuraEnabled
        public List<RC_Definition__c> definitionHierarcy2List {get;set;}
        @AuraEnabled
        public List<RC_Definition__c> definitionHierarcy3List {get;set;}
        
    }
    
    public class ProductResponse{
        @AuraEnabled
        public List<Product2> ProductList {get;set;}
    }
    
    public class HiyObject{
        @AuraEnabled
        public String hiy1 {get;set;}
        @AuraEnabled
        public String hiy2 {get;set;}
        @AuraEnabled
        public String hiy3 {get;set;}
    }
    
    @AuraEnabled
    public static InitWrapper initialize(){
        
        
        List<RC_Definition__c> defHierarcy1List = [SELECT Id, Name, RC_Value__c, RC_Upper_Hierarchy__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 1];
        List<RC_Definition__c> defHierarcy2List = [SELECT Id, Name, RC_Value__c, RC_Upper_Hierarchy__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 2];
        List<RC_Definition__c> defHierarcy3List = [SELECT Id, Name, RC_Value__c, RC_Upper_Hierarchy__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 3];
        
        InitWrapper initWrp = new InitWrapper();
        initWrp.definitionHierarcy1List = defHierarcy1List;
        initWrp.definitionHierarcy2List = defHierarcy2List;
        initWrp.definitionHierarcy3List = defHierarcy3List;
        
        system.debug('initWrp : ' + initWrp);
        
        return initWrp;
    }
    
    @AuraEnabled
    public static ProductResponse GetProducts(String hiyObjectJson){
        system.debug('hiyObjectJson : ' + hiyObjectJson);
        RC_Rnbx_ProductComponentController.HiyObject hiyObject = (RC_Rnbx_ProductComponentController.HiyObject)JSON.deserialize(hiyObjectJson, RC_Rnbx_ProductComponentController.HiyObject.class);
        
        system.debug('hiyObject : ' + hiyObject);
        
        system.debug('hiy1 : ' + hiyObject.hiy1);
        system.debug('hiy2 : ' + hiyObject.hiy2);
        system.debug('hiy3 : ' + hiyObject.hiy3);
        
        String hiy1Text = hiyObject.hiy1+'-%';
        String hiy2Text = hiyObject.hiy2+'-%';
        String hiy3Text = hiyObject.hiy3+'-%';
        
        List<RC_Definition__c> defHiy1List = [SELECT Id FROM RC_Definition__c WHERE RC_Hierarchy_Level__c =: 1 AND Name LIKE: hiy1Text];
        List<RC_Definition__c> defHiy2List = [SELECT Id FROM RC_Definition__c WHERE RC_Hierarchy_Level__c =: 2 AND Name LIKE: hiy2Text];
        List<RC_Definition__c> defHiy3List = [SELECT Id FROM RC_Definition__c WHERE RC_Hierarchy_Level__c =: 3 AND Name LIKE: hiy3Text];
        
        system.debug('defHiy1List : ' + defHiy1List);
        system.debug('defHiy2List : ' + defHiy2List);
        system.debug('defHiy3List : ' + defHiy3List);
        
        
        Set<String> hiyDef1IdSet = new Set<String>();
        for(RC_Definition__c def : defHiy1List){
            hiyDef1IdSet.add(def.Id);
        }
        
        Set<String> hiyDef2IdSet = new Set<String>();
        for(RC_Definition__c def : defHiy2List){
            hiyDef2IdSet.add(def.Id);
        }
        
        Set<String> hiyDef3IdSet = new Set<String>();
        for(RC_Definition__c def : defHiy3List){
            hiyDef3IdSet.add(def.Id);
        }
        
        system.debug('hiyDef1IdSet : ' + hiyDef1IdSet);
        system.debug('hiyDef2IdSet : ' + hiyDef2IdSet);
        system.debug('hiyDef3IdSet : ' + hiyDef3IdSet);
        
        List<Product2> productList = [SELECT Id, Name, RC_Image_URL__c, RC_External_System_ProductID__c
                                      FROM Product2 
                                      WHERE RC_Product_hie_Level_1__c IN: hiyDef1IdSet AND RC_Product_hie_Level_2__c IN: hiyDef2IdSet AND RC_Product_hie_Level_3__c IN: hiyDef3IdSet AND RC_VP_Brand__c = 'VST'];
        
        system.debug('productList : ' + productList);
        
        ProductResponse productResponse = new ProductResponse();
        
        if(productList != null && productList.size()>0){
            productResponse.productList = productList;
        }
        
        system.debug('productResponse : ' + productResponse);
        return productResponse;
        
    }
    
    @AuraEnabled
    public static String GetShareUrl(String externalSystemProductId){
        List<Product2> productList = [SELECT Id, Name, DisplayUrl FROM Product2 WHERE RC_External_System_ProductID__c =: externalSystemProductId LIMIT 1];
        system.debug('productList : ' + productList);
        if(productList != null && productList.size() > 0){
            if(productList.get(0).DisplayUrl == null){
                
                RC_Rnbx_ProductIntegrator.ResponseModel responseModel = RC_Rnbx_ProductIntegrator.getProduct(externalSystemProductId);{}
                if(responseModel != null){
                    
                    productList.get(0).DisplayUrl = responseModel.productIntegratorParser.Result.ShareUrl;
                    update productList.get(0);              
                }
                
            }
            
            system.debug('productList.get(0).DisplayUrl : ' + productList.get(0).DisplayUrl);
            return productList.get(0).DisplayUrl;
            
        }
        return null;
    }
}