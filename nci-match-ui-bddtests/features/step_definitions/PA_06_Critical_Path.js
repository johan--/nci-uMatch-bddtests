/**
 * Created by raseel.mohamed on 9/4/16
 */
'use strict';
var fs = require('fs');

var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    this.World = require ('../step_definitions/world').World;


    this.Given (/^I enter "([^"]*)" in the patient filter field$/, function (filterValue, callback) {
        patientPage.patientFilterTextBox.sendKeys(filterValue).then(function () {
            var firstPatient = patientPage.patientGridRows.get(0);
            expect(firstPatient.all(by.binding('item.patient_id')).get(0).getText()).to.eventually.eql(filterValue);
        });
        browser.sleep(50).then(callback);
    });

    this.When (/^I uncheck the variant of ordinal "([^"]*)"$/, function (arg1, callback) {
        console.log(patientPage.responseData);
        browser.sleep(40).then(callback);
    });

    this.Then (/^I "(should( not)?)" see the confirmation modal pop up$/, function (seen, callback) {
        if (seen === 'should') {
            expect(patientPage.modalWindow.isPresent()).to.eventually.eql(true).then(callback);
        } else {
            expect (patientPage.modalWindow.isPresent ()).to.eventually.eql (false).then (callback);
        }
    });

    this.Then (/^The variant at ordinal "([^"]*)" is "([^"]*)" checked$/, function (arg1, arg2, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });

    this.When (/^I can see the comment column in the variant at ordinal "([^"]*)" is "([^"]*)"$/, function (arg1, arg2, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });

    this.When (/^I enter the comment "([^"]*)" in the modal text box$/, function (arg1, comment, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });

    this.Then (/^I can see the comment column in the variant at ordinal "([^"]*)"$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });

    this.When (/^I click on the comment link$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });

    this.Then (/^I can see the "([^"]*)" in the modal text box$/, function (arg1, comment, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });

    this.When (/^I click on the "([^"]*)" button$/, function (buttonText, callback) {
        element(by.buttonText(buttonText)).click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then (/^I see the status of Report as "([^"]*)"$/, function (arg1, callback) {
        expect(patientPage.tissueReportStatus.getText()).to.eventually.eql("CONFIRMED").then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then (/^I can see the name of the commenter is present$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });
};