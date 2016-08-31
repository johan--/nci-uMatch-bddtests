/**
 * Created by raseel.mohamed on 7/7/16
 */

'use strict';
var fs = require('fs');

var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    var surgicalEventId;
    var patientApi;
    var patientId
    var responseData;

    this.World = require('../step_definitions/world').World;

    this.When(/^I select another from the drop down$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        browser.sleep(50).then(callback);
    });

    this.Then(/^I capture the current Surgical Event Id from the drop down$/, function (callback) {
        patientPage.surgicalEventDropDownButton.getText().then(function (completeSurgicalId) {
            surgicalEventId = patientPage.trimSurgicalEventId(completeSurgicalId);
        }).then(callback);
    });

    this.When(/^I collect the patient Id$/, function (callback) {
        browser.getCurrentUrl().then(function (url) {
            var startPos = url.indexOf('=') + 1;
            patientId = url.slice(startPos);
        }).then(callback);
    });

    this.When(/^I collect information about the patient$/, function (callback) {
        utilities.callApi('patient', '/patients/' + patientId).then(function (returnData) {
            responseData = JSON.parse(returnData);
        }).then(callback);
    });

    this.Then(/^The Surgical Event Id match that of the drop down$/, function (callback) {
        expect(element(by.binding('currentSurgicalEvent.surgical_event_id')).getText()).to.eventually
            .eql(surgicalEventId);
        browser.sleep(59).then(callback);
    });

    this.Then(/^I should see the "(Event|Pathology)" Section under patient Surgical Events$/, function (section, callback) {
        var headerBox = patientPage.biopsyHeaderBoxLabels[section];
        var expectedHeaderBoxLabels = headerBox['labels'];
        // Getting access to the specific biopsy box
        var actualHeaderBox = patientPage.surgicalEventSummaryBoxList.get(headerBox['index']);
        // Getting to the lables in the above box
        var actualHeaderLabels = actualHeaderBox.all(by.css('.dl-horizontal>dt'));

        expect(actualHeaderBox.all(by.css('h4')).get(0).getText()).to.eventually.equal(section);
        expect(actualHeaderLabels.count()).to.eventually.equal(expectedHeaderBoxLabels.length);
        for( var i = 0; i < expectedHeaderBoxLabels.length; i++){
            expect(actualHeaderLabels.get(i).getText()).to.eventually.equal(expectedHeaderBoxLabels[i]);
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the Surgical Events drop down button$/, function (callback) {

        expect(patientPage.surgicalEventDropDownButton.isPresent()).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Then(/^They match with the patient json for "([^"]*)" section$/, function (arg1, callback) {
        console.log("patientId " + patientId);
        console.log(responseData);

        browser.sleep(50).then(callback);
    });

    this.Then(/^I see the Assay History Match with the database$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^The status of each molecularId is displayed$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });
};