'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    var data_folder = 'data_files'


this.Given(/^I fill in the "([^"]*)" form page$/, function (arg1, callback) {
         // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
});

this.Then(/^I see the details I entered for confirmation$/, function (callback) {
          // Write code here that turns the phrase above into concrete actions
     callback(null, 'pending');
});

this.Then(/^I can see then new Treatment arm in the temporary table$/, function (callback) {
          // Write code here that turns the phrase above into concrete actions
     callback(null, 'pending');
});

this.Given(/^I go to the "([^"]*)" Section$/, function (arg1, callback) {
          // Write code here that turns the phrase above into concrete actions
     callback(null, 'pending');
 });

this.Given(/^I Preload The "([^"]*)" data columns are seen$/, function (arg1, callback) {
          // Write code here that turns the phrase above into concrete actions
     callback(null, 'pending');
});
}