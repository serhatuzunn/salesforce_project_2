import {
    LightningElement,
    track,
    api
} from 'lwc';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

import {
    loadStyle
} from 'lightning/platformResourceLoader';

import ChequeAndBondCSS from '@salesforce/resourceUrl/Check_And_Bond_Component';
import excelIcon from '@salesforce/resourceUrl/Excel_Icon';

import getBordroList from '@salesforce/apex/RC_CreateChequeAndBond.getBordroList';
import getBordroRelatedCheques from '@salesforce/apex/RC_CreateChequeAndBond.getBordroRelatedCheques';
import initializeOdemePlan from '@salesforce/apex/RC_CreateChequeAndBond.initializeOdemePlan';
import calculatePlan from '@salesforce/apex/RC_CreateChequeAndBond.calculatePlan';
import processPaymentPlan from '@salesforce/apex/RC_CreateChequeAndBond.processPaymentPlan';
import deleteOdemePlan from '@salesforce/apex/RC_CreateChequeAndBond.deleteOdemePlan';
import calculateGeneralInfo from '@salesforce/apex/RC_CreateChequeAndBond.calculateGeneralInfo';
import checkPlan from '@salesforce/apex/RC_CreateChequeAndBond.checkPlan';
import deleteCheque from '@salesforce/apex/RC_CreateChequeAndBond.deleteCheque';
import getBankInfosByCity from '@salesforce/apex/RC_CreateChequeAndBond.getBankInfosByCity';
import getRelatedInvoice from '@salesforce/apex/RC_CreateChequeAndBond.getRelatedInvoice';
import validateInput from '@salesforce/apex/RC_CreateChequeAndBond.validateInput';
import approve from '@salesforce/apex/RC_CreateChequeAndBond.approve';
import deleteBordro from '@salesforce/apex/RC_CreateChequeAndBond.deleteBordro';
import getStatus from '@salesforce/apex/RC_CreateChequeAndBond.getStatus';
import getParams from '@salesforce/apex/RC_CreateChequeAndBond.getParams';


import insertChequeList from '@salesforce/apex/RC_CreateChequeAndBond.insertChequeList';

const actions = [{
        label: 'Bordroya Bağlı Faturaları Göster',
        name: 'showInvoice',
        iconName: 'utility:info'
    },
    {
        label: 'Bordroya Bağlı Çekleri Göster',
        name: 'showCheque',
        iconName: 'utility:info'
    },
    {
        label: 'Bordro Sil',
        name: 'deleteBordro',
        iconName: 'utility:info'
    },
    {
        label: 'PDF',
        name: 'createpdf',
        iconName: 'utility:info'
    },
    {
        label: 'Email Gönder',
        name: 'sendemail',
        iconName: 'utility:info'
    }
];

const actionsForCheque = [{
        label: 'Güncelle',
        name: 'chequeUpdate',
        iconName: 'utility:info',
    },
    {
        label: 'Detay',
        name: 'chequeDetail',
        iconName: 'utility:info',
    },
    {
        label: 'Sil',
        name: 'chequeDelete',
        iconName: 'utility:info',
    }
];

export default class Rc_createchequeandbond extends LightningElement {
    @api hidefilter = false;
    @api passedbordro;
    @api bayiid;

    eIcon = excelIcon;

    //Properties For Calculation
    @track readonlyOPInput = false;
    @track readonlyCalcButton = false;
    bordroId;
    @track odemePlanList = [];
    sourcePaymentPlanList;
    @track initialPlan;
    @track deleteRecordId;
    @track status;
    @track chequeTypes = [];

    //Only Showed Properties
    @track bordroTutar;
    @track bordroVade;
    @track girilenTutar;
    @track girilenVade;
    @track hesaplananTutar;
    @track hesaplananVade;
    @track farkTutar;
    @track farkVade;
    @track farkTutarGirilen;
    @track chequeModalTitle = '';
    @track lockButtonLabel = 'Kilitle';

    //Datatable Columns
    mainBordroColumns = [];
    chequeColumns = [];
    planColumns = [];
    invoiceDataColumns = [];

    //Datatable Sources
    @track bordroList = [];
    sourceList = [];
    @track chequeList = [];
    invoiceList = [];

    // Modal Properties    
    @track showBordroDatatable = false;
    @track showChequeDatatable = false;

    @track showInvoiceModal = false;
    @track showChequeModal = false;
    @track showOdemePlani = false;
    @track showChequeAddModal = false;
    @track openPermissionModal = false;
    @track showBordroPDFModal = false;

    // Input Properties
    selectedBordroNo = ''
    selectedChequeNum = '';
    selectedMaturity = '';
    selectedStartDate;
    selectedEndDate;
    selectedBayiId = '';
    selectedBankKeyId = '';
    @track selectedBankKeyName = '';
    @track selectedCityId = '';
    @track selectedChequeType;
    @track selectedChequeId = '';
    @track isChequeReadonly = false;
    @track isChequeTypeReadonly = false;
    @track typeIsCheque = true;
    @track showAllChequeField = false;
    @track showBankList = false;
    @track showTopluCekEkleModal = false;
    @track showOnayBtn;
    @track showOdemePlanBtn;
    @track showTabbar = true;
    @track generatedFromExistOne = false;
    @track positiveAmount = 0;
    @track negativeAmount = 0;


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


