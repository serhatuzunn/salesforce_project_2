import {
    LightningElement,
    track
} from 'lwc';

import {
    loadStyle
} from 'lightning/platformResourceLoader';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent'

import {
    deleteRecord
} from 'lightning/uiRecordApi';

import ChequeAndBondCSS from '@salesforce/resourceUrl/Check_And_Bond_Component';

import CSS from '@salesforce/resourceUrl/cashFlowCss';
import initComponent from '@salesforce/apex/RC_AssociatedChequeController.initComponent';
import searchData from '@salesforce/apex/RC_AssociatedChequeController.searchData';
import saveAsDraft from '@salesforce/apex/RC_AssociatedChequeController.saveAsDraft';
import getHistory from '@salesforce/apex/RC_AssociatedChequeController.getHistory';

export default class Rc_associatedcheque extends LightningElement {
    // Combobox Options and Selected Values
    @track krediKontrolVal = 'all';
    krediKontrolOptions;
    @track baglantiDonemVal = 'all';
    baglantiDonemOptions;
    @track bayiVal = 'all';
    bayiOptions;
    @track odemeKosulOptions;
    @track totalAmount = 0;
    @track totalMaturity;
    @track paramPositive;
    @track paramNegative;
    @track historyBayiInfo = '';
    @track addEntryBayiInfo = '';

    @track openPermissionModal = false;
    @track showHistoryModal = false;
    @track showBayiBordroModal = false;
    @track showAddExtraEntry = false;
    @track showSpinner = false;
    @track showMainDataTable = false;

    @track deleteRecordId = '';

    sourceResultList = [];
    @track resultList = [];    
    @track bordroHistoryDataList = [];
    @track historyDataList = [];
    @track addExtraData;

    constructor() {
        super();
        this.showSpinner = true;
        initComponent()
            .then(data => {
                if (data != null) {
                    if (data.krediKontrol != null && data.krediKontrol.length > 0) {
                        this.krediKontrolOptions = data.krediKontrol;
                    }

                    if (data.baglantiDonem != null && data.baglantiDonem.length > 0) {
                        this.baglantiDonemOptions = data.baglantiDonem;
                    }

                    if (data.bayi != null && data.bayi.length > 0) {
                        this.bayiOptions = data.bayi;
                    }

                    if (data.odemeKosul != null && data.odemeKosul.length > 0) {
                        this.odemeKosulOptions = data.odemeKosul;
                    }

                    this.paramPositive = data.paramPositive;
                    this.paramNegative = data.paramNegative;

                    if (data.isSatisUzmani) {
                        this.handleSearchClick();
                        this.showSpinner = false;
                    } else {
                        this.showSpinner = false;
                    }
                }
            })
            .catch(error => {
                this.showSpinner = false;
                console.log(error);
            });
    }

