public class RC_EmanetStokIntegratorParser {

    public ET_OUTPUT ET_OUTPUT;
    
    public class ET_OUTPUT {
        @AuraEnabled
        public List<Item_Z> item;
    }
   
    public class Item_Z {
        @AuraEnabled
        public String MATNR;
        @AuraEnabled
        public String MAKTX;
        @AuraEnabled
        public String WERKS;
        @AuraEnabled
        public String KULAB;
        @AuraEnabled
        public String OMENG;
        @AuraEnabled
        public String CHARG;
        @AuraEnabled
        public String KUNNR;
         @AuraEnabled
        public String ZZMARKA;
         @AuraEnabled
        public String KONDM;
    }
    
        public static RC_EmanetStokIntegratorParser parse(String json) {
        return (RC_EmanetStokIntegratorParser) System.JSON.deserialize(json, RC_EmanetStokIntegratorParser.class);
    }
}