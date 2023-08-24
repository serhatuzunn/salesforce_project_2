public class RC_GetVestelCellController {

 
    public class VestelCellResponseModel{
   	        @AuraEnabled
        public RC_GetVestelCellParser.ES_CEK_S ES_CEK_S { get; set; } 
        
              @AuraEnabled
        public string DURUM { get; set; }
        
             @AuraEnabled
        public string USEDURUM { get; set; }
      }
    
    public class UseVestelCellCreateResponseModel{
        @AuraEnabled
        public RC_GetGiftVoucherUseParser.ET_RETURN ET_RETURN { get; set; } 
    }
    
    
    public class VestelCellUseResponseModel{
                @AuraEnabled
        public string EV_MESSAGE { get; set; } 
        
        @AuraEnabled
        public string EV_SUCCESS { get; set; }
        @AuraEnabled
        public string DURUM { get; set; }
    }

    @AuraEnabled
    public static VestelCellResponseModel handLeClick_v2(string CHECK_NO)
    {  
         VestelCellResponseModel ccResponseModel = new VestelCellResponseModel();
        
 		 system.debug('CHECK_NO_v2 : ' + CHECK_NO);
		   
         RC_GetVestelCellIntegrator.RequestModelStatu req = new RC_GetVestelCellIntegrator.RequestModelStatu();
        
        		 if(String.isNotBlank(CHECK_NO))
                   	req.IV_CEKNO = CHECK_NO;
                else
                    req.IV_CEKNO = '';
        
        Rc_Vcell_and_Gift_Card__c[] checkData = [Select Id,Name,Rc_Cheque_No__c,Rc_Dealer__c  From Rc_Vcell_and_Gift_Card__c Where Rc_Cheque_No__c=:CHECK_NO AND Rc_Type__c='V'];
		   system.debug('checkData :' + checkData );
        
         RC_GetVestelCellParser resultIntegrator = RC_GetVestelCellIntegrator.getsendVestelCellStatu(req);
         if(resultIntegrator != null)
         {                               
               
             if(resultIntegrator.ES_CEK_S.KEY_STATUS == '')
             {
                 ccResponseModel.DURUM = 'İndirim Kodu Oluşturulmuş. Yazdırılmayı Bekliyor. Kullanılabilir';
                 ccResponseModel.USEDURUM = '2';
             }
             else if(resultIntegrator.ES_CEK_S.KEY_STATUS =='1')
             {
                 ccResponseModel.DURUM = 'İndirim Kodu SMS Gönderildi. Kullanılabilir.'; 
                 ccResponseModel.USEDURUM = '2';
             }
             else if(resultIntegrator.ES_CEK_S.KEY_STATUS =='2' && checkData.size() == 0)
             {
                 ccResponseModel.DURUM = 'İndirim Kodu Bayide Kullanılmış.';
                 ccResponseModel.USEDURUM = '2';
             }
             else if(resultIntegrator.ES_CEK_S.KEY_STATUS =='2' && checkData.size() > 0)
                 ccResponseModel.DURUM = 'İndirim Kodu Kullanılmış Onay Bekleniyor.';
             
             else if(resultIntegrator.ES_CEK_S.KEY_STATUS =='3')
                 ccResponseModel.DURUM = 'Bayi alacaklandırıldı.';  
             
               ccResponseModel.ES_CEK_S = resultIntegrator.ES_CEK_S;
         }
         
       
         return ccResponseModel;
    }
    
     @AuraEnabled
     public static VestelCellUseResponseModel VCellUseObjeClick(string IT_CHECK_NO_ENTRY)
    {
        
        RC_GetVestelCellIntegrator.RequestModel req = new RC_GetVestelCellIntegrator.RequestModel();
      
        VestelCellUseResponseModel ccResponseModel = new VestelCellUseResponseModel();  
        		 
        string usr = UserInfo.getUserId();
        string accountId = [SELECT Id,AccountId FROM User Where Id=:usr LIMIT 1].AccountId;
        
        Rc_Vcell_and_Gift_Card__c giftCell = new Rc_Vcell_and_Gift_Card__c();
        giftCell.Rc_Type__c = 'V';
        giftCell.Rc_Cheque_No__c = IT_CHECK_NO_ENTRY;
        giftCell.Name = 'VESTELCELL - '+IT_CHECK_NO_ENTRY;
        giftCell.Rc_Dealer__c = accountId;
        insert giftCell;       
            
         
        ccResponseModel.DURUM = 'İndirim Kodu Bayi için kullanıldı.';
        return ccResponseModel;
        
    }
    @AuraEnabled
     public static VestelCellUseResponseModel VCellUseSetObjeClick(string recordId,date IT_DOCUMENT_DATE, string IT_MATBU_NO)
    {
         VestelCellUseResponseModel ccResponseModel = new VestelCellUseResponseModel();   
		UseVestelCellCreateResponseModel createResponse = new UseVestelCellCreateResponseModel(); 
        system.debug('recordId : ' + recordId);
        system.debug('IT_DOCUMENT_DATE : ' + IT_DOCUMENT_DATE);
        system.debug('IT_MATBU_NO : ' + IT_MATBU_NO);
         
        
        Rc_Vcell_and_Gift_Card__c[] checkData = [Select Id,Name,Rc_Cheque_No__c,Rc_Dealer__c,Rc_Type__c  From Rc_Vcell_and_Gift_Card__c Where Id=:recordId LIMIT 1];
       
        if (checkData.size() > 0)
        {
           
            if(checkData[0].Rc_Type__c == 'V')
            {
                     //Statu Güncelleme
                    RC_GetVestelCellIntegrator.RequestModel req = new RC_GetVestelCellIntegrator.RequestModel();
                    req.IV_DURUM = '3';   	
                    req.IV_CEKNO =  checkData[0].Rc_Cheque_No__c;
                   
                    RC_GetVestelCellParser resultIntegrator = RC_GetVestelCellIntegrator.getsendVestelCellStatuControl(req);   
            
                    if(resultIntegrator != null)
                     {                               
                           ccResponseModel.EV_MESSAGE = resultIntegrator.EV_MESSAGE;
                           ccResponseModel.EV_SUCCESS = resultIntegrator.EV_SUCCESS;
                           ccResponseModel.DURUM = resultIntegrator.EV_MESSAGE;
                     }
                    
                    Account[] acc = [SELECT RC_SAP_ID__c FROM Account WHERE id =: checkData[0].Rc_Dealer__c LIMIT 1];
                    if(acc.size() > 0)
                    {
                        //Sipariş Oluşturma
                        string DocumentDate = string.valueOf(IT_DOCUMENT_DATE);
                        createResponse = VestelCellCreateParametric(checkData[0].Rc_Cheque_No__c,acc[0].RC_SAP_ID__c,DocumentDate,IT_MATBU_NO);
                        
                        if(createResponse != null)
                        {
                            system.debug('gift create parac + '+createResponse);
                           ccResponseModel.DURUM = 'Vestel Cell Çeki Kullanıldı';
                        }
                    }
                
                    
                    
                    //Obje Güncelleme
                    Rc_Vcell_and_Gift_Card__c a = new Rc_Vcell_and_Gift_Card__c(id=recordId);
                    a.Rc_Matbu_No__c         = IT_MATBU_NO;
                    a.Rc_Invoice_Date__c     = IT_DOCUMENT_DATE;
                    a.Rc_SD_Approval_Date__c = Date.today();
                   
                    update a;
            }
            else
            {
                 RC_GetGiftVoucherCheckController.UseGiftResponseModel giftResponse = RC_GetGiftVoucherCheckController.VGiftUseSetObjeClick(recordId,IT_DOCUMENT_DATE,IT_MATBU_NO);
                  ccResponseModel.DURUM  = giftResponse.DURUM;
            }
        }	   

        return ccResponseModel;        
    }
    					 
   
    
    @AuraEnabled
    public static UseVestelCellCreateResponseModel VestelCellCreateParametric(string IT_CHECK_NO_ENTRY,string IT_BAYI_NO,string IT_DOCUMENT_DATE,string IT_MATBU_NO)
    {  
		    system.debug('CHECK_NO : ' + IT_CHECK_NO_ENTRY);
            system.debug('IT_BAYI_NO : ' + IT_BAYI_NO);
            system.debug('IT_DOCUMENT_DATE : ' + IT_DOCUMENT_DATE);
            system.debug('IT_MATBU_NO : ' + IT_MATBU_NO);
        
       		  UseVestelCellCreateResponseModel useCheckResponseModel = new UseVestelCellCreateResponseModel();
        
        		RC_GetGiftVoucherUseIntegrator.requestModel req = new RC_GetGiftVoucherUseIntegrator.requestModel();
           	    RC_GetGiftVoucherUseIntegrator.LS_HEADER lsheader = new RC_GetGiftVoucherUseIntegrator.LS_HEADER();
        		
     	   	    string bayiTipi = '1';
                lsheader.DOC_TYPE = 'ZHDC';
                lsheader.DISTR_CHAN =  bayiTipi == '3' ? '23' : bayiTipi == '4' ? '06' : '01'; //bayitipi: 2 vestel, 3 regal, 4 çeyiz
                lsheader.DIVISION = '21';
        		
               if(String.isNotBlank(IT_CHECK_NO_ENTRY))
                     lsheader.PURCH_NO_C = IT_CHECK_NO_ENTRY;
                else
                    lsheader.PURCH_NO_C = '';
        
        		 if(String.isNotBlank(IT_DOCUMENT_DATE))
                 {
                    lsheader.DOC_DATE = IT_DOCUMENT_DATE;
                	lsheader.BILL_DATE = IT_DOCUMENT_DATE;
				  	lsheader.REQ_DATE_H = IT_DOCUMENT_DATE;
                    req.P_VADE = IT_DOCUMENT_DATE;
                 }
                else
                {
                    lsheader.DOC_DATE = '';
                	lsheader.BILL_DATE = '';
				    lsheader.REQ_DATE_H = '';
                    req.P_VADE = '';
                }
         
                lsheader.SALES_ORG = bayiTipi == '3' ? '2211' : '2201';//bayitipi : 2 vestel, 3 regal, 4 çeyiz
                lsheader.PMNTTRMS = 'VPNK';
        
                RC_GetGiftVoucherUseIntegrator.LS_HEADERSX lsheaderx = new RC_GetGiftVoucherUseIntegrator.LS_HEADERSX();
                lsheaderx.DOC_TYPE = 'X';
                lsheaderx.DISTR_CHAN = 'X';
                lsheaderx.DIVISION = 'X';
                lsheaderx.DOC_DATE = 'X';
                lsheaderx.BILL_DATE = 'X';
                lsheaderx.PURCH_NO_C = 'X';
                lsheaderx.REQ_DATE_H = 'X';
                lsheaderx.SALES_ORG = 'X';
                lsheaderx.UPDATEFLAG = 'X';
                lsheaderx.PMNTTRMS = 'X';
        
        		RC_GetGiftVoucherUseIntegrator.LT_ITEMS i = new RC_GetGiftVoucherUseIntegrator.LT_ITEMS();
        	    i.item = new List<RC_GetGiftVoucherUseIntegrator.item>();
        		RC_GetGiftVoucherUseIntegrator.item item_2 = new RC_GetGiftVoucherUseIntegrator.item();
        
        		RC_GetGiftVoucherUseIntegrator.LT_ITEMSX ix = new RC_GetGiftVoucherUseIntegrator.LT_ITEMSX();
        	    ix.item = new List<RC_GetGiftVoucherUseIntegrator.item>();
       		     RC_GetGiftVoucherUseIntegrator.item item_3 = new RC_GetGiftVoucherUseIntegrator.item();
        
                item_2.MATERIAL = '1030';
                item_3.MATERIAL = 'X';
                item_2.ITM_NUMBER = '000010';
                item_3.ITM_NUMBER = '000010';
                item_2.PLANT = '2204';
                item_3.PLANT = 'X';
                item_2.TARGET_QTY = '1';
                item_2.TARGET_QTYSpecified = true;
                item_3.TARGET_QTY = 'X';
                item_3.UPDATEFLAG = 'X';
        
       			i.item.add(item_2);  
				ix.item.add(item_3);
                    
 
        		RC_GetGiftVoucherUseIntegrator.LT_CONDS c = new RC_GetGiftVoucherUseIntegrator.LT_CONDS();
        		 c.item = new List<RC_GetGiftVoucherUseIntegrator.item_W>();
       		     RC_GetGiftVoucherUseIntegrator.item_W item_4 = new RC_GetGiftVoucherUseIntegrator.item_W();
        		string tutar = '0';
                item_4.ITM_NUMBER = '00010';
                item_4.COND_TYPE = 'PR00';
                item_4.CURRENCYx = 'TRY';
                item_4.COND_VALUE = tutar;
                item_4.COND_VALUESpecified = true;
        		
        		c.item.add(item_4);
        
        		 RC_GetGiftVoucherUseIntegrator.LT_PARTNERS partners = new RC_GetGiftVoucherUseIntegrator.LT_PARTNERS();
        		 partners.item = new List<RC_GetGiftVoucherUseIntegrator.Item_X>();
       		     RC_GetGiftVoucherUseIntegrator.Item_X item_5 = new RC_GetGiftVoucherUseIntegrator.Item_X();
        
        		partners.item.add(item_5);

        	
       			
        		if(lsheader != null)
        			req.LS_HEADER = lsheader;
        		if(lsheaderx != null)
        			req.LS_HEADERSX = lsheaderx;
        		if(i.item.size()>0)
                	req.LT_ITEMS = i;
        		if(ix.item.size()>0)
                	req.LT_ITEMSX = ix;
      		   if(c.item.size()>0)
                	req.LT_CONDS = c;
       		   if(partners.item.size()>0)
                	req.LT_PARTNERS = partners;
        
        		if(String.isNotBlank(IT_BAYI_NO))
       				 req.P_KUNNR = IT_BAYI_NO;
                else
                   req.P_KUNNR = '';
        
        		if(String.isNotBlank(IT_MATBU_NO))
                    req.P_MATBUNO = IT_MATBU_NO;
                else
                   req.P_MATBUNO = '';
        		
       
        		RC_GetGiftVoucherUseParser resultIntegrator = RC_GetGiftVoucherUseIntegrator.getSendGiftUseVoucher(req);
      		
        		if(resultIntegrator != null)
                {
      			    useCheckResponseModel.ET_RETURN =  resultIntegrator.ET_RETURN;
                }
       	
         return useCheckResponseModel;
        
     }  
}