    handleSaveClick(event) {
        this.showSpinner = true;
        let saveAsDraftList = new Array();
        let canCreatable = true;
        let message = '';
        let messageTitle = '';

        let draft = event.currentTarget.value == 'true' ? true : false;

        this.resultList.forEach((data) => {
            let childSaveList = data.childs.filter(q => q.isChecked);

            if (childSaveList != undefined && childSaveList != null && childSaveList.length > 0) {
                childSaveList.forEach((child) => {

                    if (child.tutar == 0) {
                        message += 'Tutar girişi zorunludur.';
                        canCreatable = false;
                    }

                    if (!child.cekVade) {
                        message += 'Vade tarihi girişi zorunludur.';
                        canCreatable = false;
                    }

                    if (child.cekVade < child.minVade || child.cekVade > child.maxVade) {
                        let min = child.minVade.split('-');
                        let max = child.maxVade.split('-')
                        message += 'Seçilen vade tarihi ' + min[2] + '.' + min[1] + '.' + min[0] + ' tarihinden küçük, ' + max[2] + '.' + max[1] + '.' + max[0] + ' tarihinden büyük olamaz.';
                        canCreatable = false;
                    }

                    if (!child.baglantiBaslangicTarih) {
                        message += 'Bağlantı başlangıç tarihi girişi zorunludur.';
                        canCreatable = false;
                    }

                    if (canCreatable)
                        saveAsDraftList.push(child);
                });
            }
        });

        if (!canCreatable) {
            this.showToast(message, messageTitle, 'warning');
            this.showSpinner = false;

            return;
        }

        if (saveAsDraftList.length <= 0) {
            this.showToast('Seçili kayıt bulunmamaktadır.', '', 'warning');
            this.showSpinner = false;

            return;
        }

        if (saveAsDraftList.length > 0 && canCreatable) {
            saveAsDraft({
                    saveList: saveAsDraftList,
                    isDraft: draft,
                    isExtra: false
                })
                .then(response => {
                    if (response.isSuccess) {
                        this.showToast(response.message, '', 'success');

                        this.handleSearchClick(event);
                    } else {
                        this.showToast(response.message, '', 'error');
                    }
                })
                .catch(e => {
                    this.showToast(e, '', 'error');
                }).
            finally(() => {
                this.handleSearchClick();
            });
        }
    }

    handleComboboxChange(event) {
        debugger;
        switch (event.currentTarget.name) {
            case 'krediKontrol':
                this.krediKontrolVal = event.currentTarget.value;
                break;
            case 'baglantiDonem':
                this.baglantiDonemVal = event.currentTarget.value;
                break;
            case 'bayi':
                this.bayiVal = event.currentTarget.value;
                break;
            case 'formOdemeKosul':
                let parentData = this.resultList.find(q => q.Id == event.currentTarget.dataset.parentId);

                if (parentData != null && parentData != undefined) {
                    parentData.childs.forEach((child) => {
                        let yeniOdemeKosul = child.odemeKosulOptions.find(q => q.value == event.currentTarget.value);
                        let eskiOdemeKosul = child.odemeKosulOptions.find(q => q.value == child.odemeKosul);

                        child.odemeKosul = event.currentTarget.value;

                        let calculatedVal = yeniOdemeKosul.code - eskiOdemeKosul.code
                        console.log('calculatedVal : ' + JSON.stringify(calculatedVal));

                        var from = child.cekVade.split('-');
                        var f = new Date(parseInt(from[0]), ((parseInt(from[1]) - 1) + calculatedVal), parseInt(from[2]));

                        child.cekVade = f.getFullYear() + '-' + ("0" + (f.getMonth() + 1)).slice(-2) + '-' + ("0" + f.getDate()).slice(-2);
                        child.minVade = f.getFullYear() + '-' + ("0" + (f.getMonth() + 1)).slice(-2) + '-' + ("0" + (f.getDate() + parseInt(this.paramNegative))).slice(-2);
                        child.maxVade = f.getFullYear() + '-' + ("0" + (f.getMonth() + 1)).slice(-2) + '-' + ("0" + (f.getDate() + parseInt(this.paramPositive))).slice(-2);
                    });
                }

                break;
            default:
                break;
        }
    }

    handleCheckBoxSelect(event) {
        let parentData = this.resultList.find(q => q.Id == event.currentTarget.dataset.parentId);

        if (parentData != null && parentData != undefined) {
            let childData = parentData.childs.find(q => q.Id == event.currentTarget.dataset.relatedId);

            if (childData != null && childData != undefined) {
                childData.isChecked = event.currentTarget.checked;

                this.sourceResultList = this.resultList;

                if (!event.currentTarget.checked) {
                    let allCheckInput = [...this.template.querySelectorAll('lightning-input')].find(input => input.name == 'AllCheck');
                    allCheckInput.checked = event.currentTarget.checked;
                } else {
                    let allSelectCheckBox = [...this.template.querySelectorAll('lightning-input')].filter(input => input.name == 'formCheckBox' && input.checked == false);

                    if (allSelectCheckBox != null && allSelectCheckBox != undefined && allSelectCheckBox.length == 0) {
                        let allCheckInput = [...this.template.querySelectorAll('lightning-input')].find(input => input.name == 'AllCheck');
                        allCheckInput.checked = event.currentTarget.checked;
                    }
                }
            }
        }
    }

