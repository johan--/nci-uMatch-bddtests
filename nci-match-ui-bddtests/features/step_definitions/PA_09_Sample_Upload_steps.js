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
        var id = patientPage.uploadButtonsId[uploadButton];
        console.log('absolutePath: '  + absolutePath);
        var fileInput = element(by.css('input[id="' + id + '"][type="file"]'));
        
        switch (id){
            case 'vcfFile':
                makeVcfLabelVisible().then(function(label){
                    console.log('after make visible function');
                    fileInput.sendKeys(absolutePath);
                });
                break;

            case 'dnaFile':
                makeDnaLabelVisible().then(function(){
                    fileInput.sendKeys(absolutePath);
                });
                break;

            case 'rnaFile':
                makeRnaLabelVisible().then(function(){
                    fileInput.sendKeys(absolutePath);
                });
                break;

        }

        browser.sleep(5000).then(callback);




        

        // makeLabelVisible(id).then(function(){
        //     fileInput.sendKeys(absolutePath)
        // }).then(callback);
        
        // // browser.executeAsyncScript(function() {
        // //     var fileInput = element(by.css('input[id="' + id + '"][type="file"]'));
        // //     var ngfSelectLabel = fileInput.element(by.xpath('..'));
        // //     ngfSelectLabel.style.visibility = 'visible';
        // //     ngfSelectLabel.style.position = 'absolute';
        // //     ngfSelectLabel.style.width = '100px';
        // //     ngfSelectLabel.style.height = '100px';
        // //     ngfSelectLabel.style.background = 'white';
        // //     ngfSelectLabel.style.zIndex = '10000';
        // // }).then(function(){
        // //     fileInput.sendKeys(absolutePath);
        // // }).then(callback);

       
        // // // browser.executeScript("arguments[0].style.display = 'initial'", fileInput).then(function(){
        // // //     fileInput.click()
        // // // }).then(callback);

        // // // var script = "$('input[type=\"file\"][id=\"" + id + "\"]').parent().css('display', 'initial').css('visibility', 'visible').css('height', 1).css('width', 1).css('overflow', 'visible')"

        // // // browser.executeScript(script)
        // // // fileInput.click().then(callback);

        // // // // browser.sleep(50).then(callback);

        // // // // browser.executeScript("arguments[0].style.visibility = 'visible'; arguments[0].style.height = '1px'; arguments[0].style.width = '1px';  arguments[0].style.opacity = 1"
        // // // //     , fileInput).then(function(){
        // // // //         fileInput.sendKeys(absolutePath);                
        // // // //     }).then(function(){
        // // // //         browser.sleep(3000)
        // // // //     }).then(callback);
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


    function makeVcfLabelVisible(){
        return browser.executeAsyncScript(function(){
            console.log('int eh make visible function');
            var ngfSelectLabel = document.querySelectorAll('label[ng-class="getFileButtonClass(\'vcfFile\')"]')[0];
            ngfSelectLabel.style.visibility = 'visible';
            ngfSelectLabel.style.position = 'absolute';
            ngfSelectLabel.style.top = '0';
            ngfSelectLabel.style.width = '100px';
            ngfSelectLabel.style.height = '100px';
            ngfSelectLabel.style.background = 'white';
            ngfSelectLabel.style.zIndex = '10000';
            return ngfSelectLabel;
        });
    };

    function makeDnaLabelVisible(){
        return browser.executeAsyncScript(function(){
            var ngfSelectLabel = document.querySelectorAll('label[ng-class="getFileButtonClass(\'dnaFile\')"]')[0];
            ngfSelectLabel.style.visibility = 'visible';
            ngfSelectLabel.style.position = 'absolute';
            ngfSelectLabel.style.top = '0';
            ngfSelectLabel.style.width = '100px';
            ngfSelectLabel.style.height = '100px';
            ngfSelectLabel.style.background = 'white';
            ngfSelectLabel.style.zIndex = '10000';
            return;
        });
    };

    function makeRnaLabelVisible(){
        return browser.executeAsyncScript(function(){
            var ngfSelectLabel = document.querySelectorAll('label[ng-class="getFileButtonClass(\'rnaFile\')"]')[0];
            ngfSelectLabel.style.visibility = 'visible';
            ngfSelectLabel.style.position = 'absolute';
            ngfSelectLabel.style.top = '0';
            ngfSelectLabel.style.width = '100px';
            ngfSelectLabel.style.height = '100px';
            ngfSelectLabel.style.background = 'white';
            ngfSelectLabel.style.zIndex = '10000';
            return;
        });
    };

};
