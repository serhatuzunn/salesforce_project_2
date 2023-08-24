@isTest
public class RC_MusteriIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_MusteriIntegrator.Item item = new RC_MusteriIntegrator.Item();
        item.KUNNR = 'test';
        
        RC_MusteriIntegrator.INTKUNN intKunn = new RC_MusteriIntegrator.INTKUNN();
        intKunn.item = item;
        
        RC_MusteriIntegrator.requestModel req = new RC_MusteriIntegrator.requestModel();
        req.OP = '';
        req.PBANKA = '';
        req.IN_TKUNN = intKunn;
        
        Test.setMock(HttpCalloutMock.class, new RC_MusteriIntegratorMock());
        
        Test.startTest();
        
        RC_MusteriIntegrator.getMusteri(req);
        
        Test.stopTest();
    }
}