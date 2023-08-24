import { LightningElement, api, track, wire } from "lwc";
import getBABSOzet from "@salesforce/apex/RC_BABSOzet.getBABSOzet";
import getBABSDetay from "@salesforce/apex/RC_BABSDetay.getBABSDetay";

import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import SAP_ID_FIELD from "@salesforce/schema/Account.RC_SAP_ID__c";

/*
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
*/
export default class BABSLwc extends LightningElement {
  @track year = "";
  @track month = "";
  @api recordId;
  @track objectInfo;

  @track ozetDataBA = [];
  @track ozetDataBS = [];
  @track detayDataBA = [];
  @track detayDataBS = [];
  @track showBADetay = false;
  @track showBSDetay = false;
  @track showOzet = false;

  @track account;
  @track isLoading = false;
  @track isErrorPopOpen = false;
  @track detayDataFinal = {};

  @track page = 1;
  @track items = [];
  @track detayDataOnScreenBS = [];
  @track detayDataOnScreenBA = [];
  @track columns;
  @track startingRecord = 1;
  @track endingRecord = 0;
  @track pageSize = 100;
  @track totalPage = 100;

  @wire(getRecord, { recordId: "$recordId", fields: [SAP_ID_FIELD] })
  account;

  get sapId() {
    return getFieldValue(this.account.data, SAP_ID_FIELD);
  }

  get ozetColumns() {
    return [
      { label: "Firma Ünvanı", fieldName: "MANDT" },
      { label: "BA Raporu", fieldName: "DONEM" },
      { label: "Ay", fieldName: "AY" },
      { label: "Yıl", fieldName: "YIL" },
      { label: "Vergi Kimlik No", fieldName: "VKN" },
      { label: "TC Kimlik No", fieldName: "TCN" },
      { label: "Fatura Adedi", fieldName: "ADET" },
      { label: "Fatura Tutarı", fieldName: "MATRAH", type: "currency" },
      {
        label: "Detay",
        fieldName: "asd",
        type: "button-icon",
        typeAttributes: { iconName: "utility:search" }
      }
    ];
  }

  get detayColumns() {
    return [
      { label: "Başlangıç Tarihi", fieldName: "BUDAT" },
      { label: "Bitiş Tarihi", fieldName: "CPUDT" },
      { label: "No", fieldName: "BELNR" },
      { label: "Adet", fieldName: "ADET" },
      { label: "DMBTR", fieldName: "DMBTR" },
      { label: "KDV", fieldName: "KDV" },
      { label: "Fatura Tutarı", fieldName: "MATRAH", type: "currency" }
    ];
  }

  get months() {
    return [
      { label: "Ocak", value: "01" },
      { label: "Şubat", value: "02" },
      { label: "Mart", value: "03" },
      { label: "Nisan", value: "04" },
      { label: "Mayıs", value: "05" },
      { label: "Haziran", value: "06" },
      { label: "Temmuz", value: "07" },
      { label: "Ağustos", value: "08" },
      { label: "Eylül", value: "09" },
      { label: "Ekim", value: "10" },
      { label: "Kasım", value: "11" },
      { label: "Aaralık", value: "12" }
    ];
  }
  get years() {
    return [
      { label: "2021", value: "2021" },
      { label: "2020", value: "2020" },
      { label: "2019", value: "2019" },
      { label: "2018", value: "2018" },
      { label: "2017", value: "2017" },
      { label: "2016", value: "2016" },
      { label: "2015", value: "2015" },
      { label: "2014", value: "2014" },
      { label: "2013", value: "2013" },
      { label: "2012", value: "2012" },
      { label: "2011", value: "2011" }
    ];
  }

  previousHandlerBA() {
    if (this.page > 1) {
      this.page = this.page - 1;
      this.displayRecordPerPageBA(this.page);
    }
  }

  nextHandlerBA() {
    if (this.page < this.totalPage && this.page !== this.totalPage) {
      this.page = this.page + 1;
      console.log("getting  next page of records");
      this.displayRecordPerPageBA(this.page);
    }
  }

  previousHandlerBS() {
    if (this.page > 1) {
      this.page = this.page - 1;
      this.displayRecordPerPageBS(this.page);
    }
  }

