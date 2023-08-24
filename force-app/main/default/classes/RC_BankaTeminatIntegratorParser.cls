public class RC_BankaTeminatIntegratorParser {

	public class Item {
		public Integer BUKRS;
		public String KKBER;
		public String KUNNR;
		public String DMBTR;
		public String WAERS;
		public String NETDT;
		public String XBLNR;
	}

	public class ET_RETURN {
		public List<Item> item;
	}

	public ET_RETURN ET_RETURN;
	public Integer EV_TOTAL_IND;

	
	public static RC_BankaTeminatIntegratorParser parse(String json) {
		return (RC_BankaTeminatIntegratorParser) System.JSON.deserialize(json, RC_BankaTeminatIntegratorParser.class);
	}
}