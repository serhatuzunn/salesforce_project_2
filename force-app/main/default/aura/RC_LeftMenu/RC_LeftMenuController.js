({
   onClick : function(component, event, helper) {
       var id = event.target.dataset.menuItemId;
       if (id) {
           console.log("event : " + JSON.stringify(event.target.dataset.menu));
           component.getSuper().navigate(id);
        }
  },
	Init : function(component, event, helper) {
    var recordId = component.get("v.recordId");
	var action = component.get("c.initialize");
        
	action.setParams({"recordId": recordId});
        
	action.setCallback(this, function(response) { 
	console.log(response.getReturnValue());
	console.log(response.getError());
	var result = response.getReturnValue();
	var error = response.getError();
	if(component.isValid() && response.getState() == "SUCCESS")
		{  
			component.set("v.userName", result);
		}    
	});
	$A.enqueueAction(action);
    }
})