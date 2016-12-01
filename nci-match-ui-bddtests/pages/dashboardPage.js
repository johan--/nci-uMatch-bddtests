/**
 * Created by raseel.mohamed on 6/3/16
 */

var DashboardPage = function() {

    this.title = 'MATCHBox | Dashboard';
    this.dashboardController = element(by.css('div[ng-controller="DashboardController"]'));
    this.dashboardPanel      = element(by.css('.sticky-navbar')); // This is the sticky panel at the top
    this.dashSummary         = element(by.css('.top-dashboard-header-box')); // This is the top dashboard section
    this.summaryHeadings     = this.dashSummary.all(by.css('h3'));

    this.dashboardElement   = element(by.css('div[ng-controller="DashboardController"]'));
    this.statisticsLabels   = element.all(by.css('li.list-group-item'));

    this.amoiChart          = element(by.css('.donut-chart'));
    this.amoiLegendList     = element.all(by.repeater('legendItem in donutData.values'))
    this.accrualChart       = element(by.css('#chartBox'));

    this.logoutLink = element(by.css('[ng-click="logout()"]'));
    this.registeredPatients = element(by.binding(' patientStatistics.number_of_patients '));
    this.patientsWithCVR    = element(by.binding(' patientStatistics.number_of_patients_with_confirmed_variant_report '));
    this.patientsOnTA       = element(by.binding(' patientStatistics.number_of_patients_on_treatment_arm '));
    this.pendingTVRCount    = element(by.binding(' pendingTissueVariantReportGridOptions.data.length '));
    this.pendingBVRCount    = element(by.binding(' pendingBloodVariantReportGridOptions.data.length '));
    this.pendingAssgnCount  = element(by.binding(' pendingAssignmentReportGridOptions.data.length '));

    this.patientsInLimboList = element.all(by.repeater('item in limboPatients'));


    this.logout = function () {
        this.logoutLink.click();
        console.log('Clicked Logout');
        browser.waitForAngular();
    };

    this.goToPageName = function(pageName) {
        return browser.get('/#/' + pageName, 6000);
    };


    this.feedRepeaterList     = element.all(by.repeater('timelineEvent in activity.data'));

    this.dashAmoiChart        = element(by.css('div[ng-init^="setCanvasHeight(\'#amoiCanvas\'"]'));


    // this is the div id locator string that lest you get access to the individual sub tab on the dashboard Pending Review section
    // use it like this:
    // element(by.id(subTabLocator[<reportType>]))
    this.subTabLocator = {
        "Tissue Variant Reports": "pendingTissueVRs",
        "Blood Specimens": "pendingBloodVRs",
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

    this.expectedLimboTableColumns = [
        'Patient ID', 'Current Status', 'Variant Report Status', ''
    ]

};

module.exports = new DashboardPage();
