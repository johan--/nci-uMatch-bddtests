/**
 * Created by Raseel Mohamed on Jan 31 2017
 */

'use strict';
var fs = require("fs");
var path = require("path");

var patientPage = require("../../pages/patientPage");

var utilities = require("../../support/utilities");

module.exports = function () {
    this.World = require('../step_definitions/world').World;

    this.When(/^I can see that some files have not been uploaded for the Surgical Event$/, function (callback) {
        // Here we are searching for no files at all attached to the specimen
        var analysisSection = patientPage.variantAndAssignmentPanel;
        expect(analysisSection.count()).to.eventually.eql(0).notify(callback);
    });

    this.Then(/^I can see the "([^"]*)" dialog$/, function (heading, callback) {
        var uploadDialog = patientPage.modalWindow.element(by.css('form[name=uploadForm] h3'));
        expect(uploadDialog.getText()).to.eventually.eql(heading).notify(callback);
    });

    this.Then(/^I select an Ion Reporter "([^"]*)"$/, function (ionReporter, callback) {
        var cssSelector = 'li[ng-repeat="item in ionReporters"] a';
        patientPage.selectSiteAndIRID.click().then(function () {
            utilities.selectFromDropDown(cssSelector, ionReporter);
        }).then(callback());
    });

    this.Then(/^I enter Analysis ID "([^"]*)"$/, function (analysisId, callback) {
        patientPage.upldDialogAnalysisId.sendKeys(analysisId);
        expect(patientPage.upldDialogAnalysisId.getAttribute('value')).to.eventually.eql(analysisId).notify(callback);
    });

    this.Then(/^I press "([^"]*)" file button to upload "([^"]*)" file$/, function (uploadButton, fileName, callback) {
        var pathToFile = 'data/' + fileName;
        var absolutePath = path.resolve(pathToFile);
        var fileInput = element(by.id(patientPage.uploadButtonsId[uploadButton]));

        fileInput.sendKeys(absolutePath).then(function(){
            console.log('file button text set to ' + absolutePath);
            browser.sleep(3000);
        }).then(callback);
    });

    this.Then(/^I can see the Sample File upload process has started$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.When(/^I can see that all files have been uploaded for the Surgical Event$/, function (callback) {
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
