public  class RC_IptalIadeConfirmOrderParser {
    
    public class Item
    {
        public string VBELN_VA;
        public string TYPE;
        public string ID;         
        public string MESSAGE;
        public string LOG_NO;
        public string LOG_MSG_NO;
        public string MESSAGE_V1;
        public string MESSAGE_V2;
        public string MESSAGE_V3;
        public string MESSAGE_V4;
        public string PARAMETER;
        public Integer ROW;
        public string FIELD;         
    }

    public class ET_ERROR_VBELN{
        public List<Item> item;
    }

    public class ET_MESSAGE{
        public List<Item> item;
    }

    public ET_ERROR_VBELN ET_ERROR_VBELN;
    public ET_MESSAGE ET_MESSAGE;
    public string EV_SUCCESS;


    public static RC_IptalIadeConfirmOrderParser parse(String json) {
		return (RC_IptalIadeConfirmOrderParser) System.JSON.deserialize(json, RC_IptalIadeConfirmOrderParser.class);
	}
}