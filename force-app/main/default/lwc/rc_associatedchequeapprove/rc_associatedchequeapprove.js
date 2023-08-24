import {
    LightningElement,
    track
} from 'lwc';

import {
    loadStyle
} from 'lightning/platformResourceLoader';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

import CSS from '@salesforce/resourceUrl/cashFlowCss';

import initialize from '@salesforce/apex/RC_AssociatedChequeApproveController.initialize';
import getEntries from '@salesforce/apex/RC_AssociatedChequeApproveController.getEntries';
import getUserInfo from '@salesforce/apex/RC_AssociatedChequeApproveController.getUserInfo';
import handleApproveRejectProcess from '@salesforce/apex/RC_AssociatedChequeApproveController.handleApproveRejectProcess';


export default class rc_associatedchequeapprove extends LightningElement {
    //Filter Options
    @track uygulamaKanalOptions;
    @track cariDonemOptions;
    @track bayiKirilim = false;
    @track uygulamaKanal = 'all';
    @track cariDonem = 'all';
    @track selectedComment = '';

    //Main Infos
    @track anlikKullanici;
    @track kullaniciHiyerarsi;
    @track baglantiliKullanicilar;
    @track odemeKosullar;
    @track paymentForms;
    @track bordroTypes;
    @track satisUzmanlar;
    @track entrySourceList;

    krediKontrolLabelList;
    userKontrolMap;

    //Others
    @track showSpinner = false;
    @track showMainData = false;

    //Initialize
    constructor() {
        super();
        this.showSpinner = true;

        initialize().
        then(response => {
            this.uygulamaKanalOptions = new Array();
            this.cariDonemOptions = new Array();
            this.krediKontrolLabelList = new Array();

            let allOption = {
                label: 'Tümü',
                value: 'all'
            };

            this.uygulamaKanalOptions.push(allOption);
            this.cariDonemOptions.push(allOption);
            this.anlikKullanici = response.anlikKullanici;
            this.odemeKosullar = response.odemeKosul;
            this.paymentForms = response.paymentForm;
            this.bordroTypes = response.bordroTip;

            if (response.uygulamaKanal) {
                response.uygulamaKanal.forEach((data) => {
                    let isExistData = response.aggrList.find(q => q.RC_Credit_Control_Field__c == data.RC_KKA__c);

                    if (isExistData) {
                        let selectOption = {
                            label: data.RC_KKA__c + " - " + data.RC_KKA_Defination__c,
                            value: data.RC_KKA__c,
                            name: data.RC_KKA_Defination__c
                        };

                        this.uygulamaKanalOptions.push(selectOption);
                        this.krediKontrolLabelList.push(data.RC_KKA__c);
                    }
                });
            }

            if (response.baglantiDonem) {
                response.baglantiDonem.forEach((data) => {
                    let selectOption = {
                        label: data.RC_Payment_Form__c + " - " + data.RC_Comments__c,
                        value: data.Id
                    };

                    this.cariDonemOptions.push(selectOption);
                });
            }

            if (response.kullanicilar) {
                this.baglantiliKullanicilar = response.kullanicilar.kullanicilar;
                this.userKontrolMap = response.kullanicilar.userKKAMap;

                this.satisUzmanlar = [...new Set(response.kullanicilar.kullanicilar.filter(q => q.UserRole.DeveloperName == "Bayi_Satis_Uzmani").map(a => a.Id))];
            }
        }).
        catch(error => {
            console.log(error);
        }).
        finally(() => {
            this.showSpinner = false;
        });
    }