    handleTextAreaSelect(event) {
        switch (event.currentTarget.name) {
            case 'formTextArea':
                let parentData = this.resultList.find(q => q.Id == event.currentTarget.dataset.parentId);

                if (parentData != null && parentData != undefined) {
                    let childData = parentData.childs.find(q => q.Id == event.currentTarget.dataset.relatedId);

                    if (childData != null && childData != undefined) {
                        childData.aciklama = event.currentTarget.value;
                    }
                }

                this.sourceResultList = this.resultList;

                break;
            case 'addExtraTextArea':
                this.addExtraData.aciklama = event.currentTarget.value;

                break;
            default:
                break;
        }
    }

    handleSearchClick(event) {
        this.showSpinner = true;
        let toggleParents = [...this.template.querySelectorAll('tr')].filter(element => element.dataset.key == 'ROOT');
        if (toggleParents != undefined) {
            toggleParents.forEach((element) => {
                element.style.display = 'none'
            });
        }

        let allOpenInput = [...this.template.querySelectorAll('lightning-input')].filter(input => input.type == 'checkbox');
        allOpenInput.forEach((cbx) => {
            cbx.checked = false;
        });

        let bayi = this.bayiVal == 'all' ? null : this.bayiVal;
        let kredi = this.krediKontrolVal == 'all' ? null : this.krediKontrolVal;
        let baglanti = this.baglantiDonemVal == 'all' ? null : this.baglantiDonemVal;

        searchData({
            bayiId: bayi,
            krediKontrolCode: kredi,
            baglantiDonemId: baglanti
        }).
        then(data => {
            if (data != undefined && data.resultList != undefined) {
                data.resultList.forEach((q) => {

                    q.header.ortVade = this.formatDate(q.header.ortVade);

                    let enteredChild = q.childs.find(child => child.onayDurum != undefined && child.onayDurum != null && child.onayDurum.length > 0);

                    if (enteredChild != undefined) {
                        q.childs.forEach((child) => {
                            child.cekVade = enteredChild.cekVade;
                            child.baseVade = enteredChild.baseVade;
                            child.minVade = enteredChild.minVade;
                            child.maxVade = enteredChild.maxVade;
                            child.odemeKosul = enteredChild.odemeKosul;
                            child.baseOdemeKosul = enteredChild.baseOdemeKosul;
                            child.baglantiBaslangicTarihFormatted = this.formatDate(child.baglantiBaslangicTarih);
                        });
                    }

                    q.childs.forEach((child) => {
                        child.odemeKosulOptions.sort((a, b) => (a.code > b.code) ? 1 : -1);
                    });
                });

                this.sourceResultList = data.resultList;
                this.resultList = data.resultList;
                this.totalAmount = data.genelTutar;
                this.totalMaturity = this.formatDate(data.genelOrtVade);
                this.showMainDataTable = true;
            } else {
                this.sourceResultList = new Array();
                this.resultList = new Array();
                this.totalAmount = 0;
                this.totalMaturity = null;
                this.showMainDataTable = false;
            }
            this.showSpinner = false;
        }).
        catch(error => {
            this.showSpinner = false;
            this.showMainDataTable = false;
            console.log('GOKHAN :::: ' + JSON.stringify(error));
        });
    }

    handleInputCurrencyChange(event) {
        switch (event.currentTarget.name) {
            case 'formInputCurrency':
                let parentData = this.resultList.find(q => q.Id == event.currentTarget.dataset.parentId);

                if (parentData != null && parentData != undefined) {
                    let childData = parentData.childs.find(q => q.Id == event.currentTarget.dataset.relatedId);

                    if (childData != null && childData != undefined) {
                        childData.tutar = event.currentTarget.value;
                    }
                }

                this.sourceResultList = this.resultList;

                break;
            case 'addExtraInputCurrency':
                this.addExtraData.tutar = event.currentTarget.value;
                break;
            default:
                break;
        }
    }

