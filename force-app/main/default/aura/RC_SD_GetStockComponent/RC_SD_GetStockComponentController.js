({
    scriptsLoaded : function(component, event, helper) {
        $(".select2Class.productCodeCss").select2({
            tags: true
        }); 
        $(".select2Class.brandCss").select2({
            tags: true
        });
        $(".select2Class.goodsGroupCss").select2({
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
                component.set("v.listUretimYeri", options);               
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
        
        var productCodeList = component.get("v.productCodes").ProductCodeList;
        console.log('productCodeList:' + productCodeList);
        
        if(productCodeList !== undefined){
            let selectedOptions = ["2204"];
            component.set("v.selectedUretimYeri", selectedOptions);
        }
        
        action2.setParams({productCodeList: productCodeList});
        action2.setCallback(this, function(response) { 
            
            component.set('v.stokStatu',true);
            component.set('v.SASStatu', false);
            
            var result = response.getReturnValue();
            var error = response.getError();
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                
                component.set('v.GetInitResponse', result);
                
                if(result.StockWrapper!=null)
                {
                    if(result.StockWrapper.StockResponseModel.StockItemList[0].MATNR == ''){
                        var warningStockMessage = $A.get("$Label.c.Stock_Information_Not_Found");
                        helper.showMessageToast(warningStockMessage,'Warning');
                        component.set('v.FilterStockResponse', null);
                    }
                    else{
                        var totalSize = result.StockWrapper.StockResponseModel.StockItemList.length;
                        component.set('v.pageCount', Math.ceil(totalSize/25));   //25 -> her bir page'de kaç item gösterileceği
                        component.set('v.selectedPage', 1); 
                        debugger;
                        var filterResult = JSON.parse(JSON.stringify(result.StockWrapper));
                        filterResult.StockResponseModel.StockItemList = result.StockWrapper.StockResponseModel.StockItemList.slice(0, 25);
                        
                        if(filterResult.StockResponseModel.StockItemList.length == 0){
                            var warningNoStock = $A.get("$Label.c.No_Stock_Warning");
                            helper.showMessageToast(warningNoStock,'Warning');
                        }
                        
                        component.set('v.FilterStockResponse', filterResult);   //1.page'dekiler yüklenir. (result  ilk 25 kayıt)
                        
                        console.log('result list : ' + JSON.stringify(component.get('v.AllStockResponse')));
                        console.log('filter list: ' + JSON.stringify(component.get('v.FilterStockResponse')));
                    }
                }
                
            }
            
            helper.setBusy(component,false);
        });
        
        $A.enqueueAction(action2);   
    },    
    
    Init3 : function(component, event, helper){
        
        var action = component.get("c.getSlidingAverageRole");
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            var error = response.getError(); 
            
            if(component.isValid() && response.getState() == "SUCCESS")
            {
                if(result)
                {  
                    component.set("v.SlidingAverageRole", true);     
                }
                
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    
    
    
    selectedUretimYeriDrp : function (component, event, helper) {
        helper.selectedUretimYeriHelper(component,event);
    },
    
    handleClick : function (component, event, helper) {
        debugger;
        
        var urunKodList = $(".productCodeCss").select2("val");
        var markaList = $(".brandCss").select2("val");
        var malGrubuList = $(".goodsGroupCss").select2("val");
        
        var uretimYeri = component.get("v.selectedUretimYeri");
        var depoYeri   = component.get("v.selectedDepoYeri");
        
        var SatStokAltToplam = 0;
        var VestelStokAltToplam = 0;
        var UreticiStokAltToplam = 0;
        var TesMikAltToplam = 0;
        var TahditsizAltToplam =0;
        var KayarOrtAltToplam = 0;
        var BlokeStokAltToplam =0;
        
        
        
        
        if(uretimYeri == null || uretimYeri == ''){  
            var warningMessage = $A.get("$Label.c.emty_warning");
            helper.showMessageToast(warningMessage,'Warning');
            
        }
        else if(markaList != null && urunKodList == null && depoYeri == '')
        {  
            var warningMessage = $A.get("$Label.c.empty_warning2");
            helper.showMessageToast(warningMessage,'Warning');
            
        }
            else if(malGrubuList != null && urunKodList == null  && depoYeri == '')
            {  
                var warningMessage = $A.get("$Label.c.empty_warning2");
                helper.showMessageToast(warningMessage,'Warning');
                
            }
                else{
                    helper.setBusy(component,true);
                    
                    var action = component.get("c.buttonClick");
                    
                    action.setParams({uretimYeri: uretimYeri, depoYeri : depoYeri, urunKodList : urunKodList, markaList : markaList, malGrubuList : malGrubuList});
                    
                    action.setCallback(this, function(response) { 
                        console.log('response: ' + JSON.stringify(response.getReturnValue()));
                        var result = response.getReturnValue();
                        var error = response.getError();
                        if(component.isValid() && response.getState() == "SUCCESS"){ 
                            component.set('v.AllStockResponse', result);
                            
                            component.set("v.stokStatu", true);
                            component.set("v.SASStatu", false);
                            
                            component.set('v.SatStokAltToplam', SatStokAltToplam); 
                            component.set('v.VestelStokAltToplam', VestelStokAltToplam); 
                            component.set('v.UreticiStokAltToplam', UreticiStokAltToplam); 
                            component.set('v.TesMikAltToplam', TesMikAltToplam); 
                            component.set('v.TahditsizAltToplam', TahditsizAltToplam); 
                            component.set('v.KayarOrtAltToplam', KayarOrtAltToplam); 
                            component.set('v.BlokeStokAltToplam', BlokeStokAltToplam); 
                            
                            
                            if(result.StockResponseModel.StockItemList[0].MATNR == ''){
                                var warningStockMessage = $A.get("$Label.c.Stock_Information_Not_Found");
                                helper.showMessageToast(warningStockMessage,'Warning');
                                component.set('v.FilterStockResponse', null);
                                
                                
                            }
                            else{
                                var totalSize = result.StockResponseModel.StockItemList.length;
                                component.set('v.pageCount', Math.ceil(totalSize/25));   //25 -> her bir page'de kaç item gösterileceği
                                component.set('v.selectedPage', 1); 
                                
                                var filterResult = JSON.parse(JSON.stringify(response.getReturnValue()));
                                filterResult.StockResponseModel.StockItemList = result.StockResponseModel.StockItemList.slice(0, 25);
                                
                                if(filterResult.StockResponseModel.StockItemList.length == 0){
                                    var warningNoStock = $A.get("$Label.c.No_Stock_Warning");
                                    helper.showMessageToast(warningNoStock,'Warning');
                                }
                                
                                for(var i = 0; i < totalSize; i++){
                                    
                                    SatStokAltToplam = parseInt(component.get('v.SatStokAltToplam')) + parseInt(result.StockResponseModel.StockItemList[i].SAT_STOK);
                                    VestelStokAltToplam = parseInt(component.get('v.VestelStokAltToplam')) + parseInt(result.StockResponseModel.StockItemList[i].VESTEL_STOK);
                                    UreticiStokAltToplam = parseInt(component.get('v.UreticiStokAltToplam')) + parseInt(result.StockResponseModel.StockItemList[i].URETICI_STOK);
                                    TesMikAltToplam = parseInt(component.get('v.TesMikAltToplam')) + parseInt(result.StockResponseModel.StockItemList[i].TES_MIK);
                                    TahditsizAltToplam = parseFloat(component.get('v.TahditsizAltToplam')) + parseFloat(result.StockResponseModel.StockItemList[i].TAHDITSIZ);
                                    KayarOrtAltToplam = parseFloat(component.get('v.KayarOrtAltToplam')) + parseFloat(result.StockResponseModel.StockItemList[i].KAYAR_ORT_FIYAT);
                                    BlokeStokAltToplam = parseInt(component.get('v.BlokeStokAltToplam')) + parseInt(result.StockResponseModel.StockItemList[i].BLOKE_STOK_TOPLAM);
                                    
                                    component.set('v.SatStokAltToplam', SatStokAltToplam); 
                                    component.set('v.VestelStokAltToplam', VestelStokAltToplam); 
                                    component.set('v.UreticiStokAltToplam', UreticiStokAltToplam); 
                                    component.set('v.TesMikAltToplam', TesMikAltToplam); 
                                    component.set('v.TahditsizAltToplam', TahditsizAltToplam); 
                                    component.set('v.KayarOrtAltToplam', KayarOrtAltToplam); 
                                    component.set('v.BlokeStokAltToplam', BlokeStokAltToplam); 
                                    
                                }
                                
                                component.set('v.FilterStockResponse', filterResult);   //1.page'dekiler yüklenir. (result  ilk 5 kayıt)
                                component.set('v.TempFilterStockResponse', filterResult);  
                                
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
                }
        
    },
    
    MaterialhandleClick : function (component, event, helper) {
        debugger;
        
        var urunKodList = $(".productCodeCss").select2("val");
        var markaList = $(".brandCss").select2("val");
        var malGrubuList = $(".goodsGroupCss").select2("val");
        
        var uretimYeri = component.get("v.selectedUretimYeri");
        var depoYeri   = component.get("v.selectedDepoYeri");
        var sasToplamKalan = component.get("v.TOPLAMSASKALAN");
        var toplamSAS;
        
        var SasMiktarAltToplam = 0;
        var SasKalanAltToplam  = 0;
        
        if(urunKodList == "" || urunKodList == null)
        {
            var warningMessage = $A.get("$Label.c.emty_warning");
            helper.showMessageToast(warningMessage,'Warning');
        }
        else
        {
            helper.setBusy(component,true);
            
            var action = component.get("c.materialInfo");
            
            action.setParams({MATNR : urunKodList[0]});
            
            action.setCallback(this, function(response) { 
                console.log('response: ' + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                var error = response.getError();
                if(component.isValid() && response.getState() == "SUCCESS"){ 
                    component.set('v.AllMaterialStockResponse', result);
                    
                    component.set("v.stokStatu", false);
                    component.set("v.SASStatu", true);
                    
                    var allFilterResult =JSON.parse(JSON.stringify(component.get('v.AllMaterialStockResponse.MaterialInfoResponseModel.MaterialInfoItemList')));
                    
                    
                    for(var i = 0; i < allFilterResult.length; i++)
                    {
                        SasMiktarAltToplam = parseInt(component.get('v.SasMiktarAltToplam')) + parseInt(allFilterResult[i].SASMIKTAR);
                        SasKalanAltToplam  = parseInt(component.get('v.SasKalanAltToplam'))  + parseInt(allFilterResult[i].SASKALANMIKTAR);
                        
                        component.set('v.SasMiktarAltToplam', SasMiktarAltToplam); 
                        component.set('v.SasKalanAltToplam', SasKalanAltToplam); 
                    } 
                    
                    
                }
                else{ 
                    console.log('HATA response: ' + response);
                    component.set('v.showMaterialInfoResponse', null);
                }
                
                helper.setBusy(component,false);
            });
            
            $A.enqueueAction(action);
        }
        
    },
    
    
    filtreHandleClick : function (component, event, helper) {    
        
        debugger;
        
        var IV_MALZEMEKOD = component.find("IV_MALZEMEKOD").get("v.value");
        var IV_MALZEMEAD = component.find("IV_MALZEMEAD").get("v.value");
        var IV_MALGRUP = component.find("IV_MALGRUP").get("v.value");
        
        var allFilterResult = component.get('v.AllStockResponse');
        
        
        var options = [];
        
        var SatStokAltToplam = 0;
        var VestelStokAltToplam = 0;
        var UreticiStokAltToplam = 0;
        var TesMikAltToplam = 0;
        var TahditsizAltToplam =0;
        var KayarOrtAltToplam = 0;
        var BlokeStokAltToplam =0;
        
        
        component.set('v.SatStokAltToplam', SatStokAltToplam); 
        component.set('v.VestelStokAltToplam', VestelStokAltToplam); 
        component.set('v.UreticiStokAltToplam', UreticiStokAltToplam); 
        component.set('v.TesMikAltToplam', TesMikAltToplam); 
        component.set('v.TahditsizAltToplam', TahditsizAltToplam); 
        component.set('v.KayarOrtAltToplam', KayarOrtAltToplam); 
        component.set('v.BlokeStokAltToplam', BlokeStokAltToplam); 
        
        
        for(var i = 0; i < allFilterResult.StockResponseModel.StockItemList.length; i++)
        {
            helper.setBusy(component,true);
            
            if (
                (allFilterResult.StockResponseModel.StockItemList[i].MATNR.toLowerCase().indexOf(IV_MALZEMEKOD.toLowerCase()) != -1 || IV_MALZEMEKOD == null)   && 
                (allFilterResult.StockResponseModel.StockItemList[i].MALZEME_TANIM.toLowerCase().indexOf(IV_MALZEMEAD.toLowerCase())  != -1 || IV_MALZEMEAD == '') && 
                (allFilterResult.StockResponseModel.StockItemList[i].MAL_TANIM.toLowerCase().indexOf(IV_MALGRUP.toLowerCase()) != -1 || IV_MALGRUP == ''))
            {
                
                options.push(allFilterResult.StockResponseModel.StockItemList[i]); 
                
                SatStokAltToplam = parseInt(component.get('v.SatStokAltToplam')) + parseInt(allFilterResult.StockResponseModel.StockItemList[i].SAT_STOK);
                VestelStokAltToplam = parseInt(component.get('v.VestelStokAltToplam')) + parseInt(allFilterResult.StockResponseModel.StockItemList[i].VESTEL_STOK);
                UreticiStokAltToplam = parseInt(component.get('v.UreticiStokAltToplam')) + parseInt(allFilterResult.StockResponseModel.StockItemList[i].URETICI_STOK);
                TesMikAltToplam = parseInt(component.get('v.TesMikAltToplam')) + parseInt(allFilterResult.StockResponseModel.StockItemList[i].TES_MIK);
                TahditsizAltToplam = parseFloat(component.get('v.TahditsizAltToplam')) + parseFloat(allFilterResult.StockResponseModel.StockItemList[i].TAHDITSIZ);
                KayarOrtAltToplam = parseFloat(component.get('v.KayarOrtAltToplam')) + parseFloat(allFilterResult.StockResponseModel.StockItemList[i].KAYAR_ORT_FIYAT);
                BlokeStokAltToplam = parseInt(component.get('v.BlokeStokAltToplam')) + parseInt(allFilterResult.StockResponseModel.StockItemList[i].BLOKE_STOK_TOPLAM);
                
                component.set('v.SatStokAltToplam', SatStokAltToplam); 
                component.set('v.VestelStokAltToplam', VestelStokAltToplam); 
                component.set('v.UreticiStokAltToplam', UreticiStokAltToplam); 
                component.set('v.TesMikAltToplam', TesMikAltToplam); 
                component.set('v.TahditsizAltToplam', TahditsizAltToplam); 
                component.set('v.KayarOrtAltToplam', KayarOrtAltToplam); 
                component.set('v.BlokeStokAltToplam', BlokeStokAltToplam); 
                
            }
            
            
            
            
        }
        
        var totalSizeFiltre = options.length;
        component.set('v.pageCount', Math.ceil(totalSizeFiltre/25));   //25 -> her bir page'de kaç item gösterileceği
        component.set('v.selectedPage', 1); 
        helper.setBusy(component,false);
        component.set("v.FilterStockResponse.StockResponseModel.StockItemList",options);  
        
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
    
    showDagilimBilgileriPopUp : function(component, event, helper){
        
        var selectedMatnr = event.getSource().get("v.value");
        var splittedData = selectedMatnr.split('-');
        console.log('selectedMatnr : ' + selectedMatnr);
        
        var allFilterResult = JSON.parse(JSON.stringify(component.get('v.FilterStockResponse')));
        
        for(var i = 0; i < allFilterResult.StockResponseModel.StockItemList.length; i++){
            if (allFilterResult.StockResponseModel.StockItemList[i].MATNR == splittedData[0] && allFilterResult.StockResponseModel.StockItemList[i].LGORT == splittedData[1] && allFilterResult.StockResponseModel.StockItemList[i].WERKS == splittedData[2]){
                component.set("v.dagilimBilgileriResponse", allFilterResult.StockResponseModel.StockItemList[i].DAGILIM_BILGILERI);   
                console.log(JSON.stringify(allFilterResult.StockResponseModel.StockItemList[i].DAGILIM_BILGILERI));
            }
        }
        
        component.set("v.dagilimBilgileriDetay", true);
    },
    
    
    hideDagilimBilgileriPopUp : function(component, event, helper){
        component.set("v.dagilimBilgileriDetay", false);
    },
    
    showBlokeStokDetayPopUp : function(component, event, helper){
        
        var selectedMatnr = event.currentTarget.dataset.id;
        var splittedData = selectedMatnr.split('-');
        console.log('selectedMatnr : ' + selectedMatnr);
        console.log('matnr : ' + splittedData[0]);
        console.log('LGORT : ' + splittedData[1]);
        console.log('werks : ' + splittedData[2]);
        
        var allFilterResult = JSON.parse(JSON.stringify(component.get('v.FilterStockResponse')));
        
        for(var i = 0; i < allFilterResult.StockResponseModel.StockItemList.length; i++){
            if (allFilterResult.StockResponseModel.StockItemList[i].MATNR == splittedData[0] && allFilterResult.StockResponseModel.StockItemList[i].LGORT == splittedData[1] && allFilterResult.StockResponseModel.StockItemList[i].WERKS == splittedData[2]){
                
                component.set("v.blokeStokDetayResponse", allFilterResult.StockResponseModel.StockItemList[i].BLOKE_STOK_DETAY);               
                console.log("bloke : "+JSON.stringify(allFilterResult.StockResponseModel.StockItemList[i].BLOKE_STOK_DETAY));
                
            }
        }
        
        component.set("v.blokeStokDetay", true);
        window.scrollTo(0, 0);
    },
    
    hideBlokeStokDetayPopUp : function(component, event, helper){
        component.set("v.blokeStokDetay", false);
    },
    
    showTeslimatBilgileriPopUp : function(component, event, helper){
        
        var selectedMatnr = event.currentTarget.dataset.id;
        var splittedData = selectedMatnr.split('-');
        console.log('selectedMatnr : ' + selectedMatnr);
        
        var allFilterResult = JSON.parse(JSON.stringify(component.get('v.FilterStockResponse')));
        
        for(var i = 0; i < allFilterResult.StockResponseModel.StockItemList.length; i++){
            if (allFilterResult.StockResponseModel.StockItemList[i].MATNR == splittedData[0] && allFilterResult.StockResponseModel.StockItemList[i].LGORT == splittedData[1] && allFilterResult.StockResponseModel.StockItemList[i].WERKS == splittedData[2]){
                
                component.set("v.teslimatBilgileriResponse", allFilterResult.StockResponseModel.StockItemList[i].TESLIMAT_DETAY);               
                console.log(JSON.stringify(allFilterResult.StockResponseModel.StockItemList[i].TESLIMAT_DETAY));
                
            }
        }
        
        component.set("v.teslimatBilgileri", true);
        window.scrollTo(0, 0);
    },
    
    hideTeslimatBilgileriPopUp : function(component, event, helper){
        component.set("v.teslimatBilgileri", false);
    },
    
    showMaterialInfoPopup : function (component, event, helper) {    
        var selectedMatnr = event.currentTarget.dataset.id;
        var splittedData = selectedMatnr.split('-');
        console.log('selectedMatnr  : ' + selectedMatnr);
        
        debugger;
        var action = component.get("c.materialInfo");
        action.setParams({MATNR : selectedMatnr});
        
        action.setCallback(this, function(response) { 
            console.log('response: ' + JSON.stringify(response.getReturnValue()));
            var result = response.getReturnValue();
            var error = response.getError();
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                component.set('v.showMaterialInfoResponse', result);
                component.set("v.showMaterialInfo", true);
            }
            else
            {
                console.log('HATA response: ' + response);  
            }
            helper.setBusy(component,false); 
        })
        $A.enqueueAction(action);       
    },
    
    hideshowMaterialInfoPopup : function(component, event, helper){
        component.set("v.showMaterialInfo", false);
    },
    
    showSASKalanPopUp : function (component, event, helper) {    
        
        var selectedMatnr = event.currentTarget.dataset.id;
        var splittedData = selectedMatnr.split('-');
        console.log('selectedMatnr sas : ' + selectedMatnr);
        
        var allFilterResult =JSON.parse(JSON.stringify(component.get('v.AllMaterialStockResponse.MaterialInfoResponseModel.MaterialInfoItemList')));
        
        for(var i = 0; i < allFilterResult.length; i++){
            
            if (allFilterResult[i].MATNR == splittedData[0] && allFilterResult[i].EBELN == splittedData[1]){
                
                component.set("v.saskalanResponse", allFilterResult[i].SASKALAN);               
                console.log(JSON.stringify(allFilterResult[i].SASKALAN));   
            }
        }
        
        component.set("v.showSASKalanInfo", true);
        window.scrollTo(0, 0);
        
    },
    
    hideSASKalanBilgileriPopUp : function(component, event, helper){
        component.set("v.showSASKalanInfo", false);
    },
    
    downloadStockTable : function(component, event, helper){
        helper.setBusy(component, true);
        helper.prepareData(component, event, helper);     
    },
    
    createVariant : function(component, event, helper){
        
        helper.setBusy(component, true);
        
        var urunKodList  = $(".productCodeCss").select2("val");
        var markaList    = $(".brandCss").select2("val");
        var malGrubuList = $(".goodsGroupCss").select2("val");
        
        var uretimYeri       = component.get("v.selectedUretimYeri");
        var depoYeri         = component.get("v.selectedDepoYeri");
        var variantNameValue = component.get("v.variantName");
        
        var action = component.get("c.CreateVariant");
        
        action.setParams({uretimYeri: uretimYeri, depoYeri : depoYeri, urunKodList : urunKodList, markaList : markaList, malGrubuList : malGrubuList , variantName : variantNameValue});
        
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
        helper.setBusy(component,true);
        component.set("v.createVariantModal", true);
        window.scrollTo(0,0);
        helper.setBusy(component,false);
    },
    openVariantList : function(component,event,helper){
        helper.getVariants(component,event);
        window.scrollTo(0,0);
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
                    uretimYeriList = result.variantData.RC_Production_Place_Variant__c.split(',');
                    component.set("v.selectedUretimYeri", uretimYeriList);
                    
                    helper.selectedUretimYeriHelper(component,event);
                    
                    let depoYeriList = [];
                    depoYeriList = result.variantData.RC_Warehouse_Location_Variant__c.split(',');
                    component.set("v.selectedDepoYeri", depoYeriList);
                    
                    component.set("v.GetInitResponse.InitResponseModel.BrandList",result.brandList);
                    component.set("v.GetInitResponse.InitResponseModel.GoodsGroupList",result.goodsGroupList);
                    component.set("v.GetInitResponse.InitResponseModel.SelectedProductCodeList",result.productList);
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