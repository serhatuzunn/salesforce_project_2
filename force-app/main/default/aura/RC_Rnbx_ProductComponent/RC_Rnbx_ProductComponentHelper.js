({
	setBusy : function(component, state){
        component.set("v.loading", state); 
    },
     showMessageToast : function(message, type) {
        console.log('toast');
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                title: "",
                message: message,
                type: type
            });
            toastEvent.fire();
        }
    },
})