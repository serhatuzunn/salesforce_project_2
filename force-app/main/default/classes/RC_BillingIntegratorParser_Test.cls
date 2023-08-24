@IsTest
public class RC_BillingIntegratorParser_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_RETURN\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"VBELN\": \"0516092449\",'+
		'                \"POSNR\": \"000020\",'+
		'                \"VGTYP\": \"J\",'+
		'                \"VGBEL\": \"0340303730\",'+
		'                \"VGPOS\": \"000001\",'+
		'                \"MATNR\": \"000000000020217175\",'+
		'                \"FKIMG\": \"1.000\",'+
		'                \"VRKME\": \"ST\",'+
		'                \"ZTERM\": \"VPNK\",'+
		'                \"FKART\": \"FTS\",'+
		'                \"VKORG\": 2211,'+
		'                \"VTWEG\": 42'+
		'            },'+
		'            {'+
		'                \"VBELN\": \"0516092450\",'+
		'                \"POSNR\": \"000030\",'+
		'                \"VGTYP\": \"J\",'+
		'                \"VGBEL\": \"0340303731\",'+
		'                \"VGPOS\": \"000001\",'+
		'                \"MATNR\": \"000000000020217175\",'+
		'                \"FKIMG\": \"1.000\",'+
		'                \"VRKME\": \"ST\",'+
		'                \"ZTERM\": \"VPNK\",'+
		'                \"FKART\": \"FTS\",'+
		'                \"VKORG\": 2211,'+
		'                \"VTWEG\": 42'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		RC_BillingIntegratorParser obj = RC_BillingIntegratorParser.parse(json);
		System.assert(obj != null);
	}
}