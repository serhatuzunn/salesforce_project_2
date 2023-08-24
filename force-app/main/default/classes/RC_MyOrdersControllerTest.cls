@IsTest 
public class RC_MyOrdersControllerTest {
    @TestSetup
    static void prepareData(){
         Account testAccount = new Account();
        testAccount.Name = 'Test Acc';
        testAccount.RC_Account_Type__c = 'Test';
        testAccount.RC_Customer_No__c = '123';
        testAccount.RC_SAP_ID__c='20100340';//Nizamlar B2B Sap ID
        testAccount.RC_Mobile__c='5530515353';
        testAccount.Phone='05530515353';
        testAccount.RC_email__c='umity@coredet.com';
        testAccount.RC_Tax_Number__c ='00000000053';
        insert testAccount;
        
        AssecoInformation__c testInfo = new AssecoInformation__c();
        testInfo.Name = 'Regal';
        testInfo.Kanal__c = 'A010001';
        testInfo.AzamiParcaSayisi__c = '0';
        testInfo.LinkSuresi__c = '24h';
        testInfo.AssecoApiMerchFormat__c = 'Zorlu_{0}';
        testInfo.SureId__c = 'MRD_SAT_02';
        testInfo.SessionSuresi__c = '1h';   
        insert testInfo;
        
        Product2 p2 = new Product2();
        p2.Name = 'test ürün';
        p2.IsActive = true;
        p2.ProductCode = '123123';
        insert p2;   
        
        Product2 p21 = new Product2();
        p21.Name = 'test ürün';
        p21.IsActive = true;
        p21.ProductCode = '123123';
        insert p21;        
        
        Pricebook2 pb = new Pricebook2();
        pb.Name='61095-Mayıs ayı Vestel_KAMU-PIO_BE_Umut Ticaret Cezaevleri Alımı';
        pb.CurrencyIsoCode='TRY';
        pb.IsActive =true;
        pb.RC_List_UniqueID__c = 'unique';
        insert pb;
        
        Pricebook2 pb1 = new Pricebook2();
        pb1.Name='61097-Mayıs ayı Vestel_VPO-PIO_Afyon Abdullah Uraz İnşaat';
        pb1.CurrencyIsoCode='TRY';
        pb1.IsActive =true;
        pb1.RC_List_UniqueID__c = 'unique2';
        insert pb1;
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pb1.Id, 
            Product2Id = p2.Id,
            UnitPrice = 5300,
            CurrencyIsoCode ='TRY',
            UseStandardPrice=false,
            IsActive = true);
        insert standardPrice;
         
        
         
        
        Order order = new Order();
        order.AccountId=testAccount.Id;
        order.EffectiveDate=Date.valueOf('2021-01-03');
        order.Status='YS';
        order.RC_Order_No__c = '0353060134';
        order.RC_Account_Code_1__c='20100340';
        order.RC_Account_Role_1__c='RE';
        order.RC_Account_Role_2__c='RG';
        order.RC_Account_Role_3__c='AG';
        order.RC_Account_Role_4__c='WE';
        order.RC_Account_Role_5__c='SS';
        order.RC_Partner_Name_1__c ='Test Acc';
        order.RC_Partner_Name_5__c ='test yavuz';
        order.Type='TSHR';
        order.Pricebook2Id = pb1.Id;
        insert order;
        
        Id spe = [Select Id from PricebookEntry where Pricebook2Id =: Test.getStandardPricebookId() limit 1].Id;
        OrderItem ordDet = new OrderItem();
        ordDet.OrderId = order.Id;
        ordDet.Quantity = 1;
        ordDet.UnitPrice = 1;
        ordDet.PricebookEntryId=standardPrice.Id;
        database.insert(ordDet); 
        
