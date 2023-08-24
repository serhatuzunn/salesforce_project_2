public class ZFI_SF_BordroYapParser {

	public class Item {
		@AuraEnabled
		public String AUGRU {get;set;} 

		public Item(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AUGRU') {
							AUGRU = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Item consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	@AuraEnabled
	public String EV_MESSAGE {get;set;} 
	@AuraEnabled
	public IN_TAUGRU IN_TAUGRU {get;set;}
	@AuraEnabled 
	public IO_TKUNNR IO_TKUNNR {get;set;} 

	public ZFI_SF_BordroYapParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'EV_MESSAGE') {
						EV_MESSAGE = parser.getText();
					} else if (text == 'IN_TAUGRU') {
						IN_TAUGRU = new IN_TAUGRU(parser);
					} else if (text == 'IO_TKUNNR') {
						IO_TKUNNR = new IO_TKUNNR(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ZFI_SF_BordroYapParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Item_Z {
		@AuraEnabled
		public String KUNNR {get;set;} 
		@AuraEnabled
		public String BORDROTYPE {get;set;} 
		@AuraEnabled
		public String SONUC {get;set;} 
		@AuraEnabled
		public String BORDRONO {get;set;} 
		@AuraEnabled
		public String MSG {get;set;} 
		@AuraEnabled
		public String KKBER {get;set;} 

		public Item_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'KUNNR') {
							KUNNR = parser.getText();
						} else if (text == 'BORDROTYPE') {
							BORDROTYPE = parser.getText();
						} else if (text == 'SONUC') {
							SONUC = parser.getText();
						} else if (text == 'BORDRONO') {
							BORDRONO = parser.getText();
						} else if (text == 'MSG') {
							MSG = parser.getText();
						} else if (text == 'KKBER') {
							KKBER = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Item_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class IO_TKUNNR {
		@AuraEnabled
		public List<Item_Z> item {get;set;} 

		public IO_TKUNNR(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'IO_TKUNNR consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class IN_TAUGRU {
		@AuraEnabled
		public List<Item> item {get;set;} 

		public IN_TAUGRU(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'IN_TAUGRU consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ZFI_SF_BordroYapParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ZFI_SF_BordroYapParser(parser);
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
	



    private static List<Item_Z> arrayOfItem_Z(System.JSONParser p) {
        List<Item_Z> res = new List<Item_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Item_Z(p));
        }
        return res;
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