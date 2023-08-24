public class RC_CekGirIntegratorResponseParser {

    public class Item {
		public String MANDT;
		//public Long BORDRO;//Bu alan int maks value üstünde değer geliyordu parse ederken patlıyordu herhangi bir yer kullanılmadığı icin kapatıldı
		public String BORDROTYP;
		public String TARIH_BAS;
		public String TARIH_BIT;
		//public Double TUTAR;//Bu alan bi double bi string değer geliyordu parse ederken patlamasın diye ve herhangi bir yer kullanılmadığı icin kapatıldı
		public String STATUS;
		public String KUNNR;
		public String NAME1;
		public String NAME2;
		public String VADE;
		public String VADE_KUN;
		public String WAERS;
		public Integer SALLAMA;
		public String ERDAT;
		public String ERNAM;
		public String KKBER;
		public String VKBUR;
		public String ZLSCH;
		public String MONAT;
		public String GJAHR;
	}

	public ET_RETURN ET_RETURN;
	public Integer UPDCOUNT;
	public BORDROLAR BORDROLAR;
	public CEKLER CEKLER;
    public String Name;
    public String TextMsg;

    public class ET_RETURN{
		public list<Item_Y> item{get;set;}
	}
    
	public class BORDROLAR {
		public List<Item> item;
	}

	public class CEKLER {
		public List<Item_Z> item;
	}

	public class Item_Z {
		public Integer CEKNO;
		public String BANKL;
		public String TARIH;
	}
    
    public class Item_Y {
		public String TYPE;
        public String ID;
        public String MESSAGE;
        public String LOG_NO;
        public String LOG_MSG_NO;
        public String MESSAGE_V1;
        public String MESSAGE_V2;
	}
	
	public static RC_CekGirIntegratorResponseParser parse(String json) {
        
		return (RC_CekGirIntegratorResponseParser) System.JSON.deserialize(json, RC_CekGirIntegratorResponseParser.class);
	}

	
}