public class RC_DeltaCustomerIntegratorParser {

	public class ET_TNM_SATIS_ORG {
		public List<Item_U> item;
	}

	public class Item_W {
		public String VKBUR;
		public String BEZEI;
	}

	public class Item_V {
		public String VKGRP;
		public String BEZEI;
	}

	public class Item_U {
		public String VKORG;
		public String VTEXT;
	}

	public class Item_T {
		public String LFART;
		public String VTEXT;
	}

	public class ET_TNM_FTR_BLG_TR {
		public List<Item_Z> item;
	}

	public class Item_Z {
		public String FKART;
		public String VTEXT;
	}

	public class Item_Y {
		public String KKBER;
		public String KKBTX;
	}

	public class ET_TNM_SATIS_MDR {
		public List<Item_V> item;
	}

	public class ET_TNM_TESL_BLG_TR {
		public List<Item_T> item;
	}

	public ET_TNM_DGTM_KANAL ET_TNM_DGTM_KANAL;
	public ET_TNM_FTR_BLG_TR ET_TNM_FTR_BLG_TR;
	public ET_TNM_KREDI_KNTR ET_TNM_KREDI_KNTR;
	public ET_TNM_MUST_GRUBU ET_TNM_MUST_GRUBU;
	public ET_TNM_SATIS_BURO ET_TNM_SATIS_BURO;
	public ET_TNM_SATIS_MDR ET_TNM_SATIS_MDR;
	public ET_TNM_SATIS_ORG ET_TNM_SATIS_ORG;
	public ET_TNM_TESL_BLG_TR ET_TNM_TESL_BLG_TR;

	public class Item_X {
		public String KDGRP;
		public String KTEXT;
	}

	public class ET_TNM_DGTM_KANAL {
		public List<Item> item;
	}

	public class ET_TNM_KREDI_KNTR {
		public List<Item_Y> item;
	}

	public class Item {
		public String VTWEG;
		public String VTEXT;
	}

	public class ET_TNM_MUST_GRUBU {
		public List<Item_X> item;
	}

	public class ET_TNM_SATIS_BURO {
		public List<Item_W> item;
	}

	
	public static RC_DeltaCustomerIntegratorParser parse(String json) {
		return (RC_DeltaCustomerIntegratorParser) System.JSON.deserialize(json, RC_DeltaCustomerIntegratorParser.class);
	}
}