({
    myAction : function(component, event, helper) {
        
    },
    
    init: function (component, event, helper) { 
        component.set('v.columnList', helper.getColumnDefinitions());
        component.set('v.hierarchyList', helper.fillHierarchy(component, event, helper));
        
        component.set('v.columnListSelected', helper.getColumnDefinitionsSelected());
        component.set('v.visibleProductTable',false);
        
    },
    
    handleSelectedHierarchy : function (component, event, helper) { 
        helper.removeError(component, event, helper);
        
        var selectedHierarchy = component.get("v.selectedHierarchy");
        if(selectedHierarchy == '' || selectedHierarchy =='0'){
            helper.addErrorMessage(component, event, helper,'Kademe 1 seçimi zorunludur.');
            return;            
        }
        helper.fillHierarchy2(component, event, helper, selectedHierarchy);
    },
    
    handleSelectedHierarchy2 : function (component, event, helper) { 
        helper.removeError(component, event, helper);
        
        var selectedHierarchy2 = component.get("v.selectedHierarchy2");
        if(selectedHierarchy2 == '' || selectedHierarchy2 =='0'){
            helper.removeError(component, event, helper,'Kademe 2 seçimi zorunludur.');
            return;
        }
        helper.fillHierarchy3(component, event, helper, selectedHierarchy2);
    },
    
    handleSelectedHierarchy3 : function (component, event, helper) { 
        
    },
    
    clickFilter : function(component, event, helper) {
        helper.removeError(component, event, helper);
        
        var selectedHierarchy  = component.get("v.selectedHierarchy");
        var selectedHierarchy2 = component.get("v.selectedHierarchy2");
        var selectedHierarchy3 = component.get("v.selectedHierarchy3");
        
        if(selectedHierarchy == '' || selectedHierarchy =='0'){
            helper.addErrorMessage(component, event, helper,'Kategori 1 seçimi zorunludur.');
            return;
        }
        else if(selectedHierarchy2 == '' || selectedHierarchy2 =='0'){
            helper.addErrorMessage(component, event, helper,'Kategori 2 seçimi zorunludur.');
            return;
        }
        helper.getProductBarcode(component, event, helper);
    },
    
    clickAdd : function(component, event, helper) {        
        helper.setBusy(component,true);
        
        let lines = [];
        lines = component.find('linesTable').getSelectedRows();
        console.log('selectedRows: '+  JSON.stringify(lines));
        
        if(lines.length==0){
            helper.addErrorMessage(component,event,helper,"Lütfen en az 1 satır seçiniz!");
        }
        
        var myData = component.get("v.dataListSelected");        
        for(var i=0; i<lines.length; i++) {
            myData.push({
                ProductCode: lines[i]['ProductCode'],
                Name: lines[i]['Name']
            });
        }  
        helper.setBusy(component,false);
        component.set("v.dataListSelected",myData);  
        component.set("v.pdfButtonVisible", true);
    },
    
    clickAllClear : function(component, event, helper) {
        component.set('v.dataListSelected', []);
        component.set("v.pdfButtonVisible", false);

    },
    
    clickPDF : function(component, event, helper) {       
        helper.createPDF(component, event, helper,'false');        
    },
    
    clickPDFEan : function(component, event, helper) {       
        helper.createPDF(component, event, helper,'true');        
    },
    
    onRowSelection : function(component, event, helper) {
    },
    
    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                helper.deleteRow(component, row);
                break;            
        }
    },
})