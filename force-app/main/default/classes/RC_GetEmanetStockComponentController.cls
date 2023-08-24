public class RC_GetEmanetStockComponentController {
 
    
     public class StockWrapper{
        @AuraEnabled
        public StockResponseModel StockResponseModel { get; set; } 
    }
    
    public class StockResponseModel{
        @AuraEnabled
        public List<RC_EmanetStokIntegratorParser.Item_Z> StockItemList { get; set; } 
    }
    
    
     public class OpenStockWrapper{
        @AuraEnabled
        public OpenStockResponseModel OpenStockResponseModel { get; set; } 
    }
    
    public class OpenStockResponseModel{
        @AuraEnabled
        public List<RC_GetOpenStockParser.Item> OpenStockItemList { get; set; } 
    }
 
    
   public class InitProductCodeItem{
        @AuraEnabled
        public String Value{ get; set; } 
    }
    
    public class InitWrapper{
        @AuraEnabled
        public InitResponseModel InitResponseModel { get; set; } 
    }
    
    public class InitResponseModel{
        @AuraEnabled
        public List<InitItem> ProductionPlaceList { get; set; } 
        @AuraEnabled
        public List<InitPicklistItem> SalesOrganizationList {get;set;}
             @AuraEnabled
        public List<InitPicklistItem> DistributionChannelList {get;set;}
             @AuraEnabled
        public List<InitPicklistItem> SalesDirectorateList {get;set;}
             @AuraEnabled
        public List<InitPicklistItem> RegionalDirectorateList {get;set;}
   
    }

    public class InitItem{
        @AuraEnabled
        public String Value{ get; set; } 
        @AuraEnabled
        public String ApiName{ get; set; }  
    }
    
        public class InitPicklistItem{
        @AuraEnabled
        public String Value{ get; set; } 
        @AuraEnabled
        public String ApiName{ get; set; }
        @AuraEnabled
        public string Selected {get;set;}
    }
    
    public class VariantItems
    {
        @AuraEnabled
        public  RC_Stock_Variant__c variantData{get;set;}
        @AuraEnabled
        public  List<InitProductCodeItem> productList{get;set;}
        @AuraEnabled
        public  List<InitPicklistItem> DagitimKanali{get;set;}
          @AuraEnabled
        public  List<InitPicklistItem> satisBurosu{get;set;}
          @AuraEnabled
        public  List<InitPicklistItem> satisGrubu{get;set;}
          @AuraEnabled
        public  List<InitPicklistItem> satisOrganizasyonu{get;set;}
    } 

    
  
    
    
    
    @AuraEnabled
    public static List<RC_Definition__c> getProductionPlace(){
        
        List<RC_Definition__c> definitionProductionList = [SELECT Id, Name, RC_Value__c FROM RC_Definition__c WHERE Type__c = 'Production Place' and RC_Value__c in ('9205','9306','9323','9334','9335','9338')];
        return definitionProductionList;
    }
    
    @AuraEnabled
    public static InitWrapper initialize(){
        
         InitResponseModel initResponseModel = new InitResponseModel();
                
        /* Sales Organization */
       /* RC_Sales_Organization */
        List<InitPicklistItem> salesOrganizations = new List<InitPicklistItem>();
        
        Schema.DescribeFieldResult fieldResultForCompany = RC_SD_Organization__c.RC_Sales_Organization__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            InitPicklistItem salesOrg = new InitPicklistItem();
            salesOrg.Value = pickListVal.getValue();
            salesOrg.ApiName = pickListVal.getLabel();
            salesOrg.Selected = '';
            
            salesOrganizations.add(salesOrg);
        }
        System.debug('salesOrganizations : ' + salesOrganizations);
        initResponseModel.SalesOrganizationList = salesOrganizations;

     
        
        /* Distribution Channel */
        /* RC_Distribution_Channel */
        List<InitPicklistItem> distributionChannelList = new List<InitPicklistItem>();
        
        Schema.DescribeFieldResult fieldResultForCompany2 = RC_SD_Organization__c.Distribution_Channel__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResultForCompany2.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple2){
            InitPicklistItem distOrg = new InitPicklistItem();
            distOrg.Value = pickListVal.getValue();
            distOrg.ApiName = pickListVal.getLabel();
            distOrg.Selected = '';
            
            distributionChannelList.add(distOrg);
        }
        System.debug('distributionChannelList : ' + distributionChannelList);
        initResponseModel.DistributionChannelList = distributionChannelList;
        
        
        
        /* Sales Directorate */
        /* RC_Sales_Directorate */
        List<InitPicklistItem> salesDirectorates = new List<InitPicklistItem>();
        
        Schema.DescribeFieldResult fieldResultForCompany3 = RC_SD_Organization__c.Sales_Directorate__c.getDescribe();
        List<Schema.PicklistEntry> ple3 = fieldResultForCompany3.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple3){
            InitPicklistItem salesOrg2 = new InitPicklistItem();
            salesOrg2.Value = pickListVal.getValue();
            salesOrg2.ApiName = pickListVal.getLabel();
            salesOrg2.Selected = '';
            
            salesDirectorates.add(salesOrg2);
        }
        System.debug('salesDirectorates : ' + salesDirectorates);
        initResponseModel.SalesDirectorateList = salesDirectorates;
        
        
        
        /* Regional Directorate */
  		/* RC_Regional_Directorate */
        List<InitPicklistItem> regionalDirectorates = new List<InitPicklistItem>();
        
        Schema.DescribeFieldResult fieldResultForCompany4 =  RC_SD_Organization__c.RC_Regional_Directorate__c.getDescribe();
        List<Schema.PicklistEntry> ple4 = fieldResultForCompany4.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple4){
            InitPicklistItem salesOrg3 = new InitPicklistItem();
            salesOrg3.Value = pickListVal.getValue();
            salesOrg3.ApiName = pickListVal.getLabel();
            salesOrg3.Selected = '';
            
            regionalDirectorates.add(salesOrg3);
        }
        System.debug('regionalDirectorates : ' + regionalDirectorates);
        initResponseModel.RegionalDirectorateList = regionalDirectorates;
        
                  
        InitWrapper initWrapper = new InitWrapper();
        initWrapper.InitResponseModel = initResponseModel;
        
        

      
        return initWrapper;
    }
    
    @AuraEnabled
    public static StockWrapper buttonClick(string IT_MATNR,string IV_KUNNR,string[] IT_WERKS ){
        
                StockWrapper stockWrapper = new StockWrapper();
			    system.debug('IT_MATNR : ' + IT_MATNR);
                system.debug('IV_KUNNR : ' + IV_KUNNR);
       			
                
       			RC_EmanetStokIntegrator.Item item = new RC_EmanetStokIntegrator.Item(); 
        		RC_EmanetStokIntegrator.IT_INPUT itInput = new RC_EmanetStokIntegrator.IT_INPUT();
                itInput.item = new List<RC_EmanetStokIntegrator.Item>();
               
                if(String.isNotBlank(IT_MATNR))
      		    {	
                   	item.MATNR = IT_MATNR;
                    itInput.item.add(item); 
         	    }
                else
                {
                   item.MATNR= ''; 
                }
   			           
        
         		    
			    RC_EmanetStokIntegrator.IT_INPUT_W itInput_W = new RC_EmanetStokIntegrator.IT_INPUT_W();
        	    itInput_W.item = new List<RC_EmanetStokIntegrator.Item_W>();
                    
                if(IT_WERKS.size() > 0)
                {
                    for(string werks: IT_WERKS)
                    {
                        if(werks != null)
                        {
                           RC_EmanetStokIntegrator.Item_W item_2 = new RC_EmanetStokIntegrator.Item_W();
                           item_2.WERKS = werks;
                           itInput_W.item.add(item_2);   
                        }
                	}
                }
    
        
        
                RC_EmanetStokIntegrator.requestModel req = new RC_EmanetStokIntegrator.requestModel();
        		if(itInput.item.size()>0)
                req.IT_MATNR = itInput;
				req.IT_WERKS = itInput_W;
                req.IV_YALNIZCA_STOKLU = 'X';
                req.IV_SOBKZ = 'W';
                req.IV_KUNNR = IV_KUNNR;
         		

                RC_EmanetStokIntegratorParser resultIntegrator = RC_EmanetStokIntegrator.getEmanetStok(req);
	
                if(resultIntegrator.ET_OUTPUT.item != null && resultIntegrator.ET_OUTPUT.item.size() > 0)
                {
                      for(RC_EmanetStokIntegratorParser.Item_Z resultitem : resultIntegrator.ET_OUTPUT.item)
                      {
                          if(resultitem.MATNR != null)
                          {
                             if(resultitem.MATNR.isNumeric())
                             resultitem.MATNR = String.valueOf(Integer.valueOf(resultitem.MATNR));
                          }
                          
                          if(resultitem.KUNNR != null)
                          {
                             if(resultitem.KUNNR.isNumeric())
                             resultitem.KUNNR = String.valueOf(Integer.valueOf(resultitem.KUNNR));
                          }
                      } 
                      
                   
                       
                      system.debug('resultIntegrator : ' + resultIntegrator);
                      StockResponseModel stockResponseModel = new StockResponseModel();
                      StockResponseModel.StockItemList =  resultIntegrator.ET_OUTPUT.item;
					  stockWrapper.stockResponseModel = stockResponseModel;
                      system.debug('stockWrapper : ' + stockWrapper);
                }
                return stockWrapper;
    }  
     @AuraEnabled
    public static OpenStockWrapper OpenStockButtonClick(string IT_MATNR,string IV_KUNNR,string IV_VSTEL,string[] IV_VKBUR,string[] IV_VKGRP,string[] IV_VKORG,string[] IV_VTWEG ){
        
                OpenStockWrapper openstockWrapper = new OpenStockWrapper();
			    system.debug('IT_MATNR : ' + IT_MATNR);
                system.debug('IV_KUNNR : ' + IV_KUNNR);
       			system.debug('IV_VSTEL : ' + IV_VSTEL);
      		    system.debug('IV_VKBUR : ' + IV_VKBUR);
                system.debug('IV_VKGRP : ' + IV_VKGRP);
       			system.debug('IV_VKORG : ' + IV_VKORG);
       		    system.debug('IV_VTWEG : ' + IV_VTWEG);
       
       			RC_GetOpenStockIntegrator.Item item = new RC_GetOpenStockIntegrator.Item(); 
        		RC_GetOpenStockIntegrator.IT_INPUT itInput = new RC_GetOpenStockIntegrator.IT_INPUT();
                itInput.item = new List<RC_GetOpenStockIntegrator.Item>();

                   	item.VSTEL = IV_VSTEL;
                    item.MATNR = IT_MATNR;
                    item.KUNNR = IV_KUNNR;
        
        
        if (IV_VKBUR.size() == 0)   IV_VKBUR.add('');
        if (IV_VKGRP.size() == 0)     IV_VKGRP.add('');
        if (IV_VKORG.size() == 0)  IV_VKORG.add('');
        if (IV_VTWEG.size() == 0)    IV_VTWEG.add('');
   
       
        
        string itemIV_VKBUR,itemIV_VKGRP,itemIV_VKORG,itemIV_VTWEG = '';
        
        for (string itemUy : IV_VKBUR)
        {
            itemIV_VKBUR = itemUy;
            
            for (string itemDy : IV_VKGRP)
            {
                itemIV_VKGRP = itemDy;
                
                for (string itemUl : IV_VKORG)
                {
                    itemIV_VKORG = itemUl;
                    
                    for (string itemMl : IV_VTWEG)
                    {
                        itemIV_VTWEG = itemMl;
                        
                            if(itemIV_VKBUR != null)  item.VKBUR = itemIV_VKBUR; 
                            if(itemIV_VKGRP != null)  item.VKGRP = itemIV_VKGRP; 
                            if(itemIV_VKORG != null)  item.VKORG = itemIV_VKORG; 
                            if(itemIV_VTWEG != null)  item.VTWEG = itemIV_VTWEG; 
                            itInput.item.add(item); 
                        
                    }
                }
            }
        }
        
        
            
        
        
                
         	           
 
                RC_GetOpenStockIntegrator.requestModel req = new RC_GetOpenStockIntegrator.requestModel();
        		if(itInput.item.size()>0)
                req.IT_INPUT = itInput;
				

                RC_GetOpenStockParser resultIntegrator = RC_GetOpenStockIntegrator.getSendOpenStock(req);
	
                if(resultIntegrator.ET_OUTPUT.item != null && resultIntegrator.ET_OUTPUT.item.size() > 0)
                {
                      for(RC_GetOpenStockParser.Item resultitem : resultIntegrator.ET_OUTPUT.item)
                      {
                          if(resultitem.VBELN != null)
                          {
                             if(resultitem.VBELN.isNumeric())
                             resultitem.VBELN = String.valueOf(Integer.valueOf(resultitem.VBELN));
                          }
                          
                          if(resultitem.KUNNR != null)
                          {
                             if(resultitem.KUNNR.isNumeric())
                             resultitem.KUNNR = String.valueOf(Integer.valueOf(resultitem.KUNNR));
                          }
                          
                          if(resultitem.MATNR != null)
                          {
                             if(resultitem.MATNR.isNumeric())
                             resultitem.MATNR = String.valueOf(Integer.valueOf(resultitem.MATNR));
                          }
                      } 
                      
                   
                       
                       system.debug('open stock resultIntegrator : ' + resultIntegrator);
                      OpenStockResponseModel openstockResponseModel = new OpenStockResponseModel();
                      OpenStockResponseModel.OpenStockItemList =  resultIntegrator.ET_OUTPUT.item;
					  openstockWrapper.OpenStockResponseModel = openstockResponseModel;
                      system.debug('openstockWrapper : ' + openstockWrapper);
                }
                return openstockWrapper;
    }  

   
    @AuraEnabled
    public static boolean CreateVariant(string[] IT_MATNR,string[] IV_KUNNR, string[] IT_WERKS,string[] IV_VKBUR,string[] IV_VKGRP,string[] IV_VKORG,string[] IV_VTWEG, string variantName)
    {
        system.debug('IT_MATNR:' + IT_MATNR);
        system.debug('IV_KUNNR:' + IV_KUNNR);

        system.debug('IV_VKBUR:' + IV_VKBUR);
        system.debug('IV_VKGRP:' + IV_VKGRP);
        system.debug('IV_VKORG:' + IV_VKORG);
    	system.debug('IV_VTWEG:' + IV_VTWEG);
        system.debug('variantName:' + variantName);
        
        RC_Stock_Variant__c stockVariant = new RC_Stock_Variant__c();
        
        stockVariant.RC_IsActive__c 			     = true;
        stockVariant.OwnerId                         = userInfo.getUserId();
        stockVariant.Name 					         = variantName;
        stockVariant.RC_Varyant_Type__c              = '2';
      
        stockVariant.RC_Customer_Variant__c          = string.join(IV_KUNNR,',');
        stockVariant.RC_Production_Place_Variant__c  = string.join(IT_WERKS,',');
        stockVariant.RC_Product_Variant__c           = string.join(IT_MATNR,',');
        
        stockVariant.RC_Sales_Office__c              = string.join(IV_VKBUR,',');
        stockVariant.RC_Sales_Group__c               = string.join(IV_VKGRP,',');
        stockVariant.RC_Distribution_Channel__c      = string.join(IV_VTWEG,',');
        stockVariant.RC_Sales_Organization__c        = string.join(IV_VKORG,',');
       
        
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
        List<RC_Stock_Variant__c> stockVariantList = [Select Id,Name From RC_Stock_Variant__c Where RC_Varyant_Type__c = '2' AND OwnerId =: userId];
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
        
        RC_Stock_Variant__c variantData = [Select Id,Name,RC_Product_Variant__c,RC_Production_Place_Variant__c,RC_Warehouse_Location_Variant__c,RC_Customer_Variant__c,RC_Sales_Office__c,RC_Sales_Group__c,RC_Distribution_Channel__c,RC_Sales_Organization__c From RC_Stock_Variant__c Where Id=:variantId AND RC_Varyant_Type__c='2'];
        

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
        
        
        List<InitPicklistItem> salesOrganizationList = new List<InitPicklistItem>();
        
        if(string.isNotBlank(variantData.RC_Sales_Organization__c))
        {
            Set<String> salesOrg = new Set<string>();
            salesOrg.addAll(variantData.RC_Sales_Organization__c.split(','));
            
            Schema.DescribeFieldResult fieldResultForCompany = RC_SD_Organization__c.RC_Sales_Organization__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
            for(Schema.PicklistEntry pickListVal : ple){
                InitPicklistItem salesOrganization = new InitPicklistItem();
                salesOrganization.Value = pickListVal.getValue();
                salesOrganization.ApiName = pickListVal.getLabel();
                salesOrganization.Selected = salesOrg.contains(pickListVal.getValue()) ? 'selected' : '' ;
                salesOrganizationList.add(salesOrganization);
            }
        }
        
        List<InitPicklistItem> salesOfficeList = new List<InitPicklistItem>();
        
        if(string.isNotBlank(variantData.RC_Sales_Office__c))
        {
            Set<String> salessOff = new Set<string>();
            salessOff.addAll(variantData.RC_Sales_Office__c.split(','));
            
            Schema.DescribeFieldResult fieldResultForCompany = RC_SD_Organization__c.Sales_Directorate__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
            for(Schema.PicklistEntry pickListVal : ple){
                InitPicklistItem salesOff = new InitPicklistItem();
                salesOff.Value = pickListVal.getValue();
                salesOff.ApiName = pickListVal.getLabel();
                salesOff.Selected = salessOff.contains(pickListVal.getValue()) ? 'selected' : '' ;
                salesOfficeList.add(salesOff);
            }
        }
        
        
        List<InitPicklistItem> salesGroupList = new List<InitPicklistItem>();
        
        if(string.isNotBlank(variantData.RC_Sales_Group__c))
        {
            Set<String> salessGroup = new Set<string>();
            salessGroup.addAll(variantData.RC_Sales_Group__c.split(','));
            
            Schema.DescribeFieldResult fieldResultForCompany =  RC_SD_Organization__c.RC_Regional_Directorate__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
            for(Schema.PicklistEntry pickListVal : ple){
                InitPicklistItem salesGroup = new InitPicklistItem();
                salesGroup.Value = pickListVal.getValue();
                salesGroup.ApiName = pickListVal.getLabel();
                salesGroup.Selected = salessGroup.contains(pickListVal.getValue()) ? 'selected' : '' ;
                salesGroupList.add(salesGroup);
            }
        }
        
        List<InitPicklistItem> distributionChannelList = new List<InitPicklistItem>();
        
        if(string.isNotBlank(variantData.RC_Distribution_Channel__c))
        {
            Set<String> distC = new Set<string>();
            distC.addAll(variantData.RC_Distribution_Channel__c.split(','));
            
            Schema.DescribeFieldResult fieldResultForCompany =  RC_SD_Organization__c.Distribution_Channel__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
            for(Schema.PicklistEntry pickListVal : ple){
                InitPicklistItem distChannel = new InitPicklistItem();
                distChannel.Value = pickListVal.getValue();
                distChannel.ApiName = pickListVal.getLabel();
                distChannel.Selected = distC.contains(pickListVal.getValue()) ? 'selected' : '' ;
                distributionChannelList.add(distChannel);
            }
        }
        
       
        
        variants.productList =selectedProductCodeList;
        variants.satisOrganizasyonu =salesOrganizationList;
        variants.satisGrubu = salesGroupList;
        variants.satisBurosu = salesOfficeList;
        variants.DagitimKanali =distributionChannelList;
        variants.variantData  = variantData;
        
        return variants;
    }
}