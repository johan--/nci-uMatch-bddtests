/**
 * Created by raseel.mohamed on 6/26/16
 */

'use strict';
var fs          = require ('fs');
var assert      = require ('assert');
var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    this.World = require ('../step_definitions/world').World;

    var patientInfoPromise;
    var expectedMainTabs     = patientPage.expectedPatientMainTabs;
    var actualMainTabsArray  = patientPage.actualMainTabs;
    var patientApiInfo;
    var currentActiveMainTab = patientPage.currentActiveTab;

    // Given Section
    // When Section

    this.When (/^I click on one of the patients$/, function (callback) {
        //get the patient id of the first element
        var tableElement = patientPage.patientListTable;
        patientPage.returnPatientId (tableElement, 0).then (function (id) {
            patientPage.patientId = id;
            console.log ('Patient Selected: ' + patientPage.patientId);
            element (by.linkText (id)).click ();
        }).then (callback);
    });

    this.When (/^I go to patient "(.+)" details page$/, function (pa_id, callback) {
        patientPage.patientId = pa_id;
        browser.get ('/#/patient?patient_id=' + pa_id, 6000).then (callback);
    });

    this.When (/^I collect the patient Api Information$/, function (callback) {
        var str     = '/api/v1/patients/' + patientPage.patientId;
        var request = utilities.callApi ('patient', str)
        request.get ().then (function () {
            patientPage.responseData = JSON.parse (request.entity ());
        }).then (callback);
    });

    this.When (/^I click on the "([^"]*)" tab$/, function (tabName, callback) {
        browser.ignoreSynchronization = true;
        element (by.css ('li[heading="' + tabName + '"]')).click ();
        browser.ignoreSynchronization = false;
        browser.sleep (50).then (callback);
    });

    // Then Section

    this.Then (/^I should see Patient details breadcrumb$/, function (callback) {
        utilities.checkBreadcrumb ('Dashboard / Patients / Patient ' + patientPage.patientId);
        browser.sleep (50).then (callback);
    });

    this.Then (/^I am taken to the patient details page$/, function (callback) {
        var url = browser.baseUrl + '/#/patient?patient_id=' + patientPage.patientId
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

        expect (actualTable.get (0).getText ()).to.eventually.eql (patientPage.responseData.patient_id);
        expect (actualTable.get (1).getText ())
            .to
            .eventually
            .eql (patientPage.responseData.gender + ',' + patientPage.responseData.ethnicity);
        expect (actualTable.get (2).getText ())
            .to
            .eventually
            .eql (utilities.dashifyIfEmpty (patientPage.responseData.last_rejoin_scan_date));
        expect (actualTable.get (3).getText ()).to.eventually.eql (patientPage.responseData.current_status);
        expect (actualTable.get (4).getText ()).to.eventually.eql (patientPage.responseData.current_step_number)
        expect (actualTable.get (5).getText ()).to.eventually.eql (selectedTA.treatment_arm_id);
        expect (actualTable.get (6).getText ()).to.eventually.eql (selectedTA.stratum_id);
        expect (actualTable.get (7).getText ()).to.eventually.eql (', ' + selectedTA.version).notify (callback);
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
        utilities.checkElementIncludesAttribute (testElement, 'class', 'active').then (callback);
    });

    this.Then (/^I should see the "(.+)" section heading$/, function (heading, callback) {
        var index = patientPage.expectedMainTabSubHeadings.indexOf (heading);
        patientPage.mainTabSubHeadingArray ().getText ().then (function (array) {
            expect (array[ index ]).to.eql (heading);
        }).then (callback);
    });

    this.Then (/^I should see the  Treatment Arm History about the patient$/, function (callback) {
        //Getting the treatment arms history from the API call
        //todo: write coede for getting the ta_history from the patient call

        //var expectedTAHistory = patientApiInfo['ta_history']
        browser.sleep (50).then (callback);

    });

    this.When (/^I turn off synchronization$/, function (callback) {
        browser.ignoreSynchronization = true;
        browser.sleep (50).then (callback);
    })

};
