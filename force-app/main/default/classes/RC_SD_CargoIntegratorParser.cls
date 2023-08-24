//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class RC_SD_CargoIntegratorParser {

	public class Item {
		public String ZTM_DELIVEY_NO;
		public String ZZ_CODE1;
		public String ZZ_ENH_DELIVERY_ST_TXT;
		public String ZZ_CODE2;
		public String ZZ_ENH_TRNS_ST_TXT;
		public String CARGO_COMPANY;
		public String REQ_END;
	}

	public class ET_MESSAGE {
		public List<Item_Z> item;
	}

	public class ET_DATA {
		public List<Item> item;
	}

	public ET_DATA ET_DATA;
	//public ET_MESSAGE ET_MESSAGE;  //TODO: SAP AP'den liste gelmediği durumlar olduğu için kapatıldı.

	public class Item_Z {
		public String TYPE_Z;
		public String ID;
		public String NUMBER_Z;
		public String MESSAGE;
		public String LOG_NO;
		public String LOG_MSG_NO;
		public String MESSAGE_V1;
		public String MESSAGE_V2;
		public String MESSAGE_V3;
		public String MESSAGE_V4;
		public String PARAMETER;
		public String ROW_Z;
		public String FIELD_Z;
		public String SYSTEM_Z;
	}

	
	public static RC_SD_CargoIntegratorParser parse(String json) {
		return (RC_SD_CargoIntegratorParser) System.JSON.deserialize(json, RC_SD_CargoIntegratorParser.class);
	}
}