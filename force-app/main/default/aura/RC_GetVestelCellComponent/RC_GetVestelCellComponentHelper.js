({
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },
    showMessageToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type,
            duration : 10
        });
        toastEvent.fire();
    },
    prepareData : function(component, event, helper){   
        helper.fileDownload(component, event, helper);
        helper.setBusy(component, false);
    },
    
})