public class RC_GetStockMaterialInfoParser {

    
    public class Item {
        @AuraEnabled
        public String MATNR;
        @AuraEnabled
        public String EBELP;
        @AuraEnabled
        public String EBELN;
        @AuraEnabled
        public String KMONTH;
        @AuraEnabled
        public String GLTRP;
        @AuraEnabled
        public String GSTRP;
        @AuraEnabled
        public String EINDT;
        @AuraEnabled
        public String SASMIKTAR;
     
        @AuraEnabled
        public SASKALAN SASKALAN;
        
        
        @AuraEnabled
        public String MEINS;
        
                        @AuraEnabled
        public String SASKALANMIKTAR;
      
       
    }
    
     public class ET_MATNR_LIST {
        @AuraEnabled
        public List<Item> item;
    }
    
     public class SASKALAN {
        @AuraEnabled
        public List<ItemDagitim> item;
    }
    
	 public class ItemDagitim {
        @AuraEnabled
        public String WERKS;
        @AuraEnabled
        public String LGORT;
        @AuraEnabled
        public String MENGE;
        @AuraEnabled
        public String MEINS;
        
    
  
    }
    
      
   @AuraEnabled
    public ET_MATNR_LIST ET_MATNR_LIST;
  
    
      public static RC_GetStockMaterialInfoParser parse(String json) {
        return (RC_GetStockMaterialInfoParser) System.JSON.deserialize(json, RC_GetStockMaterialInfoParser.class);
    }
    
}