({
    doInit : function(component, event, helper) {
        
        helper.setBusy(component,true);
        
        var action = component.get("c.getBanners");
        action.setCallback(this, function(response) {
            
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){
            		component.set("v.contentData", result);
            };
             helper.setBusy(component,false);
        });
        $A.enqueueAction(action);
    }
})