    handleDatePickerSelect(event) {
        switch (event.currentTarget.name) {
            case 'formDatePicker':
                let parentData = this.resultList.find(q => q.Id == event.currentTarget.dataset.parentId);

                if (parentData != null && parentData != undefined) {
                    parentData.childs.forEach((child) => {
                        let selectedDate = new Date(event.currentTarget.value);
                        let minDate = new Date(child.minVade);
                        let maxDate = new Date(child.maxVade);

                        if (selectedDate < minDate || selectedDate > maxDate) {
                            let min = child.minVade.split('-');
                            let max = child.maxVade.split('-');
                            let message = 'Seçilen vade tarihi ' + min[2] + '/' + min[1] + '/' + min[0] + ' tarihinden küçük, ' + max[2] + '/' + max[1] + '/' + max[0] + ' tarihinden büyük olamaz.';

                            event.currentTarget.value = child.cekVade;

                            this.showToast(message, '', 'warning');

                            return;
                        }

                        child.cekVade = event.currentTarget.value;
                    });
                }

                this.sourceResultList = this.resultList;

                break;
            case 'addExtraDatePicker':
                this.addExtraData.cekVade = event.currentTarget.value;
                break;
            default:
                break;
        }
    }

    handleDivClick(event) {
        var key = event.currentTarget.dataset.key;
        let toggleChild = [...this.template.querySelectorAll('tr')].find(element => element.dataset.parentId == key);

        if (toggleChild.style.display == 'none') {
            toggleChild.style.display = 'table-row';

            let iconElement = [...this.template.querySelectorAll('lightning-icon')].find(element => element.dataset.key == event.currentTarget.dataset.key && element.title == "headerIcon");
            iconElement.iconName = 'utility:chevrondown';
        } else {
            toggleChild.style.display = 'none';
            let iconElement = [...this.template.querySelectorAll('lightning-icon')].find(element => element.dataset.key == event.currentTarget.dataset.key && element.title == "headerIcon");
            iconElement.iconName = 'utility:chevronright';
            let allOpenInput = [...this.template.querySelectorAll('lightning-input')].find(input => input.name == 'AllOpen');
            allOpenInput.checked = false;
        }

        let allOpened = [...this.template.querySelectorAll('tr')].filter(element => element.style.display == 'none');
        if (allOpened != null && allOpened != undefined && allOpened.length == 0) {
            let allOpenInput = [...this.template.querySelectorAll('lightning-input')].find(input => input.name == 'AllOpen');
            allOpenInput.checked = true;
        }

        let parentId = new Array();
        let parentIdForReadableOnlyField = new Array();
        this.resultList.forEach((data) => {
            if (data.header.totalTutar > 0) {
                parentId.push(String(data.header.Id));
            }

            if (data.childs.filter(child => child.onayDurum != undefined && child.onayDurum != null && child.onayDurum.length > 0 && !child.onayDurum.includes('Taslak')).length > 0) {
                parentIdForReadableOnlyField.push(String(data.header.Id));
            }
        });

        if (parentId.length > 0) {
            let allTableRow = [...this.template.querySelectorAll('div')].filter(element => parentId.includes(element.dataset.parentId) && element.dataset.divType == 'ROW');

            if (allTableRow != undefined && allTableRow.length > 0) {
                allTableRow.forEach((element) => {
                    element.style.backgroundColor = 'gray';
                });
            }

            let allChildElement = [...this.template.querySelectorAll('lightning-input, lightning-combobox')].filter(element => parentIdForReadableOnlyField.includes(element.dataset.parentId) && (element.name == 'formOdemeKosul' || element.name == 'formDatePicker'));

            if (allChildElement != undefined && allChildElement.length > 0) {
                allChildElement.forEach((element) => {
                    element.disabled = true;
                });
            }
        }
    }

