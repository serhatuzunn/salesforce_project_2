@isTest
public class RC_AnaVeriTnmTest {
    @isTest 
    static void testHierarchy() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        Map<String, List<RC_AnaVeriTnm.ProductHierarchyModel>> hierarchyMap = new Map<String, List<RC_AnaVeriTnm.ProductHierarchyModel>>();
        RC_AnaVeriTnm.saveUrunHierarchy(hierarchyMap);
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSaveUrunHierarchy() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Map<String, List<RC_AnaVeriTnm.ProductHierarchyModel>> hierarchyMap = new Map<String, List<RC_AnaVeriTnm.ProductHierarchyModel>>();
        
        List<RC_AnaVeriTnm.ProductHierarchyModel> hierarchy1List = new List<RC_AnaVeriTnm.ProductHierarchyModel>();
        
        RC_AnaVeriTnm.ProductHierarchyModel hierarchyModel = new RC_AnaVeriTnm.ProductHierarchyModel();
        hierarchyModel.PRODH = 'PRODH';
        hierarchyModel.STUFE = 'STUFE';
        hierarchyModel.VTEXT = 'VTEXT';
        
        hierarchy1List.add(hierarchyModel);
        
        hierarchyMap.put('1', hierarchy1List);
        
        Test.startTest();
        
        RC_AnaVeriTnm.saveUrunHierarchy(hierarchyMap);
        
        Test.stopTest();
    }
    
    @isTest 
    static void testMarka() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriIntegratorParser result = new RC_AnaVeriIntegratorParser();
        result.ET_TNM_MARKA = new RC_AnaVeriIntegratorParser.ET_TNM_MARKA();
        result.ET_TNM_MARKA.item = new List<RC_AnaVeriIntegratorParser.Item_A>();
        
        RC_AnaVeriIntegratorParser.Item_A itemA = new RC_AnaVeriIntegratorParser.Item_A();
        itemA.BEZEI = 'BEZEI';
        itemA.ZZMARKA = 'ZZMARKA';
        
        result.ET_TNM_MARKA.item.add(itemA);
        
        RC_AnaVeriTnm.saveMarka(result.ET_TNM_MARKA.item, 'RC_Brand');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testDepoYeri() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriIntegratorParser result = new RC_AnaVeriIntegratorParser();
        result.ET_TNM_DEPO_YERI = new RC_AnaVeriIntegratorParser.ET_TNM_DEPO_YERI();
        result.ET_TNM_DEPO_YERI.item = new List<RC_AnaVeriIntegratorParser.Item_Depo_Yeri>();
        
        RC_AnaVeriIntegratorParser.Item_Depo_Yeri Item_Depo_Yeri = new RC_AnaVeriIntegratorParser.Item_Depo_Yeri();
        Item_Depo_Yeri.LGOBE = 'LGOBE';
        Item_Depo_Yeri.LGORT = 'LGORT';
        
        result.ET_TNM_DEPO_YERI.item.add(Item_Depo_Yeri);
        
        RC_AnaVeriTnm.saveDepoYeri(result.ET_TNM_DEPO_YERI.item);
        
        Test.stopTest();
    }
    
    @isTest 
    static void testUretimYeri() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriIntegratorParser result = new RC_AnaVeriIntegratorParser();
        result.ET_TNM_URETIM_YERI = new RC_AnaVeriIntegratorParser.ET_TNM_URETIM_YERI();
        result.ET_TNM_URETIM_YERI.item = new List<RC_AnaVeriIntegratorParser.Item_Uretim_Yeri>();
        
        RC_AnaVeriIntegratorParser.Item_Uretim_Yeri Item_Uretim_Yeri = new RC_AnaVeriIntegratorParser.Item_Uretim_Yeri();
        Item_Uretim_Yeri.NAME1 = 'NAME1';
        Item_Uretim_Yeri.WERKS = 'WERKS';
        
        result.ET_TNM_URETIM_YERI.item.add(Item_Uretim_Yeri);
        
        RC_AnaVeriTnm.saveUretimYeri(result.ET_TNM_URETIM_YERI.item);
        
        Test.stopTest();
    }
    
    @isTest 
    static void testMaterialMalzGroup() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriIntegratorParser result = new RC_AnaVeriIntegratorParser();
        result.ET_TNM_MALZ_GRUBU = new RC_AnaVeriIntegratorParser.ET_TNM_MALZ_GRUBU();
        result.ET_TNM_MALZ_GRUBU.item = new List<RC_AnaVeriIntegratorParser.Item_X>();
        
        RC_AnaVeriIntegratorParser.Item_X Item_X = new RC_AnaVeriIntegratorParser.Item_X();
        Item_X.BEZEI = 'BEZEI';
        Item_X.MVGR2 = 'MVGR2';
        
        result.ET_TNM_MALZ_GRUBU.item.add(Item_X);
        
        RC_AnaVeriTnm.saveMaterialMalzGroup(result.ET_TNM_MALZ_GRUBU.item, 'RC_Material_Group_2');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testTnm() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriTnm.getTnm();
        
        Test.stopTest();
    }
    
    @isTest 
    static void testGlobalValueSetUrlId() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriTnm.getGlobalValueSetUrlId('developerName');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testGetUrunHierarchy() {
        Test.setMock(HttpCalloutMock.class, new RC_AnaVeriIntegratorMock());
        
        Test.startTest();
        
        RC_AnaVeriTnm.getUrunHierarchy();
        
        Test.stopTest();
    }
    
    
}