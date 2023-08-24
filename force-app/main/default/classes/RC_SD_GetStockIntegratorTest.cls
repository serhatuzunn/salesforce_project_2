@isTest
public class RC_SD_GetStockIntegratorTest {
    @isTest
    public static void getSendStockTest(){ 
        RC_SD_GetStockIntegrator.Item item = new RC_SD_GetStockIntegrator.Item();
        item.WERKS = '2204';
        item.LGORT = '0011';
        item.MATNR = '20210127';
        
        RC_SD_GetStockIntegrator.IT_INPUT itInput = new RC_SD_GetStockIntegrator.IT_INPUT();
        itInput.item = new List<RC_SD_GetStockIntegrator.Item>();
        itInput.item.add(item);
        
        RC_SD_GetStockIntegrator.requestModel req = new RC_SD_GetStockIntegrator.requestModel();
        req.IT_INPUT = itInput;
        
        Test.setMock(HttpCalloutMock.class, new RC_SD_GetStockIntegratorMock());
        
        Test.startTest();
        
        RC_SD_GetStockIntegrator.getSendStock(req);
        
        Test.stopTest();
    }
}