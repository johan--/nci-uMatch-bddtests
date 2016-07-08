/**
 * Created by raseel.mohamed on 6/26/16
 */

'use strict';
var fs = require('fs');

var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    this.World = require ('../step_definitions/world').World;

    var patientId = patientPage.getPatientId();
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
            var cssLocator = 'a[href="#/patient/' + id + '"]';
            patientId = id;
            element(by.css(cssLocator)).click();
        }).then(callback);
    });

    this.When(/^I collect the patient Api Information$/, function (callback) {
        console.log(patientId);
        // todo: collect patient information from API call. below is a possible solution
        // var response = utilities.callApiForDetails(patientId, 'patients');
        // response.get().then(function () {
        //     patientApiInfo = utilities.getJSONifiedDetails(response.entity());
        // });


        browser.sleep(50).then(callback);
    });

    this.When(/^I click on the "([^"]*)" tab$/, function (tabName, callback) {
        var index = expectedMainTabs.indexOf(tabName);
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
            expect(browser.getCurrentUrl()).to.eventually.equal(browser.baseUrl + '/#/patient/' + patientId)
        }).then(callback);
    });

    this.Then(/^I should see the patient's information table$/, function (callback) {
        //checking for presence of table
        expect(browser.isElementPresent(patientPage.patientSummaryTable)).to.eventually.be.true;
        //checking if the label values match
        var expectedLabelList = patientPage.expectedPatientSummaryLabels;
        var actualLabelList = patientPage.patientSummaryTable.all(by.css('dt'));
        expect(actualLabelList.count()).to.eventually.equal(expectedLabelList.length)
        for(var i = 0; i < expectedLabelList.length; i++){
            expect(actualLabelList.get(i).getText()).to.eventually.equal(expectedLabelList[i]);
         }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the patient's information match database$/, function (callback) {
        //todo: Get the api to retrieve the patient JSON
        var actualTable = patientPage.patientSummaryTable.all(by.css('.ng-binding'));
        // The list of all the labels that are present on the left hand side.
        var expectedLabelList = patientPage.expectedPatientSummaryLabels;

        var actualValueList = [];
        var expectedListfromAPI = [];
        actualTable.count().then(function (cnt) {
            if (cnt !== undefined){
                for (var i = 0; i < cnt; i++){
                    actualValueList.push(actualTable.get(i).getText());
                }
            }
        });
        expectedListfromAPI.push(patientApiInfo.patient_id);
        expectedListfromAPI.push(patientApiInfo.gender + ', ' + patientApiInfo.enthnicity);
        expectedListfromAPI.push(patientApiInfo.last_rejoin_scan_date);
        expectedListfromAPI.push(patientApiInfo.current_status);
        expectedListfromAPI.push(patientApiInfo.current_step_number);
        var selected_ta = patientApiInfo.current_assignment.treatment_arms.selected;
        expectedListfromAPI.push(selected_ta.treatment_arm);
        expectedListfromAPI.push(selected_ta.treatment_arm_stratum);
        expectedListfromAPI.push(selected_ta.treatment_arm_version);

        // we are adding 2 here because the Treatment arm is a combination of the treatment arm name the stratem and the version date.
        expect(actualValueList.count()).to.eventually.equal(expectedLabelList.length + 2);

        // Doing a deep equal (==) rather than identity (===) becuase we are comparing two arrays
        expect(actualValueList).to.eventually.eql(expectedListfromAPI);
        browser.sleep(5).then(callback);
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

    this.Then(/^I should see the patient's disease information match the database$/, function (callback) {
        //todo: write the implemetation iif the code
        var expectedValueList ;
        var actualValueList = patientPage.diseaseSummaryTable.all(by.css('.ng-binding'))
        //expect(actualValueList).to.equal(expectedValueList);
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
        utilities.checkElementIncludesAttribute(testElement, 'class', 'active');
        browser.sleep(50).then(callback)
    });

    this.Then(/^I should see the Actions Needed section with data about the patient$/, function (callback) {
        // todo: Fill out this code steps
        //Get access to then current Active tab currentActiveMainTab
        // Check that there is Action Needed from the JSON output.
        // Is this currently hardcoded here?
        callback.pending();
    });

    this.Then(/^I should see the  Treatment Arm History about the patient$/, function (callback) {
        //Getting the treatment arms history from the API call
        //todo: write coede for getting the ta_history from the patient call

        //var expectedTAHistory = patientApiInfo['ta_history']
        callback.pending();


    });

    this.Then(/^I should see the Patient Timeline section with the timeline about the patient$/, function (callback) {
        // todo: write code here to see the Patient Timeline section with the timeline about the patient
        callback.pending();
    });

};
