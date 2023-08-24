({
    Init : function(component, event, helper) {
        
        helper.setBusy(component,true);
        
        var action = component.get("c.initialize");
        action.setCallback(this, function(response) { 
            
            //console.log('response: ' + JSON.stringify(response.getReturnValue()));
            //console.log('response: ' + response.getError());
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                component.set('v.initWrapper', result);
                
                //console.log('result : ' + JSON.stringify(result));
                
                var hiy1options = [];
                result.definitionHierarcy1List.forEach(function(result)  {
                    hiy1options.push({ value: result.RC_Value__c, label: result.Name, upperHiy: result.RC_Upper_Hierarchy__c});
                });
                component.set("v.listdefinitionHierarcy1", hiy1options);
            }
            else {
                
                console.log('Failed with state: ' + state + ' error : ' + error);
            }
            helper.setBusy(component,false);
        });
        $A.enqueueAction(action);   
        
    },
    selectedHierarchy1Drp : function(component, event, helper){
        
        component.find("drpHierarchy2").set('v.value', []);
        component.find("drpHierarchy3").set('v.value', []);
        component.set("v.listdefinitionHierarcy2", null);
        component.set("v.listdefinitionHierarcy3", null);
        var selectedHiy1Level = component.find("drpHierarchy1").get("v.value");
        
        var allHiy2options = [];
        component.get('v.initWrapper').definitionHierarcy2List.forEach(function(result)  {
            allHiy2options.push({ value: result.RC_Value__c, label: result.Name, upperHiy: result.RC_Upper_Hierarchy__c});
        });
        
        var selectedHiy2List = allHiy2options.filter(function(value){
            return value.upperHiy == selectedHiy1Level;
        });
        
        component.set("v.listdefinitionHierarcy2", selectedHiy2List);     
        //console.log('selectedHiy2List : ' + selectedHiy2List);
    },
    selectedHierarchy2Drp : function(component, event, helper){
        
        component.find("drpHierarchy3").set('v.value', []);
        component.set("v.listdefinitionHierarcy3", null);
        
        var selectedHiy2Level = component.find("drpHierarchy2").get("v.value");
        
        var allHiy3options = [];
        component.get('v.initWrapper').definitionHierarcy3List.forEach(function(result)  {
            allHiy3options.push({ value: result.RC_Value__c, label: result.Name, upperHiy: result.RC_Upper_Hierarchy__c});
        });
        
        var selectedHiy3List = allHiy3options.filter(function(value){
            return value.upperHiy == selectedHiy2Level;
        });
        
        component.set("v.listdefinitionHierarcy3", selectedHiy3List);     
        console.log('selectedHiy3List : ' + selectedHiy3List);
    },
    filtreHandleClick : function(component, event, helper){
        var hiy1 = component.find("drpHierarchy1").get("v.value");
        var hiy2 = component.find("drpHierarchy2").get("v.value");
        var hiy3 = component.find("drpHierarchy3").get("v.value");
        
        if(hiy1 == "" || hiy2 == "" || hiy3 == ""){
            helper.showMessageToast("Tüm hiyerarşi alanları seçilmelidir.", "warning")
        }
        else{
            let hiyObject = {"hiy1":hiy1, "hiy2":hiy2, "hiy3":hiy3};
            
            helper.setBusy(component,true);
            
            var action = component.get("c.GetProducts");
            action.setParams(
                {'hiyObjectJson': JSON.stringify(hiyObject) });
            
            
            action.setCallback(this, function(response) { 
                //console.log('response: ' + JSON.stringify(response.getReturnValue()));
                //console.log('response: ' + JSON.stringify(response.getError()));
                
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                    var result = response.getReturnValue();
                    //console.log('result : ' + JSON.stringify(result));
                    
                    if(result == null || result.ProductList == null || result.ProductList == undefined || result.ProductList[0] == null){
                        var warningStockMessage = $A.get("Ürün bulunamadı");
                        helper.showMessageToast(warningStockMessage,'Warning');
                        component.set('v.FilterProductResponse', null);
                    }
                    else{
                        var totalSize = result.ProductList.length;
                        component.set('v.pageCount', Math.ceil(totalSize/24));   //24 -> her bir page'de kaç item gösterileceği
                        component.set('v.selectedPage', 1); 
                        var filterResult = JSON.parse(JSON.stringify(result));
                        filterResult.ProductList = result.ProductList.slice(0, 24);
                        
                        if(filterResult.ProductList.length == 0){
                            var warningNoStock = $A.get("$Label.c.No_Stock_Warning");
                            helper.showMessageToast(warningNoStock,'Warning');
                        }
                        
                        component.set('v.FilterProductResponse', filterResult);   //1.page'dekiler yüklenir. (result  ilk 24 kayıt)
                    }
                    
                    component.set("v.AllProductResponse", result); 
                    
                }
                else {
                    var error = response.getError();
                    console.log('Failed with state: ' + state + ' error : ' + error);
                }
                helper.setBusy(component,false);
            });
            $A.enqueueAction(action);   
        }
        
        
        
    },
    previousClick : function(component, event, helper){
        var selectedPage = component.get("v.selectedPage");
        var allResult = component.get('v.AllProductResponse');
        
        if(selectedPage != 1){
            selectedPage -= 1;
            component.set("v.selectedPage", selectedPage);
            
            var filterResult = JSON.parse(JSON.stringify(allResult));
            filterResult.ProductList = allResult.ProductList.slice(((selectedPage-1) * 24), (selectedPage * 24));
            
            component.set('v.FilterProductResponse', filterResult);
        }
    },
    
    nextClick : function(component, event, helper){
        var pageCount = component.get("v.pageCount");       
        var selectedPage = component.get("v.selectedPage");
        var allResult = component.get('v.AllProductResponse')
        
        if(selectedPage != pageCount){
            selectedPage += 1;
            component.set("v.selectedPage", selectedPage);
            
            var filterResult = JSON.parse(JSON.stringify(allResult));
            filterResult.ProductList = allResult.ProductList.slice(((selectedPage-1) * 24), (selectedPage * 24));
            
            component.set('v.FilterProductResponse', filterResult);
        }
    },
    
    inceleClick : function(component, event, helper){
        var msg = event.getSource().get('v.value');
        console.log(msg);
        debugger;
        
        var action = component.get("c.GetShareUrl");
        action.setParams({'externalSystemProductId': msg});
        
        action.setCallback(this, function(response) { 
            if(response.getReturnValue() == null){
                helper.showMessageToast('Ürüne ait vestel.com.tr de tanımlı ürün sayfası bulunamadı.','Error');
            }
            else{
                window.open(response.getReturnValue(), "_blank");
            }
        });
        $A.enqueueAction(action);   
        
        
    }
})