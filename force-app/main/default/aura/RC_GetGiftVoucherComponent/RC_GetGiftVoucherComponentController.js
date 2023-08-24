({
	
  handLeInquireClick : function (component, event, helper) {
        debugger;

            var IT_CHECK_NO = component.find("IT_CHECK_NO").get("v.value");

            helper.setBusy(component,true);
            
            var action = component.get("c.InquireClick");
            action.setParams({CHECK_NO: IT_CHECK_NO});
            
            action.setCallback(this, function(response) { 
                
                console.log('response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                   
                    component.set("v.cekSorgulama", true);
                    component.set("v.CheckResponse", result); 
                    
                    if(result.ES_CEK_S.DURUM == "" || result.ES_CEK_S.DURUM == "1")
                           component.set("v.cekSorguKullan", true);	
           
                }
                else{ 
                    component.set("v.cekSorgulama", false);
                    component.set("v.CheckResponse", null); 
                    console.log('HATA response: ' + response);
                  
                }
                
                helper.setBusy(component,false);
            });
           
            $A.enqueueAction(action);

    },
    	
  
  handLeCheckUseObjeClick : function (component, event, helper) {
        debugger;

            var IT_CHECK_NO_ENTRY = component.find("IT_CHECK_NO").get("v.value");

             helper.setBusy(component,true);
            
            var action = component.get("c.VGetGiftUseClick");
            action.setParams({IT_CHECK_NO_ENTRY: IT_CHECK_NO_ENTRY});
            
            action.setCallback(this, function(response) { 
              
                console.log('response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                
                if(component.isValid() && response.getState() == "SUCCESS"){    
                    component.set("v.cekKullan", true);
                    component.set("v.cekSorguKullan", false);	
                    var succesMessage = result.DURUM;
                    helper.showMessageToast(succesMessage,'Success');
                }
                else{ 
                    component.set("v.cekKullan", false);
                  
                    console.log('HATA response: ' + response);
                } 
                helper.setBusy(component,false);
            });   
            $A.enqueueAction(action);
    }
})