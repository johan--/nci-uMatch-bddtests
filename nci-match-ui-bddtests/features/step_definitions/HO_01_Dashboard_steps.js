'use strict';
var fs = require('fs');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function() {
    this.World = require ('../step_definitions/world').World;

    this.Then(/^I can see the Pending Review Section$/, function (callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.Then(/^I can see the pending "([^"]*)" subtab$/, function (arg1, callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.Then(/^I can see the Patients Statistics Section$/, function (callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.Then(/^I can see the Donut chart for confirmed patients with aMOI$/, function (callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.Then(/^I can see the Treatment Arm Accrual chart$/, function (callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.When(/^I navigate to the dashboard page\.$/, function (callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.Given(/^I collect information for the Dashboard$/, function (callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.Then(/^count of "([^"]*)" table match with the "([^"]*)" statistics$/, function (arg1, arg2, callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });

    this.Given(/^if the "([^"]*)" table is empty the message$/, function (arg1, reportType, callback) {
      // Write code here that turns the phrase above into concrete actions
      callback.pending();
    });
}
