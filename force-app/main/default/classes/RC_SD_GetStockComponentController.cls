public class RC_SD_GetStockComponentController {
    
    	
    public class InitWrapper{
        @AuraEnabled
        public InitResponseModel InitResponseModel { get; set; } 
        @AuraEnabled
        public StockWrapper StockWrapper { get; set; } 
        @AuraEnabled
        public MaterialInfoWrapper MaterialInfoWrapper { get; set; } 
    }
    
    public class StockWrapper{
        @AuraEnabled
        public StockResponseModel StockResponseModel { get; set; } 
    }
    
    public class StockResponseModel{
        @AuraEnabled
        public List<RC_SD_GetStockParser.Item> StockItemList { get; set; } 
    }
    
    
    
    public class MaterialInfoWrapper{
        @AuraEnabled
        public MaterialInfoResponseModel MaterialInfoResponseModel { get; set; } 
    }
    
    public class MaterialInfoResponseModel{
        @AuraEnabled
        public List<RC_GetStockMaterialInfoParser.Item> MaterialInfoItemList { get; set; } 
    }
    
    public class InitResponseModel{
        @AuraEnabled
        public List<InitItem> ProductionPlaceList { get; set; } 
        @AuraEnabled
        public List<InitItem> WarehousePlaceList { get; set; } 
        @AuraEnabled
        public List<InitPicklistItem> BrandList { get; set; } 
        @AuraEnabled
        public List<InitGoodsGroupItem> GoodsGroupList { get; set; } 
        @AuraEnabled
        public List<InitProductCodeItem> SelectedProductCodeList { get; set; } 

    }
    
    public class InitProductCodeItem{
        @AuraEnabled
        public String Value{ get; set; } 
    }
    public class InitSlidingAveragePriceRoleItem{
        @AuraEnabled
        public String Value{ get; set; } 
    }
    
    public class InitGoodsGroupItem{
        @AuraEnabled
        public String Name{ get; set; } 
        @AuraEnabled
        public String Value{ get; set; } 
        @AuraEnabled
        public String Selected{ get; set; } 
    }
    
    public class InitPicklistItem{
        @AuraEnabled
        public String Value{ get; set; } 
        @AuraEnabled
        public String ApiName{ get; set; }
        @AuraEnabled
        public string Selected {get;set;}
    }
    
    public class InitItem{
        @AuraEnabled
        public String Value{ get; set; } 
        @AuraEnabled
        public String ApiName{ get; set; }  
        @AuraEnabled
        public String ProductionPlace{ get; set; } 
    }
    
    public class SelectedWarehousePlace{
        @AuraEnabled
        public List<InitItem> WarehousePlaceList { get; set; } 
    }
    
    public class SasKalanWrapper{
        @AuraEnabled
        public RC_GetStockMaterialInfoParser.SASKALAN SaskalanBilgileri { get; set; } 
    }
    
    public class DagilimBilgileriWrapper{
        @AuraEnabled
        public RC_SD_GetStockParser.DAGILIM_BILGILERI DagilimBilgileri { get; set; } 
    }
    
    public class BlokeStokDetayWrapper{
        @AuraEnabled
        public RC_SD_GetStockParser.BLOKE_STOK_DETAY BlokeStokDetay { get; set; } 
    }
    public class VariantItems
    {
        @AuraEnabled
        public  RC_Stock_Variant__c variantData{get;set;}
        @AuraEnabled
        public  List<InitProductCodeItem> productList{get;set;}
        @AuraEnabled
        public  List<InitGoodsGroupItem> goodsGroupList{get;set;}
        @AuraEnabled
        public  List<InitPicklistItem> brandList{get;set;}
    } 
    
     @AuraEnabled
    public static boolean getSlidingAverageRole()
    {
       boolean textField = false;
         string usr = UserInfo.getUserId();

        string userRoleID = [Select u.UserRole.DeveloperName from User u Where u.Id=:usr LIMIT 1].UserRole.DeveloperName;
         List<KayarOrtalamaYetkileri__c> roleList = [SELECT Id, Role__c, RoleName__c FROM KayarOrtalamaYetkileri__c ORDER BY RoleName__c];
     
        for(KayarOrtalamaYetkileri__c role : roleList)
        {
            if(role.Role__c == userRoleID)
            {
            	textField = true;
            }
        }
        
        if(textField)
          return true;
        else
          return false;
       
    }
    

    
     @AuraEnabled
    public static List<RC_Definition__c> getProductionPlace(){
        
        List<RC_Definition__c> definitionProductionList = [SELECT Id, Name, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Production Place' ORDER BY RC_Value__c];
        return definitionProductionList;
    }
    
    @AuraEnabled
    public static InitWrapper initialize(List<String> productCodeList){
        system.debug('productCodeList : ' + productCodeList);
        
        
        List<RC_Definition__c> definitionWarehouseList = [SELECT Id, Name, Type__c, RC_Value__c, Production_Place_Txt__c FROM RC_Definition__c WHERE Type__c = 'Warehouse Place'];
        List<InitItem> warehousePlaceList = new List<InitItem>();
        for(RC_Definition__c definitionWarehouseItem : definitionWarehouseList){
            InitItem warehousePlaceItem = new InitItem();
            warehousePlaceItem.Value = definitionWarehouseItem.RC_Value__c+'|'+definitionWarehouseItem.Production_Place_Txt__c;
            warehousePlaceItem.ApiName = definitionWarehouseItem.Production_Place_Txt__c+' - '+definitionWarehouseItem.Name;
            warehousePlaceItem.ProductionPlace = definitionWarehouseItem.Production_Place_Txt__c;
            warehousePlaceList.add(warehousePlaceItem);
        }
        
        system.debug('warehousePlaceList : ' + warehousePlaceList);
        
        InitResponseModel initResponseModel = new InitResponseModel();
        initResponseModel.WarehousePlaceList = warehousePlaceList;
        
        //Brand
        List<InitPicklistItem> brandList = new List<InitPicklistItem>();
        
        Schema.DescribeFieldResult fieldResultForCompany = Opportunity.RC_Brand__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            InitPicklistItem brand = new InitPicklistItem();
            brand.Value = pickListVal.getValue();
            brand.ApiName = pickListVal.getLabel();
            brand.Selected = '';
            
            brandList.add(brand);
        }
        System.debug('brandList : ' + brandList);
        
        initResponseModel.BrandList = brandList;
        
       
        
        //GoodsGroup
        List<RC_Definition__c> goodsGroupList = [SELECT Name FROM RC_Definition__c WHERE Type__c = 'Material Group']; //TODO: İleride değiştirilecek
        
        List<InitGoodsGroupItem> goodsGroupItemList = new List<InitGoodsGroupItem>();
        for(RC_Definition__c goodsGroup : goodsGroupList){
            InitGoodsGroupItem goodsGroupItem = new InitGoodsGroupItem();
            goodsGroupItem.Name = goodsGroup.Name.substring(0, goodsGroup.Name.indexOf('-'));
            goodsGroupItem.Value = goodsGroup.Name;
            goodsGroupItem.Selected = '';
            
            goodsGroupItemList.add(goodsGroupItem);
        }
        system.debug('goodsGroupItemList : ' + goodsGroupItemList);
        
        initResponseModel.GoodsGroupList = goodsGroupItemList;
        
        
        InitWrapper initWrapper = new InitWrapper();
        initWrapper.InitResponseModel = initResponseModel;
        
        if(productCodeList != null && !productCodeList.isEmpty()){
            
            RC_SD_GetStockIntegrator.Item item = new RC_SD_GetStockIntegrator.Item();
            RC_SD_GetStockIntegrator.IT_INPUT itInput = new RC_SD_GetStockIntegrator.IT_INPUT();
            itInput.item = new List<RC_SD_GetStockIntegrator.Item>();
            
            for(String productCode : productCodeList){
                RC_SD_GetStockIntegrator.Item item_2 = new RC_SD_GetStockIntegrator.Item();
                item_2.MATNR = productCode; 
                item_2.WERKS = '2204';
                itInput.item.add(item_2);   
            }
            
            RC_SD_GetStockIntegrator.requestModel req = new RC_SD_GetStockIntegrator.requestModel();
            req.IT_INPUT = itInput;
            
            RC_SD_GetStockParser resultIntegrator = RC_SD_GetStockIntegrator.getSendStock(req);
            
            StockWrapper stockWrapper = new StockWrapper();
            if(resultIntegrator.ET_OUTPUT.item.size() > 0)
            {
                for(RC_SD_GetStockParser.Item resultitem : resultIntegrator.ET_OUTPUT.item)
                {
                    if(resultitem.MATNR.isNumeric())
                        resultitem.MATNR = String.valueOf(Integer.valueOf(resultitem.MATNR));   
                    
                }
                
                system.debug('resultIntegrator : ' + resultIntegrator);
                
                StockResponseModel stockResponseModel = new StockResponseModel();
                stockResponseModel.StockItemList =  resultIntegrator.ET_OUTPUT.item; 
                
                stockWrapper.stockResponseModel = stockResponseModel;
                
                system.debug('stockWrapper : ' + stockWrapper);
                
                initWrapper.StockWrapper = stockWrapper;
                
                //Selected product code
                List<InitProductCodeItem> selectedProductCodeList = new List<InitProductCodeItem>();
                for(String productCode : productCodeList){
                    InitProductCodeItem pCode = new InitProductCodeItem();
                    pCode.Value = productCode;
                    
                    selectedProductCodeList.add(pCode);
                }
                
                initResponseModel.SelectedProductCodeList = selectedProductCodeList;
            }
        }
        
        system.debug('initWrapper.initResponseModel.GoodsGroupList : ' + initWrapper.initResponseModel.GoodsGroupList);
        
        return initWrapper;
        
    }
    
    @AuraEnabled
    public static StockWrapper buttonClick(string[] uretimYeri, string[] depoYeri, string[] urunKodList, string[] markaList, string[] malGrubuList){ 
        
        system.debug('uretimYeri : ' + uretimYeri);
        system.debug('depoYeri : ' + depoYeri);
        system.debug('urunKodList : ' + urunKodList);
        system.debug('markaList : ' + markaList);
        system.debug('malGrubuList : ' + malGrubuList);
        
        RC_SD_GetStockIntegrator.Item item = new RC_SD_GetStockIntegrator.Item();
        RC_SD_GetStockIntegrator.IT_INPUT itInput = new RC_SD_GetStockIntegrator.IT_INPUT();
        itInput.item = new List<RC_SD_GetStockIntegrator.Item>();
        
        if (uretimYeri.size() == 0)   uretimYeri.add('');
        if (depoYeri.size() == 0)     depoYeri.add('');
        if (urunKodList.size() == 0)  urunKodList.add('');
        if (markaList.size() == 0)    markaList.add('');
        if (malGrubuList.size() == 0) malGrubuList.add('');
       
        
        string itemUretimYeri,itemDepoyeri,itemUrunkod,itemMarkaList,itemMalGrubu = '';
        
        for (string itemUy : uretimYeri)
        {
            itemUretimYeri = itemUy;
            
            for (string itemDy : depoYeri)
            {
                itemDepoYeri = itemDy;
                
                for (string itemUl : urunKodList)
                {
                    itemUrunkod = itemUl;
                    
                    for (string itemMl : markaList)
                    {
                        itemMarkaList = itemMl;
                        
                        for (string itemMg : malGrubuList)
                        {
                            itemMalGrubu = itemMg;
                            
                            RC_SD_GetStockIntegrator.Item item_2 = new RC_SD_GetStockIntegrator.Item();
                            if(itemUrunkod != null)  item_2.MATNR = itemUrunkod; 
                            if(itemUretimYeri != null)  item_2.WERKS = itemUretimYeri; 
                            if(itemDepoYeri != null)  item_2.LGORT = itemDepoYeri.substringBefore('|'); 
                            if(itemMarkaList != null)  item_2.ZZMARKA = itemMarkaList; 
                            if(itemMalGrubu != null)  item_2.KONDM = itemMalGrubu; 
                            
                            
                            itInput.item.add(item_2);   
                        }
                    }
                }
            }
        }
        
        system.debug('itInput : ' + itInput);
        
        RC_SD_GetStockIntegrator.requestModel req = new RC_SD_GetStockIntegrator.requestModel();
        req.IT_INPUT = itInput;
        
        RC_SD_GetStockParser resultIntegrator = RC_SD_GetStockIntegrator.getSendStock(req);
        
        StockWrapper stockWrapper = new StockWrapper();
        if(resultIntegrator.ET_OUTPUT.item.size() > 0)
        {
            for(RC_SD_GetStockParser.Item resultitem : resultIntegrator.ET_OUTPUT.item)
            {
                if(resultitem.MATNR.isNumeric())
                    resultitem.MATNR = String.valueOf(Integer.valueOf(resultitem.MATNR));   
                
            }
            
            system.debug('resultIntegrator : ' + resultIntegrator);
            
            StockResponseModel stockResponseModel = new StockResponseModel();
            stockResponseModel.StockItemList =  resultIntegrator.ET_OUTPUT.item; 
            
            stockWrapper.stockResponseModel = stockResponseModel;
            
            system.debug('stockWrapper : ' + stockWrapper);
            
        }
        
        return stockWrapper;
    }  
    
    
    @AuraEnabled
    public static MaterialInfoWrapper materialInfo(string MATNR){ 
        
        system.debug('material matnr : ' + MATNR);
        system.debug('burda : ' + MATNR);
        
        Integer toplamSasKalan = 0;
        
        RC_GetStockMaterialInfoIntegrator.requestModel req = new RC_GetStockMaterialInfoIntegrator.requestModel();
        if(MATNR != null ) req.I_MATNR = MATNR;
        
        
        RC_GetStockMaterialInfoParser resultIntegrator = RC_GetStockMaterialInfoIntegrator.getSendStock(req);
        
        MaterialInfoWrapper MaterialInfoWrapper = new MaterialInfoWrapper();
        
        if(resultIntegrator != null)
        {
            if(resultIntegrator.ET_MATNR_LIST.item.size() > 0)
            {
                
                for(RC_GetStockMaterialInfoParser.Item resultitem : resultIntegrator.ET_MATNR_LIST.item)
                {
                    if(resultitem.MATNR.isNumeric())
                        resultitem.MATNR = String.valueOf(Integer.valueOf(resultitem.MATNR)); 
                    
                    if(resultitem.SASKALAN.item.size() > 0)
                    {
                        toplamSasKalan = 0;
                        for(RC_GetStockMaterialInfoParser.ItemDagitim resultitem2 : resultitem.SASKALAN.item)
                        { 
                            
                            if(resultitem2.MENGE != '')
                            {
                                
                            	toplamSasKalan += Integer.valueOf(resultitem2.MENGE);
                             
                            }
                            
                        }
                        resultitem.SASKALANMIKTAR = String.valueOf(toplamSasKalan);
                    }     
                          
                }
             
                
                
                system.debug('Material ResultIntegrator : ' + resultIntegrator);
                
                MaterialInfoResponseModel MaterialResponseModel = new MaterialInfoResponseModel();
                MaterialResponseModel.MaterialInfoItemList =  resultIntegrator.ET_MATNR_LIST.item; 
                
                MaterialInfoWrapper.MaterialInfoResponseModel = MaterialResponseModel;
                
                system.debug('MaterialInfoWrapper : ' + MaterialInfoWrapper);
                
            }
        }
        
        return MaterialInfoWrapper;
    }
    @AuraEnabled
    public static boolean CreateVariant(string[] uretimYeri, string[] depoYeri, string[] urunKodList, string[] markaList, string[] malGrubuList, string variantName)
    {
        system.debug('uretimYeri:' + uretimYeri);
        system.debug('depoYeri:' + depoYeri);
        system.debug('urunKodList:' + urunKodList);
        system.debug('markaList:' + markaList);
        system.debug('malGrubuList:' + malGrubuList);
        
        RC_Stock_Variant__c stockVariant = new RC_Stock_Variant__c();
        
        stockVariant.RC_IsActive__c 				  = true;
        stockVariant.OwnerId                          = userInfo.getUserId();
        stockVariant.Name 							  = variantName;
        stockVariant.RC_Brand_Variant__c              = string.join(markaList,',');
        stockVariant.RC_Goods_Group_Variant__c        = string.join(malGrubuList,',');
        stockVariant.RC_Warehouse_Location_Variant__c = string.join(depoYeri,',');
        stockVariant.RC_Production_Place_Variant__c   = string.join(uretimYeri,',');
        stockVariant.RC_Product_Variant__c            = string.join(urunKodList,',');
        stockVariant.RC_Varyant_Type__c            =  '1';
        
        Database.SaveResult sr = Database.insert(stockVariant);
        
        if(sr.isSuccess())
            return true;
        else
            return false;
        
    }
    @AuraEnabled
    public static List<RC_Stock_Variant__c> GetVariantList()
    {
        Id userId = userInfo.getUserId();
        List<RC_Stock_Variant__c> stockVariantList = [Select Id,Name From RC_Stock_Variant__c Where RC_Varyant_Type__c = '1' AND OwnerId =: userId];
        if(stockVariantList!=null) return stockVariantList;
        else return null;
    }
    @AuraEnabled
    public static boolean DeleteVariantItem(string variantId)
    {
        RC_Stock_Variant__c variantData = [Select Id,Name From RC_Stock_Variant__c Where Id=:variantId];
        Database.DeleteResult dr = Database.delete(variantData.Id);
        if(dr.isSuccess()) return true;
        else return false;
    }
    
    @AuraEnabled
    public static VariantItems GetVariantItem(string variantId)
    {
        VariantItems variants = new VariantItems();
        
        RC_Stock_Variant__c variantData = [Select Id,Name,RC_Product_Variant__c,RC_Production_Place_Variant__c,RC_Warehouse_Location_Variant__c,RC_Goods_Group_Variant__c,RC_Brand_Variant__c From RC_Stock_Variant__c Where RC_Varyant_Type__c = '1' AND Id=:variantId];
        
        
        List<InitPicklistItem> brandList = new List<InitPicklistItem>();
        
        if(string.isNotBlank(variantData.RC_Brand_Variant__c))
        {
            Set<String> brandSet = new Set<string>();
            brandSet.addAll(variantData.RC_Brand_Variant__c.split(','));
            
            Schema.DescribeFieldResult fieldResultForCompany = Opportunity.RC_Brand__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
            for(Schema.PicklistEntry pickListVal : ple){
                InitPicklistItem brand = new InitPicklistItem();
                brand.Value = pickListVal.getValue();
                brand.ApiName = pickListVal.getLabel();
                brand.Selected = brandSet.contains(pickListVal.getValue()) ? 'selected' : '' ;
                brandList.add(brand);
            }
        }
        
        List<RC_Definition__c> goodsGroupList = [SELECT Name,RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Material Group']; //TODO: İleride değiştirilecek
        
        List<InitGoodsGroupItem> goodsGroupItemList = new List<InitGoodsGroupItem>();
        
        if(string.isNotBlank(variantData.RC_Goods_Group_Variant__c))
        {
            Set<String> goodsGroupSet = new Set<string>();
            goodsGroupSet.addAll(variantData.RC_Goods_Group_Variant__c.remove(' ').split(','));
            system.debug('goodsGroupSet:' + goodsGroupSet);
            for(RC_Definition__c goodsGroup : goodsGroupList){
                InitGoodsGroupItem goodsGroupItem = new InitGoodsGroupItem();
                goodsGroupItem.Name = goodsGroup.RC_Value__c;
                goodsGroupItem.Value = goodsGroup.Name;
                goodsGroupItem.Selected = goodsGroupSet.contains(goodsGroup.RC_Value__c) ? 'selected' : '' ;
                
                goodsGroupItemList.add(goodsGroupItem);
            }
        }
        
        
        List<InitProductCodeItem> selectedProductCodeList = new List<InitProductCodeItem>();
        
        if(string.isNotBlank(variantData.RC_Product_Variant__c))
        {
            Set<String> productSet = new Set<string>();
            productSet.addAll(variantData.RC_Product_Variant__c.remove(' ').split(','));
            for(String productCode : productSet){
                InitProductCodeItem pCode = new InitProductCodeItem();
                pCode.Value = productCode;
                
                selectedProductCodeList.add(pCode);
            }
        }
        
        variants.productList =selectedProductCodeList;
        variants.goodsGroupList = goodsGroupItemList;
        variants.brandList = brandList;
        variants.variantData  = variantData;
        
        return variants;
    }
    
}