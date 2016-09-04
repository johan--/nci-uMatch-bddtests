/**
 * Created by raseel.mohamed on 6/26/16
 */

'use strict';
var fs = require('fs');
var assert = require('assert');
var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    this.World = require ('../step_definitions/world').World;

    var patientId;
    var patientInfoPromise;
    var expectedMainTabs = patientPage.expectedPatientMainTabs;
    var actualMainTabsArray = patientPage.actualMainTabs;
    var patientApiInfo;
    var currentActiveMainTab = patientPage.currentActiveTab;

    // Given Section
    // When Section

    this.When(/^I click on one of the patients$/, function (callback) {
        //get the patient id of the first element
        var tableElement = patientPage.patientListTable;
        patientPage.returnPatientId(tableElement, 0).then(function (id) {
            patientId = id;
            element(by.linkText(id)).click();
        }).then(callback);
    });

    this.When(/^I go to patient "(.+)" details page$/, function (pa_id, callback) {
        patientId = pa_id;
        browser.get('/#/patient?patient_id=' + pa_id, 6000).then(callback);
    });

    this.When(/^I collect the patient Api Information$/, function (callback) {
        var str = '/api/v1/patients/' + patientId;

        patientInfoPromise = utilities.callApi('patient', str).then(function (response) {
              return(response);
        });

        browser.sleep(50).then(callback);
    });

    this.When(/^I click on the "([^"]*)" tab$/, function (tabName, callback) {
        var index = expectedMainTabs.indexOf(tabName);
        utilities.waitForElement(actualMainTabsArray.get(0));
        utilities.clickElementArray(actualMainTabsArray, index);
        browser.sleep(5).then(callback);
    });

    // Then Section

    this.Then(/^I should see Patient details breadcrumb$/, function (callback) {
        utilities.checkBreadcrumb('Dashboard / Patients / Patient ' + patientId);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I am taken to the patient details page$/, function (callback) {
        browser.sleep(200).then(function () {
            expect(browser.getCurrentUrl()).to.eventually.equal(browser.baseUrl + '/#/patient?patient_id=' + patientId)
        }).then(callback);
    });

    this.Then(/^I should see the patient's information table$/, function (callback) {
        //checking for presence of table
        expect(browser.isElementPresent(patientPage.patientSummaryTable)).to.eventually.be.true;
        //checking if the label values match
        var expectedLabelList = patientPage.expectedPatientSummaryLabels;
        var actualLabelList = patientPage.patientSummaryTable.all(by.css('dt'));
        expect(actualLabelList.count()).to.eventually.equal(expectedLabelList.length);
        for(var i = 0; i < expectedLabelList.length; i++){
            expect(actualLabelList.get(i).getText()).to.eventually.equal(expectedLabelList[i]);
         }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the patient's information match database$/, function (callback) {
        var actualTable = patientPage.patientSummaryTable.all(by.css('.ng-binding'));
        patientInfoPromise.then(function (info) {
            var patientApiInfo = JSON.parse(info);
            var expectedListfromAPI = [];
            expectedListfromAPI.push(patientApiInfo.patient_id);
            expectedListfromAPI.push(patientApiInfo.gender + ', ' + patientApiInfo.ethnicity);
            expectedListfromAPI.push(utilities.dashifyIfEmpty(patientApiInfo.last_rejoin_scan_date));
            expectedListfromAPI.push(patientApiInfo.current_status);
            expectedListfromAPI.push(patientApiInfo.current_step_number);

            for (var i = 0; i < expectedListfromAPI.length; i++) {
                expect(actualTable.get(i).getText()).to.eventually.eql(expectedListfromAPI[i]);
            }

            if (patientApiInfo.current_assignment !== null){
                var selectedTA = patientApiInfo.current_assignment.treatment_arms.selected;
                expect(element(by.css('treatment-arm-title[name="currentTreatmentArm.name"]'))).to.
                    eventually.equal(selectedTA.treatment_arm);

                expect(element(by.css('treatment-arm-title[name="currentTreatmentArm.stratum"]'))).to.
                eventually.equal(selectedTA.treatment_arm_stratum);

                expect(element(by.css('treatment-arm-title[name="currentTreatmentArm.version"]'))).to.
                eventually.equal(selectedTA.treatment_arm_version);
            }
        }).then(function () {
            callback();
        })
    });

    this.Then(/^I should see the patient's disease information match the database$/, function (callback) {
        var actualTable = patientPage.diseaseSummaryTable.all(by.css('.ng-binding'));
        patientInfoPromise.then (function (info){
            var patientApiInfo = JSON.parse(info);
            var expectedListfromAPI = [];
            if (patientApiInfo.disease !== null) {
                var diseaseName = utilities.dashifyIfEmpty (patientApiInfo.disease.disease_name);
                var diseaseType = utilities.dashifyIfEmpty (patientApiInfo.disease.disease_code_type);
                var diseaseCode = utilities.dashifyIfEmpty (patientApiInfo.disease.disease_code);
                //todo:add drugs list/
                var priorDrugs  = '-';

                expectedListfromAPI.push (diseaseName);
                expectedListfromAPI.push (diseaseType);
                expectedListfromAPI.push (diseaseCode);

                for (var i = 0; i < expectedListfromAPI.length; i++) {
                    expect (actualTable.get (i).getText ().to.eventually.eql (expectedListfromAPI[ i ]));
                }

                // todo: add priorDrugs list check.
            }
        }).then(function () {
            callback();
        });
    });

    this.Then(/^I should see the patient's disease information table$/, function (callback) {
        //checking for presence of table
        expect(browser.isElementPresent(patientPage.diseaseSummaryTable)).to.eventually.be.true;
        var expectedLabelList = patientPage.expectedDiseaseSummaryLabels;
        var actualLabelList = patientPage.diseaseSummaryTable.all(by.css('dt'));
        expect(actualLabelList.count()).to.eventually.equal(expectedLabelList.length);

        for(var i = 0; i < expectedLabelList.length; i++){
            expect(actualLabelList.get(i).getText()).to.eventually.equal(expectedLabelList[i]);
        }
        browser.sleep(5).then(callback);
    });

    this.Then(/^I should see the main tabs associated with the patient$/, function (callback) {
        // checking for number of tabs
        expect(actualMainTabsArray.count()).to.eventually.equal(expectedMainTabs.length);
        //checking for each individual tab name in order
        utilities.checkElementArray(actualMainTabsArray, expectedMainTabs);
        browser.sleep(5).then(callback);
    });

    this.Then(/^I should see the "([^"]*)" tab is active$/, function (tabName, callback) {
        var index = expectedMainTabs.indexOf(tabName);
        var testElement = actualMainTabsArray.get(index);
        utilities.checkElementIncludesAttribute(testElement, 'class', 'active').then(callback);
    });


    this.Then(/^I should see the "(.+)" section heading$/, function (heading, callback) {
        var index = patientPage.expectedMainTabSubHeadings.indexOf(heading);
        var actual_element = patientPage.mainTabSubHeadingArray().get(index);
        expect(actual_element.getText()).to.eventually.eql(heading).and.notify(callback);
    });


    this.Then(/^I should see data under "(.+)" heading/, function (heading, callback) {
        // todo: Fill out this code steps
        //Get access to then current Active tab currentActiveMainTab
        // Check that there is Action Needed from the JSON output.
        // Is this currently hardcoded here?
        callback();
    });

    this.Then(/^I should see the  Treatment Arm History about the patient$/, function (callback) {
        //Getting the treatment arms history from the API call
        //todo: write coede for getting the ta_history from the patient call

        //var expectedTAHistory = patientApiInfo['ta_history']
        browser.sleep(50).then(callback);


    });

    this.Then(/^I should see the Patient Timeline section with the timeline about the patient$/, function (callback) {
        // todo: write code here to see the Patient Timeline section with the timeline about the patient
        browser.sleep(50).then(callback);
    });

    // todo: All pages that have TA "title" should display Name, Stratum and Version.
    // todo: MATCHKB-349

};
