@IsTest
public class ZFI_SF_BordroYapParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"EV_MESSAGE\": \"Tüm müşteriler için bordrolar başarıyla yaratılmıştır.\",'+
		'    \"IN_TAUGRU\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"AUGRU\": \"\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"IO_TKUNNR\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"KUNNR\": \"0020100385\",'+
		'                \"BORDROTYPE\": \"C\",'+
		'                \"SONUC\": -2,'+
		'                \"BORDRONO\": 1000204764,'+
		'                \"MSG\": \"HAREKET SAP de kayitli degil\",'+
		'                \"KKBER\": \"\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		ZFI_SF_BordroYapParser r = ZFI_SF_BordroYapParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ZFI_SF_BordroYapParser.Item objItem = new ZFI_SF_BordroYapParser.Item(System.JSON.createParser(json));
		System.assert(objItem != null);
		System.assert(objItem.AUGRU == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ZFI_SF_BordroYapParser objZFI_SF_BordroYapParser = new ZFI_SF_BordroYapParser(System.JSON.createParser(json));
		System.assert(objZFI_SF_BordroYapParser != null);
		System.assert(objZFI_SF_BordroYapParser.EV_MESSAGE == null);
		System.assert(objZFI_SF_BordroYapParser.IN_TAUGRU == null);
		System.assert(objZFI_SF_BordroYapParser.IO_TKUNNR == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ZFI_SF_BordroYapParser.Item_Z objItem_Z = new ZFI_SF_BordroYapParser.Item_Z(System.JSON.createParser(json));
		System.assert(objItem_Z != null);
		System.assert(objItem_Z.KUNNR == null);
		System.assert(objItem_Z.BORDROTYPE == null);
		System.assert(objItem_Z.SONUC == null);
		System.assert(objItem_Z.BORDRONO == null);
		System.assert(objItem_Z.MSG == null);
		System.assert(objItem_Z.KKBER == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ZFI_SF_BordroYapParser.IO_TKUNNR objIO_TKUNNR = new ZFI_SF_BordroYapParser.IO_TKUNNR(System.JSON.createParser(json));
		System.assert(objIO_TKUNNR != null);
		System.assert(objIO_TKUNNR.item == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ZFI_SF_BordroYapParser.IN_TAUGRU objIN_TAUGRU = new ZFI_SF_BordroYapParser.IN_TAUGRU(System.JSON.createParser(json));
		System.assert(objIN_TAUGRU != null);
		System.assert(objIN_TAUGRU.item == null);
	}
}