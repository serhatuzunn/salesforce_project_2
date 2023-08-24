public class RC_UploadLabelJsonParser {
    
    
    public string urunKodu {get;set;}     
    public string baslik {get;set;}        
    public string aciklama {get;set;}      
    public string uretimyeri {get;set;}    
    public string errorMess {get;set;}
    
    
    
    public RC_UploadLabelJsonParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'urunkodu') {
                        urunkodu = parser.getText();
                    } else if (text == 'baslik') {
                        baslik = parser.getText();
                    } else if (text == 'aciklama') {
                        aciklama = parser.getText();
                    } else if (text == 'uretimyeri') {
                        uretimyeri = parser.getText();
                    }                        
                    else {
                        System.debug(LoggingLevel.WARN, 'RC_UploadLabelJsonParser consuming unrecognized property: '+text);
                        consumeObject(parser);
                        errorMess=text;
                    }
                }
            }
        }
    }
    
    
    public static List<RC_UploadLabelJsonParser> parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfRC_UploadLabelJsonParser(parser);
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
    
    
    
    
    private static List<RC_UploadLabelJsonParser> arrayOfRC_UploadLabelJsonParser(System.JSONParser p) {
        List<RC_UploadLabelJsonParser> res = new List<RC_UploadLabelJsonParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new RC_UploadLabelJsonParser(p));
        }
        return res;
    }
    
    
}