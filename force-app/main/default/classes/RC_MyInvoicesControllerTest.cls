@IsTest
public class RC_MyInvoicesControllerTest {
    
    @testSetup static void setup(){        
    }
    
    @IsTest
    static void unitTest(){ 
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
        
        Order order = new Order();
        order.AccountId=testAccount.Id;
        order.EffectiveDate=Date.valueOf('2021-03-03');
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
        insert order;
        
        RC_Delivery_and_Billing__c testInvoice = new RC_Delivery_and_Billing__c();
        testInvoice.Name = '8000984546';
        testInvoice.RC_Invoice_Total__c = 5000;
        testInvoice.RC_Invoice_No__c = '0185375158';
        testInvoice.RC_Invoice_Date__c =Date.newInstance(2021,11,09);
        testInvoice.RC_Delivery_Cargo_Company__c = 'N21300001';
        testInvoice.RC_Delivery_Status__c = 'Kurye Dağıtımda';
        testInvoice.RC_Order_Number__c = order.Id;
        testInvoice.RC_UUID__c ='rvkYg2H8UdWGAnSQnY%2B94A%3D%3D';
        insert testInvoice;
        
        RC_Billing_Item__c testBillingItem = new RC_Billing_Item__c();
        testBillingItem.RC_Delivery_and_Billing__c = testInvoice.Id;
        
        insert testBillingItem;
        
        AssecoInformation__c testInfo = new AssecoInformation__c();
        testInfo.Name = 'Vestel';
        testInfo.Kanal__c = 'A010001';
        testInfo.AzamiParcaSayisi__c = '0';
        testInfo.LinkSuresi__c = '24h';
        testInfo.AssecoApiMerchFormat__c = 'Zorlu_{0}';
        testInfo.SureId__c = 'MRD_SAT_02';
        testInfo.SessionSuresi__c = '1h';
        
        insert testInfo;
        
        String selectedHierarchy='02';
        String selectedHierarchy2='0201';
        String selectedHierarchy3='020103';
        String productCode ='20262918';
        
        RC_Definition__c  def = new RC_Definition__c ();
        def.RC_Value__c ='01';
        def.Name ='01-Beyaz Eşya';
        def.Type__c='Product Hierarchy';
        def.RC_Hierarchy_Level__c =1;
        def.RC_External_ID__c ='Hierarchy-01';
        insert def;
        def = new RC_Definition__c ();
        def.RC_Value__c ='02';
        def.Name ='02-Elektronik';
        def.Type__c='Product Hierarchy';
        def.RC_Hierarchy_Level__c =1;
        def.RC_External_ID__c ='Hierarchy-02';
        insert def;
        def = new RC_Definition__c ();
        def.RC_Value__c ='10';
        def.Name ='10-Hizmet';
        def.Type__c='Product Hierarchy';
        def.RC_Hierarchy_Level__c =1;
        def.RC_External_ID__c ='Hierarchy-10';
        insert def;
        
        def = new RC_Definition__c ();
        def.RC_Value__c ='E3';
        def.Name ='Ürün Hasarlı (Tutanak)';
        def.Type__c='Cancel Refund Reason';
        def.RC_Has_It_Billing__c  =true;
        insert def;
        def = new RC_Definition__c ();
        def.RC_Value__c ='F2';
        def.Name ='Bayiliği Bırakma';
        def.Type__c='Cancel Refund Reason';
        def.RC_Has_It_Billing__c  =true;
        insert def;
        def = new RC_Definition__c ();
        def.RC_Value__c ='E6';
        def.Name ='Siparişte Eksik Ürün';
        def.Type__c='Cancel Refund Reason';
        def.RC_Has_It_Billing__c  =true;
        insert def;
        def = new RC_Definition__c ();
        def.RC_Value__c ='13';
        def.Name ='Rework';
        def.Type__c='Cancel Refund Reason';
        def.RC_Has_It_Billing__c  =true;
        insert def;

        def = new RC_Definition__c ();
        def.RC_Value__c ='04';
        def.Name ='14';
        def.Type__c='Event Map';
        def.RC_Has_It_Billing__c  =true;
        insert def;
        
        def = new RC_Definition__c ();
        def.RC_Value__c ='01';
        def.Name ='01';
        def.Type__c='Event Map';
        def.RC_Has_It_Billing__c  =true;
        insert def;
       
        def = new RC_Definition__c ();
        def.RC_Value__c ='01';
        def.Name ='01';
        def.RC_Production_Place__c ='2204';
        def.Type__c='Cancel Refund Store Map';
        def.RC_TM_Event_Code__c='01';
        def.Store_Place__c='0001';
        def.Toplama_Yeri__c='2010211';
        def.RC_Has_It_Billing__c=true;
        insert def;
        
        def = new RC_Definition__c ();
        def.RC_Value__c ='13';
        def.Type__c='Cancel Refund Store Map';
        def.Name ='13';
        def.RC_Production_Place__c ='2204';
        def.RC_TM_Event_Code__c='01';
        def.Store_Place__c='0001';
        def.Toplama_Yeri__c='2010211';
        def.RC_Has_It_Billing__c=false;
        insert def;
        
        
        
        RC_MyInvoicesController.CancelRefundProductionPlaceStorePlace crpps = new RC_MyInvoicesController.CancelRefundProductionPlaceStorePlace();
        List<RC_MyInvoicesController.BillingWrapper> filteredInvoice = new List<RC_MyInvoicesController.BillingWrapper>();
        
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RC_SD_GetPayedAmountMock());
        RC_MyInvoicesController.getCategory1();
        RC_MyInvoicesController.getCategory2(selectedHierarchy);
        RC_MyInvoicesController.getCategory3(selectedHierarchy2);
        
        
     filteredInvoice = RC_MyInvoicesController.getInvoicesNew(Date.newInstance(2021,01,01), null, '0185375158',testAccount.Id, '','','','');
        
