({
    Init : function(component, event, helper)
    {
        
        helper.setBusy(component,true);
        
        var fields= [];
        fields.push('Name');
        fields.push('RC_SAP_ID__c');
        component.set('v.fields' , fields);
        console.log('fields:' + JSON.stringify(fields));
        var action = component.get("c.Initialize");
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                console.log('result: ' + JSON.stringify(result));
                component.set('v.initWrapper', result);
            }
            else
            {   
                console.log('Failed with state: ' + state + ' error : ' + error);
            }
            helper.setBusy(component,false);
        });
        $A.enqueueAction(action);  
        
        var actionApprovalStatusList = component.get("c.GetApprovalStatus");
        
        actionApprovalStatusList.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                console.log('result: ' + JSON.stringify(result));
                component.set("v.approvalStatusList", result);
                
            }
            else
            {   
                
                console.log('Failed with state: ' + state + ' error : ' + error);
            }
        });
        $A.enqueueAction(actionApprovalStatusList);
        
    },   
    filterHandleClick : function(component,event,helper)
    {
        helper.getConnections(component);
    },
    handleLookup : function(component,event,helper)
    {
        console.log('test');
        var selectedItem = event.getParam('data');
        component.set("v.selectedAccount",selectedItem.recordId);
        
    },
    changeApprovalType : function(component,event,helper)
    {
        var selectedVal = component.get("v.approvalData.selectedStatus");
        component.set("v.approvalStatusChanged" , false);
        
        var action = component.get("c.ChangeApprovalStatus");
        action.setParams({"selectedSt" : selectedVal , "approvalUserMap" : component.get("v.approvalData.statusUserMap")});
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                component.set("v.newApproverUser",result);
                helper.setBusy(component,false);
                
                if(result.UserName!='')// BM , SM ve GMY ise onaylayacak kullanıcı gözükür.
                    component.set("v.approvalStatusChanged" , true);
            }
            else{
                helper.setBusy(component,false);
                helper.showMessageToast('Onay statüsü değiştirilirken hata oluştu', 'error');
                
            }
        });
        $A.enqueueAction(action);
        
    },
    deleteConnModal : function(component,event,helper)
    {
        component.set("v.showDeleteConnModal",true);
        var connectionValue = event.getSource().get("v.value");
        var bordroNo  = connectionValue.split('-')[0];
        var accountNo = connectionValue.split('-')[1];
        var bordroId  = connectionValue.split('-')[2];
        var connId    = connectionValue.split('-')[3];
        component.set("v.selectedBordro" , bordroNo);
        component.set("v.selectedAccountNo" , accountNo);
        component.set("v.selectedBordroId"  , bordroId);
        component.set("v.selectedConnId"   ,  connId);
        
        
    },
    recordUpdateModal : function(component,event,helper)
    {
        var bordroId = event.getSource().get("v.value").split('-')[0];
        var connId   = event.getSource().get("v.value").split('-')[1];
        
        component.set('v.selectedConnId', connId);
        component.set('v.selectedPayrollForUpdate' , bordroId);
        console.log('bordroId:' + bordroId);
        var action = component.get("c.GetChequeData");
        action.setParams({"bordroNo" : bordroId})
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                console.log('result: ' + JSON.stringify(result));
                component.set('v.chequeData', result);
            }
            else
            {   
                console.log('Failed with state: ' + state + ' error : ' + error);
            }
        });
        $A.enqueueAction(action);  
        
        var actionPayrollInfo = component.get("c.GetPayrollTotalAmountAndAvg");
        actionPayrollInfo.setParams({"payrollId" : bordroId});
        actionPayrollInfo.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                console.log('result: ' + JSON.stringify(result));
                component.set('v.totalAmount', result.BAKIYE);
                component.set('v.avgMaturity', result.ORTVADE);
                
            }
            else
            {   
                console.log('Failed with state: ' + state + ' error : ' + error);
            }
        });
        $A.enqueueAction(actionPayrollInfo); 
        component.set("v.showRecordUpdateModal", true);
        
    },
    skipApprovalModal : function(component,event,helper)
    {
        helper.setBusy(component,true);
        var connId = event.getSource().get("v.value").split('-')[0];
        var accountId   = event.getSource().get("v.value").split('-')[1];
        component.set("v.selectedConnId",connId);
        
        var action = component.get("c.GetApprovalData");
        action.setParams({"connId" : connId , "accountId" : accountId});
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                console.log("approvalData:" + JSON.stringify(result));
                component.set("v.approvalData",result);
                component.set("v.showSkipApprovalModal",true);
                helper.setBusy(component,false);
            }
            else{
                helper.setBusy(component,false);
                helper.showMessageToast('Bağlantı Kaydı getirilirken hata oluştu', 'error');
                
            }
        });
        $A.enqueueAction(action);
        
    },
    hideDeleteConnModal : function(component,event,helper)
    {
        component.set("v.showDeleteConnModal",false);
        component.set("v.deleteDescription",null);
        
    },
    hideRecordUpdateModal : function(component,event,helper)
    {
        component.set("v.showRecordUpdateModal",false);
        component.set("v.updateMaturityDesc",null);
        
    },
    hideSkipApprovalModal : function(component,event,helper)
    {
        component.set("v.showSkipApprovalModal",false);
        component.set("v.approvalStatusChanged",false);
        component.set("v.approvalDesc",null);
        
        
    },
    calcAvgMaturity : function(component,event,helper)
    {
        var cheques = component.find('boxPack');
        console.log('++' + cheques);
        var delIds = [];
        for (var i = 0; i < cheques.length; i++) {
            if (cheques[i].get("v.value") == false) {
                console.log('t:' + cheques[i].get("v.value"));
                console.log('text:' + cheques[i].get("v.text"));
                
                delIds.push(cheques[i].get("v.text"));
            }
        }
        
        var action = component.get("c.CalculateAvgMaturity");
        action.setParams({"chequeNumbers" : delIds});
        
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                component.set('v.totalAmount', result.BAKIYE);
                component.set('v.avgMaturity', result.ORTVADE);                
            }
        });
        $A.enqueueAction(action);
        
    },
    saveUpdateMaturity : function(component,event,helper)
    {
        var cheques         = component.find('boxPack');
        var selectedPayroll = component.get("v.selectedPayrollForUpdate");
        var totalAmount     = component.get("v.totalAmount");
        var avgMaturity     = component.get("v.avgMaturity");
        var selectedConn    = component.get("v.selectedConnId");
        var desc    		= component.get("v.updateMaturityDesc");
        var chequesToBeDeleted = [];
        
        for (var i = 0; i < cheques.length; i++) {
            if (cheques[i].get("v.value") == true) {
                console.log('cheques:' + cheques[i].get("v.value"));
                chequesToBeDeleted.push(cheques[i].get("v.text"));
            }
        }
        console.log('chequest:' + chequesToBeDeleted);
        var action = component.get("c.UpdateConnection");
        action.setParams({"selectedPayroll" : selectedPayroll, "chequesToBeDeleted" : chequesToBeDeleted ,
                          "totalAmount" : totalAmount , "avgMaturity" : avgMaturity , "selectedConn" : selectedConn , "description" : desc});
        
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                if(result)
                {
                    helper.showMessageToast('Güncelleme işlemi başarı ile gerçekleştirildi', 'success');
                    component.set("v.updateMaturityDesc",null);
                    component.set("v.showRecordUpdateModal",false);
                    helper.getConnections(component);
                }
                else{
                    helper.showMessageToast('Güncelleme işlemi gerçekleştirilemedi', 'error');
                    
                }
            }
            else
            {
                helper.showMessageToast('Güncelleme işlemi gerçekleştirilemedi', 'error');
                
            }
        });
        $A.enqueueAction(action);
        
    },
    deletePayroll : function(component,event,helper)
    {
        helper.setBusy(component,true);
        
        var selectedBordro    = component.get("v.selectedBordroId");
        var selectedConnId    = component.get("v.selectedConnId");
        var deleteDescription = component.get("v.deleteDescription");
        var action = component.get("c.DeletePayroll");
        action.setParams({"bordroId" : selectedBordro , "connId" : selectedConnId , "description" : deleteDescription});
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                if(result)
                {
                    helper.showMessageToast('Silme işlemi gerçekleştirildi', 'success');
                    component.set("v.deleteDescription",null);
                    component.set("v.showDeleteConnModal",false);
                    helper.getConnections(component);
                }
                else{
                    helper.showMessageToast('Silme işlemi gerçekleştirilemedi', 'error');
                    
                }
            }
            else
            {   
                helper.showMessageToast('Silme işlemi gerçekleştirilemedi', 'error');
                
            }
            
            helper.setBusy(component,false);
            
        });
        $A.enqueueAction(action);  
        
    },
    saveApprovalChange: function(component,event,helper)
    {
        helper.setBusy(component,true);
        var selectedConn    = component.get("v.selectedConnId");
        var desc = component.get("v.approvalDesc");
        var newApprovalStatus = component.get("v.approvalData.selectedStatus");
        var approver = component.get("v.approvalData.approverUser.UserId");
        var action = component.get("c.SaveApprovalChange");
        
        action.setParams({"description" : desc , "newApprovalStatus" : newApprovalStatus , "connId" : selectedConn , "approver" : approver});
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();  
                if(result)
                {
                    helper.showMessageToast('Onay atlatma işlemi başarı ile gerçekleştirildi', 'success');
                    component.set("v.approvalDesc",null);
                    component.set("v.showSkipApprovalModal",false);
                    helper.getConnections(component);
                    helper.setBusy(component,false);
                    
                    
                }
                else
                {
                    helper.showMessageToast('Onay atlatma işlemi gerçekleştirilemedi', 'error');
                    helper.setBusy(component,false);
                    
                    
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})