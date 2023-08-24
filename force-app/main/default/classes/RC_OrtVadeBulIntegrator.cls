public class RC_OrtVadeBulIntegrator {
    
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
        public String CURRENCY_X {get;set;} //CURRENCY
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
    }
    
    public class IT_LINEITEMS {
        public Item item {get;set;}
    }
    
    public class RequestModel {
        @AuraEnabled
        public IT_LINEITEMS IT_LINEITEMS {get;set;}
    }
    
    public class ResponseModel{
        @AuraEnabled
        public RC_OrtVadeBulIntegratorParser OrtVadeBulResponse {get;set;}
    }
    
    public static ResponseModel getOrtVadeBul(RequestModel req){
        try {
            String url = 'RESTAdapter/salesforce/fi_ortvade_bul';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req).replace('CURRENCY_X', 'CURRENCY'));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            ResponseModel resp = new ResponseModel();
            if(response.getStatus() == 'OK'){
                RC_OrtVadeBulIntegratorParser parseResult = RC_OrtVadeBulIntegratorParser.parse(response.getBody());
                
                resp.OrtVadeBulResponse = parseResult;
                return resp;
            }
            
            return resp;
            
        }
        
        catch(Exception ex){
            system.debug('ex : ' + ex);
            RC_Logger.LOG_EXCEPTION('Error : RC_OrtVadeBulIntegrator', 'Integrator Error', ex.getMessage(), 'RC_OrtVadeBulIntegrator', 'getOrtVadeBul', '');

            return null;
        }
    }
}