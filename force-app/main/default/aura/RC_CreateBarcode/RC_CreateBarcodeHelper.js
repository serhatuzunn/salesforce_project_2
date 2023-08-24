({
	helperMethod : function() {
		
	},
    
    createPDF : function(component, event, helper, isEan){
        helper.removeError(component,event,helper); 
         debugger;
        var dtSelected = component.get('v.dataListSelected');
        
        if(dtSelected.length==0){
            helper.addErrorMessage(component,event,helper,"PDF işlemi için en az 1 satır seçilmiş olması gerekmektedir!");
            return;
        }
        helper.setBusy(component,true);
        
        var action=component.get('c.createBarcodePDF');
        action.setParams( { "addedProducts"  : JSON.stringify(dtSelected),
                           "isEan" : isEan});
        action.setCallback(this, function(response){            
            var state = response.getState();
        helper.setBusy(component,false);   
            if (state === "SUCCESS") {
                debugger;
                
                var base64String = response.getReturnValue();
                console.log('base64 : '+base64String.replace('\\"', '').replace('\\"',''));
                helper.convertBase64ToPDF(base64String.replace('\\"', '').replace('\\"','').replace('"','').replace('"',''));        
            }                     
        });
        
        $A.enqueueAction(action);
    },
    
    fillHierarchy : function(component, event, helper){        
        var action = component.get('c.fillHierarchy');
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                console.log('v.hierarchyList: '+ result);
                component.set('v.hierarchyList', result);                    
            }
            else{
                component.set('v.hierarchyList',null);
            }
        });
        
        $A.enqueueAction(action); 
        
    },
    
    fillHierarchy2 : function(component, event, helper, selectedHierarchy){        
        var action = component.get('c.fillHierarchy2');
        action.setParams({ "selectedHierarchy" : selectedHierarchy });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                console.log('v.hierarchy2List: '+ result);
                component.set('v.hierarchy2List', result);                    
            }
            else{
                component.set('v.hierarchy2List',null);
            }
        });
        
        $A.enqueueAction(action); 
        
    },
    
    fillHierarchy3 : function(component, event, helper, selectedHierarchy2){        
        var action = component.get('c.fillHierarchy3');
        action.setParams({ "selectedHierarchy2" : selectedHierarchy2 });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                console.log('v.hierarchy3List: '+ result);
                component.set('v.hierarchy3List', result);                    
            }
            else{
                component.set('v.hierarchy3List',null);
            }
        });
        
        $A.enqueueAction(action); 
        
    },
    
    getProductBarcode : function(component, event, helper, selectedHierarchy2){        
       helper.setBusy(component,true);
        
        var parsedData ;        
        var selectedHierarchy  = component.get("v.selectedHierarchy");
        var selectedHierarchy2 = component.get("v.selectedHierarchy2");
        var selectedHierarchy3 = component.get("v.selectedHierarchy3");
        var productCode = component.get("v.productCode");
        
        var action = component.get('c.getProducts');
        action.setParams({"selectedHierarchy" : selectedHierarchy, 
                          "selectedHierarchy2" : selectedHierarchy2,
                          "selectedHierarchy3" :  selectedHierarchy3,
                          "productCode" : productCode } );
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            helper.setBusy(component,false);
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){
                console.log('JSON.parse(result) :  '+ JSON.stringify(JSON.parse(result)));
                parsedData  = JSON.parse(result);
                component.set('v.dataList', parsedData) ;
                component.set('v.visibleProductTable', true);
                
            }
            else{
                component.set('v.dataList',null);
                helper.addErrorMessage(component, event, helper,"Ürün bilgileri getirilirken hata oluştu!");
                helper.setBusy(component,false);
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    convertBase64ToPDF : function(base64String){  
        debugger;
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
    
    deleteRow : function(component, row) {
        var rows = component.get('v.dataListSelected');
        var rowIndex = rows.indexOf(row);

        rows.splice(rowIndex, 1);
        component.set('v.dataListSelected', rows);
    },
    
    getColumnDefinitions : function () {
        var columnsWidths = this.getColumnWidths();        
          var columns = [                        
            {label: 'Ürün Kodu', fieldName: 'ProductCode', type: 'text',  wrapText: false, sortable: false},            
            {label: 'Ürün Adı', fieldName: 'Name', type: 'text',  wrapText: false, sortable: false}
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    getColumnDefinitionsSelected : function () {
        var columnsWidths = this.getColumnWidths();        
        var columns = [                        
            {label: 'Ürün Kodu', fieldName: 'ProductCode', type: 'text', wrapText: false, sortable: false},            
            {label: 'Ürün Adı', fieldName: 'Name', type: 'text', wrapText: false, sortable: false},
            {label: 'Sil', type: 'button', initialWidth: 135, typeAttributes: { label: 'Sil', name: 'delete', title: 'Satır Sil', iconName: 'utility:delete', iconPosition : 'left' , variant:'destructive' }, wrapText: false, sortable: false}            
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    getColumnWidths : function () {
        var widths = localStorage.getItem('datatable-in-action');
        
        try {
            console.log('widths: '+JSON.parse(widths));
            widths = JSON.parse(widths);
        } catch(e) {
            return [];
        }
        return Array.isArray(widths) ? widths : [];
    },
    
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },
    
    showMessage: function (component, type, message) {        
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({               
                message: message,
                type: type,
                mode : 'sticky'
            });
            toastEvent.fire();
        }
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