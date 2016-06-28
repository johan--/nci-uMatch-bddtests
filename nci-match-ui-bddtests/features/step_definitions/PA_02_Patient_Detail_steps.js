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

    // Given Section
    // When Section

    this.When(/^I click on one of the patients$/, function () {
        callback.pending();
    });

    this.When(/^I click on the "([^"]*)" tab$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    // Then Section

    this.Then(/^I am taken to the patient details page\.$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I should see the patient's information$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I should see the patient's disease information$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I should see the main tabs associated with the patient$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I should see the "([^"]*)" tab is active$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I should see the Actions Needed section with data about the patient$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I should see the Patient Timeline section with the timeline about the patient$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

};
