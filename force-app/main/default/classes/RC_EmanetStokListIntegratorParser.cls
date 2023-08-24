public class RC_EmanetStokListIntegratorParser {

	public class Item {
		public String MATNR;
		public String MAKTX;
		public String WERKS;
		public String KULAB;
		public String OMENG;
		public String CHARG;
		public String KUNNR;
		public String ZZMARKA;
		public String KONDM;
	}

	public class ET_OUTPUT {
		public List<Item> item;
	}

	public ET_OUTPUT ET_OUTPUT;

	
	public static RC_EmanetStokListIntegratorParser parse(String json) {
		return (RC_EmanetStokListIntegratorParser) System.JSON.deserialize(json, RC_EmanetStokListIntegratorParser.class);
	}
}