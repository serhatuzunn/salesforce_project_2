({
    myAction : function(component, event, helper) {
        
    },
    
    init: function (component, event, helper) {
        var today = new Date();
        
        var strDate = 'Y-m-d'
        .replace('Y', today.getFullYear())
        .replace('m', today.getMonth())
        .replace('d', 1);
        
        var endDate = 'Y-m-d'
        .replace('Y', today.getFullYear())
        .replace('m', today.getMonth())
        .replace('d', today.getDate());        
        
        component.set("v.strStartDate", strDate);
        component.set("v.strEndDate", endDate);
        
        component.set('v.columnListShipment', helper.getColumnShipmentDefinitions());
        component.set('v.columnListStore', helper.getColumnDefinitions());
        component.set('v.columnList', helper.getColumnDefinitions());
        
        var year = today.getFullYear();
        var yearList = [{ label: year, value: year}, {label: year-1 ,value: year-1}];
        component.set('v.preYearList',yearList);
    },
    
    clickFilter: function(component, event, helper) { 
        helper.removeError(component, event, helper);
        
        var selectedBonusType = component.find("bonusType").get("v.value");
        
        switch (selectedBonusType) {
            case 'dealerBonusStore':
                helper.getDealerBonus(component, event, helper,'A');
                break;
            case 'dealerBonus':
                helper.getDealerBonus(component, event, helper,'G');
                break;            
            case 'dealerBonusShipment':                
                helper.getDealerBonusShipment(component, event, helper);
                break;
        }
        console.debug(selectedBonusType);
    },
    
    closeModel: function(component, event, helper) {        
        component.set('v.showWarningDialog', false);
        
        helper.closeModel(component, event, helper);  
    },
    
    onSave: function(component, event, helper) {
        var type = 'G';
        var dataList = component.get('v.dataList');
        
        helper.updateDealerBonus(component, event, helper,dataList, type);        
        debugger;
        //helper.getDealerBonus(component, event, helper,type);//Tekrar datatable'da data listelensin diye
    },
    
    onSaveStore : function(component, event, helper) {
        var type = 'A';
        var dataListStore = component.get('v.dataListStore');
        
        helper.updateDealerBonus(component, event, helper,dataListStore, type);
        debugger;
        //helper.getDealerBonus(component, event, helper,type);//Tekrar datatable'da data listelensin diye
    },
    
    onSaveShipment: function(component, event, helper) {
        var type = 'shipmentBonus';
        var dataListShipment = component.get('v.dataListShipment');
        
        console.debug('draftValuesShipment : ' + JSON.stringify(dataListShipment));
        helper.updateDealerBonusShipment(component, event, helper,dataListShipment, type);
        debugger;
        //helper.getDealerBonusShipment(component, event, helper);//Tekrar datatable'da data listelensin diye
    },
    
    handleSelectedBonusType : function(component, event, helper){        
        
    },
    
    handleSelectedPeriodType : function(component, event, helper){
        
    },
    
    handleSelectedPreYear : function(component, event, helper){
        
    },
    
    handleDateFilterType : function(component, event, helper){
        
    },
    
    handleRowShipmentAction: function (component, event, helper) {
        var action = event.getParam('action');        
        
        switch (action.name) {
            case 'details':                              
                helper.openModel(component, event, helper,'details');
                break;            
        }
    }
})