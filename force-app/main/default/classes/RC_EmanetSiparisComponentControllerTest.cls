@isTest
public class RC_EmanetSiparisComponentControllerTest {
    
    @isTest
    public static void unitTest(){
        
        Account acc = new Account();
        acc.Name='test';
        acc.RC_SAP_ID__c='20100340';
        insert acc;
                
        Contact testContact =  new Contact(
        	accountId = acc.Id,
            FirstName = 'Test',
            LastName = 'Contact'
        );
        
        insert testContact;
        
        User usr = new User();
        usr.Username = 'emanetsiparis@test.com';
        usr.LastName = 'Test';
        usr.Email = 'test@test.com';
        usr.Alias = 'Test';
        usr.TimeZoneSidKey = 'Europe/Dublin';
        usr.LocaleSidKey = 'en_IE_EURO';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.ProfileId = [SELECT Id FROM Profile where name = 'Partner Community User Custom' LIMIT 1].Id;
        usr.ContactId = testcontact.id;
        
        User currUser = [SELECT Id FROM USer WHERE Id =: UserInfo.getUserId()];
        system.runAs(currUser){
            insert usr;            
        }
        
        Test.setMock(HttpCalloutMock.class, new RC_EmanetSiparisMock());
        
        String productCode = '20217928';
        
        Test.startTest();
        
        System.runas(usr){
            RC_EmanetSiparisComponentController.buttonClick(productCode); 
        }    
        
        Test.stopTest();     
        
    }
}