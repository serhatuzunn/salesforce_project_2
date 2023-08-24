@IsTest
public class RC_GetPriceListFromVefaParser_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"HeaderLists\": ['+
		'        {'+
		'            \"NAME\": \"Q1_Vestel_VPO_EVC_ZES_AC_DC_USD\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"LISTID\": 59017,'+
		'            \"PRICETYPE\": \"\",'+
		'            \"UNIQUEID\": \"59017\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        },'+
		'        {'+
		'            \"NAME\": \"Q1 Vestel_VPO_LED_Maysa Peyzaj_TL\",'+
		'            \"CURRENCYVEFA\": \"TRY\",'+
		'            \"LISTID\": 59032,'+
		'            \"PRICETYPE\": \"\",'+
		'            \"UNIQUEID\": \"59032\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        },'+
		'        {'+
		'            \"NAME\": \"Q1_VPO_VTS_Özdisan_TL \",'+
		'            \"CURRENCYVEFA\": \"TRY\",'+
		'            \"LISTID\": 59254,'+
		'            \"PRICETYPE\": \"24\",'+
		'            \"UNIQUEID\": \"59254_24\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        },'+
		'        {'+
		'            \"NAME\": \"Q1_Vestel_VPO_LED_BEYAZ_ESYA\",'+
		'            \"CURRENCYVEFA\": \"TRY\",'+
		'            \"LISTID\": 59289,'+
		'            \"PRICETYPE\": \"2\",'+
		'            \"UNIQUEID\": \"59289_2\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        },'+
		'        {'+
		'            \"NAME\": \"Q1_Vestel_VPO_LED_BEYAZ_ESYA\",'+
		'            \"CURRENCYVEFA\": \"TRY\",'+
		'            \"LISTID\": 59289,'+
		'            \"PRICETYPE\": \"4\",'+
		'            \"UNIQUEID\": \"59289_4\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        },'+
		'        {'+
		'            \"NAME\": \"Q1_Vestel_VPO_LED_BEYAZ_ESYA\",'+
		'            \"CURRENCYVEFA\": \"TRY\",'+
		'            \"LISTID\": 59289,'+
		'            \"PRICETYPE\": \"6\",'+
		'            \"UNIQUEID\": \"59289_6\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        },'+
		'        {'+
		'            \"NAME\": \"Q1_Vestel_VPO_LED_BEYAZ_ESYA\",'+
		'            \"CURRENCYVEFA\": \"TRY\",'+
		'            \"LISTID\": 59289,'+
		'            \"PRICETYPE\": \"8\",'+
		'            \"UNIQUEID\": \"59289_8\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        },'+
		'        {'+
		'            \"NAME\": \"Q1_Vestel_VPO_LED_BEYAZ_ESYA\",'+
		'            \"CURRENCYVEFA\": \"TRY\",'+
		'            \"LISTID\": 59289,'+
		'            \"PRICETYPE\": \"24\",'+
		'            \"UNIQUEID\": \"59289_24\",'+
		'            \"SOCODE\": \"2211\",'+
		'            \"DCCODE\": \"24\",'+
		'            \"RDCODE\": \"\",'+
		'            \"SGCODE\": \"\"'+
		'        }'+
		'    ],'+
		'    \"DetailLists\": ['+
		'        {'+
		'            \"PRODUCTCODE\": \"20275073\",'+
		'            \"PRODUCTNAME\": \"STAND EVC02 BACK SIDE WHITE V1\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 81.88,'+
		'            \"EXTERNALID\": \"59017_20275073_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 81.88'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291322\",'+
		'            \"PRODUCTNAME\": \"EVC02-AC22R-6 VP ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 506.62,'+
		'            \"EXTERNALID\": \"59017_20291322_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 506.62'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291323\",'+
		'            \"PRODUCTNAME\": \"EVC02-AC22UR-6 VP ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 568.54,'+
		'            \"EXTERNALID\": \"59017_20291323_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 568.54'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291324\",'+
		'            \"PRODUCTNAME\": \"EVC02-AC22UR-A6 VP ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 619.21,'+
		'            \"EXTERNALID\": \"59017_20291324_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 619.21'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291492\",'+
		'            \"PRODUCTNAME\": \"EVC02-AC22R-T2P-6 ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 579.80,'+
		'            \"EXTERNALID\": \"59017_20291492_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 579.80'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291672\",'+
		'            \"PRODUCTNAME\": \"EVC02-AC22UR-6 T2P VP ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 641.73,'+
		'            \"EXTERNALID\": \"59017_20291672_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 641.73'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291503\",'+
		'            \"PRODUCTNAME\": \"EVC03-DC180CHSP ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 33585.75,'+
		'            \"EXTERNALID\": \"59017_20291503_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 33585.75'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291504\",'+
		'            \"PRODUCTNAME\": \"EVC03-DC60CHSP ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 21845.34,'+
		'            \"EXTERNALID\": \"59017_20291504_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 21845.34'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291505\",'+
		'            \"PRODUCTNAME\": \"EVC03-DC120CHSP ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 28867.52,'+
		'            \"EXTERNALID\": \"59017_20291505_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 28867.52'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291688\",'+
		'            \"PRODUCTNAME\": \"EVC03-DC180CC ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 33585.75,'+
		'            \"EXTERNALID\": \"59017_20291688_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 33585.75'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291689\",'+
		'            \"PRODUCTNAME\": \"EVC03-DC120C ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 24713.92,'+
		'            \"EXTERNALID\": \"59017_20291689_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 24713.92'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20275737\",'+
		'            \"PRODUCTNAME\": \"STAND PROFILE EVC04 BLACK R1\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 81.88,'+
		'            \"EXTERNALID\": \"59017_20275737_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 81.88'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291552\",'+
		'            \"PRODUCTNAME\": \"EVC04-AC22-G ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 358.11,'+
		'            \"EXTERNALID\": \"59017_20291552_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 358.11'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291553\",'+
		'            \"PRODUCTNAME\": \"EVC04-AC22-T2P-G ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 431.30,'+
		'            \"EXTERNALID\": \"59017_20291553_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 431.30'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291554\",'+
		'            \"PRODUCTNAME\": \"EVC04-AC22 ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 354.64,'+
		'            \"EXTERNALID\": \"59017_20291554_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 354.64'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291555\",'+
		'            \"PRODUCTNAME\": \"EVC04-AC22-T2P ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 427.82,'+
		'            \"EXTERNALID\": \"59017_20291555_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 427.82'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291673\",'+
		'            \"PRODUCTNAME\": \"EVC04-AC7 ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 315.23,'+
		'            \"EXTERNALID\": \"59017_20291673_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 315.23'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291674\",'+
		'            \"PRODUCTNAME\": \"EVC04-AC7-G ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 318.71,'+
		'            \"EXTERNALID\": \"59017_20291674_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 318.71'+
		'        },'+
		'        {'+
		'            \"PRODUCTCODE\": \"20291675\",'+
		'            \"PRODUCTNAME\": \"EVC04-AC7-T2P ZES TR\",'+
		'            \"CURRENCYVEFA\": \"USD\",'+
		'            \"UNITPRICE\": 360.26,'+
		'            \"EXTERNALID\": \"59017_20291675_\",'+
		'            \"EXTERNALHEADERID\": \"59017\",'+
		'            \"MINPRICE\": 360.26'+
		'        }'+
		'    ],'+
		'    \"Message\": \"İşlem başarılı.\",'+
		'    \"PageCount\": 2'+
		'}';
		RC_GetPriceListFromVefaParser obj = RC_GetPriceListFromVefaParser.parse(json);
		System.assert(obj != null);
	}
}