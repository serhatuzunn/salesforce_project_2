import { LightningElement, api, track,wire } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import ChequeAndBondCSS from '@salesforce/resourceUrl/Check_And_Bond_Component';

import { refreshApex } from '@salesforce/apex';
import GetControlChequeAndBond from '@salesforce/apex/RC_ControlChequeAndBond.GetControlChequeAndBond'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBordroList from '@salesforce/apex/RC_CreateChequeAndBond.getBordroList';
import getBordroRelatedCheques from '@salesforce/apex/RC_ControlChequeAndBond.getBordroRelatedCheques';
import initializeOdemePlan from '@salesforce/apex/RC_CreateChequeAndBond.initializeOdemePlan';
import calculatePlan from '@salesforce/apex/RC_CreateChequeAndBond.calculatePlan';
import processPaymentPlan from '@salesforce/apex/RC_CreateChequeAndBond.processPaymentPlan';
import deleteOdemePlan from '@salesforce/apex/RC_CreateChequeAndBond.deleteOdemePlan';
import calculateGeneralInfo from '@salesforce/apex/RC_CreateChequeAndBond.calculateGeneralInfo';
import checkPlan from '@salesforce/apex/RC_CreateChequeAndBond.checkPlan';
import deleteCheque from '@salesforce/apex/RC_CreateChequeAndBond.deleteCheque';
import getBankInfosByCity from '@salesforce/apex/RC_CreateChequeAndBond.getBankInfosByCity';
import getDocType from '@salesforce/apex/RC_ControlChequeAndBond.fillDocType';
import fillBaglantiDonem from '@salesforce/apex/RC_ControlChequeAndBond.fillBaglantiDonem';
import fillBordroStatus from '@salesforce/apex/RC_ControlChequeAndBond.fillBordroStatus';
import fillKKA from '@salesforce/apex/RC_ControlChequeAndBond.fillKKA';
import updateStatusBordroAndCheque from '@salesforce/apex/RC_ControlChequeAndBond.updateStatusBordroAndCheque';
import bordroCekGirSAP from '@salesforce/apex/RC_ControlChequeAndBond.bordroCekGirSAP';
import getStatus from '@salesforce/apex/RC_CreateChequeAndBond.getStatus';

const actions = [{
    label: 'Bordroya Bağlı Çekleri Göster',
    name: 'showCheque',
    iconName: 'utility:info',
}];

const actionsForCheque = [ 
{
    label: 'Detay',
    name: 'chequeDetail',
    iconName: 'utility:info',
} 
];

export default class RC_ControlChequeAndBond extends LightningElement {    
    @track objDocType;
    @track objBordroStatu;
    @track objBaglantiDonem;
    @track objCreditControl;
    

    @api hidefilter = false;
    @api passedbordro;

    
    @track loaded = false;
    @track bordroStatu = null;
    @track bordroStatuClosing = null;
    @track docType = null;
    @track baglantiDonem = null;
    @track creditControl = null;

    // Input Properties
    selectedBayiId = '';
    selectedBayiIdClosing ='';
    @track typeIsCheque = true;
    @track selectedChequeType;
    @track showAllChequeField = false;
    @track isChequeTypeReadonly = false;

    @track selectedCityId = '';
    @track selectedChequeType;
    @track selectedChequeId = '';
    @track isChequeReadonly = false;
    @track showBankList = false;
    @track showTopluCekEkleModal = false;

    @track ShowOnayGonder = false;
    @track showSendSAP = false;
    @track showReject = false;

    @track selectedChequeNum;
    @track selectedIdentificationNum = '';
    @track selectDrawerReg = '';
    @track selectedBankAccNum = '';
    @track relatedDueDate = '';
    @track relatedAmount = '';
    @track relatedBayiCode = '';
    @track selectedCityName = '';
    @track isReadonly = false;
    selectedPortfolio = 'Merkez Çek Portföyü TRL';

    //For custom lookup field
    fields = ["Name", "RC_SAP_ID__c"];
    displayFields = "Name, RC_SAP_ID__c";

    //Datatable Columns
    mainBordroColumns = [];
    mainBordroColumnsClosing = [];
    chequeColumns = [];
    @track chequeList = [];
    @track status;
    @track chequeTypes = [];

