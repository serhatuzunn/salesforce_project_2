public class RC_FI_OrtalamaVadeJsonParser {

	public class Item {
		public String BLINE_DATE {get;set;} 
		public Integer DSCT_DAYS1 {get;set;} 
		public String PSTNG_DATE {get;set;} 
		public String DB_CR_IND {get;set;} 
		public String LC_AMOUNT {get;set;} 

		public Item(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'BLINE_DATE') {
							BLINE_DATE = parser.getText();
						} else if (text == 'DSCT_DAYS1') {
							DSCT_DAYS1 = parser.getIntegerValue();
						} else if (text == 'PSTNG_DATE') {
							PSTNG_DATE = parser.getText();
						} else if (text == 'DB_CR_IND') {
							DB_CR_IND = parser.getText();
						} else if (text == 'LC_AMOUNT') {
							LC_AMOUNT = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Item consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class IT_LINEITEMS {
		public List<Item> item {get;set;} 

		public IT_LINEITEMS(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'IT_LINEITEMS consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String EV_BAKIYE {get;set;} 
	public String EV_ORTVADE {get;set;} 
	public IT_LINEITEMS IT_LINEITEMS {get;set;} 

	public RC_FI_OrtalamaVadeJsonParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'EV_BAKIYE') {
						EV_BAKIYE = parser.getText();
					} else if (text == 'EV_ORTVADE') {
						EV_ORTVADE = parser.getText();
					} else if (text == 'IT_LINEITEMS') {
						IT_LINEITEMS = new IT_LINEITEMS(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'RC_FI_OrtalamaVadeJsonParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static RC_FI_OrtalamaVadeJsonParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_FI_OrtalamaVadeJsonParser(parser);
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