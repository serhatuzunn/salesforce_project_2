@isTest
public class RC_GetDealerBonusIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_GetDealerBonusIntegrator.requestModel req = new RC_GetDealerBonusIntegrator.requestModel();         
        req.PA_KUNNR='0020300066';
        req.PA_TIP='G';
        req.PA_DONEM='1';
        req.PA_BAST='20210101';
        req.PA_BITT='20211231';
        req.PA_ONCEKI='X';
        
        Test.setMock(HttpCalloutMock.class, new RC_GetDealerBonusIntegratorMock());
        
        Test.startTest();
        
        RC_GetDealerBonusIntegrator.getDealerBonus(req);
        
        Test.stopTest();
    }
}