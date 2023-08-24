@isTest
public class customLookupControllerTest {

    @isTest
    public static void unitTest(){
        List<sObject> objList = customLookUpController.fetchLookUpValues('test', 'Account', null);
    }
    
}