    @track deleteType = '';


    relatedPlanId = '';

    // Input Source Properties
    @track bankKeyList = [];
    @track bayiName = '';

    //pagging 
    @track currentPage = 1;
    @track totalPage = 1;
    @track totalRecord;

    //For custom lookup field
    fields = ["Name", "RC_SAP_ID__c"];
    displayFields = "Name,RC_SAP_ID__c";
    whereClauses = "WHERE RC_Dealer_Type__c = \'BAYI\'";

    fieldsForCity = ["Name", "RC_Code__c"];
    displayFieldsForCity = "Name,RC_Code__c";
    whereClausesForCity = "WHERE RC_Type__c = \'City\'";

    fieldsForBankKey = ["Name", "RC_BANKL__c", "RC_BANK__c", "RC_BRINCH__c"];
    displayFieldsForBankKey = "Name,RC_BANKL__c";
    @track whereClausesForBankKey = "";

    constructor() {
        super();
        getStatus().
        then(data => {
            this.status = data;
            this.chequeTypes = data.chequeTypes;
            this.mainBordrocolumns = [{
                    label: 'Bordro No',
                    fieldName: 'RC_Bordro_No__c'
                },
                {
                    label: 'Bayi No',
                    fieldName: 'RC_Dealer_Number__c'
                },
                {
                    label: 'Tarih',
                    fieldName: 'CreatedDate',
                    type: 'date-local',
                    typeAttributes: {
                        month: '2-digit',
                        day: '2-digit'
                    }
                },
                {
                    label: 'Durum',
                    fieldName: 'statusVal'
                },
                {
                    label: 'Vade',
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
                    cellAttributes: {
                        alignment: 'right'
                    },
                    typeAttributes: {
                        currencyCode: 'TRY',
                        step: '0.01'
                    }
                },
                {
                    type: 'action',
                    typeAttributes: {
                        rowActions: this.getRowActions
                    }
                }
            ];
            this.planColumns = [{
                    label: 'Çek Vade Tarihi',
                    fieldName: 'RC_Payment_Plan_Due_Date__c',
                    type: 'date-local',
                    editable: true,
                    typeAttributes: {
                        month: '2-digit',
                        day: '2-digit'
                    }
                },
                {
                    label: 'Çek Tutar',
                    fieldName: 'RC_Payment_Plan_Amount__c',
                    type: 'currency',
                    editable: true,
                    typeAttributes: {
                        currencyCode: 'TRY',
                        step: '0.01'
                    }
                }
            ];
        }).
        catch();


    }

    getParameters() {
        getParams({
            selectedBordroId: this.bordroId,
            bayiId: this.selectedBayiId
        }).then(
            data => {
                if (data != null) {
                    this.positiveAmount = data.positiveAmount;
                    this.negativeAmount = data.negativeAmount;
                    this.selectedIdentificationNum = data.bayiTaxNumber;
                }
            }
        ).
        catch();
    }


