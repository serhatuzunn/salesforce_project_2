@isTest(SeeAllData=true)
public class RC_IptalIadeConfirmOrderIntegratorTest {
@isTest static void unitTest(){
test.startTest();

RC_IptalIadeConfirmOrderIntegrator.requestModel req = new RC_IptalIadeConfirmOrderIntegrator.requestModel();

RC_IptalIadeConfirmOrderIntegrator.IT_HEADER it_header = new RC_IptalIadeConfirmOrderIntegrator.IT_HEADER();
it_header.item = new List<RC_IptalIadeConfirmOrderIntegrator.Item>();

RC_IptalIadeConfirmOrderIntegrator.Item item = new RC_IptalIadeConfirmOrderIntegrator.Item();
item.VBELN_VA = '0021072639';

it_header.item.Add(item);
req.IT_HEADER = it_header;


RC_IptalIadeConfirmOrderIntegrator.responseModel resp = new RC_IptalIadeConfirmOrderIntegrator.responseModel();
resp.ET_ERROR_VBELN = new RC_IptalIadeConfirmOrderParser.ET_ERROR_VBELN();
resp.ET_MESSAGE = new RC_IptalIadeConfirmOrderParser.ET_MESSAGE();
resp.Success = '';

resp = RC_IptalIadeConfirmOrderIntegrator.getIptalIadeConfirmOrder(req);       

test.stopTest();

}
}