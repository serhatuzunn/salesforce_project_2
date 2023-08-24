public class RC_AddressDeltaIntegratorParser {

	public class ITEM {
		public String CITY_CODE {get;set;} 
		public String CITYP_CODE {get;set;} 
		public String CITY_PART {get;set;} 

		public ITEM(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CITY_CODE') {
							CITY_CODE = parser.getText();
						} else if (text == 'CITYP_CODE') {
							CITYP_CODE = parser.getText();
						} else if (text == 'CITY_PART') {
							CITY_PART = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ITEM consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<ITEM_Z> ITEM {get;set;} 

	public RC_AddressDeltaIntegratorParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'ITEM') {
						ITEM = arrayOfITEM_Z(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'RC_GetAddressDeltaJSONParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class ADRCITYPRT {
		public List<ITEM> ITEM {get;set;} 

		public ADRCITYPRT(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ITEM') {
							ITEM = arrayOfITEM(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ADRCITYPRT consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ITEM_Z {
		public String ZDURUM {get;set;} 
		public String REGION {get;set;} 
		public String CITY_CODE {get;set;} 
		public String MC_CITY {get;set;} 
		public ADRCITYPRT ADRCITYPRT {get;set;} 

		public ITEM_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ZDURUM') {
							ZDURUM = parser.getText();
						} else if (text == 'REGION') {
							REGION = parser.getText();
						} else if (text == 'CITY_CODE') {
							CITY_CODE = parser.getText();
						} else if (text == 'MC_CITY') {
							MC_CITY = parser.getText();
						} else if (text == 'ADRCITYPRT') {
							ADRCITYPRT = new ADRCITYPRT(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ITEM_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static RC_AddressDeltaIntegratorParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_AddressDeltaIntegratorParser(parser);
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
	


    private static List<ITEM> arrayOfITEM(System.JSONParser p) {
        List<ITEM> res = new List<ITEM>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ITEM(p));
        }
        return res;
    }





    private static List<ITEM_Z> arrayOfITEM_Z(System.JSONParser p) {
        List<ITEM_Z> res = new List<ITEM_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ITEM_Z(p));
        }
        return res;
    }



}