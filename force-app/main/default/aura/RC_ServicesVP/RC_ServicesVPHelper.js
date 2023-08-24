({
    helperMethod : function() {
        
    },
    
    getColumnDefinitions : function () {
        var columnsWidths = this.getColumnWidths();        
        var columns = [                        
          /*  {label: 'İl', fieldName: 'IL', type: 'text',  wrapText: false, sortable: false},            
            {label: 'İlçe', fieldName: 'ILCE', type: 'text',  wrapText: false, sortable: false},            
            {label: 'Semt', fieldName: 'SEMT', type: 'text',  wrapText: false, sortable: false},  */          
            {label: 'Servis Kodu', fieldName: 'SERVIS_KODU', type: 'text', initialWidth : 129,  wrapText: false, sortable: false},
            {label: 'Servis Adı', fieldName: 'SERVIS_ADI', type: 'text',  wrapText: false, sortable: false},
            {label: 'Adres', fieldName: 'ADRES', type: 'text',  wrapText: false, sortable: false},
            {label: 'Mail', fieldName: 'EMAIL', type: 'text',  wrapText: false, sortable: false},
            {label: 'Telefon', fieldName: 'TELEFON1', type: 'text', initialWidth : 105,  wrapText: false, sortable: false},
            {label: 'Yetki', fieldName: 'YETKINLIK2', type: 'text', initialWidth : 270,  wrapText: false, sortable: false}
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
    
    fillAuthority : function (component, event, helper){
        
        var action = component.get('c.fillAuthority');          
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                console.log('v.authorityList: '+ result);
                component.set('v.authorityList', result);                    
            }
            else{
                component.set('v.authorityList',null);
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    fillCities : function (component, event, helper){
        
        var action = component.get('c.fillCities');          
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                console.log('v.cityList: '+ result);
                component.set('v.cityList', result);                    
            }
            else{
                component.set('v.cityList',null);
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    fillRegions : function (component, event, helper, selectedCity){
        helper.setBusy(component,true);
        
        var action = component.get('c.fillRegions');
        action.setParams({ "code" : selectedCity });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                console.log('v.regionList: ' + result);
                component.set('v.regionList', result);                    
            }
            else{
                component.set('v.regionList',null);
            }
        });
        helper.setBusy(component,false);
        $A.enqueueAction(action); 
    },
    
    fillDistricts : function (component, event, helper, selectedRegion){
        helper.setBusy(component,true);
        
        var action = component.get('c.fillDistricts');
        action.setParams({ "code" : selectedRegion });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){                
                console.log('v.districtList:  '+ result);
                component.set('v.districtList',result);                    
            }
            else{
                component.set('v.districtList',null);
            }
        });
        helper.setBusy(component,false);
        $A.enqueueAction(action); 
    },
    
    getServicesVP : function (component, event, helper){
        helper.setBusy(component,true);
        
        var parsedData ;
        
        var selectedCity = component.get("v.selectedCity");
        var selectedRegion = component.get("v.selectedRegion");
        var selectedDistrict = component.get("v.selectedDistrict");
        var selectedAuth = component.get("v.selectedAuthority");
        
        var action = component.get('c.getServicesVP');
        action.setParams({"city" : selectedCity, 
                          "region" : selectedRegion,
                          "district" :  selectedDistrict,
                          "authority" : selectedAuth } );
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            helper.setBusy(component,false);
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){
                
                parsedData  = JSON.parse(result);
                component.set('v.dataListServicesVP', parsedData.ET_INFO.item) ;
                component.set('v.visibleServicesVPDT', true);
                
            }
            else{
                component.set('v.dataListServicesVP',null);
                helper.addErrorMessage(component, event, helper,"Servis bilgileri getirilirken hata oluştu!");
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