import { LightningElement, api, track, wire } from "lwc";
import getBABSOzet from "@salesforce/apex/RC_BABSOzet.getBABSOzet";
import getBABSDetay from "@salesforce/apex/RC_BABSDetay.getBABSDetay";
import getUserRelatedAccount from "@salesforce/apex/RC_UtilitiesClass.getUserRelatedAccount";

import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import SAP_ID_FIELD from "@salesforce/schema/Account.RC_SAP_ID__c";

// RC_FileSaver içeride oluşturulan Static Resources, loadScript ise yüklenen js static resource unu load etmek amacıyla tanımlandı.
import RC_FileSaver from '@salesforce/resourceUrl/RC_FileSaver';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import MyOrdersCSS from '@salesforce/resourceUrl/myordersCSS';

export default class BABSLwc extends LightningElement {
  @track year = "";
  @track month = "";
  @api recordId;
  @track objectInfo;

  @track ozetDataBA = [];
  @track ozetDataBS = [];
  @track ozetData = [];
  @track detayDataBA = [];
  @track detayDataBS = [];
  @track showBADetay = false;
  @track showBSDetay = false;
  @track showOzet = false;

  @track account;
  @track isLoading = false;
  @track isErrorPopOpen = false;
  @track detayDataFinal = {};

  @track pageBA = 1;
  @track pageBS = 1;
  @track items = [];
  @track detayDataOnScreenBS = [];
  @track detayDataOnScreenBA = [];
  @track columns;
  @track startingRecordBA = 1;
  @track endingRecordBA = 0;
  @track startingRecordBS = 1;
  @track endingRecordBS = 0;
  @track pageSize = 100;
  @track totalPageBA;
  @track totalPageBS;
  @track showPagingBA = false;
  @track showPagingBS = false;

  // wire to get accounts SAPId and later send it to rest integration in backend
  @wire(getRecord, { recordId: "$recordId", fields: [SAP_ID_FIELD] })
  account;

  get sapId() {
    return getFieldValue(this.account.data, SAP_ID_FIELD);
  }

  get ozetColumns() {
    return [
      /*
      { label: "Firma Ünvanı", fieldName: "MANDT" },
      { label: "BA Raporu", fieldName: "DONEM" },
      { label: "Ay", fieldName: "AY" },
      { label: "Yıl", fieldName: "YIL" },
      { label: "Vergi Kimlik No", fieldName: "VKN" },
      { label: "TC Kimlik No", fieldName: "TCN" },
      */

      {
        label: "Özet Tipi",
        fieldName: "BLGTUR",
        cellAttributes: { alignment: "left" }
      },
      {
        label: "Fatura Adeti",
        fieldName: "ADET",
        cellAttributes: { alignment: "left" }
      },
      {
        label: "Fatura Tutarı",
        fieldName: "MATRAH",
        type: "currency",
        cellAttributes: { alignment: "left" },
        typeAttributes: { currencyCode: "TRY", currencyDisplayAs: "code" }
      },

      {
        label: "Detay",
        fieldName: "BLGTUR",
        type: "button-icon",
        typeAttributes: { iconName: "utility:search" }
      }
    ];
  }

  get detayColumns() {
    return [
      {
        label: "Başlangıç Tarihi",
        fieldName: "BUDAT",
        cellAttributes: { alignment: "left" }
      },
      {
        label: "Bitiş Tarihi",
        fieldName: "CPUDT",
        cellAttributes: { alignment: "left" }
      },
      {
        label: "No",
        fieldName: "BELNR",
        initialWidth: 100,
        cellAttributes: { alignment: "left" }
      },
      {
        label: "Adet",
        initialWidth: 60,
        fieldName: "ADET",
        cellAttributes: { alignment: "left" }
      },
      {
        label: "KDV'siz Fatura Tutarı",
        fieldName: "MATRAH",
        type: "currency",
        initialWidth: 160,
        cellAttributes: { alignment: "left" },
        typeAttributes: { currencyCode: "TRY", currencyDisplayAs: "code" }
      },
      {
        label: "KDV",
        fieldName: "KDV",
        type: "currency",
        initialWidth: 120,
        cellAttributes: { alignment: "left" },
        typeAttributes: { currencyCode: "TRY", currencyDisplayAs: "code" }
      },
      {
        label: "Fatura Tutarı",
        fieldName: "DMBTR",
        type: "currency",
        initialWidth: 120,
        cellAttributes: { alignment: "left" },
        typeAttributes: { currencyCode: "TRY", currencyDisplayAs: "code" }
      }
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
      { label: "2019", value: "2019" }
    ];
  }

