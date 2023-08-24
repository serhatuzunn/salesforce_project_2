@isTest
public class RC_UploadLabelJsonParser_Test {
    static testMethod void testParse() {
        String json = '[{\"urunkodu\":20210100,\"baslik\":\"test1\",\"aciklama\":\"test2\",\"uretimyeri\":\"test3\"},{\"urunkodu\":20210101,\"baslik\":\"test1\",\"aciklama\":\"test2\",\"uretimyeri\":\"test3\"},{\"urunkodu\":20210102,\"baslik\":\"test1\",\"aciklama\":\"test2\",\"uretimyeri\":\"test3\"}]';
        List<RC_UploadLabelJsonParser> obj = RC_UploadLabelJsonParser.parse(json);
        System.JSONParser parser  = System.JSON.createParser(json);
        RC_UploadLabelJsonParser.consumeObject(parser);
        System.assert(obj != null);
    }
}