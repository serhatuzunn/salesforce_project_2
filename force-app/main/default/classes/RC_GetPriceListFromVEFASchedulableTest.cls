@isTest(SeeAllData=true)
public class RC_GetPriceListFromVEFASchedulableTest {
  @isTest static void unitTest(){
        test.startTest();        
        RC_GetPriceListFromVEFASchedulable sch1 = new RC_GetPriceListFromVEFASchedulable();
        sch1.execute(null);             
        test.stopTest();
        
    }
}