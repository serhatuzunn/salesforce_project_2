@IsTest
public class RC_GetGiftVoucherStatuParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"EV_CEKNO\": 1'+
		'}';
		RC_GetGiftVoucherStatuParser obj = RC_GetGiftVoucherStatuParser.parse(json);
		System.assert(obj != null);
	}
}