  nextHandlerBS() {
    if (this.page < this.totalPage && this.page !== this.totalPage) {
      this.page = this.page + 1;
      console.log("getting  next page of records");
      this.displayRecordPerPageBS(this.page);
    }
  }

  displayRecordPerPageBA(page) {
    this.startingRecord = (page - 1) * this.pageSize;
    this.endingRecord = this.pageSize * page;

    console.log(
      "cutting data between " +
        this.startingRecord +
        " and " +
        this.endingRecord
    );

    this.detayDataOnScreenBA = this.detayDataBA.slice(
      this.startingRecord,
      this.endingRecord
    );

    this.startingRecord = this.startingRecord + 1;
    console.log("succesfully got  next page of records");
  }

  displayRecordPerPageBS(page) {
    this.startingRecord = (page - 1) * this.pageSize;
    this.endingRecord = this.pageSize * page;

    console.log(
      "cutting data between " +
        this.startingRecord +
        " and " +
        this.endingRecord
    );

    this.detayDataOnScreenBS = this.detayDataBS.slice(
      this.startingRecord,
      this.endingRecord
    );

    this.startingRecord = this.startingRecord + 1;
    console.log("succesfully got  next page of records");
  }

  handleMonthChange(event) {
    this.month = event.detail.value;
    console.log("month is : " + this.month);
  }

  handleYearChange(event) {
    this.year = event.detail.value;
    console.log("year is : " + this.year);
    console.log("sap id is : " + this.sapId);
  }

  closeModal() {
    this.isErrorPopOpen = false;
  }

  getOzet(event) {
    try {
      getBABSOzet({
        yearmonth: this.year + this.month,
        accountSAPId: this.sapId
      })
        .then((result) => {
          this.ozetDataBA = JSON.parse(result);
          this.ozetDataBA = this.ozetDataBA.BA.item;

          this.ozetDataBA.forEach((element) => {
            element.AY = this.month;
            element.YIL = this.year;
          });

          this.ozetDataBS = JSON.parse(result);
          this.ozetDataBS = this.ozetDataBS.BS.item;

          this.ozetDataBS.forEach((element) => {
            element.AY = this.month;
            element.YIL = this.year;
          });

          this.showOzet = true;
          console.log("sucesss");
          //console.log("accountSAPID is :  " + JSON.stringify(this.objectInfo));
          console.log(" BA data is : " + JSON.stringify(this.ozetDataBA));
          console.log(" BS data is : " + JSON.stringify(this.ozetDataBS));
        })
        .catch((error) => {
          console.log("error");
          this.error = error;
        });
    } catch (err) {
      console.log(err);
    }
  }

  getDetay(event) {
    this.isLoading = true;
    try {
      getBABSDetay({
        yearmonth: this.year + this.month,
        accountSAPId: this.sapId
      })
        .then((result) => {
          this.detayDataBA = JSON.parse(result);
          if (this.detayDataBA.BA != null) {
            this.detayDataBA = this.detayDataBA.BA.item;
            this.detayDataBA = this.modifyDetayFields(this.detayDataBA);
            this.detayDataOnScreenBA = this.detayDataBA.slice(0, this.pageSize);
            this.showBADetay = true;
          }
          this.detayDataBS = JSON.parse(result);
          if (this.detayDataBS.BS != null) {
            this.detayDataBS = JSON.parse(result);
            this.detayDataBS = this.detayDataBS.BS.item;
            this.detayDataBS = this.modifyDetayFields(this.detayDataBS);
            this.detayDataOnScreenBS = this.detayDataBS.slice(0, this.pageSize);
            this.showBSDetay = true;
          }

          this.isLoading = false;
          console.log("sucesss");
        })
        .catch((error) => {
          console.log("error");
          this.isLoading = false;
          this.error = error;
          this.isErrorPopOpen = true;
        });
    } catch (err) {
      console.log(err);
    }
  }

  modifyDetayFields(array) {
    array.forEach((element) => {
      delete element.DONEM;
      delete element.BLGTUR;
      delete element.MUHATAP;
      delete element.NAME1;
      delete element.ULKE;
      delete element.VKN;
      delete element.TCN;
      delete element.MWSKZ;
    });
    return array;
  }
}