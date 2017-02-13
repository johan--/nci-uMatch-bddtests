/**
 * Created by hendriksson on 02/7/17
 */

'use strict'
var fs = require('fs');
var moment = require('moment');

var utilities = require('../../support/utilities');
var dash      = require('../../pages/dashboardPage');
var cliaPage      = require('../../pages/CLIAPage');

var nodeCmd   = require('node-cmd');
module.exports = function() {
    this.World = require('../step_definitions/world').World;
    var controlType;

    this.When(/^I go to clia variant filtered report with "(.+)" as the molecular_id on "(.+)" tab$/, function (molecularId, subTabName, callback) {
        var location;
        cliaPage.site = 'MoCha';

        if(subTabName === "Positive Sample Controls") {
            location = '/#/clia-lab-report/positive-control/?site=' + cliaPage.site
                + '&type=positive_sample_control' + '&molecular_id=' + molecularId;
        }
        else if(subTabName === "No Template Control") {
            location = '/#/clia-lab-report/no-template-sample-control/?site=' + cliaPage.site
                + '&type=no_template_control' + '&molecular_id=' + molecularId;
        }
        else{
            location = '/#/clia-lab-report/proficiency-competency-sample-control/?site=' + cliaPage.site
                + '&type=positive_sample_control' + '&molecular_id=' + molecularId;
        }

        browser.get(location, 6000).then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^The clia report "(.+?)" button is "(disabled|enabled|visible|invisible)"$/, function (buttonText, buttonState, callback) {
        var button = element(by.buttonText(buttonText));
        var isVisible = buttonState === 'enabled' || buttonState === 'disabled';
        var isAvailable = buttonState === 'enabled' || buttonState === 'visible';

        if (isVisible){
            expect(button.isEnabled()).to.eventually.eql(isAvailable).notify(callback);
        } else {
            expect(button.isPresent()).to.eventually.eql(isAvailable).notify(callback);
        }
    });

    this.When(/^I click on clia report "(.+?)" button on "(.+?)"$/, function (statusButton, subTabName, callback) {
        var acceptProperty;

        if(subTabName === "Positive Sample Controls"){
            acceptProperty = cliaPage.rejectPcButton;
        }
        else if(subTabName === "No Template Control") {
            acceptProperty = cliaPage.acceptNtcButton;
        }
        else {
            acceptProperty = cliaPage.confirmPncButton;
        }

        browser.executeScript('window.scrollTo(0, 5000)').then(function(){

            acceptProperty.click().then(function() {
                browser.waitForAngular();
                browser.ignoreSynchronization = false;
                browser.sleep(5000);
            })

        }).then(callback)

    });

    this.When(/^I can see the clia report "([^"]*)" in the modal text box$/, function (comment, callback) {
        var confirmVRStatus;
        confirmVRStatus = cliaPage.confirmVRStatusCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
    });

    this.When(/^I click on clia report Comment button$/, function (callback) {
        var acceptProperty;
        acceptProperty = cliaPage.statusCancelButton;

            acceptProperty.click().then(function() {
                browser.waitForAngular();
                browser.ignoreSynchronization = false;
                browser.sleep(4000);
            })

        browser.executeScript('window.scrollTo(0, 100)');

    });

    // this.Then (/^I should see the patient's information table$/, function (callback) {
    //     //checking for presence of table
    //     expect (browser.isElementPresent (patientPage.patientSummaryTable)).to.eventually.be.true;
    //     //checking if the label values match
    //     var expectedLabelList = patientPage.expectedPatientSummaryLabels;
    //     var actualLabelList   = patientPage.patientSummaryTable.all (by.css ('dt'));
    //     expect (actualLabelList.count ()).to.eventually.equal (expectedLabelList.length);
    //     for (var i = 0; i < expectedLabelList.length; i++) {
    //         expect (actualLabelList.get (i).getText ()).to.eventually.equal (expectedLabelList[ i ]);
    //     }
    //     browser.sleep (50).then (callback);
    // });

    this.Then(/^I "(should|should not)" see the status$/, function (presence, callback) {
        var status = presence == 'should';
        var positiveControlArray = ['Molecular ID',
            'Analysis ID',
            'Ion Reporter ID',
            'Positive Control Loaded Date',
            'Torrent Variant Caller Version', 
            'Positive Control Version', 
            'Status'];
        var index = positiveControlArray.indexOf(6);

        console.log("--> " + cliaPage.infoPanel.all(by.css('.ng-binding')).get(index).getText())

        // if (status === true) {
        //     expect(cliaPage.infoPanel.all(by.css('.ng-binding')).get(index).getText())
        //         .to
        //         .eventually
        //         .include(value)
        //         .notify(callback);
        // }
        // else {
        //     cliaPage.infoPanel.all(by.css('.ng-binding')).get(index).getText().then(function (text) {
        //         expect(text).to.not.eql(value);
        //     }).then(callback);
        // }
    });


    // this.When(/^I clear the text in the modal text box$/, function (callback) {
    //     patientPage.confirmChangeCommentField.clear();
    //     browser.sleep(50).then(callback);
    // });
    //
    // this.When(/^I enter the cliaPage report comment "([^"]*)" in the VR modal text box$/, function (comment, callback) {
    //     patientPage.confirmVRStatusCommentField.sendKeys(comment);
    //     browser.sleep(50).then(callback);
    // });

};
