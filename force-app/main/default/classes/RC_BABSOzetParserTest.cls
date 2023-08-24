@IsTest
public class RC_BABSOzetParserTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"T_BADET\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"MANDT\": \"021\",'+
		'                \"DONEM\": \"000000\",'+
		'                \"SIRA\": \"02050\",'+
		'                \"BLGTUR\": \"BA\",'+
		'                \"MUHATAP\": \"0029900009\",'+
		'                \"NAME1\": \"\",'+
		'                \"ULKE\": \"\",'+
		'                \"VKN\": \"\",'+
		'                \"TCN\": \"\",'+
		'                \"ADET\": -9596,'+
		'                \"MATRAH\": -5683439.07'+
		'            },'+
		'            {'+
		'                \"MANDT\": \"021\",'+
		'                \"DONEM\": \"000000\",'+
		'                \"SIRA\": \"01236\",'+
		'                \"BLGTUR\": \"BA\",'+
		'                \"MUHATAP\": \"0029900009\",'+
		'                \"NAME1\": \"\",'+
		'                \"ULKE\": \"\",'+
		'                \"VKN\": \"\",'+
		'                \"TCN\": \"\",'+
		'                \"ADET\": -6461,'+
		'                \"MATRAH\": -6816266.45'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"T_BSDET\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"MANDT\": \"021\",'+
		'                \"DONEM\": \"000000\",'+
		'                \"SIRA\": \"00505\",'+
		'                \"BLGTUR\": \"BS\",'+
		'                \"MUHATAP\": \"0029900009\",'+
		'                \"NAME1\": \"ARIZİ\",'+
		'                \"ULKE\": \"TR\",'+
		'                \"VKN\": \"\",'+
		'                \"TCN\": \"\",'+
		'                \"ADET\": 6457,'+
		'                \"MATRAH\": 2328933.94'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		RC_BABSOzetParser r = RC_BABSOzetParser.parse(json);
		System.assert(r != null);
		/*
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BABSOzetParser.Item objItem = new RC_BABSOzetParser.Item(System.JSON.createParser(json));
		System.assert(objItem != null);
		System.assert(objItem.MANDT == null);
		System.assert(objItem.DONEM == null);
		System.assert(objItem.SIRA == null);
		System.assert(objItem.BLGTUR == null);
		System.assert(objItem.MUHATAP == null);
		System.assert(objItem.NAME1 == null);
		System.assert(objItem.ULKE == null);
		System.assert(objItem.VKN == null);
		System.assert(objItem.TCN == null);
		System.assert(objItem.ADET == null);
		System.assert(objItem.MATRAH == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BABSOzetParser.T_BADET objT_BADET = new RC_BABSOzetParser.T_BADET(System.JSON.createParser(json));
		System.assert(objT_BADET != null);
		System.assert(objT_BADET.item == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BABSOzetParser objRC_BABSOzetParser = new RC_BABSOzetParser(System.JSON.createParser(json));
		System.assert(objRC_BABSOzetParser != null);
		System.assert(objRC_BABSOzetParser.T_BADET == null);
		System.assert(objRC_BABSOzetParser.T_BSDET == null);
*/
	}
}