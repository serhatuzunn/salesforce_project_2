({
    
    scriptsLoaded : function(component, event, helper) {
        $(".select2Class.VKORGCss").select2({
            tags: true
        }); 
        $(".select2Class.VTWEGCss").select2({
            tags: true
        });
        $(".select2Class.VKBURCss").select2({
            tags: true
        });
         $(".select2Class.VKGRPCss").select2({
            tags: true
        });
    },
    
    
    Init : function(component, event, helper) {
        
        helper.setBusy(component,true);
        
        var action = component.get("c.getProductionPlace");
        action.setCallback(this, function(response) { 
           
            console.log('response: ' + JSON.stringify(response.getReturnValue()));
            console.log('response: ' + response.getError());

            if(component.isValid() && response.getState() == "SUCCESS"){ 
                 var result = response.getReturnValue();
                 var options = [];
                  result.forEach(function(result)  {
                       
                        options.push({ value: result.RC_Value__c, label: result.Name});
                   });
                  component.set("v.listOptions", options);               
            }
             else {
                  var error = response.getError();
                 console.log('Failed with state: ' + state + ' error : ' + error);
            }
            helper.setBusy(component,false);
        });
        $A.enqueueAction(action);   
    },
    
    Init2 : function(component, event, helper) {
        
        helper.setBusy(component,true);
        
        var action2 = component.get("c.initialize");
       
        action2.setCallback(this, function(response) { 
            
                
            var result = response.getReturnValue();
            var error = response.getError();
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                
                if(result.InitWrapper!=null)
                {
                     component.set('v.GetInitResponse', result);
                }
               
            }
            
            helper.setBusy(component,false);
        });
        
        $A.enqueueAction(action2);   
    },  
    
    handleClick : function (component, event, helper) {
        debugger;
        var IT_WERKS = component.get("v.selectedOptions");
        var IT_MATNR = component.find("IT_MATNR").get("v.value");
        var IV_KUNNR = component.find("IV_KUNNR").get("v.value");
		var TahditsizAltToplam = 0;
        
        
            helper.setBusy(component,true);
            
            var action = component.get("c.buttonClick");
            
            action.setParams({IT_MATNR: IT_MATNR, IV_KUNNR : IV_KUNNR, IT_WERKS : IT_WERKS});
            
            action.setCallback(this, function(response) { 
                console.log('response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                
                console.log('state : ' + response.getState());
                component.set('v.TahditsizAltToplam', 0); 
                
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                    component.set('v.AllStockResponse', result);
                    
                     component.set("v.emanetStatu", true);
                    component.set("v.acikSiparisStatu", false);
                    
                    if(result.StockResponseModel.StockItemList[0].MATNR == ''){
                        var warningStockMessage = $A.get("$Label.c.Stock_Information_Not_Found");
                        helper.showMessageToast(warningStockMessage,'Warning');
                        component.set('v.FilterStockResponse', null);
                        component.set('v.AllOpenStockResponse', null);
                    }
                    else{
                        var totalSize = result.StockResponseModel.StockItemList.length;
                        component.set('v.pageCount', Math.ceil(totalSize/25));   //15 -> her bir page'de kaç item gösterileceği
                        component.set('v.selectedPage', 1); 
                        
                        var filterResult = JSON.parse(JSON.stringify(response.getReturnValue()));
                        filterResult.StockResponseModel.StockItemList = result.StockResponseModel.StockItemList.slice(0, 25);
                        
                        if(filterResult.StockResponseModel.StockItemList.length == 0){
                            var warningNoStock = $A.get("$Label.c.No_Stock_Warning");
                            helper.showMessageToast(warningNoStock,'Warning');
                        }
                        
                       
                        for(var i = 0; i < totalSize; i++){
                        	TahditsizAltToplam = parseInt(component.get('v.TahditsizAltToplam')) + parseInt(result.StockResponseModel.StockItemList[i].KULAB);
                          	component.set('v.TahditsizAltToplam', TahditsizAltToplam); 
                        }

                        
                            
                        component.set('v.FilterStockResponse', filterResult);   //1.page'dekiler yüklenir. (result  ilk 5 kayıt)
                        
                        console.log('result list : ' + JSON.stringify(component.get('v.AllStockResponse')));
                        console.log('filter list: ' + JSON.stringify(component.get('v.FilterStockResponse')));
                    }
                    
                    
                }
                else{ 
                    console.log('HATA response: ' + response);
                    component.set('v.GetStockResponse', null);
                }
                
                helper.setBusy(component,false);
            });
            
            $A.enqueueAction(action);
        
        
    },
    
    openHandleClick : function (component, event, helper) {


         debugger;
        
        var IT_WERKS = component.get("v.selectedOptions"); 
        var IT_MATNR = component.find("IT_MATNR").get("v.value");
        var IV_KUNNR = component.find("IV_KUNNR").get("v.value");
        
        
        var IV_VKORG = $(".select2Class.VKORGCss").select2("val");
        var IV_VTWEG = $(".select2Class.VTWEGCss").select2("val");
        var IV_VKBUR = $(".select2Class.VKBURCss").select2("val");
        var IV_VKGRP = $(".select2Class.VKGRPCss").select2("val");
        

         
          helper.setBusy(component,true);
         
   		var action = component.get("c.OpenStockButtonClick");
        
        
                 
         var KZWI2AltToplam= 0;
         var FARKAltToplam = 0;
         var RFMNGAltToplam = 0;
         var KLMENGAltToplam = 0;
         
         component.set('v.KZWI2AltToplam', KZWI2AltToplam);      
         component.set('v.FARKAltToplam', FARKAltToplam);   
         component.set('v.RFMNGAltToplam', RFMNGAltToplam);   
         component.set('v.KLMENGAltToplam', KLMENGAltToplam);   
        
         action.setParams({IT_MATNR: IT_MATNR, IV_KUNNR : IV_KUNNR, IV_VSTEL : IT_WERKS[0],IV_VKBUR :IV_VKBUR ,IV_VKGRP :IV_VKGRP,IV_VKORG :IV_VKORG,IV_VTWEG:IV_VTWEG});
            	    
         action.setCallback(this, function(response) { 
                console.log('all open response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                var error = response.getError();
               
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                    
                      if(result.OpenStockResponseModel.OpenStockItemList[0].MATNR == ''){
                        var warningStockMessage = $A.get("$Label.c.Stock_Information_Not_Found");
                        helper.showMessageToast(warningStockMessage,'Warning');
                        component.set('v.AllOpenStockResponse', null);
                        component.set('v.FilterStockResponse', null);
                    }
                    else{
                        
                        var totalSize = result.OpenStockResponseModel.OpenStockItemList.length;
                        component.set('v.pageCount', Math.ceil(totalSize/50));   //15 -> her bir page'de kaç item gösterileceği
                        component.set('v.selectedPage', 1); 
                      
                        var filterResult = JSON.parse(JSON.stringify(response.getReturnValue()));
                        filterResult.OpenStockResponseModel.OpenStockItemList = result.OpenStockResponseModel.OpenStockItemList.slice(0, 25);
                      
                        
                          for(var i = 0; i < totalSize; i++){
                              
                          	  KZWI2AltToplam = parseFloat(component.get('v.KZWI2AltToplam')) + parseFloat(result.OpenStockResponseModel.OpenStockItemList[i].KZWI2);
                              KLMENGAltToplam = parseInt(component.get('v.KLMENGAltToplam')) + parseInt(result.OpenStockResponseModel.OpenStockItemList[i].KLMENG);
                              RFMNGAltToplam = parseInt(component.get('v.RFMNGAltToplam')) + parseInt(result.OpenStockResponseModel.OpenStockItemList[i].RFMNG);
                              FARKAltToplam = parseInt(component.get('v.FARKAltToplam')) + parseInt(result.OpenStockResponseModel.OpenStockItemList[i].FARK);
           		    		  
                              component.set('v.KZWI2AltToplam', KZWI2AltToplam);   
                              component.set('v.KLMENGAltToplam', KLMENGAltToplam);
                              component.set('v.RFMNGAltToplam', RFMNGAltToplam);
                              component.set('v.FARKAltToplam', FARKAltToplam);
                          }

                       component.set('v.AllOpenStockResponse', result);
                       component.set('v.FilterAllOpenStockResponse', result); 
                        
                    
                    
                       component.set("v.emanetStatu", false);
                   	   component.set("v.acikSiparisStatu", true);
                    }


                }
                else
                {
                  console.log('HATA response: ' + response);  
                }
               helper.setBusy(component,false);   
         })
	
         $A.enqueueAction(action);  
        
    },
    
    
   filtreHandleClick : function (component, event, helper) {    
         
         debugger;
         
        var IVF_KUNNR = component.find("IVF_KUNNR").get("v.value");
        var IVF_MATNR = component.find("IVF_MATNR").get("v.value");
        var IVF_MAKTX = component.find("IVF_MAKTX").get("v.value");
         
        var allFilterResult = component.get('v.AllStockResponse');
        
    
        var options = [];
         
         var TahditsizAltToplam = 0;
         
         component.set('v.TahditsizAltToplam', TahditsizAltToplam);               

         
     
        for(var i = 0; i < allFilterResult.StockResponseModel.StockItemList.length; i++)
        {
            helper.setBusy(component,true);
            
            if (
                (allFilterResult.StockResponseModel.StockItemList[i].KUNNR.indexOf(IVF_KUNNR) != -1 || IVF_KUNNR == null)   && 
                (allFilterResult.StockResponseModel.StockItemList[i].MATNR.indexOf(IVF_MATNR)  != -1 || IVF_MATNR == null) && 
                (allFilterResult.StockResponseModel.StockItemList[i].MAKTX.toLowerCase().indexOf(IVF_MAKTX.toLowerCase()) != -1 || IVF_MAKTX == ''))
            {
              
                options.push(allFilterResult.StockResponseModel.StockItemList[i]); 
                
            	TahditsizAltToplam = parseInt(component.get('v.TahditsizAltToplam')) + parseInt(allFilterResult.StockResponseModel.StockItemList[i].KULAB);
              	component.set('v.TahditsizAltToplam', TahditsizAltToplam);   			 }
            

            
           
        }
         
         var totalSizeFiltre = options.length;
         component.set('v.pageCount', Math.ceil(totalSizeFiltre/25));   //25 -> her bir page'de kaç item gösterileceği
         component.set('v.selectedPage', 1); 
         helper.setBusy(component,false);
        
         component.set("v.FilterStockResponse.StockResponseModel.StockItemList",options);  
               
    },
    
   openfiltreHandleClick : function (component, event, helper) {    
         
      //   debugger;
         
        var IVO_KUNNR = component.find("IVO_KUNNR").get("v.value");
        var IVO_MATNR = component.find("IVO_MATNR").get("v.value");
        var IVO_VBELN = component.find("IVO_VBELN").get("v.value");
         

       var allFilterResult = component.get('v.AllOpenStockResponse');
           

        var options = [];
         
          var KZWI2AltToplam= 0;
         var FARKAltToplam = 0;
         var RFMNGAltToplam = 0;
         var KLMENGAltToplam = 0;
         
         component.set('v.KZWI2AltToplam', KZWI2AltToplam);      
         component.set('v.FARKAltToplam', FARKAltToplam);   
         component.set('v.RFMNGAltToplam', RFMNGAltToplam);   
         component.set('v.KLMENGAltToplam', KLMENGAltToplam);   
      
        for(var i = 0; i < allFilterResult.OpenStockResponseModel.OpenStockItemList.length; i++)
        {
            helper.setBusy(component,true);
            
            if (
                (allFilterResult.OpenStockResponseModel.OpenStockItemList[i].KUNNR.indexOf(IVO_KUNNR) != -1 || IVO_KUNNR == null)   && 
                (allFilterResult.OpenStockResponseModel.OpenStockItemList[i].MATNR.indexOf(IVO_MATNR) != -1 || IVO_MATNR == null) && 
                (allFilterResult.OpenStockResponseModel.OpenStockItemList[i].VBELN.indexOf(IVO_VBELN) != -1 || IVO_VBELN == null))
            {
              
                options.push(allFilterResult.OpenStockResponseModel.OpenStockItemList[i]); 
                
             
                          	  KZWI2AltToplam = parseFloat(component.get('v.KZWI2AltToplam')) + parseFloat(allFilterResult.OpenStockResponseModel.OpenStockItemList[i].KZWI2);
                              KLMENGAltToplam = parseInt(component.get('v.KLMENGAltToplam')) + parseInt(allFilterResult.OpenStockResponseModel.OpenStockItemList[i].KLMENG);
                              RFMNGAltToplam = parseInt(component.get('v.RFMNGAltToplam')) + parseInt(allFilterResult.OpenStockResponseModel.OpenStockItemList[i].RFMNG);
                              FARKAltToplam = parseInt(component.get('v.FARKAltToplam')) + parseInt(allFilterResult.OpenStockResponseModel.OpenStockItemList[i].FARK);
           		    		  
                              component.set('v.KZWI2AltToplam', KZWI2AltToplam);   
                              component.set('v.KLMENGAltToplam', KLMENGAltToplam);
                              component.set('v.RFMNGAltToplam', RFMNGAltToplam);
                              component.set('v.FARKAltToplam', FARKAltToplam);		 
            }
            

            
           
        }
         
         var totalSizeFiltre = options.length;
         component.set('v.pageCount', Math.ceil(totalSizeFiltre/25));   //25 -> her bir page'de kaç item gösterileceği
         component.set('v.selectedPage', 1); 
         helper.setBusy(component,false);
        
         component.set("v.FilterAllOpenStockResponse.OpenStockResponseModel.OpenStockItemList",options);  
               
    },
    
    
    showOpenStockPopup : function (component, event, helper) {    
        var selectedMatnr = event.currentTarget.dataset.id;
        var splittedData = selectedMatnr.split('-');
        console.log('selectedMatnr : ' + selectedMatnr);
        
         debugger;
         
      
        var IV_VKORG = "";
        var IV_VTWEG = "";
        var IV_VKBUR = "";
        var IV_VKGRP = "";
         
          helper.setBusy(component,true);
         
   		var action = component.get("c.OpenStockButtonClick");
         action.setParams({IT_MATNR: splittedData[0], IV_KUNNR : splittedData[1], IV_VSTEL : splittedData[2],IV_VKBUR :IV_VKBUR ,IV_VKGRP :IV_VKGRP,IV_VKORG :IV_VKORG,IV_VTWEG:IV_VTWEG});
            	    
         action.setCallback(this, function(response) { 
                console.log('all open response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                var error = response.getError();
               
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                    component.set('v.AllOpenStockResponse', result);
                    component.set("v.OpenStockDetay", true);
                }
                else
                {
                  console.log('HATA response: ' + response);  
                }
               helper.setBusy(component,false);   
         })
         

         $A.enqueueAction(action);  
                window.scrollTo(0, 0);

        
               
    },
                
    hideOpenStockPopup : function(component, event, helper){
        component.set("v.OpenStockDetay", false);
    },
    
    previousClick : function(component, event, helper){
        var selectedPage = component.get("v.selectedPage");
        var allResult = component.get('v.AllStockResponse');
        
        if(selectedPage != 1){
            selectedPage -= 1;
            component.set("v.selectedPage", selectedPage);
            
            var filterResult = JSON.parse(JSON.stringify(allResult));
            filterResult.StockResponseModel.StockItemList = allResult.StockResponseModel.StockItemList.slice(((selectedPage-1) * 25), (selectedPage * 25));
            
            component.set('v.FilterStockResponse', filterResult);
        }
    },
    
    nextClick : function(component, event, helper){
        var pageCount = component.get("v.pageCount");       
        var selectedPage = component.get("v.selectedPage");
        var allResult = component.get('v.AllStockResponse')
        
        if(selectedPage != pageCount){
            debugger;
            selectedPage += 1;
            component.set("v.selectedPage", selectedPage);
            
            var filterResult = JSON.parse(JSON.stringify(allResult));
            filterResult.StockResponseModel.StockItemList = allResult.StockResponseModel.StockItemList.slice(((selectedPage-1) * 25), (selectedPage * 25));
            
            component.set('v.FilterStockResponse', filterResult);
        }
    },
    
     downloadStockTable : function(component, event, helper){
        helper.setBusy(component, true);
        helper.prepareData(component, event, helper);     
    },
    
    createVariant : function(component, event, helper){
        
        helper.setBusy(component, true);
        
        var IT_WERKS = component.get("v.selectedOptions"); 
        var IT_MATNR = component.find("IT_MATNR").get("v.value");
        var IV_KUNNR = component.find("IV_KUNNR").get("v.value");
        
        
        var IV_VKORG = $(".select2Class.VKORGCss").select2("val");
        var IV_VTWEG = $(".select2Class.VTWEGCss").select2("val");
        var IV_VKBUR = $(".select2Class.VKBURCss").select2("val");
        var IV_VKGRP = $(".select2Class.VKGRPCss").select2("val");
        
             var variantNameValue = component.get("v.variantName");
        
        
        var action = component.get("c.CreateVariant");
        
        action.setParams({IT_MATNR: IT_MATNR, IV_KUNNR : IV_KUNNR, IT_WERKS : IT_WERKS, IV_VKBUR :IV_VKBUR ,IV_VKGRP :IV_VKGRP,IV_VKORG :IV_VKORG,IV_VTWEG:IV_VTWEG , variantName : variantNameValue});
        
        action.setCallback(this, function(response) { 
            console.log('response::: ' + JSON.stringify(response.getReturnValue()));
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS")
            {
                if(result)
                {
                    console.log('valid');
                    component.set("v.createVariantModal", false);
                    helper.setBusy(component,false);
                    helper.showMessageToast('Variant Kaydetme İşlemi Gerçekleştirilmiştir.','Success');                      
                }
                else
                { 
                    console.log('error'); 
                    helper.setBusy(component,false);
                    helper.showMessageToast('Variant Kaydetme İşlemi Gerçekleştirilemedi.','Error');
                }
                
            }
            else
            { 
                console.log('error'); 
                helper.setBusy(component,false);
                helper.showMessageToast('Variant Kaydetme İşlemi Gerçekleştirilemedi.','Error');
            }
            
            
        });
        
        $A.enqueueAction(action);
    },
    openVariantModal : function(component,event,helper){
        component.set("v.createVariantModal", true);
        window.scrollTo(0, 0);

    },
    openVariantList : function(component,event,helper){
        helper.getVariants(component,event);
                window.scrollTo(0, 0);

    },
    hideVariantModal : function(component, event, helper){
        component.set("v.createVariantModal", false);
    },
    hideVariantList : function(component, event, helper){
        component.set("v.variantListModal", false);
    },
    
    deleteVariantItem : function(component, event, helper){
        
        
        var varId = event.getSource().get("v.value");
        var action = component.get("c.DeleteVariantItem");
        
        action.setParams({variantId: varId});
        
        
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            var error = response.getError();        
            if(component.isValid() && response.getState() == "SUCCESS")
            {
                if(result)
                {
                    helper.showMessageToast('Variant Silme İşlemi Gerçekleştirildi.','Success');
                    helper.getVariants(component,event);
                    
                }
                else{
                    helper.showMessageToast('Variant Silme İşlemi Gerçekleştirilemedi.','Error');
                    
                }
            }
            else
            {
                helper.showMessageToast('Variant Silme İşlemi Gerçekleştirilemedi.','Error');
            }
        });
        
        $A.enqueueAction(action);
        
    },
   
    setVariantItem : function(component, event, helper){
        var varId = event.getSource().get("v.value");
        var action = component.get("c.GetVariantItem");
        
        action.setParams({variantId: varId});
        
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            var error = response.getError();        
            if(component.isValid() && response.getState() == "SUCCESS")
            {
                if(result!=null)
                {
                    let uretimYeriList = [];
                    let satisOrganizasyonu = [];
                    let satisGrubu = [];
                    let satisBurosu = [];
                    let DagitimKanali = [];
                    
                    uretimYeriList = result.variantData.RC_Production_Place_Variant__c.split(',');
                    satisOrganizasyonu = result.variantData.RC_Sales_Organization__c.split(',');
                    satisGrubu = result.variantData.RC_Sales_Group__c.split(',');
                    satisBurosu = result.variantData.RC_Sales_Office__c.split(',');
                    DagitimKanali = result.variantData.RC_Distribution_Channel__c.split(',');
                    
                    component.set("v.selectedOptions", uretimYeriList);
                    
                    
                    component.set("v.GetInitResponse.InitResponseModel.SalesOrganizationList",result.satisOrganizasyonu);
                    component.set("v.GetInitResponse.InitResponseModel.RegionalDirectorateList",result.satisGrubu);
                    component.set("v.GetInitResponse.InitResponseModel.SalesDirectorateList",result.satisBurosu);
                    component.set("v.GetInitResponse.InitResponseModel.DistributionChannelList",result.DagitimKanali);
                    
                    
                    component.set("v.IT_MATNR", result.variantData.RC_Product_Variant__c);
                    component.set("v.IV_KUNNR", result.variantData.RC_Customer_Variant__c);
                    
                    
                  
                    component.set("v.variantListModal", false);
                    helper.showMessageToast('Variant Yükleme İşlemi Gerçekleştirildi.','Success');
                    
                }
                else{
                    component.set("v.variantListModal", false);
                    helper.showMessageToast('Variant Yükleme İşlemi Gerçekleştirilemedi.','Error');
                }
            }
            else
            {
                component.set("v.variantListModal", false);
                helper.showMessageToast('Variant Yükleme İşlemi Gerçekleştirilemedi.','Error');
            }
        });
        
        $A.enqueueAction(action);
    }
       
});