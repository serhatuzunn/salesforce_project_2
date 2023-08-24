import { api, LightningElement, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import CSS from "@salesforce/resourceUrl/SelectPriceBookCSS";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import updateOPP from "@salesforce/apex/RC_SelectPricebookController.updateOPP";
import updateOPPWithWithDeleting from "@salesforce/apex/RC_SelectPricebookController.updateOPPWithWithDeleting";
import { CloseActionScreenEvent } from "lightning/actions";

export default class Rc_selectpricebook extends LightningElement {
  //For custom lookup field
  fields = ["Name"];
  displayFields = "Name";
  whereClauses = "WHERE IsActive = true";

  @track isLoading = false;
  @api recordId;
  @track selectedPricebookID;
  @track isOpenChildModal = false;

  renderedCallback() {
    loadStyle(this, CSS)
      .then(() => {
        console.log("Style Loaded.");
      })
      .catch((error) => console.log(error));
  }

  closeQuickAction(event) {
    this.dispatchEvent(new CloseActionScreenEvent());
  }

  handleLookup(event) {
    this.selectedPricebookID = event.detail.data.recordId;
  }

  updateOpportunity(event) {
    if (this.selectedPricebookID == null || this.selectedPricebookID == undefined || this.selectedPricebookID == "") {
      this.showToast("Lutfen Secim yapiniz !", "error");
      return;
    }

    this.isLoading = true;
    updateOPP({
      selectedPricebookID: this.selectedPricebookID,
      oppID: this.recordId
    })
      .then((data) => {
        if (data.success) {
          this.showToast("Fiyat Listesi Eklendi.", "success");
          this.isLoading = false;
          this.selectedPricebookID = null;
          window.location =
            "/lightning/r/Opportunity/" + this.recordId + "/view";
        } else {
          if (data.hasItem) {
            this.isLoading = false;
            this.isOpenChildModal = true;
            return;
          }
          this.showToast("Hata Olustu..", "error");
          this.isLoading = false;
        }
      })
      .catch((error) => {
        this.isLoading = false;
        console.log(error);
      });
  }

  closeChildModal() {
    this.isOpenChildModal = false;
  }

  closeChildModalAfterSaving() {
    this.isLoading = true;
    updateOPPWithWithDeleting({
      selectedPricebookID: this.selectedPricebookID,
      oppID: this.recordId
    })
      .then((data) => {
        if (data.success) {
          this.showToast("Fiyat Listesi Guncellendi.", "success");
          this.isLoading = false;
          this.selectedPricebookID = null;
          window.location ="/lightning/r/Opportunity/" + this.recordId + "/view";
        } else {
          this.showToast(data.msg, "error");
          this.isLoading = false;
        }
      })
      .catch((error) => {
        this.isLoading = false;
        console.log(error);
      });
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
}
