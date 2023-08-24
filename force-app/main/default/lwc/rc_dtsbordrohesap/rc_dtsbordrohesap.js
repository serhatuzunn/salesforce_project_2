import { LightningElement, wire, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import CSS from "@salesforce/resourceUrl/DtsBordroHesapCss";
import getBordroList from "@salesforce/apex/RC_DtsBordroHesapController.getBordroList";
import getRelatedInvoice from "@salesforce/apex/RC_DtsBordroHesapController.getRelatedInvoice";
import initializeOdemePlan from "@salesforce/apex/RC_DtsBordroHesapController.initializeOdemePlan";
import checkPlan from "@salesforce/apex/RC_DtsBordroHesapController.checkPlan";
import processPaymentPlan from "@salesforce/apex/RC_DtsBordroHesapController.processPaymentPlan";
import calculatePlan from "@salesforce/apex/RC_DtsBordroHesapController.calculatePlan";
import sendPaymentPlanToSAP from "@salesforce/apex/RC_DtsBordroHesapController.sendPaymentPlanToSAP";
import getBordroRelatedCheques from "@salesforce/apex/RC_DtsBordroHesapController.getBordroRelatedCheques";
import calculateGeneralInfo from "@salesforce/apex/RC_DtsBordroHesapController.calculateGeneralInfo";
import deleteSelectedBordro from "@salesforce/apex/RC_DtsBordroHesapController.deleteSelectedBordro";
import deletePlan from "@salesforce/apex/RC_DtsBordroHesapController.deletePlan";

const actions = [
  {
    label: "Bordroya Bağlı Faturaları Göster",
    name: "showInvoice",
    iconName: "utility:info"
  },
  {
    label: "Bordroya Bağlı Çek Plan Giriş",
    name: "showCheque",
    iconName: "utility:info"
  },
  {
    label: "Bordroya Bağlı Çekleri göster",
    name: "getRelatedCheques",
    iconName: "utility:info"
  },
  {
    label: "Bordro Sil",
    name: "deleteBordro",
    iconName: "utility:info"
  }
];

export default class Rc_dtsbordrohesap extends LightningElement {
  @track bakiye = "10.000"; //şimdilik dummy değer girildi , normal senaryoda collection component üzerinden pass edilecek
  @track vade = "2020-01-01"; //şimdilik dummy değer girildi , normal senaryoda collection component üzerinden pass edilecek

  @api hidefilter = false;
  @api passedbordro;
  @api bayiid;

  @track isDisabledSendToSap = true;
  @track isLoading = false;
  @track readonlyCalcButton = true;

  @track selectedChequeNum = "";
  @track selectedMaturity = "";
  @track readonlyOPInput = false;

  @track planModel;
  @track odemePlanList = [];
  @track sourcePaymentPlanList;
  @track showOdemePlani = false;
  @track initialPlan;

  @track showSendSapButton = false;
  @track showInvoiceModal = false;
  @track showChequeModal = false;
  @track isOpenBordroRb;
  @track showBordroDatatable = false;
  @track bordroList = [];
  @track invoiceList = [];
  @track chequeList = [];
  @track bordroId;
  @track selectedAccountId;

  mainBordroColumns = [];
  planColumns = [];

  options = [
    { label: "Açık", value: "true" },
    { label: "Kapalı", value: "false" }
  ];

  constructor() {
    super();

    this.mainBordrocolumns = [
      {
        label: "Bordro No",
        fieldName: "RC_Bordro_No__c"
      },
      {
        label: "Bordro Oluşturma Tarihi",
        fieldName: "CreatedDate",
        type: "date-local",
        typeAttributes: {
          month: "2-digit",
          day: "2-digit"
        }
      },
      {
        label: "Vade",
        fieldName: "RC_Average_Due_Date__c",
        type: "date-local",
        typeAttributes: {
          month: "2-digit",
          day: "2-digit"
        }
      },
      {
        label: "Bakiye",
        fieldName: "RC_Amount__c",
        type: "currency",
        cellAttributes: {
          alignment: "right"
        },
        typeAttributes: {
          currencyCode: "TRY",
          step: "0.01"
        }
      },
      {
        type: "action",
        typeAttributes: {
          rowActions: this.getRowActions.bind(this)
        }
      }
    ];

    this.planColumns = [
      {
        label: "Çek Vade Tarihi",
        fieldName: "RC_Payment_Plan_Due_Date__c",
        type: "date-local",
        editable: true,
        typeAttributes: {
          month: "2-digit",
          day: "2-digit"
        }
      },
      {
        label: "Çek Tutar",
        fieldName: "RC_Payment_Plan_Amount__c",
        type: "currency",
        editable: true,
        typeAttributes: {
          currencyCode: "TRY",
          step: "0.01"
        }
      }
    ];
  }

  showToast(msg, type) {
    const evt = new ShowToastEvent({
      title: "",
      message: msg,
      variant: type,
      mode: "dismissable"
    });
    this.dispatchEvent(evt);
  }

  renderedCallback() {
    //loadScript(this, jQuery),
    if (this.passedbordro != undefined) {
      this.bordroId = this.passedbordro;
      this.selectedAccountId = this.bayiid;
      this.initializePlan();
      this.passedbordro = undefined;
    }

    loadStyle(this, CSS)
      .then(() => {
        console.log("Style Loaded.");
      })
      .catch((error) => console.log(error));
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;

    switch (actionName) {
      case "showInvoice":
        this.bordroId = event.detail.row["Id"];
        this.showInvoice();
        break;

      case "showCheque":
        this.bordroId = event.detail.row["Id"];
        this.initializePlan();

        break;

      case "getRelatedCheques":
        this.bordroId = event.detail.row["Id"];
        this.showRelatedCheques();
        break;

      case "deleteBordro":
        this.bordroId = event.detail.row["Id"];
        this.deleteBordro();
        break;
    }
  }

  handleCellChange(event) {
    let draftValues = event.detail.draftValues;

    draftValues.forEach((modifiedData) => {
      var relatedData = this.sourcePaymentPlanList.filter((data) => {
        return (
          data.RC_Payment_Plan_Number__c ==
          modifiedData.RC_Payment_Plan_Number__c
        );
      });

      let tempDataList = JSON.parse(JSON.stringify(relatedData));

      tempDataList.map((e) => {
        if (modifiedData.RC_Payment_Plan_Due_Date__c != undefined) {
          e.RC_Payment_Plan_Due_Date__c =
            modifiedData.RC_Payment_Plan_Due_Date__c;
        } else if (modifiedData.RC_Payment_Plan_Amount__c != undefined) {
          e.RC_Payment_Plan_Amount__c = parseFloat(
            modifiedData.RC_Payment_Plan_Amount__c
          );
        }
      });
      this.sourcePaymentPlanList = this.sourcePaymentPlanList.filter((data) => {
        return (
          data.RC_Payment_Plan_Number__c !=
          modifiedData.RC_Payment_Plan_Number__c
        );
      });

      this.sourcePaymentPlanList.push.apply(
        this.sourcePaymentPlanList,
        tempDataList
      );
    });

    draftValues = [];

    this.sourcePaymentPlanList.sort(function (a, b) {
      var dateA = new Date(a.RC_Payment_Plan_Due_Date__c),
        dateB = new Date(b.RC_Payment_Plan_Due_Date__c);
      return dateA - dateB;
    });

    this.odemePlanList = this.sourcePaymentPlanList;
    this.initialPlan.paymentPlan = this.sourcePaymentPlanList;
  }

  getRowActions(row, doneCallback) {
    const actionList = [];

    actions.forEach((action) => {
      if (this.isOpenBordroRb == "true") {
        if (action.name == "showInvoice") {
          actionList.push(action);
        } else if (action.name == "showCheque") {
          actionList.push(action);
        } else if (action.name == "deleteBordro") {
          actionList.push(action);
        }
      } else {
        if (action.name == "showInvoice") {
          actionList.push(action);
        } else if (action.name == "getRelatedCheques") {
          actionList.push(action);
        }
      }
    });

    doneCallback(actionList);
  }

  getBordroData(event) {
    if (this.isOpenBordroRb == undefined || this.isOpenBordroRb == "") {
      this.showToast("Seçim yapınız ! ", "error");
      return;
    }
    this.isLoading = true;

    getBordroList({
      isOpen: this.isOpenBordroRb,
      selectedAccountId: this.selectedAccountId
    })
      .then((data) => {
        if (data != undefined && data.length > 0) {
          this.bordroList = data;
          this.showBordroDatatable = true;
          this.isLoading = false;
        } else {
          this.showToast("Veri bulunamadı ! ", "error");
          this.showBordroDatatable = false;
          this.bordroList = [];
          this.isLoading = false;
        }
      })
      .catch((error) => {
        console.log("Get Bordro List Error : ", error);
        this.isLoading = false;
      });
  }

  radioChange(event) {
    this.isOpenBordroRb = event.detail.value;
  }

  showRelatedCheques(event) {
    this.chequeDataColumns = [
      {
        label: "Çek Numarası",
        fieldName: "RC_Cheque_Number__c"
      },
      {
        label: "Vade Tarihi",
        fieldName: "RC_Due_Date__c",
        type: "date-local",
        typeAttributes: {
          month: "2-digit",
          day: "2-digit"
        }
      },
      {
        label: "Tutar",
        fieldName: "RC_Amount__c",
        type: "currency",
        typeAttributes: {
          currencyCode: "TRY",
          step: "0.01"
        }
      }
    ];

    getBordroRelatedCheques({
      selectedBordroId: this.bordroId
    })
      .then((data) => {
        this.chequeList = data;

        this.showChequeModal = true;
      })
      .catch();
  }

  showInvoice(event) {
    this.invoiceDataColumns = [
      {
        label: "SAP Belge No",
        fieldName: "RC_Invoice_Number__c"
      },
      {
        label: "Belge Türü Tanımı",
        fieldName: "RC_Description__c"
      },
      {
        label: "Fatura İçeriği",
        fieldName: "RC_Product_Info__c"
      },
      {
        label: "Vade Tarihi",
        fieldName: "RC_Due_Date__c",
        type: "date-local",
        typeAttributes: {
          month: "2-digit",
          day: "2-digit"
        }
      },
      {
        label: "Tutar",
        fieldName: "RC_Amount__c",
        type: "currency",
        typeAttributes: {
          currencyCode: "TRY",
          step: "0.01"
        }
      }
    ];

    getRelatedInvoice({
      selectedBordroId: this.bordroId
    })
      .then((data) => {
        this.invoiceList = data;

        this.showInvoiceModal = true;
      })
      .catch();
  }

  initializePlan() {
    initializeOdemePlan({
      selectedBordroId: this.bordroId,
      brdBakiye: this.bakiye,
      brdOrtVade: this.vade
    })
      .then((data) => {
        if (data != null) {
          if (data.message != undefined && data.message.length > 0) {
            this.showToast(data.message, "warning");
          } else {
            if (data.checkToday) {
              this.selectedChequeNum = "1";
              this.selectedMaturity = "0";
            } else {
              this.selectedChequeNum = "6";
              this.selectedMaturity = "30";
            }

            this.initialPlan = data;
            this.planModel = data;
            this.odemePlanList = data.paymentPlan;
            this.sourcePaymentPlanList = data.paymentPlan;
            this.showOdemePlani = true;
          }
        }
      })
      .catch((error) => {
        this.showToast("Integration Error !", "error");
      });
  }

  handleSearchElements(event) {
    const srcName = event.srcElement.name;

    switch (srcName) {
      case "selectedChequeNum":
        this.selectedChequeNum = event.detail.value;
        break;
      case "selectedMaturity":
        this.selectedMaturity = event.detail.value;
        break;

      default:
    }
  }

  lockedPlan(event) {
    checkPlan({
      selectedBordroId: this.bordroId,
      paymentPlanList: this.sourcePaymentPlanList
    })
      .then((data) => {
        if (data.isSuccess) {
          this.planModel.hesaplananTutar = data.info.hesaplananTutar;

          this.planModel.hesaplananVade = data.info.hesaplananVade;

          this.planModel.farkTutar = data.info.farkTutar;

          this.planModel.farkVade = data.info.farkVade;

          deletePlan({
            selectedBordroId: this.bordroId
          })
            .then((data) => {
              if (data == true) {
                this.sourcePaymentPlanList.forEach((data) => {
                  data.Id = null;
                  data.RC_Bordro__c = this.bordroId;
                });
                console.log(JSON.stringify(this.sourcePaymentPlanList));
                processPaymentPlan({
                  paymentPlanList: this.sourcePaymentPlanList
                })
                  .then((data) => {
                    if (data == true) {
                      this.isDisabledSendToSap = false;
                      this.showToast("Plan kaydedildi ! ", "success");
                      this.initializePlan(event);
                    } else {
                      this.showToast(
                        "Plan kaydedilirken bir hata oluştu ! ",
                        "error"
                      );
                    }
                  })
                  .catch((error) => {
                    console.log("processPaymentPlan", error);
                  });
              } else {
                this.showToast("Plan silinirken bir hata oluştu ! ", "error");
              }
            })
            .catch((error) => {
              console.log("delete plan error :", error);
            });
        } else {
          this.isDisabledSendToSap = true;

          this.showSendSapButton = false;

          let elem = this.template.querySelector("[data-id='cbxAccept']");
          elem.checked = false;

          this.planModel.hesaplananTutar = data.info.hesaplananTutar;

          this.planModel.hesaplananVade = data.info.hesaplananVade;

          this.planModel.farkTutar = data.info.farkTutar;

          this.planModel.farkVade = data.info.farkVade;

          this.dispatchEvent(
            new ShowToastEvent({
              message: data.message,
              variant: "error"
            })
          );
        }
      })
      .catch((error) => {
        console.log("processPaymentPlan", error);
      });
  }

  sendPlanToSap(event) {
    sendPaymentPlanToSAP({
      paymentPlanList: this.sourcePaymentPlanList
    })
      .then((data) => {
        if (data.isSuccess == true) {
          this.showToast("Başarılı. ", "success");
          this.showOdemePlani = false;
          window.location.reload();
        } else {
          this.showToast(data.message, "error");
        }
      })
      .catch((error) => {
        console.log("processPaymentPlan Error : ", error);
      });
  }

  calculateOdemePlan(event) {
    this.isDisabledSendToSap = true;
    this.showSendSapButton = false;
    let elem = this.template.querySelector("[data-id='cbxAccept']");
    elem.checked = false;

    calculatePlan({
      selectedBordroId: this.bordroId,
      checkToday: this.initialPlan.checkToday,
      count: this.selectedChequeNum,
      range: this.selectedMaturity
    })
      .then((data) => {
        this.initialPlan = data;
        this.planModel = data;

        data.paymentPlan.sort(function (a, b) {
          var dateA = new Date(a.RC_Payment_Plan_Due_Date__c),
            dateB = new Date(b.RC_Payment_Plan_Due_Date__c);
          return dateA - dateB;
        });

        this.sourcePaymentPlanList = data.paymentPlan;
        this.odemePlanList = data.paymentPlan;

        return checkPlan({
          selectedBordroId: this.bordroId,
          paymentPlanList: data.paymentPlan
        });
      })
      .then((data) => {
        if (!data.isSuccess) {
          this.dispatchEvent(
            new ShowToastEvent({
              message: data.message,
              variant: "error"
            })
          );
        }
      })
      .catch((error) => {
        console.log("Custom Odeme Plan", error);
      });
  }

  calculateModifiedPaymentPlan(event) {
    this.isDisabledSendToSap = true;
    checkPlan({
      selectedBordroId: this.bordroId,
      paymentPlanList: this.sourcePaymentPlanList
    })
      .then((data) => {
        if (data.isSuccess) {
          this.isDisabledSendToSap = true;

          this.showSendSapButton = false;

          let elem = this.template.querySelector("[data-id='cbxAccept']");
          elem.checked = false;

          calculateGeneralInfo({
            selectedBordroId: this.bordroId,
            paymentPlanList: this.sourcePaymentPlanList
          })
            .then((data) => {
              if (data != null) {
                console.log(JSON.stringify(data));

                this.showToast("Hesaplandı. ", "success");

                this.planModel.bordro.RC_Amount__c = data.bordroTutar;

                this.planModel.bordro.RC_Average_Due_Date__c = data.bordroVade;

                this.planModel.hesaplananTutar = data.hesaplananTutar;

                this.planModel.hesaplananVade = data.hesaplananVade;

                this.planModel.farkTutar = data.farkTutar;

                this.planModel.farkVade = data.farkVade;
              }
            })
            .catch((error) => {
              console.log("Modified Plan Control", error);
            });
        } else {
          this.isDisabledSendToSap = true;

          this.showSendSapButton = false;

          let elem = this.template.querySelector("[data-id='cbxAccept']");
          elem.checked = false;

          this.planModel.hesaplananTutar = data.info.hesaplananTutar;

          this.planModel.hesaplananVade = data.info.hesaplananVade;

          this.planModel.farkTutar = data.info.farkTutar;

          this.planModel.farkVade = data.info.farkVade;

          this.dispatchEvent(
            new ShowToastEvent({
              message: data.message,
              variant: "error"
            })
          );
        }
      })
      .catch((error) => {
        console.log("Modified Plan Control", error);
      });
  }

  closeChequeModal(event) {
    this.showChequeModal = false;
  }

  closeModal(event) {
    switch (event.target.dataset.key) {
      case "permission":
        this.openPermissionModal = false;
        break;
      default:
        this.showInvoiceModal = false;
        break;
    }
  }

  closeOdemePlanModal() {
    const selectEvent = new CustomEvent("closechildcomponent", {
      bubbles: true,
      composed: true,
      cancelable: true,
      detail: {
        close : false,
        componentname : 'dts'
      }
    });

    this.dispatchEvent(selectEvent);
    this.showOdemePlani = false;
  }

  formatDate(dateVal) {
    if (dateVal != undefined) {
      let splittedDate = dateVal.split("-");

      let result =
        splittedDate[2] + "." + splittedDate[1] + "." + splittedDate[0];

      return result;
    }
  }

  CbxAccept(event) {
    if (event.currentTarget.checked) {
      this.showSendSapButton = true;
    } else {
      this.showSendSapButton = false;
    }
  }

  deleteBordro(event) {
    this.isLoading = false;

    deleteSelectedBordro({
      selectedBordroId: this.bordroId
    })
      .then((data) => {
        if (data) {
          this.showToast("Bordro Başarıyla Silindi.", "success");
          this.getBordroData();
        } else {
          this.showToast("Bordro Silinirken Hata Olu ! ", "error");
        }
        this.isLoading = false;
      })
      .catch((error) => {
        console.log("Delete Bordro Error : ", error);
        this.isLoading = false;
      });
  }
}