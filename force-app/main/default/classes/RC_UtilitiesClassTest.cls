@IsTest
public class RC_UtilitiesClassTest {
	
    @testSetup static void testSetup(){
        Account testAccount = new Account();
        testAccount.Name = 'Test Acc';
        testAccount.RC_Customer_No__c = '123';
        
        insert testAccount;
        
        RC_City_Region__c testRegion = new RC_City_Region__c(
        	RC_Type__c = 'District',
            RC_Code__c = '34110015'
        );
        
        RC_City_Region__c testRegion2 = new RC_City_Region__c(
        	RC_Type__c = 'District',
            RC_Code__c = '34110014'
        );
        
        List<RC_City_Region__c> insertRegions = new List<RC_City_Region__c>{testRegion, testRegion2};
        
        insert insertRegions;
    }
    
    @IsTest static void unitTest(){
        Test.startTest();
        
        RC_UtilitiesClass.getUserRelatedAccount();
        RC_UtilitiesClass.getFormattedProductCode('000123');
        
        Test.stopTest();
    }
    
    @IsTest static void unitTestForCityMap(){
        Test.startTest();
        
        RC_UtilitiesClass.getCityMappedData(new List<String>{'34110014', '34110015'});
        
        Test.stopTest();
    }
            @IsTest static void getUserInfoTest(){
        Test.startTest();
        User usr = [Select Id,Name From User Limit 1 ] ;
RC_LeftMenuController.initialize(usr.Id);        
        Test.stopTest();
    }
}