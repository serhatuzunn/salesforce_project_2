public class RC_BordroGirParser {
    
    public class Item {
        public String BELNR;
        public String BUZEI;
        public String KUNNR;
        public String BUDAT;
        public String ZFBDT;
        public String WAERS;
        public String DMBTR;
        public String SGTXT;
        public String BLART;
        public String VKBUR;
    }
    
    public String BORDRONO;
    public Integer EV_BAKIYE;
    public String EV_KKBER;
    public String EV_MESSAGE;
    public String EV_ORTVADE;
    public String EV_SUCCESS;
    public IT_ITEMS IT_ITEMS;
    
    public class IT_ITEMS {
        public List<Item> item;
    }
    
    public static RC_BordroGirParser parse(String json) {
        return (RC_BordroGirParser) System.JSON.deserialize(json, RC_BordroGirParser.class);
    }
}