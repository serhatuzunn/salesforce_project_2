@isTest
public class RC_BordroPdfControllerTest {
    @istest 
    public static void unitTest()
    {
        Account acc = new Account(Name ='Test');
        insert acc;
        
        RC_Bordro__c brd = new RC_Bordro__c();
        brd.RC_Average_Due_Date__c = System.today();
        insert brd;
        
        RC_Cheques__c cq = new RC_Cheques__c();
        cq.RC_Type__c = 'Cheque';
        cq.RC_Bordro__c = brd.Id;
        cq.RC_Due_Date__c = System.today();
        cq.RC_Amount__c = 10;
        insert cq;
        
        PageReference pageRef = Page.RC_BordroPdf;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('bid', brd.Id);
        RC_BordroPdfController p = new RC_BordroPdfController(sc);
    }
}