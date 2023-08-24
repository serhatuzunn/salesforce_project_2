public class RC_VestelOrderDocPdfController {
    
    ApexPages.StandardController controller;
    public Order order {get;set;}
    public AccountWrapper acc {get;set;} 
    public List<OrderItemWrapper> orderItems {get;set;} 

    
    public class AccountWrapper{
        @AuraEnabled
        public String accountID {get; set;} 

        @AuraEnabled
        public String accountName {get; set;}       
      
        @AuraEnabled
        public String postalCode {get; set;}

        
        public string streetName {get; set;}
        
        @AuraEnabled
        public string districtName {get; set;}
        
        @AuraEnabled
        public string countyName {get; set;}
        
        @AuraEnabled
        public string cityName {get; set;}        
    }  

    public class OrderItemWrapper{
        @AuraEnabled
        public String ProductNo {get; set;} 

        @AuraEnabled
        public String ProductCode {get; set;}       
      
        @AuraEnabled
        public String ProductName {get; set;}

        
        public decimal Quantity {get; set;}
        
        @AuraEnabled
        public Decimal UnitPrice {get; set;}
        
        @AuraEnabled
        public Decimal TotalPrice {get; set;}    
    } 
    
	   
    
    public RC_VestelOrderDocPdfController(ApexPages.StandardController c) {
        
     system.debug('deneme');
     id orderId = apexPages.currentPage().getParameters().get('id');
        
     order = [SELECT id,AccountId, Account.RC_SAP_ID__c,  EffectiveDate, Type,OrderNumber, TotalAmount, RC_Order_No__c, RC_Order_Justification__c,RC_Payment_Condition__c,ToLabel(Status)
         ,RC_Circular_Number__c, RC_SAS_Number__c, RC_SAS_Date__c, RC_Delivery_Date__c, RC_Average_Value_Date__c, RC_Additional_Value_Date__c,
         RC_Address_Data__c  
             FROM Order
             WHERE id=:orderId];
     string orderAccAdd= order.RC_Address_Data__c;
     string[] orderAccount = orderAccAdd.Split('\\|');
     system.debug('orderAcc:' + orderAccount);
     string cityCode = orderAccount[2].Trim();
     system.debug('cityCode=' + cityCode );
     RC_City_Region__c city =[SELECT RC_Code__C, Name FROM RC_City_Region__c 
             WHERE RC_Type__c ='city' and RC_Code__C =:cityCode];
     acc = new AccountWrapper();

     acc.accountID = order.Account.RC_SAP_ID__c;
     acc.accountName = orderAccount[0].Trim() + ' '+ orderAccount[1].Trim();
     if(orderAccount.size() >6)
     {
        acc.postalCode =  orderAccount[7];
     }
     acc.streetName = orderAccount[5].Trim();
     acc.districtName = orderAccount[4].Trim();
     acc.countyName = orderAccount[3].Trim();
     acc.cityName = city.Name.Trim();	
        system.debug('acc='+ acc);

  List<OrderItem> orderItemz = [SELECT id,RC_Order_Product_No__c, Product2.ProductCode, Product2.Name,Quantity,UnitPrice,TotalPrice
     FROM OrderItem
     WHERE OrderId =:orderId
     order by RC_Order_Product_No__c];
     orderItems = new List<OrderItemWrapper>();
     for(OrderItem oi  : orderItemz)
     {
        OrderItemWrapper oiw = new OrderItemWrapper();
        oiw.ProductNo = oi.RC_Order_Product_No__c;
        oiw.ProductCode = oi.Product2.ProductCode;
        oiw.ProductName= oi.Product2.Name;
        oiw.Quantity = oi.Quantity;
        oiw.UnitPrice = oi.UnitPrice;
        oiw.TotalPrice = oi.TotalPrice;
        orderItems.add(oiw);
     }
    }   

    public List<OrderItem> getItems(){
        
     id orderId = apexPages.currentPage().getParameters().get('id');

     List<OrderItem> orderItems = [SELECT id,RC_Order_Product_No__c, Product2.ProductCode, Product2.Name,Quantity,UnitPrice,TotalPrice
     FROM OrderItem
     WHERE OrderId =:orderId];
     system.debug('ois : ' + orderItems);

     return orderItems;
    }
}