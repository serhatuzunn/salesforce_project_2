@isTest
public class RC_TeslimatBekleyenIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_TeslimatBekleyenIntegrator.Item item = new RC_TeslimatBekleyenIntegrator.Item();
        item.BAYINO = '123';
        item.URUNKODU = '123';
        
        RC_TeslimatBekleyenIntegrator.TESLIMATTABEKLEYEN teslimatBekleyen = new RC_TeslimatBekleyenIntegrator.TESLIMATTABEKLEYEN();
        teslimatBekleyen.item = new List<RC_TeslimatBekleyenIntegrator.Item>();
        teslimatBekleyen.item.add(item);
        
        RC_TeslimatBekleyenIntegrator.RequestModel req = new RC_TeslimatBekleyenIntegrator.RequestModel();
        req.BAYINO = '123';
        req.TESLIMATTABEKLEYEN = teslimatBekleyen;
        
        Test.setMock(HttpCalloutMock.class, new RC_TeslimatBekleyenIntegratorMock());
        
        Test.startTest();
        
        RC_TeslimatBekleyenIntegrator.getTeslimatBekleyen(req);
        
        Test.stopTest();
    }
}