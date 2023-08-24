public class RC_TeslimatBekleyenIntegratorParser {

	public class Item {
		public String BAYINO;
		public String URUNKODU;
		public String URUNTANIM;
		public String TESLIMATTABEKLEYEN;
		public String BIRIM;
		public String VSART;
		public String KDVSIZ;
		public String FIYATBIRIM;
		public String SIPARISNO;
		public String SIPARISKLM;
		public String ZADRESTESL;
		public String TESLIMATNO;
		public String TESLIMATKLM;
		public String WERKS;
		public String IL;
		public String ILCE;
		public String SEMT;
		public String AD;
		public String SOYAD;
		public String TEL;
		public String ADRES;
		public String GUN;
	}

	public class TESLIMATTABEKLEYEN {
		public List<Item> item;
	}

	public TESLIMATTABEKLEYEN TESLIMATTABEKLEYEN;

	
	public static RC_TeslimatBekleyenIntegratorParser parse(String json) {
		return (RC_TeslimatBekleyenIntegratorParser) System.JSON.deserialize(json, RC_TeslimatBekleyenIntegratorParser.class);
	}
}