@isTest
public class RC_CreateCustomerComponentControllerTest {
 @isTest
    public static void unitTest(){
     RC_CreateCustomerComponentController.createCustomerWrapper wrapper= new RC_CreateCustomerComponentController.createCustomerWrapper();
        RC_CreateCustomerComponentController.createCustomerWrapper sendwrapper= new RC_CreateCustomerComponentController.createCustomerWrapper();
                 
        Account act = new Account();
       
        act.Name='Create Test Bayi LTD ŞTİ Create Test Clas';
        act.RC_Street__c='RAGIP TÜZÜN CAD. NO:168/ B .';
        act.RC_Postal_Code__c='06231';
        act.Phone='3123446857';
        act.Fax='3123446857';
        act.RC_Email__c='TEST@VESTELBAYI.COM';
        act.RC_Tax_Office__c='YENİMAHALLE';
        act.RC_Tax_Number__c='98708822222';   
        insert act;
        
        RC_SD_Organization__c SD = new RC_SD_Organization__c();
        SD.RC_Account__c = act.id;
        SD.RC_Sales_Organization__c = '2201';
        SD.Distribution_Channel__c = '06';
        SD.RC_Active__c=true;
        
        insert SD;       

        Test.startTest();
		 wrapper= RC_CreateCustomerComponentController.initialize(act.Id);
      	 sendwrapper = RC_CreateCustomerComponentController.sendcustomer(act.Id);
        
        Test.stopTest();     
        
    	
    }
    
}