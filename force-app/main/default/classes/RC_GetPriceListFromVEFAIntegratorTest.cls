@isTest(SeeAllData=true)
public class RC_GetPriceListFromVEFAIntegratorTest {
    @isTest static void unitTest(){
        test.startTest();        
             test.setMock(HttpCalloutMock.class, new RC_SD_DeltaCustomerIntegratorMock());
        RC_GetPriceListFromVEFAIntegrator.requestModel req = new RC_GetPriceListFromVEFAIntegrator.requestModel();
        
        req.DeliveryChanCode = '';
        req.Month = 1;
        req.SaleGroupCode = '';
        req.SaleOfficeCode = '';
        req.SalesOrgCode = '';
        req.Year = 2021;
        req.PackageSize=0;
        req.CurrentIndex=10;        
        RC_GetPriceListFromVefaParser resp = RC_GetPriceListFromVEFAIntegrator.getPriceListFromVefa(req);        
        
        test.stopTest();
        
    }
    
    @isTest static void savePriceListTest(){
        test.startTest();        
        test.setMock(HttpCalloutMock.class, new RC_SD_DeltaCustomerIntegratorMock());
        RC_GetPriceListFromVefaParser.VefaListHeader vefaHeader = new RC_GetPriceListFromVefaParser.VefaListHeader();
        vefaHeader.NAME = '63138-Ekim Ayı VESTEL_KEA Isıtıcı';
        vefaHeader.CURRENCYVEFA = 'TRY';
        vefaHeader.LISTID = '63138';
        vefaHeader.PRICETYPE = '';
        vefaHeader.UNIQUEID = '63138';
        vefaHeader.SOCODE = '2201';
        vefaHeader.DCCODE = '01';
        vefaHeader.RDCODE = '';
        vefaHeader.SGCODE = '';
        
        List<RC_GetPriceListFromVefaParser.VefaListHeader> vefaList = new List<RC_GetPriceListFromVefaParser.VefaListHeader>();
        
        vefaList.add(vefaHeader);
        
        List<RC_GetPriceListFromVefaParser.VefaListDetail> lstDetailList = new List<RC_GetPriceListFromVefaParser.VefaListDetail>();
        
        RC_GetPriceListFromVefaParser.VefaListDetail lstDetail = new RC_GetPriceListFromVefaParser.VefaListDetail();
        lstDetail.PRODUCTCODE = '20263502';
        lstDetail.PRODUCTNAME = 'VESTEL IS1500 INFRARED ISITICI';
        lstDetail.CURRENCYVEFA = 'TRY';
        lstDetail.UNITPRICE = 332.50;
        lstDetail.EXTERNALID = '63138_20263502_';
        lstDetail.EXTERNALHEADERID = '63138';
        lstDetail.MINPRICE =332.50;
        
        lstDetailList.add(lstDetail);
        
        RC_GetPriceListFromVEFAIntegrator.savePriceList(vefaList, lstDetailList);
        
        test.stopTest();
        
    }
}