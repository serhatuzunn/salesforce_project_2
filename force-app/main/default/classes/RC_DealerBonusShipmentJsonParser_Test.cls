@IsTest
public class RC_DealerBonusShipmentJsonParser_Test {
    static testMethod void testParse() {
        String json = '{'+
            '    \"ET_RETURN\": {'+
            '        \"item\": ['+
            '            {'+
            '                \"BSTNK\": \"\",'+
            '                \"POSNR\": \"\",'+
            '                \"ERDAT\": \"\",'+
            '                \"NAME1\": \"\",'+
            '                \"MATNR\": \"\",'+
            '                \"MATNR_T\": \"\",'+
            '                \"KWMENG\": \"\",'+
            '                \"KONDM\": \"\",'+
            '                \"KONDM_T\": \"\",'+
            '                \"KUNNR\": \"\",'+
            '                \"KUNNR_T\": \"\",'+
            '                \"ZDATE\": \"\",'+
            '                \"ZFIYAT1_BR\": 0.0,'+
            '                \"ZFIYAT1\": 0.0,'+
            '                \"ZFIYAT2_BR\": \"\",'+
            '                \"ZFIYAT2\": \"\",'+
            '                \"ORAN\": \"\",'+
            '                \"ZPRIM\": 0.0,'+
            '                \"ZPB\": \"\",'+
            '                \"KANAL\": \"\",'+
            '                \"PRODH\": \"\",'+
            '                \"PRODH_T\": \"\",'+
            '                \"BELNR_V\": \"\"'+
            '            }'+
            '        ]'+
            '    }'+
            '}';
        RC_DealerBonusShipmentJsonParser obj = RC_DealerBonusShipmentJsonParser.parse(json);
        System.assert(obj != null);
    }
}