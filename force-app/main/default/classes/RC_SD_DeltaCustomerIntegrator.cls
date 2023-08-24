public with sharing class RC_SD_DeltaCustomerIntegrator {

    public static ResponseModel getDeltaCustomer(RequestModel reqModel){
        try {
            ResponseModel respModel = new ResponseModel();

            HttpRequest request = new HttpRequest();
            request.setBody(json.serialize(reqModel));
            request.setEndpoint('callout:PoqaZorluAPI' + '/RESTAdapter/salesforce/sd_delta_customer');
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;');
            request.setTimeout(120000);

            HttpResponse response = new Http().send(request);
            
            if(response.getStatus() == 'OK'){
                if(String.isNotBlank(response.getBody()) && response.getBody() != '""'){                    
                    respModel = (ResponseModel) System.JSON.deserialize(response.getBody(), ResponseModel.class);          
                }
            }            
            
            return respModel;
        } catch (Exception e){
            RC_Logger.LOG_EXCEPTION('RC_SD_DeltaCustomerIntegrator Error', e.getMessage(), e.getStackTraceString(), 'RC_SD_DeltaCustomerIntegrator', 'finish', '');

            return null;
        }
    }

    public class RequestModel{
        public String IV_YARAT_TRH {get; set;}
        public String IV_DEGIS_TRH {get; set;}

        public RequestModel(String iyt, String idt){
            this.IV_YARAT_TRH = iyt;
            this.IV_DEGIS_TRH = idt;
        }
    }

    public class ResponseModel{
        public HeaderModel ET_DEGISEN {get; set;}
        public HeaderModel ET_YARATILAN {get; set;}
    }

    public class HeaderModel{
        public List<DetailModel> item {get; set;}
    }

    public class DetailModel{
        public String KUNNR {get; set;}
        public String NAME1 {get; set;}
        public String NAME2 {get; set;}
        public String SORTL {get; set;}
        public String STREET {get; set;}
        public String HOUSE_NUM1 {get; set;}
        public String CITY2 {get; set;}
        public String POST_CODE1 {get; set;}
        public String CITY1 {get; set;}
        public String REGION {get; set;}
        public String COUNTRY {get; set;}
        public String LZONE {get; set;}
        public String VTEXT {get; set;}
        public String SMTP_ADDR {get; set;}
        public String TEL_NUMBER {get; set;}
        public String TAXNUM_NO {get; set;}
        public String TAXNUM_DR {get; set;}
        public PARVWHeader PARVW_TT {get; set;} 
        public SaleHeader SATIS_ANAVERILERI {get; set;}
        public ZMMNOPTCTHeader ZMM_NOPT_CT0002 {get; set;}
        public String XBLCK {get; set;}
        public String LOCCO {get; set;}
        public Decimal ZZLATITUDE {get; set;}
        public Decimal ZLONGITUDE {get; set;}
        public String SPERR {get; set;}
        public String BU_GROUP {get; set;}
        public String CITY_CODE {get; set;}
        public String CITYP_CODE {get; set;}
    }

    public class ZMMNOPTCTHeader{
        public List<ZMMNOPTCTDetail> item {get; set;}
    }

    public class ZMMNOPTCTDetail{
        public String MUSTERI_ADI {get; set;}  
        public String DEPO_TIPI {get; set;}     
        public String URETIM_YERI {get; set;} 
        public String VKORG {get; set;}
        public String VTWEG {get; set;}
        public Integer SPART {get; set;}
    }

    public class SaleHeader{
        public List<SaleDetail> item {get; set;}
    }

    public class SaleDetail{
        public String KUNNR {get; set;}
        public String VKORG {get; set;}
        public String VTWEG {get; set;}
        public String SPART {get; set;}
        public String VKBUR {get; set;}
        public String VKGRP {get; set;}
        public String BZIRK {get; set;}
        public String WAERS {get; set;}
        public String BEZEI_SB {get; set;}
        public String BEZEI_SG {get; set;}
        public String BZTXT {get; set;}
        public String KONDA {get; set;}
        public String AUFSD {get; set;}
        public String LIFSD {get; set;}
        public String FAKSD {get; set;}
    }

    public class PARVWHeader{
        public List<PARVWDetail> item {get; set;}
    }

    public class PARVWDetail{
        public String KUNNR {get; set;}
        public String VKORG {get; set;}
        public String VTWEG {get; set;}
        public String PARVW {get; set;}
        public String KUNN2 {get; set;}
        public String SPART {get; set;}
    }

}