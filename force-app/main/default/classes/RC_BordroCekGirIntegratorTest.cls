@isTest
public class RC_BordroCekGirIntegratorTest {
    @isTest
    public static void UnitTest(){
        List<RC_BordroCekGirIntegrator.Item> itemList = new List<RC_BordroCekGirIntegrator.Item>();
        RC_BordroCekGirIntegrator.Item item = new RC_BordroCekGirIntegrator.Item();
        item.BOENUM = '';
        item.BUDAT = '';
        item.PORTFO = '';
        item.KUNNR = '';
        item.ZFBDT = '';
        item.XSIWE = '';
        item.WAERS = '';
        item.WRBTR = '';
        item.BANKL = '';
        item.BANKN = '';   
        item.NAME1 = '';
        item.BOLGE = '';
        item.STCEG = '';
        item.FATURA = '';
        item.VKBUR = '';
        item.HZUON = '';
        itemList.Add(item);
        
        RC_BordroCekGirIntegrator.Item_Z itemZ = new RC_BordroCekGirIntegrator.Item_Z();
        itemZ.BELNR = '';
        itemZ.BUZEI = '';
        itemZ.KUNNR = '';
        itemZ.BUDAT = '';
        itemZ.ZFBDT = '';
        itemZ.WAERS = '';
        itemZ.DMBTR = '';
        itemZ.SGTXT = '';
        itemZ.BLART = '';
        itemZ.AWKEY = '';
        itemZ.GJAHR = '';
        itemZ.ZLSPR = '';
        itemZ.ZLSCH = '';
        itemZ.LTEXT = '';
        itemZ.MATNR = '';
        itemZ.MAKTX = '';
        itemZ.FKIMG = '';
        itemZ.VRKME = '';
        itemZ.KKBER = '';
        
        
        
        RC_BordroCekGirIntegrator.CEK_ITEMS items = new RC_BordroCekGirIntegrator.CEK_ITEMS();
        items.item = itemList;
        
        RC_BordroCekGirIntegrator.ET_ITEMS itemZs = new RC_BordroCekGirIntegrator.ET_ITEMS();
        itemZs.item = itemZ;
        
        
        RC_BordroCekGirIntegrator.RequestModel req = new RC_BordroCekGirIntegrator.RequestModel();
        
        req.BORDRONO = '';
        req.BORDROTYPE = '';
        req.IV_BAKIYE = '';
        req.IV_ORTVADE = '';
        req.IV_SFBAKIYE = '';
        req.IV_SFORTVADE = '';
        req.CEK_ITEMS = items;
        req.ET_ITEMS = itemZs;
        
        Test.setMock(HttpCalloutMock.class, new RC_BordroCekGirIntegratorMock());
        
        Test.startTest();
        
        RC_BordroCekGirIntegrator.responseModel resp = RC_BordroCekGirIntegrator.getBordroCekGir(req);
        
        Test.stopTest();
    }
}