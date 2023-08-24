public class RC_GetCustomerOrdersJsonParser {
    
    public ET_ORDERS ET_ORDERS;
    public ET_ORDERS_H ET_ORDERS_H;    
    
    public class Item {
        public String VBELN;
        public String POSNR;
        public String MATNR;
        public String ARKTX;
        public String KWMENG;
        public String PURCHQUA;
        public String NETWR;
        public String UEPOS;
    }
    
    public class ET_ORDERS {
        public List<Item> item;
    }
    
    public class ET_ORDERS_H {
        public List<Item_Z> item;
    }
    
    public class Item_Z {
        public String VBELN;
        public String AUDAT;
        public String NETWR;
    }    
    
    
    public static RC_GetCustomerOrdersJsonParser parse(String json) {
        return (RC_GetCustomerOrdersJsonParser) System.JSON.deserialize(json, RC_GetCustomerOrdersJsonParser.class);
    }
    
}