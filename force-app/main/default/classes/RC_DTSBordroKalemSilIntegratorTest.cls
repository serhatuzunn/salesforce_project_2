@isTest
public class RC_DTSBordroKalemSilIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_DTSBordroKalemSilIntegrator.item itm = new RC_DTSBordroKalemSilIntegrator.item();
        itm.BORDRO = '';
        itm.GJAHR  = '';
        itm.BELNR  = '';

        RC_DTSBordroKalemSilIntegrator.T_ITEMS T_ITEMS = new RC_DTSBordroKalemSilIntegrator.T_ITEMS();
        T_ITEMS.item =  new List<RC_DTSBordroKalemSilIntegrator.item>();
        T_ITEMS.item.add(itm);

        RC_DTSBordroKalemSilIntegrator.requestModel req = new RC_DTSBordroKalemSilIntegrator.requestModel();
        req.T_ITEMS = T_ITEMS;

        RC_DTSBordroKalemSilIntegrator.responseModel resp = new RC_DTSBordroKalemSilIntegrator.responseModel();

        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        Test.startTest();
        resp = RC_DTSBordroKalemSilIntegrator.DTSBordroKalemSil(req);
        Test.stopTest();

        
    }
    
}