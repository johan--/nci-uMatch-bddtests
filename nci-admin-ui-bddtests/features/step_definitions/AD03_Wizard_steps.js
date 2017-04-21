'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var wizard = require('../../pages/wizardPage')
var utilities = require('../../support/utilities');

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    var data_folder = 'data_files'
//Given

    this.Given(/^I click on "([^"]*)" button in the wizard$/, function (buttonName, callback) {
        var buttonElement = returnButtonElement(buttonName);
        buttonElement.click().then(function(){
            browser.waitForAngular()
        }).then(callback);
    });

    this.Given(/^I fill in the Arm Data form section$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Given(/^I fill in the Other Data form section$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Given(/^I fill in the Exclusion\/Inclusion Varients form section$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Given(/^I preload treatment arm "([^"]*)" and version "([^"]*)"$/, function (arg1, arg2, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I verify the Arm Data form section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I verify the Other Data form section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I verify the Exclusion\/Inclusion Varients form section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I delete the "([^"]*)" field$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Given(/^I land on the selection section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

//When
    this.When(/^I select treatment arm "([^"]*)" from the choices$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.When(/^I select version "([^"]*)" from the version dropdown$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

//Then
    this.Then(/^I see the details I entered for confirmation$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I am on the "([^"]*)" section$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I can see then new Treatment arm in the temporary table$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^I see the field is required message under "([^"]*)" field$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^A popup is seen displaying the message "([^"]*)"$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    function returnButtonElement(buttonName){
        var button = {
            "Create New Treatment Arm": wizard.createTreatmentArmButton,
            "Upload or Choose Treatment Arm": wizard.chooseTreatmentArmButton
        }
        return button[buttonName];
    }
}
