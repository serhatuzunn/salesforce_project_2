public class RC_CreateBarcodeController {
    
    //Constructor with no arguments
    public RC_CreateBarcodeController() 
    {        
    }
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value {get;set;}
    }
    
    public class initWrapper{         
        @AuraEnabled
        public RC_ServicesVPJsonParser.ET_INFO ET_INFO{get;set;}       
    }
    
    public class ProductWrapper {
        public String ProductCode {get; set;}
        public String Name {get; set;}
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillHierarchy(){        
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> (); 
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Seçiniz';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        
        for(Schema.PicklistEntry pickListVal : ple){            
            SelectOptionWrapper tempValues = new SelectOptionWrapper();
            
            tempValues.value = pickListVal.getValue();
            tempValues.label = pickListVal.getLabel();
            
            resultList.add(tempValues);
        }
        
        return resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillHierarchy2(String selectedHierarchy){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> (); 
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_2__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Seçiniz';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        system.debug('ple: '+ ple);
        system.debug('selectedHierarchy: '+ selectedHierarchy);
        for(Schema.PicklistEntry pickListVal : ple){            
            if(pickListVal.getValue().substring(0,2).Contains(selectedHierarchy)) {                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = pickListVal.getValue();
                tempValues.label = pickListVal.getLabel();
                
                resultList.add(tempValues);
            }
        }
        
        return resultList; 
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillHierarchy3(String selectedHierarchy2){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> (); 
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_3__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Seçiniz';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        system.debug('ple: '+ ple);
        system.debug('selectedHierarchy: '+ selectedHierarchy2);
        for(Schema.PicklistEntry pickListVal : ple){            
            if(pickListVal.getValue().substring(0,4).Contains(selectedHierarchy2)) {                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = pickListVal.getValue();
                tempValues.label = pickListVal.getLabel();
                
                resultList.add(tempValues);
            }
        }
        
        return resultList; 
    }
    
    @AuraEnabled
    public static String getSideId(){
     	String siteName = 'Vestel_B2B';
        
        if(!Test.isRunningTest()){
            String siteId = Site.getSiteId();
            Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE id = : siteId];
            System.debug('Site: '+ site.Name);            
            siteName = site.Name;
        }
    	
        return siteName;
    }
    
    @AuraEnabled
    public static String getProducts(string selectedHierarchy, string selectedHierarchy2, string selectedHierarchy3, string productCode){
        List<Product2> lstProducts=new List<Product2>();
        List<ProductWrapper> lstProductsWrp = null;
        
        System.debug('selectedHierarchy : '+selectedHierarchy);
        System.debug('selectedHierarchy2 : '+selectedHierarchy2);
        System.debug('selectedHierarchy3 : '+selectedHierarchy3);
        String qry = 'Select ProductCode, Name, RC_Product_hiy_Level_1__c, RC_Product_hiy_Level_2__c, RC_Product_hiy_Level_3__c  FROM Product2';
        
        //Network'e gore
        //RC_VP_Brand__c setlenecek
        
        if(!String.isBlank(productCode)){
            qry = qry + ' WHERE ProductCode like \'%'+ String.escapeSingleQuotes(productCode)+'%\'';   
        }
        else if(!String.isBlank(selectedHierarchy3))  {
            qry = qry + ' WHERE RC_Product_hiy_Level_3__c  = \''+ String.escapeSingleQuotes(selectedHierarchy3)+'\'';            
        }
        else if(!String.isBlank(selectedHierarchy2))  {
            qry = qry + ' WHERE RC_Product_hiy_Level_2__c  = \''+ String.escapeSingleQuotes(selectedHierarchy2)+'\'';            
        }
        else if(!String.isBlank(selectedHierarchy))  {
            qry = qry + ' WHERE RC_Product_hiy_Level_1__c  = \''+ String.escapeSingleQuotes(selectedHierarchy)+'\'';            
        }
        if(getSideId().Contains('Regal')){
        	qry = qry + ' AND RC_VP_Brand__c = \'RGL\'';    
        }else qry = qry + ' AND RC_VP_Brand__c = \'VST\'';
        
        qry = qry + ' LIMIT 1000';
        
        lstProducts = Database.query(qry);
        lstProductsWrp = new List<ProductWrapper>();
        
        for (Product2 p : lstProducts) {
            
            ProductWrapper wrp = new ProductWrapper();
            
            wrp.ProductCode = p.ProductCode != null && p.ProductCode.startsWith('0') ? p.ProductCode.replaceFirst('^0+',''): p.ProductCode;/*ProductCode bos gelen datalar vardı*/
            wrp.Name = p.Name;
            lstProductsWrp.add(wrp);           
        }
        System.debug('lstProducts : '+JSON.serialize(lstProducts));
        return JSON.serialize(lstProducts);
    }
    
    @AuraEnabled
    public static String createBarcodePDF(String addedProducts, boolean isEan)
    {       
        String result = '';
        system.debug('addedProducts: '+ addedProducts);
        RC_ProductBarcodeIntegrator.requestModel r = null;        
        
        List<RC_ProductBarcodeIntegrator.productDetail> selectedProductList = new List<RC_ProductBarcodeIntegrator.productDetail>();
        RC_ProductBarcodeIntegrator.productDetail selectedProduct = null;
        
		List<ProductWrapper> products = (List<ProductWrapper>)JSON.deserialize(addedProducts, List<ProductWrapper>.class);        
        
        for (ProductWrapper p : products) {
            selectedProduct = new RC_ProductBarcodeIntegrator.productDetail();
            
            selectedProduct.ProductCode = p.ProductCode;
            selectedProduct.ProductName = p.Name;
            
            selectedProductList.add(selectedProduct);            
        }
        
        r = new RC_ProductBarcodeIntegrator.requestModel();
        r.isEAN = isEan;
        r.productDetail = selectedProductList;
        
        String base64String = RC_ProductBarcodeIntegrator.getCreateBarcodePDF(r);       
        system.debug('base64String :' + base64String);
        if(base64String != 'error'){
             result = base64String;
        }
        return result;
    } 
    
}