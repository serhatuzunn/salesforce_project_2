({
    myAction : function(component, event, helper) {
        
    },
    
    fetchProducts : function(component, event, helper) {
        var tagPriceType = component.find("tagPriceType").get("v.value");
        console.log('tagPriceType: '+tagPriceType);
        
        if(tagPriceType=='SpecialPrice'){
            console.log('special: '+tagPriceType);
            component.set('v.mycolumn', [
                {label: 'Ürün Kodu', fieldName: 'ProductCode', type: 'text',hideDefaultActions:true },
                {label: 'Ürün Adı', fieldName: 'Description', type: 'Text'},
                /* {label: 'Başlık', fieldName: 'RC_Header__c', type: 'text',wrapText: true},
                    {label: 'Açıklama', fieldName: 'RC_Description__c', type: 'text', wrapText: true},
                    {label: 'Üretim Yeri', fieldName: 'RC_Manufacture_Place__c', type: 'text'},*/
                {label: 'Fiyat Güncelleme tarihi', fieldName: 'RC_Price_Update_Date__c', type: 'date-local',typeAttributes:{month: "2-digit", day: "2-digit"},editable:'true'},
                {label: 'Fiyat', fieldName: 'RC_Price__c', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.001'}, cellAttributes: { alignment: 'left' },editable:'true'},            
                {label: 'Sonlandırılan Fiyat', fieldName: 'RC_Terminated_Amount__c', type: 'text', type: 'currency',editable:'true'}]);
            
        }        
        else if(tagPriceType=='Stamped'){
            console.log('stamp: '+tagPriceType);
            component.set('v.mycolumn', [
                {label: 'Ürün Kodu', fieldName: 'ProductCode', type: 'text',hideDefaultActions:true },
                {label: 'Ürün Adı', fieldName: 'Description', type: 'Text'},
                /* {label: 'Başlık', fieldName: 'RC_Header__c', type: 'text',wrapText: true},
                    {label: 'Açıklama', fieldName: 'RC_Description__c', type: 'text', wrapText: true},
                    {label: 'Üretim Yeri', fieldName: 'RC_Manufacture_Place__c', type: 'text'},*/
                {label: 'Fiyat Güncelleme tarihi', fieldName: 'RC_Price_Update_Date__c', type: 'date-local',typeAttributes:{month: "2-digit", day: "2-digit"},editable:'true'},
                {label: 'Fiyat', fieldName: 'RC_Price__c', type: 'Text', typeAttributes: { currencyCode: 'TRY', step: '0.001'}, cellAttributes: { alignment: 'left' },editable:'true'},
                {label: 'Senetli Tutar 1', fieldName: 'RC_Bill_Amount_1__c', type: 'Text', cellAttributes: { alignment: 'left' },  editable:'true'},
                {label: 'Senetli Tutar 2', fieldName: 'RC_Bill_Amount_2__c', type: 'Text', cellAttributes: { alignment: 'left' },  editable:'true'}]);
        }        
            else if(tagPriceType=='Installment'){
                console.log('Installment: '+tagPriceType);
                component.set('v.mycolumn', [
                    {label: 'Ürün Kodu', fieldName: 'ProductCode', type: 'text',hideDefaultActions:true },
                    {label: 'Ürün Adı', fieldName: 'Description', type: 'Text'},
                    /* {label: 'Başlık', fieldName: 'RC_Header__c', type: 'text',wrapText: true},
                    {label: 'Açıklama', fieldName: 'RC_Description__c', type: 'text', wrapText: true},
                    {label: 'Üretim Yeri', fieldName: 'RC_Manufacture_Place__c', type: 'text'},*/
                    {label: 'Fiyat Güncelleme tarihi', fieldName: 'RC_Price_Update_Date__c', type: 'date-local',typeAttributes:{month: "2-digit", day: "2-digit"},editable:'true'},
                    {label: 'Fiyat', fieldName: 'RC_Price__c', type: '', typeAttributes: { currencyCode: 'TRY', step: '0.001'}, cellAttributes: { alignment: 'left' },editable:'true'},            
                    {label: 'Taksitli Tutar 1', fieldName: 'RC_Installment_Amount_1__c', type: 'Text', cellAttributes: { alignment: 'left' }, editable:'true'},
                    {label: 'Taksitli Tutar 2', fieldName: 'RC_Installment_Amount_2__c', type: 'Text', cellAttributes: { alignment: 'left' }, editable:'true'},
                    {label: 'Taksitli Tutar 3', fieldName: 'RC_Installment_Amount_3__c', type: 'Text', cellAttributes: { alignment: 'left' }, editable:'true'}]);
            }        
                else{
                    console.log('Installment: '+tagPriceType);
                    component.set('v.mycolumn', [
                        {label: 'Ürün Kodu', fieldName: 'ProductCode', type: 'text',hideDefaultActions:true },
                        {label: 'Ürün Adı', fieldName: 'Description', type: 'Text'},
                        /* {label: 'Başlık', fieldName: 'RC_Header__c', type: 'text',wrapText: true},
                    {label: 'Açıklama', fieldName: 'RC_Description__c', type: 'text', wrapText: true},
                    {label: 'Üretim Yeri', fieldName: 'RC_Manufacture_Place__c', type: 'text'},*/
                        {label: 'Fiyat Güncelleme tarihi', fieldName: 'RC_Price_Update_Date__c',  type: 'date-local',typeAttributes:{month: "2-digit", day: "2-digit"},editable:'true'},
                        {label: 'Fiyat', fieldName: 'RC_Price__c', type: 'currency',typeAttributes: { currencyCode: 'TRY', step: '0.001'}, cellAttributes: { alignment: 'left' },editable:'true'}
                    ]);
                }
        
        var searchTagType = component.find("tagTypeNew").get("v.value");
        console.log('searchTagType: '+searchTagType);
        
        
        /* if(searchTagType!= undefined ){ 
            var action=component.get('c.fetchProductRecords');
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var rows = response.getReturnValue();
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        if (row.RC_Product__r){
                            row.ProductCode = row.RC_Product__r.ProductCode;
                            row.Description = row.RC_Product__r.Description;
                        }
                    }
                    component.set("v.productList", rows);
                    
                }
            });
            $A.enqueueAction(action);
        } */
        
    },
    
    doInit: function (component, event, helper) {        
    component.set('v.visibleProductTable',false);
    },
    
    /*  handleOptionSelected: function (component, event, helper) {       
        var options = [];
        helper.removeError(component,event,helper);
        var selectedValue = event.getParam("value");
        var selectedValueLabel  = selectedValue;
        console.log('selectedVariant: '+ options);
        
        var action = component.get('c.productGroupeRecords');        
        action.setParams( { "tagTypeValue"  : selectedValue } );
        action.setCallback(this, function(response){
            var state = response.getState();              
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                options.push({"value": 0,"label": "Seçiniz"});
                
                for(var i=0; i<data.length; i++) {  
                    console.log('data[i].Id'+ data[i].Id+'data[i].Name : '+ data[i].Name);
                    var result = data[i].Name.toString().split('-');
                    var item = {"value": result[0],
                                "label": result[1]};
                    options.push(item);
                }
                component.set("v.productGroupe", options);
                
                
                var action = component.get('c.getMaxRowSelection');
                action.setParams( { "tagTypeValueLabel"  : selectedValueLabel } );
                action.setCallback(this, function(response){
                    var state = response.getState();              
                    if (state === "SUCCESS") {
                        component.set('v.maxRowSelection', response.getReturnValue());
                    }
                });  
                $A.enqueueAction(action);
                
            }
        });
        $A.enqueueAction(action);
    },   */ 
    
    handleOptionSelectedNew : function(component, event, helper){        
        var options = [];
        var selectedTagTypeLabel = '';
        helper.setBusy(component,true);
        
        var action = component.get('c.productGroupeRecords'); 
        var selectedTagTypeValue =  component.get("v.selectedValueTagType");
        
        selectedTagTypeLabel = helper.getSelectedTagTypeLabel(component);
        
        
        
        action.setParams( { "tagTypeValue"  : selectedTagTypeValue,
                           "tagTypeLabel"  : selectedTagTypeLabel});
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){                
                component.set("v.productGroupe", result.productGroupes); 
                component.set("v.maxRowSelection", result.maxRowSelectionCount); 
            }
            helper.setBusy(component,false);
        });
        $A.enqueueAction(action);
    },
    
    
    handleOptionSelectedPG: function (component, event) {
        //Get the string of the "value" attribute on the selected option
        var selectedValue = event.getParam("value");              
    },
    
    handleOptionSelectedTagPriceType: function (cmp, event) {
        //Get the string of the "value" attribute on the selected option
        var selectedValue = event.getParam("value");
    },
    
    /*TODO: Etiket tipi selected oldugunda Urun Gruplarini dolduracak func yazilmali*/
    handleTagPriceSelected: function (cmp, event) {
        //Get the string of the "value" attribute on the selected option
        var selectedValue = event.getParam("value");
    },
    
    clickFilter: function(component, event, helper) {
        helper.clickFilter(component, event, helper,false);
    },
    
    handleCellChange: function(component, event, helper) {
        var table = component.find('linesTable').getSelectedRows(); 
        var draftValues =  event.getParam('draftValues');
        console.log(JSON.stringify(draftValues));
        console.log(JSON.stringify(table));
        helper.saveEdition(component, draftValues);
    },
    
    clickPreview: function(component, event, helper) {
        helper.setBusy(component,true);
        helper.removeError(component,event,helper); 
        
        let lines = [];
        let ids = [];
        var selectedTagTypeLabel = '';
        lines = component.find('linesTable').getSelectedRows();
        console.log('selectedRows: '+  JSON.stringify(lines));
        // debugger;
        if(lines.length==0){
            helper.toastMsg('error',"PDF Görüntüleyebilmek için en az 1 satır seçmelisiniz!");            
        }
        for(var i=0; i<lines.length; i++) {            
            var value = lines[i]['Id'];
            ids.push(value);            
        }
        
        var tagType = component.find("tagTypeNew").get("v.value");
        var tagPriceType = component.find("tagPriceType").get("v.value");
        selectedTagTypeLabel = helper.getSelectedTagTypeLabel(component);
        
        var action=component.get('c.previewSelectedProduct');
        action.setParams( { "tagType"  : tagType,
                           "tagTypeLabel" : selectedTagTypeLabel,
                           "tagPriceType" : tagPriceType,
                           "labelIds" :  JSON.stringify(ids)});
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS") {
                // debugger;
                /*var url = 'https://vestel--vtsbxdev--c.visualforce.com/apex/RC_ConvertBase64ToPDF?dataPDF='+response.getReturnValue();
                 helper.parseBase64toFile(response.getReturnValue());      
                component.set('v.strBase64', response.getReturnValue());  */

				helper.convertBase64ToPDF(response.getReturnValue());         
            }
            
            helper.setBusy(component,false);
            
        });
        $A.enqueueAction(action);        
    },
    
    onSave : function( component, event, helper ) {
        var action = component.get("c.updateLabels");
        var productList = component.get("v.productList");
        var draftList = event.getParam('draftValues'); 
        console.log('draftValues-> ' + JSON.stringify(draftList));        
        action.setParams({            
            'updatedLabelList' : JSON.stringify(draftList)            
        });  
        // debugger;
        action.setCallback( this, function(response) {
            var state = response.getState();   
            if ( state === "SUCCESS" ) {
                helper.removeError(component,event,helper);                
                if (response.getReturnValue() === true ){
                    helper.removeError(component,event,helper);                    
                    component.set('v.draftValues', []);
                    helper.clickFilter(component, event, helper, false, draftList);                    
                }
                else{                    
                    helper.toastMsg('error','Something went wrong. Contact your system administrator.');
                }} 
            else {  
                helper.toastMsg('error','Something went wrong. Contact your system administrator.(2)');                
            }            
        });  
        $A.enqueueAction(action);
    },
    
    UpdateSelectedRows: function(component, event, helper) {        
        var selectedRows = event.getParam('selectedRows');
        /*console.log('selectedRows: '+ JSON.stringify(selectedRows));*/
        component.set('v.selectedRowsCount', selectedRows.length);
    },
})