    // Filter Functions
    handleCheckbox(event) {
        this.showSpinner = true;
        switch (event.target.name) {
            case "bayiKirilim":
                this.bayiKirilim = event.currentTarget.checked;
                this.showSpinner = false;
                break;
            case "userCheckInput":
                this.handleDataSelectionProcess(event.currentTarget.dataset, event.currentTarget.checked);
                break;
            case "dataCheckInput":
                let datasetObject = event.currentTarget.dataset;

                let relatedUserData = this.kullaniciHiyerarsi.find(q => q.kullaniciID == datasetObject.parentId && q.uygulamaKanal == datasetObject.ukkey);

                if (relatedUserData) {
                    let relatedData = relatedUserData.dataList.find(q => q.Id == datasetObject.id);
                    relatedData.isChecked = event.currentTarget.checked;

                    let relatedSourceData = this.entrySourceList.find(q => q.Id == datasetObject.id);
                    relatedSourceData.isChecked = event.currentTarget.checked;

                    let isAllDataUnchecked = relatedUserData.dataList.filter(q => q.isChecked == true);

                    if (!isAllDataUnchecked) {
                        relatedUserData.isChecked = false;
                    }

                    this.recalculatedOrtVade();
                } else {
                    this.showSpinner = false;
                }
                break;
            default:
                break;
        }
    }

    handleCombobox(event) {
        switch (event.currentTarget.name) {
            case 'kanal':
                this.uygulamaKanal = event.currentTarget.value;
                break;
            case 'donem':
                this.cariDonem = event.currentTarget.value;
                break;
            default:
                console.log(event.currentTarget.name);
                break;
        }
    }

    handleSearch(event) {
        this.showSpinner = true;
        this.kullaniciHiyerarsi = new Array();

        getUserInfo({
            uygulamaKanal: this.uygulamaKanal,
            userIDList: this.satisUzmanlar
        }).
        then(response => {
            let satisUzmanList = [...new Set(response.map(q => q.RC_Sales_Expert__c))];

            return getEntries({
                uygulamaKanal: this.uygulamaKanal,
                cariDonem: this.cariDonem,
                salesExpert: satisUzmanList
            });
        }).
        then(response => {
            if (response && response.length > 0) {
                response.forEach((data) => {
                    data.isChecked = "true";
                });

                this.entrySourceList = response;

                this.krediKontrolLabelList.forEach((key) => {
                    let hl = 0;

                    let keyLabel = this.uygulamaKanalOptions.find(q => q.value == key);

                    for (let data of this.anlikKullanici) {
                        let childUsers = this.baglantiliKullanicilar.filter(q => q.ManagerId == data.Id);

                        let onayLevel = this.retrieveApproveLevel(data.UserRole.DeveloperName);

                        let relatedAllElemanList = [...new Set(this.baglantiliKullanicilar.filter(q => q.ManagerId == data.Id || q.RC_ManagerId_2__c == data.Id || q.Manager_3__c == data.Id || q.Manager_4__c == data.Id).map(a => a.Id))];

                        let calculatedVal = this.calculateOrtVade(this.entrySourceList.filter(q => q.RC_KKA__c == keyLabel.value && q.RC_Approval_Status__c <= onayLevel && relatedAllElemanList.includes(q.CreatedById)), onayLevel);

                        let approvableDataExist = this.entrySourceList.filter(q => q.RC_KKA__c == keyLabel.value && q.RC_Approval_Status__c == onayLevel && (q.CreatedBy.ManagerId == data.Id || q.CreatedBy.RC_ManagerId_2__c == data.Id || q.CreatedBy.Manager_3__c == data.Id || q.CreatedBy.Manager_4__c == data.Id));

                        const kullanici = {
                            kullaniciAd: data.Name,
                            kullaniciID: data.Id,
                            uygulamaKanal: keyLabel.value,
                            uygulamaKanalLabel: keyLabel.name,
                            hierarchyLevel: hl,
                            ol: onayLevel,
                            parentID: 'ROOT',
                            dataGoster: true,
                            hierarchyLevelClass: this.retrieveHieararcyLevelClass(hl),
                            backgroundClass: approvableDataExist && approvableDataExist.length > 0 ? 'redBack' : 'transparentBack',
                            totalAmount: calculatedVal.totalAmount,
                            onaylananTotalAmount: calculatedVal.onaylananTotalAmount,
                            totalOrtVade: calculatedVal.totalOrtVade,
                            onaylananOrtVade: calculatedVal.onaylananOrtVade,
                            showBayiKirilim: false,
                            isChildExist: childUsers != undefined && childUsers.length > 0 ? true : false,
                            isSatisUzmani: false,
                            isBayi: false,
                            isChecked: true,
                            showDataList: false
                        };

                        this.kullaniciHiyerarsi.push(kullanici);
                        this.groupUsers(data.Id, childUsers, this.baglantiliKullanicilar, hl + 1, keyLabel, onayLevel);
                    }
                });
            }
        }).
        catch(error => {
            console.log(error);
        }).
        finally(() => {
            if (this.kullaniciHiyerarsi && this.kullaniciHiyerarsi.length > 0) {
                this.showMainData = true;
            } else {
                this.showMainData = false;
            }
            
            this.showSpinner = false;
        });
    }

