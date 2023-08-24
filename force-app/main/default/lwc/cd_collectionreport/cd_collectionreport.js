import { LightningElement, wire, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import CSS from "@salesforce/resourceUrl/CollectionReportCSS";
import initialize from "@salesforce/apex/CollectionReportController.initialize";
import getDocumentOnDemand from "@salesforce/apex/CollectionReportController.getDocumentOnDemand";
import ortalamaVadeBul from "@salesforce/apex/CollectionReportController.ortalamaVadeBul";
import BordroKaydet from "@salesforce/apex/CollectionReportController.BordroKaydet";
import BordroYaratDTS from "@salesforce/apex/CollectionReportController.BordroYaratDTS";
import RC_FileSaver from '@salesforce/resourceUrl/RC_FileSaver';
const DELAY = 2000;

export default class Cd_collectionreport extends LightningElement {

  @track backupVadeTarihi = '2020-01-01'; //şimdilik dummy değer girildi , normal senaryoda collection component üzerinden pass edilecek
  @track backupBakiye = '10.000';         //şimdilik dummy değer girildi , normal senaryoda collection component üzerinden pass edilecek
  @track isCalculated = false;

  @track disabledCreateBordroButton = false;
  @track isShowSearchComponent = true;
  @track isShowCekComponent = false;
  @track isShowDTSCekComponent = false;
  @track bordroId;
  @track hideFilter = true;

  @track isLoading = false;

  //For custom lookup field
  fields = ["Name", "RC_SAP_ID__c"];
  displayFields = "Name,RC_SAP_ID__c";
  whereClauses = "WHERE RC_Dealer_Type__c = \'BAYI\'";
  
  @track selectedAccountId;

  @track ortVadeDateInput;
  @track toplamTutar;
  @track initToplamTutar;

  @track tableDataList = [];
  @track tableDataListBackup = [];
  @track isShowDataTable = false;
  @track isShowTableCheckbox = false;
  @track selectedItemSize;
  @track selectAllCbxChecked = false;

  @track isDisabledFilter = true;

  @track initModel;

  //Picklist Attributes
  @track krediKontrolPicklist;
  @track surecTipiPicklist;
  @track belgeTuruPicklist;
  @track odemeBicimiPicklist;
  @track OdemeBlokajPicklist;


  @track selectedOdemeBlokaj = "";
  @track selectedOdemeBlokajLabel = "";
  @track selectedKrediKontrol = "";
  @track selectedSurecTipi = "";
  @track selectedBelgeTuru = "";
  @track selectedBelgeTuruLabel = "";
  @track selectedOdemeBicimi = "";
  @track selectedOdemeBicimiLabel = "";
  @track selectedBelgeTarihi = "";
  @track selectedVadeTarihi = "";
  @track selectedODK = "";
  @track filteredBelgeNo = "";
  @track filteredVadeTarihi = "";
  @track filteredkayitTarihi = "";

  @track PACKAGE = 1000;
  @track INDEX = 0;

  @track bayiDataList;
  @track selectedBayi;
  @track isShowBayiLookupData = false;
  @track isDTS;
  @track isCommunity = false; 
  @track isOpenCreateBordroButton = true;

  constructor() {
    super();
    this.initComponent();
  }

  clearFilter(event) {
    this.selectedVadeTarihi = "";
    this.selectedBelgeTarihi = "";
    this.selectedKrediKontrol = "";
    this.selectedSurecTipi = "";
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
    loadScript(this, RC_FileSaver),
    loadStyle(this, CSS)
      .then(() => {
        console.log("Style Loaded.");
        console.log("Script Loaded.");
      })
      .catch((error) => console.log(error));
  }

  initComponent(event) {
    initialize()
      .then((data) => {
        debugger;
        this.initModel = data;
        this.krediKontrolPicklist = data.krediKontrolPicklist;
        this.surecTipiPicklist = data.surecTipiPicklist;
        this.belgeTuruPicklist = data.belgeTuruPicklist;
        this.odemeBicimiPicklist = data.odemeBicimiPicklist;
        this.OdemeBlokajPicklist = data.OdemeBlokajPicklist;
        this.isCommunity = data.isCommunity;

        if(this.isCommunity){
          this.isShowSearchComponent = false;
          this.selectedAccountId = data.selectedAccountId;
        }
      })
      .catch((error) => {
        console.log(error);
      });
  }

  handleComboboxChange(event) {
    switch (event.currentTarget.name) {
      case "kredi":
        this.selectedKrediKontrol = event.currentTarget.value;
        break;

      case "surec":
        this.selectedSurecTipi = event.currentTarget.value;

        if(this.selectedSurecTipi == '02' && this.isDTS == false){
            var Id = event.target.id;
            var Element123 = this.template.querySelector("[id='"+Id+"']");
            Element123.value = '';
            this.selectedSurecTipi = '';
            this.showToast("İşlem yapılan bayi DTS olmadığı için süreç tipi DTS seçilemez !", "error");
            return;
        }

        

        if ((this.selectedSurecTipi == '03' || this.selectedSurecTipi == '01') && this.isCommunity) {
          this.isOpenCreateBordroButton = false;
        }else{
          this.isOpenCreateBordroButton = true;
        }

        break;
        
      case "belge":
        this.selectedBelgeTuru = event.currentTarget.value;
        if (this.selectedBelgeTuru == "") {
          this.tableDataList = this.tableDataListBackup;
        } else {
          this.selectedBelgeTuruLabel = event.target.options.find((opt) => opt.value === event.currentTarget.value).label;
          this.tableDataList = this.tableDataListBackup.filter((q) => q.LTEXT == this.selectedBelgeTuruLabel);
        }
        break;

      case "odeme":
        this.selectedOdemeBicimi = event.currentTarget.value;
        if (this.selectedOdemeBicimi == "") {
          this.tableDataList = this.tableDataListBackup;
        } else {
          this.selectedOdemeBicimiLabel = event.target.options.find((opt) => opt.value === event.currentTarget.value).label;
          this.tableDataList = this.tableDataListBackup.filter((q) => q.ZLSCH == this.selectedOdemeBicimiLabel);
        }
        break;

        case "odemeblokaj":
        this.selectedOdemeBlokaj = event.currentTarget.value;
        if (this.selectedOdemeBlokaj == "") {
          this.tableDataList = this.tableDataListBackup;
        } else {
          this.selectedOdemeBlokajLabel = event.target.options.find((opt) => opt.value === event.currentTarget.value).label;
          this.tableDataList = this.tableDataListBackup.filter((q) => q.ZLSPR == this.selectedOdemeBlokajLabel);
        }
        break;

    }
  }

  handleInputChange(event) {
    switch (event.currentTarget.name) {
      case "belgeNo":
        this.filteredBelgeNo = event.currentTarget.value;
        if (this.filteredBelgeNo == "") {
          this.tableDataList = this.tableDataListBackup;
        } else {
          this.tableDataList = this.tableDataList.filter((q) =>
            q.BELNR.includes(this.filteredBelgeNo)
          );
        }
        break;
      case "belgeTuru":
        this.filteredBelgeturu = event.currentTarget.value;
        if (this.filteredBelgeturu == "") {
          this.tableDataList = this.tableDataListBackup;
        } else {
          this.tableDataList = this.tableDataList.filter((q) =>
            q.BLART.includes(this.filteredBelgeturu)
          );
        }
        break;
        break;
      case "kayitTarihi":
        this.filteredkayitTarihi = event.currentTarget.value;
        if (this.filteredkayitTarihi == "") {
          this.tableDataList = this.tableDataListBackup;
        } else {
          this.tableDataList = this.tableDataList.filter((q) =>
            q.BUDAT.includes(this.filteredkayitTarihi)
          );
        }
        break;
      case "VadeTarihi":
        this.filteredVadeTarihi = event.currentTarget.value;
        if (this.filteredVadeTarihi == "") {
          this.tableDataList = this.tableDataListBackup;
        } else {
          this.tableDataList = this.tableDataList.filter((q) =>
            q.ZFBDT.includes(this.filteredVadeTarihi)
          );
        }
        break;
    }
  }

  getDocumentOnClick(event) {
    this.tableDataList = [];
    this.tableDataListBackup = [];
    this.isLoading = true;
    if (this.selectedAccountId == null || this.selectedAccountId == undefined || this.selectedAccountId == "") {
      this.isLoading = false;
      this.showToast("Lütfen Bayi Seçimi Yapınız", "error");
      return;
    }
    getDocumentOnDemand({
      accountId: this.selectedAccountId,
      surID: this.selectedSurecTipi,
      KKBER: this.selectedKrediKontrol,
      KEYDATE: this.selectedBelgeTarihi,
      VADETARIHI: this.selectedVadeTarihi,
      ODK: this.selectedODK,
      packageSize: this.PACKAGE,
      INDEX: this.INDEX
    })
      .then((data) => {
        this.isDTS = data.isDTS;
        data.itemList.forEach((element) => {
          element.isChecked = true;
          element.isEmptyZLSCH = false;
          element.isEmptyZLSPR = false;
          if (element.MATNR != undefined && element.MATNR.item != undefined && element.MATNR.item.length > 0) {
            element.formattedProductInfo = "";
            element.MATNR.item.forEach((item) => {
              let parsedmatnr = parseInt(item.MATNR, 10);
              element.formattedProductInfo +="* " + parsedmatnr.toString() +" - " + item.MAKTX + " - " + item.FKIMG.replace(".000", "") + " - " + "ADT" + "</br>";
            });
          }
          if (element.ZLSCH == '' || element.ZLSCH == null || element.ZLSCH == undefined) {
            element.isEmptyZLSCH = true;
          }
          if (element.ZLSPR == '' || element.ZLSPR == null || element.ZLSPR == undefined) {
            element.isEmptyZLSPR = true;
          }
        });

        data.itemList.sort((a, b) => a.ZFBDT.split("-")[2] + "-" + a.ZFBDT.split("-")[1] + a.ZFBDT.split("-")[0] < b.ZFBDT.split("-")[2] + "-" + b.ZFBDT.split("-")[1] + b.ZFBDT.split("-")[0] ? 1 : -1);
        this.tableDataList = data.itemList;
        console.log("DATALIST TEST :" , JSON.stringify(this.tableDataList));
        this.tableDataListBackup = data.itemList;
        if (this.tableDataList.length > 0) {
          this.isShowDataTable = true;

          this.showToast("Açık Kalemler Getirildi", "success");
          this.isDisabledFilter = false;
          this.selectedItemSize = this.selectedItemSize = this.tableDataListBackup.filter((q) => q.isChecked == true).length;

          if (this.selectedSurecTipi != undefined && this.selectedSurecTipi != "" && this.selectedSurecTipi != null) {
            this.isShowTableCheckbox = true;
          } else {
            this.isShowTableCheckbox = false;
          }

          this.ortalamaVadeGetir(event);


          this.tableDataList.forEach((element) => {
            element.isChecked = false;
          });
          this.tableDataListBackup.forEach((element) => {
            element.isChecked = false;
          });
          this.selectedItemSize = this.selectedItemSize = this.tableDataListBackup.filter((q) => q.isChecked == true).length;


          this.isLoading = false;
        } else {
          this.showToast(data.message, "error");
          this.isShowDataTable = false;
          this.isLoading = false;
        }
      })
      .catch((error) => {
        this.isLoading = false;
        console.log(error);
      });
  }

  handleLookup(event) {
    this.selectedAccountId = event.detail.data.recordId;
  }

  cbxOnChange(event) {
    let indexVar = event.currentTarget.dataset.index;
    this.tableDataList[indexVar].isChecked = event.currentTarget.checked;
    let sourceData = this.tableDataListBackup.find((q) => q.BELNR == this.tableDataList[indexVar].BELNR);
    sourceData.isChecked = event.currentTarget.checked;





    this.selectedItemSize = this.tableDataListBackup.filter((q) => q.isChecked == true).length;
  }

  cbxSelectAll(event) {
    let i;
    let checkboxes = this.template.querySelectorAll('[data-id="cbx"]');
    for (i = 0; i < checkboxes.length; i++) {
      this.tableDataListBackup[i].isChecked = event.target.checked;
    }
    this.selectedItemSize = this.tableDataListBackup.filter((q) => q.isChecked == true).length;
  }

  belgeTarihiOnChange(event) {
    this.selectedBelgeTarihi = event.currentTarget.value;
  }

  vadeTarihiOnChange(event) {
    this.selectedVadeTarihi = event.currentTarget.value;
  }

  ortalamaVadeGetir(event) {
    let checkedDataList = this.tableDataListBackup.filter((q) => q.isChecked);
    console.log(JSON.stringify(checkedDataList));
    if (checkedDataList.length > 0) {
      ortalamaVadeBul({
        dataList: JSON.stringify(checkedDataList)
      }).then((data) => {
          
          if (data != null) {
            //this.showToast("Ortalama Vade Hesaplandı.", "success");
            this.ortVadeDateInput = data.ORTVADE;
            this.toplamTutar = data.BAKIYE;

            if(!this.isCalculated && this.selectedSurecTipi == '02'){
              this.backupBakiye     = data.BAKIYE;
              this.backupVadeTarihi = data.ORTVADE;
              this.isCalculated     = true;
            }
          } else {
            this.showToast(data.message, "error");
          }
        })
        .catch((error) => {
          this.isLoading = false;
          this.disabledCreateBordroButton = false;
          console.log(error);
        });
    } else {
      this.showToast("En az bir belge seçmeniz gerekiyor !", "error");
      this.isLoading = false;
      this.disabledCreateBordroButton = false;
      return;
    }
  }

  createBordro(event) {
    this.isLoading = true;
    let checkedDataList = this.tableDataListBackup.filter((q) => q.isChecked);
    if (checkedDataList.length > 0) {

      this.disabledCreateBordroButton = true;
      this.ortalamaVadeGetir(event);

      setTimeout(() => {
        if (this.selectedKrediKontrol == undefined || this.selectedKrediKontrol == null || this.selectedKrediKontrol == "") {
          this.showToast("Bordro oluşturmadan önce kredi kontrol alanını seçiniz !","error");
          this.isLoading = false;
          this.disabledCreateBordroButton = false;
          return;
        }

        if (this.selectedSurecTipi == "01") {

          if(this.isCommunity){
            this.showToast("OÇT tipindeki bordrolar Bayi Portal üzerinden oluşturulamaz !","error");
            this.isLoading = false;
            this.disabledCreateBordroButton = false;
            return;
          }

          let today = new Date();
          today.setDate(today.getDate() + 5);

          var dd = today.getDate();
          var mm = today.getMonth() + 1;
          var y = today.getFullYear();

          var someFormattedDate = y + "-" + mm + "-" + dd;
          console.log("someFormattedDate :" + someFormattedDate);
          console.log("this.ortVadeDateInput :" + this.ortVadeDateInput);

          if (this.ortVadeDateInput < someFormattedDate) {
            this.showToast("Ortalama vade tarihi " +someFormattedDate +" tarihinden önce olamaz.","error");
            this.isLoading = false;
            this.disabledCreateBordroButton =false;
            return;
          }

          let checkedDataList = this.tableDataListBackup.filter((q) => q.isChecked);
          if (checkedDataList.length > 0) {
            if (parseFloat(this.toplamTutar) < 5000) {
              this.showToast("Seçilen belgelerin toplam tutarı 5.000 ve üzeri olmalıdır !","error");
              this.disabledCreateBordroButton =false;
              this.isLoading = false;
            } else {
              
              BordroKaydet({
                accountId: this.selectedAccountId,
                selectedODK: this.selectedODK,
                selectedKKBER: this.selectedKrediKontrol,
                selectedKEYDATE: this.selectedBelgeTarihi,
                dataItemList: JSON.stringify(checkedDataList)
              })
                .then((data) => {
                  if (data.EV_SUCCESS == "") {
                    this.showToast(data.EV_MESSAGE, "error");
                    this.isLoading = false;
                    this.disabledCreateBordroButton = false;
                  } else {
                    this.bordroId = data.bordroId;
                    this.isShowCekComponent = true;
                    this.showToast(data.EV_MESSAGE, "success");
                    this.isLoading = false;
                    this.disabledCreateBordroButton = false;
                    this.clearFilter();
                    this.getDocumentOnClick(event);
                    this.isShowDTSCekComponent = true;
                  }
                })
                .catch((error) => {
                  this.isLoading = false;
                  console.log(error);
                });
            }
          } else {
            this.showToast("En az bir belge seçmeniz gerekiyor !", "error");
            this.isLoading = false;
          }
        }

        if (this.selectedSurecTipi == "02") {

          if(!this.isCommunity){
            this.showToast("DTS tipindeki bordrolar sadece Bayi Portal üzerinden oluşturulabilir !","error");
            this.isLoading = false;
            this.disabledCreateBordroButton = false;
            return;
          }

          if (this.selectedKrediKontrol != '0001') {
            this.showToast("DTS tipindeki bordroların kredi kontrol alanı sadece Vestel olmalıdır !","error");
            this.isLoading = false;
            this.disabledCreateBordroButton = false;
            return;
          }
        
          let checkedDataList = this.tableDataListBackup.filter((q) => q.isChecked);
          let unCheckedDataList = this.tableDataListBackup.filter((q) => q.isChecked == false);
          if (checkedDataList.length > 0) {
            if (parseFloat(this.toplamTutar) < 0) {
              this.showToast("Seçilen belgelerin toplam tutarı artı olmalıdır !","error");
              this.isLoading = false;
              this.disabledCreateBordroButton = false;
            } else {
              BordroYaratDTS({
                accountId: this.selectedAccountId,
                dataItemList: JSON.stringify(checkedDataList),
                dataItemListUnChecked: JSON.stringify(unCheckedDataList),
                bakiye : this.toplamTutar,
                selectedKKBER: this.selectedKrediKontrol,
                ortVadeTarihi : this.ortVadeDateInput
              })
                .then((data) => {
                  if (data.success == false) {
                    this.showToast(data.message, "error");
                    this.disabledCreateBordroButton = false;
                  } else {
                    this.bordroId = data.bordroId;
                    this.disabledCreateBordroButton = false;
                    this.showToast(data.message, "success");
                    this.getDocumentOnClick(event);

                    if (this.isCommunity) {
                      this.isShowDTSCekComponent = true;
                    } else{
                      this.isShowDTSCekComponent = false;
                    }
                    
                  }
                  
                })
                .catch((error) => {
                  this.isLoading = false;
                  this.disabledCreateBordroButton = false;
                  console.log(error);
                });
            }
          } else {
            this.showToast("En az bir belge seçmeniz gerekiyor !", "error");
            this.isLoading = false;
            this.disabledCreateBordroButton = false;
          }
          this.isLoading = false;
        }

      }, DELAY);
    }else {
      this.showToast("En az bir belge seçmeniz gerekiyor !", "error");
      this.isLoading = false;
    }
  }

  closeChild(event){
    if (event.detail.close != undefined) {
      if(event.detail.componentname == 'dts'){
        this.isShowDTSCekComponent = event.detail.close;
      }
      if(event.detail.componentname == 'oct'){
        this.isShowCekComponent = event.detail.close;
      }
      
    }
  }

  // Download Data as CSV
  downloadTable(){
    this.prepareData();
  }

  prepareData(){
    if(this.tableDataList != null && this.tableDataList.length > 0){
        this.fileDownload();
    }
  }

  fileDownload() { 
    this.isLoading = true;
    try{       
        // call the helper function which "return" the CSV data as a String   
        var csv = this.convertArrayOfObjectsToCSV(this.tableDataList);
        if (csv == null) { return; }
        
        var blob = new Blob(["\ufeff",csv], { type: "" });
        var fileName = 'BakiyeBilgilerim_AcikBelgeler.csv';
        
        window.saveAs(blob, fileName);    
    }
    catch(e){
        console.log(e);
    } 
    this.isLoading = false;
  }  

  convertArrayOfObjectsToCSV(objectRecords) {
    
    let columns = [    
      { label: 'Belge No', fieldName: 'BELNR'},
      { label: 'Ürün Bilgisi', fieldName: 'formattedProductInfo'},
      { label: 'Kayıt Tarihi', fieldName: 'BUDAT'},
      { label: 'Vade Tarihi', fieldName: 'ZFBDT'},
      { label: 'Tutar', fieldName: 'DMBTR'},
      { label: 'Para Birimi', fieldName: 'WAERS'},    
      { label: 'Belge türü', fieldName: 'BLART'},
      { label: 'Belge Türü Tanımı', fieldName: 'LTEXT'},
      { label: 'Referans İşlem', fieldName: 'AWKEY'},
      { label: 'Mali Yıl', fieldName: 'GJAHR'},
      { label: 'Ödeme Biçimi', fieldName: 'ZLSCH'},
      { label: 'Ödeme Blokajı', fieldName: 'ZLSPR'},
      { label: 'Kredi Kontrol Alanı', fieldName: 'KKBER'}
      ];




    // declare variables
    var csvStringResult, counter, keys, columnDivider, lineDivider, keysHeader;
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

    var keys = [];
    var keysHeader = [];
    for (var i = 0; i < columns.length; i++) {
        var column = columns[i];

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

            if(skey == 'formattedProductInfo'){
                data = data.replaceAll('</br>','');
            }


                                        
            csvStringResult += '"' + data + '"';

            counter++;
        } 
        csvStringResult += lineDivider;
    }

    return csvStringResult;
  }
 
}