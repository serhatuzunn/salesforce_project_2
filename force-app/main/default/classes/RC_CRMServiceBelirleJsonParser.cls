public class RC_CRMServiceBelirleJsonParser {

	public class Item {
		public String SERVIS_KODU;
		public String SERVIS_ADI;
		public String TELEFON1;
		public String TELEFON2;
		public String TELEFON3;
		public String IL;
		public String ILCE;
		public String SEMT;
		public String ADRES;
		public String EMAIL;
		public String IL_KODU;
		public String ILCE_KODU;
		public String SEMT_KODU;
	}

	public class ET_SERVIS {
		public List<Item> item;
	}

	public ET_SERVIS ET_SERVIS;
	public String EV_MESAJ_NO;
	public String EV_MESAJ_TXT;

	
	public static RC_CRMServiceBelirleJsonParser parse(String json) {
		return (RC_CRMServiceBelirleJsonParser) System.JSON.deserialize(json, RC_CRMServiceBelirleJsonParser.class);
	}
}