    handleDataButtonClick(event) {
        this.showSpinner = true;
        switch (event.target.value) {
            case 'bayiBordro':
                let parentDataHistory = this.resultList.find(q => q.header.Id == event.target.dataset.parentId);
                let childDataHistory = parentDataHistory.childs.find(q => q.Id == event.target.dataset.relatedId);

                getHistory({
                    accId: childDataHistory.bayiId,
                    bordroTip: childDataHistory.bordroType,
                    cariDonemId: childDataHistory.donemID,
                    kka: childDataHistory.krediKontrolID
                }).
                then(data => {
                    if (data != undefined && data != null && data.length > 0) {

                        this.historyBayiInfo = data[0].bayiInfo;

                        data.forEach((q) => {
                            q.ortalamaVade = this.formatDate(q.ortalamaVade);
                        });

                        this.bordroHistoryDataList = data;

                        this.showBayiBordroModal = true;
                    }

                    this.showSpinner = false;
                }).
                catch(error => {
                    this.showSpinner = false;
                    console.log('History Error : ' + error)
                });

                break;
            case 'history':
                let mainData = this.bordroHistoryDataList.find(q => q.entryId == event.target.dataset.relatedId);

                if (mainData != undefined && mainData.approvalHistory != undefined && mainData.approvalHistory.length > 0) {
                    mainData.approvalHistory.forEach((q) => {
                        q.CreatedDate = this.formatDate(q.CreatedDate.substr(0,10));
                    });

                    this.historyDataList = mainData.approvalHistory;
                    this.showHistoryModal = true;
                }

                this.showSpinner = false;
                break;
            case 'delete':
                let parentDataDelete = this.resultList.find(q => q.header.Id == event.target.dataset.parentId);
                let childDataDelete = parentDataDelete.childs.find(q => q.Id == event.target.dataset.relatedId);

                if (childDataDelete != undefined) {
                    this.deleteRecordId = childDataDelete.entityId;
                }

                this.openPermissionModal = true;

                this.showSpinner = false;
                break;
            case 'addEntry':
                let parentDataAddEntry = this.resultList.find(q => q.header.Id == event.target.dataset.parentId);
                let childDataAddEntry = parentDataAddEntry.childs.find(q => q.Id == event.target.dataset.relatedId);

                if (childDataAddEntry != undefined) {

                    this.addEntryBayiInfo = parentDataAddEntry.header.bayiNo + ' ' + parentDataAddEntry.header.bayiAd + ' ünvanlı bayinin tüm bordro tiplerinde ' + childDataAddEntry.tutar + ' TL\'lik ' + parentDataAddEntry.header.ortVade + ' ortalama vadeli bordrosu mevcuttur.';

                    var copiedData = JSON.parse(JSON.stringify(childDataAddEntry));
                    copiedData.tutar = 0;
                    copiedData.aciklama = '';
                    copiedData.entityId = '';
                    this.addExtraData = copiedData;

                    this.showAddExtraEntry = true;
                }
                this.showSpinner = false;

                break;
            case 'saveEntry':
                this.showSpinner = true;
                if (this.addExtraData.tutar == undefined || this.addExtraData.tutar <= 0) {
                    this.showToast('Tutar 0 dan büyük olmalıdır.', '', 'warning');
                    this.showSpinner = false;
                    return;
                }

                let saveDataList = new Array();
                saveDataList.push(this.addExtraData);

                saveAsDraft({
                    saveList: saveDataList,
                    isDraft: false,
                    isExtra: true
                }).
                then(data => {
                    if (data.isSuccess) {
                        this.showToast(data.message, '', 'success');

                        this.handleSearchClick(event);
                    } else {
                        this.showToast(data.message, '', 'error');
                    }
                    this.showSpinner = false;
                    this.showAddExtraEntry = false;
                }).
                catch(error => {
                    this.showSpinner = false;
                    console.log('Save Extra Error : ' + error);
                });

                break;
            default:
                this.showSpinner = false;
                break;
        }
    }

