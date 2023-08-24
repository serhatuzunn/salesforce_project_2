public class RC_DTSBordroKalemSilParser {

	public class Item {
		public String BORDRO;
		public String KALEM;
		public String BELNR;
		public String RESULT;
		public String ERROR;
	}

	public T_RETURN T_RETURN;

	public class T_RETURN {
		public List<Item> item;
	}

	
	public static RC_DTSBordroKalemSilParser parse(String json) {
		return (RC_DTSBordroKalemSilParser) System.JSON.deserialize(json, RC_DTSBordroKalemSilParser.class);
	}
}