  previousHandlerBA() {
    if (this.pageBA > 1) {
      this.pageBA = this.pageBA - 1;
      this.displayRecordPerPageBA(this.pageBA);
    }
  }

  nextHandlerBA() {
    if (this.pageBA < this.totalPageBA && this.pageBA !== this.totalPageBA) {
      this.pageBA = this.pageBA + 1;
      console.log("getting  next page of records");
      this.displayRecordPerPageBA(this.pageBA);
    }
  }

  previousHandlerBS() {
    if (this.pageBS > 1) {
      this.pageBS = this.pageBS - 1;
      this.displayRecordPerPageBS(this.pageBS);
    }
  }

  nextHandlerBS() {
    if (this.pageBS < this.totalPageBS && this.pageBS !== this.totalPageBS) {
      this.pageBS = this.pageBS + 1;
      console.log("getting  next page of records");
      this.displayRecordPerPageBS(this.pageBS);
    }
  }

  displayRecordPerPageBA(page) {
    this.startingRecordBA = (page - 1) * this.pageSize;
    this.endingRecordBA = this.pageSize * page;

    console.log(
      "cutting data between " +
        this.startingRecordBA +
        " and " +
        this.endingRecordBA
    );

    this.detayDataOnScreenBA = this.detayDataBA.slice(
      this.startingRecordBA,
      this.endingRecordBA
    );

    this.startingRecordBA = this.startingRecordBA + 1;
    console.log("succesfully got  next page of records");
  }

