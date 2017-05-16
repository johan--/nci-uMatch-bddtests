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

    this.When(/^I enter the Clia Lab comment "([^"]*)" in the modal text box$/, function (comment, callback) {
        cliaPage.confirmVRStatusCommentField.sendKeys(comment).then(callback);
    });

    this.When(/^I click "(.+?)" on clia report Comment button$/, function (buttonText, callback) {
        var acceptProperty = element(by.buttonText(buttonText))

            acceptProperty.click().then(function() {
                browser.waitForAngular();
                browser.ignoreSynchronization = false;
                browser.sleep(4000);
            });

        browser.executeScript('window.scrollTo(0, 100)').then(callback);

    });

    this.Then(/^I should see the status as "(.+?)"$/, function (status, callback) {
        expect(cliaPage.infoPanel.get(0).all(by.css('dt+dd')).get(6).getText()).to.eventually.include(status).notify(callback);
    });

    this.Then(/^I should see the comment as "(.+?)"$/, function (comment, callback) {
        expect(element(by.css('[ng-if="comments!==null"] dd')).getText()).to.eventually.eql(comment).notify(callback);
    });

    this.When(/^I enter "([^"]*)" in the search field of "([^"]*)" under "([^"]*)"$/, function (searchTerm, controlType, siteName, callback) {
        var input = cliaPage.tabNameMapping[siteName][controlType].searchElement;
        cliaPage.parent = cliaPage.tabNameMapping[siteName][controlType].element;
        input.sendKeys(searchTerm).then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I should see the status of variant report in list as "([^"]*)"$/, function (status, callback) {
        var tableElement = cliaPage.parent.all(by.css('tr[ng-repeat^="item in filtered"]'));
        expect(tableElement.count()).to.eventually.equal(1)
        expect(cliaPage.searchList.get(0).all(by.binding('item.report_status | dashify')).get(0).getText())
            .to.eventually.eql(status).notify(callback);
    });

};
