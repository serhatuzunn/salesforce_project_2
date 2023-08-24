//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class RC_CekGirIntegratorResponseParserTest {
	
	static testMethod void testParse() {
        
		String json = '{'+
             '\"ET_RETURN\": { \"item\" : [{\"TYPE\": \"test\", \"ID\": \"test\", \"MESSAGE\": \"test\", \"LOG_NO\": \"test\", \"LOG_MSG_NO\": \"test\", \"MESSAGE_V1\": \"test\", \"MESSAGE_V2\": \"test\"}]},'+
		'    \"BATCHMOD\": \"N\",'+
		'    \"DEBUG\": \"\",'+
		'    \"EKSIKKAYIT\": \"\",'+
		'    \"FORCE\": \"\",'+
		'    \"LOG\": \"X\",'+
		'    \"OPERASYON\": \"C\",'+
            '    \"BORDROLAR\": {'+
		'        \"item\": [{'+
		'            \"MANDT\": \"021\",'+
		'            \"BORDRO\": \"1000009556\",'+
		'            \"BORDROTYP\": \"C\",'+
		'            \"TARIH_BAS\": \"\",'+
		'            \"TARIH_BIT\": \"20211102\",'+
		'            \"TUTAR\": \"56.013,13\",'+
		'            \"STATUS\": \"C\",'+
		'            \"KUNNR\": \"22201781\",'+
		'            \"NAME1\": \"SEREN DAYANIKLI TÜKETİM MAMÜLLERİ\",'+
		'            \"NAME2\": \"PAZARLAMA LİMİTED ŞİRKETİ\",'+
		'            \"VADE\": \"20211201\",'+
		'            \"VADE_KUN\": \"\",'+
		'            \"WAERS\": \"TRY\",'+
		'            \"SALLAMA\": \"0\",'+
		'            \"ERDAT\": \"\",'+
		'            \"ERNAM\": \"\",'+
		'            \"KKBER\": \"Vestel\",'+
		'            \"VKBUR\": \"2201\",'+
		'            \"ZLSCH\": \"\",'+
		'            \"MONAT\": \"\",'+
		'            \"GJAHR\": \"\"'+
            '        }]}'+
		'    ,'+
		'    \"CEKLER\": {'+
		'        \"item\": ['+
		'            {'+
		'            \"CEKNO\": \"9907669\",'+
		'            \"TARIH\": \"20210910\"'+
		'        },'+
		'        {'+
		'            \"CEKNO\": \"9907670\",'+
		'            \"TARIH\": \"20210910\"'+
		'        },'+
		'        {'+
		'            \"CEKNO\": \"9907671\",'+
		'            \"TARIH\": \"20210910\"'+
		'        }'+
		'        ]'+
		'    }'+
		'}';
        
        RC_CekGirIntegratorResponseParser.Item i = new RC_CekGirIntegratorResponseParser.Item();
        i.MANDT = 'test';
        i.BORDROTYP = 'test';
        i.TARIH_BAS = 'test';
        i.TARIH_BIT = 'test';
        i.STATUS = 'test';
        i.KUNNR = 'test';
        i.NAME1 = 'test';
        i.NAME2 = 'test';
        i.VADE = 'test';
        i.VADE_KUN = 'test';
        i.WAERS = 'test';
        i.SALLAMA = 1;
        i.ERDAT = 'test';
        i.ERNAM = 'test';
        i.KKBER = 'test';
        i.VKBUR = 'test';
        i.ZLSCH = 'test';
        i.MONAT = 'test';
        i.GJAHR = 'test';
        
        RC_CekGirIntegratorResponseParser.Item_Y i1 = new RC_CekGirIntegratorResponseParser.Item_Y();
        i1.TYPE= 'test';
        i1.ID= 'test';
        i1.MESSAGE= 'test';
        i1.LOG_NO= 'test';
        i1.LOG_MSG_NO= 'test';
        i1.MESSAGE_V1= 'test';
        i1.MESSAGE_V2= 'test';
        
        RC_CekGirIntegratorResponseParser.ET_RETURN er = new RC_CekGirIntegratorResponseParser.ET_RETURN();
        er.item = new List<RC_CekGirIntegratorResponseParser.Item_Y>{i1};
        
		RC_CekGirIntegratorResponseParser obj = RC_CekGirIntegratorResponseParser.parse(json);
		System.assert(obj != null);
	}
}