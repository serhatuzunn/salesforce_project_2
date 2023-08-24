@IsTest
public class RC_BordroCekGirParser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_RETURN\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"TYPE\": \"S\",'+
		'                \"ID\": \"\",'+
		'                \"NUMBER\": \"000\",'+
		'                \"MESSAGE\": \"Giriş işlemi başarılı.\",'+
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
		'    \"CEK_ITEMS\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"BOENUM\": 99076543,'+
		'                \"BUDAT\": \"10-09-2021\",'+
		'                \"PORTFO\": \"C01\",'+
		'                \"KUNNR\": 22201781,'+
		'                \"ZFBDT\": \"30-06-2021\",'+
		'                \"XSIWE\": \"\",'+
		'                \"WAERS\": \"TRY\",'+
		'                \"WRBTR\": 56.01,'+
		'                \"BANKL\": \"0064-01260\",'+
		'                \"BANKN\": 177005,'+
		'                \"NAME1\": \"\",'+
		'                \"BOLGE\": \"İSTANBUL\",'+
		'                \"STCEG\": 11223344789,'+
		'                \"FATURA\": \"\",'+
		'                \"VKBUR\": \"\",'+
		'                \"HZUON\": 11223344789'+
		'            },'+
		'            {'+
		'                \"BOENUM\": 99076544,'+
		'                \"BUDAT\": \"11-09-2021\",'+
		'                \"PORTFO\": \"C01\",'+
		'                \"KUNNR\": 22201781,'+
		'                \"ZFBDT\": \"30-06-2021\",'+
		'                \"XSIWE\": \"\",'+
		'                \"WAERS\": \"TRY\",'+
		'                \"WRBTR\": 56.01,'+
		'                \"BANKL\": \"0064-01260\",'+
		'                \"BANKN\": 177005,'+
		'                \"NAME1\": \"\",'+
		'                \"BOLGE\": \"İSTANBUL\",'+
		'                \"STCEG\": 11223344789,'+
		'                \"FATURA\": \"\",'+
		'                \"VKBUR\": \"\",'+
		'                \"HZUON\": 11223344789'+
		'            },'+
		'            {'+
		'                \"BOENUM\": 99076545,'+
		'                \"BUDAT\": \"12-09-2021\",'+
		'                \"PORTFO\": \"C01\",'+
		'                \"KUNNR\": 22201781,'+
		'                \"ZFBDT\": \"30-06-2021\",'+
		'                \"XSIWE\": \"\",'+
		'                \"WAERS\": \"TRY\",'+
		'                \"WRBTR\": 56.01,'+
		'                \"BANKL\": \"0064-01260\",'+
		'                \"BANKN\": 177005,'+
		'                \"NAME1\": \"\",'+
		'                \"BOLGE\": \"İSTANBUL\",'+
		'                \"STCEG\": 11223344789,'+
		'                \"FATURA\": \"\",'+
		'                \"VKBUR\": \"\",'+
		'                \"HZUON\": 11223344789'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"ET_ITEMS\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"BELNR\": \"\",'+
		'                \"BUZEI\": \"\",'+
		'                \"KUNNR\": \"\",'+
		'                \"BUDAT\": \"\",'+
		'                \"ZFBDT\": \"\",'+
		'                \"WAERS\": \"\",'+
		'                \"DMBTR\": \"\",'+
		'                \"SGTXT\": \"\",'+
		'                \"BLART\": \"\",'+
		'                \"AWKEY\": \"\",'+
		'                \"GJAHR\": \"\",'+
		'                \"ZLSPR\": \"\",'+
		'                \"ZLSCH\": \"\",'+
		'                \"LTEXT\": \"\",'+
		'                \"MATNR\": \"\",'+
		'                \"MAKTX\": \"\",'+
		'                \"FKIMG\": \"\",'+
		'                \"VRKME\": \"\",'+
		'                \"KKBER\": \"\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		RC_BordroCekGirParser r = RC_BordroCekGirParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BordroCekGirParser.Item objItem = new RC_BordroCekGirParser.Item(System.JSON.createParser(json));
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
		RC_BordroCekGirParser.ET_ITEMS objET_ITEMS = new RC_BordroCekGirParser.ET_ITEMS(System.JSON.createParser(json));
		System.assert(objET_ITEMS != null);
		System.assert(objET_ITEMS.item == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BordroCekGirParser.ET_RETURN objET_RETURN = new RC_BordroCekGirParser.ET_RETURN(System.JSON.createParser(json));
		System.assert(objET_RETURN != null);
		System.assert(objET_RETURN.item == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BordroCekGirParser.Item_Z objItem_Z = new RC_BordroCekGirParser.Item_Z(System.JSON.createParser(json));
		System.assert(objItem_Z != null);
		System.assert(objItem_Z.BOENUM == null);
		System.assert(objItem_Z.BUDAT == null);
		System.assert(objItem_Z.PORTFO == null);
		System.assert(objItem_Z.KUNNR == null);
		System.assert(objItem_Z.ZFBDT == null);
		System.assert(objItem_Z.XSIWE == null);
		System.assert(objItem_Z.WAERS == null);
		System.assert(objItem_Z.WRBTR == null);
		System.assert(objItem_Z.BANKL == null);
		System.assert(objItem_Z.BANKN == null);
		System.assert(objItem_Z.NAME1 == null);
		System.assert(objItem_Z.BOLGE == null);
		System.assert(objItem_Z.STCEG == null);
		System.assert(objItem_Z.FATURA == null);
		System.assert(objItem_Z.VKBUR == null);
		System.assert(objItem_Z.HZUON == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BordroCekGirParser objRC_BordroCekGirParser = new RC_BordroCekGirParser(System.JSON.createParser(json));
		System.assert(objRC_BordroCekGirParser != null);
		System.assert(objRC_BordroCekGirParser.ET_RETURN == null);
		System.assert(objRC_BordroCekGirParser.CEK_ITEMS == null);
		System.assert(objRC_BordroCekGirParser.ET_ITEMS == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BordroCekGirParser.Item_Y objItem_Y = new RC_BordroCekGirParser.Item_Y(System.JSON.createParser(json));
		System.assert(objItem_Y != null);
		System.assert(objItem_Y.BELNR == null);
		System.assert(objItem_Y.BUZEI == null);
		System.assert(objItem_Y.KUNNR == null);
		System.assert(objItem_Y.BUDAT == null);
		System.assert(objItem_Y.ZFBDT == null);
		System.assert(objItem_Y.WAERS == null);
		System.assert(objItem_Y.DMBTR == null);
		System.assert(objItem_Y.SGTXT == null);
		System.assert(objItem_Y.BLART == null);
		System.assert(objItem_Y.AWKEY == null);
		System.assert(objItem_Y.GJAHR == null);
		System.assert(objItem_Y.ZLSPR == null);
		System.assert(objItem_Y.ZLSCH == null);
		System.assert(objItem_Y.LTEXT == null);
		System.assert(objItem_Y.MATNR == null);
		System.assert(objItem_Y.MAKTX == null);
		System.assert(objItem_Y.FKIMG == null);
		System.assert(objItem_Y.VRKME == null);
		System.assert(objItem_Y.KKBER == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_BordroCekGirParser.CEK_ITEMS objCEK_ITEMS = new RC_BordroCekGirParser.CEK_ITEMS(System.JSON.createParser(json));
		System.assert(objCEK_ITEMS != null);
		System.assert(objCEK_ITEMS.item == null);
	}
}