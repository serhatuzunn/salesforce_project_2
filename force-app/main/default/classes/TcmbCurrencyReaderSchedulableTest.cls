@isTest
public class TcmbCurrencyReaderSchedulableTest {
    
    @isTest
    public static void unitTest(){
        test.startTest();
        TcmbCurrencyReaderSchedulable sc = new TcmbCurrencyReaderSchedulable();
        String schedule = '0 0 23 * * ?';
        system.schedule('Nightly Update', schedule, sc);
        test.stopTest();
    }
    
}