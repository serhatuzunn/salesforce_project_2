@IsTest
public class RC_BordroCancelIntegratorParser_Test {
	
	static testMethod void testParse() {
		String json = '{\"EV_FLAG\":\"S\",\"EV_RETURN\":\"İşlem başarılı bir şekilde tamamlandı.\",\"IT_ODEME_PLAN\":{\"item\":[{\"MANDT\":1,\"GJAHR\":\"0001\",\"KUNNR\":\"0020300066\",\"ZLSCH\":\"A\",\"KKBER\":1,\"ROW_NO\":1,\"BORDROTIPI\":1,\"PORTFOY\":1,\"SMCTR\":\"1.00\",\"CVDTE\":\"01.01.2021\"}]},\"IT_SOZLESME\":{\"item\":[{\"MANDT\":1,\"GJAHR\":\"0001\",\"KUNNR\":\"0020300066\",\"ZLSCH\":\"A\",\"KKBER\":1,\"ROW_NO\":1,\"SMCTR\":\"1.00\",\"CVDTE\":\"01.01.2021\",\"START_DATE\":\"01.01.2021\",\"END_DATE\":\"01.01.2021\",\"TIMESTAMP\":1,\"USERNAME\":1,\"VARIANT\":1,\"ZTERM\":1,\"GJAHR_ZLSCH\":1,\"LAST_DATE\":\"01.01.2021\",\"LAST_TIME\":\"11:00:00\"}]}}';
		RC_BordroCancelIntegratorParser obj = RC_BordroCancelIntegratorParser.parse(json);
		System.assert(obj != null);
	}

}