@IsTest
public class RC_AcikKalemlerParserTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_ITEMS\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"BELNR\": 5130021877,'+
		'                \"BUZEI\": \"001\",'+
		'                \"KUNNR\": \"0022201781\",'+
		'                \"BUDAT\": \"28-12-2020\",'+
		'                \"ZFBDT\": \"27-04-2021\",'+
		'                \"WAERS\": \"TRY\",'+
		'                \"DMBTR\": \"-494700.00\",'+
		'                \"SGTXT\": \"Bayi Diğer Primler\",'+
		'                \"BLART\": \"MA\",'+
		'                \"AWKEY\": \"0130254523\",'+
		'                \"GJAHR\": 2020,'+
		'                \"ZLSPR\": \"\",'+
		'                \"ZLSCH\": \"\",'+
		'                \"LTEXT\": \"Müşteriden Alış Fat.\",'+
		'                \"MATNR\": {'+
		'                    \"item\": ['+
		'                        {'+
		'                            \"MATNR\": \"000000000000001148\",'+
		'                            \"MAKTX\": \"Ahb prim bedeli Beyaz Eşya\",'+
		'                            \"FKIMG\": \"1.000\",'+
		'                            \"VRKME\": \"ST\"'+
		'                        },'+
		'                        {'+
		'                            \"MATNR\": \"000000000000001189\",'+
		'                            \"MAKTX\": \"Ahb Prim Bedeli (TV)\",'+
		'                            \"FKIMG\": \"1.000\",'+
		'                            \"VRKME\": \"ST\"'+
		'                        }'+
		'                    ]'+
		'                },'+
		'                \"MAKTX\": \"\",'+
		'                \"KKBER\": \"0007\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"EV_BAKIYE\": \"12126701.2700\",'+
		'    \"EV_ORTVADE\": \"23-04-2021\",'+
		'    \"EV_TOTAL_IND\": 1882'+
		'}';
		RC_AcikKalemlerParser r = RC_AcikKalemlerParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AcikKalemlerParser.Item objItem = new RC_AcikKalemlerParser.Item(System.JSON.createParser(json));
		System.assert(objItem != null);
		System.assert(objItem.MATNR == null);
		System.assert(objItem.MAKTX == null);
		System.assert(objItem.FKIMG == null);
		System.assert(objItem.VRKME == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AcikKalemlerParser.ET_ITEMS objET_ITEMS = new RC_AcikKalemlerParser.ET_ITEMS(System.JSON.createParser(json));
		System.assert(objET_ITEMS != null);
		System.assert(objET_ITEMS.item == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AcikKalemlerParser objRC_AcikKalemlerParser = new RC_AcikKalemlerParser(System.JSON.createParser(json));
		System.assert(objRC_AcikKalemlerParser != null);
		System.assert(objRC_AcikKalemlerParser.ET_ITEMS == null);
		System.assert(objRC_AcikKalemlerParser.EV_BAKIYE == null);
		System.assert(objRC_AcikKalemlerParser.EV_ORTVADE == null);
		System.assert(objRC_AcikKalemlerParser.EV_TOTAL_IND == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AcikKalemlerParser.Item_Z objItem_Z = new RC_AcikKalemlerParser.Item_Z(System.JSON.createParser(json));
		System.assert(objItem_Z != null);
		System.assert(objItem_Z.BELNR == null);
		System.assert(objItem_Z.BUZEI == null);
		System.assert(objItem_Z.KUNNR == null);
		System.assert(objItem_Z.BUDAT == null);
		System.assert(objItem_Z.ZFBDT == null);
		System.assert(objItem_Z.WAERS == null);
		System.assert(objItem_Z.DMBTR == null);
		System.assert(objItem_Z.SGTXT == null);
		System.assert(objItem_Z.BLART == null);
		System.assert(objItem_Z.AWKEY == null);
		System.assert(objItem_Z.GJAHR == null);
		System.assert(objItem_Z.ZLSPR == null);
		System.assert(objItem_Z.ZLSCH == null);
		System.assert(objItem_Z.LTEXT == null);
		System.assert(objItem_Z.MATNR == null);
		System.assert(objItem_Z.MAKTX == null);
		System.assert(objItem_Z.KKBER == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AcikKalemlerParser.MATNR objMATNR = new RC_AcikKalemlerParser.MATNR(System.JSON.createParser(json));
		System.assert(objMATNR != null);
		System.assert(objMATNR.item == null);
	}
}