      //  String siteURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        //Map<String, Object> preparedMap = RC_MyInvoicesController.prepareMapForPayAction(filteredInvoice.get(0), siteURL, siteURL);
        
     //   List<RC_Billing_Item__c> foundedItems = RC_MyInvoicesController.getBillingDetail(filteredInvoice.get(0).Id);
        
        RC_MyInvoicesController.formatDate(Date.newInstance(2021, 01, 01));
        RC_MyInvoicesController.getBillingDetail(testInvoice.Id);
        RC_MyInvoicesController.getDelivering(testAccount.Id);
        RC_MyInvoicesController.getCancelRefundReason('1','1');
        RC_MyInvoicesController.getCancelRefundReason('2','2');
        RC_MyInvoicesController.getInfoByCancelRefundCode('2','2','10','0350208989');
        RC_MyInvoicesController.getInfoByCancelRefundCode('1','1','10','0350208989');
        RC_MyInvoicesController.getInfoByCancelRefundCode('1','2','10','0350208989');
        RC_MyInvoicesController.getInfoByCancelRefundCode('2','1','10','0350208989');
      	List<RC_MyInvoicesController.IptIadeDetail> r = RC_MyInvoicesController.getBillingIptIade(testInvoice.Name);
        String gipl = RC_MyInvoicesController.getInvoicePDFLink();
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTestForOther(){
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RC_SD_GetPayedAmountMock());
        
        List<RC_MyInvoicesController.IptIadeDetail> lst = new List<RC_MyInvoicesController.IptIadeDetail>();
        RC_MyInvoicesController.IptIadeDetail iid = new RC_MyInvoicesController.IptIadeDetail('Test','Test',10,'10',10,'20110232', 'Test','Test','Test','Test','Test','Test','Test','Test','Test','Test','Test');
        lst.add(iid);
        RC_MyInvoicesController.CreateOrderRetVal corv = RC_MyInvoicesController.sendSap(lst, 'Istanbul','Istanbul','Istanbul','','','','Test');
        RC_MyInvoicesController.prepareMapForPayActionNew('Vestel','test','123123','10000');
        
        Test.stopTest();
    }
}