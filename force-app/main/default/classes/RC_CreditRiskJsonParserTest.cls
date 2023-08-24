@IsTest
public class RC_CreditRiskJsonParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_RETURN\": {'+
		'        \"Item_Y\": {'+
		'            \"ZDATUM\": \"2021-02-12\",'+
		'            \"BUKRS\": \"2002\",'+
		'            \"KUNNR\": \"0020300066\",'+
		'            \"GJAHR\": \"0000\",'+
		'            \"ACIK_BKY\": \"-419754.78\",'+
		'            \"ACIK_VALOR\": \"-153.00\",'+
		'            \"ACIK_VADE_TARIH\": \"2020-09-12\",'+
		'            \"ACIK_KREDI\": \"6.00\",'+
		'            \"ACIK_BAGSIZ\": -37715.71,'+
		'            \"ACIK_BAGSIZ_VALOR\": \"-349.00\",'+
		'            \"ACIK_BAGSIZ_TARIH\": \"2020-02-29\",'+
		'            \"IPOTEK\": \"1410000.00\",'+
		'            \"TEMINAT\": \"600000.00\",'+
		'            \"AVAL_KREDI\": \"3645006.00\",'+
		'            \"AVAL_BONOSU\": \"701503.00\",'+
		'            \"EKYONETIM_LMT2\": 0,'+
		'            \"EK_KLIMA_LMT\": 0,'+
		'            \"KUL_KLIMA_LMT\": 0,'+
		'            \"EK_CEPTEL_LMT\": \"50000.00\",'+
		'            \"KUL_CEPTEL_LMT\": 0,'+
		'            \"EK_KEA_LMT\": \"100000.00\",'+
		'            \"KUL_KEA_LMT\": 0,'+
		'            \"EK_ACM_LMT\": 0,'+
		'            \"KUL_ACM_LMT\": 0,'+
		'            \"RISK_CIRO\": 0,'+
		'            \"KMH_LIMIT\": \"1170000.00\",'+
		'            \"KMH\": 0,'+
		'            \"DBSBORC\": 0,'+
		'            \"DBS_LIMIT\": 0,'+
		'            \"BAYI_OLUS_TARIHI\": \"1992-06-15\",'+
		'            \"KREDI_TARIHI\": \"2019-06-13\",'+
		'            \"EMANET\": 0,'+
		'            \"DTSTEMCEK\": \"1.00\",'+
		'            \"RISK_SINIFI\": \"+\",'+
		'            \"RISK_SINIFI_T\": {'+
		'                \"item\": ['+
		'                    {'+
		'                        \"KUNNR\": \"0020300066\",'+
		'                        \"GJAHR\": 2019,'+
		'                        \"KMHYR\": 0,'+
		'                        \"KRSLZ\": 0,'+
		'                        \"TMDIT\": 0'+
		'                    },'+
		'                    {'+
		'                        \"KUNNR\": \"0020300066\",'+
		'                        \"GJAHR\": 2018,'+
		'                        \"KMHYR\": 0,'+
		'                        \"KRSLZ\": 0,'+
		'                        \"TMDIT\": 0'+
		'                    },'+
		'                    {'+
		'                        \"KUNNR\": \"0020300066\",'+
		'                        \"GJAHR\": 2017,'+
		'                        \"KMHYR\": 0,'+
		'                        \"KRSLZ\": 0,'+
		'                        \"TMDIT\": 0'+
		'                    },'+
		'                    {'+
		'                        \"KUNNR\": \"0020300066\",'+
		'                        \"GJAHR\": 2016,'+
		'                        \"KMHYR\": 0,'+
		'                        \"KRSLZ\": 0,'+
		'                        \"TMDIT\": 0'+
		'                    },'+
		'                    {'+
		'                        \"KUNNR\": \"0020300066\",'+
		'                        \"GJAHR\": 2015,'+
		'                        \"KMHYR\": 0,'+
		'                        \"KRSLZ\": 0,'+
		'                        \"TMDIT\": 0'+
		'                    },'+
		'                    {'+
		'                        \"KUNNR\": \"0020300066\",'+
		'                        \"GJAHR\": 2014,'+
		'                        \"KMHYR\": 0,'+
		'                        \"KRSLZ\": 0,'+
		'                        \"TMDIT\": 0'+
		'                    },'+
		'                    {'+
		'                        \"KUNNR\": \"0020300066\",'+
		'                        \"GJAHR\": 2013,'+
		'                        \"KMHYR\": 0,'+
		'                        \"KRSLZ\": 0,'+
		'                        \"TMDIT\": 0'+
		'                    }'+
		'                ]'+
		'            },'+
		'            \"YENILENECEK_TMNT\": \"1200000.00\",'+
		'            \"YENILENECEK_KLM\": {'+
		'                \"item\": ['+
		'                    {'+
		'                        \"NETDT\": \"2021-02-25\",'+
		'                        \"DMBTR\": \"200000.00\",'+
		'                        \"BANKA\": \".\"'+
		'                    },'+
		'                    {'+
		'                        \"NETDT\": \"2021-02-25\",'+
		'                        \"DMBTR\": \"200000.00\",'+
		'                        \"BANKA\": \".\"'+
		'                    },'+
		'                    {'+
		'                        \"NETDT\": \"2021-02-25\",'+
		'                        \"DMBTR\": \"200000.00\",'+
		'                        \"BANKA\": \"DTS ÇEKİ\"'+
		'                    },'+
		'                    {'+
		'                        \"NETDT\": \"2021-02-25\",'+
		'                        \"DMBTR\": \"200000.00\",'+
		'                        \"BANKA\": 4'+
		'                    },'+
		'                    {'+
		'                        \"NETDT\": \"2021-02-25\",'+
		'                        \"DMBTR\": \"200000.00\",'+
		'                        \"BANKA\": \"AKBANK\"'+
		'                    },'+
		'                    {'+
		'                        \"NETDT\": \"2021-02-25\",'+
		'                        \"DMBTR\": \"200000.00\",'+
		'                        \"BANKA\": \"GARANTİ BANKASI\"'+
		'                    }'+
		'                ]'+
		'            },'+
		'            \"KARSILIKSIZ_CEKLER\": 0,'+
		'            \"PROTESTOLU_SENETLER\": 0,'+
		'            \"IADELI_CEKLER\": \"3236000.00\",'+
		'            \"IADELI_SENETLER\": 0,'+
		'            \"TOP_RISK\": \"11427845.43\",'+
		'            \"TOP_KREDI\": \"5655012.00\",'+
		'            \"FARK_ASIM\": 5772833.43,'+
		'            \"KONSINYE\": 0,'+
		'            \"ALACAK_SIGORTA\": \"000000000000000\"'+
		'        }'+
		'    }'+
		'}';
        RC_CreditRiskJsonParser.Item_Y itemY = new RC_CreditRiskJsonParser.Item_Y();
        itemY.ACIK_BKY = '10';
        itemY.ACIK_VALOR = '10';
        itemY.ACIK_VADE_TARIH = '10';
        itemY.ACIK_KREDI = '10';
        itemY.ACIK_BAGSIZ = '10';
        itemY.ACIK_BAGSIZ_VALOR = '10';
        itemY.ACIK_BAGSIZ_TARIH = '10';
        itemY.ACIK_HESAP_VALORU = '10';
        itemY.IPOTEK = '10';
        itemY.TEMINAT = '10';
        itemY.AVAL_KREDI = '10';
        itemY.AVAL_BONOSU = '10';
        itemY.EKYONETIM_LMT2 = '10';
        itemY.EK_KLIMA_LMT = '10';
        itemY.KUL_KLIMA_LMT = '10';
        itemY.EK_CEPTEL_LMT = '10';
        itemY.KUL_CEPTEL_LMT = '10';
        itemY.EK_KEA_LMT = '10';
        itemY.KUL_KEA_LMT = '10';
        itemY.EK_ACM_LMT = '10';
        itemY.KUL_ACM_LMT = '10;';
        itemY.RISK_CIRO = '10';
        itemY.KMH_LIMIT = '10';
        itemY.KMH = '10';
        itemY.DBSBORC = '10';
        itemY.DBS_LIMIT = '10';
        itemY.BAYI_OLUS_TARIHI = '10';
        itemY.KREDI_TARIHI = '10';
        itemY.EMANET = '10';
        itemY.DTSTEMCEK = '10';
        itemY.YENILENECEK_TMNT = '10';
        itemY.KARSILIKSIZ_CEKLER = '10';
        itemY.PROTESTOLU_SENETLER = '10';
        itemY.IADELI_CEKLER = '10';
        itemY.IADELI_SENETLER = '10';
        itemY.TOP_RISK = '10';
        itemY.TOP_KREDI = '10';
        itemY.FARK_ASIM = '10';
        itemY.KONSINYE = '10';
        itemY.ALACAK_SIGORTA = '10';
        
		RC_CreditRiskJsonParser obj = RC_CreditRiskJsonParser.parse(json);
		System.assert(obj != null);
	}
}