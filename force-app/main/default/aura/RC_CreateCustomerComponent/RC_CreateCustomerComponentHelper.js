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
    }
})