public class RC_BordroCekGirParser {
    
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
        public String ROW {get;set;} 
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
                            ROW = parser.getText();
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
    
    public class ET_ITEMS {
        public List<Item_Y> item {get;set;} 
        
        public ET_ITEMS(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'item') {
                            item = arrayOfItem_Y(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'ET_ITEMS consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ET_RETURN {
        public List<Item> item {get;set;} 
        
        public ET_RETURN(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'item') {
                            item = arrayOfItem(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'ET_RETURN consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Item_Z {
        public String BOENUM {get;set;} 
        public String BUDAT {get;set;} 
        public String PORTFO {get;set;} 
        public String KUNNR {get;set;} 
        public String ZFBDT {get;set;} 
        public String XSIWE {get;set;} 
        public String WAERS {get;set;} 
        public String WRBTR {get;set;} 
        public String BANKL {get;set;} 
        public String BANKN {get;set;} 
        public String NAME1 {get;set;} 
        public String BOLGE {get;set;} 
        public String STCEG {get;set;} 
        public String FATURA {get;set;} 
        public String VKBUR {get;set;} 
        public String HZUON {get;set;} 
        
        public Item_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'BOENUM') {
                            BOENUM = parser.getText();
                        } else if (text == 'BUDAT') {
                            BUDAT = parser.getText();
                        } else if (text == 'PORTFO') {
                            PORTFO = parser.getText();
                        } else if (text == 'KUNNR') {
                            KUNNR = parser.getText();
                        } else if (text == 'ZFBDT') {
                            ZFBDT = parser.getText();
                        } else if (text == 'XSIWE') {
                            XSIWE = parser.getText();
                        } else if (text == 'WAERS') {
                            WAERS = parser.getText();
                        } else if (text == 'WRBTR') {
                            WRBTR = parser.getText();
                        } else if (text == 'BANKL') {
                            BANKL = parser.getText();
                        } else if (text == 'BANKN') {
                            BANKN = parser.getText();
                        } else if (text == 'NAME1') {
                            NAME1 = parser.getText();
                        } else if (text == 'BOLGE') {
                            BOLGE = parser.getText();
                        } else if (text == 'STCEG') {
                            STCEG = parser.getText();
                        } else if (text == 'FATURA') {
                            FATURA = parser.getText();
                        } else if (text == 'VKBUR') {
                            VKBUR = parser.getText();
                        } else if (text == 'HZUON') {
                            HZUON = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Item_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public ET_RETURN ET_RETURN {get;set;} 
    public CEK_ITEMS CEK_ITEMS {get;set;} 
    public ET_ITEMS ET_ITEMS {get;set;} 
    
    public RC_BordroCekGirParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'ET_RETURN') {
                        ET_RETURN = new ET_RETURN(parser);
                    } else if (text == 'CEK_ITEMS') {
                        CEK_ITEMS = new CEK_ITEMS(parser);
                    } else if (text == 'ET_ITEMS') {
                        ET_ITEMS = new ET_ITEMS(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'RC_BordroCekGirParser consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Item_Y {
        public String BELNR {get;set;} 
        public String BUZEI {get;set;} 
        public String KUNNR {get;set;} 
        public String BUDAT {get;set;} 
        public String ZFBDT {get;set;} 
        public String WAERS {get;set;} 
        public String DMBTR {get;set;} 
        public String SGTXT {get;set;} 
        public String BLART {get;set;} 
        public String AWKEY {get;set;} 
        public String GJAHR {get;set;} 
        public String ZLSPR {get;set;} 
        public String ZLSCH {get;set;} 
        public String LTEXT {get;set;} 
        public String MATNR {get;set;} 
        public String MAKTX {get;set;} 
        public String FKIMG {get;set;} 
        public String VRKME {get;set;} 
        public String KKBER {get;set;} 
        
        public Item_Y(JSONParser parser) {
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
                            GJAHR = parser.getText();
                        } else if (text == 'ZLSPR') {
                            ZLSPR = parser.getText();
                        } else if (text == 'ZLSCH') {
                            ZLSCH = parser.getText();
                        } else if (text == 'LTEXT') {
                            LTEXT = parser.getText();
                        } else if (text == 'MATNR') {
                            MATNR = parser.getText();
                        } else if (text == 'MAKTX') {
                            MAKTX = parser.getText();
                        } else if (text == 'FKIMG') {
                            FKIMG = parser.getText();
                        } else if (text == 'VRKME') {
                            VRKME = parser.getText();
                        } else if (text == 'KKBER') {
                            KKBER = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Item_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CEK_ITEMS {
        public List<Item_Z> item {get;set;} 
        
        public CEK_ITEMS(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'item') {
                            item = arrayOfItem_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'CEK_ITEMS consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static RC_BordroCekGirParser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new RC_BordroCekGirParser(parser);
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

    private static List<Item_Y> arrayOfItem_Y(System.JSONParser p) {
        List<Item_Y> res = new List<Item_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Item_Y(p));
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