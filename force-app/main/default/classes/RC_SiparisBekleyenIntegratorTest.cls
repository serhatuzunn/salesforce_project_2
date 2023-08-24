@isTest
public class RC_SiparisBekleyenIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_SiparisBekleyenIntegrator.Item item = new RC_SiparisBekleyenIntegrator.Item();
        item.BAYINO = '123';
        item.URUNKODU = '123';
        
        RC_SiparisBekleyenIntegrator.SIPARISTEBEKLEYEN siparisBekleyen = new RC_SiparisBekleyenIntegrator.SIPARISTEBEKLEYEN();
        siparisBekleyen.item = new List<RC_SiparisBekleyenIntegrator.Item>();
        siparisBekleyen.item.add(item);
        
        RC_SiparisBekleyenIntegrator.RequestModel req = new RC_SiparisBekleyenIntegrator.RequestModel();
        req.BAYINO = '123';
        req.SIPARISTEBEKLEYEN = siparisBekleyen;
        
        Test.setMock(HttpCalloutMock.class, new RC_SiparisBekleyenIntegratorMock());
        
        Test.startTest();
        
        RC_SiparisBekleyenIntegrator.getSiparisBekleyen(req);
        
        Test.stopTest();
    }
}