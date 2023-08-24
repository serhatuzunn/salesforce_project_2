import { LightningElement, track } from 'lwc';
import GetAllReports from '@salesforce/apex/RC_AllReportController.GetAllReports';
import SaveFolder from '@salesforce/apex/RC_AllReportController.saveFolder';
import {NavigationMixin} from 'lightning/navigation';

const actions = [
    { label: 'Download', name: 'download' }
];

export default class Rc_allreport extends NavigationMixin(LightningElement) {
    @track reportList = [];
    @track detailData;
    @track detailDataSize;

    columns = [];
    detailColumn = [];

    selectedFolderLabel = null;
    selectedFolderName = null;

    isModalOpen = false;
    isFolderModalOpen = false;

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    handleSearchElements(event) {
        const srcName = event.srcElement.name;

        switch (srcName) {
            case 'folderLabel':
                this.selectedFolderLabel = event.detail.value;
                break;
            case 'folderUniqueName':
                this.selectedFolderName = event.detail.value;
                break;

            default:
        }
    }

    navigateNext(event) {
        event.preventDefault();
        event.stopPropagation();
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://vestel--vtsbxqa.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJyZXBvcnRzOnJlcG9ydEJ1aWxkZXIiLCJhdHRyaWJ1dGVzIjp7InJlY29yZElkIjoiIiwibmV3UmVwb3J0QnVpbGRlciI6dHJ1ZX0sInN0YXRlIjp7fX0%3D',
                target: '_blank'
            }
        });
    }

    constructor(){
        super();

        this.columns = [
            {label: 'Name', initialWidth: 300, fieldName: 'folderName', type:'button', typeAttributes:{label : {fieldName: 'folderName'}, variant: 'base' }, sortable: true , cellAttributes: { iconName: 'utility:open_folder', iconAlternativeText: 'Folder', iconPosition: 'left' }},
            {label: 'Created By', fieldName: 'folderCreator'},
            {label: 'Created On', fieldName: 'folderCreationDate', type: "date",typeAttributes:{year: "numeric",month: "long",day: "2-digit",hour: "2-digit",minute: "2-digit"}},
            {label: 'Last Modified By', fieldName: 'folderLastChanger'},
            {label: 'Last Modified Date', fieldName: 'folderLastModificationDate', type: "date",typeAttributes:{year: "numeric",month: "long",day: "2-digit",hour: "2-digit",minute: "2-digit"}}
        ];

        this.detailColumn = [
            {label: 'Name', fieldName: 'reportLink', type: 'url', typeAttributes: {label:{fieldName:'reportName'}, target:'_blank'}},
            {label: 'Description', fieldName: 'reportDescription'},
            {label: 'Created By', fieldName: 'reportCreator'},
            {label: 'Created On', fieldName: 'reportCreationDate', type: "date",typeAttributes:{year: "numeric",month: "long",day: "2-digit",hour: "2-digit",minute: "2-digit"}}
        ];

        GetAllReports()
        .then(result => {
            this.reportList = result;
        })
        .catch(ex => {
            console.log('Get All Report Error : ' + JSON.stringify(ex));
        });
    }

    handleClick(evt) {
        // Stop the event's default behavior.
        // Stop the event from bubbling up in the DOM.
        evt.preventDefault();
        evt.stopPropagation();
        // Navigate to the Account Home page.
        this[NavigationMixin.Navigate](this.reportNewPageRef);
    }

    // Used to sort the 'Age' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.reportList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.reportList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    handleRowClick(event){
        var relatedData = this.reportList.find((item) => item.folderName == event.detail.row.folderName);
        this.detailData = relatedData;
        console.log(JSON.stringify(relatedData));
        this.detailDataSize = relatedData.relatedReportList.length == 1 ? relatedData.relatedReportList.length + ' item.' : relatedData.relatedReportList.length + ' items.';

        this.openModal();
    }

    openFolderModal(){
        this.isFolderModalOpen = true;
    }

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.isFolderModalOpen = false;
    }

    saveFolder(event){
        SaveFolder({
                fl: this.selectedFolderLabel,
                fn: this.selectedFolderName
        })
        .then(result => {
            this.showSuccessToast(result, 'Başarılı');
        })
        .catch(
            Error => window.console.log('Folder Save Error : ' + JSON.stringify(Error))
            );
    }

    showSuccessToast(message, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}