    //Main Methods
    initializePlan(isShowCheque) {
        initializeOdemePlan({
                selectedBordroId: this.bordroId
            })
            .then(data => {
                if (data != null) {
                    if (data.message != undefined && data.message.length > 0) {
                        this.showToast(data.message, '', 'warning');
                    } else {
                        if (data.checkToday) {
                            this.readonlyOPInput = true;
                            this.selectedChequeNum = "1";
                            this.selectedMaturity = "0";
                        } else {
                            this.readonlyOPInput = false;
                            this.selectedChequeNum = "6";
                            this.selectedMaturity = "30";
                        }

                        this.bordroTutar = data.generalInfo.bordroTutar;
                        this.bordroVade = this.formatDate(data.generalInfo.bordroVade);
                        this.girilenTutar = data.generalInfo.girilenTutar;
                        this.girilenVade = this.formatDate(data.generalInfo.girilenVade);
                        this.hesaplananTutar = data.generalInfo.hesaplananTutar;
                        this.hesaplananVade = this.formatDate(data.generalInfo.hesaplananVade);
                        this.farkTutar = data.generalInfo.farkTutar;
                        this.farkVade = data.generalInfo.farkVade;
                        this.initialPlan = data;
                        this.relatedBayiCode = data.bordro.RC_Dealer_Number__c;
                        this.odemePlanList = data.paymentPlan;
                        this.sourcePaymentPlanList = data.paymentPlan;
                        this.farkTutarGirilen = this.bordroTutar - this.girilenTutar;
                        this.selectedChequeType = undefined;
                        this.showAllChequeField = false;

                        if (data.bayiTaxNumber)
                            this.selectedIdentificationNum = data.bayiTaxNumber;

                        if (this.bordroTutar - this.girilenTutar <= 0) {
                            this.showOdemePlani = false;
                            this.showCheque();
                            return;
                        }

                        data.paymentPlan.sort(function (a, b) {
                            var dateA = new Date(a.RC_Payment_Plan_Due_Date__c),
                                dateB = new Date(b.RC_Payment_Plan_Due_Date__c)
                            return dateA - dateB
                        });

                        if (data.paymentPlan[0].Id != '' && data.paymentPlan[0].Id != undefined && data.paymentPlan[0].Id != null) {
                            this.lockButtonLabel = 'Kilit Kaldır';
                            this.readonlyCalcButton = false;
                            this.planColumns = [{
                                    label: 'Çek Vade Tarihi',
                                    fieldName: 'RC_Payment_Plan_Due_Date__c',
                                    type: 'date-local',
                                    typeAttributes: {
                                        month: '2-digit',
                                        day: '2-digit'
                                    }
                                },
                                {
                                    label: 'Çek Tutar',
                                    fieldName: 'RC_Payment_Plan_Amount__c',
                                    type: 'currency',
                                    typeAttributes: {
                                        currencyCode: 'TRY',
                                        step: '0.01'
                                    }
                                },
                                {
                                    label: '',
                                    type: 'button-icon',
                                    initialWidth: 75,
                                    typeAttributes: {
                                        iconName: 'utility:add',
                                        title: 'Add Cheque',
                                        variant: 'border-filled',
                                        alternativeText: 'View'
                                    }
                                }
                            ];

                            checkPlan({
                                    selectedBordroId: this.bordroId,
                                    paymentPlanList: data.paymentPlan
                                })
                                .then(data => {
                                    if (!data.isSuccess) {
                                        this.showToast(data.message, '', 'warning');
                                    }
                                })
                                .catch(error => {
                                    this.displayError('Initialize Odeme Plan', error);
                                });
                        } else {
                            this.lockButtonLabel = 'Kilitle';
                            this.readonlyCalcButton = true;
                            this.planColumns = [{
                                    label: 'Çek Vade Tarihi',
                                    fieldName: 'RC_Payment_Plan_Due_Date__c',
                                    type: 'date-local',
                                    editable: true,
                                    typeAttributes: {
                                        month: '2-digit',
                                        day: '2-digit'
                                    }
                                },
                                {
                                    label: 'Çek Tutar',
                                    fieldName: 'RC_Payment_Plan_Amount__c',
                                    type: 'currency',
                                    editable: true,
                                    typeAttributes: {
                                        currencyCode: 'TRY',
                                        step: '0.01'
                                    }
                                }
                            ];
                        }

                        if (isShowCheque) {
                            this.showCheque();
                        }
                    }
                }
            })
            .catch(error => {
                this.displayError('Initialize Odeme Plan', error);
            });
    }

