public class RC_IptalIadeGetPackagedSales {
    
    public class Item_1{
		public String AUGRU;
		public String MATNR;
		public Integer KWMENG;
		public Integer VRKME;
	}
    public class Item_2 {
		public String AUGRU;
		public String MATNR;
		public Integer MATNR_PRO;
		public Integer KWMENG;
		public Integer KWMENG_PRO;
		public String KATLARI_YOK;

	}
    public class Item_3 {
		public String AUGRU;
		public String MATNR;		
		public Integer KWMENG;
		public String VRKME;
		public String KAT_YOK;
	}
    public class Item_4 {
		public String AUGRU;
		public String PRODH;
		public Integer MIN_MIK;
		public Integer MAX_MIK;
	}
    public class Item_5 {
		public String AUGRU;
		public Integer KONDM;
		public Integer KWMENG;
		public String KATI;
		public String USTU;
	}

    public class Item_6 {
		public String AUGRU;
		public Integer KONDM;
	}
    public class ET_EXPORT1 {
		public List<Item_1> item;
	}
    public class ET_EXPORT2 {
		public List<Item_2> item;
	}
    public class ET_EXPORT3 {
		public List<Item_3> item;
	}
    
	public class ET_EXPORT4 {
		public List<Item_4> item;
	}

    public class ET_EXPORT5 {
		public List<Item_5> item;
	}

    public class ET_EXPORT6 {
		public List<Item_6> item;
	}
	public ET_EXPORT4 ET_EXPORT1;
	public ET_EXPORT4 ET_EXPORT2;
	public ET_EXPORT4 ET_EXPORT3;
	public ET_EXPORT4 ET_EXPORT4;
	public ET_EXPORT5 ET_EXPORT5;
	public ET_EXPORT6 ET_EXPORT6;
	public String EV_ID;
	public String EV_PACKAGE;

	
	public static RC_IptalIadeGetPackagedSales parse(String json) {
		return (RC_IptalIadeGetPackagedSales) System.JSON.deserialize(json, RC_IptalIadeGetPackagedSales.class);
	}
}