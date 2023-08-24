public class RC_OrtVadeBulIntegratorParser {

	public class Item {
		public String COMP_CODE {get;set;} 
		public String CUSTOMER {get;set;} 
		public String SP_GL_IND {get;set;} 
		public String CLEAR_DATE {get;set;} 
		public String CLR_DOC_NO {get;set;} 
		public String ALLOC_NMBR {get;set;} 
		public String FISC_YEAR {get;set;} 
		public String DOC_NO {get;set;} 
		public String ITEM_NUM {get;set;} 
		public String PSTNG_DATE {get;set;} 
		public String DOC_DATE {get;set;} 
		public String ENTRY_DATE {get;set;} 
		public String CURRENCY_Z {get;set;} // in json: CURRENCY
		public String LOC_CURRCY {get;set;} 
		public String REF_DOC_NO {get;set;} 
		public String DOC_TYPE {get;set;} 
		public String FIS_PERIOD {get;set;} 
		public String POST_KEY {get;set;} 
		public String DB_CR_IND {get;set;} 
		public String BUS_AREA {get;set;} 
		public String TAX_CODE {get;set;} 
		public String LC_AMOUNT {get;set;} 
		public String AMT_DOCCUR {get;set;} 
		public String LC_TAX {get;set;} 
		public String TX_DOC_CUR {get;set;} 
		public String ITEM_TEXT {get;set;} 
		public String BRANCH {get;set;} 
		public String BLINE_DATE {get;set;} 
		public String PMNTTRMS {get;set;} 
		public String DSCT_DAYS1 {get;set;} 
		public String DSCT_DAYS2 {get;set;} 
		public String NETTERMS {get;set;} 
		public String DSCT_PCT1 {get;set;} 
		public String DSCT_PCT2 {get;set;} 
		public String DISC_BASE {get;set;} 
		public String DSC_AMT_LC {get;set;} 
		public String DSC_AMT_DC {get;set;} 
		public String PYMT_METH {get;set;} 
		public String PMNT_BLOCK {get;set;} 
		public String FIXEDTERMS {get;set;} 
		public String INV_REF {get;set;} 
		public String INV_YEAR {get;set;} 
		public String INV_ITEM {get;set;} 
		public String DUNN_BLOCK {get;set;} 
		public String DUNN_KEY {get;set;} 
		public String LAST_DUNN {get;set;} 
		public String DUNN_LEVEL {get;set;} 
		public String DUNN_AREA {get;set;} 
		public String DOC_STATUS {get;set;} 
		public String NXT_DOCTYP {get;set;} 
		public String VAT_REG_NO {get;set;} 
		public String REASON_CDE {get;set;} 
		public String PMTMTHSUPL {get;set;} 
		public String REF_KEY_1 {get;set;} 
		public String REF_KEY_2 {get;set;} 
		public String T_CURRENCY {get;set;} 
		public String AMOUNT {get;set;} 
		public String NET_AMOUNT {get;set;} 
		public String NAME {get;set;} 
		public String NAME_2 {get;set;} 
		public String NAME_3 {get;set;} 
		public String NAME_4 {get;set;} 
		public String POSTL_CODE {get;set;} 
		public String CITY {get;set;} 
		public String COUNTRY {get;set;} 
		public String STREET {get;set;} 
		public String PO_BOX {get;set;} 
		public String POBX_PCD {get;set;} 
		public String POBK_CURAC {get;set;} 
		public String BANK_ACCT {get;set;} 
		public String BANK_KEY {get;set;} 
		public String BANK_CTRY {get;set;} 
		public String TAX_NO_1 {get;set;} 
		public String TAX_NO_2 {get;set;} 
		public String TAX {get;set;} 
		public String EQUAL_TAX {get;set;} 
		public String REGION {get;set;} 
		public String CTRL_KEY {get;set;} 
		public String INSTR_KEY {get;set;} 
		public String PAYEE_CODE {get;set;} 
		public String LANGU {get;set;} 
		public String BILL_LIFE {get;set;} 
		public String BE_TAXCODE {get;set;} 
		public String BILLTAX_LC {get;set;} 
		public String BILLTAX_FC {get;set;} 
		public String LC_COL_CHG {get;set;} 
		public String COLL_CHARG {get;set;} 
		public String CHGS_TX_CD {get;set;} 
		public String ISSUE_DATE {get;set;} 
		public String USAGEDATE {get;set;} 
		public String BILL_USAGE {get;set;} 
		public String DOMICILE {get;set;} 
		public String DRAWER {get;set;} 
		public String CTRBNK_LOC {get;set;} 
		public String DRAW_CITY1 {get;set;} 
		public String DRAWEE {get;set;} 
		public String DRAW_CITY2 {get;set;} 
		public String DISCT_DAYS {get;set;} 
		public String DISCT_RATE {get;set;} 
		public String ACCEPTED {get;set;} 
		public String BILLSTATUS {get;set;} 
		public String PRTEST_IND {get;set;} 
		public String BE_DEMAND {get;set;} 
		public String OBJ_TYPE {get;set;} 
		public String REF_DOC {get;set;} 
		public String REF_ORG_UN {get;set;} 
		public String REVERSAL_DOC {get;set;} 
		public String SP_GL_TYPE {get;set;} 
		public String NEG_POSTNG {get;set;} 
		public String REF_DOC_NO_LONG {get;set;} 
		public String BILL_DOC {get;set;} 

		public Item(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'COMP_CODE') {
							COMP_CODE = parser.getText();
						} else if (text == 'CUSTOMER') {
							CUSTOMER = parser.getText();
						} else if (text == 'SP_GL_IND') {
							SP_GL_IND = parser.getText();
						} else if (text == 'CLEAR_DATE') {
							CLEAR_DATE = parser.getText();
						} else if (text == 'CLR_DOC_NO') {
							CLR_DOC_NO = parser.getText();
						} else if (text == 'ALLOC_NMBR') {
							ALLOC_NMBR = parser.getText();
						} else if (text == 'FISC_YEAR') {
							FISC_YEAR = parser.getText();
						} else if (text == 'DOC_NO') {
							DOC_NO = parser.getText();
						} else if (text == 'ITEM_NUM') {
							ITEM_NUM = parser.getText();
						} else if (text == 'PSTNG_DATE') {
							PSTNG_DATE = parser.getText();
						} else if (text == 'DOC_DATE') {
							DOC_DATE = parser.getText();
						} else if (text == 'ENTRY_DATE') {
							ENTRY_DATE = parser.getText();
						} else if (text == 'CURRENCY') {
							CURRENCY_Z = parser.getText();
						} else if (text == 'LOC_CURRCY') {
							LOC_CURRCY = parser.getText();
						} else if (text == 'REF_DOC_NO') {
							REF_DOC_NO = parser.getText();
						} else if (text == 'DOC_TYPE') {
							DOC_TYPE = parser.getText();
						} else if (text == 'FIS_PERIOD') {
							FIS_PERIOD = parser.getText();
						} else if (text == 'POST_KEY') {
							POST_KEY = parser.getText();
						} else if (text == 'DB_CR_IND') {
							DB_CR_IND = parser.getText();
						} else if (text == 'BUS_AREA') {
							BUS_AREA = parser.getText();
						} else if (text == 'TAX_CODE') {
							TAX_CODE = parser.getText();
						} else if (text == 'LC_AMOUNT') {
							LC_AMOUNT = parser.getText();
						} else if (text == 'AMT_DOCCUR') {
							AMT_DOCCUR = parser.getText();
						} else if (text == 'LC_TAX') {
							LC_TAX = parser.getText();
						} else if (text == 'TX_DOC_CUR') {
							TX_DOC_CUR = parser.getText();
						} else if (text == 'ITEM_TEXT') {
							ITEM_TEXT = parser.getText();
						} else if (text == 'BRANCH') {
							BRANCH = parser.getText();
						} else if (text == 'BLINE_DATE') {
							BLINE_DATE = parser.getText();
						} else if (text == 'PMNTTRMS') {
							PMNTTRMS = parser.getText();
						} else if (text == 'DSCT_DAYS1') {
							DSCT_DAYS1 = parser.getText();
						} else if (text == 'DSCT_DAYS2') {
							DSCT_DAYS2 = parser.getText();
						} else if (text == 'NETTERMS') {
							NETTERMS = parser.getText();
						} else if (text == 'DSCT_PCT1') {
							DSCT_PCT1 = parser.getText();
						} else if (text == 'DSCT_PCT2') {
							DSCT_PCT2 = parser.getText();
						} else if (text == 'DISC_BASE') {
							DISC_BASE = parser.getText();
						} else if (text == 'DSC_AMT_LC') {
							DSC_AMT_LC = parser.getText();
						} else if (text == 'DSC_AMT_DC') {
							DSC_AMT_DC = parser.getText();
						} else if (text == 'PYMT_METH') {
							PYMT_METH = parser.getText();
						} else if (text == 'PMNT_BLOCK') {
							PMNT_BLOCK = parser.getText();
						} else if (text == 'FIXEDTERMS') {
							FIXEDTERMS = parser.getText();
						} else if (text == 'INV_REF') {
							INV_REF = parser.getText();
						} else if (text == 'INV_YEAR') {
							INV_YEAR = parser.getText();
						} else if (text == 'INV_ITEM') {
							INV_ITEM = parser.getText();
						} else if (text == 'DUNN_BLOCK') {
							DUNN_BLOCK = parser.getText();
						} else if (text == 'DUNN_KEY') {
							DUNN_KEY = parser.getText();
						} else if (text == 'LAST_DUNN') {
							LAST_DUNN = parser.getText();
						} else if (text == 'DUNN_LEVEL') {
							DUNN_LEVEL = parser.getText();
						} else if (text == 'DUNN_AREA') {
							DUNN_AREA = parser.getText();
						} else if (text == 'DOC_STATUS') {
							DOC_STATUS = parser.getText();
						} else if (text == 'NXT_DOCTYP') {
							NXT_DOCTYP = parser.getText();
						} else if (text == 'VAT_REG_NO') {
							VAT_REG_NO = parser.getText();
						} else if (text == 'REASON_CDE') {
							REASON_CDE = parser.getText();
						} else if (text == 'PMTMTHSUPL') {
							PMTMTHSUPL = parser.getText();
						} else if (text == 'REF_KEY_1') {
							REF_KEY_1 = parser.getText();
						} else if (text == 'REF_KEY_2') {
							REF_KEY_2 = parser.getText();
						} else if (text == 'T_CURRENCY') {
							T_CURRENCY = parser.getText();
						} else if (text == 'AMOUNT') {
							AMOUNT = parser.getText();
						} else if (text == 'NET_AMOUNT') {
							NET_AMOUNT = parser.getText();
						} else if (text == 'NAME') {
							NAME = parser.getText();
						} else if (text == 'NAME_2') {
							NAME_2 = parser.getText();
						} else if (text == 'NAME_3') {
							NAME_3 = parser.getText();
						} else if (text == 'NAME_4') {
							NAME_4 = parser.getText();
						} else if (text == 'POSTL_CODE') {
							POSTL_CODE = parser.getText();
						} else if (text == 'CITY') {
							CITY = parser.getText();
						} else if (text == 'COUNTRY') {
							COUNTRY = parser.getText();
						} else if (text == 'STREET') {
							STREET = parser.getText();
						} else if (text == 'PO_BOX') {
							PO_BOX = parser.getText();
						} else if (text == 'POBX_PCD') {
							POBX_PCD = parser.getText();
						} else if (text == 'POBK_CURAC') {
							POBK_CURAC = parser.getText();
						} else if (text == 'BANK_ACCT') {
							BANK_ACCT = parser.getText();
						} else if (text == 'BANK_KEY') {
							BANK_KEY = parser.getText();
						} else if (text == 'BANK_CTRY') {
							BANK_CTRY = parser.getText();
						} else if (text == 'TAX_NO_1') {
							TAX_NO_1 = parser.getText();
						} else if (text == 'TAX_NO_2') {
							TAX_NO_2 = parser.getText();
						} else if (text == 'TAX') {
							TAX = parser.getText();
						} else if (text == 'EQUAL_TAX') {
							EQUAL_TAX = parser.getText();
						} else if (text == 'REGION') {
							REGION = parser.getText();
						} else if (text == 'CTRL_KEY') {
							CTRL_KEY = parser.getText();
						} else if (text == 'INSTR_KEY') {
							INSTR_KEY = parser.getText();
						} else if (text == 'PAYEE_CODE') {
							PAYEE_CODE = parser.getText();
						} else if (text == 'LANGU') {
							LANGU = parser.getText();
						} else if (text == 'BILL_LIFE') {
							BILL_LIFE = parser.getText();
						} else if (text == 'BE_TAXCODE') {
							BE_TAXCODE = parser.getText();
						} else if (text == 'BILLTAX_LC') {
							BILLTAX_LC = parser.getText();
						} else if (text == 'BILLTAX_FC') {
							BILLTAX_FC = parser.getText();
						} else if (text == 'LC_COL_CHG') {
							LC_COL_CHG = parser.getText();
						} else if (text == 'COLL_CHARG') {
							COLL_CHARG = parser.getText();
						} else if (text == 'CHGS_TX_CD') {
							CHGS_TX_CD = parser.getText();
						} else if (text == 'ISSUE_DATE') {
							ISSUE_DATE = parser.getText();
						} else if (text == 'USAGEDATE') {
							USAGEDATE = parser.getText();
						} else if (text == 'BILL_USAGE') {
							BILL_USAGE = parser.getText();
						} else if (text == 'DOMICILE') {
							DOMICILE = parser.getText();
						} else if (text == 'DRAWER') {
							DRAWER = parser.getText();
						} else if (text == 'CTRBNK_LOC') {
							CTRBNK_LOC = parser.getText();
						} else if (text == 'DRAW_CITY1') {
							DRAW_CITY1 = parser.getText();
						} else if (text == 'DRAWEE') {
							DRAWEE = parser.getText();
						} else if (text == 'DRAW_CITY2') {
							DRAW_CITY2 = parser.getText();
						} else if (text == 'DISCT_DAYS') {
							DISCT_DAYS = parser.getText();
						} else if (text == 'DISCT_RATE') {
							DISCT_RATE = parser.getText();
						} else if (text == 'ACCEPTED') {
							ACCEPTED = parser.getText();
						} else if (text == 'BILLSTATUS') {
							BILLSTATUS = parser.getText();
						} else if (text == 'PRTEST_IND') {
							PRTEST_IND = parser.getText();
						} else if (text == 'BE_DEMAND') {
							BE_DEMAND = parser.getText();
						} else if (text == 'OBJ_TYPE') {
							OBJ_TYPE = parser.getText();
						} else if (text == 'REF_DOC') {
							REF_DOC = parser.getText();
						} else if (text == 'REF_ORG_UN') {
							REF_ORG_UN = parser.getText();
						} else if (text == 'REVERSAL_DOC') {
							REVERSAL_DOC = parser.getText();
						} else if (text == 'SP_GL_TYPE') {
							SP_GL_TYPE = parser.getText();
						} else if (text == 'NEG_POSTNG') {
							NEG_POSTNG = parser.getText();
						} else if (text == 'REF_DOC_NO_LONG') {
							REF_DOC_NO_LONG = parser.getText();
						} else if (text == 'BILL_DOC') {
							BILL_DOC = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Item consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class IT_LINEITEMS {
		public List<Item> item {get;set;} 

		public IT_LINEITEMS(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'IT_LINEITEMS consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String EV_BAKIYE {get;set;} 
	public String EV_ORTVADE {get;set;} 
	public IT_LINEITEMS IT_LINEITEMS {get;set;} 

	public RC_OrtVadeBulIntegratorParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'EV_BAKIYE') {
						EV_BAKIYE = parser.getText();
					} else if (text == 'EV_ORTVADE') {
						EV_ORTVADE = parser.getText();
					} else if (text == 'IT_LINEITEMS') {
						IT_LINEITEMS = new IT_LINEITEMS(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'OrtVadeBulIntegratorParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static RC_OrtVadeBulIntegratorParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_OrtVadeBulIntegratorParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	



    private static List<Item> arrayOfItem(System.JSONParser p) {
        List<Item> res = new List<Item>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Item(p));
        }
        return res;
    }



}