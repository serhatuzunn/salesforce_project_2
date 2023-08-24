@isTest
public class RC_DTS_OdemePlanIntegratorTest {
  @isTest
  public static void UnitTest() {
    Test.setMock(HttpCalloutMock.class, new RC_FI_Services_Mock());

    RC_DTS_OdemePlanIntegrator.requestModel req = new RC_DTS_OdemePlanIntegrator.requestModel();
    RC_DTS_OdemePlanIntegrator.item requestItem = new RC_DTS_OdemePlanIntegrator.item();
    List<RC_DTS_OdemePlanIntegrator.item> requestItemList = new List<RC_DTS_OdemePlanIntegrator.item>();
    RC_DTS_OdemePlanIntegrator.ODEMEPLANDB ODEMEPLANDB = new RC_DTS_OdemePlanIntegrator.ODEMEPLANDB();

    req.BORDRONO = '313131';
    req.DEBUG = '';
    req.OPERASYON = 'R';

    requestItem.CEKNO = '';
    requestItem.BORDRO = '';
    requestItem.BORDROTYPE = '';
    requestItem.KUNNR = '';
    requestItem.KALEM = '';
    requestItem.TARIH = '';
    requestItem.TUTAR = '';
    requestItem.WAERS = 'TRY';
    requestItem.STATUS = 'A';
    requestItem.ISLEMTARIHI = '';
    requestItem.BELNR = '';
    requestItem.GJAHR = '';

    Test.startTest();
    RC_DTS_OdemePlanIntegrator.responseModel odemePlanResponse = RC_DTS_OdemePlanIntegrator.getDTSOdemePlan(
      req
    );
    Test.stopTest();
  }
}