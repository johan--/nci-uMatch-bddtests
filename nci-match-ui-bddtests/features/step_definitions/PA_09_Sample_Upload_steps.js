/**
 * Created by Raseel Mohamed on Jan 31 2017
 */

'use strict';
var fs = require ("fs");

var patientPage = require("../../pages/patientPage");

var utilities = require("../../support/utilities");

module.exports = function() {
     this.World = require('../step_definitions/world').World;

     this.When(/^I can see that some files have not been uploaded for the Surgical Event$/, function (callback) {
          // Write code here that turns the phrase above into concrete actions
          callback(null, 'pending');
     });

     this.Then(/^I can see the "([^"]*)" dialog$/, function (arg1, callback) {
            // Write code here that turns the phrase above into concrete actions
            callback(null, 'pending');
     });

     this.Then(/^I select an Ion Reporter "([^"]*)"$/, function (arg1, callback) {
            // Write code here that turns the phrase above into concrete actions
            callback(null, 'pending');
     });

     this.Then(/^I enter Analysis ID "([^"]*)"$/, function (arg1, callback) {
            // Write code here that turns the phrase above into concrete actions
            callback(null, 'pending');
     });

     this.Then(/^I select a file "([^"]*)"$/, function (arg1, callback) {
            // Write code here that turns the phrase above into concrete actions
            callback(null, 'pending');
     });

     this.Then(/^I can click on the "([^"]*)" button$/, function (arg1, callback) {
            // Write code here that turns the phrase above into concrete actions
            callback(null, 'pending');
     });

     this.Then(/^I can see the Sample File upload process has started$/, function (callback) {
            // Write code here that turns the phrase above into concrete actions
            callback(null, 'pending');
     });

     this.When(/^I can see that all files have been uploaded for the Surgical Event$/, function (callback) {
           // Write code here that turns the phrase above into concrete actions
           callback(null, 'pending');
     });

     this.Then(/^The "([^"]*)" button is "([^"]*)"$/, function (arg1, arg2, callback) {
           // Write code here that turns the phrase above into concrete actions
           callback(null, 'pending');
     });

     this.Then(/^I can see the Upload Progress in the toolbar$/, function (callback) {
           // Write code here that turns the phrase above into concrete actions
           callback(null, 'pending');
     });

     this.Then(/^I can see current uploads$/, function (callback) {
           // Write code here that turns the phrase above into concrete actions
           callback(null, 'pending');
     });

     this.Then(/^I can cancel the first upload in the list$/, function (callback) {
           // Write code here that turns the phrase above into concrete actions
           callback(null, 'pending');
     });

     this.Then(/^The cancelled file is removed from the upload list$/, function (callback) {
           // Write code here that turns the phrase above into concrete actions
           callback(null, 'pending');
     });


};
