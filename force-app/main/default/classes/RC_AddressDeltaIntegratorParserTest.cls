@IsTest
public class RC_AddressDeltaIntegratorParserTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'        \"ITEM\": ['+
		'            {'+
		'                \"ZDURUM\": \"INSERT\",'+
		'                \"REGION\": \"026\",'+
		'                \"CITY_CODE\": \"000000026114\",'+
		'                \"MC_CITY\": \"TEPEBAŞI\",'+
		'                \"ADRCITYPRT\": {'+
		'                    \"ITEM\": ['+
		'                        {'+
		'                            \"CITY_CODE\": \"000000026114\",'+
		'                            \"CITYP_CODE\": 26999999,'+
		'                            \"CITY_PART\": \"semt ekleme test\"'+
		'                        }'+
		'                    ]'+
		'                }'+
		'            },'+
		'            {'+
		'                \"ZDURUM\": \"INSERT\",'+
		'                \"REGION\": \"026\",'+
		'                \"CITY_CODE\": \"000000026114\",'+
		'                \"MC_CITY\": \"TEPEBAŞI\",'+
		'                \"ADRCITYPRT\": {'+
		'                    \"ITEM\": ['+
		'                        {'+
		'                            \"CITY_CODE\": \"000000026114\",'+
		'                            \"CITYP_CODE\": 26999998,'+
		'                            \"CITY_PART\": \"SUHEYLA TEST 2\"'+
		'                        }'+
		'                    ]'+
		'                }'+
		'            },'+
		'            {'+
		'                \"ZDURUM\": \"INSERT\",'+
		'                \"REGION\": \"026\",'+
		'                \"CITY_CODE\": \"000000026114\",'+
		'                \"MC_CITY\": \"TEPEBAŞI\",'+
		'                \"ADRCITYPRT\": {'+
		'                    \"ITEM\": ['+
		'                        {'+
		'                            \"CITY_CODE\": \"000000026114\",'+
		'                            \"CITYP_CODE\": 26114093,'+
		'                            \"CITY_PART\": \"ŞEKER MAH.\"'+
		'                        }'+
		'                    ]'+
		'                }'+
		'            },'+
		'            {'+
		'                \"ZDURUM\": \"DELETE\",'+
		'                \"REGION\": \"026\",'+
		'                \"CITY_CODE\": \"000000026114\",'+
		'                \"MC_CITY\": \"TEPEBAŞI\",'+
		'                \"ADRCITYPRT\": {'+
		'                    \"ITEM\": ['+
		'                        {'+
		'                            \"CITY_CODE\": \"000000026114\",'+
		'                            \"CITYP_CODE\": 26114092,'+
		'                            \"CITY_PART\": \"SUHEYLA TEST 2\"'+
		'                        }'+
		'                    ]'+
		'                }'+
		'            },'+
		'            {'+
		'                \"ZDURUM\": \"DELETE\",'+
		'                \"REGION\": \"026\",'+
		'                \"CITY_CODE\": \"000000026114\",'+
		'                \"MC_CITY\": \"TEPEBAŞI\",'+
		'                \"ADRCITYPRT\": {'+
		'                    \"ITEM\": ['+
		'                        {'+
		'                            \"CITY_CODE\": \"000000026114\",'+
		'                            \"CITYP_CODE\": 26113088,'+
		'                            \"CITY_PART\": \"ŞARKİYE MAH.\"'+
		'                        }'+
		'                    ]'+
		'                }'+
		'            },'+
		'            {'+
		'                \"ZDURUM\": \"DELETE\",'+
		'                \"REGION\": \"026\",'+
		'                \"CITY_CODE\": \"000000026114\",'+
		'                \"MC_CITY\": \"TEPEBAŞI\",'+
		'                \"ADRCITYPRT\": {'+
		'                    \"ITEM\": ['+
		'                        {'+
		'                            \"CITY_CODE\": \"000000026114\",'+
		'                            \"CITYP_CODE\": 26113001,'+
		'                            \"CITY_PART\": \"71 EVLER MAH.\"'+
		'                        },'+
		'                        {'+
		'                            \"CITY_CODE\": \"000000026114\",'+
		'                            \"CITYP_CODE\": 26113001,'+
		'                            \"CITY_PART\": \"71 EVLER MAH.\"'+
		'                        }'+
		'                    ]'+
		'                }'+
		'            }'+
		'        ]'+
		'    }';
		RC_AddressDeltaIntegratorParser r = RC_AddressDeltaIntegratorParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AddressDeltaIntegratorParser.ITEM objITEM = new RC_AddressDeltaIntegratorParser.ITEM(System.JSON.createParser(json));
		System.assert(objITEM != null);
		System.assert(objITEM.CITY_CODE == null);
		System.assert(objITEM.CITYP_CODE == null);
		System.assert(objITEM.CITY_PART == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AddressDeltaIntegratorParser.ADRCITYPRT objADRCITYPRT = new RC_AddressDeltaIntegratorParser.ADRCITYPRT(System.JSON.createParser(json));
		System.assert(objADRCITYPRT != null);
		System.assert(objADRCITYPRT.ITEM == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AddressDeltaIntegratorParser.ITEM_Z objITEM_Z = new RC_AddressDeltaIntegratorParser.ITEM_Z(System.JSON.createParser(json));
		System.assert(objITEM_Z != null);
		System.assert(objITEM_Z.ZDURUM == null);
		System.assert(objITEM_Z.REGION == null);
		System.assert(objITEM_Z.CITY_CODE == null);
		System.assert(objITEM_Z.MC_CITY == null);
		System.assert(objITEM_Z.ADRCITYPRT == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RC_AddressDeltaIntegratorParser objRC_AddressDeltaIntegratorParser = new RC_AddressDeltaIntegratorParser(System.JSON.createParser(json));
		System.assert(objRC_AddressDeltaIntegratorParser != null);
		System.assert(objRC_AddressDeltaIntegratorParser.ITEM == null);
	}
}