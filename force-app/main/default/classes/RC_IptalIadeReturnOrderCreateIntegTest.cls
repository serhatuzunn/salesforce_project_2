@isTest(SeeAllData=true)
public class RC_IptalIadeReturnOrderCreateIntegTest {
    @isTest static void unitTest(){
        test.startTest();
        
        RC_IptalIadeReturnOrderCreateIntegrator.requestModel req = new RC_IptalIadeReturnOrderCreateIntegrator.requestModel();
        
        RC_IptalIadeReturnOrderCreateIntegrator.IS_HEADER is_header = new RC_IptalIadeReturnOrderCreateIntegrator.IS_HEADER();
        RC_IptalIadeReturnOrderCreateIntegrator.IT_ITEM it_item = new RC_IptalIadeReturnOrderCreateIntegrator.IT_ITEM();
        
        
        is_header.REF_SIP_NO = '1';
        is_header.NEW_VKORG  = '1';
        is_header.NEW_VTWEG  = '1';
        is_header.NEW_SPART  = '1';
        is_header.NEW_AUART  = '1';
        is_header.NEW_USAGE  = '1';
        is_header.NEW_BSTKD  = '1';
        is_header.LIFSP      ='1';
        is_header.NEW_VSART  ='1';
        is_header.SIMULATION ='1';
        is_header.NEW_FAT_KUNNR='1';
        
        
        it_item.item = new List<RC_IptalIadeReturnOrderCreateIntegrator.Item>();
        
        
        RC_IptalIadeReturnOrderCreateIntegrator.Item item = new RC_IptalIadeReturnOrderCreateIntegrator.Item();
        item.REF_POSNR = '1';
        item.NEW_MENGE = '1';
        item.NEW_WERKS = '1';
        item.NEW_LGORT = '1';
        item.REF_FATURA= '1';
        item.REF_FAT_KALEM='1';
        
        it_item.item.Add(item);
        
        
        
        req.IS_HEADER = is_header;
        req.IT_ITEM = it_item;
        
        
        RC_IptalIadeReturnOrderCreateIntegrator.responseModel resp = new RC_IptalIadeReturnOrderCreateIntegrator.responseModel();
        resp.ET_MESSAGE = new  RC_IptalIadeReturnOrderCreateParser.ET_MESSAGE();
        resp.EV_DELIVERYDOCUMENT='';
        resp.EV_SALESDOCUMENT='';
        resp.EV_SUCCESS='';
        resp.ET_SALES_PARTNERS = new  RC_IptalIadeReturnOrderCreateParser.ET_SALES_PARTNERS();
        
        
        resp = RC_IptalIadeReturnOrderCreateIntegrator.getIptalIadeReturnOrderCreate(req);    
        RC_IptalIadeReturnOrderCreateIntegrator.Item2 i = new RC_IptalIadeReturnOrderCreateIntegrator.Item2();
        i.TYPE = 'test';
        i.ID = 'test';        
        i.MESSAGE = 'test';
        i.LOG_NO = 'test';
        i.LOG_MSG_NO = 'test';
        i.MESSAGE_V1 = 'test';
        i.MESSAGE_V2 = 'test';
        i.MESSAGE_V3 = 'test';
        i.MESSAGE_V4 = 'test';
        i.PARAMETER = 'test';
        i.ROW = 2;
        i.FIELD = 'test';        
        i.PARTN_ROLE = 'test';
        i.PARTN_NUMB = 'test';
        i.ITM_NUMBER = 'test';
        i.TITLE = 'test';
        i.NAME = 'test';
        i.NAME_2 = 'test';
        i.NAME_3 = 'test';
        i.NAME_4 = 'test';
        i.STREET = 'test';
        i.COUNTRY = 'test';
        i.COUNTR_ISO = 'test';
        i.POSTL_CODE = 'test';
        i.POBX_PCD = 'test';
        i.POBX_CTY = 'test';
        i.CITY = 'test';
        i.DISTRICT = 'test';
        i.REGION = 'test';
        i.PO_BOX = 'test';
        i.TELEPHONE = 'test';
        i.TELEPHONE2 = 'test';
        i.TELEBOX = 'test';
        i.FAX_NUMBER = 'test';
        i.TELETEX_NO = 'test';
        i.TELEX_NO = 'test';
        i.LANGU = 'test';
        i.LANGU_ISO = 'test';
        i.UNLOAD_PT = 'test';
        i.TRANSPZONE = 'test';
        i.TAXJURCODE = 'test';
        i.ADDRESS = 'test';
        i.PRIV_ADDR = 'test';
        i.ADDR_TYPE = 'test';
        i.ADDR_ORIG = 'test';
        i.ADDR_LINK = 'test';
        i.REFOBJTYPE = 'test';
        i.REFOBJKEY = 'test';
        i.REFLOGSYS = 'test';
        
        test.stopTest();
        
    }
}