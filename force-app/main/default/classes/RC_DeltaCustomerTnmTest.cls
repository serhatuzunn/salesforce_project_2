@isTest
public class RC_DeltaCustomerTnmTest {
    
    @isTest 
    static void testSaveDgtmKanal() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_DGTM_KANAL = new RC_DeltaCustomerIntegratorParser.ET_TNM_DGTM_KANAL();
        result.ET_TNM_DGTM_KANAL.item = new List<RC_DeltaCustomerIntegratorParser.Item>();
        
        RC_DeltaCustomerIntegratorParser.Item item = new RC_DeltaCustomerIntegratorParser.Item();
        item.VTWEG = 'VTWEG';
        item.VTEXT = 'VTEXT';
        
        result.ET_TNM_DGTM_KANAL.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveDgtmKanal(result.ET_TNM_DGTM_KANAL.item, '', '', '');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveFtrBlgTr() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_FTR_BLG_TR = new RC_DeltaCustomerIntegratorParser.ET_TNM_FTR_BLG_TR();
        result.ET_TNM_FTR_BLG_TR.item = new List<RC_DeltaCustomerIntegratorParser.Item_Z>();
        
        RC_DeltaCustomerIntegratorParser.Item_Z item = new RC_DeltaCustomerIntegratorParser.Item_Z();
        item.FKART = 'FKART';
        item.VTEXT = 'VTEXT';
        
        result.ET_TNM_FTR_BLG_TR.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveFtrBlgTr(result.ET_TNM_FTR_BLG_TR.item, '', '', '');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveKrediKntr() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_KREDI_KNTR = new RC_DeltaCustomerIntegratorParser.ET_TNM_KREDI_KNTR();
        result.ET_TNM_KREDI_KNTR.item = new List<RC_DeltaCustomerIntegratorParser.Item_Y>();
        
        RC_DeltaCustomerIntegratorParser.Item_Y item = new RC_DeltaCustomerIntegratorParser.Item_Y();
        item.KKBER = 'KKBER';
        item.KKBTX = 'KKBTX';
        
        result.ET_TNM_KREDI_KNTR.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveKrediKntr(result.ET_TNM_KREDI_KNTR.item, '', '', '');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveMustGrubu() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_MUST_GRUBU = new RC_DeltaCustomerIntegratorParser.ET_TNM_MUST_GRUBU();
        result.ET_TNM_MUST_GRUBU.item = new List<RC_DeltaCustomerIntegratorParser.Item_X>();
        
        RC_DeltaCustomerIntegratorParser.Item_X item = new RC_DeltaCustomerIntegratorParser.Item_X();
        item.KDGRP = 'KDGRP';
        item.KTEXT = 'KTEXT';
        
        result.ET_TNM_MUST_GRUBU.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveMustGrubu(result.ET_TNM_MUST_GRUBU.item, '', '', '');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveSatisBuro() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_SATIS_BURO = new RC_DeltaCustomerIntegratorParser.ET_TNM_SATIS_BURO();
        result.ET_TNM_SATIS_BURO.item = new List<RC_DeltaCustomerIntegratorParser.Item_W>();
        
        RC_DeltaCustomerIntegratorParser.Item_W item = new RC_DeltaCustomerIntegratorParser.Item_W();
        item.VKBUR = 'VKBUR';
        item.BEZEI = 'BEZEI';
        
        result.ET_TNM_SATIS_BURO.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveSatisBuro(result.ET_TNM_SATIS_BURO.item, '', '', '');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveSatisMdr() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_SATIS_MDR = new RC_DeltaCustomerIntegratorParser.ET_TNM_SATIS_MDR();
        result.ET_TNM_SATIS_MDR.item = new List<RC_DeltaCustomerIntegratorParser.Item_V>();
        
        RC_DeltaCustomerIntegratorParser.Item_V item = new RC_DeltaCustomerIntegratorParser.Item_V();
        item.VKGRP = 'VKGRP';
        item.BEZEI = 'BEZEI';
        
        result.ET_TNM_SATIS_MDR.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveSatisMdr(result.ET_TNM_SATIS_MDR.item, '', '', '');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveSatisOrg() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_SATIS_ORG = new RC_DeltaCustomerIntegratorParser.ET_TNM_SATIS_ORG();
        result.ET_TNM_SATIS_ORG.item = new List<RC_DeltaCustomerIntegratorParser.Item_U>();
        
        RC_DeltaCustomerIntegratorParser.Item_U item = new RC_DeltaCustomerIntegratorParser.Item_U();
        item.VKORG = 'VKORG';
        item.VTEXT = 'VTEXT';
        
        result.ET_TNM_SATIS_ORG.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveSatisOrg(result.ET_TNM_SATIS_ORG.item, '', '', '');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveTeslBlgTr() {
        
        RC_DeltaCustomerIntegratorParser result = new RC_DeltaCustomerIntegratorParser();
        result.ET_TNM_TESL_BLG_TR = new RC_DeltaCustomerIntegratorParser.ET_TNM_TESL_BLG_TR();
        result.ET_TNM_TESL_BLG_TR.item = new List<RC_DeltaCustomerIntegratorParser.Item_T>();
        
        RC_DeltaCustomerIntegratorParser.Item_T item = new RC_DeltaCustomerIntegratorParser.Item_T();
        item.LFART = 'LFART';
        item.VTEXT = 'VTEXT';
        
        result.ET_TNM_TESL_BLG_TR.item.add(item);
        Test.startTest();
        
        RC_DeltaCustomerTnm.saveTeslBlgTr(result.ET_TNM_TESL_BLG_TR.item, '', '', '');
        
        Test.stopTest();
    }
    
    
    
}