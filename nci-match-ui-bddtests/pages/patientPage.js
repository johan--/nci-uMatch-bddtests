/**
 * Created by raseel.mohamed on 6/23/16
 */

var PatientPage = function () {
    this.patientListTable = element(by.css('table[datatable="ng"]'));
    this.patientListHeaders = function () { return element.all(by.css('table[datatable="ng"] th[colspan="1"]'))};


    this.expectedPatientListHeaders = [
        'Patient ID',
        'Status',
        'Step Number',
        'Disease',
        'Treatment Arm',
        'Registration Date',
        'Off Trial Date'
    ];
}

module.exports = new PatientPage();