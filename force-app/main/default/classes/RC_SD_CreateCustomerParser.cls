public class RC_SD_CreateCustomerParser {
public class Item {
		public String TYPE {get;set;} 
		public String ID {get;set;} 
		public String NUMBER_Z {get;set;} // in json: NUMBER
		public String MESSAGE {get;set;} 
		public String LOG_NO {get;set;} 
		public String LOG_MSG_NO {get;set;} 
		public String MESSAGE_V1 {get;set;} 
		public String MESSAGE_V2 {get;set;} 
		public String MESSAGE_V3 {get;set;} 
		public String MESSAGE_V4 {get;set;} 
		public String PARAMETER {get;set;} 
		public Integer ROW {get;set;} 
		public String FIELD {get;set;} 
		public String SYSTEM_Z {get;set;} // in json: SYSTEM

		public Item(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'TYPE') {
							TYPE = parser.getText();
						} else if (text == 'ID') {
							ID = parser.getText();
						} else if (text == 'NUMBER') {
							NUMBER_Z = parser.getText();
						} else if (text == 'MESSAGE') {
							MESSAGE = parser.getText();
						} else if (text == 'LOG_NO') {
							LOG_NO = parser.getText();
						} else if (text == 'LOG_MSG_NO') {
							LOG_MSG_NO = parser.getText();
						} else if (text == 'MESSAGE_V1') {
							MESSAGE_V1 = parser.getText();
						} else if (text == 'MESSAGE_V2') {
							MESSAGE_V2 = parser.getText();
						} else if (text == 'MESSAGE_V3') {
							MESSAGE_V3 = parser.getText();
						} else if (text == 'MESSAGE_V4') {
							MESSAGE_V4 = parser.getText();
						} else if (text == 'PARAMETER') {
							PARAMETER = parser.getText();
						} else if (text == 'ROW') {
							ROW = parser.getIntegerValue();
						} else if (text == 'FIELD') {
							FIELD = parser.getText();
						} else if (text == 'SYSTEM') {
							SYSTEM_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Item consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ET_MESSAGES {
		public List<Item> item {get;set;} 

		public ET_MESSAGES(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ET_MESSAGES consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public ET_MESSAGES ET_MESSAGES {get;set;} 
	public String EV_CUSTOMER_NO {get;set;} 

	public RC_SD_CreateCustomerParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'ET_MESSAGES') {
						ET_MESSAGES = new ET_MESSAGES(parser);
					} else if (text == 'EV_CUSTOMER_NO') {
						EV_CUSTOMER_NO = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'RC_SD_CreateCustomerParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static RC_SD_CreateCustomerParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_SD_CreateCustomerParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<Item> arrayOfItem(System.JSONParser p) {
        List<Item> res = new List<Item>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Item(p));
        }
        return res;
    }



}