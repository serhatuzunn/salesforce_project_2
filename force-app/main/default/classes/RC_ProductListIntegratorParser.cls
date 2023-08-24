public class RC_ProductListIntegratorParser {
    
    public class ProductList {
        public String Id {get;set;} 
        public String FirstProductImageURL {get;set;} 
        public String ExternalSystemCode {get;set;} 
    }
    
    public Boolean Success {get;set;} 
    public Result Result {get;set;} 
    
    public class Result {
        public List<ProductList> ProductList {get;set;} 
        public Integer TotalPageCount {get;set;}         
    }    
}