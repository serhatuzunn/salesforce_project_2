@isTest
public class ZFI_SF_BordroYapIntegratorTest {
    @isTest
    public static void UnitTest(){
        ZFI_SF_BordroYapIntegrator.item itm = new ZFI_SF_BordroYapIntegrator.item();
        itm.AUGRU = '';
        itm.KUNNR = '';
        itm.BORDROTYPE = '';
        itm.SONUC = '';
        itm.BORDRONO = '';
        itm.KKBER = '';
        itm.MSG = '';
        
        ZFI_SF_BordroYapIntegrator.IN_TAUGRU IN_TAUGRU = new ZFI_SF_BordroYapIntegrator.IN_TAUGRU();
        ZFI_SF_BordroYapIntegrator.IO_TKUNNR IO_TKUNNR = new ZFI_SF_BordroYapIntegrator.IO_TKUNNR();
        IN_TAUGRU.item = new List<ZFI_SF_BordroYapIntegrator.item>();
        IO_TKUNNR.item = new List<ZFI_SF_BordroYapIntegrator.item>();
        
        ZFI_SF_BordroYapIntegrator.requestModel req = new ZFI_SF_BordroYapIntegrator.requestModel();
        
        req.IN_TAUGRU = IN_TAUGRU;
        req.IO_TKUNNR = IO_TKUNNR;
        req.IV_BEG_DATE   = '';
        req.IV_END_DATE = '';
        req.PBANKA = '';
        req.PBGLNT   = '';
        req.PBRDTYP   = '';
        req.PKUNSCR   = '';
        req.PSIMUL   = '';
        req.PTAKSIT   = '';
        req.PKKBER = '';
        ZFI_SF_BordroYapIntegrator.responseModel resp = new ZFI_SF_BordroYapIntegrator.responseModel();

        Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());
        
        Test.startTest();
        resp =  ZFI_SF_BordroYapIntegrator.bordroYap(req);
        Test.stopTest();
    }
}