@isTest
public class RC_GetDealerBonusShipmentIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_GetDealerBonusShipmentIntegrator.requestModel req = new RC_GetDealerBonusShipmentIntegrator.requestModel();
        req.IV_BEGIN_DATE='20210101';
        req.IV_END_DATE='20211231';
        req.IV_KUNNR='0020300066';
        
        Test.setMock(HttpCalloutMock.class, new RC_GetDealerBonusShipmentIntegratorMock());
        
        Test.startTest();
        
        RC_GetDealerBonusShipmentIntegrator.getDealerBonusShipment(req);
        
        Test.stopTest();
    }
}