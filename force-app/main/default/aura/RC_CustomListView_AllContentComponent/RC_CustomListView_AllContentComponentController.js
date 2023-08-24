({
    doInit : function(component, event, helper) {
        
        helper.setBusy(component,true);
        
        var topicName    = component.get("v.ContentTitle");
        
        var action     = component.get("c.getContentsByTopic");
        action.setParams({"topicName": topicName});
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
        
        var actionResource     = component.get("c.GetResourceURL");
        actionResource.setParams({"resourceName": topicName});
        actionResource.setCallback(this, function(response) {
            
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){
                component.set("v.defaultImage", result);
            };
            helper.setBusy(component,false);
        });
        $A.enqueueAction(actionResource);
    }
})