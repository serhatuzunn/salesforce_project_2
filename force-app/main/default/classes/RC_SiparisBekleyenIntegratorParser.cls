public class RC_SiparisBekleyenIntegratorParser {

	public class Item {
		public String BELGENO;
		public String SIPARISTARIHI;
		public String BAYINO;
		public String URUNKODU;
		public String URUNTANIM;
		public String SIPARISADEDI;
		public String SIPARISTEBEKLEYEN;
		public String VSART;
		public String BIRIM;
		public String KDVSIZ;
		public String FIYATBIRIM;
		public String UST;
		public String POSNR;
		public String SEBEP;
		public String ZADRESTESL;
		public String ZADRESNAME;
		public String IL;
		public String ILCE;
		public String SEMT;
		public String AD;
		public String SOYAD;
		public String TEL;
		public String ADRES;
	}

	public SIPARISTEBEKLEYEN SIPARISTEBEKLEYEN;

	public class SIPARISTEBEKLEYEN {
		public List<Item> item;
	}

	
	public static RC_SiparisBekleyenIntegratorParser parse(String json) {
		return (RC_SiparisBekleyenIntegratorParser) System.JSON.deserialize(json, RC_SiparisBekleyenIntegratorParser.class);
	}
}