        RC_Delivery_and_Billing__c delBil = new RC_Delivery_and_Billing__c(
            Name = '123123' ,
            RC_Delivery_Date__c = Date.today(), 
            RC_Invoice_No__c = '123123',
            RC_Order_Number__c = order.Id
        );
        insert delBil;
    }
    
    @isTest
    public static void unitTest(){
		Order order = [SELECT Id FROM Order LIMIT 1]; 
        OrderItem orderItem = [SELECT Id, Product2Id FROM OrderItem LIMIT 1];
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new RC_SD_GetPayedAmountMock());
        
        
        List<RC_MyOrdersController.OrdersWrapper> orders = RC_MyOrdersController.GetOrders(date.valueOf('2021-01-01'),date.valueOf('2021-03-18'),'0353060134','','','','','','',orderItem.Product2Id);
        
        List<RC_MyOrdersController.OrderDetailsWrapper> orderdetailstrue = RC_MyOrdersController.GetOrderDetails(order.Id,true);
        List<RC_MyOrdersController.OrderDetailsWrapper> orderdetailsfalse = RC_MyOrdersController.GetOrderDetails(order.Id,false);
        List<RC_MyOrdersController.OrderDeliveryBillingsWrapper> delvierybilling = RC_MyOrdersController.GetOrderDeliveryBillings(order.Id);
        List<RC_MyOrdersController.CargoStatuWrapper> cargoStatu = RC_MyOrdersController.CargoStatuDetails('123123');
        
        
        List<RC_MyOrdersController.OrdersWrapper>orderDetailsProduct = RC_MyOrdersController.GetOrderDetailsProduct('123123');
        String namedCred = RC_MyOrdersController.getAssecoPaymentLink();
        
        Map<String, Object> request = RC_MyOrdersController.GetRequestParameters('Vestel','https://vtsbxqa-vestelqa.cs127.force.com/vestelb2b/s/myorders','0006800021','5000','2');
        
        Test.stopTest();        
    }
    
    @IsTest 
    static void unitTestForPicklists(){
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new RC_SD_GetPayedAmountMock());
        
        List<RC_MyOrdersController.PickListValues>orderStatuses = RC_MyOrdersController.getOrderStatuses();
        List<RC_MyOrdersController.PickListValues>category1 = RC_MyOrdersController.getCategory1();
        List<RC_MyOrdersController.PickListValues>category2 = RC_MyOrdersController.getCategory2('01');
        List<RC_MyOrdersController.PickListValues>category3 = RC_MyOrdersController.getCategory3('0101');
        List<RC_MyOrdersController.PickListValues> cities = RC_MyOrdersController.getCities();
        List<RC_MyOrdersController.PickListValues> countries = RC_MyOrdersController.getCounties('34');
        List<RC_MyOrdersController.PickListValues> districts = RC_MyOrdersController.getDistricts('TR');
        List<RC_MyOrdersController.PickListValues> services = RC_MyOrdersController.getServices('','','','');
        String sta = RC_MyOrdersController.shipToAddress('0353060134','1',10,'Turkey', 'Marmara','Test', 'Bayi', 'Test Test', '', '5385644870', '34', '');
        Test.stopTest();       
    }
    
    @IsTest
    static void unitTEstForSiparisBolme(){
        RC_SDSiparisBolmeIntegrator.requestModel req = new RC_SDSiparisBolmeIntegrator.requestModel();
        RC_SDSiparisBolmeIntegrator.SALES_PARTNERS sp = new RC_SDSiparisBolmeIntegrator.SALES_PARTNERS();
        RC_SDSiparisBolmeIntegrator.IT_BELGE ib = new RC_SDSiparisBolmeIntegrator.IT_BELGE();
        
        List<RC_SDSiparisBolmeIntegrator.Item_2> spItemList = new List<RC_SDSiparisBolmeIntegrator.Item_2>();
        RC_SDSiparisBolmeIntegrator.Item_2 it = new RC_SDSiparisBolmeIntegrator.Item_2();
        it.PARTN_ROLE = 'test';
        it.PARTN_NUMB = 'test';
        it.ITM_NUMBER = 'test';
        it.TITLE = 'test';
        it.NAME = 'test';
        it.NAME_2 = 'test';
        it.NAME_3 = 'test';
        it.NAME_4 = 'test';
        it.STREET = 'test';
        it.COUNTRY = 'test';
        it.COUNTR_ISO = 'test';
        it.POSTL_CODE = 'test';
        it.POBX_PCD = 'test';
        it.POBX_CTY = 'test';
        it.CITY = 'test';
        it.DISTRICT = 'test';
        it.REGION = 'test';
        it.PO_BOX = 'test';
        it.TELEPHONE = 'test';
        it.TELEPHONE2 = 'test';
        it.TELEBOX = 'test';
        it.FAX_NUMBER = 'test';
        it.TELETEX_NO = 'test';
        it.TELEX_NO = 'test';
        it.LANGU = 'test';
        it.LANGU_ISO = 'test';
        it.UNLOAD_PT = 'test';
        it.TRANSPZONE = 'test';
        it.TAXJURCODE = 'test';
        it.ADDRESS = 'test';
        it.PRIV_ADDR = 'test';
        it.ADDR_TYPE = 'test';
        it.ADDR_ORIG = 'test';
        it.ADDR_LINK = 'test';
        it.REFOBJTYPE = 'test';
        it.REFOBJKEY = 'test';
        it.REFLOGSYS = 'test';
        spItemList.add(it);
        sp.item = spItemList;
        req.SALES_PARTNERS = sp;
    }
}