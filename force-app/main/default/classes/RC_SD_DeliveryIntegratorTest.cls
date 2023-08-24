@isTest
public class RC_SD_DeliveryIntegratorTest {
	@isTest
    public static void unitTest(){
        
        Test.setMock(HttpCalloutMock.class, new RC_BillingIntegratorMock());
        
        RC_SD_DeliveryIntegrator.SdDeliveryRequestModel req = new RC_SD_DeliveryIntegrator.SdDeliveryRequestModel();
        RC_SD_DeliveryIntegrator.SdDeliveryResponseModel resp = new RC_SD_DeliveryIntegrator.SdDeliveryResponseModel();
        
        req.IV_VBELN = '';
        
        resp = RC_SD_DeliveryIntegrator.getDelivery(req);
    }
}