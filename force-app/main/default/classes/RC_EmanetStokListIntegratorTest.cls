@isTest
public class RC_EmanetStokListIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_EmanetStokListIntegrator.Item item = new RC_EmanetStokListIntegrator.Item();
        item.MATNR = '';
        
        RC_EmanetStokListIntegrator.IT_MATNR itMatnr = new RC_EmanetStokListIntegrator.IT_MATNR();
        itMatnr.item = new List<RC_EmanetStokListIntegrator.Item>();
        itMatnr.item.add(item);
        
        RC_EmanetStokListIntegrator.Item_Z itemZ = new RC_EmanetStokListIntegrator.Item_Z();
        itemZ.WERKS = '';
        
        RC_EmanetStokListIntegrator.IT_WERKS itWerks = new RC_EmanetStokListIntegrator.IT_WERKS();
        itWerks.item = new List<RC_EmanetStokListIntegrator.Item_Z>();
        itWerks.item.add(itemZ);
        
        RC_EmanetStokListIntegrator.RequestModel req = new RC_EmanetStokListIntegrator.RequestModel();
        req.IT_MATNR = itMatnr;
        req.IT_WERKS = itWerks;
        req.IV_KUNNR = '';
        req.IV_SOBKZ = '';
        req.IV_YALNIZCA_STOKLU = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_EmanetStokListIntegratorMock());
        
        Test.startTest();
        
        RC_EmanetStokListIntegrator.getEmanetStokList(req);
        
        Test.stopTest();
    }
}