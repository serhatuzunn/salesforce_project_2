public class RC_AnaVeriProductBatchable implements Database.Stateful,Database.Batchable<RC_AnaVeriIntegratorParser.Item>,Database.AllowsCallouts {
    
    public RC_AnaVeriIntegrator.RequestModel requestBody {get;set;}
    public Integer TOTAL {get;set;}
    public Integer INDEX {get;set;}
    public Integer PACKAGE_SIZE {get;set;}
    
    List<RC_Definition__c> definitionHierarcy1List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 1];
    List<RC_Definition__c> definitionHierarcy2List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 2];
    List<RC_Definition__c> definitionHierarcy3List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 3];
    List<RC_Definition__c> definitionHierarcy4List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 4];
    List<RC_Definition__c> definitionHierarcy5List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 5];
    List<RC_Definition__c> definitionHierarcy6List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 6];
    List<RC_Definition__c> definitionHierarcy7List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 7];
    List<RC_Definition__c> definitionHierarcy8List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 8];
    List<RC_Definition__c> definitionHierarcy9List = [SELECT Id, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Product Hierarchy' AND RC_Hierarchy_Level__c = 9];
    
    
    
    Integer limitCount = Limits.getQueries();
    
    
    public RC_AnaVeriProductBatchable(RC_AnaVeriIntegrator.RequestModel req){     
        this.PACKAGE_SIZE   = Integer.valueOf(req.IV_PACKAGE);
        this.INDEX 			= Integer.valueOf(req.IV_INDEX);
        this.requestBody    = req;
        
        system.debug('limit count : ' + limitCount);
    }
    
    public Iterable<RC_AnaVeriIntegratorParser.Item> start(Database.BatchableContext BC){
        
        RC_AnaVeriIntegratorParser result = RC_AnaVeriIntegrator.getAnaVeri(this.requestBody);
        
        this.TOTAL = result.EV_TOTAL_IND;
        
        return result.ET_RETURN.item;
    }
    
    public void execute(Database.BatchableContext info , List<RC_AnaVeriIntegratorParser.Item> itemList){
        
        system.debug('itemList: ' + itemList);
        
        Map<String, String> definitionHierarcy1Map = new Map<String, String>();
        Map<String, String> definitionHierarcy2Map = new Map<String, String>();
        Map<String, String> definitionHierarcy3Map = new Map<String, String>();
        Map<String, String> definitionHierarcy4Map = new Map<String, String>();
        Map<String, String> definitionHierarcy5Map = new Map<String, String>();
        Map<String, String> definitionHierarcy6Map = new Map<String, String>();
        Map<String, String> definitionHierarcy7Map = new Map<String, String>();
        Map<String, String> definitionHierarcy8Map = new Map<String, String>();
        Map<String, String> definitionHierarcy9Map = new Map<String, String>();
        
        for(RC_Definition__c definition1 : definitionHierarcy1List){
            definitionHierarcy1Map.put(definition1.RC_Value__c, definition1.Id);
        }
        
        for(RC_Definition__c definition2 : definitionHierarcy2List){
            definitionHierarcy2Map.put(definition2.RC_Value__c, definition2.Id);
        }
        
        for(RC_Definition__c definition3 : definitionHierarcy3List){
            definitionHierarcy3Map.put(definition3.RC_Value__c, definition3.Id);
        }
        
        for(RC_Definition__c definition4 : definitionHierarcy4List){
            definitionHierarcy4Map.put(definition4.RC_Value__c, definition4.Id);
        }
        
        for(RC_Definition__c definition5 : definitionHierarcy5List){
            definitionHierarcy5Map.put(definition5.RC_Value__c, definition5.Id);
        }
        
        for(RC_Definition__c definition6 : definitionHierarcy6List){
            definitionHierarcy6Map.put(definition6.RC_Value__c, definition6.Id);
        }
        
        for(RC_Definition__c definition7 : definitionHierarcy7List){
            definitionHierarcy7Map.put(definition7.RC_Value__c, definition7.Id);
        }
        
        for(RC_Definition__c definition8 : definitionHierarcy8List){
            definitionHierarcy8Map.put(definition8.RC_Value__c, definition8.Id);
        }
        
        for(RC_Definition__c definition9 : definitionHierarcy9List){
            definitionHierarcy9Map.put(definition9.RC_Value__c, definition9.Id);
        }
        
        List<Product2> productList = new List<Product2>();
        
        for(RC_AnaVeriIntegratorParser.Item item : itemList){
            Product2 product = new Product2();
            product.IsActive = true;
            if(item.MATNR.isNumeric()){
                product.ProductCode = String.valueOf(Integer.valueOf(item.MATNR));
            }
            else{
                product.ProductCode = item.MATNR;
            }
            product.Description = item.MAKTX;
            product.RC_Product_Hierarchy__c = item.PRDHA;
            
            product.RC_Product_hie_Level_1__c = definitionHierarcy1Map.get(item.KADEME1);
            product.RC_Product_hie_Level_2__c = definitionHierarcy2Map.get(item.KADEME2);
            product.RC_Product_hie_Level_3__c = definitionHierarcy3Map.get(item.KADEME3);
            product.RC_Product_hie_Level_4__c = definitionHierarcy4Map.get(item.KADEME4);
            product.RC_Product_hie_Level_5__c = definitionHierarcy5Map.get(item.KADEME5);
            product.RC_Product_hie_Level_6__c = definitionHierarcy6Map.get(item.KADEME6);
            product.RC_Product_hie_Level_7__c = definitionHierarcy7Map.get(item.KADEME7);
            product.RC_Product_hie_Level_8__c = definitionHierarcy8Map.get(item.KADEME8);
            product.RC_Product_hie_Level_9__c = definitionHierarcy9Map.get(item.KADEME9);
            
            product.Name = item.MAKTX;
            product.RC_EAN_UPC_Code__c = item.EAN11;
            product.RC_EAN_Type__c = item.NUMTP;
            product.RC_VP_Brand__c = item.ZZMARKA;
            product.RC_Material_Group_2__c = item.MVGR2;
            product.RC_Sliding_Average_Price__c = Decimal.valueOf(item.VERPR);
            if(item.MATNR.isNumeric()){
                product.RC_External_ID__c = String.valueOf(Integer.valueOf(item.MATNR));
            }
            else{
                product.RC_External_ID__c = item.MATNR;
            }
            productList.add(product);
            
        }   
        
        List<Database.UpsertResult> resultList = Database.upsert(productList, Product2.RC_External_ID__c, true);
        
        for (Database.UpsertResult rl : resultList) {
            if (rl.isSuccess()) {
                System.debug('Successfully id : ' + rl.getId());
            }
            else {              
                for(Database.Error err : rl.getErrors()) {               
                    System.debug('Error : ' + err.getStatusCode() + ': ' + err.getMessage() + ' : ' + err.getFields());
                }
            }
        }     
    }
    
    public void finish(Database.BatchableContext info){
        List<AsyncApexJob> statusList = [SELECT Status FROM AsyncApexJob where id =:info.getJobId()];
        if(statusList.size() > 0){
            AsyncApexJob status = statusList.get(0); 
            if(status.Status == 'Completed'){
                this.INDEX = this.INDEX + this.PACKAGE_SIZE;
                
                if(this.INDEX <= this.TOTAL){
                    RC_AnaVeriIntegrator.RequestModel req = new RC_AnaVeriIntegrator.RequestModel();
                    req.IV_TANIM = '';
                    req.IV_VKORG = this.requestBody.IV_VKORG;
                    req.IV_VTWEG = this.requestBody.IV_VTWEG;
                    req.IV_PACKAGE = String.valueOf(this.PACKAGE_SIZE);
                    req.IV_INDEX = String.valueOf(this.INDEX);
                    
                    RC_AnaVeriProductBatchable batch = new RC_AnaVeriProductBatchable(req);
                    Database.executeBatch(batch,this.PACKAGE_SIZE);
                }
                else{
                    DateTime nowDate = datetime.now().addHours(-3);
                    List<Product2> updateIsActiveProductList = [SELECT Id, LastModifiedDate FROM Product2 WHERE LastModifiedDate <: nowDate];
                    system.debug('updateIsActiveProductList : ' + updateIsActiveProductList);
                    for(Product2 p : updateIsActiveProductList){
                        p.IsActive = false;
                    }
                    update updateIsActiveProductList;                  
                }
            }
        }
    }
    
}