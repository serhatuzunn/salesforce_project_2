public class RC_SD_DeliveryParser {

	public class Item {
		public String VBELN;
		public String POSNR;
		public String VGBEL;
		public String VGPOS;
		public String MATNR;
		public String LFIMG;
		public String VRKME;
		public String LIFSK;
		public String LIFSK_T;
		public String STATUS_T;
        public String LFART;
        public String LFART_T;
        public String VSTEL;
        public string VSTEL_T;
        public String TM;
        public string CHANGED;
	}

	public class ET_RETURN {
		public List<Item> item;
	}

	public ET_RETURN ET_RETURN;
    public Integer EV_TOTAL_IND;

	
	public static RC_SD_DeliveryParser parse(String json) {
		return (RC_SD_DeliveryParser) System.JSON.deserialize(json, RC_SD_DeliveryParser.class);
	}
}