@isTest
public class RC_OrtVadeBulIntegratorTest {
    @isTest
    public static void UnitTest(){
        

        RC_OrtVadeBulIntegrator.Item item = new RC_OrtVadeBulIntegrator.Item();
        item.COMP_CODE = '';
        item.CUSTOMER = '';
        item.SP_GL_IND = '';
        item.CLEAR_DATE = '';
        item.CLR_DOC_NO = '';
        item.ALLOC_NMBR = '';
        item.FISC_YEAR = '';
        item.DOC_NO = '';
        item.ITEM_NUM = '';
        item.PSTNG_DATE = '';
        item.DOC_DATE = '';
        item.ENTRY_DATE = '';
        item.CURRENCY_X = '';
        item.LOC_CURRCY = '';
        item.REF_DOC_NO = '';
        item.DOC_TYPE = '';
        item.FIS_PERIOD = '';
        item.POST_KEY = '';
        item.DB_CR_IND = '';
        item.BUS_AREA = '';
        item.TAX_CODE = '';
        item.LC_AMOUNT = '';
        item.AMT_DOCCUR = '';
        item.LC_TAX = '';
        item.TX_DOC_CUR = '';
        item.ITEM_TEXT = '';
        item.BRANCH = '';
        item.BLINE_DATE = '';
        item.PMNTTRMS = '';
        item.DSCT_DAYS1 = '';
        item.DSCT_DAYS2 = '';
        item.NETTERMS = '';
        item.DSCT_PCT1 = '';
        item.DSCT_PCT2 = '';
        item.DISC_BASE = '';
        item.DSC_AMT_LC = '';
        item.DSC_AMT_DC = '';
		item.PYMT_METH = '';
        item.PMNT_BLOCK = '';
        item.FIXEDTERMS = '';
        item.INV_REF = '';
        item.INV_YEAR = '';
        item.INV_ITEM = '';
        item.DUNN_BLOCK = '';
        item.DUNN_KEY = '';
        item.LAST_DUNN = '';
        item.DUNN_LEVEL = '';
        item.DUNN_AREA = '';
        item.DOC_STATUS = '';
        item.NXT_DOCTYP = '';
        item.VAT_REG_NO = '';
        item.REASON_CDE = '';
        item.PMTMTHSUPL = '';
        item.REF_KEY_1 = '';
        item.REF_KEY_2 = '';
        item.T_CURRENCY = '';
        item.AMOUNT = '';
        item.NET_AMOUNT = '';
        item.NAME = '';
        item.NAME_2 = '';
        item.NAME_3 = '';
        item.NAME_4 = '';
        item.POSTL_CODE = '';
        item.CITY = '';
        item.COUNTRY = '';
        item.STREET = '';
        item.PO_BOX = '';
        item.POBX_PCD = '';
        item.POBK_CURAC = '';
        item.BANK_ACCT = '';
        item.BANK_KEY = '';
        item.BANK_CTRY = '';
        item.TAX_NO_1 = '';
        item.TAX_NO_2 = '';
        item.TAX = '';
        item.EQUAL_TAX = '';
        item.REGION = '';
        item.CTRL_KEY = '';
        item.INSTR_KEY = '';
        item.PAYEE_CODE = '';
        item.LANGU = '';
        item.BILL_LIFE = '';
        item.BE_TAXCODE = '';
        item.BILLTAX_LC = '';
        item.BILLTAX_FC = '';
        item.LC_COL_CHG = '';
        item.COLL_CHARG = '';
        item.CHGS_TX_CD = '';
        item.ISSUE_DATE = '';
        item.USAGEDATE = '';
        item.BILL_USAGE = '';
        item.DOMICILE = '';
        item.DRAWER = '';
        item.CTRBNK_LOC = '';
        item.DRAW_CITY1 = '';
        item.DRAWEE = '';
        item.DRAW_CITY2 = '';
        item.DISCT_DAYS = '';
        item.DISCT_RATE = '';
        item.ACCEPTED = '';
        item.BILLSTATUS = '';
        item.PRTEST_IND = '';
        item.BE_DEMAND = '';
        item.OBJ_TYPE = '';
        item.REF_DOC = '';
        item.REF_ORG_UN = '';
        item.REVERSAL_DOC = '';
        item.SP_GL_TYPE = '';
        item.NEG_POSTNG = '';
        item.REF_DOC_NO_LONG = '';
        item.BILL_DOC = '';

        RC_OrtVadeBulIntegrator.IT_LINEITEMS lineItems = new RC_OrtVadeBulIntegrator.IT_LINEITEMS();
        lineItems.item = item;
        
        RC_OrtVadeBulIntegrator.RequestModel req = new RC_OrtVadeBulIntegrator.RequestModel();
        req.IT_LINEITEMS = lineItems;
        
        Test.setMock(HttpCalloutMock.class, new RC_OrtVadeBulIntegratorMock());
        
        Test.startTest();
        
        RC_OrtVadeBulIntegrator.responseModel resp = RC_OrtVadeBulIntegrator.getOrtVadeBul(req);
        
        Test.stopTest();
    }
}