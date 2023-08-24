@IsTest
public class RC_IptalIadeReturnOrderCreateParserTest {
		
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_MESSAGE\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"TYPE\": \"E\",'+
		'                \"ID\": \"t\",'+
		'                \"NUMBER\": \"000\",'+
		'                \"MESSAGE\": \"Teslimat blokajı  \\\"ZI\\\" yollayınız!\",'+
		'                \"LOG_NO\": \"t\",'+
		'                \"LOG_MSG_NO\": \"000000\",'+
		'                \"MESSAGE_V1\": \"t\",'+
		'                \"MESSAGE_V2\": \"t\",'+
		'                \"MESSAGE_V3\": \"t\",'+
		'                \"MESSAGE_V4\": \"t\",'+
		'                \"PARAMETER\": \"t\",'+
		'                \"ROW\": 0,'+
		'                \"FIELD\": \"t\",'+
		'                \"SYSTEM\": \"t\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"EV_DELIVERYDOCUMENT\": \"t\",'+
		'    \"EV_SALESDOCUMENT\": \"t\",'+
		'    \"EV_SUCCESS\": \"E\",'+
		'    \"ET_SALES_PARTNERS\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"PARTN_ROLE\": \"t\",'+
		'                \"PARTN_NUMB\": \"t\",'+
		'                \"ITM_NUMBER\": \"000000\",'+
		'                \"TITLE\": \"t\",'+
		'                \"NAME\": \"t\",'+
		'                \"NAME_2\": \"t\",'+
		'                \"NAME_3\": \"t\",'+
		'                \"NAME_4\": \"t\",'+
		'                \"STREET\": \"t\",'+
		'                \"COUNTRY\": \"t\",'+
		'                \"COUNTR_ISO\": \"t\",'+
		'                \"POSTL_CODE\": \"t\",'+
		'                \"POBX_PCD\": \"t\",'+
		'                \"POBX_CTY\": \"t\",'+
		'                \"CITY\": \"t\",'+
		'                \"DISTRICT\": \"\",'+
		'                \"REGION\": \"\",'+
		'                \"PO_BOX\": \"\",'+
		'                \"TELEPHONE\": \"\",'+
		'                \"TELEPHONE2\": \"\",'+
		'                \"TELEBOX\": \"\",'+
		'                \"FAX_NUMBER\": \"\",'+
		'                \"TELETEX_NO\": \"\",'+
		'                \"TELEX_NO\": \"\",'+
		'                \"LANGU\": \"\",'+
		'                \"LANGU_ISO\": \"\",'+
		'                \"UNLOAD_PT\": \"\",'+
		'                \"TRANSPZONE\": \"\",'+
		'                \"TAXJURCODE\": \"\",'+
		'                \"ADDRESS\": \"\",'+
		'                \"PRIV_ADDR\": \"\",'+
		'                \"ADDR_TYPE\": \"\",'+
		'                \"ADDR_ORIG\": \"\",'+
		'                \"ADDR_LINK\": \"\",'+
		'                \"REFOBJTYPE\": \"\",'+
		'                \"REFOBJKEY\": \"\",'+
		'                \"REFLOGSYS\": \"\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		RC_IptalIadeReturnOrderCreateParser.Item i = new RC_IptalIadeReturnOrderCreateParser.Item();
        i.TYPE= 'test';
        i.ID= 'test';        
        i.MESSAGE = 'test';
        i.LOG_NO = 'test';
        i.LOG_MSG_NO = 'test';
        i.MESSAGE_V1 = 'test';
        i.MESSAGE_V2 = 'test';
        i.MESSAGE_V3 = 'test';
        i.MESSAGE_V4  = 'test';
        i.PARAMETER = 'test';
        i.ROW = 0;
        i.FIELD = 'test';       
        i.PARTN_ROLE = 'test';
        i.PARTN_NUMB = 'test';
        i.ITM_NUMBER = 'test';
        i.TITLE = 'test';
        i.NAME = 'test';
        i.NAME_2 = 'test';
        i.NAME_3 = 'test';
        i.NAME_4 = 'test';
        i.STREET = 'test';
        i.COUNTRY = 'test';
        i.COUNTR_ISO = 'test';
        i.POSTL_CODE = 'test';
        i.POBX_PCD  = 'test';
        i.POBX_CTY = 'test';
        i.CITY = 'test';
        i.DISTRICT = 'test';
        i.REGION  = 'test';
        i.PO_BOX = 'test';
        i.TELEPHONE = 'test';
        i.TELEPHONE2 = 'test';
        i.TELEBOX = 'test';
        i.FAX_NUMBER  = 'test';
        i.TELETEX_NO = 'test';
        i.TELEX_NO = 'test';
        i.LANGU = 'test';
        i.LANGU_ISO = 'test';
        i.UNLOAD_PT = 'test';
        i.TRANSPZONE = 'test';
        i.TAXJURCODE = 'test';
        i.ADDRESS = 'test';
        i.PRIV_ADDR = 'test';
        i.ADDR_TYPE = 'test';
        i.ADDR_ORIG = 'test';
        i.ADDR_LINK = 'test';
        i.REFOBJTYPE = 'test';
        i.REFOBJKEY = 'test';
        i.REFLOGSYS = 'test';
        
        RC_IptalIadeReturnOrderCreateParser obj = RC_IptalIadeReturnOrderCreateParser.parse(json);
		System.assert(obj != null);
        		
	}
}