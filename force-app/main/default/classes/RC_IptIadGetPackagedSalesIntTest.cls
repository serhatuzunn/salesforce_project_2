@isTest(SeeAllData=true)
public class RC_IptIadGetPackagedSalesIntTest {
@isTest static void unitTest(){
test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RC_IptalIadeGetOrdersIntegratorMock());
RC_IptalIadeGetPackagedSalesIntegrator.requestModel req = new RC_IptalIadeGetPackagedSalesIntegrator.requestModel();
req.IV_AUGRU='YR2';
RC_IptalIadeGetPackagedSalesIntegrator.responseModel resp = new RC_IptalIadeGetPackagedSalesIntegrator.responseModel();
resp.export1 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT1();
resp.export2 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT2();
resp.export3 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT3();
resp.export4 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT4();
resp.export5 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT5();
resp.export6 = new RC_IptalIadeGetPackagedSalesParser.ET_EXPORT6();         
resp.EV_ID = '';          
resp.EV_PACKAGE = '';          


resp = RC_IptalIadeGetPackagedSalesIntegrator.getIptalIadePackages(req);       

test.stopTest();

}
}