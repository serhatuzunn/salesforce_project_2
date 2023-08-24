public class RC_GenerateBarcodeController {
    
    public List<SelectOption> hiyLevels{set;}
    public String selectedHierarchy {get;set;}
    public String selectedHierarchy2 {get;set;}
    public String selectedHierarchy3 {get;set;}
    public String filterProductCode {get;set;}
    public List<Product2> lstProducts {get; set;}
    public List<ProductWrapper> lstProductsWrp {get; set;}
    public List<ProductWrapper> lstProductsAdded {get; set;}
    public RC_ProductBarcodeIntegrator.requestModel r  {get; set;}
    public String paramValue {get; set;}
    public boolean showProductTable{get; set;}
    
    public class ProductWrapper {
        public Boolean isSelected {get; set;}
        public String ProductCode {get; set;}
        public String Name {get; set;}
    }
    
    
    public RC_GenerateBarcodeController(){
        lstProductsAdded = new List<ProductWrapper>();
        showProductTable = false;
    }
    
    public List<SelectOption> getHierarchyOption () {        
        List<SelectOption> hieararchy = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
        
        hieararchy.add(new SelectOption('0','Seçiniz'));
        
        for( Schema.PicklistEntry pickListVal : ple){
            hieararchy.add(new SelectOption(   pickListVal.getValue(),pickListVal.getLabel()));
        }        
        
        return hieararchy;
    } 
    
    public List<SelectOption> getHierarchyOption2 ( ) {        
        List<SelectOption> hieararchy2 = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_2__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
        
        hieararchy2.add(new SelectOption( '0','Seçiniz'));
        if(!String.isBlank(selectedHierarchy) && selectedHierarchy != '1'){
            for( Schema.PicklistEntry pickListVal : ple){                
                if(pickListVal.getValue().substring(0,2).Contains(selectedHierarchy)) {                    
                    hieararchy2.add(new SelectOption(  pickListVal.getValue(), pickListVal.getLabel()));
                }                
            }
        }        
        
        return hieararchy2;
    }
    
    public List<SelectOption> getHierarchyOption3 () {        
        List<SelectOption> hieararchy3 = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_3__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();
        
        hieararchy3.add(new SelectOption( '0','Seçiniz'));
        if(!String.isBlank(selectedHierarchy2) && selectedHierarchy2 != '1'){
            for( Schema.PicklistEntry pickListVal : ple){
                if(pickListVal.getValue().substring(0,4).Contains(selectedHierarchy2)) {
                    hieararchy3.add(new SelectOption(  pickListVal.getValue(), pickListVal.getLabel()));
                }
            }
        }        
        
        return hieararchy3;
    }
    
    
    public PageReference search(){
        
        if(!string.isBlank(filterProductCode)){            
            lstProductsWrp = getAllProducts('',filterProductCode);
            system.debug('search: '+ filterProductCode);
        }
        
        else if(!String.isBlank(selectedHierarchy3) && selectedHierarchy3 != '0' ){
            lstProductsWrp = getAllProducts('3','');
            system.debug('search: '+ selectedHierarchy3);
        } 
        else if(!String.isBlank(selectedHierarchy2)&& selectedHierarchy2 != '0'){
            lstProductsWrp = getAllProducts('2','');
            system.debug('search: '+ selectedHierarchy2);
        } 
        else if(!String.isBlank(selectedHierarchy)&& selectedHierarchy != '0'){
            lstProductsWrp = getAllProducts('1','');
            system.debug('search: '+ selectedHierarchy);
        }
        filterProductCode='';
        
        if(!showProductTable && lstProductsWrp.size()>0){
            showProductTable=true;
        }
        
        return null;
    }
    
    public PageReference add()
    {
        filterProductCode='';
        
        ProductWrapper selectedProduct = null;        
        for (ProductWrapper p : lstProductsWrp) {
            
            if(p.isSelected == true && !lstProductsAdded.contains(p)){
                selectedProduct = new ProductWrapper();
                
                selectedProduct.isSelected = true;
                selectedProduct.ProductCode = p.ProductCode;
                selectedProduct.Name = p.Name;
                
                lstProductsAdded.add(selectedProduct);
            }
        }
        return null;
    }
    
    public PageReference clearAll(){
        
        lstProductsAdded = new List<ProductWrapper>();
        
        return null;
    }
    
    
    public PageReference deleteAddedProduct(){     
        system.debug('lstProductsAdded.size()-First: '+lstProductsAdded.size());
        string productCode  = this.paramValue;
        if(!String.isBlank(productCode)){
            List<ProductWrapper> tempList = new List<ProductWrapper>();
            tempList = lstProductsAdded.clone();
            
            
            Integer i = 0;
            for( ProductWrapper p : tempList){
                if(p.ProductCode == productCode) {
                    lstProductsAdded.remove(i);
                    break;
                }
                else{
                    i++;
                }
            }
            system.debug('productCode: '+ productCode);
            system.debug('lstProductsAdded.size(): '+lstProductsAdded.size());
            search();
            lstProductsAdded = lstProductsAdded;
        }
        return null;
    }
    
    
    public PageReference addHieararchy()
    {        
        return null;
    }
    public PageReference getHierarchy1Products()
    {       
        return null;
    }    
    public PageReference getHierarchy2Products()
    { 
        getHierarchyOption3();         
        return null;
    }    
    public PageReference getHierarchy3Products()
    {         
        return null;
    }
    
    public List<ProductWrapper> getAllProducts(string hierarchyLevel, string productCode){ 
        String qry = 'Select ProductCode, Name, RC_Product_hiy_Level_1__c, RC_Product_hiy_Level_2__c, RC_Product_hiy_Level_3__c  FROM Product2';
        
        if(!String.isBlank(productCode)){
            qry = qry + ' WHERE ProductCode like \'%'+ String.escapeSingleQuotes(productCode)+'%\'';   
        }
        else if(!String.isBlank(hierarchyLevel) && hierarchyLevel == '3' && !String.isBlank(selectedHierarchy3))  {
            qry = qry + ' WHERE RC_Product_hiy_Level_3__c  = \''+ String.escapeSingleQuotes(selectedHierarchy3)+'\'';            
        }
        else if(!String.isBlank(hierarchyLevel) && hierarchyLevel == '2' && !String.isBlank(selectedHierarchy2))  {
            qry = qry + ' WHERE RC_Product_hiy_Level_2__c  = \''+ String.escapeSingleQuotes(selectedHierarchy2)+'\'';            
        }
        else if(!String.isBlank(hierarchyLevel) && hierarchyLevel == '1' && !String.isBlank(selectedHierarchy))  {
            qry = qry + ' WHERE RC_Product_hiy_Level_1__c  = \''+ String.escapeSingleQuotes(selectedHierarchy)+'\'';            
        }
        qry = qry + ' LIMIT 1000';
        
        lstProducts = Database.query(qry);
        lstProductsWrp = new List<ProductWrapper>();
        
        for (Product2 p : lstProducts) {
            
            ProductWrapper wrp = new ProductWrapper();
            wrp.isSelected = false;
            wrp.ProductCode = p.ProductCode != null && p.ProductCode.startsWith('0') ? p.ProductCode.replaceFirst('^0+',''): p.ProductCode;/*ProductCode bos gelen datalar vardı*/
            wrp.Name = p.Name;
            lstProductsWrp.add(wrp);           
        }
        
        return lstProductsWrp;
    }
    
    public PageReference createPDF()
    {
        return createBarcodePDF(false);
    }
    
    public PageReference createPDFEAN()
    {
        return createBarcodePDF(true);         
    }
    
    public PageReference createBarcodePDF(boolean isEan)
    {        
        List<RC_ProductBarcodeIntegrator.productDetail> selectedProductList = new List<RC_ProductBarcodeIntegrator.productDetail>();
        RC_ProductBarcodeIntegrator.productDetail selectedProduct = null;
        
        
        for (ProductWrapper p : lstProductsAdded) {            
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
            PageReference pdfViewerPage = new PageReference('/apex/RC_ConvertBase64ToPDF');			
            pdfViewerPage.getParameters().put('dataPDF',base64String);            
            
            return pdfViewerPage.setRedirect(true);
        }
        return null;
    }    
    
}