    // Modal Properties 
    @track showChequeDatatable = false;
    @track showChequeModal = false;
    @track showChequeAddModal = false;


    bordroId;
     //Only Showed Properties
     @track bordroTutar;
     @track bordroVade;
     @track girilenTutar;
     @track girilenVade;
     @track hesaplananTutar;
     @track hesaplananVade;
     @track farkTutar;
     @track farkVade;
    

    constructor() {
        super();
        getStatus().
        then(data => {
            this.status = data;
            this.chequeTypes = data.chequeTypes;
        }).catch();

        this.mainBordrocolumns = [
            {
                label: 'Dönem',
                fieldName: ''
            },
            {
                label: 'Bordro No',
                fieldName: 'RC_Bordro_No__c'
            },
            {
                label: 'Bayi No',
                fieldName: 'RC_Dealer_Number__c'
            },
            {
                label: 'Kredi Kontrol Alanı',
                fieldName: ''
            },
            {
                label: 'Belge Türü',
                fieldName: 'bordroType'
            },
            {
                label: 'Durum',
                fieldName: 'statusVal'
            },
            {
                label: 'Ort. Vade',
                fieldName: 'RC_Average_Due_Date__c',
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit'
                }
            },
            {
                label: 'Bakiye',
                fieldName: 'RC_Amount__c',
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'TRY',
                    step: '0.01'
                }
            },
            {
                label: 'Bordro Olusturma Tarih',
                fieldName: 'CreatedDate',
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit'
                }
            },
            // {
            //     label: 'Durum',
            //     fieldName: 'RC_Bordro_Status_ID__c'
            // },
            {
                label: 'Satış Uzmanına Gönd. Tarih',
                fieldName: 'CreatedDate',
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit'
                }
            },            
            {
                label:'',
                type: 'action',
                typeAttributes: {
                    rowActions: this.getRowActions
                }
            }
        ];

        this.mainBordrocolumnsClosing = [            
            {
                label: 'Bordro No',
                fieldName: 'RC_Bordro_No__c'
            },
            {
                label: 'Bayi No',
                fieldName: 'RC_Dealer_Number__c'
            },
            {
                label: 'Bayi Adı',
                fieldName: ''
            },
            {
                label: 'Belge Türü',
                fieldName: 'bordroType'
            },
            {
                label: 'Durum',
                fieldName: 'statusVal'
            },
            {
                label: 'Ort. Vade',
                fieldName: 'RC_Average_Due_Date__c',
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit'
                }
            },
            {
                label: 'Bakiye',
                fieldName: 'RC_Amount__c',
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'TRY',
                    step: '0.01'
                }
            },
            {
                label: 'Bordro Olusturma Tarih',
                fieldName: 'CreatedDate',
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit'
                }
            },
            // {
            //     label: 'Durum',
            //     fieldName: 'RC_Bordro_Status_ID__c'
            // },
            {
                label: 'Satış Uzmanına Gönd. Tarih',
                fieldName: 'CreatedDate',
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit'
                }
            },            
            {
                label:'',
                type: 'action',
                typeAttributes: {
                    rowActions: this.getRowActions
                }
            }
        ];


        getDocType().then(data => {
            this.objDocType = data;            
        }).catch(error => {
            this.displayError('getDocType', error);
            this.loaded = false;
        });

        fillBordroStatus().then(data => {
            this.objBordroStatu = data;
            this.BordroStatusOptionsClosing=data;         
        }).catch(error => {
            this.displayError('fillBordroStatus', error);
            this.loaded = false;
        });

        fillBaglantiDonem().then(data => {
            this.objBaglantiDonem = data;     
        }).catch(error => {
            this.displayError('fillBaglantiDonem', error);
            this.loaded = false;
        });

        fillKKA().then(data => {
            this.objCreditControl = data;     
        }).catch(error => {
            this.displayError('fillKKA', error);
            this.loaded = false;
        });
    }

     // Modal Properties    
     @track showBordroDatatable = false;
     @track showBordroDatatableClosing = false;

    handleLookup(event) {
        this.selectedBayiId = event.detail.data.recordId;
    }

    handleLookupClosing(event){
        this.selectedBayiIdClosing = event.detail.data.recordId;
    }

    handleSearchBordroStatu(event){
        this.bordroStatu = event.detail.value;
    } 

    handleSearchBordroStatuClosing(event){
        this.bordroStatuClosing = event.detail.value;
    } 

    handleSearchDocType(event){
        this.docType = event.detail.value;
    } 
    handleSearchBaglantiDonem(event){
        this.baglantiDonem = event.detail.value;
    } 

    handleCreditControl(event){
        this.creditControl = this.objCreditControl.find(opt => opt.value === event.detail.value).label;
    } 

    handleSearch(){ 
        this.loaded = true;
        var message= '';
        if(message !='')
        {
            const event = new ShowToastEvent({
                title: 'Hata',
                message: message,
                mode:'sticky',
                variant:'Warning'

            });
            this.dispatchEvent(event); 
            this.loaded = false;
        }
        else{
            let selectedBayi = this.selectedBayiId;
            let selectedBordroStatu = this.bordroStatu;
            let selectedDocType = this.docType;
            let selectedBaglantiDonem = this.baglantiDonem;
            let selectedCreditControl = this.creditControl;

            GetControlChequeAndBond({
                bayiId: selectedBayi,
                bordroStatu: selectedBordroStatu,
                docType: selectedDocType,
                baglantiDonem: selectedBaglantiDonem,
                creditControl: selectedCreditControl
            })
            .then(data => {
                if (data != undefined && data.length > 0) {
                    data.forEach((q) => {
                        q.statusVal = this.status.bordroStatus.find(a => a.value == q.RC_Bordro_Status_ID__c).label;
                    });

                    this.bordroList = data;
                    this.showBordroDatatable = true;
                    this.showBordroDatatableClosing = false;
                    this.loaded = false;
                }
                else{
                    this.bordroList = null;
                    this.showBordroDatatable = true;
                    this.showBordroDatatableClosing = false;
                    this.loaded = false;
                }
            })
            .catch(error => {
                this.displayError('GetControlChequeAndBond', error);
                this.loaded = false;
            });
        }
    
    }

    handleSearchClosing(){
        this.loaded = true;
        var message= '';
        if(message !='')
        {
            const event = new ShowToastEvent({
                title: 'Hata',
                message: message,
                mode:'sticky',
                variant:'Warning'

            });
            this.dispatchEvent(event); 
            this.loaded = false;
        }
        else{
            let selectedBayi = this.selectedBayiIdClosing;
            let selectedBordroStatu = this.bordroStatuClosing;
            let selectedDocType = '';
            let selectedBaglantiDonem = '';
            let selectedCreditControl = '';
            let accountClosing = '1';

            GetControlChequeAndBond({
                bayiId: selectedBayi,
                bordroStatu: selectedBordroStatu,
                docType: selectedDocType,
                baglantiDonem: selectedBaglantiDonem,
                creditControl: selectedCreditControl,
                accountClosing : accountClosing
            })
            .then(data => {
                if (data != undefined && data.length > 0) {
                    data.forEach((q) => {
                        q.statusVal = this.status.bordroStatus.find(a => a.value == q.RC_Bordro_Status_ID__c).label;
                    });
                    
                    this.bordroListClosing = data;
                    this.showBordroDatatable = false;
                    this.showBordroDatatableClosing = true;
                    this.loaded = false;
                }
                else{
                    this.bordroListClosing = null;
                    this.showBordroDatatable = false;
                    this.showBordroDatatableClosing = true;
                    this.loaded = false;
                }
            })
            .catch(error => {
                this.displayError('GetControlChequeAndBond', error);
                this.loaded = false;
            });
        }
    
    }


    getRowActions(row, doneCallback) {
        const actionList = [];

        actions.forEach(action => {
            
            if (action.name == 'showCheque' && row['Cheques__r'] != undefined) {
                actionList.push(action);
            }             
        });

        doneCallback(actionList);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        switch (actionName) {            
            case 'showCheque':
                console.debug('event.detail.row : ' + event.detail.row['Id']);
                this.bordroId = event.detail.row['Id'];
                this.showCheque(event);
                break;
            case 'chequeDetail':
                this.selectedChequeId = event.detail.row['Id'];

                let cheque = this.chequeList.find(q => q.Id == this.selectedChequeId);

                this.relatedAmount = cheque.RC_Amount__c;
                this.relatedDueDate = cheque.RC_Due_Date__c;
                this.selectedChequeNum = cheque.RC_Cheque_Number__c;
                this.selectedIdentificationNum = cheque.RC_Identification_Number__c;
                this.relatedBayiCode = cheque.RC_Account_No__c;

                if (cheque.RC_Cheque_Bill__c == 'Cheque') {
                    this.selectedBankKeyName = cheque.bankKey;
                    this.selectedCityId = cheque.RC_City__c;
                    this.selectedCityName = cheque.RC_City__r.Name;
                    this.selectDrawerReg = cheque.RC_Drawer_Region__c;
                    this.selectedBankAccNum = cheque.RC_Bank_Account_Number__c;

                    this.typeIsCheque = true;
                    this.selectedChequeType = 'Cheque';
                } else {
                    this.typeIsCheque = false;
                    this.selectedChequeType = 'Bill';
                }
                this.isReadonly = true;
                this.chequeModalTitle = 'Çek/Senet Detay';
                this.showAllChequeField = true;
                this.isChequeReadonly = true;
                this.isChequeTypeReadonly = true;
                this.showChequeAddModal = true;
                break;
            break;
                
        }
    }

    // Modal's Methods
    showCheque(event) {        
        getBordroRelatedCheques({
                selectedBordroId: this.bordroId
            })
            .then(data => {               
                if (data != null && data.length > 0) {
                    
                    this.chequeColumns = [{
                            label: 'Çek/Senet',
                            fieldName: 'RC_Cheque_Bill__c'
                        },
                        {
                            label: 'Çek/Senet No',
                            fieldName: 'RC_Cheque_Number__c'
                        },
                        {
                            label: 'Tarih',
                            fieldName: 'RC_Due_Date__c',
                            type: 'date-local',
                            typeAttributes: {
                                month: '2-digit',
                                day: '2-digit'
                            }
                        },
                        {
                            label: 'Tutar',
                            fieldName: 'RC_Amount__c',
                            type: 'currency',
                            typeAttributes: {
                                currencyCode: 'TRY',
                                step: '0.01'
                            }
                        },
                        {
                            label: 'TCKN',
                            fieldName: 'RC_Identification_Number__c'
                        },
                        {
                            label: 'Banka İli',
                            fieldName: 'cityName'
                        },
                        {
                            label: 'Şube Anahtarı',
                            fieldName: 'bankKey'
                        },
                        {
                            label: 'Banka Hesap Kodu',
                            fieldName: 'RC_Bank_Account_Number__c'
                        },
                        {
                            label: 'Keşide Yeri',
                            fieldName: 'RC_Drawer_Region__c'
                        },
                        {
                            label: 'Durum',
                            fieldName: 'statusVal'
                        },
                        {
                            type: 'action',
                            typeAttributes: {
                                rowActions: this.getRowActionsForCheque
                            }
                        }
                    ];

                    data.forEach((q) => {
                        if (q.RC_Cheque_Bill__c == 'Cheque' ||q.RC_Cheque_Bill__c == 'Bill' ) {
                            q.cityName = q.RC_City__r != undefined ? q.RC_City__r.Name : undefined;
                            q.bankKey = q.RC_Bank_Key__r != undefined ? (q.RC_Bank_Key__r.RC_BANKL__c + ' / ' + q.RC_Bank_Key__r.RC_BANK__c + ' / ' + q.RC_Bank_Key__r.RC_BRINCH__c) : undefined;
                        } else {
                            q.RC_Cheque_Number__c = q.RC_Bill_Number__c;
                        }

                        q.statusVal = this.status.cekStatus.find(a => a.value == q.RC_Check_Status_ID__c).label;
                    })

                    
                    this.chequeList = data;
                    this.relatedBayiCode = data[0].RC_Account_No__c;

                    this.typeIsCheque = data[0].RC_Cheque_Bill__c == "Cheque" ? true : false;
                    this.selectedChequeType = data[0].RC_Cheque_Bill__c;
                    this.showAllChequeField = true;
                    this.isChequeTypeReadonly = true;
                    this.showChequeDatatable = true;

                    
                    if(event.detail.row['RC_Bordro_Status_ID__c'] =='2'){
                        this.ShowOnayGonder = true;
                        this.showReject = true;
                        this.showSendSAP = true;
                    }
                    else if(event.detail.row['RC_Bordro_Status_ID__c'] =='3'){
                        this.ShowOnayGonder = false;
                        this.showReject = false;
                        this.showSendSAP = true;
                    }
                    else if(event.detail.row['RC_Bordro_Status_ID__c'] =='4'){
                        this.ShowOnayGonder = false;
                        this.showReject = false;
                        this.showSendSAP = false;
                    }

                } else {
                    this.showChequeDatatable = false

                    this.ShowOnayGonder = false;
                    this.showReject = false;
                    this.showSendSAP = false;
                }

                return calculateGeneralInfo({
                    selectedBordroId: this.bordroId,
                    paymentPlanList: null
                });
            })
            .then(data => {
                this.bordroTutar = data.bordroTutar;
                this.bordroVade = data.bordroVade;
                this.girilenTutar = data.girilenTutar;
                this.girilenVade = data.girilenVade;
                this.hesaplananTutar = data.hesaplananTutar;
                this.hesaplananVade = data.hesaplananVade;
                this.farkTutar = data.farkTutar;
                this.farkVade = data.farkVade;
            })
            .catch(error => {
                this.displayError('Get Cheque List', error);
            });

        this.showChequeModal = true;
    }

    showChequeModalAdd(event) {
        // if (this.selectedChequeType != undefined && this.selectedChequeType != '') {
        //     this.isChequeTypeReadonly = true;
        // }
        // this.showChequeAddModal = true;
        this.relatedAmount = 0;
        this.relatedDueDate = undefined;
        this.isReadonly = false;

        this.selectedChequeType = this.initialPlan.bordro.RC_Bordro_Type__c == 'C' ? undefined : this.initialPlan.bordro.RC_Bordro_Type__c == 'B' ? 'Cheque' : 'Bill';

        if (this.selectedChequeType) {
            this.showAllChequeField = true;
            this.isChequeTypeReadonly = true;

            if (this.selectedChequeType == 'Bill') {
                this.typeIsCheque = false;
            } else {
                this.typeIsCheque = true;
            }
        } else {
            this.showAllChequeField = false;
            this.isChequeTypeReadonly = false;
        }

        this.selectedBankKeyName = '';
        this.selectedChequeNum = '';
        this.selectedIdentificationNum = '';
        this.selectedDrawerReg = '';
        this.selectedBankAccNum = '';
        this.selectedCityId = '';
        this.selectedCityName = '';

        this.chequeModalTitle = 'Çek/Senet Ekle';

        this.showChequeAddModal = true;
    }

    getRowActionsForCheque(row, doneCallback) {
        const actionList = [];

        actionsForCheque.forEach(action => {
            // if(action.name == 'chequeDelete' && !row['RC_IsSent__c']){
            //     actionList.push(action);
            // }
            // else if(action.name == 'chequeUpdate' && !row['RC_IsSent__c']){
            //     actionList.push(action);
            // } else
            if(action.name == 'chequeDetail'){
                actionList.push(action);
            }
        });

        doneCallback(actionList);
    }

    closeChequeModal() {
        this.chequeList = [];
        this.showChequeModal = false;

        this.ShowOnayGonder = false;
        this.showReject = false;
        this.showSendSAP = false;
    }

    closeChequeAddModal() {
        this.selectedChequeId = '';
        this.isChequeReadonly = false;
        this.isChequeTypeReadonly = false;
        this.showChequeAddModal = false;
    }

    doneControl(event) {
        updateStatusBordroAndCheque({
            selectedBordroId: this.bordroId,
            statusID : '3'
        })
        .then(data => {                         
            if (data) {
                this.closeChequeModal();
                this.handleSearch();
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Kayıt başarıyla Kontrol Edildi durumuna çevrilmiştir.',
                        variant: 'success'
                    })
                );
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Kayıt güncellenirken hata oluştu.' + cw.message,
                        variant: 'success'
                    })
                );
            } 
        })
        .catch(error => {
            this.displayError('Get doneControl', error);
        });
    }

    sendRecordSAP(event) {
        bordroCekGirSAP({
            selectedBordroId: this.bordroId
        })
        .then(data => {               
            if (data.isSuccess) {                
                this.closeChequeModal();
                this.handleSearch();
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Ilgili Bordro belgesi başarılı bir şekilde SAP sistemine aktarılmıştır.',
                        variant: 'success'
                    })
                );

            }else{
                this.loaded = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Bordro SAP sistemine aktarılırken hata almıştır: '+data.message,
                        variant: 'error'
                    })
                );
            }
        })
        .catch(error => {
            this.loaded = false;
            this.displayError('sendRecordSAP', error);
        });
    }

    rejectRecord(event) {
        debugger;
        updateStatusBordroAndCheque({
            selectedBordroId: this.bordroId,
            statusID : '1'
        })
        .then(data => {                       
            if (data) {                
                this.closeChequeModal();
                this.handleSearch();
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Kayıt Reddedildi durumuna çevrilmiştir.',
                        variant: 'success'
                    })
                );
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Kayıt güncellenirken hata oluştu.' + cw.message,
                        variant: 'success'
                    })
                );
            } 
        })
        .catch(error => {
            this.displayError('Get rejectRecord', error);
        });
    }
    
    displayError(source, error) {
        this.error = '';
        if (Array.isArray(error.body)) {
            this.error = error.body.map(e => e.message).join(', ');
        } else if (typeof error.body.message === 'string') {
            this.error = error.body.message;
        }

        window.console.log('Source : ' + source);
        window.console.log('Error : ' + this.error);
    }

    handleClick(event) {        
        if(event.target.value === 'tab-1'){
            console.debug('tab-1 e girdi');
            this.showBordroDatatableClosing = false;
            this.showBordroDatatable = true;
        }else if(event.target.value === 'tab-2'){
            console.debug('tab-2 e girdi');
            this.showBordroDatatableClosing = true;
            this.showBordroDatatable = false;
        }
        else{
            console.debug('hiçbirine girmedi');
            this.showBordroDatatableClosing = false;
            this.showBordroDatatable = false;
        }       
    
    }

    handleFormChange(event) {
        let val = event.currentTarget.value;

        switch (event.currentTarget.name) {
            case 'chequeNumber':
                this.selectedChequeNum = val;
                break;
            case 'drawerRegion':
                this.selectDrawerReg = val;
                break;
            case 'bankAccNum':
                this.selectedBankAccNum = val;
                break;
            case 'identificationNumber':
                this.selectedIdentificationNum = val;
                break;
            case 'amount':
                this.relatedAmount = val;
                break;
            case 'dueDate':
                this.relatedDueDate = val;
                break;
            default:
                break;
        }
    }

    // Load Static Resources
    renderedCallback() {
        if (this.passedbordro != undefined) {
            this.bordroId = this.passedbordro;
            this.showCheque();
            this.passedbordro = undefined;
        }

        if (this.bordroTutar - this.girilenTutar > 0) {
            let odemePlanBtn = [...this.template.querySelectorAll('button')].find(q => q.name == 'odemePlanHazirla');

            if (odemePlanBtn)
                odemePlanBtn.style.display = 'inline';

            let onayBtn = [...this.template.querySelectorAll('button')].find(q => q.name == 'onayGonder');

            if (onayBtn)
                onayBtn.style.display = 'none';
        } 
        else if (this.bordroTutar - this.girilenTutar == 0) {
            let odemePlanBtn = [...this.template.querySelectorAll('button')].find(q => q.name == 'odemePlanHazirla');

            if (odemePlanBtn)
                odemePlanBtn.style.display = 'none';

            let onayBtn = [...this.template.querySelectorAll('button')].find(q => q.name == 'onayGonder');

            if (onayBtn)
                onayBtn.style.display = 'inline';
        }

        loadStyle(this, ChequeAndBondCSS)
            .then()
            .catch(error => console.log(error));
    }

}