  displayRecordPerPageBS(page) {
    this.startingRecordBS = (page - 1) * this.pageSize;
    this.endingRecordBS = this.pageSize * page;

    console.log(
      "cutting data between " +
        this.startingRecordBS +
        " and " +
        this.endingRecordBS
    );

    this.detayDataOnScreenBS = this.detayDataBS.slice(
      this.startingRecordBS,
      this.endingRecordBS
    );

    this.startingRecordBS = this.startingRecordBS + 1;
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

  handleRowAction(event) {
    if (event.detail.row.BLGTUR == "BA") {
      this.getDetayBA(event);
    } else if (event.detail.row.BLGTUR == "BS") {
      this.getDetayBS(event);
    }
  }
  getOzet(event) {
    this.isLoading = true;
    this.ozetData = [];
    var sapid = this.sapId;
    try {
      if(sapid == undefined){
        getUserRelatedAccount()
        .then((data) => {
          if(data != undefined && data != null){
            return getBABSOzet({
              yearmonth: this.year + this.month,
              accountSAPId: data.RC_SAP_ID__c
            });
          }
        })
        .then((result) => {
         if(result != null && result != undefined){
          this.ozetDataBA = JSON.parse(result);
          this.ozetDataBA = this.ozetDataBA.BA.item;
          this.ozetDataBS = JSON.parse(result);
          this.ozetDataBS = this.ozetDataBS.BS.item;
          this.ozetData.push(this.ozetDataBA[0]);
          this.ozetData.push(this.ozetDataBS[0]);
          this.showOzet = true;
          console.log("ozetdata is : " + JSON.stringify(this.ozetData));
          this.showBADetay = false;
          this.showBSDetay = false;
          this.isLoading = false;
         }
        })
        .catch((error) => {
          console.log(error);
          this.isLoading = false;
          this.error = error;
          this.isErrorPopOpen = true;
          this.showBADetay = false;
          this.showBSDetay = false;
          this.showOzet = false;
        });
      }
        else{
          getBABSOzet({
            yearmonth: this.year + this.month,
            accountSAPId: sapid
          }).then((result) => {
            if(result != null && result != undefined){
             this.ozetDataBA = JSON.parse(result);
             this.ozetDataBA = this.ozetDataBA.BA.item;
             this.ozetDataBS = JSON.parse(result);
             this.ozetDataBS = this.ozetDataBS.BS.item;
             this.ozetData.push(this.ozetDataBA[0]);
             this.ozetData.push(this.ozetDataBS[0]);
             this.showOzet = true;
             console.log("ozetdata is : " + JSON.stringify(this.ozetData));
             this.showBADetay = false;
             this.showBSDetay = false;
             this.isLoading = false;
            }
           })
           .catch((error) => {
             console.log(error);
             this.isLoading = false;
             this.error = error;
             this.isErrorPopOpen = true;
             this.showBADetay = false;
             this.showBSDetay = false;
             this.showOzet = false;
           });
        }
    } catch (err) {
      console.log(err);
    }
  }

  getDetayBA(event) {
    this.isLoading = true;
    this.detayDataBA = [];
    try {
      if(this.sapid == undefined){
        getUserRelatedAccount()
        .then((data) => {
          if(data != undefined && data != null){
            return getBABSDetay({
              yearmonth: this.year + this.month,
              accountSAPId: data.RC_SAP_ID__c
            });
          }
        })
        .then((result) => {
          this.detayDataBA = JSON.parse(result);
          if (this.detayDataBA != null && this.detayDataBA != "" && this.detayDataBA.BA != null && this.detayDataBA.BA != "") {
            this.detayDataBA = JSON.parse(result);
            this.detayDataBA = this.detayDataBA.BA.item;
            this.detayDataBA = this.modifyDetayFields(this.detayDataBA);
            this.totalPageBA = Math.ceil(
              this.detayDataBA.length / this.pageSize
            );
            if (this.totalPageBA != 1) this.showPagingBA = true;
            this.detayDataOnScreenBA = this.detayDataBA.slice(0, this.pageSize);
            this.showBADetay = true;
          } else this.isErrorPopOpen = true;

          this.isLoading = false;
          this.showBSDetay = false;
          console.log("sucesss");
        })
        .catch((error) => {
          console.log(error);
          this.isLoading = false;
          this.error = error;
          this.isErrorPopOpen = true;
        });
      }
      else{
        getBABSDetay({
          yearmonth: this.year + this.month,
          accountSAPId: this.sapId
        })
          .then((result) => {
            this.detayDataBA = JSON.parse(result);
            if (this.detayDataBA != null && this.detayDataBA != "" && this.detayDataBA.BA != null && this.detayDataBA.BA != "") {
              this.detayDataBA = JSON.parse(result);
              this.detayDataBA = this.detayDataBA.BA.item;
              this.detayDataBA = this.modifyDetayFields(this.detayDataBA);
              this.totalPageBA = Math.ceil(
                this.detayDataBA.length / this.pageSize
              );
              if (this.totalPageBA != 1) this.showPagingBA = true;
              this.detayDataOnScreenBA = this.detayDataBA.slice(0, this.pageSize);
              this.showBADetay = true;
            } else this.isErrorPopOpen = true;
  
            this.isLoading = false;
            this.showBSDetay = false;
            console.log("sucesss");
          })
          .catch((error) => {
            console.log(error);
            this.isLoading = false;
            this.error = error;
            this.isErrorPopOpen = true;
          });
      }
    } catch (err) {
      console.log(err);
    }
  }

  getDetayBS(event) {
    this.isLoading = true;
    this.detayDataBS = [];
    try {
      if(this.sapid == undefined){
        getUserRelatedAccount()
        .then((data) => {
          if(data != undefined && data != null){
            return getBABSDetay({
              yearmonth: this.year + this.month,
              accountSAPId: data.RC_SAP_ID__c
            })
            .then((result) => {
              this.detayDataBS = JSON.parse(result);
    
              if (this.detayDataBS != null && this.BS != "" && this.detayDataBS.BS != null && this.detayDataBS.BS != "") {
                this.detayDataBS = JSON.parse(result);
                this.detayDataBS = this.detayDataBS.BS.item;
                this.detayDataBS = this.modifyDetayFields(this.detayDataBS);
                this.totalPageBS = Math.ceil(
                  this.detayDataBS.length / this.pageSize
                );
                if (this.totalPageBS != 1) this.showPagingBS = true;
                this.detayDataOnScreenBS = this.detayDataBS.slice(0, this.pageSize);
                this.showBSDetay = true;
              } else this.isErrorPopOpen = true;
    
              console.log(JSON.stringify(this.detayDataBS));
              this.isLoading = false;
              this.showBADetay = false;
              console.log("sucesss");
            })
            .catch((error) => {
              console.log(error);
              this.isLoading = false;
              this.error = error;
              this.isErrorPopOpen = true;
            });
          }
        })
      }
        else{
          getBABSDetay({
            yearmonth: this.year + this.month,
            accountSAPId: this.sapId
          })
            .then((result) => {
              this.detayDataBS = JSON.parse(result);
    
              if (this.detayDataBS != null && this.BS != "" && this.detayDataBS.BS != null && this.detayDataBS.BS != "") {
                this.detayDataBS = JSON.parse(result);
                this.detayDataBS = this.detayDataBS.BS.item;
                this.detayDataBS = this.modifyDetayFields(this.detayDataBS);
                this.totalPageBS = Math.ceil(
                  this.detayDataBS.length / this.pageSize
                );
                if (this.totalPageBS != 1) this.showPagingBS = true;
                this.detayDataOnScreenBS = this.detayDataBS.slice(0, this.pageSize);
                this.showBSDetay = true;
              } else this.isErrorPopOpen = true;
    
              console.log(JSON.stringify(this.detayDataBS));
              this.isLoading = false;
              this.showBADetay = false;
              console.log("sucesss");
            })
            .catch((error) => {
              console.log(error);
              this.isLoading = false;
              this.error = error;
              this.isErrorPopOpen = true;
            });
        }
      }
     
    catch (err) {
      console.log(err);
    }
  }
  modifyDetayFields(array) {
    array.forEach((element) => {
      delete element.DONEM;
      delete element.MUHATAP;
      delete element.NAME1;
      delete element.ULKE;
      delete element.VKN;
      delete element.TCN;
      delete element.MWSKZ;
    });
    return array;
  }

   // Download Data as CSV
   downloadBaTable(){
    console.log('downloadBaTable');
    debugger;
    this.prepareBaData();
  };

downloadBsTable(){
  console.log('downloadBsTable');
  debugger;
  this.prepareBsData();
};

prepareBaData(){
    this.isLoading = true;

    if(this.detayDataBA != null && this.detayDataBA.length > 0){
        this.fileDownload(this.detayDataBA);
    }
};

prepareBsData(){
  this.isLoading = true;

  if(this.detayDataBS != null && this.detayDataBS.length > 0){
      this.fileDownload(this.detayDataBS);
  }
};

 //RenderedCallback fonksiyonun amacı import edilen static resource js i load etmek için gereklidir.
 renderedCallback() {
    debugger;
   loadScript(this, RC_FileSaver)
   .then(() => console.log('Loaded sayHello'))
   .catch(error => console.log(error));   
   loadStyle(this, MyOrdersCSS)
   .then()
   .catch(error => console.log(error));
};

fileDownload(detayData) { 
  try{       
    debugger;
      // call the helper function which "return" the CSV data as a String   
      var csv = this.convertArrayOfObjectsToCSV(detayData);
      if (csv == null) { return; }
      
      var blob = new Blob(["\ufeff",csv], { type: "" });
      var fileName = 'Ba_Bs_rapor.csv';
      
      window.saveAs(blob, fileName);    
      
      this.isLoading = false;
  }
  catch(e){
      console.log(e);
  } 
};

convertArrayOfObjectsToCSV(objectRecords) {
  debugger;
  
  // declare variables
  var csvStringResult, counter, keys, columnDivider, lineDivider, keysHeader;
debugger;
  // check if "objectRecords" parameter is null, then return from function
  if (objectRecords == null || !objectRecords.length) {
      return null;
  }
  // store ,[comma] in columnDivider variabel for sparate CSV values and 
  // for start next line use '\n' [new line] in lineDivider varaible  
  columnDivider = ';';
  lineDivider = '\n';

  // in the keys valirable store fields API Names as a key 
  // this labels use in CSV file header  

  this.columns = this.detayColumns;
  console.log(this.columns);

  var keys = [];
  var keysHeader = [];
  for (var i = 0; i < this.columns.length; i++) {
      var column = this.columns[i];

      if(column.label == "") continue;

      keys.push(column.fieldName);
      keysHeader.push(column.label.replace(/(\r\n|\n|\r)/gm, ""));
  }
  
  csvStringResult = '';
  csvStringResult += "\"" + keysHeader.join("\"" + columnDivider + "\"") + "\"";
  csvStringResult += lineDivider;

  for (var i = 0; i < objectRecords.length; i++) {
      counter = 0;
      
      for (var sTempkey in keys) {
          var skey = keys[sTempkey];

          // add , [comma] after every String value,. [except first]
          if (counter > 0) {
              csvStringResult += columnDivider;
          }
          var data = objectRecords[i][skey];
          if (data == undefined) {
              data = '';
          }

          if(skey == 'MATRAH' || skey == 'KDV' || skey == 'DMBTR'){
              console.log(parseFloat(data).toFixed(2));
              data = parseFloat(data).toFixed(2);
          }
                          
          csvStringResult += '"' + data + '"';

          counter++;
      } 
      csvStringResult += lineDivider;
  }

  return csvStringResult;
};

 
}