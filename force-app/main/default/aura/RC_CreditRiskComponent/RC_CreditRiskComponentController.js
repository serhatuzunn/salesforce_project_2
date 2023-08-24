({
    Init : function(component, event, helper) {
        helper.setBusy(component,true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.initialize");
        
        action.setParams({"recordId": recordId});
        action.setCallback(this, function(response) { 
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){  
                
                if(result.responseWrp.lenght > 0){
                    
                    result.responseWrp.creditRiskResponse.itemZ[0].BAYI_OLUS_TARIHI = helper.formatDate(component,event,helper,result.responseWrp.itemZ.BAYI_OLUS_TARIHI);
                    result.responseWrp.creditRiskResponse.itemZ[0].KREDI_TARIHI = helper.formatDate(component,event,helper,result.responseWrp.itemZ.KREDI_TARIHI);
                    
                }
                
                component.set('v.Acik_Hesap_Valor_Number', parseInt(result.responseWrp.creditRiskResponse.itemZ.ACIK_HESAP_VALORU));

                console.log('items:' + JSON.stringify(result.responseWrp.creditRiskResponse.itemZ));
                component.set("v.CreditRiskResponse", result.responseWrp.creditRiskResponse); 
                component.set("v.BayiCekResponse", result.responseWrp.bayiCekSenetResponse); 
                component.set("v.BaglantiResponse", result.responseWrp.baglantiResponse); 
                console.log('result : ' + JSON.stringify(result.responseWrp.groupedBayiCekSenet));
                component.set("v.GroupedCekSenet", result.responseWrp.groupedBayiCekSenet);
                component.set("v.SelectedKarsiliksizCekSenet", result.responseWrp.SelectedKarsiliksizCekSenet);
                component.set("v.DistChannelList", result.DistChannelList);  
                component.set("v.selectedDistChannel", result.DistChannelList[0].value); 
                console.log('return:' + JSON.stringify(component.get("v.BaglantiResponse.etReturn.item"))); 
                
                //Entegrasyon üzerinden dönen verinin formatı yanlış olduğu için kontrol eklendi.
                if(result.responseWrp.baglantiResponse.etReturn.item.length==1)
                {
                   if(result.responseWrp.baglantiResponse.etReturn.item[0].KUNNR=='')
                   {
                     component.set("v.BaglantiResponse", null);  
                   }
                }
            } 
            helper.setBusy(component,false);
        });
        $A.enqueueAction(action);
    },
    distributionChannelChange : function(component, event, helper){
        helper.setBusy(component,true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.getCreditRiskReport");
        
        action.setParams({"accountId": recordId,
                          "distChannel" : component.get("v.selectedDistChannel")});
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){  
                console.log("result.responseWrp: " + JSON.stringify(result));
                component.set("v.CreditRiskResponse", result.creditRiskResponse);
                component.set("v.BayiCekResponse", result.bayiCekSenetResponse);
                component.set("v.GroupedCekSenet", result.groupedBayiCekSenet);
                component.set("v.BaglantiResponse", result.baglantiResponse); 
            } 
            helper.setBusy(component,false);
        });
        $A.enqueueAction(action);
    },
    showPopUp : function(component, event, helper){
        component.set("v.showRiskPopup",true);
        
    },
    hidePopUp : function(component, event, helper){
        component.set("v.showRiskPopup",false);
    },
    checkDetail : function(component, event, helper){
        var id = event.currentTarget.dataset.id;
        console.log('div:' + id);
        
        var groupedCekSenet = component.get('v.GroupedCekSenet');     
        console.log(JSON.stringify(component.get("v.GroupedCekSenet")));
        
        console.log('size : ' + groupedCekSenet.length);
        
        component.set('v.SelectedGroupedCekSenet', null);
        component.set('v.SelectedCekSenetName', '');
        
        for(var i=0; i < groupedCekSenet.length; i++){
            
            if(id == 'CEK_DTS'){
                component.set('v.SelectedCekSenetName', $A.get("$Label.c.DTS_Checks_Detail"));
                if(id == groupedCekSenet[i].CheckType){
                    component.set('v.SelectedGroupedCekSenet', groupedCekSenet[i].TotalValueByMonthAndYear);
                    break;
                }
                
            }
            else if(id == 'CEK_SAHSI'){
                component.set('v.SelectedCekSenetName', $A.get("$Label.c.Personal_Checks_Detail"));
                if(id == groupedCekSenet[i].CheckType){
                    component.set('v.SelectedGroupedCekSenet', groupedCekSenet[i].TotalValueByMonthAndYear);
                    break;
                }
                
            }
                else if(id == 'CEK_MUSTERI'){
                    component.set('v.SelectedCekSenetName', $A.get("$Label.c.Customer_Checks_Detail"));
                    if(id == groupedCekSenet[i].CheckType){
                        component.set('v.SelectedGroupedCekSenet', groupedCekSenet[i].TotalValueByMonthAndYear);                   
                        break;
                    }
                    
                }
                    else if(id == 'CEK_BAGLANTI'){
                        component.set('v.SelectedCekSenetName', $A.get("$Label.c.Connection_Checks_Detail"));
                        if(id == groupedCekSenet[i].CheckType){
                            component.set('v.SelectedGroupedCekSenet', groupedCekSenet[i].TotalValueByMonthAndYear);
                            break;
                        }
                        
                    }
                        else if(id == 'SENET_SAHSI'){
                            component.set('v.SelectedCekSenetName', $A.get("$Label.c.Personal_Notes_Detail"));
                            if(id == groupedCekSenet[i].CheckType){
                                component.set('v.SelectedGroupedCekSenet', groupedCekSenet[i].TotalValueByMonthAndYear);
                                break;
                            }
                            
                        }
                            else if(id == 'SENET_MUSTERI'){
                                component.set('v.SelectedCekSenetName', $A.get("$Label.c.Customer_Notes_Detail"));
                                if(id == groupedCekSenet[i].CheckType){
                                    component.set('v.SelectedGroupedCekSenet', groupedCekSenet[i].TotalValueByMonthAndYear);
                                    break;
                                }
                                
                            }
                                else if(id == 'SENET_BAGLANTI'){
                                    component.set('v.SelectedCekSenetName', $A.get("$Label.c.Connection_Notes_Detail"));
                                    if(id == groupedCekSenet[i].CheckType){
                                        component.set('v.SelectedGroupedCekSenet', groupedCekSenet[i].TotalValueByMonthAndYear);
                                        break;
                                    }
                                    
                                }
            
            
        }
        
        console.log('ilhan : ' + JSON.stringify(component.get('v.SelectedGroupedCekSenet')));
        
        component.set("v.showCekSenetDetay",true);
        window.scrollTo(0, 650);
    },
    karsiliksizCheckDetail : function(component, event, helper){
        var dataId = event.currentTarget.dataset.id;
        console.log('dataId:' + dataId);
        
        var allCekSenet = component.get('v.SelectedKarsiliksizCekSenet');
        console.log(JSON.stringify(allCekSenet));
        
        if(dataId == 'KARSILIKSIZ_CEKLER'){ 
            component.set('v.SelectedKarsiliksizCekSenetName', 'Karşılıksız Çek/Senet');
            allCekSenet.SelectedModalKarsiliksizList = allCekSenet.SelectedKarsiliksizCekSenetList;
            component.set('v.SelectedKarsiliksizCekSenet', allCekSenet);
        }
        else if(dataId == 'PROTESTOLU_SENETLER'){
            component.set('v.SelectedKarsiliksizCekSenetName', 'Protestolu Senetler');
            allCekSenet.SelectedModalKarsiliksizList = allCekSenet.SelectedProtestoluSenetList;
            component.set('v.SelectedKarsiliksizCekSenet', allCekSenet);
        }
            else if(dataId == 'IADELI_CEKLER'){
                component.set('v.SelectedKarsiliksizCekSenetName', 'İadeli Çekler');
                allCekSenet.SelectedModalKarsiliksizList = allCekSenet.SelectedIadeliCekList;
                component.set('v.SelectedKarsiliksizCekSenet', allCekSenet);
            }
                else if(dataId == 'IADELI_SENETLER'){
                    component.set('v.SelectedKarsiliksizCekSenetName', 'İadeli Senetler');
                    allCekSenet.SelectedModalKarsiliksizList = allCekSenet.SelectedIadeliSenetList;
                    component.set('v.SelectedKarsiliksizCekSenet', allCekSenet);
                }

        component.set("v.showKarsiliksizCekSenetDetay",true);
        
        window.scrollTo(0, 650);
        var ilhan = component.get("v.SelectedKarsiliksizCekSenet.SelectedModalKarsiliksizList");
        console.log('ilhan : ' + JSON.stringify(ilhan));
        
    },
    showTeminat : function(component, event, helper){
        component.set("v.showYenilenecekTeminat",true);
        window.scrollTo(0, 650);

    },
    hideTeminat : function(component, event, helper){
        component.set("v.showYenilenecekTeminat",false);
    },
    hideCekSenetDetail : function(component, event, helper){
        component.set("v.showCekSenetDetay",false);
    },
    hideKarsiliksizCekSenetDetail : function(component, event, helper){
        component.set("v.showKarsiliksizCekSenetDetay",false);
    },
    showDetailPopUp : function(component, event, helper){
        component.set("v.showRiskPopup",true);
        window.scrollTo(0, 650);
    },
    showIpotekDetayPopUp : function(component, event, helper){
        component.set("v.showIpotekDetay",true);
        window.scrollTo(0, 650);
    },
    hideIpotekDetayPopUp : function(component, event, helper){
        component.set("v.showIpotekDetay",false);
    },
    showTeminatDetayPopUp : function(component, event, helper){
        component.set("v.showTeminatDetay",true);
        window.scrollTo(0, 650);
    },
    showTeminatIpotegiDetayPopUp : function(component, event, helper){
        component.set("v.showTeminatIpotegiDetay",true);
        window.scrollTo(0, 650);
    },
    hideTeminatDetayPopUp : function(component, event, helper){
        component.set("v.showTeminatDetay",false);
    },
    hideTeminatIpotegiDetayPopUp : function(component, event, helper){
        component.set("v.showTeminatIpotegiDetay",false);
    },
    showDtstmckDetayPopUp : function(component, event, helper){
        component.set("v.showDtstmckDetay",true);
        window.scrollTo(0, 650);
    },
    hideDtstmckDetayPopUp : function(component, event, helper){
        component.set("v.showDtstmckDetay",false);
    },
    showBaglantiFaturaDetayPopUp : function(component, event, helper){
        
        
        var sozlesmeNo = event.currentTarget.dataset.id;
        console.log('sozlesmeNo :' + sozlesmeNo);
        
        var allBaglantiResult = JSON.parse(JSON.stringify(component.get('v.BaglantiResponse')));
        
        for(var i = 0; i < allBaglantiResult.etReturn.item.length; i++){
            if (allBaglantiResult.etReturn.item[i].SOZLESME_NO == sozlesmeNo){
                component.set("v.SelectedBaglantiFaturaDetay", allBaglantiResult.etReturn.item[i].FAT_DETAY);   
            }
        }         
        
        component.set("v.showBaglantiFaturaDetay", true);
        window.scrollTo(0, 650);
    },
    hideBaglantiFaturaDetayPopUp : function(component, event, helper){
        component.set("v.showBaglantiFaturaDetay", false);
    },
    showBaglantiCekDetayPopUp : function(component, event, helper){
        helper.setBusy(component,false);
        var sozlesmeNo = event.currentTarget.dataset.id;
        console.log('sozlesmeNo cek :' + sozlesmeNo);
        
        var allBaglantiResult = JSON.parse(JSON.stringify(component.get('v.BaglantiResponse')));
        
        for(var i = 0; i < allBaglantiResult.etReturn.item.length; i++){
            if (allBaglantiResult.etReturn.item[i].SOZLESME_NO == sozlesmeNo){
                component.set("v.SelectedBaglantiCekDetay", allBaglantiResult.etReturn.item[i].CEK_DETAY);             
            }
        }
        
        component.set("v.showBaglantiCekDetay", true);
        helper.setBusy(component,false);
        window.scrollTo(0, 0);
    },
    hideBaglantiCekDetayPopUp : function(component, event, helper){
        component.set("v.showBaglantiCekDetay", false);
    },
    handlePDF : function(component, event, helper){
        helper.setBusy(component, true);
        var recordId = component.get("v.recordId");
        var selectedDistChannel = component.get("v.selectedDistChannel");
        var url = "/apex/" + "RC_CreditRiskPDF" + "?id=" + recordId + "&distChannel=" + selectedDistChannel;
        console.log("url: " + url);
        var useNavigate = true;
        helper.setBusy(component, true);
        if(useNavigate){
            helper.setBusy(component, true);
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": url,
                "isredirect": false
            });
            helper.setBusy(component, true);
            urlEvent.fire();
            helper.setBusy(component, true);
        }
    },
    downloadExcelIpotek: function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareIpotekData(component, event, helper);      
    },
    downloadExcelTeminat : function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareTeminatData(component, event, helper);      
    },
    downloadExcelTeminatIpotegi : function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareTeminatIpotegiData(component, event, helper);      
    },
    
    downloadExcelDtsKasaCeki: function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareDtsKasaCekiData(component, event, helper);      
    },
    downloadExcelYenilenecekTeminat: function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareYenilenecekTeminatData(component, event, helper);      
    },
    //cek senet detay modal 7 adet
    downloadExcelCekSenetDetay : function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareCekSenetDetayData(component, event, helper);      
    },
    
    //karşılıksız-çek senet modal 4 adet
        downloadExcelKarsiliksizCekSenet : function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareKarsiliksizCekSenetData(component, event, helper);      
    },
    
    downloadExcelBaglantiCekDetay : function (component, event, helper) {            
        helper.setBusy(component, true);
        
        helper.prepareBaglantiCekDetayData(component, event, helper);      
    },
})