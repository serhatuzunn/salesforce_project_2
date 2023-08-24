@isTest
public class RC_SubeYaratIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_SubeYaratIntegrator.requestModel req = new RC_SubeYaratIntegrator.requestModel();
        req.IV_BAYI = 'IV_BAYI';
        req.IV_SUBE = 'IV_SUBE';
        req.IS_SUBE_VERILERI = new RC_SubeYaratIntegrator.IS_SUBE_VERILERI();
        req.IS_SUBE_VERILERI.ADRNR = 'ADRNR';
        req.IS_SUBE_VERILERI.NAME1 = 'NAME1';
        req.IS_SUBE_VERILERI.NAME2 = 'NAME2';
        req.IS_SUBE_VERILERI.NAME3 = 'NAME3';
        req.IS_SUBE_VERILERI.NAME4 = 'NAME4';
        req.IS_SUBE_VERILERI.ERDAT = 'ERDAT';
        req.IS_SUBE_VERILERI.LOCCO = 'LOCCO';
        req.IS_SUBE_VERILERI.CITY1 = 'CITY1';
        req.IS_SUBE_VERILERI.CITY2 = 'CITY2';
        req.IS_SUBE_VERILERI.LZONE = 'LZONE';
        req.IS_SUBE_VERILERI.REGION = 'REGION';
        req.IS_SUBE_VERILERI.TEL_NUMBER = 'TEL_NUMBER';
        req.IS_SUBE_VERILERI.FAX_NUMBER = 'FAX_NUMBER';
        req.IS_SUBE_VERILERI.SMTP_ADDR = 'SMTP_ADDR';
        req.IS_SUBE_VERILERI.VKORG = 'VKORG';
        req.IS_SUBE_VERILERI.VTWEG = 'VTWEG';
        req.IS_SUBE_VERILERI.SPART = 'SPART';
        req.IS_SUBE_VERILERI.ENLEM = 'ENLEM';
        req.IS_SUBE_VERILERI.BOYLAM = 'BOYLAM';
        req.IS_SUBE_VERILERI.ORT01 = 'ORT01';
        req.IS_SUBE_VERILERI.LAND1 = 'LAND1';

        Test.setMock(HttpCalloutMock.class, new RC_SubeYaratIntegratorMock());
        
        Test.startTest();
        
        RC_SubeYaratIntegrator.getSubeYarat(req);
        
        Test.stopTest();
    }
}