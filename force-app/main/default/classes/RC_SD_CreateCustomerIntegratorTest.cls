@isTest
public class RC_SD_CreateCustomerIntegratorTest {
 @isTest
    public static void UnitTest(){
        
        RC_SD_CreateCustomerIntegrator.CreateSAPCustomerResponse resp = new RC_SD_CreateCustomerIntegrator.CreateSAPCustomerResponse();
        
         resp.Messages='';
        resp.SAPCustomerID='';
        resp.IntegrationStatus='';
        RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper req = new RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper();
        RC_SD_CreateCustomerIntegrator.IS_GENERAL_DATA generaldata=  new RC_SD_CreateCustomerIntegrator.IS_GENERAL_DATA();
	        
        generaldata.PARTNERGROUP='';
        generaldata.CUSTOMER_NAME_1='TESTBAYİ444';
        generaldata.CUSTOMER_NAME_2='TT';
        generaldata.CUSTOMER_NAME_3='';
        generaldata.CUSTOMER_NAME_4='';
        generaldata.SEARCH_KEY='TESTBAYİ444';
        generaldata.STREET='RAGIP TÜZÜN CAD. NO:168/ B .';
        generaldata.DISTRICT='RAGIP TÜZÜN MAH.';
        generaldata.CITY='ETIMESGUT';
        generaldata.CITY_CODE='006';
        generaldata.POST_CODE='06231';
        generaldata.PHONE='3123446857';
        generaldata.FAX='3123446857';
        generaldata.EMAIL='TEST@VESTELBAYI.COM';
        generaldata.TAX_AREA='YENİMAHALLE';
        generaldata.TAX_NUMBER='98708822222';
        generaldata.TRANSPZONE='';
        generaldata.LANGU='TR';
        generaldata.LOCCO='';
        generaldata.CONTROL_ACCOUNT='';
        generaldata.ZWELS='';
        generaldata.XZVER='';
        generaldata.ZZLONGITUDE='';
        generaldata.ZZLATITUDE='';
                
         List<RC_SD_CreateCustomerIntegrator.IS_SALES_DATA> salesdataList= new  List<RC_SD_CreateCustomerIntegrator.IS_SALES_DATA>();
	     RC_SD_CreateCustomerIntegrator.IS_SALES_DATA salesdata= new  RC_SD_CreateCustomerIntegrator.IS_SALES_DATA();
     			 salesdata.VKORG='2201';
                 salesdata.VTWEG='01';
                 salesdata.SPART='21';
                 salesdata.VKBUR='0072';
                 salesdata.VKGRP='724';
                 salesdata.KONDA='';
                 salesdata.KALKS='';
                 salesdata.KDGRP='';
                 salesdata.BZIRK='';
                 salesdata.WAERS='TRY';
                 salesdata.PLTYP='';
                 salesdata.VERSG='';
                 salesdata.LPRIO='00';
                 salesdata.VWERK='';
                 salesdata.VSBED='';
                 salesdata.KTGRD='';
                 salesdata.TAXKD='';
        
             RC_SD_CreateCustomerIntegrator.PARTNERS partners= new RC_SD_CreateCustomerIntegrator.PARTNERS();
                List<RC_SD_CreateCustomerIntegrator.Item> partnersItems= new List<RC_SD_CreateCustomerIntegrator.Item>();
                RC_SD_CreateCustomerIntegrator.Item item= new RC_SD_CreateCustomerIntegrator.Item();
                item.PARVW='S';
                item.KUNNR='29004334';
                item.PARZA='000';
                partnersItems.Add(item);
                partners.Items=partnersItems;
        		salesdata.PARTNERS=partners;
            	salesdataList.Add(salesdata);
                req.IS_SALES_DATA=salesdataList;
        		string IV_REF_CUSTOMER_NO='20300066';
                req.IV_REF_CUSTOMER_NO=IV_REF_CUSTOMER_NO;
        
    		    req.IS_GENERAL_DATA=generaldata;
       			 req.IV_BAYI='';
      				  req.IV_BP='';
   
        Test.setMock(HttpCalloutMock.class, new RC_SD_CreateCustomerIntegratorMock());
        
        Test.startTest();
        
        resp= RC_SD_CreateCustomerIntegrator.CreateSAPCustomer(req);
       

        Test.stopTest();
     
    }

}