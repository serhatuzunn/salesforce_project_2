public class RC_CreateCustomerComponentController {
   public class createCustomerWrapper{
        @AuraEnabled
        public string AccountName {get;set;}
        @AuraEnabled
        public string ReferanceName {get;set;}
        @AuraEnabled
        public string Message {get;set;}
    }
    
     @AuraEnabled
    public static createCustomerWrapper initialize(string recordId){
        createCustomerWrapper initWrp = new createCustomerWrapper();
        
        Account act=[Select id,Name,RC_Reference_Account__r.Name from Account where id =:recordId];
        initWrp.ReferanceName=act.RC_Reference_Account__r.Name;
        initWrp.AccountName=act.Name;
        initWrp.Message='';
        if(act.RC_Reference_Account__r.Name=='')
        {
            //initWrp.Message='Referans Hesap Seçilmeli';
        }

        return initWrp;
    }
    
     @AuraEnabled
    public static createCustomerWrapper sendcustomer(string recordId)
    {
         createCustomerWrapper initWrp = new createCustomerWrapper();
         //Create Customer 
         RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper requestWrapper=new  RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper();
               
        requestWrapper=CreateRequestWrapper(requestWrapper,recordId);
        system.debug('request:' + requestWrapper);
       
        RC_SD_CreateCustomerIntegrator.CreateSAPCustomerResponse responseWrapper= new RC_SD_CreateCustomerIntegrator.CreateSAPCustomerResponse();
       	responseWrapper= RC_SD_CreateCustomerIntegrator.CreateSAPCustomer(requestWrapper);
        system.debug('return:' + responseWrapper);
        string screenMessage='';
        
        if((responseWrapper!=null))
        {
       	if(responseWrapper.SAPCustomerID!='')
        {
            screenMessage=responseWrapper.SAPCustomerID +' Numarası ile SAP Kaydı Açılmıştır.';
            if(responseWrapper.IntegrationStatus=='1')
            {
                screenMessage= screenMessage + ' Genişletme Yapılamamıştır.' + responseWrapper.Messages;
            }
            else{
                 screenMessage= screenMessage + ' Genişletme Yapılmıştır.';
            }
            initWrp.Message=screenMessage;
        }
        else{
            initWrp.Message=responseWrapper.Messages;}
   	  
        if(responseWrapper.SAPCustomerID!='')
        {
             Account act=[Select Id,RC_SAP_ID__c FROM Account where Id=:recordId];
           	 act.RC_SAP_ID__c=responseWrapper.SAPCustomerID;
             act.Integration_Status__c=responseWrapper.IntegrationStatus;
             update act;
        } 
        
        }
        return initWrp;
    }
    
 /*  public static RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper TestFunction(RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper requestWrapper)
    {
          
                requestWrapper.IS_GENERAL_DATA.PARTNERGROUP='';
                requestWrapper.IS_GENERAL_DATA.CUSTOMER_NAME_1='TESTBAYİ444';
                requestWrapper.IS_GENERAL_DATA.CUSTOMER_NAME_2='TT';
                requestWrapper.IS_GENERAL_DATA.CUSTOMER_NAME_3='';
                requestWrapper.IS_GENERAL_DATA.CUSTOMER_NAME_4='';
                requestWrapper.IS_GENERAL_DATA.SEARCH_KEY='TESTBAYİ444';
                requestWrapper.IS_GENERAL_DATA.STREET='RAGIP TÜZÜN CAD. NO:168/ B .';
                requestWrapper.IS_GENERAL_DATA.DISTRICT='RAGIP TÜZÜN MAH.';
                requestWrapper.IS_GENERAL_DATA.CITY='ETIMESGUT';
                requestWrapper.IS_GENERAL_DATA.CITY_CODE='006';
                requestWrapper.IS_GENERAL_DATA.POST_CODE='06231';
                requestWrapper.IS_GENERAL_DATA.PHONE='3123446857';
                requestWrapper.IS_GENERAL_DATA.FAX='3123446857';
                requestWrapper.IS_GENERAL_DATA.EMAIL='TEST@VESTELBAYI.COM';
                requestWrapper.IS_GENERAL_DATA.TAX_AREA='YENİMAHALLE';
                requestWrapper.IS_GENERAL_DATA.TAX_NUMBER='98708822222';
                requestWrapper.IS_GENERAL_DATA.TRANSPZONE='';
                requestWrapper.IS_GENERAL_DATA.LANGU='TR';
                requestWrapper.IS_GENERAL_DATA.LOCCO='';
                requestWrapper.IS_GENERAL_DATA.CONTROL_ACCOUNT='';
                requestWrapper.IS_GENERAL_DATA.ZWELS='';
                requestWrapper.IS_GENERAL_DATA.XZVER='';
                            
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
                requestWrapper.IS_SALES_DATA=salesdataList;
                requestWrapper.IV_REF_CUSTOMER_NO='20300066';
                return requestWrapper;
    }*/
    
   public static RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper CreateRequestWrapper(RC_SD_CreateCustomerIntegrator.CreateSAPCustomerWrapper requestWrapper,string accountId)
   {
         Account act=[Select id,Name,RC_Reference_Account__r.RC_SAP_ID__c,RC_Street__c,RC_SORTL__c,RC_District__r.Name,RC_Region__r.Name,
                      RC_Postal_Code__c,RC_City__r.RC_Code__c,Phone,Fax,RC_Email__c,RC_Tax_Office__c,RC_Tax_Number__c,RC_Transport_Zone__r.RC_Code__c,
                      RC_Location_Code__c,RC_Sub_Type__c,Integration_Status__c,RC_SAP_ID__c
                      from Account where id =:accountId];
     	 RC_SD_CreateCustomerIntegrator.IS_GENERAL_DATA generaldata= new RC_SD_CreateCustomerIntegrator.IS_GENERAL_DATA();
         List<RC_SD_CreateCustomerIntegrator.IS_SALES_DATA> salesdataList= new  List<RC_SD_CreateCustomerIntegrator.IS_SALES_DATA>();
         string referanceCustomer=act.RC_Reference_Account__r.RC_SAP_ID__c;
         string AccountName1='';
       	 string AccountName2='';
       
        integer lengthFirmName = act.Name.length();
       system.debug('length:' + lengthFirmName);
       if(lengthFirmName>40)
       {
           AccountName1=act.Name.substring(0,39);
           
       }else{
             
           AccountName1=act.Name.substring(0,lengthFirmName);
            system.debug('AccountName1:' +AccountName1);
       }
       if(lengthFirmName>40){
         if (lengthFirmName > 80)
         {
             AccountName2=act.Name.substring(40,80);
         }
           else{
             AccountName2=act.Name.substring(40,lengthFirmName);
           }
       }else{AccountName2='';}
       
        		generaldata.PARTNERGROUP='';
       
                generaldata.CUSTOMER_NAME_1=AccountName1;
                generaldata.CUSTOMER_NAME_2=AccountName2;
                generaldata.CUSTOMER_NAME_3='';
                generaldata.CUSTOMER_NAME_4='';
                generaldata.SEARCH_KEY=AccountName1.substring(0,10); //RC_SORTL__c ???
                generaldata.STREET=act.RC_Street__c;
                generaldata.DISTRICT=act.RC_District__r.Name;
                generaldata.CITY=act.RC_Region__r.Name;
       
                generaldata.CITY_CODE=act.RC_City__r.RC_Code__c;
                generaldata.POST_CODE=act.RC_Postal_Code__c;
                generaldata.PHONE=act.Phone;
                generaldata.FAX=act.Fax;
                generaldata.EMAIL=act.RC_Email__c;
                generaldata.TAX_AREA=act.RC_Tax_Office__c;
                generaldata.TAX_NUMBER=act.RC_Tax_Number__c;
               // generaldata.TRANSPZONE=act.RC_Transport_Zone__r.RC_Code__c;
                generaldata.LANGU='TR';
                generaldata.LOCCO=act.RC_Location_Code__c;
                generaldata.CONTROL_ACCOUNT=act.RC_Sub_Type__c;
                generaldata.ZWELS='';
                generaldata.XZVER='';
      	
        		 RC_SD_CreateCustomerIntegrator.IS_SALES_DATA salesdata= new  RC_SD_CreateCustomerIntegrator.IS_SALES_DATA();

		         for(RC_SD_Organization__c sdorg: [SELECT Id,RC_Sales_Organization__c,Distribution_Channel__c,Sales_Directorate__c,RC_Regional_Directorate__c,RC_BZIRK__c,CurrencyIsoCode,RC_Price_Group__c,RC_Sales_Expert__r.EmployeeNumber FROM RC_SD_Organization__c 
									 where RC_Account__c=:accountId and RC_Active__c=true and RC_Sales_Organization__c='2201'])
                { 
                 salesdata.VKORG=sdorg.RC_Sales_Organization__c;
                 salesdata.VTWEG=sdorg.Distribution_Channel__c;
                 salesdata.SPART='21';
                 salesdata.VKBUR=sdorg.RC_Regional_Directorate__c;
                 salesdata.VKGRP=sdorg.Sales_Directorate__c;
                 salesdata.KONDA=sdorg.RC_Price_Group__c;
                 salesdata.KALKS='';
                 salesdata.KDGRP='';
                 salesdata.BZIRK='';
                 salesdata.WAERS=sdorg.CurrencyIsoCode;
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
                item.PARVW='SS';
                item.KUNNR=sdorg.RC_Sales_Expert__r.EmployeeNumber;
                item.PARZA='000';
                partnersItems.Add(item);
                partners.Items=partnersItems;
        		salesdata.PARTNERS=partners;

                salesdataList.Add(salesdata);
                
                }
       
        requestWrapper.IS_GENERAL_DATA=generaldata;
        requestWrapper.IS_SALES_DATA=salesdataList;
        requestWrapper.IV_REF_CUSTOMER_NO=referanceCustomer;
        requestWrapper.IV_BAYI='X';
       system.debug('Status:' + act.Integration_Status__c);
       system.debug('SAPID:' + act.RC_SAP_ID__c);
        if(act.Integration_Status__c=='1')
         {
             
            requestWrapper.IV_BP=act.RC_SAP_ID__c;   
         }
       	return requestWrapper;
       
   }
     
}