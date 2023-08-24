public class RC_GetPriceListFromVEFAIntegrator {
    public class requestModel{
        public Integer Month 	{get;set;}
        public Integer Year 	{get;set;}
        public String SalesOrgCode 	{get;set;}
        public String DeliveryChanCode 	{get;set;}
        public String SaleOfficeCode 	{get;set;}
        public String SaleGroupCode 	{get;set;}
        public Integer PackageSize {get;set;}
        public Integer CurrentIndex {get;set;}
    }   
    
    public static RC_GetPriceListFromVefaParser getPriceListFromVefa(requestModel req){              
        //String url = 'http://212.29.90.76/WEBSERVICES/ProductPricesRest/exportpricelists/getproduct';
        String url = 'RESTAdapter/salesforce/vefa/product_prices';
        HttpRequest request = new HttpRequest();
        request.setBody(json.serialize(req));
        request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Basic ' + 'UE9fU0FMRVNGT1JDRTpOMnElfXUoOw==');    
        request.setHeader('Content-Type','application/json');        
        request.setTimeout(120000);
        system.debug('request : ' + json.serialize(req));
        Http http = new Http();      
            HttpResponse response = http.send(request);      
            if(response.getStatus() == 'OK'){                
                RC_GetPriceListFromVefaParser parseResult = RC_GetPriceListFromVefaParser.parse(response.getBody());   
                return parseResult;     			                 
            }
            else
            {
                return null;
            }
            
        
    }
    
    public static boolean savePriceList(List<RC_GetPriceListFromVefaParser.VefaListHeader> lstHeader,List<RC_GetPriceListFromVefaParser.VefaListDetail> lstDetail){
        try {
            List<Pricebook2> lstPriceBooks = new List<Pricebook2>();    
            set<string>externalDetailIds=new set<string>();//kalemlerdeki externalIdleri al   
            
            for(RC_GetPriceListFromVefaParser.VefaListDetail record: lstDetail) {               
                externalDetailIds.add(record.EXTERNALID);          
            }
            
                 Map<string, string> unProductCodes = new map<string, string>();        
            for(RC_GetPriceListFromVefaParser.VefaListDetail record: lstDetail) {
                if(!unProductCodes.containsKey(record.PRODUCTCODE)) {
                    unProductCodes.put(record.PRODUCTCODE, record.PRODUCTCODE);
                }           
            } 

            
            for(RC_GetPriceListFromVefaParser.VefaListHeader p : lstHeader)
            {
                Pricebook2 prc = new Pricebook2();          
                prc.Description = p.NAME.length()>110 ? p.NAME.Substring(0,109) : p.NAME;
                prc.Name = p.NAME.length()>110 ? p.NAME.Substring(0,109) : p.NAME;
                prc.RC_List_ID__c =	String.valueOf(p.LISTID);		
                prc.RC_Distribution_Channel__c = p.DCCODE;
                prc.RC_Sales_Organizations__c=p.SOCODE;
                prc.RC_Regional_Directorie__c = p.RDCODE;
                prc.RC_Sales_Directorate__c = p.SGCODE;  
                prc.RC_List_UniqueID__c = p.UNIQUEID;
                prc.RC_Pricebook_Type__c = p.PRICETYPE;
                prc.CurrencyIsoCode = p.CURRENCYVEFA;
                prc.IsActive = true;
                lstPriceBooks.add(prc);               
            }
            
            if(lstPriceBooks.size() > 0){
                try{
                    
                    Schema.SObjectField ext = Pricebook2.RC_List_UniqueID__c;
                    List<DataBase.UpsertResult> urList = DataBase.upsert(lstPriceBooks,ext ,false);
                    set<id> urListIds = new set<id>();
                    for(DataBase.UpsertResult ur : urList) {
                        if(ur.isSuccess() == true){         
                            urListIds.add(ur.getId());                            
                        }
                        else
                        {
                            system.debug('Saving Pricebooks ListId :' + ur.getErrors()); 
                        }
                    }
                    
                    
                    Map<string, string> m = new Map<string, string>();
                    for(Pricebook2 price : [SELECT RC_List_UniqueID__c,Id FROM Pricebook2 where Id IN : urListIds])
                    {
                        m.put(price.RC_List_UniqueID__c,price.Id);
                    }                    
                    
                    Map<string, string> products = new Map<string, string>();
                    for(Product2 pro : [SELECT ProductCode,Id FROM Product2 where ProductCode IN : unProductCodes.values()])
                    {
                        products.put(pro.ProductCode,pro.Id);
                    }
                    
                    List<PricebookEntry> lEntry = new List<PricebookEntry>();                      
                    
                    
                    integer counter =1;
                    for(RC_GetPriceListFromVefaParser.VefaListDetail p : lstDetail)
                    {  
                        string ab = m.get(string.valueOf(p.EXTERNALHEADERID));                   
                        string productId =products.get(string.valueOf(p.PRODUCTCODE));                   
                        if(string.isNotBlank(ab)){
                            if(string.isNotBlank(productId))
                            {
                                PricebookEntry pe = new PricebookEntry();   
                                pe.Product2Id =productId;	
                                pe.UnitPrice=p.UNITPRICE; 
                                pe.RC_Min_Price__c=p.MINPRICE;                            
                                pe.Pricebook2Id =ab;
                                pe.ExternalId__c = p.EXTERNALID;    
                                pe.IsActive=true;                               
                                pe.CurrencyIsoCode = p.CURRENCYVEFA;
                                lEntry.add(pe);   
                                counter++;
                            }
                            else
                            {
                                system.debug('product not found productCode:' + string.valueOf(p.PRODUCTCODE));   
                            }
                        }     
                    }                      
                    if(lEntry.size() > 0){
                        try{
                            Schema.SObjectField extPricebookentry = PricebookEntry.ExternalId__c;
                            List<DataBase.UpsertResult> urList2 = DataBase.upsert(lEntry,extPricebookentry, false);
                            integer count=1;
                            for(DataBase.UpsertResult ur : urList2) {
                                if(ur.isSuccess() == false){         
                                    system.debug(count + ')Saving Pricebookentries error :' + ur.getErrors()  );                       
                                }
                                else
                                {
                                    
                                }
                                count++;
                                
                            }
                            
                        }
                        catch(Exception e){
                            system.debug(e.getMessage());
                        }
                    }
                    
                }
                catch(Exception e){
                    system.debug(e.getMessage());
                }          
            }
            return true;
            
        }
        
        catch(Exception e){
            RC_Logger.LOG_EXCEPTION('RC_GetPriceListFromVEFAIntegrator  Error', e.getMessage(), e.getStackTraceString(), 'RC_GetPriceListFromVEFAIntegrator', 'finish', '');
            return null;
        }
    }
    
}