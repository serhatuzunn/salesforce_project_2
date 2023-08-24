public class RC_MusteriIntegratorParser {

	public class Item {
		public String KUNNR;
	}

	public String EV_MESSAGE;
	public IN_TKUNN IN_TKUNN;

	public class IN_TKUNN {
		public List<Item> item;
	}

	
	public static RC_MusteriIntegratorParser parse(String json) {
		return (RC_MusteriIntegratorParser) System.JSON.deserialize(json, RC_MusteriIntegratorParser.class);
	}
}