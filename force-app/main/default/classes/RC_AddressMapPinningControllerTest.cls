@IsTest public with sharing class RC_AddressMapPinningControllerTest {    
    @isTest
    public static void unitTest(){
        Test.startTest(); 
        
        RC_City_Region__c testCity = new RC_City_Region__c();
        testCity.RC_Country__c='TR';
        testCity.Name='İSTANBUL';
        testCity.RC_Type__c='City';
        testCity.RC_Code__c = '034';
        insert testCity;
        
        system.debug('testCity.id : ' + testCity.id);
        RC_City_Region__c testRegion = new RC_City_Region__c();
        testRegion.RC_Country__c='TR';
        testRegion.Name='ŞİŞLİ';
        testRegion.RC_Type__c='Region';
        testRegion.RC_City__c = testCity.id;
        testRegion.RC_Code__c = '000000034127';
        insert testRegion;
        
        RC_City_Region__c testDistrict = new RC_City_Region__c();
        testDistrict.RC_Country__c='TR';
        testDistrict.Name='KUŞTEPE MAH.';
        testDistrict.RC_Type__c='District';
        testDistrict.RC_City__c = testCity.id;
        testDistrict.RC_Region__c = testRegion.id;
        testDistrict.RC_Code__c = '34127012';
        insert testDistrict;
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';     
        testAccount.RC_City__c = testCity.id;
        testAccount.RC_Region__c = testRegion.id;
        testAccount.RC_Geolocation__Latitude__s = 40.97973505618505;
        testAccount.RC_Geolocation__Longitude__s = 29.041794437976087;
        insert testAccount;   
        
        PageReference pageRef = Page.RC_AddressMapPinning;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(testAccount);
        ApexPages.currentPage().getParameters().put('recordId',testAccount.id);
        ApexPages.currentPage().getParameters().put('objectName','Account');
        
        RC_AddressMapPinningController controller = new RC_AddressMapPinningController();
        
        controller.GetAddres();
        controller.Location='(40.97973505618505,29.041794437976087)';
        controller.City='İstanbul';
        controller.Region='Şişli';
        controller.District='Kuştepe';
        controller.SetLocation();                
        Test.stopTest();        
    }
}