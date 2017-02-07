/**
 * Created by hendriksson on 02/7/17
 */

'use strict'
var fs = require('fs');
var moment = require('moment');

var utilities = require ('../../support/utilities');
var dash      = require ('../../pages/dashboardPage');
var cliaPage      = require ('../../pages/CLIAPage');
var cliaVariantReportPage      = require ('../../pages/CLIAVariantReportPage');

var nodeCmd   = require ('node-cmd');
module.exports = function() {
    this.World = require ('../step_definitions/world').World;
    var controlType;

    this.When(/^I go to clia variant filtered report with "(.+)" as the molecular_id$/, function (molecularId, callback) {
        var location = '/#/clia-lab-report/no-template-sample-control/?site=' + cliaPage.site
            + '&type=no_template_control' + '&molecular_id=' + molecularId;
        browser.get(location, 6000).then(function () {browser.waitForAngular();}).then(callback);
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

        if(subTabName === "No Template Control"){
            acceptProperty = cliaVariantReportPage.acceptNtcButton;
        }
        else{
            acceptProperty = cliaVariantReportPage.rejectPcButton;
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
        confirmVRStatus = cliaVariantReportPage.confirmVRStatusCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
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
