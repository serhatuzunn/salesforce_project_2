@isTest
public class RC_BordroPdfTest {
    @istest 
    public static void unitTest()
    {
        RC_BordroPdf.getEmail('123');
        
        RC_Bordro__c brd = new RC_Bordro__c();
        insert brd;
        
        RC_BordroPdf.sendEmail('test@test.test', brd.Id);
    }
}