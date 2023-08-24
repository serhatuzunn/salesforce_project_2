@isTest(SeeAllData=true)
public class RC_IptalIadeOpenRetOrderIntegratorTest {
@isTest static void unitTest(){
test.startTest();        
RC_IptalIadeOpenRetOrderIntegrator.requestModel req = new RC_IptalIadeOpenRetOrderIntegrator.requestModel();
req.IV_BEGDA='20210201';
req.IV_ENDDA='20210225';
req.IV_KUNNR='0020700295';
req.IV_VKGRP='732';
req.IV_VKORG='2201';
req.IV_VTWEG='01';


RC_IptalIadeOpenRetOrderIntegrator.responseModel resp = new RC_IptalIadeOpenRetOrderIntegrator.responseModel();
resp.ET_RESULT = new RC_IptalIadeOpenRetOrderParser.ET_RESULT();
resp.EV_SUCCESS = '';          
resp = RC_IptalIadeOpenRetOrderIntegrator.getIptalIadeOpenRetOrder(req);       

test.stopTest();

}
}