public class RC_SD_BaglantiParser {
    
    public class Item {
        @AuraEnabled
        public String BUKRS;
        @AuraEnabled
        public String BELNR;
        @AuraEnabled
        public String GJAHR;
        @AuraEnabled
        public String UMSKZ;
        @AuraEnabled
        public String SHKZG;
        @AuraEnabled
        public String H_BLART;
        @AuraEnabled
        public String NETDT;
        @AuraEnabled
        public String DMBTR;
        @AuraEnabled
        public String KUNNR;
        @AuraEnabled
        public String H_BUDAT;
        @AuraEnabled
        public String H_BLDAT;
        @AuraEnabled
        public String ZZBGL_DNM;
    }
    
    public class ET_RETURN {
        @AuraEnabled
        public List<Item_Y> item;
    }
    
    public class FAT_DETAY {
        @AuraEnabled
        public List<Item> item;
    }
    
    public class Item_Z {
        @AuraEnabled
        public String BUKRS;
        @AuraEnabled
        public String BELNR;
        @AuraEnabled
        public String GJAHR;
        @AuraEnabled
        public String UMSKZ;
        @AuraEnabled
        public String SHKZG;
        @AuraEnabled
        public String H_BLART;
        @AuraEnabled
        public String NETDT;
        @AuraEnabled
        public String DMBTR;
        @AuraEnabled
        public String KUNNR;
        @AuraEnabled
        public String H_BUDAT;
        @AuraEnabled
        public String ZZBGL_DNM;
        @AuraEnabled
        public String PORTF;
    }
    
    public class CEK_DETAY {
        @AuraEnabled
        public List<Item_Z> item;
    }
    
    public class Item_Y {
        @AuraEnabled
        public String ZTERM;
        @AuraEnabled
        public String BUKRS;
        @AuraEnabled
        public String KUNNR;
        @AuraEnabled
        public String GJAHR;
        @AuraEnabled
        public String SOZLESME_NO;
        @AuraEnabled
        public String SOZLESME_BAS;
        @AuraEnabled
        public String SOZLESME_BIT;
        @AuraEnabled
        public String VADE_TARIH;
        @AuraEnabled
        public String TOPLAM_CEK;
        @AuraEnabled
        public String FAT_TOTAL;
        @AuraEnabled
        public String FAT_ORT_VADE;
        @AuraEnabled
        public String FAT_ORT_TARIH;
        @AuraEnabled
        public String FAT_VADE_TARIH;
        @AuraEnabled
        public FAT_DETAY FAT_DETAY;
        @AuraEnabled
        public String BAGCEK_TOTAL1;
        @AuraEnabled
        public String BAGCEK_ORT_VADE1;
        @AuraEnabled
        public String BAGCEK_ORT_TARIH;
        @AuraEnabled
        public String BAGCEK_VADE_TARIH;
        @AuraEnabled
        public CEK_DETAY CEK_DETAY;
    }
    
    public ET_RETURN ET_RETURN;
    
    
    public static RC_SD_BaglantiParser parse(String json) {
        return (RC_SD_BaglantiParser) System.JSON.deserialize(json, RC_SD_BaglantiParser.class);
    }
}