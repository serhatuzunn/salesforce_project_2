@IsTest
public class RC_GetVestelCellParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"ES_CEK_S\": {'+
		'        \"KEY_ID\": \"0000000604\",'+
		'        \"CAMPAIGN_KEY\": \"VC5LKPGQ\",'+
		'        \"MSISDN\": 5337643771,'+
		'        \"TARIFFID\": 2314,'+
		'        \"USED_INVOICEID\": \"0000000000\",'+
		'        \"USED_INVOICEDETAILID\": \"0000000000\",'+
		'        \"USED_AT\": 0,'+
		'        \"USED_BY\": \"\",'+
		'        \"CREATED_AT\": 20211030120728,'+
		'        \"GUID\": \"\",'+
		'        \"KEY_STATUS\": \"3\",'+
		'        \"USED_BAYI\": \"\"'+
		'    },'+
		'    \"EV_MESSAGE\": \"\",'+
		'    \"EV_SUCCESS\": \"X\"'+
		'}';
		RC_GetVestelCellParser obj = RC_GetVestelCellParser.parse(json);
		System.assert(obj != null);
	}
}