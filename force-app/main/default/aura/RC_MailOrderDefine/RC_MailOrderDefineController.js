({
    myAction : function(component, event, helper) {
        
    },
    
    init: function (cmp, event, helper) {
        cmp.set('v.columns', helper.getColumnDefinitions());
        cmp.set('v.columnsOrderDetail', helper.getColumnDefinitionsOrderDetail('details'));
        cmp.set('v.assecoPaymentLink',helper.getAssecoPaymentLink(cmp, event, helper));
        
        var sURL = location.href;         
        var isAsseco = sURL.split('c__isAsseco=')[1];
        
        if(isAsseco==='true' || isAsseco==='True'){
            helper.toastMsg('success','Ödeme mail linki gönderilmiştir. Lütfen ilgili mail adresini kontrol ediniz');
            return;
        }
    },
    
    clickFilter: function(component, event, helper) { 
        
        var accountName = (component.get("v.selectedAccount")).Name;
        console.log("accountName : " + accountName);
        
        if(!accountName|| accountName.length === 0 || accountName=='undefined'){
            helper.showMessage(component, "error","Lütfen hesap seçiniz!");
        }else{
            helper.clickFilter(component, event, helper);      
        }
        
    },
    
    handleSelectedPaymentType : function(component, event, helper){        
        
    },
    
    handlecellchange: function (component, event, helper) {
        helper.setBusy(component,true);
        var draftValues = event.getParam('draftValues');         
        
        var parsedDraftValue = JSON.parse(JSON.stringify(draftValues));
        console.log("parsedDraftValue :" + JSON.stringify(parsedDraftValue));
        var updatedQuantity = parseInt(parsedDraftValue[0].PURCHQUA);
        var rowNumber =  parsedDraftValue[0].POSNR;
        
        var deliveryNo = component.get('v.deliveryNo');
        
        var orderList = component.get('v.customerOrderList');
        var objOrderList = JSON.parse(JSON.stringify(orderList)); 
        var orderDetailList = objOrderList.oDetail.item.filter(c => c.VBELN === deliveryNo);
        
        var updatedRow = orderDetailList.find(x => x.POSNR === rowNumber);
        console.log("updatedQuantity :" + JSON.stringify(updatedQuantity));
        
        if(parseInt(updatedRow.KWMENG) < updatedQuantity){
            updatedQuantity = updatedRow.KWMENG;
            console.log("updatedQuantity :" + JSON.stringify(updatedQuantity));
            helper.toastMsg("error","Alınacak adet Sipariş Miktarından büyük olamaz!");            
        }
        else{
            if(parseInt(updatedRow.KWMENG) != updatedQuantity){
                updatedRow.PURCHQUA = updatedQuantity;
                updatedRow.NETWR = (( parseFloat(updatedRow.NETWR) / parseInt(updatedRow.KWMENG) ) * parseInt(updatedQuantity)).toFixed(3);
                console.log("updatedRow.NETWR :" + JSON.stringify(updatedRow));
            }
            
            const index = objOrderList.oDetail.item.findIndex(p => p.VBELN === deliveryNo && p.POSNR === rowNumber);
            objOrderList.oDetail.item[index].PURCHQUA = updatedQuantity;
            
            debugger;
            var tempList = component.get("v.tempCustomerOrderList");
            if(tempList == null || tempList ==='undefined'){
                tempList = [];
            }
            
            
            for(var i = 0; i < tempList.length; i++) {
                if (JSON.parse(tempList[i]).POSNR == updatedRow.POSNR) {
                    tempList.splice(i, 1);
                    break;
                }
            }
            
            tempList.push(JSON.stringify(objOrderList.oDetail.item[index]));
            /*var oldPrice = parseFloat(updatedRow.NETWR);
            var oldQuantitiy = parseFloat(updatedRow.KWMENG);
            var unitPrice = (oldPrice / oldQuantitiy);
            
            console.log("unitPrice :" + unitPrice);
            
            var newPrice = unitPrice * updatedQuantity;            
            const index = objOrderList.oDetail.item.findIndex(p => p.VBELN === deliveryNo && p.POSNR === rowNumber);
			objOrderList.oDetail.item[index].NETWR = newPrice.toString();
            objOrderList.oDetail.item[index].KWMENG = updatedQuantity;
            objOrderList.oDetail.item[index].PURCHQUA = updatedQuantity;
            
            const indexHeader = objOrderList.oHeader.item.findIndex(p => p.VBELN === deliveryNo);
            objOrderList.oHeader.item[indexHeader].NETWR = updatedQuantity;
            debugger;
            
            let sum = 0;
            var cnt = objOrderList.oDetail.item.filter(p => p.VBELN === deliveryNo).length;
            for (let i = 0; i < cnt; i++) {
                sum = sum + parseFloat(objOrderList.oDetail.item[i].NETWR);
            }
            
			component.set('v.customerOrderList',objOrderList);*/
            console.log("tempList :" + tempList);
            console.log("unitPrice :" + JSON.stringify(objOrderList));
            
            component.set("v.tempCustomerOrderList",tempList);            
            console.log("tempCustomerOrderList :" + JSON.stringify(component.get("v.tempCustomerOrderList")));
        }
        helper.setBusy(component,false);
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');        
        
        switch (action.name) {
            case 'details':                              
                helper.openModel(component, event, helper,'details');
                break;
            case 'partial_payment':                
                helper.openModel(component, event, helper,'partial_payment');
                break;
            case 'do_payment':
                helper.openModel(component, event, helper,'do_payment');
                break;
        }
    },
    
    openModel : function(component, event, helper) {
        helper.openModel(component, event, helper,'details');      
    },
    
    closeModel: function(component, event, helper) {
        component.set('v.deliveryNo', '');
        component.set('v.totalAmount', '0.00');
        component.set('v.showWarningDialog', false);
        
        var deliveryNo = component.get('v.deliveryNo');
        var totalAmount = component.get('v.totalAmount');
        
        console.log('deliveryNo'+deliveryNo);
        console.log('totalAmount'+totalAmount);
        
        helper.closeModel(component, event, helper);  
    },
    
    submitDetails: function(component, event, helper) {
        helper.submitDetails(component, event, helper);  
    },
    
    handleConfirmDialogYes : function(component, event, helper) {
        helper.setBusy(component,true);
        
        var deliveryNo = component.get('v.deliveryNo');
        var totalAmount =component.get('v.totalAmount');
        var emailAdress =component.get('v.emailAdress');
        var accountId =component.get('v.accountId');
        
        var site =  window.location.pathname;
        var returnUrl = window.location.href;
        /*.indexOf('c__isAsseco') > -1
        ?  window.location.href : window.location.href+'?c__isAsseco=true';*/
        
        var action = component.get('c.GetRequestParameters');
        action.setParams({ 
            			  "accountId" : accountId,
            			  "site"  : site,
                          "returnUrl"  : returnUrl,
                          "orderNo"  : deliveryNo,
                          "amount"  : totalAmount,
                          "email"  : emailAdress
                         });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var error = response.getError();
            
            console.log('response.getState() :  '+ JSON.stringify(response.getState()));
            if(component.isValid() && response.getState() == "SUCCESS"){
                component.set('v.showWarningDialog', false);
                
                const formElement = component.find("assecoForm").getElement();
                for (var key in result) 
                {
                    let inputElement = document.createElement('input');
                    inputElement.name = key;
                    inputElement.value = result[key];
                    formElement.appendChild(inputElement);
                } 
                //set form variable using output variables from flow
                component.find("assecoForm").getElement().submit();
                
                helper.setBusy(component,false);
            }else{
                helper.toastMsg("error","Asseco ile bağlantı kurulurken hata oluştu.");
            }
            
        });
        
        $A.enqueueAction(action);
        
        
        helper.setBusy(component,false);
    },
    
    handleConfirmDialogNo : function(component, event, helper) {        
        component.set('v.deliveryNo', '');
        component.set('v.totalAmount', '0.00');
        component.set('v.showWarningDialog', false);
        
        var deliveryNo = component.get('v.deliveryNo');
        var totalAmount = component.get('v.totalAmount');
        
        console.log('deliveryNo'+deliveryNo);
        console.log('totalAmount'+totalAmount);
    },
    
    changeAccount : function(component, event, helper) {         
        console.log("change quote account");
        
        var accValue = component.get("v.selectedAccount").Name;
        var email = (component.get("v.selectedAccount")).RC_Email__c;
        var accountId = (component.get("v.selectedAccount")).Id;
        console.log("accountId :" + accountId);
        if ((!accValue || accValue.length === 0)){
            component.set("v.emailAdress", null);
            component.set("v.accountId", null);
        }
        /*  component.set("v.acc", false);
        }
        else{            
            if (!email || email.length === 0){
                component.set("v.acc", false);
            }
            else component.set("v.acc", true);
            }*/
        component.set("v.emailAdress", email);
        component.set("v.accountId", accountId);
        
    }
    
})