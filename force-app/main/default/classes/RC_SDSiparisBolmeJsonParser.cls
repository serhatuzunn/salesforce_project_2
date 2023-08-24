public class RC_SDSiparisBolmeJsonParser {

	public class Item {
		public String TYPE;
		public String ID ;
		public Integer NUMBER_Z;
		public String MESSAGE;
		public String LOG_NO;
		public String LOG_MSG_NO;
		public String MESSAGE_V1;
		public string MESSAGE_V2;
		public String MESSAGE_V3;
		public String MESSAGE_V4;
		public String PARAMETER;
		public Integer ROW;
		public String FIELD;
		public String SYSTEM_Z;
	}
	
	public class ET_MESSAGE {
		public List<Item> item;
		}	
	public ET_MESSAGE ET_MESSAGE; 	
		
	public static RC_SDSiparisBolmeJsonParser parse(String json) {
		return (RC_SDSiparisBolmeJsonParser) System.JSON.deserialize(json, RC_SDSiparisBolmeJsonParser.class);
	}

}