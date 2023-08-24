@isTest
public class RC_GetGiftVoucherCheckControllerTest {
 @isTest
    public static void unitTest(){
        
        string CHECK_NO = '8018456517';
        string IT_BAYI_NO = '11';
        string IT_DOCUMENT_DATE = '2020-09-30';
        
        string IT_MATBU_NO = '123456';
        string recordId = 'a0p8E000003zpXeQAI';
         string TYPE = 'G';
        
          Account acc = new Account();
        acc.Name='test';
        acc.RC_SAP_ID__c='20100340';
        insert acc;
        
            
        Rc_Vcell_and_Gift_Card__c definition = new Rc_Vcell_and_Gift_Card__c();
        definition.Rc_Cheque_No__c = CHECK_NO;
        definition.Rc_Type__c = TYPE;
        definition.Rc_Dealer__c  = acc.id;
        insert definition;
        
        
         Test.setMock(HttpCalloutMock.class, new RC_GetGiftVoucherCheckMock());
         Test.setMock(HttpCalloutMock.class, new RC_GetGiftVoucherUseMock());
         
        
          Test.startTest();
        
       RC_GetGiftVoucherCheckController.InquireClick(CHECK_NO);
        RC_GetGiftVoucherCheckController.VGetGiftUseClick(CHECK_NO);
        RC_GetGiftVoucherCheckController.VGiftUseSetObjeClick(definition.Id,Date.valueOf(IT_DOCUMENT_DATE),IT_MATBU_NO);
        RC_GetGiftVoucherCheckController.VestelCellCreateParametric(CHECK_NO,acc.id,IT_DOCUMENT_DATE,IT_MATBU_NO);
        
      
        Test.stopTest(); 
        
         
        
    }
}