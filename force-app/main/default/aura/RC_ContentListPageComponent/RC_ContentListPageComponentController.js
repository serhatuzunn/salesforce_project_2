({
    doInit : function(component, event, helper) {
        
        helper.setBusy(component,true);
        
        var getCommPath = component.get("c.GetCommunityPath");
        getCommPath.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            component.set("v.communityPath" , result);
            if(component.isValid() && response.getState() == "SUCCESS"){
                component.set("v.ContentAllItemLink", '/' + result + '/s' + component.get("v.Content1Link"));
                
            };
        });
        $A.enqueueAction(getCommPath);
        
        var action     = component.get("c.getContentsByTopic");
        action.setParams({"topicName": component.get("v.Content1")});
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
        var allLink = selectedItem.dataset.link;
        var Elements = component.find('div-content');
        var iconElements = component.find('icon-content');
        
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            
            if(val != id){
                $A.util.removeClass(Elements[i], "shadow-box-active");
                $A.util.removeClass(iconElements[i], "icon-active");
                $A.util.addClass(iconElements[i], "my-icon");
                
                
            } else {
                $A.util.addClass(Elements[i], "shadow-box-active");
                $A.util.addClass(iconElements[i], "icon-active");
                $A.util.removeClass(iconElements[i], "my-icon");
                
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
        
        var getCommPath = component.get("c.GetCommunityPath");
        getCommPath.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            console.log('res:' + result);
            console.log('name:' + allLink);
            if(component.isValid() && response.getState() == "SUCCESS"){
                component.set("v.ContentAllItemLink", '/' + result + '/s' + allLink);
                
            };
        });
        $A.enqueueAction(getCommPath);
        
        
    }
})