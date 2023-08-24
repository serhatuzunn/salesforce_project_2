({
    doInit : function(component, event, helper) {
        
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        var sParameterName = sURLVariables[0].split('=');
        component.set("v.contentId", sParameterName[1]);

        var sParameterName2 = sURLVariables[1].split('=');
        var topicName = sParameterName2[1];
        helper.setBusy(component,true);
        
        var action     = component.get("c.getContentDetailById");
        action.setParams({"contentId": component.get("v.contentId")});
        action.setCallback(this, function(response) {
            
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){
                component.set("v.contentData", result);
                console.log('result: ' + JSON.stringify(result));
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