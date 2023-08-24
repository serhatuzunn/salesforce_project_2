@IsTest
public class RC_FI_OrtalamaVadeJsonParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"EV_BAKIYE\": \"3000.0000\",'+
		'    \"EV_ORTVADE\": \"2020-01-01\",'+
		'    \"IT_LINEITEMS\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"BLINE_DATE\": \"01-01-2020\",'+
		'                \"DSCT_DAYS1\": 0,'+
		'                \"PSTNG_DATE\": \"01-01-2020\",'+
		'                \"DB_CR_IND\": \"S\",'+
		'                \"LC_AMOUNT\": \"3000.0000\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		RC_FI_OrtalamaVadeJsonParser r = RC_FI_OrtalamaVadeJsonParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_FI_OrtalamaVadeJsonParser.Item objItem = new RC_FI_OrtalamaVadeJsonParser.Item(System.JSON.createParser(json));
		System.assert(objItem != null);
		System.assert(objItem.BLINE_DATE == null);
		System.assert(objItem.DSCT_DAYS1 == null);
		System.assert(objItem.PSTNG_DATE == null);
		System.assert(objItem.DB_CR_IND == null);
		System.assert(objItem.LC_AMOUNT == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_FI_OrtalamaVadeJsonParser.IT_LINEITEMS objIT_LINEITEMS = new RC_FI_OrtalamaVadeJsonParser.IT_LINEITEMS(System.JSON.createParser(json));
		System.assert(objIT_LINEITEMS != null);
		System.assert(objIT_LINEITEMS.item == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_FI_OrtalamaVadeJsonParser objRC_FI_OrtalamaVadeJsonParser = new RC_FI_OrtalamaVadeJsonParser(System.JSON.createParser(json));
		System.assert(objRC_FI_OrtalamaVadeJsonParser != null);
		System.assert(objRC_FI_OrtalamaVadeJsonParser.EV_BAKIYE == null);
		System.assert(objRC_FI_OrtalamaVadeJsonParser.EV_ORTVADE == null);
		System.assert(objRC_FI_OrtalamaVadeJsonParser.IT_LINEITEMS == null);
	}
}