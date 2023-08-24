@isTest
public class RC_EmanetStokIntegratorTest {

    @isTest
        public static void getEmanetStokTest(){
            
            RC_EmanetStokIntegrator.requestModel req = new RC_EmanetStokIntegrator.requestModel();
            RC_EmanetStokIntegrator.IT_INPUT_W itInput_W = new RC_EmanetStokIntegrator.IT_INPUT_W();            
            RC_EmanetStokIntegrator.IT_INPUT itInput = new RC_EmanetStokIntegrator.IT_INPUT();
            
       		req.IT_MATNR = itInput;
       		req.IV_YALNIZCA_STOKLU = '';
        	req.IV_SOBKZ = '';
            req.IV_KUNNR = '';
            req.IT_WERKS = itInput_W;
            
            Test.setMock(HttpCalloutMock.class, new RC_EmanetStokMock());
        
        	Test.startTest();

            RC_EmanetStokIntegrator.getEmanetStok(req);
            
            Test.stopTest();     
             
        }
}