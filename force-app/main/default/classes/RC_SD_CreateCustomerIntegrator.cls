public class RC_SD_CreateCustomerIntegrator {
    
	public class Item {
		public String PARVW {get;set;}
		public String KUNNR{get;set;}
		public String PARZA{get;set;}
	}

	public class IS_GENERAL_DATA {
		public String PARTNERGROUP{get;set;}
		public String CUSTOMER_NAME_1{get;set;}
		public String CUSTOMER_NAME_2{get;set;}
		public String CUSTOMER_NAME_3{get;set;}
		public String CUSTOMER_NAME_4{get;set;}
		public String SEARCH_KEY{get;set;}
		public String STREET{get;set;}
		public String DISTRICT{get;set;}
		public String CITY{get;set;}
		public String CITY_CODE{get;set;}
		public String POST_CODE{get;set;}
		public String PHONE{get;set;}
		public String FAX{get;set;}
		public String EMAIL{get;set;}
		public String TAX_AREA{get;set;}
		public String TAX_NUMBER{get;set;}
		public String TRANSPZONE{get;set;}
		public String LANGU{get;set;}
		public String LOCCO{get;set;}
		public String CONTROL_ACCOUNT{get;set;}
		public String ZWELS{get;set;}
		public String XZVER{get;set;}
        public String ZZLONGITUDE{get;set;}
		public String ZZLATITUDE{get;set;}
        
	}

    public class IS_SALES_DATA {
		public String VKORG{get;set;}
		public String VTWEG{get;set;}
		public String SPART{get;set;}
		public String VKBUR{get;set;}
		public String VKGRP{get;set;}
		public String KONDA{get;set;}
		public String KALKS{get;set;}
		public String KDGRP{get;set;}
		public String BZIRK{get;set;}
		public String WAERS{get;set;}
		public String PLTYP{get;set;}
		public String VERSG{get;set;}
		public String LPRIO{get;set;}
		public String VWERK{get;set;}
		public String VSBED{get;set;}
		public String KTGRD{get;set;}
		public String TAXKD{get;set;}
		public PARTNERS PARTNERS{get;set;}
	}

	public class PARTNERS {
		public List<Item> items{get;set;}
	}
    
    public String IV_REF_CUSTOMER_NO {get;set;}
     public String IV_BAYI {get;set;}
     public String IV_BP {get;set;}
    
    public class CreateSAPCustomerWrapper{
    public IS_GENERAL_DATA IS_GENERAL_DATA {get;set;}
	public List<IS_SALES_DATA> IS_SALES_DATA {get;set;}
	public String IV_REF_CUSTOMER_NO {get;set;}
     public String IV_BAYI {get;set;}
     public String IV_BP {get;set;}
    }
    public class CreateSAPCustomerResponse{
        public  RC_SD_CreateCustomerParser response{get;set;}
    	  public String Messages{get;set;}
        public String SAPCustomerID{get;set;}
        public String IntegrationStatus{get;set;}
    }
    
    public static CreateSAPCustomerResponse CreateSAPCustomer(CreateSAPCustomerWrapper req)
    {
         try {
            CreateSAPCustomerResponse resp = new CreateSAPCustomerResponse();
           
            String url = 'RESTAdapter/salesforce/sd_create_customer';
            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(req));
            request.setEndpoint('callout:PoqaZorluAPI' + '/' + url);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);
            Http http = new Http();
            system.debug('Service RequestBody:' + json.serialize(req));
            HttpResponse response = http.send(request);
             system.debug('response' + response.getBody());
            RC_Logger.LOG_EXCEPTION('RC_SD_CreateCustomerIntegrator  Error','' , json.serialize(req), 'RC_SD_CreateCustomerIntegrator', 'finish', '');
                if(response.getStatus() == 'OK'){
                    RC_SD_CreateCustomerParser parseResult = RC_SD_CreateCustomerParser.parse(response.getBody());
                    resp.response=parseResult;
                     string IntegrationStatus='0';
                    if(parseResult.ET_MESSAGES!=null)
                    if(parseResult.ET_MESSAGES.item.size()>0)
                    {
                        resp.response=parseResult;
                        boolean genisletme=false;
                        boolean warning=false;
                        string returnMessage='';
                      
                        for (RC_SD_CreateCustomerParser.Item retItem : parseResult.ET_MESSAGES.item) {
   							 if(retItem.MESSAGE=='Genişletme başarılı')
                             {
                                 genisletme=true;
                             }
                             if(retItem.TYPE=='E')
                               {
                                   warning=true;
                                   returnMessage=retItem.MESSAGE;
                               }
							}
                        resp.Messages= returnMessage;
                        if(parseResult.EV_CUSTOMER_NO!='')
                        {
                            IntegrationStatus='1';
                        }
                        if(genisletme){IntegrationStatus='2';}
                      
                    }
                      resp.SAPCustomerID=parseResult.EV_CUSTOMER_NO;
                     resp.IntegrationStatus=IntegrationStatus;
                    
                }
             else{
				system.debug('Service Response:' + response);
                system.debug('Service Response Body:' + response.getBody());
             }
            return resp;
        }
        catch(Exception e){
            RC_Logger.LOG_EXCEPTION('RC_SD_CreateCustomerIntegrator  Error', 'Integrator Error', e.getMessage(), 'RC_SD_CreateCustomerIntegrator', 'CreateSAPCustomer', '');
           
            return null;
        }
           
    }
}