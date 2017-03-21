/**
 * Created by Raseel Mohamed on Jan 31 2017
 */

'use strict';
var fs = require("fs");
var path = require("path");

var patientPage = require("../../pages/patientPage");

var utilities = require("../../support/utilities");

module.exports = function () {
    var templateFolder = '../DataSetup/variant_file_templates/templates_for_ui/'

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
        }).then(callback);
    });

    this.Then(/^I enter Analysis ID "([^"]*)"$/, function (analysisId, callback) {
        patientPage.upldDialogAnalysisId.clear();
        patientPage.upldDialogAnalysisId.sendKeys(analysisId);
        expect(patientPage.upldDialogAnalysisId.getAttribute('value')).to.eventually.eql(analysisId).notify(callback);
    });

    this.When(/^I make all elements visible$/, function(next){
        browser.executeAsyncScript(function(callback) {
            document.querySelectorAll('#vcfFile')[0]
                .style.display = 'inline';
            callback();
        }).then(function(callback){
            browser.executeAsyncScript(function(callback) {
                document.querySelectorAll('#dnaFile')[0]
                    .style.display = 'inline';
                callback();
            })
        }).then(function(callback){
            browser.executeAsyncScript(function(callback) {
                document.querySelectorAll('#rnaFile')[0]
                    .style.display = 'inline';
                callback();
            })
        }).then(next);

    })

    this.Then(/^I press "(.+?)" file button to upload "([^"]*)" file$/, function (buttonName, fileName, callback) {
        var buttonType = patientPage.uploadButtonsId[buttonName]
        var pathToFile = templateFolder + fileName;
        var absolutePath = path.resolve(pathToFile);
   
        element(by.css('input#' + buttonType + '[type="file"]')).sendKeys(absolutePath)
            .then(callback);
    });

    this.Then(/^I can only see "([^"]*)" type user$/, function(siteName, callback){
        var dropdownList = patientPage.selectSiteDropDownList
        dropdownList.getText().then(function(arrList){
            // console.log(arrList);
            for (var i = 1; i < arrList.length; i++) {  //starting from the second element onwards. The first is the buttonName 
                expect(arrList[i]).to.include(siteName);
            }
        }).then(callback);
    });

    this.Then(/^The Upload new sample file link is not visible$/, function (callback) {
        var elem = element(by.cssContainingText('.btn', 'Upload new sample file'));
        expect(elem.isPresent()).to.eventually.eql(false).notify(callback);
    });


    this.Then(/^I can see the Sample File upload process has started$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });


    this.Then(/^I can see the Upload Progress in the toolbar$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I click on the Upload Progress in the toolbar$/, function (callback) {
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
