({
    
      setHandLeClick : function (component, event, helper) {
        debugger;

      	
        var IT_DOCUMENT_DATE = component.find("IT_DOCUMENT_DATE").get("v.value");
        var IT_MATBU_NO = component.find("IT_MATBU_NO").get("v.value");
        var recordId = component.get("v.recordId");
        
            helper.setBusy(component,true);
            
         
        var action = component.get("c.VCellUseSetObjeClick");
        action.setParams({recordId: recordId,IT_DOCUMENT_DATE: IT_DOCUMENT_DATE,IT_MATBU_NO:IT_MATBU_NO});
            
            action.setCallback(this, function(response) { 
                
                console.log('response son yer: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                console.log("durum : " + response.getState());
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                    
                 
                        var succesMessage = result.DURUM;
                        helper.showMessageToast(succesMessage,'Success');	
                 		window.location.reload();
                        
                }
                else{ 
                    console.log('HATA response: ' + response);
                  
                }
                
                helper.setBusy(component,false);
            });
           
            $A.enqueueAction(action);
       
 
    },
    
})