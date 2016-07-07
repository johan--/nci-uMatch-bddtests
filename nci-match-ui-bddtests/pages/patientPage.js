/**
 * Created by raseel.mohamed on 6/23/16
 */

var PatientPage = function () {
    var patientId;

    this.patientListTable = element(by.css('table[datatable="ng"]'));
    this.patientListHeaders = element.all(by.css('table[datatable="ng"] th[colspan="1"]'));
    this.patientListRowElements = element.all(by.repeater("patient in patientList"));


    // Patient summary table information on the patient details page
    this.patientSummaryTable = element.all(by.css('.header-info-box.top-main-header-box')).get(0);
    // Disease Summary table information on the patient details page.
    this.diseaseSummaryTable = element.all(by.css('.header-info-box.top-main-header-box')).get(1);
    //Patient details page main tabs
    this.actualMainTabs = element.all(by.css('li.uib-tab.nav-item'));
    // This element gives access to the current active tab
    this.currentActiveTab = element(by.css('.active[ng-class="{active: tabset.active === tab.index}"]'));

    // *****************  Summary Tab  ********************//
    // Accessing the patient timeline
    this.patientTimelineElementArray = element.all(by.repeater('timelineEvent in data.timeline'));
    //Accessing the Treatment Arm History
    this.treatmentArmsHistoryElementArray = element.all(by.repeater('ta in data.ta_history'));

    // ****************** Expected values *******************//
    // Patient list table
    this.expectedPatientListHeaders = [
        'Patient ID',
        'Status',
        'Step Number',
        'Disease',
        'Treatment Arm',
        'Registration Date',
        'Off Trial Date'
    ];
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
    this.expectedDiseaseSummaryLabels = ['Disease Name', 'Disease Type', 'Disease Code', 'Prior Drugs'];

    this.expectedPatientMainTabs = [ 'Summary', 'Surgical Event', 'Tissue Report', 'Blood Variant Report', 'Documents'];

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

    function setPatientId(id) {
        patientId = id;
    }

    this.getPatientId = function () {
        return patientId;
    };

    this.checkPatientMainTabs = function() {
        //check for number of tabs
        expect(element(by.css('li.uib-tab.nav-item')).count()).to.eventually.equal()
    }
};

module.exports = new PatientPage();
