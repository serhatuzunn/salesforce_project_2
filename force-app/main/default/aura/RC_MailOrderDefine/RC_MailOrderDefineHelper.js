({    
    clickFilter : function(component, event, helper){        
        helper.setBusy(component,true);
        
        component.set("v.visiblePayment", false);
        helper.removeError(component, event, helper);
        
        var accountName = (component.get("v.selectedAccount")).Name;
        
        var action = component.get('c.getCustomerOrders');
        action.setParams({ "accountName"  : accountName });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){
                helper.setBusy(component,false);
                var parsedData = JSON.parse(result);
                component.set('v.customerOrderList', parsedData);
                
                if(parsedData.oHeader != null && parsedData.oHeader.item != null && parsedData.oHeader.item.length>0 ){
                    component.set("v.visiblePayment", true);
                    component.set('v.dataList', parsedData.oHeader.item);                    
                }else{
                    helper.addErrorMessage(component, event, helper,'Sipariş bulunamadı.');
                    component.set('v.customerOrderList', null);
                    component.set('v.dataList',null);
                } 
            }
            else{
                component.set('v.customerOrderList', null);
                component.set('v.dataList',null);
                helper.addErrorMessage(component, event, helper,"Sipariş bilgileri getirilirken hata oluştu!");
                helper.setBusy(component,false);
            }                      
        });
        
        $A.enqueueAction(action);
        
    },
    
    getAssecoPaymentLink : function(component, event, helper){
    
    var action = component.get('c.getAssecoPaymentLink');        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            console.log('error :  '+ JSON.stringify(error));
            console.log('result :  '+ JSON.stringify(result));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                component.set('v.assecoPaymentLink', result);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    getColumnDefinitions: function () {
        var columnsWidths = this.getColumnWidths();
        var actions = [
            { label: 'Detay', name: 'details',iconName: 'utility:info' },
            { label: 'Parçalı Ödeme', name: 'partial_payment', iconName: 'utility:adjust_value' },
            { label: 'Ödeme Yap', name: 'do_payment', iconName: 'utility:payment_gateway' }
        ];
        
        var columns = [
            {label: 'Sipariş No', fieldName: 'VBELN', type: 'text', wrapText: false, sortable: false},
            {label: 'Sipariş Tarihi', fieldName: 'AUDAT', type: 'date-local', wrapText: false, sortable: false},            
            {label: 'Sipariş Tutarı', fieldName: 'NETWR', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    getColumnDefinitionsOrderDetail: function (actionType) {
        var columnsWidths = this.getColumnWidths();        
        var columns = [
            {label: 'Ürün Kodu', fieldName: 'MATNR', type: 'Long', wrapText: false, cellAttributes: { alignment: 'left'}, sortable: false},
            {label: 'Ürün Adı', fieldName: 'ARKTX', type: 'text', wrapText: false, cellAttributes: { alignment: 'left'}, sortable: false},            
            {label: 'Miktar', fieldName: 'KWMENG', type: 'Integer', wrapText: false, cellAttributes: { alignment: 'left'}, sortable: false},
            {label: 'Fiyat', fieldName: 'NETWR', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false}            
        ];
        
        if(actionType=='partial_payment'){
            columns = [
                {label: 'Kalem No', fieldName: 'POSNR', type: 'Integer', wrapText: false, cellAttributes: { alignment: 'left'}, sortable: false},
                {label: 'Ürün Kodu', fieldName: 'MATNR', type: 'Long', wrapText: false, cellAttributes: { alignment: 'left'}, sortable: false},
                {label: 'Ürün Adı', fieldName: 'ARKTX', type: 'text', wrapText: false, cellAttributes: { alignment: 'left'}, sortable: false},            
                {label: 'Miktar', fieldName: 'KWMENG', type: 'Integer', wrapText: false, cellAttributes: { alignment: 'left'}, sortable: false},
                {label: 'Fiyat', fieldName: 'NETWR', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
                {label: 'Alınacak Adet', fieldName: 'PURCHQUA', type: 'number', cellAttributes: { alignment: 'left'}, typeAttributes:{label: 'Alınacak Miktar', name: "PURCHQUA", disabled: false}, editable: true,sortable: false}
            ];
            
        }
        
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    getColumnWidths: function () {
        var widths = localStorage.getItem('datatable-in-action');
        
        try {
            widths = JSON.parse(widths);
        } catch(e) {
            return [];
        }
        return Array.isArray(widths) ? widths : [];
    },
    
    handleEditCell: function (component, event) {
        
        
    },
    
    openModel : function(component, event, helper, actionType) {
        // Set isModalOpen attribute to true
        var row = event.getParam('row');        
        var selectedRow = JSON.parse(JSON.stringify(row));        
        var deliveryNo = selectedRow.VBELN;
        var totalAmount = selectedRow.NETWR;
        component.set("v.deliveryNo", deliveryNo);
        component.set("v.totalAmount", totalAmount);
        
        console.log('deliveryNo'+deliveryNo);
        console.log('totalAmount'+totalAmount);
        
        if(actionType=='details'){
            component.set('v.columnsOrderDetail', helper.getColumnDefinitionsOrderDetail('details'));
            
            component.set("v.modalHeaderText",deliveryNo +' - Sipariş Detayı');
            component.set("v.isOpenPaymentType",false);            
            component.set('v.isBtnSend',false);
        }else if(actionType=='partial_payment'){
            component.set('v.columnsOrderDetail', helper.getColumnDefinitionsOrderDetail('partial_payment')); 
            
            component.set("v.modalHeaderText",deliveryNo +' - Parçalı Ödeme Ekranı');
            component.set("v.isOpenPaymentType",true);            
            component.set('v.isBtnSend',true);
        }else{
            component.set('v.showWarningDialog', true);
            return;
        }
        
        component.set("v.isModalOpen", true);
        var orderList = component.get('v.customerOrderList');
        var objOrderList = JSON.parse(JSON.stringify(orderList)); 
        console.log('objOrderList :  '+ JSON.stringify(objOrderList));        
        
        var orderDetailList = [];
        var counter = objOrderList.oDetail.item.length;        
        
        orderDetailList = objOrderList.oDetail.item.filter(c => c.VBELN === deliveryNo);        
        component.set("v.dataListOrderDetail", orderDetailList);       
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.tempCustomerOrderList",null);
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        var deliveryNo = component.get("v.deliveryNo");
        var modalHeaderText = component.get("v.modalHeaderText");
        var isPartial = modalHeaderText.includes('Parçalı');        
        if(isPartial){
            var partialData = JSON.parse(JSON.stringify(component.get("v.tempCustomerOrderList")));
            console.log('partialData: '+partialData);
            if(partialData == null || partialData.length<1){
                helper.showMessage(component,'error','Gönderilecek data setlenemedi!');
                return;
            }else{
                var partialTotalAmount = 0.00;
                for(var i = 0; i < partialData.length; i++) {
                    var rowAmount = parseFloat(JSON.parse(partialData[i]).NETWR) 
                    partialTotalAmount = parseFloat(partialTotalAmount) + parseFloat(rowAmount);
                    
                    component.set("v.totalAmount", partialTotalAmount.toFixed(3));
                }
                console.log('deliveryNo'+deliveryNo);
                console.log('partialTotalAmount'+partialTotalAmount);
            }
            //Yukardaki objList
        }else{            
            //SelectedRowdaki dataları al
            //Ödeme fonksiyonuna git
        }
        
        component.set('v.showWarningDialog', true);        
    },
    
    saveEdition: function (component, draftValues) 
    {
        // draft values
        var draftData = draftValues;
        console.log(draftData);
        
        // original values
        var originalData = component.get("v.data");
        console.log(originalData);
        
        // Question - how to save draftData in originalData
    },
    
    handleConfirmDialogYes : function(component, event, helper){
        component.set('v.showWarningDialog', false);
    },
    
    handleConfirmDialogNo : function(component, event, helper){
        
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