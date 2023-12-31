//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class RC_DealerBonusJsonParser {

	public class Item {
		public String MANDT;
		public String KUNNR;
		public String BAST;
		public String BITT;
		public String VKBUR;
		public String VKBUR_TXT;
		public String VKGRP;
		public String VKGRP_TXT;
		public String NAME1;
		public String KATEGORI1;
		public String KATEGORI2;
		public String KATEGORI3;
		public String KATEGORI4;
		public String KATEGORI5;
		public String NETCIRO;
		public String TOPCIRO;
		public String PRIM_TUTAR_KTG1;
		public String PRIM_TUTAR_KTG2;
		public String PRIM_TUTAR_KTG3;
		public String PRIM_TUTAR_KTG4;
		public String PRIM_TUTAR_KTG5;
		public String PRIM;
		public String PRIMD;
		public String PB;
		public String PRIMORANI;
		public String USTPRIMORANI;
		public String KALAN;
		public String ORTVADE;
		public String FATURALANDI;
		public String ORTGUN;
	}

	public class ET_BUYUME_PERAKENDE {
		public List<Item> item;
	}

	public class ET_RESULT_GRUP {
		public List<Item_Y> item;
	}

	public class ET_RESULT {
		public List<Item_Z> item;
	}

	public ET_BUYUME_PERAKENDE ET_BUYUME_PERAKENDE;
	public ET_RESULT ET_RESULT;
	public ET_RESULT_GRUP ET_RESULT_GRUP;

	public class Item_Z {
		public String MANDT;
		public String KUNNR;
		public String BAST;
		public String BITT;
		public String VKBUR;
		public String VKBUR_TXT;
		public String VKGRP;
		public String VKGRP_TXT;
		public String NAME1;
		public String GIBECIRO;
		public String GITVCIRO;
		public String GIEECIRO;
		public String GDBECIRO;
		public String GDTVCIRO;
		public String GDEECIRO;
		public String NETCIRO;
		public String TOPCIRO;
		public String GIBEPRIM;
		public String GITVPRIM;
		public String GIEEPRIM;
		public String GDBEPRIM;
		public String GDTVPRIM;
		public String GDEEPRIM;
		public String PRIM;
		public String PRIMD;
		public String PB;
		public String PRIMORANI;
		public String USTPRIMORANI;
		public String KALAN;
		public String ORTVADE;
		public String FATURALANDI;
		public String ORTGUN;
	}

	public class Item_Y {
		public String MANDT;
		public String KUNNR;
		public String YIL;
		public String DONEM;
		public String VKBUR;
		public String VKBUR_TXT;
		public String VKGRP;
		public String VKGRP_TXT;
		public String NAME1;
		public String GRUP1CIRO;
		public String GRUP2CIRO;
		public String FIRSATCIRO;
		public String PRIMSIZCIRO;
		public String NETCIRO;
		public String TOPCIRO;
		public String GRUP1PRIM;
		public String GRUP2PRIM;
		public String FIRSATPRIM;
		public String PRIM;
		public String PRIMD;
		public String PB;
		public String GRUP1PRIMO;
		public String GRUP2PRIMO;
		public String FIRSATPRIMO;
		public String KALAN;
		public String ORTVADE;
		public String FATURALANDI;
		public String ORTGUN;
	}

	
	public static RC_DealerBonusJsonParser parse(String json) {
		return (RC_DealerBonusJsonParser) System.JSON.deserialize(json, RC_DealerBonusJsonParser.class);
	}
}