    calculateOdemePlan(event) {
        processPaymentPlan({
                paymentPlanList: this.sourcePaymentPlanList,
                processType: 'delete'
            })
            .then(data => {
                return calculatePlan({
                    selectedBordroId: this.bordroId,
                    checkToday: this.initialPlan.checkToday,
                    count: this.selectedChequeNum,
                    range: this.selectedMaturity
                });
            })
            .then(data => {
                this.initialPlan = data;

                this.bordroTutar = data.generalInfo.bordroTutar;
                this.bordroVade = this.formatDate(data.generalInfo.bordroVade);
                this.girilenTutar = data.generalInfo.girilenTutar;
                this.girilenVade = this.formatDate(data.generalInfo.girilenVade);
                this.hesaplananTutar = data.generalInfo.hesaplananTutar;
                this.hesaplananVade = this.formatDate(data.generalInfo.hesaplananVade);
                this.farkTutar = data.generalInfo.farkTutar;
                this.farkVade = data.generalInfo.farkVade;
                this.farkTutarGirilen = this.bordroTutar - this.girilenTutar;
                data.paymentPlan.sort(function (a, b) {
                    var dateA = new Date(a.RC_Payment_Plan_Due_Date__c),
                        dateB = new Date(b.RC_Payment_Plan_Due_Date__c)
                    return dateA - dateB
                });

                this.sourcePaymentPlanList = data.paymentPlan;
                this.odemePlanList = data.paymentPlan;

                return checkPlan({
                    selectedBordroId: this.bordroId,
                    paymentPlanList: data.paymentPlan
                });
            })
            .then(data => {
                if (!data.isSuccess) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: data.message,
                            variant: 'error'
                        })
                    );
                }
            })
            .catch(error => {
                this.displayError('Custom Odeme Plan', error);
            });
    }

    calculateModifiedPaymentPlan(event) {
        checkPlan({
            selectedBordroId: this.bordroId,
            paymentPlanList: this.sourcePaymentPlanList
        }).
        then(data => {
            if (data.isSuccess) {
                calculateGeneralInfo({
                        selectedBordroId: this.bordroId,
                        paymentPlanList: this.sourcePaymentPlanList
                    })
                    .then(data => {
                        if (data != null) {
                            this.bordroTutar = data.bordroTutar;
                            this.bordroVade = this.formatDate(data.bordroVade);
                            this.girilenTutar = data.girilenTutar;
                            this.girilenVade = this.formatDate(data.girilenVade);
                            this.hesaplananTutar = data.hesaplananTutar;
                            this.hesaplananVade = this.formatDate(data.hesaplananVade);
                            this.farkTutar = data.farkTutar;
                            this.farkVade = data.farkVade;

                            this.initialPlan.generalInfo = data;
                        }
                    }).
                catch(error => {
                    this.displayError('Modified Plan Control', error);
                });
            } else {
                this.bordroTutar = data.info.bordroTutar;
                this.bordroVade = this.formatDate(data.info.bordroVade);
                this.girilenTutar = data.info.girilenTutar;
                this.girilenVade = this.formatDate(data.info.girilenVade);
                this.hesaplananTutar = data.info.hesaplananTutar;
                this.hesaplananVade = this.formatDate(data.info.hesaplananVade);
                this.farkTutar = data.info.farkTutar;
                this.farkVade = data.info.farkVade;

                this.initialPlan.generalInfo = data.info;

                this.dispatchEvent(
                    new ShowToastEvent({
                        message: data.message,
                        variant: 'error'
                    })
                );
            }
        }).
        catch(error => {
            this.displayError('Modified Plan Control', error);
        });
    }

    lockedPlan(event) {
        if (this.readonlyCalcButton) {
            checkPlan({
                    selectedBordroId: this.bordroId,
                    paymentPlanList: this.sourcePaymentPlanList
                })
                .then(data => {
                    if (data.isSuccess) {
                        this.lockButtonLabel = 'Kilit Kaldır';
                        processPaymentPlan({
                                paymentPlanList: this.sourcePaymentPlanList,
                                processType: 'insert'
                            })
                            .then(data => {

                                this.readonlyCalcButton = false;
                                this.planColumns = [{
                                        label: 'Çek Vade Tarihi',
                                        fieldName: 'RC_Payment_Plan_Due_Date__c',
                                        type: 'date-local',
                                        typeAttributes: {
                                            month: '2-digit',
                                            day: '2-digit'
                                        }
                                    },
                                    {
                                        label: 'Çek Tutar',
                                        fieldName: 'RC_Payment_Plan_Amount__c',
                                        type: 'currency',
                                        typeAttributes: {
                                            currencyCode: 'TRY',
                                            step: '0.01'
                                        }
                                    },
                                    {
                                        label: '',
                                        type: 'button-icon',
                                        initialWidth: 75,
                                        typeAttributes: {
                                            iconName: 'utility:add',
                                            title: 'Add Cheque',
                                            variant: 'border-filled',
                                            alternativeText: 'View'
                                        }
                                    }
                                ];

                                this.initializePlan(false);
                            })
                            .catch();
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                message: data.message,
                                variant: 'error'
                            })
                        );
                    }
                })
                .catch();
        } else {
            this.readonlyCalcButton = true;
            this.planColumns = [{
                    label: 'Çek Vade Tarihi',
                    fieldName: 'RC_Payment_Plan_Due_Date__c',
                    type: 'date-local',
                    editable: true,
                    typeAttributes: {
                        month: '2-digit',
                        day: '2-digit'
                    }
                },
                {
                    label: 'Çek Tutar',
                    fieldName: 'RC_Payment_Plan_Amount__c',
                    type: 'currency',
                    editable: true,
                    typeAttributes: {
                        currencyCode: 'TRY',
                        step: '0.01'
                    }
                }
            ];

            this.lockButtonLabel = 'Kilitle';
        }
    }

    sendApprove(event) {
        let gvList = this.girilenVade.split('.');
        let girilenV = new Date(gvList[2] + '-' + gvList[1] + '-' + gvList[0]);

        let bvList = this.bordroVade.split('.');
        let bordroV = new Date(bvList[2] + '-' + bvList[1] + '-' + bvList[0]);
        approve({
            selectedBordroId: this.bordroId,
            fark: this.farkTutar,
            girilenVade: girilenV,
            bordroVade: bordroV,
            bayiId: this.selectedBayiId
        }).
        then(data => {
            if (data.isSuccess) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Bordro onaya gönderilmiştir.',
                        variant: 'success'
                    })
                );
                this.searchBakiye();
                this.showChequeModal = false;
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: data.message,
                        variant: 'warning'
                    })
                );
            }
        }).
        catch(error => {
            console.log(error);
        });
    }

    // Bordro Datatable Methods and Process Methods
    deleteBordro(event) {
        if (this.deleteRecordId != undefined && this.deleteRecordId != null && this.deleteRecordId.length > 0) {
            let bordro = this.bordroList.find(q => q.Id == this.deleteRecordId);


            deleteBordro({
                bordroId: this.deleteRecordId
            }).
            then(data => {
                if (data.isSuccess) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: 'Bordro başarıyle silinmiştir.',
                            variant: 'success'
                        })
                    );
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: 'Bordro silinirken bir hata meydana geldi.',
                            variant: 'error'
                        })
                    );
                }

                this.deleteType = '';
                this.deleteRecordId = undefined;
                this.searchBakiye();
                this.openPermissionModal = false;
            }).
            catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    message: 'Silinecek bordro bulunamadı. Sistem admininiz ile iletişime geçiniz.',
                    variant: 'error'
                })
            );

            this.openPermissionModal = false;
        }
    }

    deleteCheque(cID) {
        deleteCheque({
                chequeId: this.deleteRecordId
            })
            .then(data => {
                if (data.isSuccess) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: 'Kayıt başarıyle silinmiştir.',
                            variant: 'success'
                        })
                    );
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: 'Kayıt silinirken hata oluştu.' + cw.message,
                            variant: 'success'
                        })
                    );
                }

                this.deleteType = '';
                this.deleteRecordId = undefined;
                this.openPermissionModal = false;

                this.showCheque();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    searchBakiye(event) {
        let selectedBayi = this.selectedBayiId;
        let selectedBaslangic = this.selectedStartDate;
        let selectedBitis = this.selectedEndDate;
        let selectedBordro = this.selectedBordroNo;

        getBordroList({
                bayiId: selectedBayi,
                baslangic: selectedBaslangic,
                bitis: selectedBitis,
                bordroNo: selectedBordro
            })
            .then(data => {
                if (data != undefined && data.length > 0) {
                    data.forEach((q) => {
                        q.statusVal = this.status.bordroStatus.find(a => a.value == q.RC_Bordro_Status_ID__c).label;
                    });

                    this.sourceList = data;
                    this.showBordroDatatable = true;

                    //Pagging
                    this.totalRecord = data.length;
                    this.totalPage = Math.ceil(this.totalRecord / 20);
                    this.currentPage = 0;
                    this.bordroList = data.slice(this.currentPage * 20, (this.currentPage + 1) * 20);
                    this.currentPage = 1;
                }
            })
            .catch(error => {
                this.displayError('Get Bordro List', error);
            });
    }

    handleLookup(event) {
        switch (event.detail.data.objectName) {
            case 'Account':
                this.selectedBayiId = event.detail.data.currentRecordId;
                break;
            case 'RC_City_Region__c':
                this.selectedCityId = event.detail.data.currentRecordId;
                this.whereClausesForBankKey = "WHERE RC_ORT01__c = '" + event.detail.data.currentRecordId + "'";
                break;
            case 'RC_Bank_Informations__c':
                this.selectedBankKeyId = event.detail.data.currentRecordId;
                break;
            default:
                break;
        }
    }

    topluCekEkleModalClose(event) {
        if (event.detail != undefined) {
            this.showTopluCekEkleModal = event.detail.data.close;

            if (event.detail.data.message != undefined && event.detail.data.message.length > 0) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: event.detail.data.message,
                        variant: event.detail.data.variant
                    })
                );
            }
        }

        this.showCheque();
    }

    sendemailclosemodal(event) {
        if (event.detail != undefined) {
            this.showBordroPDFModal = event.detail.data.close;

            if (event.detail.data.message != undefined && event.detail.data.message.length > 0) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: event.detail.data.message,
                        variant: event.detail.data.variant
                    })
                );
            }
        }
    }

    next(){
        if(this.currentPage != this.totalPage){          
            this.bordroList = this.sourceList.slice(this.currentPage * 20, (this.currentPage + 1) * 20);
            this.currentPage = this.currentPage + 1;
        }   
    }

    previous(){
        if(this.currentPage != 1){   
            this.currentPage = this.currentPage -1;       
            this.bordroList = this.sourceList.slice((this.currentPage - 1 ) * 20, this.currentPage * 20);      
        }
    }

    first(){
        if(this.currentPage != 1){   
            this.currentPage = 1;       
            this.bordroList = this.sourceList.slice(0, 20);      
        }
    }

    last(){
        if(this.currentPage != this.totalPage){   
            this.currentPage = this.totalPage;       
            this.bordroList = this.sourceList.slice((this.totalPage - 1) * 20, this.totalPage * 20);      
        }
    }

    // Input Change Helper Methods
    bayiInputChangeHandler(event) {
        this.selectedBordroNo = event.target.value;
    }
    handleDatePickerSelect(event) {
        switch (event.currentTarget.name) {
            case 'startDate':
                this.selectedStartDate = event.currentTarget.value;
                break;
            case 'endDate':
                this.selectedEndDate = event.currentTarget.value;
                break;
            default:
                break;
        }
    }

    handlePlanForm(event) {
        switch (event.currentTarget.name) {
            case "formInputCurrency":
                let odemePlanCurr = this.odemePlanList.find(q => q.RC_Payment_Plan_Number__c == event.currentTarget.dataset.relatedId);
                odemePlanCurr.RC_Payment_Plan_Amount__c = event.currentTarget.value;
                break;
            case "formInputDate":
                let odemePlanDate = this.odemePlanList.find(q => q.RC_Payment_Plan_Number__c == event.currentTarget.dataset.relatedId);
                odemePlanDate.RC_Payment_Plan_Due_Date__c = event.currentTarget.value;

                break;
            default:
                break;
        }
    }

    // Modal's Methods
    showCheque() {
        this.getParameters();
        getBordroRelatedCheques({
            selectedBordroId: this.bordroId
        }).
        then(data => {
            if (data != undefined && data.length > 0) {
                this.chequeColumns = [{
                        label: 'Çek/Senet',
                        fieldName: 'chequeTypeVal'
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
                        label: 'Şube İli',
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
                    if (q.RC_Cheque_Bill__c == 'Cheque') {
                        q.cityName = q.RC_City__r != undefined ? q.RC_City__r.Name : undefined;
                        q.bankKey = q.RC_Bank_Key__r != undefined ? q.RC_Bank_Key__r.Name : undefined;
                    }

                    q.statusVal = this.status.cekStatus.find(a => a.value == q.RC_Check_Status_ID__c).label;
                    q.chequeTypeVal = this.chequeTypes ? this.chequeTypes.find(a => a.value == q.RC_Cheque_Bill__c).label : q.RC_Cheque_Bill__c;
                })

                this.chequeList = data;

                this.typeIsCheque = data[0].RC_Cheque_Bill__c == "Cheque" ? true : false;
                this.selectedChequeType = data[0].RC_Cheque_Bill__c;
                this.showAllChequeField = true;
                this.isChequeTypeReadonly = true;
                this.showChequeDatatable = true;
            } else {
                this.selectedChequeType = undefined;
                this.showAllChequeField = false;
                this.showChequeDatatable = false;
            }

            return calculateGeneralInfo({
                selectedBordroId: this.bordroId,
                paymentPlanList: null
            });
        }).
        then(data => {
            this.bordroTutar = data.bordroTutar;
            this.bordroVade = this.formatDate(data.bordroVade);
            this.girilenTutar = data.girilenTutar;
            this.girilenVade = this.formatDate(data.girilenVade);
            this.hesaplananTutar = data.hesaplananTutar;
            this.hesaplananVade = this.formatDate(data.hesaplananVade);
            this.farkTutarGirilen = data.bordroTutar - data.girilenTutar;
            this.farkVade = data.farkVade;



            if (this.chequeList != undefined && this.chequeList.length == 0) {
                this.showOnayBtn = false;
            } else if (this.chequeList != undefined && this.chequeList.length > 0) {
                this.showOnayBtn = true;
            }

            if (this.initialPlan.bordro.RC_Bordro_Status_ID__c == "1") {
                if (this.positiveAmount >= this.farkTutarGirilen && this.negativeAmount <= this.farkTutarGirilen) {
                    this.showOdemePlanBtn = false;
                } else {
                    this.showOdemePlanBtn = true;
                }
                this.showTabbar = true;

            } else {
                this.showOdemePlanBtn = false;
                this.showOnayBtn = false;
                this.showTabbar = false;
            }

            this.showChequeModal = true;
        }).
        catch(error => {
            console.log(error);
        });
    }

    showInvoice(event) {
        this.invoiceDataColumns = [{
                label: 'SAP Belge No',
                fieldName: 'RC_Invoice_Number__c'
            },
            {
                label: 'Belge Türü Tanımı',
                fieldName: 'RC_Description__c'
            },
            {
                label: 'Fatura İçeriği',
                fieldName: 'RC_Product_Info__c'
            },
            {
                label: 'Vade Tarihi',
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
            }
        ];

        getRelatedInvoice({
            selectedBordroId: this.bordroId
        }).
        then(data => {
            this.invoiceList = data;

            this.showInvoiceModal = true;
        }).
        catch();
    }

    showOdemePlanModal(event) {
        this.initializePlan(false);
        this.showOdemePlani = true;
        this.showChequeModal = false;
    }

    showChequeModalAdd(event) {
        this.relatedAmount = 0;
        this.relatedDueDate = undefined;
        this.relatedPlanId = undefined;
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
        this.selectedDrawerReg = '';
        this.selectedBankAccNum = '';
        this.selectedCityId = '';
        this.selectedCityName = '';

        this.chequeModalTitle = 'Çek/Senet Ekle';

        this.showChequeAddModal = true;
    }

    closeModal(event) {
        switch (event.target.dataset.key) {
            case 'permission':
                this.openPermissionModal = false;
                break;
            default:
                this.showInvoiceModal = false;
                break;
        }
    }

    closeChequeModal() {
        this.chequeList = [];

        const selectEvent = new CustomEvent("closechildcomponent", {
            bubbles: true,
            composed: true,
            cancelable: true,
            detail: {
                close: false,
                componentname: 'oct'
            }
        });

        this.dispatchEvent(selectEvent);
        this.showChequeModal = false;
    }


    closeOdemePlanModal() {
        this.showOdemePlani = false;
        this.showChequeModal = false;
    }

    closeChequeAddModal() {
        this.selectedChequeId = '';
        this.isChequeReadonly = false;
        this.isChequeTypeReadonly = false;
        this.showChequeAddModal = false;
    }

    // Helper Methods
    handleSearchElements(event) {
        const srcName = event.srcElement.name;

        switch (srcName) {
            case 'selectedChequeNum':
                this.selectedChequeNum = event.detail.value;
                break;
            case 'selectedMaturity':
                this.selectedMaturity = event.detail.value;
                break;

            default:
        }
    }

    handleOdemePlanClick(event) {
        let relatedPlan = this.odemePlanList.find(q => q.RC_Payment_Plan_Number__c == event.currentTarget.dataset.relatedId);

        if (this.initialPlan.bordro.Cheques__r) {
            let exist = this.initialPlan.bordro.Cheques__r[0];

            if (exist.RC_Cheque_Bill__c == 'Cheque') {
                this.selectedBankKeyName = exist.RC_Bank_Key__r != undefined ? exist.RC_Bank_Key__r.Name : undefined;
                this.selectedBankKeyId = exist.RC_Bank_Key__c;
                this.selectedCityId = exist.RC_City__c;
                this.selectedCityName = exist.RC_City__r.Name;
                this.selectDrawerReg = exist.RC_Drawer_Region__c;
                this.selectedBankAccNum = exist.RC_Bank_Account_Number__c;
            }

            this.selectedChequeType = exist.RC_Cheque_Bill__c;
            this.selectedChequeNum = '';
            this.selectedIdentificationNum = exist.RC_Identification_Number__c;



            this.showAllChequeField = true;
        } else {
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
            this.selectDrawerReg = '';
            this.selectedBankAccNum = '';
            this.selectedCityId = '';
            this.selectedCityName = '';
        }
        this.isReadonly = true;
        this.selectedChequeId = undefined;
        this.relatedPlanId = relatedPlan.Id;
        this.relatedAmount = relatedPlan.RC_Payment_Plan_Amount__c;
        this.relatedDueDate = relatedPlan.RC_Payment_Plan_Due_Date__c;

        this.chequeModalTitle = 'Çek/Senet Ekle';

        this.showChequeAddModal = true;
    }

    handleChequeTypeChange(event) {
        var val = event.detail.value;
        this.selectedChequeType = val;
        if (val == "Cheque") {
            this.showAllChequeField = true;
            this.typeIsCheque = true;
        } else if (val == "Bill") {
            this.showAllChequeField = true;
            this.typeIsCheque = false;
        } else {
            this.showAllChequeField = false;
            this.typeIsCheque = false;
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;

        switch (actionName) {
            case 'showInvoice':
                this.bordroId = event.detail.row['Id'];
                this.showInvoice();
                break;
            case 'showCheque':
                this.bordroId = event.detail.row['Id'];
                this.initializePlan(true);
                break;
            case 'deleteBordro':
                this.deleteType = 'bordro';
                this.deleteRecordId = event.detail.row['Id'];
                this.openPermissionModal = true;
                break;
            case 'chequeDetail':
                this.selectedChequeId = event.detail.row['Id'];

                let cheque = this.chequeList.find(q => q.Id == this.selectedChequeId);

                this.relatedAmount = cheque.RC_Amount__c;
                this.relatedDueDate = cheque.RC_Due_Date__c;
                this.selectedChequeNum = cheque.RC_Cheque_Number__c;
                this.selectedIdentificationNum = cheque.RC_Identification_Number__c;

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
            case 'chequeUpdate':
                this.selectedChequeId = event.detail.row['Id'];

                let chequeUpdate = this.chequeList.find(q => q.Id == this.selectedChequeId);
                this.relatedAmount = chequeUpdate.RC_Amount__c;
                this.relatedDueDate = chequeUpdate.RC_Due_Date__c;
                this.selectedChequeNum = chequeUpdate.RC_Cheque_Number__c;
                this.selectedIdentificationNum = chequeUpdate.RC_Identification_Number__c;

                this.chequeModalTitle = 'Çek/Senet Güncelle';

                if (chequeUpdate.RC_Cheque_Bill__c == 'Cheque') {
                    this.selectedChequeType = 'Cheque';
                    this.selectedBankKeyName = chequeUpdate.bankKey;
                    this.selectedBankKeyId = chequeUpdate.RC_Bank_Key__c;

                    this.selectedCityId = chequeUpdate.RC_City__c;
                    this.selectedCityName = chequeUpdate.RC_City__r.Name;
                    this.selectDrawerReg = chequeUpdate.RC_Drawer_Region__c;
                    this.selectedBankAccNum = chequeUpdate.RC_Bank_Account_Number__c;
                    this.typeIsCheque = true;
                } else {
                    this.selectedChequeType = 'Bill';
                    this.typeIsCheque = false;
                }


                this.isChequeTypeReadonly = false;
                this.showChequeAddModal = true;
                this.isChequeReadonly = false;
                this.isReadonly = false;
                break;
            case 'chequeDelete':
                this.deleteType = 'cheque';
                this.deleteRecordId = event.detail.row['Id'];
                this.openPermissionModal = true;
                break;
            case 'createpdf':
                window.open(window.location.origin + '/apex/RC_BordroPdf?bid=' + event.detail.row['Id'], '_blank');
                break;
            case 'sendemail':
                this.bordroId = event.detail.row['Id'];
                this.relatedBayiCode = event.detail.row['RC_Dealer_Number__c'];
                this.showBordroPDFModal = true;
                break;
            default:
                break;
        }
    }

    getRowActions(row, doneCallback) {
        const actionList = [];

        actions.forEach(action => {
            if (action.name == 'showCheque') {
                actionList.push(action);
            } else if (action.name == 'deleteBordro') {
                if (row['RC_Bordro_Status_ID__c'] == '1') {
                    actionList.push(action);
                }
            } else {
                actionList.push(action);
            }
        });

        doneCallback(actionList);
    }

    getRowActionsForCheque(row, doneCallback) {
        const actionList = [];
        actionsForCheque.forEach(action => {
            if (row['RC_Check_Status_ID__c'] == '1') {
                if (action.name == 'chequeDelete') {
                    actionList.push(action);
                } else if (action.name == 'chequeUpdate') {
                    actionList.push(action);
                }
            }
            if (action.name == 'chequeDetail') {
                actionList.push(action);
            }
        });

        doneCallback(actionList);
    }

    displayError(source, error) {


        window.console.log('Source : ' + source);
        window.console.log('Error : ' + this.error);
    }

    handleDeleteRecord(event) {
        if (this.deleteType == 'bordro') {
            this.deleteBordro();
        } else {
            this.deleteCheque();
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

    handleSubmit(event) {
        let isFormValid = [...this.template.querySelectorAll('lightning-input')].reduce((valid, element) => {
            element.reportValidity();

            return valid && element.checkValidity();
        }, true);

        if (isFormValid) {
            var insertData = new Object();
            insertData.RC_Type__c = 'Cheque';
            insertData.RC_Check_Status_ID__c = '1';
            insertData.RC_Cheque_Bill__c = this.selectedChequeType;
            insertData.RC_Due_Date__c = this.relatedDueDate;
            insertData.RC_Amount__c = this.relatedAmount;
            insertData.RC_Identification_Number__c = this.selectedIdentificationNum;
            insertData.RC_Account_No__c = this.relatedBayiCode;
            insertData.RC_Bordro__c = this.bordroId;

            if (this.selectedChequeType == 'Cheque') {
                insertData.RC_Bank_Key__c = this.selectedBankKeyId;
                insertData.RC_City__c = this.selectedCityId;
                insertData.RC_Drawer_Region__c = this.selectDrawerReg;
                insertData.RC_Cheque_Number__c = this.selectedChequeNum;
                insertData.RC_Bank_Account_Number__c = this.selectedBankAccNum;
            }

            if (this.selectedChequeId) {
                insertData.Id = this.selectedChequeId;
            }

            validateInput({
                data: insertData
            }).
            then(data => {
                if (data.length > 0) {
                    const event = new ShowToastEvent({
                        message: data,
                        variant: 'warning',
                        moda: 'sticky'
                    });
                    this.dispatchEvent(event);
                } else {
                    var inserDatatList = new Array();
                    inserDatatList.push(insertData);
                    this.showOdemePlanModal = false;
                    return insertChequeList({
                        insertList: inserDatatList
                    });
                }
            }).
            then((data) => {
                if (data) {
                    if (!data.isSuccess) {
                        const event = new ShowToastEvent({
                            message: data.message,
                            variant: 'warning',
                            moda: 'sticky'
                        });
                        this.dispatchEvent(event);
                    } else {
                        const event = new ShowToastEvent({
                            message: 'Kayıt başarıyla oluşturuldu.',
                            variant: 'success',
                            moda: 'sticky'
                        });
                        this.dispatchEvent(event);
                        this.handleSuccess();
                        this.showChequeAddModal = false;
                    }
                }
            }).
            catch(error => {
                console.log(error);
            });
        } else {
            const event = new ShowToastEvent({
                message: 'Form üzerinde hatalı veriler mevcut. Kontrol ediniz.',
                variant: 'warning',
                moda: 'sticky'
            });
            this.dispatchEvent(event);
        }
    }

    handleSuccess(event) {
        if (this.relatedPlanId != undefined) {
            deleteOdemePlan({
                    relatedOPId: this.relatedPlanId
                })
                .then(data => {
                    this.relatedPlanId = undefined;
                    this.selectedChequeType = '';
                    this.selectedChequeNum = '';
                    this.selectedDrawerReg = '';
                    this.selectedBankAccNum = '';
                    this.selectedCityId = '';
                    this.initializePlan(false);
                    this.showChequeAddModal = false;
                })
                .catch();
        } else {
            this.initializePlan(false);
            this.showChequeAddModal = false;
        }
    }

    handleError(event) {
        console.log('onerror: ');
    }

    showTopluCekEkle(event) {
        this.showTopluCekEkleModal = true;
    }

    retrieveRelatedBankList(event) {
        this.selectedCityId = event.target.value;
    }

    handleKeyUp(event) {
        var key = event.target.value;

        if (key.length > 5) {
            getBankInfosByCity({
                    cityId: this.selectedCityId,
                    searchedKey: key
                })
                .then(data => {
                    if (data != null & data != undefined && data.length > 0) {
                        this.bankKeyList = data;
                        this.showBankList = true;
                    } else {
                        this.bankKeyList = [];
                        this.showBankList = false;
                    }
                })
                .catch(error => {
                    console.log(error);
                });
        } else {
            this.bankKeyList = [];
            this.showBankList = false;
        }
    }

    showToast(msg, msgTitle, msgType) {
        const evt = new ShowToastEvent({
            title: msgTitle,
            message: msg,
            variant: msgType,
        });

        this.dispatchEvent(evt);
    }

    formatDate(dateVal) {
        if (dateVal != undefined) {
            let splittedDate = dateVal.split('-');

            let result = splittedDate[2] + '.' + splittedDate[1] + '.' + splittedDate[0];

            return result
        }
    }

    // Load Static Resources
    renderedCallback() {
        if (this.passedbordro != undefined) {
            this.bordroId = this.passedbordro;
            this.selectedBayiId = this.bayiid;
            //this.showCheque();
            this.initializePlan(true);
            this.passedbordro = undefined;
            this.bayiid = undefined;
        }

        loadStyle(this, ChequeAndBondCSS)
            .then()
            .catch(error => console.log(error));
    }
}