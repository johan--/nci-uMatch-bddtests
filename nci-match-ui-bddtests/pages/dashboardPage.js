/**
 * Created by raseel.mohamed on 6/3/16
 */

var DashboardPage = function() {
    
    this.title = 'MATCHBox | Dashboard';
    this.greeterHeading = element(by.binding(' name '));
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
        if (pageName == 'IR Reporters') {
            pageName =iradmin;
        }
        browser.get('/#/' + pageName, 6000);
        browser.waitForAngular();
    };
};

module.exports = new DashboardPage();
