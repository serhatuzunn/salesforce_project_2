({
    helperMethod : function() {
        
    },
    
    parseBase64toFile : function(base64) {
        
        var url = 'data:application/octet-stream;base64,' + base64;
        var urlEvent = $A.get('e.force:navigateToURL');
        
        console.log('url');
        console.log(url);
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    convertBase64ToPDF : function(base64String){           
        
        const byteCharacters = atob(base64String);
        const byteNumbers = new Array(byteCharacters.length);
        for (let i = 0; i < byteCharacters.length; i++) {
            byteNumbers[i] = byteCharacters.charCodeAt(i);
        }    
        const byteArray = new Uint8Array(byteNumbers);
        const blob = new Blob([byteArray], {type: 'application/pdf'});
        /*const blobUrl = URL.createObjectURL(blob);
        window.location = blobUrl;*/
        
        
        const data = window.URL.createObjectURL(blob);
        var link = document.createElement('a');
        link.href = data;
        link.download="file.pdf";
        document.body.appendChild(link);
        link.click();
        setTimeout(function(){            
            document.body.removeChild(link); 
            window.URL.revokeObjectURL(data);
        }, 100);
        
    },
    
    
    
    getSelectedTagTypeLabel : function(component){
        var selectedTagTypeLabel ='';
        var selectedTagTypeValue = component.get("v.selectedValueTagType");
        var itemsToPass = component.get("v.tagType");
        for (var i=0; i< itemsToPass.length; i++)
        {
            if(itemsToPass[i].value == selectedTagTypeValue ){
                selectedTagTypeLabel = itemsToPass[i].label;
            }
        }
        
        return selectedTagTypeLabel;
    },
    
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },
    
    clickFilter : function(component, event, helper, showData, draftList){
        helper.setBusy(component,true);
        var productCodeName = component.find("productCodeName").get("v.value");
        var tagType = component.find("tagTypeNew").get("v.value");
        var productGroupe = component.find("productGroupe").get("v.value");
        console.log('data:'+productCodeName+' - '+tagType+' - '+productGroupe);
        
        if(tagType!= undefined && tagType != ''){
            helper.removeError(component,event,helper);
            var action=component.get('c.fetchProductRecords');
            action.setParams( { "tagType"  : tagType,
                               "productGroupe"  : productGroupe,
                               "productCodeName"  : productCodeName} );            
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var rows = response.getReturnValue();
                    var rowCount = rows.length;
                    helper.setBusy(component,false);
                    if(rowCount==0){
                        component.set("v.productList", null);
                        helper.addErrorMessage(component,event,helper,"İlgili ürün bulunamadı.");
                    }
                    else{
                        component.set("v.visibleProductTable", true);
                        component.set("v.hidePreviewBtn", true);
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (row.RC_Product__r){
                                row.ProductCode = row.RC_Product__r.ProductCode;
                                row.Description = row.RC_Product__r.Description;
                            }
                            
                            
                            if (rows != null && rows.length > 0) {
                                let parsedData = [];
                                if(!showData){
                                    
                                    rows.forEach( document=> {
                                        debugger;
                                        if (draftList!= null && draftList.filter(e => e.Id === document['Id']).length > 0){
                                        parsedData.push(document);
                                        return;
                                    }
                                        if (document['RC_Price_Update_Date__c'] ) {document['RC_Price_Update_Date__c'] = '';}
                                        else if (document['RC_Price__c']) {document['RC_Price__c'] = '';}
                                        else if (document['RC_Terminated_Amount__c'] ) {document['RC_Terminated_Amount__c'] = '';}
                                        else if (document['RC_Bill_Amount_1__c'] ) {document['RC_Bill_Amount_1__c'] = '';}
                                        else if (document['RC_Bill_Amount_2__c'] ) {document['RC_Bill_Amount_2__c'] = '';}
                                        else if (document['RC_Installment_Amount_1__c'] ) {document['RC_Installment_Amount_1__c'] = '';}
                                        else if (document['RC_Installment_Amount_2__c'] ) {document['RC_Installment_Amount_2__c'] = '';}
                                        else if (document['RC_Installment_Amount_3__c']){document['RC_Installment_Amount_3__c'] = '';}
                                        
                                        parsedData.push(document);
                                    });
                                    }else{
                                        parsedData=rows;
                                    }                            
                                        component.set("v.productList", parsedData);
                        }
                    }
                }                    
            }
                               });
            $A.enqueueAction(action);
        }
        else{
            helper.addErrorMessage(component,event,helper,"Lütfen Etiket Tipi alanını seçiniz!");
            helper.setBusy(component,false);
        }
    },
    
    saveEdition: function (component, draftValues) {
        var productList = component.find("v.productList");
        
    },
    
    saveDataTable : function(component, event, helper) {
        var dv = component.find("linesTable").get("v.draftValues");
        console.log('dv: '+ dv);
    },
    
    toastMsg : function( strType, strMessage ) {            
        var showToast = $A.get( "e.force:showToast" );   
        showToast.setParams({              
            message : strMessage,  
            type : strType,  
            mode : 'sticky'              
        });   
        showToast.fire();          
    },
    
    addErrorMessage : function(component,event,helper,message){
        var errorMsg = component.find("errorMsg");
        $A.util.addClass(errorMsg,'slds-show');
        $A.util.removeClass(errorMsg,'slds-hide'); 
        component.set("v.error",true);
        component.set("v.message",message);
    },
    
    removeError : function(component,event,helper){
        var errorMsg = component.find("errorMsg");
        $A.util.addClass(errorMsg,'slds-hide');
        $A.util.removeClass(errorMsg,'slds-show');  
        component.set("v.error",false);
    }
})