    handleDeleteRecord(event) {
        this.showSpinner = true;
        if (this.deleteRecordId != undefined && this.deleteRecordId != null && this.deleteRecordId.length > 0) {
            deleteRecord(this.deleteRecordId).
            then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Kayıt başarıyle silinmiştir.',
                        variant: 'success'
                    })
                );

                this.deleteRecordId = '';
                this.openPermissionModal = false;
                this.handleSearchClick(event);
                this.showSpinner = false;
            }).
            catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
                this.showSpinner = false;
            });
        }
    }

    handleMainCheckInput(event) {
        switch (event.currentTarget.name) {
            case 'AllOpen':
                let parentId = new Array();
                this.resultList.forEach((data) => {
                    if (data.header.totalTutar > 0) {
                        parentId.push(String(data.header.Id));
                    }
                });

                if (parentId.length > 0) {
                    let allTableRow = [...this.template.querySelectorAll('tr')].filter(element => parentId.includes(element.dataset.parentId) && element.dataset.divType == 'ROW');

                    if (allTableRow != undefined && allTableRow.length > 0) {
                        allTableRow.forEach((element) => {
                            element.style.backgroundColor = 'gray';
                        });
                    }
                }

                let toggleChild = [...this.template.querySelectorAll('tr')].filter(q => q.dataset.key == 'ROOT');

                toggleChild.forEach(element => {
                    if (event.target.checked) {
                        element.style.display = 'table-row';

                        let icons = [...this.template.querySelectorAll('lightning-icon')].filter(icon => icon.title == 'headerIcon');
                        icons.forEach((icon) => {
                            icon.iconName = 'utility:chevrondown';
                        });
                    } else {
                        element.style.display = 'none';

                        let icons = [...this.template.querySelectorAll('lightning-icon')].filter(icon => icon.title == 'headerIcon');
                        icons.forEach((icon) => {
                            icon.iconName = 'utility:chevronright';
                        });
                    }
                });
                break;
            case 'AllCheck':
                let inputs = [...this.template.querySelectorAll('lightning-input')].filter(q => q.name == 'formCheckBox');

                inputs.forEach((element) => {
                    element.checked = event.currentTarget.checked;
                });
                console.log('Child Selection Val : ' + event.currentTarget.checked);
                this.resultList.forEach((parent) => {
                    parent.childs.forEach((child) => {
                        console.log('Child Selection : ' + JSON.stringify(child));
                        child.isChecked = event.currentTarget.checked;
                    });
                });
                break;
            default:
                break;
        }
    }

    connectedCallback() {
        Promise.all([
            //loadScript(this, jQuery),
            loadStyle(this, CSS)
        ]).then(() => {

        }).catch(error => console.log(error));
    }

    showToast(msg, msgTitle, msgType) {
        const evt = new ShowToastEvent({
            title: msgTitle,
            message: msg,
            variant: msgType,
        });

        this.dispatchEvent(evt);
    }

    closeModal(event) {
        switch (event.target.dataset.key) {
            case 'bayiBordro':
                this.showBayiBordroModal = false;
                break;
            case 'permission':
                this.openPermissionModal = false;
                break;
            case 'addEntry':
                this.showAddExtraEntry = false;
                break;
            case 'history':
                this.showHistoryModal = false;
                break;
            default:
                break;
        }
    }

    formatDate(dateVal) {
        if (dateVal != undefined) {
            let splittedDate = dateVal.split('-');

            let result = splittedDate[2] + '.' + splittedDate[1] + '.' + splittedDate[0];

            return result
        }
    }

    renderedCallback() {
        loadStyle(this, ChequeAndBondCSS)
            .then()
            .catch(error => console.log(error));
    }
}