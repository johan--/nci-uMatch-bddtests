/**
 * Created by raseel.mohamed on 6/3/16
 */

var DashboardPage = function() {

    this.title = 'MATCHBox | Dashboard';
    this.greeterHeading = function() { return element(by.binding(' name ')); }
    this.logoutLink = element(by.css('[ng-click="logout()"]'));
    this.patientsNum = element.all(by.binding(' numberOfPatients '));
    this.screenedPatients = element(by.binding(' numberOfScreenedPatients '));
    this.patientsOnTreatment = element(by.binding(' numberOfPatientsWithTreatment '));
    this.pendingAssignmentReports = element(by.binding(' numberOfPendingAssignmentReports '));



    this.logout = function () {
        element(by.linkText('Log out')).click();
        browser.waitForAngular();
    };

    this.goToPageName = function(pageName) {
        browser.get('/#/' + pageName, 6000);
        browser.waitForAngular();
    };

    this.dashboardElement     = element(by.css('div[ng-controller="DashboardController"]'));
    this.feedRepeaterList     = element.all(by.repeater('timelineEvent in activity.data'));
    this.dashBannerList       = element.all(by.css('.dashboard-header'));
    this.dashAmoiChart        = element(by.css('div[ng-init^="setCanvasHeight(\'#amoiCanvas\'"]'));
    this.dashTreatmentAccrual = element(by.css('div[ng-init^="setCanvasHeight(\'#treatmentArmAccrualCanvas\'"]'));

    // this is the div id locator string that lest you get access to the individual sub tab on the dashboard Pending Review section
    // use it like this:
    // element(by.id(subTabLocator[<reportType>]))
    this.subTabLocator = {
        "Tissue Variant Reports": "pendingTissueVRs",
        "Blood Variant Reports": "pendingBloodVRs",
        "Assignment Reports" : "pendingAssignReps"
    };

    this.expectedTissueVRColumns = ['Patient ID', 'Molecular ID',
        'Analysis ID', 'Variant Report',
        'CLIA Lab', 'Specimen Received Date',
        'Variant Report Received Date', 'Days Pending'];

    this.expectedBloodVRColumns = ['Patient ID', 'Molecular ID',
        'Analysis ID', 'Variant Report',
        'CLIA Lab', 'Specimen Received Date',
        'Variant Report Received Date', 'Days Pending'];

    this.expectedAssignmentColumns = ['Patient ID', 'Molecular ID',
        'Analysis ID', 'Assignment Report',
        'Disease', 'Assigned Treatment Arm',
        'Assignment Date', 'Hours Pending'];

};

module.exports = new DashboardPage();
