({
    doInit : function(component, event, helper) {
        
        helper.setBusy(component,true);

        var action     = component.get("c.getContentsByTopic");
        action.setParams({"topicName": "Kampanyalar"});
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
        
        
    },
    iconClick : function(component,event,helper)
    {
        
        var selectedItem = event.currentTarget;
        var id = selectedItem.dataset.id;
        var name = selectedItem.dataset.name;
        var Elements = component.find('div-content');
        var iconElements = component.find('icon-content');
        
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            
            if(val != id){
                $A.util.removeClass(Elements[i], "shadow-box-active");
                $A.util.removeClass(iconElements[i], "icon-active");
            } else {
                $A.util.addClass(Elements[i], "shadow-box-active");
                $A.util.addClass(iconElements[i], "icon-active");
            }
        }
        
        var action     = component.get("c.getContentsByTopic");
        
        action.setParams({"topicName": name});
        action.setCallback(this, function(response) {
            
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){
                component.set("v.contentData", result);
            };
        });
        $A.enqueueAction(action);
        
    }
})