@isTest(SeeAllData=true)
public class RC_IptalIadeGetOrdersIntegratorTest {
    @isTest static void unitTest(){
        test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RC_IptalIadeGetOrdersIntegratorMock());
        
        RC_IptalIadeGetOrdersIntegrator.requestModel req = new RC_IptalIadeGetOrdersIntegrator.requestModel();
        RC_IptalIadeGetOrdersIntegrator.Item_9 a = new RC_IptalIadeGetOrdersIntegrator.Item_9();
        a.VBELN_VL ='0319408703';
        RC_IptalIadeGetOrdersIntegrator.IT_VBELNVL tes = new RC_IptalIadeGetOrdersIntegrator.IT_VBELNVL();
        
        tes.Item = new List<RC_IptalIadeGetOrdersIntegrator.Item_9>();
        tes.Item.Add(a);
        req.IT_VBELN_VL = tes;
        req.IV_FKDAT_F = '20210331';
        req.IV_FKDAT_S = '20210301';
        req.IV_EMANET = '20210301'; 
        req.IV_AUDAT_S= '20210301';
        req.IV_AUDAT_F= '20210301';
        req.IT_VKBUR= new RC_IptalIadeGetOrdersIntegrator.IT_VKBUR();
        req.IT_VKGRP= new RC_IptalIadeGetOrdersIntegrator.IT_VKGRP();
        req.IT_VKORG= new RC_IptalIadeGetOrdersIntegrator.IT_VKORG();
        req.IT_VTWEG= new RC_IptalIadeGetOrdersIntegrator.IT_VTWEG();
        req.IT_MATNR= new RC_IptalIadeGetOrdersIntegrator.IT_MATNR();
        req.IT_VBELN_VA= new RC_IptalIadeGetOrdersIntegrator.IT_VBELN_VA();
        req.IT_VBELN_VF= new RC_IptalIadeGetOrdersIntegrator.IT_VBELN_VF();
        req.IT_VBELN_VL= new RC_IptalIadeGetOrdersIntegrator.IT_VBELNVL();
        req.IT_MATKL= new RC_IptalIadeGetOrdersIntegrator.IT_MATKL();
        req.IT_KUNNR= new RC_IptalIadeGetOrdersIntegrator.IT_KUNNR();
        req.IT_BUKRS= new RC_IptalIadeGetOrdersIntegrator.IT_BUKRS();
        req.IT_AUGRU= new RC_IptalIadeGetOrdersIntegrator.IT_AUGRU();
        req.IT_AUART= new RC_IptalIadeGetOrdersIntegrator.IT_AUART();
        
        RC_IptalIadeGetOrdersIntegrator.Item_1 i1 = new RC_IptalIadeGetOrdersIntegrator.Item_1();
        i1.AUART = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_2 i2 = new RC_IptalIadeGetOrdersIntegrator.Item_2();
        i2.AUGRU = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_3 i3 = new RC_IptalIadeGetOrdersIntegrator.Item_3();
        i3.BUKRS = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_4 i4 = new RC_IptalIadeGetOrdersIntegrator.Item_4();
        i4.KUNNR = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_5 i5 = new RC_IptalIadeGetOrdersIntegrator.Item_5();
        i5.MATKL = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_6 i6 = new RC_IptalIadeGetOrdersIntegrator.Item_6();
        i6.MATNR = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_7 i7 = new RC_IptalIadeGetOrdersIntegrator.Item_7();
        i7.VBELN_VA = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_8 i8 = new RC_IptalIadeGetOrdersIntegrator.Item_8();
        i8.VBELN_VF = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_9 i9 = new RC_IptalIadeGetOrdersIntegrator.Item_9();
        i9.VBELN_VL = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_10 i10 = new RC_IptalIadeGetOrdersIntegrator.Item_10();
        i10.VKBUR = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_11 i11 = new RC_IptalIadeGetOrdersIntegrator.Item_11();
        i11.VKGRP = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_12 i12 = new RC_IptalIadeGetOrdersIntegrator.Item_12();
        i12.VKORG = 'test';
        RC_IptalIadeGetOrdersIntegrator.Item_13 i13 = new RC_IptalIadeGetOrdersIntegrator.Item_13();
        i13.VTWEG = 'test';
        
        RC_IptalIadeGetOrdersIntegrator.responseModel resp = new RC_IptalIadeGetOrdersIntegrator.responseModel();
        resp.Result = new RC_IptalIadeGetOrdersParser.ET_RESULT();
        resp.Message = new RC_IptalIadeGetOrdersParser.ET_MESSAGE();          
        resp = RC_IptalIadeGetOrdersIntegrator.getIptalIade(req);       
        
        test.stopTest();
        
    }
}