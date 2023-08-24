public class RC_AcikKalemlerParser {

	public class Item {
		@AuraEnabled
		public String MATNR {get;set;} 
		@AuraEnabled
		public String MAKTX {get;set;} 
		@AuraEnabled
		public String FKIMG {get;set;} 
		@AuraEnabled
		public String VRKME {get;set;} 

		public Item(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MATNR') {
							MATNR = parser.getText();
						} else if (text == 'MAKTX') {
							MAKTX = parser.getText();
						} else if (text == 'FKIMG') {
							FKIMG = parser.getText();
						} else if (text == 'VRKME') {
							VRKME = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Item consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ET_ITEMS {
		@AuraEnabled
		public List<Item_Z> item {get;set;} 

		public ET_ITEMS(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ET_ITEMS consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	@AuraEnabled
	public ET_ITEMS ET_ITEMS {get;set;} 
	@AuraEnabled
	public String EV_BAKIYE {get;set;} 
	@AuraEnabled
	public String EV_ORTVADE {get;set;} 
	@AuraEnabled
	public Integer EV_TOTAL_IND {get;set;} 

	public RC_AcikKalemlerParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'ET_ITEMS') {
						ET_ITEMS = new ET_ITEMS(parser);
					} else if (text == 'EV_BAKIYE') {
						EV_BAKIYE = parser.getText();
					} else if (text == 'EV_ORTVADE') {
						EV_ORTVADE = parser.getText();
					} else if (text == 'EV_TOTAL_IND') {
						EV_TOTAL_IND = parser.getIntegerValue();
					} else {
						System.debug(LoggingLevel.WARN, 'RC_AcikKalemlerParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Item_Z {
		@AuraEnabled
		public String BELNR {get;set;} 
		@AuraEnabled
		public String BUZEI {get;set;} 
		@AuraEnabled
		public String KUNNR {get;set;} 
		@AuraEnabled
		public String BUDAT {get;set;} 
		@AuraEnabled
		public String ZFBDT {get;set;} 
		@AuraEnabled
		public String WAERS {get;set;} 
		@AuraEnabled
		public String DMBTR {get;set;} 
		@AuraEnabled
		public String SGTXT {get;set;} 
		@AuraEnabled
		public String BLART {get;set;} 
		@AuraEnabled
		public String AWKEY {get;set;} 
		@AuraEnabled
		public Integer GJAHR {get;set;} 
		@AuraEnabled
		public String ZLSPR {get;set;} 
		@AuraEnabled
		public String ZLSCH {get;set;} 
		@AuraEnabled
		public String LTEXT {get;set;} 
		@AuraEnabled
		public MATNR MATNR {get;set;} 
		@AuraEnabled
		public String MAKTX {get;set;} 
		@AuraEnabled
		public String KKBER {get;set;} 
		@AuraEnabled
		public String formattedProductInfo {get;set;} 


		public Item_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'BELNR') {
							BELNR = parser.getText();
						} else if (text == 'BUZEI') {
							BUZEI = parser.getText();
						} else if (text == 'KUNNR') {
							KUNNR = parser.getText();
						} else if (text == 'BUDAT') {
							BUDAT = parser.getText();
						} else if (text == 'ZFBDT') {
							ZFBDT = parser.getText();
						} else if (text == 'WAERS') {
							WAERS = parser.getText();
						} else if (text == 'DMBTR') {
							DMBTR = parser.getText();
						} else if (text == 'SGTXT') {
							SGTXT = parser.getText();
						} else if (text == 'BLART') {
							BLART = parser.getText();
						} else if (text == 'AWKEY') {
							AWKEY = parser.getText();
						} else if (text == 'GJAHR') {
							GJAHR = parser.getIntegerValue();
						} else if (text == 'ZLSPR') {
							ZLSPR = parser.getText();
						} else if (text == 'ZLSCH') {
							ZLSCH = parser.getText();
						} else if (text == 'LTEXT') {
							LTEXT = parser.getText();
						} else if (text == 'MATNR') {
							MATNR = new MATNR(parser);
						} else if (text == 'MAKTX') {
							MAKTX = parser.getText();
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
	
	public class MATNR {
		@AuraEnabled
		public List<Item> item {get;set;} 

		public MATNR(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'MATNR consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static RC_AcikKalemlerParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_AcikKalemlerParser(parser);
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