@isTest
public class SearchControllerTest {
	@isTest
    public static void unitTest(){
        test.startTest();
        
        List<String> fieldList = new List<String>();
        fieldList.add('name');
        List<sObject> objList = SearchController.search('Account', fieldList , '' , '');
        
        Test.stopTest();
    }
    
}