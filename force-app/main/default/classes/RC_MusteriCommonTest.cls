@isTest
public class RC_MusteriCommonTest {
    @istest 
    public static void unitTest()
    {   
        RC_MusteriIntegrator.Item item = new RC_MusteriIntegrator.Item();
        item.KUNNR = '123';
        
        RC_MusteriIntegrator.INTKUNN intKunnr = new RC_MusteriIntegrator.INTKUNN();
        intKunnr.item = item;
        
        RC_MusteriIntegrator.RequestModel req = new RC_MusteriIntegrator.RequestModel();
        req.OP = 'C';
        req.PBANKA = 'GRN';
        req.IN_TKUNN = intKunnr;
        
        system.debug('req : ' + req);
        
        RC_MusteriCommon.getMusteri(Json.serialize(req));
    }
}