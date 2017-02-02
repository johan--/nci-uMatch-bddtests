/**
 * Created by Raseel Mohamed on Jan 31 2017
 */

'use strict';
var fs = require("fs");
var path = require("path");

var patientPage = require("../../pages/patientPage");

var utilities = require("../../support/utilities");

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    this.When(/^I can see that some files have not been uploaded for the Surgical Event$/, function(callback) {
        // Here we are searching for no files at all attached to the specimen
        var analysisSection = patientPage.variantAndAssignmentPanel;
        expect(analysisSection.count()).to.eventually.eql(0).notify(callback)
    });

    this.Then(/^I can see the "([^"]*)" dialog$/, function(heading, callback) {
        var uploadDialog = patientPage.modalWindow.element(by.css('form[name=uploadForm] h3'));
        expect(uploadDialog.getText()).to.eventually.eql(heading).notify(callback);
    });

    this.Then(/^I select an Ion Reporter "([^"]*)"$/, function(ionReporter, callback) {
        var cssSelector = 'li[ng-repeat="item in ionReporters"] a'
        patientPage.selectSiteAndIRID.click().then(function() {
            utilities.selectFromDropDown(cssSelector, ionReporter)
        }).then(callback());
    });

    this.Then(/^I enter Analysis ID "([^"]*)"$/, function(analysisId, callback) {
        patientPage.upldDialogAnalysisId.sendKeys(analysisId);
        expect(patientPage.upldDialogAnalysisId.getAttribute('value')).
        to.eventually.eql(analysisId).notify(callback);
    });

    this.Then(/^I select a file "([^"]*)" for "([^"]*)" upload$/, function(fileName, fileType, callback) {
        var fileUploadButton = patientPage.types[fileType]['button'];
        var fileElement = patientPage.types[fileType]['input'];
        var position = patientPage.types[fileType]['order'];
        var pathToFile = 'data/' + fileName;
        var absolutePath = path.resolve(pathToFile);

        var callback = function () {

          fileElement.sendKeys(absolutePath); //assuming you only have 1 input

        };

        browser.executeAsyncScript(function(callback){
            var labelList = element.all(by.css('label'));
            var ngfSelectLabel = labelList.get(2);
            ngfSelectLabel.style.visibility = 'visible';
            ngfSelectLabel.style.position = 'absolute';
            ngfSelectLabel.style.top = '0'; //maybe needs adjustment, depending on where on the page you are
            ngfSelectLabel.style.width = '100px';
            ngfSelectLabel.style.height = '100px';
            ngfSelectLabel.style.background = 'white';
            ngfSelectLabel.style.zIndex = '10000'; //to account for any blocking modal / popup screens

          callback();

        }).then(function() {
            callback();
        }).then(callback);
    });

    this.Then(/^I can click on the "([^"]*)" button$/, function(arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I can see the Sample File upload process has started$/, function(callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.When(/^I can see that all files have been uploaded for the Surgical Event$/, function(callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^The Upload new sample file link is "([^"]*)"$/, function(visible, callback) {
        var isVisible = visible === 'visible';
        expect(browser.isElementPresent(patientPage.uploadNewSampleFile)).
        to.eventually.eql(isVisible).notify(callback);
    });

    this.Then(/^I click on the Upload new sample file link$/, function(callback){
        patientPage.uploadNewSampleFile.click().then(function(){
            browser.sleep(10);
        }).then(callback);
    });

    this.Then(/^I can see the Upload Progress in the toolbar$/, function(callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I can see current uploads$/, function(callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I can cancel the first upload in the list$/, function(callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^The cancelled file is removed from the upload list$/, function(callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });


};
