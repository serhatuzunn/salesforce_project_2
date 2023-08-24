public class RC_IptalIadeGetOrdersParser {
 	public ET_MESSAGE ET_MESSAGE;
	public ET_RESULT ET_RESULT;
	public class Item {
		public String KUNAG;
		public String MATNR;
		public String MAKTX;
		public String PRODH;
		public String KONDM;
		public String ONAY_DURUM;
		public Integer SATIS_ORG;
		public String DGTM_KANALI;
		public Integer BOLUM;
		public String SIP_NO;
		public String SIP_KLM;
		public String SIP_TUR;
		public String SIP_GRKC;
		public String SIP_GRKC_TNM;
		public String SIP_MIK;
		public Integer SIP_IADE_MIK;
		public String SIP_AL_MIK;
		public String TES_NO;
		public String TES_KALEM;
		public String FAT_NO;
		public String FAT_KLM;
		public String FAT_TRH;
		public String FAT_VADE;
		public Double FAT_TTR;
		public String FAT_KDV;
		public String FAT_MIK;
		public Integer FAT_IADE_MIK;
		public String FAT_AL_MIK;
		public Integer URETIM_YERI;
		public String DEPO_YERI;
		public String EMANET;
		public String EMANET_SIP;
		public String EMANET_SIP_KLM;
		public Integer EMANET_SIP_MIK;
		public String EMANET_TESLIMAT;
		public String EMANET_TESLIMAT_KLM;
		public Integer EMANET_SEVK_MIK;
		public String EMANET_MC_TIPI;
		public String EMANET_LOKASYON;
		public String EMANET_UY;
		public String PAKET_GOSTERGE;
		public String PAKET_TANIM;
		public String TYPE;
		public String MESSAGE;
		public String LOG_NO;
		public String LOG_MSG_NO;
		public String MESSAGE_V1;
		public String MESSAGE_V2;
		public String MESSAGE_V3;
		public String MESSAGE_V4;
		public String PARAMETER;
		public Integer ROW;	
	}

	public class ET_RESULT {
		public List<Item> item;
	}

	public class ET_MESSAGE {
		public List<Item> item;
	}	
	public static RC_IptalIadeGetOrdersParser parse(String json) {
		return (RC_IptalIadeGetOrdersParser) System.JSON.deserialize(json, RC_IptalIadeGetOrdersParser.class);
	}
}