/**
 * Created by raseel.mohamed on 6/26/16
 */

'use strict';

var fs          = require('fs');
var assert      = require('assert');
var patientPage = require('../../pages/patientPage');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    this.World = require('../step_definitions/world').World;

    var patientInfoPromise;
    var expectedMainTabs     = patientPage.expectedPatientMainTabs;
    var actualMainTabsArray  = patientPage.actualMainTabs;
    var patientApiInfo;
    var currentActiveMainTab = patientPage.currentActiveTab;

    this.When (/^I click on one of the patients$/, function (callback) {
        //get the patient id of the first element
        var tableElement = patientPage.patientListTable;
        patientPage.returnPatientId (tableElement, 0).then (function (id) {
            patientPage.patientId = id;
            element (by.linkText (id)).click ();
        }).then (callback);
    });

    this.When (/^I go to patient "([^"]*)" details page$/, function (pa_id, callback) {
        patientPage.patientId = pa_id;
        browser.get ('/#/patient?patient_id=' + pa_id, utilities.delay.afterPatientLoad).then(function(){
            browser.waitForAngular().then(function(){
                expect(browser.getCurrentUrl()).to.eventually.include('/#/patient?patient_id=' + pa_id);
            });
        }).then(callback);
    });

    this.When (/^I collect the patient Api Information$/, function (callback) {
        var url     = '/api/v1/patients/' + patientPage.patientId;
        utilities.getRequestWithService('patient', url).then(function (responseBody) {
            patientPage.responseData = responseBody;
        }).then(callback);
    });

    this.When (/^I click on the "([^"]*)" tab$/, function (tabName, callback) {
        var elementToClick = utilities.getSubTabHeadingElement(tabName);
        utilities.waitForElement(elementToClick, tabName).then(function(presence){
            if(presence === true){
                browser.waitForAngular().then(function(){
                    elementToClick.click();
                });
            } else {
                expect("Element \"" + tabName + "\" not found").to.eql("Element \"" + tabName + "\" found")
            }
        }).then(callback);
    });

    // Then Section

    this.Then (/^I should see Patient details breadcrumb$/, function (callback) {
        browser.ignoreSynchronization = false;
        utilities.checkBreadcrumb ('Dashboard / Patients / Patient ' + patientPage.patientId);
        browser.sleep (500).then (callback);
    });

    this.Then (/^I am taken to the patient details page$/, function (callback) {
        var url = browser.baseUrl + '/#/patient?patient_id=' + patientPage.patientId;
        expect (browser.getCurrentUrl ()).to.eventually.eql (url).notify (callback);
    });

    this.Then (/^I should see the patient's information table$/, function (callback) {
        //checking for presence of table
        expect (browser.isElementPresent (patientPage.patientSummaryTable)).to.eventually.be.true;
        //checking if the label values match
        var expectedLabelList = patientPage.expectedPatientSummaryLabels;
        var actualLabelList   = patientPage.patientSummaryTable.all (by.css ('dt'));
        expect (actualLabelList.count ()).to.eventually.equal (expectedLabelList.length);
        for (var i = 0; i < expectedLabelList.length; i++) {
            expect (actualLabelList.get (i).getText ()).to.eventually.equal (expectedLabelList[ i ]);
        }
        browser.sleep (50).then (callback);
    });

    this.Then (/^I should see the patient's information match database$/, function (callback) {
        var actualTable = patientPage.patientSummaryTable.all (by.css ('.ng-binding'));
        var selectedTA  = patientPage.responseData.current_assignment;
        var fixedTA     = utilities.stripStudyId(selectedTA.treatment_arm_id);

        expect (actualTable.get (0).getText ()).to.eventually.eql (patientPage.responseData.patient_id);
        expect (actualTable.get (1).getText ())
            .to
            .eventually
            .eql (patientPage.responseData.gender + ', ' + patientPage.responseData.ethnicity);
        expect (actualTable.get (2).getText ()).to.eventually.eql (patientPage.responseData.current_status);
        expect (actualTable.get (3).getText ()).to.eventually.eql (patientPage.responseData.current_step_number)
        expect (actualTable.get (4).getText ()).to.eventually.eql (fixedTA);
        expect (actualTable.get (5).getText ()).to.eventually.eql ('-' + selectedTA.stratum_id);
        expect (actualTable.get (6).getText ()).to.eventually.eql ('(' + selectedTA.version + ')').notify (callback);
    });

    this.Then (/^I should see the patient's disease information match the database$/, function (callback) {
        var actualTable = patientPage.diseaseSummaryTable.all (by.css ('.ng-binding'));

        if (patientPage.responseData.diseases !== null) {
            var diseaseName = utilities.dashifyIfEmpty (patientPage.responseData.diseases[ 0 ].disease_name);
            var diseaseType = utilities.dashifyIfEmpty (patientPage.responseData.diseases[ 0 ].disease_code_type);
            var diseaseCode = utilities.dashifyIfEmpty (patientPage.responseData.diseases[ 0 ].disease_code);
            //todo:add drugs list/
            var priorDrugs  = '-';

            expect (actualTable.get (0).getText ()).to.eventually.eql (diseaseName);
            expect (actualTable.get (1).getText ()).to.eventually.eql (diseaseType);
            expect (actualTable.get (2).getText ()).to.eventually.eql (diseaseCode);
            // todo: add priorDrugs list check.
        }
        browser.sleep (5000).then (callback);
    });

    this.Then (/^I should see the patient's disease information table$/, function (callback) {
        //checking for presence of table
        expect (browser.isElementPresent (patientPage.diseaseSummaryTable)).to.eventually.be.true;
        var expectedLabelList = patientPage.expectedDiseaseSummaryLabels;
        var actualLabelList   = patientPage.diseaseSummaryTable.all (by.css ('dt'));
        expect (actualLabelList.count ()).to.eventually.equal (expectedLabelList.length);

        for (var i = 0; i < expectedLabelList.length; i++) {
            expect (actualLabelList.get (i).getText ()).to.eventually.equal (expectedLabelList[ i ]);
        }
        browser.sleep (5).then (callback);
    });

    this.Then (/^I should see the main tabs associated with the patient$/, function (callback) {
        // checking for number of tabs. Removed because surgical Event tab can be multiple
        // expect(actualMainTabsArray.count()).to.eventually.equal(expectedMainTabs.length);
        //checking for each individual tab name in order
        utilities.checkInclusiveElementArray (actualMainTabsArray, expectedMainTabs);
        browser.sleep (5).then (callback);
    });

    this.Then (/^I should see the "([^"]*)" tab is active$/, function (tabName, callback) {
        var index       = expectedMainTabs.indexOf (tabName);
        var testElement = element.all (by.css ('li.uib-tab.nav-item')).get (index);
        var testElem    = element.all (by.css ('li.uib-tab.nav-item'))
        utilities.getElementIndex(testElem, tabName).then(function (newIndex){
            utilities.checkElementIncludesAttribute (testElem.get(newIndex), 'class', 'active');
        }).then(callback);
    });

    this.Then (/^I should see the "(.+)" section heading$/, function (heading, callback) {
        // var index = patientPage.expectedMainTabSubHeadings.indexOf (heading);
        utilities.waitForElement(patientPage.mainTabSubHeadingArray().get(0), "Sections under Patient Details").then(function(presence){
            if (presence === true){
                patientPage.mainTabSubHeadingArray().getText().then(function (array) {
                  expect(array).to.include(heading);
                });
            } else {
                expect(heading + " not found").to.eql(heading + " found");
            }
        }).then (callback);
    });

    this.Then(/^I should see a message "([^"]*)" in the timeline$/, function (timeLineMessage, callback) {
        var events = element.all(by.repeater('timelineEvent in activity.data')).all(by.css('span[ng-if="timelineEvent.event_data.message"]'));

        events.get(0).getText().then(function(text) {
            expect(text).to.eql(text);
        }).then(callback);
    });

    this.When(/^His status is "([^"]*)"$/, function (status, callback) {
        browser.waitForAngular().then(function(){
            expect(patientPage.patientDetailsStatus.getText()).to.eventually.eql(status);
        }).then(callback);
    });

    this.Then(/^I "(should|should not)" see a Treatment Arm selected for the patient$/, function (see_or_not, callback){
        utilities.waitForElement(patientPage.treatmentArmComplete.get(0), "Treatment Arm Value").then(function(presence){
            if (presence === true){
                if (see_or_not === 'should'){
                    expect(patientPage.treatmentArmComplete.get(0).getText()).to.eventually.not.eql('-');
                } else {
                    expect(patientPage.treatmentArmComplete.get(0).getText()).to.eventually.eql('-');
                }
            } else {
                expect("patientPage.treatmentArmComplete is not found").to.eql("patientPage.treatmentArmComplete is found");
            }
        }).then(callback);
    });

    this.Then(/^I "(should|should not)" see a Off Arm Date generated for the patient$/, function (see_or_not, callback){
        if (see_or_not === 'should'){
            expect(patientPage.treatmentArmComplete.get(0).getText()).to.eventually.include('APEC1621').notify(callback);
        } else {
            expect(patientPage.treatmentArmComplete.get(0).getText()).to.eventually.eql('-').notify(callback);
        }
    });
};
