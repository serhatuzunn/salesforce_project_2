@IsTest
public class RC_BABSDetayParserTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"T_BSDETAY\": {'+
		'        \"item\": ['+ 
		'            {'+
		'                \"MANDT\": \"021\",'+
		'                \"DONEM\": \"000000\",'+
		'                \"BLGTUR\": \"BS\",'+
		'                \"BUDAT\": \"30-09-2013\",'+
		'                \"CPUDT\": \"30-09-2013\",'+
		'                \"BELNR\": \"0232113104\",'+
		'                \"MUHATAP\": \"0029900009\",'+
		'                \"NAME1\": \"ARIZİ\",'+
		'                \"ULKE\": \"TR\",'+
		'                \"VKN\": \"\",'+
		'                \"TCN\": \"\",'+
		'                \"MWSKZ\": \"\",'+
		'                \"ADET\": 1,'+
		'                \"DMBTR\": \"134.00\",'+
		'                \"KDV\": -20.44,'+
		'                \"MATRAH\": 113.56'+
		'            }'+
		']'+
		'}'+
		'}';
		RC_BABSDetayParser r = RC_BABSDetayParser.parse(json);
		System.assert(r != null);

        /*
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BABSDetayParser.Item objItem = new RC_BABSDetayParser.Item(System.JSON.createParser(json));
		System.assert(objItem != null);
		System.assert(objItem.MANDT == null);
		System.assert(objItem.DONEM == null);
		System.assert(objItem.BLGTUR == null);
		System.assert(objItem.BUDAT == null);
		System.assert(objItem.CPUDT == null);
		System.assert(objItem.BELNR == null);
		System.assert(objItem.MUHATAP == null);
		System.assert(objItem.NAME1 == null);
		System.assert(objItem.ULKE == null);
		System.assert(objItem.VKN == null);
		System.assert(objItem.TCN == null);
		System.assert(objItem.MWSKZ == null);
		System.assert(objItem.ADET == null);
		System.assert(objItem.DMBTR == null);
		System.assert(objItem.KDV == null);
		System.assert(objItem.MATRAH == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BABSDetayParser objRC_BABSDetayParser = new RC_BABSDetayParser(System.JSON.createParser(json));
		System.assert(objRC_BABSDetayParser != null);
		System.assert(objRC_BABSDetayParser.T_BSDETAY == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BABSDetayParser.T_BSDETAY objT_BSDETAY = new RC_BABSDetayParser.T_BSDETAY(System.JSON.createParser(json));
		System.assert(objT_BSDETAY != null);
		System.assert(objT_BSDETAY.item == null);
*/
	}
}