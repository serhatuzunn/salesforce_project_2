@IsTest
public class RC_SD_CreateCustomerParserTest {

	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_MESSAGES\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"TYPE\": \"\",'+
		'                \"ID\": \"E\",'+
		'                \"NUMBER\": \"000\",'+
		'                \"MESSAGE\": \"Aynı vergi numarası 0020302091 için kullanılmıştır!\",'+
		'                \"LOG_NO\": \"\",'+
		'                \"LOG_MSG_NO\": \"000000\",'+
		'                \"MESSAGE_V1\": \"\",'+
		'                \"MESSAGE_V2\": \"\",'+
		'                \"MESSAGE_V3\": \"\",'+
		'                \"MESSAGE_V4\": \"\",'+
		'                \"PARAMETER\": \"\",'+
		'                \"ROW\": 0,'+
		'                \"FIELD\": \"\",'+
		'                \"SYSTEM\": \"\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"EV_CUSTOMER_NO\": \"\"'+
		'}';
		RC_SD_CreateCustomerParser r = RC_SD_CreateCustomerParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_SD_CreateCustomerParser.Item objItem = new RC_SD_CreateCustomerParser.Item(System.JSON.createParser(json));
		System.assert(objItem != null);
		System.assert(objItem.TYPE == null);
		System.assert(objItem.ID == null);
		System.assert(objItem.NUMBER_Z == null);
		System.assert(objItem.MESSAGE == null);
		System.assert(objItem.LOG_NO == null);
		System.assert(objItem.LOG_MSG_NO == null);
		System.assert(objItem.MESSAGE_V1 == null);
		System.assert(objItem.MESSAGE_V2 == null);
		System.assert(objItem.MESSAGE_V3 == null);
		System.assert(objItem.MESSAGE_V4 == null);
		System.assert(objItem.PARAMETER == null);
		System.assert(objItem.ROW == null);
		System.assert(objItem.FIELD == null);
		System.assert(objItem.SYSTEM_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_SD_CreateCustomerParser.ET_MESSAGES objET_MESSAGES = new RC_SD_CreateCustomerParser.ET_MESSAGES(System.JSON.createParser(json));
		System.assert(objET_MESSAGES != null);
		System.assert(objET_MESSAGES.item == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_SD_CreateCustomerParser objRC_SD_CreateCustomerParser = new RC_SD_CreateCustomerParser(System.JSON.createParser(json));
		System.assert(objRC_SD_CreateCustomerParser != null);
		System.assert(objRC_SD_CreateCustomerParser.ET_MESSAGES == null);
		System.assert(objRC_SD_CreateCustomerParser.EV_CUSTOMER_NO == null);
	}
}