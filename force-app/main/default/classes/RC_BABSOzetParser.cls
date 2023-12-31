//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class RC_BABSOzetParser {

	public class Item {
		public String MANDT {get;set;} 
		public String DONEM {get;set;} 
		public String SIRA {get;set;} 
		public String BLGTUR {get;set;} 
		public String MUHATAP {get;set;} 
		public String NAME1 {get;set;} 
		public String ULKE {get;set;} 
		public String VKN {get;set;} 
		public String TCN {get;set;} 
		public String ADET {get;set;} 
		public String MATRAH {get;set;} 

		public Item(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MANDT') {
							MANDT = parser.getText();
						} else if (text == 'DONEM') {
							DONEM = parser.getText();
						} else if (text == 'SIRA') {
							SIRA = parser.getText();
						} else if (text == 'BLGTUR') {
							BLGTUR = parser.getText();
						} else if (text == 'MUHATAP') {
							MUHATAP = parser.getText();
						} else if (text == 'NAME1') {
							NAME1 = parser.getText();
						} else if (text == 'ULKE') {
							ULKE = parser.getText();
						} else if (text == 'VKN') {
							VKN = parser.getText();
						} else if (text == 'TCN') {
							TCN = parser.getText();
						} else if (text == 'ADET') {
							ADET = parser.getText();
						} else if (text == 'MATRAH') {
							MATRAH = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Item consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class T_BADET {
		public List<Item> item {get;set;} 

		public T_BADET(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'item') {
							item = arrayOfItem(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'T_BADET consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    public class T_BSDET {
        public List<Item> item {get;set;} 
        
        public T_BSDET(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'item') {
                            item = arrayOfItem(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'T_BSDET consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
	public T_BADET T_BADET {get;set;} 
	public T_BSDET T_BSDET {get;set;} 

	public RC_BABSOzetParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'T_BADET') {
						T_BADET = new T_BADET(parser);
					} else if (text == 'T_BSDET') {
						T_BSDET = new T_BSDET(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'RC_BABSOzetParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static RC_BABSOzetParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_BABSOzetParser(parser);
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