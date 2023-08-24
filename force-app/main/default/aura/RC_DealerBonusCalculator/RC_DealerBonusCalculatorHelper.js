({
    helperMethod : function() {
        
    },
    
    getColumnShipmentDefinitions : function () {
        var columnsWidths = this.getColumnWidths();
        var actions = [            
            { label: 'Detay', name: 'details', iconName: 'utility:info' }
        ];
        
        var columns = [
            {label: 'Dönem', fieldName: 'PERIOD', type: 'text', wrapText: false, sortable: false},
            {label: 'Toplam Sipariş Adedi', fieldName: 'TOTALORDERCOUNT', type: 'text', wrapText: false, sortable: false},
            {label: 'Toplam Prim(KDV Hariç)', fieldName: 'TOTALBONUSWITHOUTTAX', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
            {label: 'KDV', fieldName: 'KDV', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
            {label: 'Toplam Prim Tutarı', fieldName: 'TOTALBONUS', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
            {label: 'Fatura Matbu No', fieldName: 'INVOICENO', type: 'text', wrapText: false,  editable: {fieldName: 'EDITABLE'}, sortable: false},
            {label: 'Açıklama', fieldName: 'DESCRIPTION', type: 'text', wrapText: false,  editable: {fieldName: 'EDITABLE'}, sortable: false},
            { type: 'action', typeAttributes: { rowActions: actions } }            
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    getColumnShipmentDefinitionsDetail : function () {
        var columnsWidths = this.getColumnWidths();        
        var columns = [            
            {label: 'Sipariş Tarihi', fieldName: 'ERDAT', type: 'date-local',initialWidth: 150, wrapText: false, sortable: false},
            {label: 'SAP Sipariş No', fieldName: 'VBELN', type: 'text', initialWidth: 150,wrapText: false, sortable: false},            
            {label: 'Tük. Adı Soyadı', fieldName: 'NAME1', type: 'text',initialWidth: 150, wrapText: false, sortable: false},            
            {label: 'Ürün Kodu', fieldName: 'MATNR', type: 'text', initialWidth: 150, wrapText: false, sortable: false},            
            {label: 'Ürün Adı', fieldName: 'MATNR_T', type: 'text',initialWidth: 150, wrapText: false, sortable: false},
            {label: 'Sipariş Adedi', fieldName: 'KWMENG', type: 'number', initialWidth: 150, wrapText: false, sortable: false},
            {label: 'Vestel Ödeme No', fieldName: 'BELNR_V', type: 'text', initialWidth: 150, wrapText: false,sortable: false},
            {label: 'Aksiyon Birim Fiyat', fieldName: 'ZFIYAT2_BR', type: 'currency', initialWidth: 150, wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
            {label: 'Toplam Fiyat', fieldName: 'ZFIYAT2', type: 'currency', initialWidth: 150, wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},            
            {label: 'Komisyon Oranı', fieldName: 'ORAN', type: 'percentage', initialWidth: 150, wrapText: false, sortable: false}, 
            {label: 'Prim(BSP)', fieldName: 'ZPRIM', type: 'currency', initialWidth: 150, wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false}
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
    
    getColumnDefinitions : function () {
        var columnsWidths = this.getColumnWidths();
        
        var columns = [
            {label: 'Dönem', fieldName: 'PERIOD', type: 'text', wrapText: false, sortable: false},
            {label: 'Ortalama Gün', fieldName: 'ORTGUN', type: 'text', wrapText: false, sortable: false},
            {label: 'Prim(KDV Hariç)', fieldName: 'TOTALBONUSWITHOUTTAX', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
            {label: 'KDV %18', fieldName: 'KDV', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},
            {label: 'Toplam', fieldName: 'TOTALBONUS', type: 'currency', wrapText: false, cellAttributes: { alignment: 'left'}, typeAttributes: { currencyCode: 'TRY'}, sortable: false},            
            {label: 'Fatura Matbu No', fieldName: 'INVOICENO', type: 'text', wrapText: false, editable: {fieldName: 'EDITABLE'}, sortable: false},
            {label: 'Açıklama', fieldName: 'DESCRIPTION', type: 'text', wrapText: false, editable: {fieldName: 'EDITABLE'}, sortable: false}
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    getDealerBonusShipment : function(component, event, helper) {
        helper.getDealerBonusShipmentDateControl(component, event, helper);
        
        if(component.get('v.dateControl')){
            helper.setBusy(component,true);
            
            let resultData = [];
            let parsedData = [];
            
            var selectedStartDate = component.find("startDate").get("v.value");
            var selectedEndDate = component.find("endDate").get("v.value");
            
            var action = component.get('c.getDealerBonusShipment');
            action.setParams({ "startDate"  : selectedStartDate,
                              "endDate" : selectedEndDate});
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var error = response.getError();
                
                console.log('response.getState() :  '+ JSON.stringify(response.getState()));
                if(component.isValid() && response.getState() == "SUCCESS"){
                    helper.setBusy(component,false);
                    
                    parsedData = JSON.parse(result);
                    component.set('v.bonusDealerShipmentFilterList',parsedData);
                    console.log('v.bonusDealerShipmentFilterList:  '+ JSON.stringify(component.get('v.bonusDealerShipmentFilterList')));
                    
                    if(parsedData.length>0){
                        
                        for(var i=0; i<parsedData.length; i++){
                            resultData.push(parsedData[i].headerData);
                        }
                        
                        component.set('v.dataListShipment',resultData);                    
                        component.set('v.visibleDealerBonusShipment',true);                    
                    }else{
                        component.set('v.dataListShipment',null); 
                        helper.addErrorMessage(component, event, helper,'Sipariş bulunamadı.');
                    }
                }
                else{
                    component.set('v.dataListShipment',null); 
                    helper.addErrorMessage(component, event, helper,"Sipariş bilgileri getirilirken hata oluştu!");
                    helper.setBusy(component,false);
                }                      
            });
            
            $A.enqueueAction(action); 
        }
        
    },
    
    getDealerBonusShipmentDateControl : function(component, event, helper) {        
        
        var selectedStartDate = component.find("startDate").get("v.value");
        var selectedEndDate = component.find("endDate").get("v.value");
        
        var resultStartDate = selectedStartDate.split('-');
        var resultEndDate = selectedEndDate.split('-');
        
        const d1 = new Date(resultStartDate[0], resultStartDate[1],resultStartDate[2]);
        const d2 = new Date(resultEndDate[0], resultEndDate[1],resultEndDate[2]);
        console.log('d1: ' +  d1 );console.log('d2: ' +  d2 );
        if(d1 > d2){
            component.set('v.dateControl',false);
            helper.addErrorMessage(component, event, helper,"Başlangıç tarihi Bitiş Tarihinden büyük olamaz!");            
            return;
        }
        /*const diffInMs = Math.abs(d2 - d1);
        const numberDaysDiff =  diffInMs / (1000 * 60 * 60 * 24);
        console.log('numberDaysDiff: ' +  numberDaysDiff );
        if(numberDaysDiff > 180){
            component.set('v.dateControl',false);
            helper.addErrorMessage(component, event, helper,"En fazla 180 günlük sorgulama yapılabilir!");            
            return; 
        }*/
        
        /* var today = new Date();
        	if(d2.getFullYear() == today.setMonth(today.getMonth()-1).getFullYear() 
           && d2.getMonth() == today.setMonth(today.getMonth()-1).getMonth() && d2.getDay() < 15 ){
           component.set('v.dateControl',false);
            
            const monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
            
            const fullPeriod = monthNames[d2.getMonth()]+" - " +d2.getFullYear();
            const thisMonth15 = '15-'+monthNames[d2.getMonth()]+'-'+d2.getFullYear();
            
            const errMsg = '${fullPeriod} döneminin hakedişlerini ${thisMonth15} tarihi itibari ile görüntüleyebileceksiniz.';            
            helper.addErrorMessage(component, event, helper,errMsg);
            return;
        } */           
    },
    
    
    getDealerBonus : function(component, event, helper,bonusType) {
        
        helper.setBusy(component,true);
        
        var period = '';
        var preYear = '';
        var selectedStartDate ='';
        var selectedEndDate = '';
        
        let resultData = [];
        let parsedData = [];
        
        period =  component.find('periodType').get("v.value");
        console.log('period :  '+ JSON.stringify(period));
        
        preYear =  component.find('preYear').get("v.value");
        console.log('preYear :  '+ JSON.stringify(preYear));
        
        var action = component.get('c.getDealerBonus');
        action.setParams({ "startDate"  : selectedStartDate,
                          "endDate" : selectedEndDate,
                          "period" : period,
                          "bonusType" : bonusType,
                          "preYear" : preYear});
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){
                helper.setBusy(component,false);
                
                parsedData = JSON.parse(result);
                if(parsedData===null){
                    helper.addErrorMessage(component, event, helper,"Prim bulunamadı!");
                    helper.setBusy(component,false);
                    return;
                }
                if(bonusType=='A'){
                    component.set('v.bonusDealerFilterStoreList',parsedData);
                    console.log('v.bonusDealerFilterStoreList:  '+ JSON.stringify(component.get('v.bonusDealerFilterStoreList')));
                    
                    component.set('v.dataListStore',parsedData);                    
                    component.set('v.visibleDealerBonusStore',true);  
                }else{
                    component.set('v.bonusDealerFilterList',parsedData);
                    console.log('v.bonusDealerFilterList:  '+ JSON.stringify(component.get('v.bonusDealerFilterList')));
                    
                    component.set('v.dataList',parsedData);                    
                    component.set('v.visibleDealerBonus',true);
                }
            }
            else{
                if(bonusType=='A'){
                    component.set('v.dataListStore',null); 
                } else component.set('v.dataList',null);                    
                helper.addErrorMessage(component, event, helper,"Prim bilgileri getirilirken hata oluştu!");
                helper.setBusy(component,false);
            }                      
        });
        
        $A.enqueueAction(action);
    },
    
    openModel : function(component, event, helper, actionType) {
        // Set isModalOpen attribute to true
        var row = event.getParam('row');        
        var selectedRow = JSON.parse(JSON.stringify(row));
        var period = selectedRow.PERIOD;
        
        if(actionType=='details'){
            component.set('v.columnListShipmentDetail', helper.getColumnShipmentDefinitionsDetail());            
            component.set("v.modalHeaderText", period +' Bayiden Sevk Prim Detayı');
        }        
        var dealerBonusShipment = component.get('v.bonusDealerShipmentFilterList');
        debugger;
        console.log('dealerBonusShipment: ' +  JSON.parse(JSON.stringify(dealerBonusShipment)) );
        
        for (let i = 0; i < dealerBonusShipment.length; i++) {
            if (dealerBonusShipment[i].headerData.PERIOD === period) { 
                component.set('v.dataListShipmentDetail', dealerBonusShipment[i].item);
                break;
            }
        }
        
        component.set("v.isModalOpenShipment", true);  
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.dataListShipmentDetail",null);
        component.set("v.isModalOpenShipment", false);
    },
    
    updateDealerBonusShipment : function(component, event, helper, data, bonusType){
        helper.setBusy(component,true);
        
        var draftValues = event.getParam('draftValues'); 
        
        console.log('bonusType-> ' + JSON.stringify(bonusType));
        console.log('draftValues-> ' + JSON.stringify(draftValues));        
        console.log('dataListShipment-> ' + JSON.stringify(data));
        
        var action = component.get('c.updateDealerBonusShipment');
        action.setParams({ "draftValues"  : draftValues,
                          "bonusType" : bonusType,
                          "headerData" : data});
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){
                helper.setBusy(component,false);
                $A.get('e.force:refreshView').fire();
                helper.toastMsg('success', 'Fatura bilgileri başarıyla kaydedilmiştir.');
                draftValues = null;
            }
            else{                
                helper.addErrorMessage(component, event, helper,"Fatura bilgileri kaydedilirken hata oluştu!");
                helper.setBusy(component,false);
            }                      
        });
        
        $A.enqueueAction(action);
                 
    },
    

    updateDealerBonus : function(component, event, helper, data, bonusType){
        helper.setBusy(component,true);
        
        var draftValues = event.getParam('draftValues'); 
        
        console.log('bonusType-> ' + JSON.stringify(bonusType));
        console.log('draftValues-> ' + JSON.stringify(draftValues));        
        console.log('dataList-> ' + JSON.stringify(data));
        
        var action = component.get('c.updateDealerBonus');
        action.setParams({ "draftValues"  : draftValues,                         
                          "bonusType" : bonusType,
                          "headerData" : data});
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){
                helper.setBusy(component,false);
                $A.get('e.force:refreshView').fire();
                helper.toastMsg('success', 'Fatura bilgileri başarıyla kaydedilmiştir.');
                draftValues = null;
            }
            else{                
                helper.addErrorMessage(component, event, helper,"Fatura bilgileri kaydedilirken hata oluştu!");
                helper.setBusy(component,false);
            }                      
        });
        
        $A.enqueueAction(action);
                 
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