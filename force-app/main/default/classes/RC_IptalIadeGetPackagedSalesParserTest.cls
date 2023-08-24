@IsTest
    public class RC_IptalIadeGetPackagedSalesParserTest {
        static testMethod void testParse() {
            String json = '{'+
            '    \"ET_EXPORT6\": {'+
            '        \"item\": ['+
            '            {'+
            '                \"AUGRU\": \"MM8\",'+
            '                \"KONDM\": 29'+
            '            },'+
            '            {'+
            '                \"AUGRU\": \"MM8\",'+
            '                \"KONDM\": 84'+
            '            },'+
            '            {'+
            '                \"AUGRU\": \"MM8\",'+
            '                \"KONDM\": 85'+
            '            },'+
            '            {'+
            '                \"AUGRU\": \"MM8\",'+
            '                \"KONDM\": 86'+
            '            }'+
            '        ]'+
            '    },'+
            '    \"EV_ID\": \"0006\",'+
            '    \"EV_PACKAGE\": \"S\"'+
            '}';
            RC_IptalIadeGetPackagedSalesParser obj = RC_IptalIadeGetPackagedSalesParser.parse(json);
            System.assert(obj != null);
        }
    }