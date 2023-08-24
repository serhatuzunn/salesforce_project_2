({
    myAction : function(component, event, helper) {
        
    },
    
    init: function (component, event, helper) {        
        component.set('v.columnListServicesVP', helper.getColumnDefinitions());
        component.set('v.cityList', helper.fillCities(component, event, helper));
        component.set('v.authorityList', helper.fillAuthority(component, event, helper));
        component.set('v.visibleServicesVPDT',false);
    },
    
    handleSelectedCity : function(component, event, helper){                               
        helper.removeError(component, event, helper);
        
        var selectedCity = component.get("v.selectedCity");
        if(selectedCity == '' || selectedCity =='0'){
            helper.addErrorMessage(component, event, helper,'İl seçimi zorunludur.');
            return;            
        }
        helper.fillRegions(component, event, helper, selectedCity);
    },
    
    handleSelectedRegion : function(component, event, helper){
        helper.removeError(component, event, helper);
        
        var selectedRegion = component.get("v.selectedRegion");
        if(selectedRegion == '' || selectedRegion =='0'){
            helper.removeError(component, event, helper);
            return;
        }
        helper.fillDistricts(component, event, helper, selectedRegion);
        component.set("v.selectedDistrict",'');        
    },
    
    handleSelectedDistrict : function(component, event, helper){
        helper.removeError(component, event, helper);
        
        var selectedDistrict = component.get("v.selectedDistrict");
        if(selectedDistrict == '' || selectedDistrict =='0'){
            helper.addErrorMessage(component, event, helper,'İl seçimi zorunludur.');
            return;            
        }
    },
    
    handleSelectedAuthority : function(component, event, helper){
        
    },
    
    clickFilter : function(component, event, helper) {
        helper.removeError(component, event, helper);
        
        var selectedCity = component.get("v.selectedCity");
        var selectedRegion = component.get("v.selectedRegion");
        var selectedDistrict = component.get("v.selectedDistrict");
        
        if(selectedCity == '' || selectedCity =='0'){
            helper.addErrorMessage(component, event, helper,'İl seçimi zorunludur.');
            return;
        }
        else if(selectedRegion == '' || selectedRegion =='0'){
            helper.addErrorMessage(component, event, helper,'İlçe seçimi zorunludur.');
            return;
        }
        else if (selectedDistrict=='' || selectedDistrict =='0'){
            helper.addErrorMessage(component, event, helper,'Semt seçimi zorunludur.');
            return;
        }
        helper.getServicesVP(component, event, helper);
    },
})