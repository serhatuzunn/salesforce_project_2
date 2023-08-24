({
  handLeClick : function (component, event, helper) {
        debugger;

      	
            var IT_CHECK_NO = component.find("IT_CHECK_NO_V2").get("v.value");
     		

            helper.setBusy(component,true);
            
            var action = component.get("c.handLeClick_v2");
            action.setParams({"CHECK_NO": IT_CHECK_NO});
            
            action.setCallback(this, function(response) { 
                
                console.log('response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                    component.set("v.VCellResponse", result); 
                    component.set("v.VCellSorgulama", false); 
                    component.set("v.VCellSorgulama", true); 
                   
                     if(result.USEDURUM == "2")
                    	component.set("v.VUseButton", true); 
                    
                }
                else{ 
                    component.set("v.VCellSorgulama", false); 
                     component.set("v.VCellSorgulama", false); 
                    component.set("v.VCellResponse", null); 
                     component.set("v.VUseButton", false); 
                    console.log('HATA response: ' + response);
                  
                }
                
                helper.setBusy(component,false);
            });
           
            $A.enqueueAction(action);

    },
    
  handLeVCellUseObjeClick : function (component, event, helper) {
        debugger;

 
            var IT_CHECK_NO_ENTRY = component.find("IT_CHECK_NO_V2").get("v.value");
			
            
         
             helper.setBusy(component,true);
            
            var action = component.get("c.VCellUseObjeClick");
            action.setParams({IT_CHECK_NO_ENTRY: IT_CHECK_NO_ENTRY});
            
            action.setCallback(this, function(response) { 
              
                console.log('response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                
                if(component.isValid() && response.getState() == "SUCCESS"){    
                   component.set("v.VCellSorgulama", false); 
                   component.set("v.VUseButton", false); 
                   var succesMessage = result.DURUM;
                   helper.showMessageToast(succesMessage,'Success');
                   
                }
                else{ 
				 console.log('HATA response: ' + response);
                } 
                helper.setBusy(component,false);
            });   
            $A.enqueueAction(action);
    },
    	
})