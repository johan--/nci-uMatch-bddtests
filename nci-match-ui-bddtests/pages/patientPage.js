/**
 * Created by raseel.mohamed on 6/23/16
 */

var PatientPage = function () {
    var patientId;
    var patientData;

    this.patientListTable = element(by.css('table[datatable="ng"]'));
    this.patientListHeaders = element.all(by.css('table[datatable="ng"] th[colspan="1"]'));
    this.patientListRowElements = element.all(by.repeater("patient in patientList"));


    // Patient summary table information on the patient details page
    this.patientSummaryTable = element.all(by.css('.header-info-box.top-main-header-box')).get(0);
    // Expected Patient List Labels
    this.expectedPatientListHeaders = [
        'Patient ID',
        'Status',
        'Step Number',
        'Disease',
        'Treatment Arm',
        'Registration Date',
        'Off Trial Date'
    ];


    // Disease Summary table information on the patient details page.
    this.diseaseSummaryTable = element.all(by.css('.header-info-box.top-main-header-box')).get(1);
    //Patient details page main tabs
    this.actualMainTabs = element.all(by.css('li.uib-tab.nav-item'));
    // This element gives access to the current active tab
    this.currentActiveTab = element(by.css('.active[ng-class="{active: tabset.active === tab.index}"]'));
    //This element captures the sub headings under all the Tabs.
    // Though it captures all the headings, only the active tab's headings are populated in the array
    this.mainTabSubHeadingArray = element.all(by.css('.ibox-title.ibox-title-no-line>h3'));


    // *****************  Summary Tab  ********************//
    // Accessing the patient timeline
    this.patientTimelineElementArray = element.all(by.repeater('timelineEvent in data.timeline'));
    //Accessing the Treatment Arm History
    this.treatmentArmsHistoryElementArray = element.all(by.repeater('ta in data.ta_history'));

    // *****************  Surgical Event Tab  ********************//
    // Get all elements under the Surgical Event Panel
    this.surgicalEventPanel = element.all(by.css('div[ng-if="currentSurgicalEvent"]'));
    // This is the drop down button. Clicking this will give you access to the list of options.
    this.surgicalEventDropDownButton = element(by.binding('surgicalEventOption.text'));
    // List of Surgical Events from the drop down
    this.surgicalEventIdList = element.all(by.css('a[ng-click="onSurgicalEventSelected(item)"]'));
    // Access to the Summary boxes (Event and Pathology)
    this.surgicalEventSummaryBoxList = element.all(by.css('.biopsy-header-box'));
    // Expected Event and Pathology Labels
    this.biopsyHeaderBoxLabels = {
        'Event': {
            'index': 0,
            'labels': ['Surgical Event ID', 'Type', 'Collection Date', 'Received Date', 'Failure Date']
        },
        'Pathology': {
            'index': 1,
            'labels': ['Status', 'Received Date', 'Comment']
        }
    };


    // ****************** Expected values *******************//
    // Patient list table

    // Patient details page left hand side top summary
    this.expectedPatientSummaryLabels = [
        'Patient ID',
        'Patient',
        'Last Rejoin Scan Date',
        'Status',
        'Current Step',
        'Treatment Arm'
    ];
    // Patient details page right hand side top summary
    this.expectedDiseaseSummaryLabels = ['Disease Name', 'Disease Code Type', 'Disease Code', 'Prior Drugs'];

    this.expectedPatientMainTabs = [ 'Summary', 'Surgical Events', 'Tissue Reports', 'Blood Variant Reports', 'Documents'];

    this.expectedMainTabSubHeadings = ['Actions Needed', 'Treatment Arm History', 'Patient Timeline',
        'Slide Shipments', 'Assay History', 'Specimen History',
        'SNVs/MNVs/Indels', 'Copy Number Variant(s)', 'Gene Fusion(s)',
        'SNVs/MNVs/Indels(s) ##', 'Copy Number Variant(s)', 'Gene Fusion(s)',
        'Patient Documents'
    ];

    //**************************** Functions **********************//

    // For whatever zero based row that we want, get the patient Id for that row.
    this.returnPatientId = function (tableElement, indexCount) {
        return this.patientListRowElements.get(indexCount)
            .all(by.binding('::patient.patient_id '))
            .get(0).getText()
            .then(function (patientId) {
                setPatientId(patientId);
                return patientId;
            });
    };

    this.trimSurgicalEventId =  function(completeText){
      return completeText.replace('Surgical Event ', '').replace(/\|.+/, '').trim();
    };

    function setPatientId(id) {
        patientId = id;
    }

    this.setPatientData = function(data){
        patientData = data;
    };

    function getPatientData(){
        return patientData;
    };

    this.getPatientId = function () {
        return patientId;
    };

    this.checkPatientMainTabs = function() {
        //check for number of tabs
        expect(element(by.css('li.uib-tab.nav-item')).count()).to.eventually.equal()
    };
};

module.exports = new PatientPage();
