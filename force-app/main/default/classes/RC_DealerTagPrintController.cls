public class RC_DealerTagPrintController {    
    //Constructor with no arguments
    public RC_DealerTagPrintController(){        
    }
    
    @AuraEnabled
    public static List<RC_Definition__c> definitionList {get;set;}
        
    public class initWrapper{
        @AuraEnabled
        public List<SelectOptionWrapper> productGroupes {get;set;}
        @AuraEnabled
        public Integer maxRowSelectionCount {get;set;}
    }
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value {get;set;}
    }
    @AuraEnabled
    public static initWrapper productGroupeRecords(string tagTypeValue, string tagTypeLabel){
        integer maxRowSelectionCount = 3;
        initWrapper initWrp = new initWrapper();        
        List<SelectOptionWrapper> productGroupes = new List<SelectOptionWrapper>();        
        List<RC_Definition__c> r = new List<RC_Definition__c> ();
        
        System.debug('tagTypeValue : '+tagTypeValue);
        System.debug('tagTypeLabel : '+tagTypeLabel);
        if(string.isNotEmpty(tagTypeValue) && string.isNotBlank(tagTypeValue)){
            String[] arrTagType = tagTypeValue.split('-');
            if(arrTagType.size()>0){
                r = [select Id, Name from RC_Definition__c  Where RC_Value__c IN :arrTagType];
                System.debug('sql : '+r);                
                if(r.size()>0){
                    SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
                    EmptyValue.label = 'Seçiniz';
                    EmptyValue.value = '0';
                    productGroupes.add(EmptyValue);
                    
                    for(RC_Definition__c pGroupe : r){
                        
                        SelectOptionWrapper tempValues = new SelectOptionWrapper();
                        
                        string[] result = pGroupe.Name.split('-');
                        
                        tempValues.value = result[0];
                        tempValues.label = result[1];
                        
                        productGroupes.add(tempValues);
                    }
                    definitionList =[SELECT Id, RC_Product_Group__c, RC_Label_Type__c, RC_Standart_Label_PDF__c, RC_Special_Price_Label_PDF__c, RC_Stamped_Label_PDF__c, RC_Installment_Label_PDF__c, RC_Count__c from RC_Definition__c  where RC_Label_Type__c = :tagTypeLabel AND RC_Standart_Label_PDF__c!= ''  ];
           			maxRowSelectionCount = definitionList[0].RC_Count__c.intValue();
                }
            }
        }
        
        initWrp.productGroupes = productGroupes;
        initWrp.maxRowSelectionCount = maxRowSelectionCount;
        
        return initWrp;        
    }
       
    @AuraEnabled
    public static list<RC_Label__c> fetchProductRecords(string tagType, string productGroupe, string productCodeName){
        string sqlClause = 'SELECT RC_Product__r.ProductCode  , RC_Product__r.Description  , RC_Header__c, RC_Description__c,RC_Manufacture_Place__c,RC_Price_Update_Date__c,  RC_Price__c,RC_Terminated_Amount__c, RC_Bill_Amount_1__c, RC_Bill_Amount_2__c, RC_Bill_Amount_3__c, RC_Installment_Amount_1__c,RC_Installment_Amount_2__c,RC_Installment_Amount_3__c, RC_LabelType__c FROM RC_Label__c ';
        
        System.debug('sql tagType : '+tagType);
        System.debug('sql productGroupe : '+productGroupe);
        System.debug('sql productCodeName : '+productCodeName);
        
        if(string.isNotEmpty(tagType) && string.isNotBlank(tagType)){            
            String[] arrTagType = tagType.split('-');
            String s = String.join(arrTagType, '\',\'');
            sqlClause = sqlClause + ' WHERE RC_Product__r.RC_Product_hie_Level_3__r.RC_Value__c IN (\'' +s+'\')';
        }
        
        if(string.isNotEmpty(productCodeName) && string.isNotBlank(productCodeName)){
            String[] productCodeNameList = productCodeName.split('\\,');
            String s = String.join(productCodeNameList, '\',\'');
            s = s.replaceAll( '\\s+', '');
            
            System.debug('s : '+JSON.serialize(s));
            /*String searchString = '\'%' + productCodeName + '%\'';
            sqlClause = sqlClause + ' AND (RC_Product__r.ProductCode LIKE '+searchString+' OR  RC_Product__r.Description LIKE '+searchString+')';*/
            sqlClause = sqlClause + ' AND (RC_Product__r.ProductCode IN (\''+s+'\'))';            
        }
        
        if(string.isNotEmpty(productGroupe) && string.isNotBlank(productGroupe) && productGroupe != '0'){
            sqlClause = sqlClause + ' AND RC_Product__r.RC_Product_hie_Level_3__r.RC_Value__c   IN (\'' + productGroupe+ '\') ';
        }
        
        System.debug('sql fetchProductRecords2 : '+sqlClause);
        list<RC_Label__c> obj = database.query(sqlClause);
        
        return obj;
    }
    
    @AuraEnabled    
    public static boolean updateLabels(String updatedLabelList) {
        try {
            List<RC_Label__c> updatelist = (List<RC_Label__c>) System.JSON.deserialize(updatedLabelList, List<RC_Label__c>.class);
            System.debug('updatedLabelList : '+updatelist);
            update updatelist;  
            return true;
        } catch(Exception e) {          
            System.debug('Exception updateLabels : '+e);
            return false;              
        }       
    }    
    
    @AuraEnabled
    public static string previewSelectedProduct(string tagType, string tagTypeLabel, string tagPriceType, string labelIds){        
        System.debug('tagType: '+ tagType );
        System.debug('tagTypeLabel: '+tagTypeLabel);    
        System.debug('labelIds: '+labelIds);
        
        String labelName = '';
        labelIds = labelIds.replace('[', '');
        labelIds = labelIds.replace(']', '');
        labelIds = labelIds.replace('\"', '\'');
        
        string sqlClause = 'SELECT RC_Product__r.ProductCode  , RC_Product__r.Description  , RC_Header__c, RC_Description__c,RC_Manufacture_Place__c,RC_Price_Update_Date__c,  RC_Price__c,RC_Terminated_Amount__c, RC_Bill_Amount_1__c, RC_Bill_Amount_2__c, RC_Bill_Amount_3__c, RC_Installment_Amount_1__c,RC_Installment_Amount_2__c,RC_Installment_Amount_3__c, RC_LabelType__c FROM RC_Label__c WHERE Id IN (' +labelIds+ ')' ;
        list<RC_Label__c> obj = database.query(sqlClause);
        System.debug('obj: '+obj+'OBJ Count: '+ obj.size());
                
        /*definitionList'ten daima 1 kayıt gelecek*/
        definitionList =[SELECT Id, RC_Product_Group__c, RC_Label_Type__c, RC_Standart_Label_PDF__c, RC_Special_Price_Label_PDF__c, RC_Stamped_Label_PDF__c, RC_Installment_Label_PDF__c, RC_Count__c from RC_Definition__c  where RC_Standart_Label_PDF__c!= '' and RC_Label_Type__c = :tagTypeLabel];
        System.debug('definitionList: '+ definitionList );        
        /*selected olan kayıtların ID'sinden ilgili bilgileri db'den tekrar cek*/        
        RC_ProductLabelIntegrator.requestModel r = new RC_ProductLabelIntegrator.requestModel();
        List<RC_ProductLabelIntegrator.LabelDetail> ldList = new List<RC_ProductLabelIntegrator.LabelDetail>();
        
        RC_ProductLabelIntegrator.LabelDetail ld = null;
        
        for (RC_Label__c lbl : obj) {            
            integer indexValue = obj.indexOf(lbl);
            System.debug('indexValue : '+ indexValue );
            System.debug('tagPriceType : '+ tagPriceType );
            
            /*for döngüsü ile IdList'e ekleme yapılacak*/
            ld = new RC_ProductLabelIntegrator.LabelDetail();
            ld.LabelName=indexValue>0 ? 'Title'+'_'+indexValue : 'Title' ;
            ld.LabelValue= lbl.RC_Header__c; /*'BZE-XL3303 XEH A+ NF';/*TODO: baslık Adi setlenecek*/            
            ldList.Add(ld);
            
            ld = new RC_ProductLabelIntegrator.LabelDetail();
            ld.LabelName=indexValue>0 ? 'Description'+'_'+indexValue : 'Description';
            ld.LabelValue= lbl.RC_Description__c;/*'A';/*TODO: aciklama alani setlenecek*/
            ldList.Add(ld);
            
            ld = new RC_ProductLabelIntegrator.LabelDetail();
            ld.LabelName=indexValue>0 ? 'factory'+'_'+indexValue : 'factory';
            ld.LabelValue= lbl.RC_Manufacture_Place__c;/*'Türkiye';/*TODO: UretimYeri setlenecek*/            
            ldList.Add(ld);
            
            ld = new RC_ProductLabelIntegrator.LabelDetail();
            ld.LabelName=indexValue>0 ?'amountchangeddate'+'_'+indexValue : 'amountchangeddate';
            ld.LabelValue=GetDateFormat(String.valueOf(lbl.RC_Price_Update_Date__c));/*'28.09.2018';/*TODO: degisiklik tarihi setlenecek*/
            ldList.Add(ld);
            
            ld = new RC_ProductLabelIntegrator.LabelDetail();
            ld.LabelName=indexValue>0 ?'Amount'+'_'+indexValue : 'Amount';
            ld.LabelValue= String.valueOf(lbl.RC_Price__c);/*'2299.00';/*TODO: price alani setlenecek*/
            ldList.Add(ld);
            
            
            switch on tagPriceType {
            when 'SpecialPrice' {
                ld = new RC_ProductLabelIntegrator.LabelDetail();
                ld.LabelName=indexValue>0 ?'Amount2'+'_'+indexValue : 'Amount2';
                ld.LabelValue=String.valueOf(lbl.RC_Terminated_Amount__c);/*'2999.00';/*TODO: sonlandırılan tutar*/
                ldList.Add(ld);
            }	
            when 'Stamped' {
                ld = new RC_ProductLabelIntegrator.LabelDetail();
                ld.LabelName=indexValue>0 ?'Amount1'+'_'+indexValue : 'Amount1';
                ld.LabelValue=String.valueOf(lbl.RC_Bill_Amount_1__c);/*'2999.00';*/
                ldList.Add(ld);
                
                ld = new RC_ProductLabelIntegrator.LabelDetail();
                ld.LabelName=indexValue>0 ?'Amount2'+'_'+indexValue : 'Amount2';
                ld.LabelValue=String.valueOf(lbl.RC_Bill_Amount_2__c);/*'3199.00'; */
                ldList.Add(ld);
            }
            when 'Installment' {
                ld = new RC_ProductLabelIntegrator.LabelDetail();
                ld.LabelName=indexValue>0 ?'Installment1'+'_'+indexValue : 'Installment1';
                ld.LabelValue=String.valueOf(lbl.RC_Installment_Amount_1__c);/*'1999.00'; */
                ldList.Add(ld);
                
                ld = new RC_ProductLabelIntegrator.LabelDetail();
                ld.LabelName=indexValue>0 ?'Installment2'+'_'+indexValue : 'Installment2';
                ld.LabelValue=String.valueOf(lbl.RC_Installment_Amount_2__c);/*'2999.00'; */
                ldList.Add(ld);                
                
                ld = new RC_ProductLabelIntegrator.LabelDetail();
                ld.LabelName=indexValue>0 ?'Installment3'+'_'+indexValue : 'Installment3';
                ld.LabelValue=String.valueOf(lbl.RC_Installment_Amount_3__c);/*'3999.00'; */
                ldList.Add(ld);
            }
            when else {}
        } 
        } 
        /*
ld = new RC_ProductLabelIntegrator.LabelDetail();
ld.LabelName='amount1_1';
ld.LabelValue='2999.00';
ld.DisplayName='Senetli Tutar1';
ld.MaxLength=10;
ld.IsMultiLine=false;
ldList.Add(ld);

ld = new RC_ProductLabelIntegrator.LabelDetail();
ld.LabelName='amount2_1';
ld.LabelValue='3199.00'; 
ld.DisplayName='Senetli Tutar2';
ld.MaxLength=10;
ld.IsMultiLine=false;
ldList.Add(ld);


ld = new RC_ProductLabelIntegrator.LabelDetail();
ld.LabelName='Installment1_2';
ld.LabelValue='2999.00'; 
ld.DisplayName='Senetli Tutar1';
ld.MaxLength=10;
ld.IsMultiLine=false;
ldList.Add(ld);

ld = new RC_ProductLabelIntegrator.LabelDetail();
ld.LabelName='Installment2';
ld.LabelValue='3999.00'; 
ld.DisplayName='Senetli Tutar2';
ld.MaxLength=10;
ld.IsMultiLine=false;
ldList.Add(ld);

ld = new RC_ProductLabelIntegrator.LabelDetail();
ld.LabelName='Installment3';
ld.LabelValue='4999.00'; 
ld.DisplayName='Senetli Tutar3';
ld.MaxLength=10;
ld.IsMultiLine=false;
ldList.Add(ld);

        switch on tagPriceType {
            when 'SpecialPrice' {
                labelName = definitionList[0].RC_Special_Price_Label_PDF__c;
            }	
            when 'Stamped' {
                labelName = definitionList[0].RC_Stamped_Label_PDF__c;
            }
            when 'Installment' {
                labelName = definitionList[0].RC_Installment_Label_PDF__c;
            }
            when else {
                labelName = definitionList[0].RC_Standart_Label_PDF__c;
            }
        }
*/      
        labelName = tagPriceType == 'SpecialPrice' ? definitionList[0].RC_Special_Price_Label_PDF__c 
            : tagPriceType == 'Stamped' ? definitionList[0].RC_Stamped_Label_PDF__c 
                : tagPriceType == 'Installment' ? definitionList[0].RC_Installment_Label_PDF__c 
                    : definitionList[0].RC_Standart_Label_PDF__c ;        
        
        r.LabelName = labelName;
        r.labelDetail = ldList;
        System.debug('gonderilecek object r : '+ JSON.serialize(r));
        string base64String = RC_ProductLabelIntegrator.getCreatePDF(r,true);        
        return base64String;        
    }
    
     @AuraEnabled
    public static String GetDateFormat(string changeDate)
    {
        String separator = '.';
        
        String y = changeDate.substring(0,4);
        String m = changeDate.substring(5,7);
        String d = changeDate.substring(8,10);
        
        List<String> listVariable = new List<String>{d, m, y};
            
        return String.join(listVariable, separator);        
    }
    
   /* public static PageReference pdfViewer(string base64string) {
        try{
            System.debug('pdfViewer : '+ base64string );
            PageReference pdfViewerPage = new PageReference('/apex/RC_ConvertBase64ToPDF');			
            pdfViewerPage.getParameters().put('dataPDF',base64string);            
            
            System.debug('returne geldi : ');
            return pdfViewerPage.setRedirect(true);
        }
        catch(Exception e) {
            System.debug('pdfViewer exc:'+e);
            return null;
        }
        
    }*/
    
    /* @AuraEnabled
    public static Integer getMaxRowSelection(string tagTypeValueLabel){                
        Integer maxRowSelection = 3;
        
        try{
            definitionList =[SELECT Id, RC_Product_Group__c, RC_Label_Type__c, RC_Standart_Label_PDF__c, RC_Special_Price_Label_PDF__c, RC_Stamped_Label_PDF__c, RC_Installment_Label_PDF__c, RC_Count__c from RC_Definition__c  where RC_Standart_Label_PDF__c!= '' and RC_Label_Type__c = :tagTypeValueLabel];
            maxRowSelection = definitionList[0].RC_Count__c.intValue();
            
            return maxRowSelection;            
        }
        catch(Exception e) {
            System.debug('Exception getMaxRowSelection:'+e);               
        }
        
        return maxRowSelection;
    }*/
    
    
}