public class RC_CekGirIntegratorParser {

	public class Item {
		public String MANDT;
		public String BORDRO;
		public String BORDROTYP;
		public String TARIH_BAS;
		public String TARIH_BIT;
		public String TUTAR;
		public String STATUS;
		public String KUNNR;
		public String NAME1;
		public String NAME2;
		public String VADE;
		public String VADE_KUN;
		public String WAERS;
		public String SALLAMA;
		public String ERDAT;
		public String ERNAM;
		public String KKBER;
		public String VKBUR;
		public String ZLSCH;
		public String MONAT;
		public String GJAHR;
	}

	public class BORDROLAR {
		public Item item;
	}

	public class CEKLER {
		public List<Item_Z> item;
	}

	public String BATCHMOD;
	public String DEBUG;
	public String EKSIKKAYIT;
	public String FORCE;
	public String LOG;
	public String OPERASYON;
	public BORDROLAR BORDROLAR;
	public CEKLER CEKLER;

	public class Item_Z {
		public String CEKNO;
		public String TARIH;
	}

	
	public static RC_CekGirIntegratorParser parse(String json) {
		return (RC_CekGirIntegratorParser) System.JSON.deserialize(json, RC_CekGirIntegratorParser.class);
	}
}