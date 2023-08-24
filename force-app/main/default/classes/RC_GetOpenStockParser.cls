public class RC_GetOpenStockParser {
public class Item {
        @AuraEnabled
        public String MATNR;
    
    
        @AuraEnabled
        public String VBELN;
        @AuraEnabled
        public String KUNNR;
        @AuraEnabled
        public String KLMENG;
        @AuraEnabled
        public String RFMNG;
        @AuraEnabled
        public String FARK;
        @AuraEnabled
        public String KZWI2;
        @AuraEnabled
        public String MEINS;
        @AuraEnabled
        public String WAERK;
        
    }
    
    public class ET_OUTPUT {
        @AuraEnabled
        public List<Item> item;
    }
    
  
    
    @AuraEnabled
    public ET_OUTPUT ET_OUTPUT;
 
    
    
    public static RC_GetOpenStockParser parse(String json) {
        return (RC_GetOpenStockParser) System.JSON.deserialize(json, RC_GetOpenStockParser.class);
    }
}