    handleButtonClick(event) {
        this.showSpinner = true;
        let processableDataList = new Array();

        if (this.kullaniciHiyerarsi) {
            this.kullaniciHiyerarsi.forEach((mainData) => {
                if (mainData.isSatisUzmani) {
                    if (mainData.dataList) {
                        let foundedDataList = mainData.dataList.filter(q => q.isChecked);

                        if (foundedDataList) {
                            processableDataList.push.apply(processableDataList, foundedDataList);
                        }
                    }
                }
            });
        }

        var jsonData = JSON.stringify(processableDataList);

        switch (event.target.name) {
            case "onay":
                if (processableDataList && processableDataList.length > 0) {
                    handleApproveRejectProcess({
                        operation: event.target.name,
                        message: this.selectedComment,
                        selectedDataList: jsonData
                    }).
                    then(data => {
                        if (data.isSuccess) {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    message: data.message,
                                    variant: 'success'
                                })
                            );
                        } else {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    message: data.message,
                                    variant: 'error'
                                })
                            );
                        }
                    }).
                    catch(err => {
                        console.log(err);
                    }).
                    finally(() => {
                        this.selectedComment = '';
                        this.handleSearch();
                    });
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: 'Seçili kayıt bulunmamaktadır.',
                            variant: 'warning'
                        })
                    );

                    this.showSpinner = false;
                }

                break;
            case "red":
                if (this.selectedComment != undefined && this.selectedComment.length > 0) {
                    if (processableDataList && processableDataList.length > 0) {
                        handleApproveRejectProcess({
                            operation: event.target.name,
                            message: this.selectedComment,
                            selectedDataList: jsonData
                        }).
                        then(data => {
                            if (data.isSuccess) {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        message: data.message,
                                        variant: 'success'
                                    })
                                );
                            } else {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        message: data.message,
                                        variant: 'error'
                                    })
                                );
                            }
                        }).
                        catch(err => {
                            console.log(err);
                        }).
                        finally(() => {
                            this.selectedComment = '';
                            this.handleSearch();
                        });
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                message: 'Seçili kayıt bulunmamaktadır.',
                                variant: 'warning'
                            })
                        );

                        this.showSpinner = false;
                    }
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: 'Red durumunda açıklama giriniz.',
                            variant: 'warning'
                        })
                    );

                    this.showSpinner = false;
                }

                break;
            default:
                break;
        }
    }

    //Helper Functions
    handleDataSelectionProcess(datasetObject, value) {
        try {
            this.changeDataCheckValueRecursively(datasetObject, undefined, value);
        } catch (error) {
            console.log('handleDataSelectionProcess error : ' + JSON.stringify(error));
        } finally {
            this.showSpinner = false;
        }
    }

    changeDataCheckValueRecursively(datasetObject, parentDataIDlist, value) {
        let sourceIDList = undefined;

        if (parentDataIDlist != undefined) {
            sourceIDList = parentDataIDlist;
        } else {
            sourceIDList = new Array();
            sourceIDList.push(datasetObject.id);
        }

        if (sourceIDList.length > 0) {
            let relatedDataList = this.kullaniciHiyerarsi.filter(q => q.uygulamaKanal == datasetObject.ukkey && sourceIDList.includes(q.kullaniciID));

            if (relatedDataList) {
                relatedDataList.forEach((data) => {
                    data.isChecked = value;

                    if (data.isSatisUzmani) {
                        if (data.isDataExist) {
                            data.dataList.forEach((q) => {
                                q.isChecked = value;
                            });
                        }
                    }
                });

                let parentIDSet = [...new Set(this.kullaniciHiyerarsi.filter(q => q.uygulamaKanal == datasetObject.ukkey && sourceIDList.includes(q.parentID)).map(q => q.kullaniciID))];

                this.changeDataCheckValueRecursively(datasetObject, parentIDSet, value);
            }
        } else {
            this.recalculatedOrtVade();
        }
    }

    recalculatedOrtVade() {
        this.kullaniciHiyerarsi.forEach((data) => {
            let relatedAllElemanList = new Set();
            
            if (data.isBayiParent) {
                relatedAllElemanList = [...new Set(this.baglantiliKullanicilar.filter(q => q.Id == data.kullaniciID).map(a => a.Id))];
            } else if (!data.isSatisUzmani) {
                relatedAllElemanList = [...new Set(this.baglantiliKullanicilar.filter(q => q.ManagerId == data.kullaniciID || q.RC_ManagerId_2__c == data.kullaniciID || q.Manager_3__c == data.kullaniciID || q.Manager_4__c == data.kullaniciID).map(a => a.Id))];
            }
            
            if ((relatedAllElemanList && relatedAllElemanList.length > 0) || data.isBayi) {
                let sourceDataList = new Array();

                if(data.isSatisUzmani && data.isBayi){
                    sourceDataList = data.dataList;
                }
                else{
                    sourceDataList = this.entrySourceList.filter(q => q.RC_KKA__c == data.uygulamaKanal && relatedAllElemanList.includes(q.CreatedById));
                }
                
                let calculatedVal = this.calculateOrtVade(sourceDataList, data.ol);

                data.totalAmount = calculatedVal.totalAmount;
                data.onaylananTotalAmount = calculatedVal.onaylananTotalAmount;
                data.totalOrtVade = calculatedVal.totalOrtVade;
                data.onaylananOrtVade = calculatedVal.onaylananOrtVade;
            }
        });

        this.showSpinner = false;
    }

    groupUsers(parentId, dataList, mainDataList, hl, keyLabel, onayLevel) {
        for (let data of dataList) {
            let childUsers = mainDataList.filter(q => q.ManagerId == data.Id);

            let relatedAllElemanList = new Set();

            if (data.UserRole.DeveloperName != 'Bayi_Satis_Uzmani') {
                relatedAllElemanList = [...new Set(this.baglantiliKullanicilar.filter(q => q.ManagerId == data.Id || q.RC_ManagerId_2__c == data.Id || q.Manager_3__c == data.Id || q.Manager_4__c == data.Id).map(a => a.Id))];
            } else {
                relatedAllElemanList = [...new Set(this.baglantiliKullanicilar.filter(q => q.Id == data.Id).map(a => a.Id))];
            }

            let calculatedVal = this.calculateOrtVade(this.entrySourceList.filter(q => q.RC_KKA__c == keyLabel.value && q.RC_Approval_Status__c <= onayLevel && relatedAllElemanList.includes(q.CreatedById)), onayLevel);

            let approvableDataExist = this.entrySourceList.filter(q => q.RC_KKA__c == keyLabel.value && q.RC_Approval_Status__c == onayLevel && (q.CreatedBy.ManagerId == data.Id || q.CreatedBy.RC_ManagerId_2__c == data.Id || q.CreatedBy.Manager_3__c == data.Id || q.CreatedBy.Manager_4__c == data.Id));

            const kullanici = {
                kullaniciAd: data.Name,
                kullaniciID: data.Id,
                parentID: parentId,
                hierarchyLevel: hl,
                ol: onayLevel,
                dataGoster: false,
                uygulamaKanal: keyLabel.value,
                uygulamaKanalLabel: keyLabel.name,
                hieararcyLevelClass: this.retrieveHieararcyLevelClass(hl),
                backgroundClass: approvableDataExist && approvableDataExist.length > 0 ? 'redBack' : 'transparentBack',
                totalAmount: calculatedVal.totalAmount,
                onaylananTotalAmount: calculatedVal.onaylananTotalAmount,
                totalOrtVade: calculatedVal.totalOrtVade,
                onaylananOrtVade: calculatedVal.onaylananOrtVade,
                isChildExist: childUsers != undefined && childUsers.length > 0 ? true : false,
                isSatisUzmani: true,
                isBayi: false,
                showBayiKirilim: false,
                isChecked: true,
                showDataList: false
            };

            let dataList = new Array();
            if (data.UserRole.DeveloperName == 'Bayi_Satis_Uzmani') {
                dataList = this.entrySourceList.filter(q => q.RC_KKA__c == keyLabel.value && relatedAllElemanList.includes(q.CreatedById) && q.RC_Approval_Status__c <= onayLevel);
                let onayApproveDataList = this.entrySourceList.filter(q => q.RC_KKA__c == keyLabel.value && relatedAllElemanList.includes(q.CreatedById) && q.RC_Approval_Status__c == onayLevel);

                if (dataList) {
                    dataList.forEach((q) => {
                        let relatedDataList = this.entrySourceList.filter(a => a.RC_KKA__c == keyLabel.value && a.RC_Account__r.RC_SAP_ID__c == q.RC_Account__r.RC_SAP_ID__c && a.RC_Term_ID__r.RC_Payment_Form__c == q.RC_Term_ID__r.RC_Payment_Form__c && a.RC_Bordro_Types__c == q.RC_Bordro_Types__c && relatedAllElemanList.includes(q.CreatedById));

                        let relatedBordro = this.bordroTypes.find(a => a.RC_Bordro_Types__c == q.RC_Bordro_Types__c);

                        let relatedTotalTutar = 0;
                        relatedDataList.forEach((b) => {
                            relatedTotalTutar += b.RC_Amount__c
                        });
                        q.bordroTipDef = relatedBordro.RC_Bordro_Types__c + ' - ' + relatedBordro.RC_Bordro_Type_Definations__c;
                        q.calcAmount = relatedTotalTutar;
                        q.odemeKosul = this.odemeKosullar.find(kosul => kosul.Id == q.RC_Payment_Term__c).RC_Payment_Term__c;
                        q.paymentFormDesc = this.paymentForms.find(form => (form.RC_Fiscal_Year__c + form.RC_Payment_Form__c) == q.RC_Term_ID__r.RC_Payment_Form__c).RC_Comments__c;
                        q.backgroundClass = q.RC_Approval_Status__c < onayLevel ? 'transparentBack' : 'redBack';
                        q.canApproveItem = q.RC_Approval_Status__c < onayLevel ? false : true;
                        q.bayiInfo = q.RC_Account__r.RC_SAP_ID__c + ' - ' + q.RC_Account__r.Name;
                    });
                }

                kullanici.isBayiParent = true;
                kullanici.isSatisUzmani = true;
                kullanici.isDataExist = kullanici.dataList && kullanici.dataList.length > 0 ? true : false;
                kullanici.backgroundClass = onayApproveDataList && onayApproveDataList.length > 0 ? 'redBack' : 'transparentBack';
                kullanici.showDataList = kullanici.isDataExist && this.bayiKirilim ? true : false;
            }

            let foundedKey = this.userKontrolMap.find(q => q.includes(data.Id) && q.includes(keyLabel.value + '-'));

            if (foundedKey) {
                let satisUzmani = kullanici.isSatisUzmani;
                kullanici.isSatisUzmani = false;
                this.kullaniciHiyerarsi.push(kullanici);

                if (satisUzmani && dataList != undefined && dataList.length > 0) {
                    let mappedData = new Map();

                    dataList.forEach((q) => {
                        if (mappedData.has(q.bayiInfo)) {
                            let relatedList = mappedData.get(q.bayiInfo);
                            relatedList.push(q);
                            mappedData.set(q.bayiInfo, relatedList);
                        } else {
                            let relatedList = new Array();
                            relatedList.push(q);
                            mappedData.set(q.bayiInfo, relatedList);
                        }
                    });

                    for (const [k, v] of mappedData) {
                        let calculatedValForBayi = this.calculateOrtVade(v, onayLevel);

                        v.sort((curr, prev) => curr.RC_IsExtra__c - prev.RC_IsExtra__c);
                        let bayiOnayApprove = v.filter(q => q.RC_Approval_Status__c == onayLevel);

                        const bayiKullanici = {
                            kullaniciAd: k,
                            kullaniciID: k,
                            parentID: kullanici.kullaniciID,
                            hierarchyLevel: hl,
                            ol: onayLevel,
                            dataGoster: false,
                            uygulamaKanal: keyLabel.value,
                            uygulamaKanalLabel: keyLabel.name,
                            hieararcyLevelClass: this.retrieveHieararcyLevelClass(6),
                            backgroundClass: bayiOnayApprove && bayiOnayApprove.length > 0 ? 'redBack' : 'transparentBack',
                            totalAmount: calculatedValForBayi.totalAmount,
                            onaylananTotalAmount: calculatedValForBayi.onaylananTotalAmount,
                            totalOrtVade: calculatedValForBayi.totalOrtVade,
                            onaylananOrtVade: calculatedValForBayi.onaylananOrtVade,
                            isChildExist: true,
                            isSatisUzmani: true,
                            isBayi: true,
                            showBayiKirilim: false,
                            isChecked: true,
                            showDataList: true,
                            dataList: v,
                            isDataExist : v && v.length > 0 ? true : false
                        };

                        this.kullaniciHiyerarsi.push(bayiKullanici);
                    }
                }

                this.groupUsers(data.Id, childUsers, mainDataList, hl + 1, keyLabel, onayLevel);
            } else {
                this.groupUsers(data.Id, childUsers, mainDataList, hl + 1, keyLabel, onayLevel);
            }
        }
    }

    calculateOrtVade(dataList, onayLevel) {
        let calculatedData = new Object();

        var keyDate = new Date(new Date().getFullYear(), '01', '01');
        keyDate.setHours(0);
        keyDate.setMinutes(0);
        keyDate.setSeconds(0);
        keyDate.setMilliseconds(0);

        if (dataList) {
            let totalAmount = 0;
            let onaylananTotalAmount = 0;
            let totalOrtVadeAdat = 0;
            let onaylananOrtVadeAdat = 0;

            dataList.forEach((data) => {
                if (data.isChecked) {
                    const vade = new Date(data.RC_Average_Due_Date__c);
                    vade.setHours(0);
                    vade.setMinutes(0);
                    vade.setSeconds(0);
                    vade.setMilliseconds(0);

                    const diffDays = Math.ceil((vade - keyDate) / (1000 * 60 * 60 * 24));

                    if (data.RC_Approval_Status__c == onayLevel) {
                        totalAmount += data.RC_Amount__c;
                        totalOrtVadeAdat += diffDays * data.RC_Amount__c;
                    } else {
                        onaylananOrtVadeAdat += diffDays * data.RC_Amount__c;
                        onaylananTotalAmount += data.RC_Amount__c;
                        totalAmount += data.RC_Amount__c;
                        totalOrtVadeAdat += diffDays * data.RC_Amount__c;
                    }
                }
            });

            calculatedData.totalAmount = totalAmount;
            calculatedData.onaylananTotalAmount = onaylananTotalAmount;

            if (totalAmount > 0) {
                var result = new Date(keyDate);

                result.setDate(result.getDate() + (totalOrtVadeAdat / totalAmount));

                calculatedData.totalOrtVade = result;
            } else {
                calculatedData.totalOrtVade = null;
            }

            if (onaylananOrtVadeAdat > 0) {
                var result = new Date(keyDate);

                result.setDate(result.getDate() + (onaylananOrtVadeAdat / onaylananTotalAmount));

                calculatedData.onaylananOrtVade = result;
            } else {
                calculatedData.onaylananOrtVade = null;
            }
        }

        return calculatedData;
    }

    retrieveApproveLevel(roleName) {
        switch (roleName) {
            case 'Bayi_Satis_Muduru_Satis_Sorumlusu':
                return '4';
            case 'Bayi_Bolge_Muduru':
                return '3';
            case 'Bayi_Genel_Mudur_Yardimcisi':
                return '2';
            default:
                return '5';
        }
    }

    retrieveHieararcyLevelClass(hl) {
        switch (hl) {
            case 1:
                return 'hierarcyOne';
            case 2:
                return 'hierarcyTwo';
            case 3:
                return 'hierarcyThree';
            case 4:
                return 'hierarcyFour';
            case 5:
                return 'hierarcyFive';
            case 6:
                return 'hierarcySix';
            default:
                return '';
        }
    }

    handleDivClick(event) {
        var datasetObject = event.currentTarget.dataset;

        if (datasetObject.isSatisUzmani == 'false')
            this.closeDataShow(datasetObject.id, datasetObject.ukkey, false);
        else {
            if (this.bayiKirilim)
                this.checkShowedDataListStatus(datasetObject.id, datasetObject.ukkey);
        }
    }

    handleComment(event) {
        this.selectedComment = event.currentTarget.value.trim();
    }

    closeDataShow(objID, uk, isChild) {
        let processData = this.kullaniciHiyerarsi.filter(q => q.parentID == objID && q.uygulamaKanal == uk);

        processData.forEach((data) => {
            if (isChild) {
                if (data.dataGoster) {
                    this.closeDataShow(data.kullaniciID, data.uygulamaKanal, true);

                    data.dataGoster = false;
                }
            } else {
                if (data.dataGoster) {
                    this.closeDataShow(data.kullaniciID, data.uygulamaKanal, true);

                    data.dataGoster = false;
                } else {
                    data.dataGoster = true;
                }
            }
        });
    }

    checkShowedDataListStatus(objID, uk) {
        let processData = this.kullaniciHiyerarsi.filter(q => q.kullaniciID == objID && q.uygulamaKanal == uk);

        processData.forEach((q) => {
            if (q.showBayiKirilim) {
                q.showBayiKirilim = false;
            } else {
                q.showBayiKirilim = true;
            }
        });
    }

    //System Functions
    connectedCallback() {
        Promise.all([
            loadStyle(this, CSS)
        ]).then(() => {

        }).catch(error => console.log(error));
    }

    renderedCallback() {
        //Checkbox Data Preparation
        if (this.kullaniciHiyerarsi) {
            this.kullaniciHiyerarsi.forEach((k) => {
                let relatedUserCheckbox = [...this.template.querySelectorAll('lightning-input')].filter(input => input.name == 'userCheckInput' && input.dataset.ukkey == k.uygulamaKanal && input.dataset.id == k.kullaniciID);

                if (relatedUserCheckbox) {
                    relatedUserCheckbox.forEach((element) => {
                        element.checked = k.isChecked;
                    });

                    if (k.isSatisUzmani) {
                        if (k.dataList) {
                            k.dataList.forEach((d) => {
                                let relatedDataCheckbox = [...this.template.querySelectorAll('lightning-input')].filter(input => input.name == 'dataCheckInput' && input.dataset.ukkey == d.RC_KKA__c && input.dataset.id == d.Id);

                                relatedDataCheckbox.forEach((element) => {
                                    element.checked = d.isChecked;
                                });
                            });
                        }
                    }
                }
            });
        }
    }
}