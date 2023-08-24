@IsTest
public class RC_DTSBordroKalemSilParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'\"T_RETURN\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"BORDRO\": 1000205986,'+
		'                \"KALEM\": \"000000\",'+
		'                \"BELNR\": 1020207338,'+
		'                \"RESULT\": \"F\",'+
		'                \"ERROR\": \"Fatura kalemlerinden biri bulunamadı.\"'+
		'            },'+
		'            {'+
		'                \"BORDRO\": 1000205986,'+
		'                \"KALEM\": \"000000\",'+
		'                \"BELNR\": 1020205266,'+
		'                \"RESULT\": \"S\",'+
		'                \"ERROR\": \"Başarıyla silindi.\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		RC_DTSBordroKalemSilParser obj = RC_DTSBordroKalemSilParser.parse(json);
		System.assert(obj != null);
	}
}