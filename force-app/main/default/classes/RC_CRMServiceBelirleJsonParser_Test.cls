@IsTest
public class RC_CRMServiceBelirleJsonParser_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_SERVIS\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"SERVIS_KODU\": \"\",'+
		'                \"SERVIS_ADI\": \"\",'+
		'                \"TELEFON1\": \"\",'+
		'                \"TELEFON2\": \"\",'+
		'                \"TELEFON3\": \"\",'+
		'                \"IL\": \"\",'+
		'                \"ILCE\": \"\",'+
		'                \"SEMT\": \"\",'+
		'                \"ADRES\": \"\",'+
		'                \"EMAIL\": \"\",'+
		'                \"IL_KODU\": \"\",'+
		'                \"ILCE_KODU\": \"\",'+
		'                \"SEMT_KODU\": \"\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"EV_MESAJ_NO\": \"003\",'+
		'    \"EV_MESAJ_TXT\": \"Hatalı ürün kodu!\"'+
		'}';
		RC_CRMServiceBelirleJsonParser obj = RC_CRMServiceBelirleJsonParser.parse(json);
		System.assert(obj != null);
	}
}