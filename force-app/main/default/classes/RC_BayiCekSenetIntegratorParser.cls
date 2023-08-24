public class RC_BayiCekSenetIntegratorParser {
    
    public class CEK_DTS {
        @AuraEnabled
        public List<Item> item;
    }
    public class CEK_MUSTERI {
        @AuraEnabled
        public List<Item> item;
    }
    public class CEK_SAHSI {
        @AuraEnabled
        public List<Item> item;
    }
    public class CEK_BAGLANTI {
        @AuraEnabled
        public List<Item> item;
    }
    public class SENET_MUSTERI {
        @AuraEnabled
        public List<Item> item;
    }
    public class SENET_BAGLANTI {
        @AuraEnabled
        public List<Item> item;
    }
    public class SENET_SAHSI {
        @AuraEnabled
        public List<Item> item;
    }
    public class Item {
        @AuraEnabled
        public string AYIND;
        @AuraEnabled
        public String TUTAR;
        @AuraEnabled
        public String BORALA;
        @AuraEnabled
        public String VADE;
        @AuraEnabled
        public String WAERS;
        @AuraEnabled
        public String PORTF;
        @AuraEnabled
        public String BOENO;
    }
    
    public ET_RETURN ET_RETURN;
    
    public class ET_RETURN {
        @AuraEnabled
        public List<Item_Z> item;
    }
    
    public class Item_Z {
        @AuraEnabled
        public string CEK_SAHSI_TOP; 
        @AuraEnabled
        public CEK_SAHSI CEK_SAHSI;
        @AuraEnabled
        public string CEK_MUSTERI_TOP;
        @AuraEnabled
        public CEK_MUSTERI CEK_MUSTERI;
        @AuraEnabled
        public string CEK_DTS_TOP;
        @AuraEnabled
        public CEK_DTS CEK_DTS;
        @AuraEnabled
        public String CEK_BAGLANTI_TOP;
        @AuraEnabled
        public CEK_BAGLANTI CEK_BAGLANTI;
        @AuraEnabled
        public string SENET_SAHSI_TOP;
        @AuraEnabled
        public SENET_SAHSI SENET_SAHSI;
        @AuraEnabled
        public string SENET_MUSTERI_TOP;
        @AuraEnabled    
        public SENET_MUSTERI SENET_MUSTERI;
        @AuraEnabled
        public string SENET_BAGLANTI_TOP;
        @AuraEnabled
        public SENET_BAGLANTI SENET_BAGLANTI;
    }
    
    
    public static RC_BayiCekSenetIntegratorParser parse(String json) {
        return (RC_BayiCekSenetIntegratorParser) System.JSON.deserialize(json, RC_BayiCekSenetIntegratorParser.class);
    }
}