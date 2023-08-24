@isTest
public class RC_FI_OrtalamaVadeIntegratorTest {
    @isTest
    public static void UnitTest(){
        RC_FI_OrtalamaVadeIntegrator.item itm = new RC_FI_OrtalamaVadeIntegrator.item();
        itm.BLINE_DATE = '';
        itm.DSCT_DAYS1 = '';
        itm.PSTNG_DATE = '';
        itm.DB_CR_IND = '';
        itm.LC_AMOUNT = '';
        
        RC_FI_OrtalamaVadeIntegrator.IT_LINEITEMS lineItm = new RC_FI_OrtalamaVadeIntegrator.IT_LINEITEMS();
        lineItm.item = new List<RC_FI_OrtalamaVadeIntegrator.item>();
        
        RC_FI_OrtalamaVadeIntegrator.requestModel req = new RC_FI_OrtalamaVadeIntegrator.requestModel();
        req.IT_LINEITEMS = lineItm;
        

        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        
        Test.startTest();
        RC_FI_OrtalamaVadeIntegrator.responseModel resp =  RC_FI_OrtalamaVadeIntegrator.FI_OrtalamaVadeBul(req);
        Test.stopTest();
    }
}