/**
 * Created by raseel.mohamed on 7/7/16
 */

'use strict';
var fs = require('fs');

var patientPage = require('../../pages/patientPage');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    var surgicalEventId = '';
    var surgicalEventData;
    var patientApi;
    var patientId
    var responseData;
    var surgicalTabs = element.all(by.css('li[ng-repeat="surgicalEvent in specimenEvents"]'));

    this.World = require('../step_definitions/world').World;

    this.When(/^I select another from the drop down$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        browser.sleep(50).then(callback);
    });

    this.Then(/^I capture the current Surgical Event Id from the drop down$/, function (callback) {
        patientPage.surgicalEventDropDownButton.getText().then(function (completeSurgicalId) {
            surgicalEventId = patientPage.trimSurgicalEventId(completeSurgicalId);
        }).then(callback);
    });

    this.When(/^I collect the patient Id$/, function (callback) {
        browser.getCurrentUrl().then(function (url) {
            var startPos = url.indexOf('=') + 1;
            patientId = url.slice(startPos);
        }).then(callback);
    });

    this.When(/^I collect information about the patient$/, function (callback) {
        var url = '/api/v1/patients/' + patientPage.patientId

        utilities.getRequestWithService('patient', url).then(function(response){
            patientPage.responseData = response
        }).then(callback);
    });

    this.When(/^I collect specimen information about the patient$/, function (callback) {
        var url = '/api/v1/patients/' + patientPage.patientId + '/specimen_events';
        utilities.getRequestWithService('patient', url).then(function(response){
            patientPage.responseData = response
        }).then(callback);
    });

    this.Then(/^I should see the same number of surgical event tabs$/, function (callback) {

        var response = patientPage.responseData['tissue_specimens']
        var expectedCount = 0
        for (var i = 0; i < response.length; i++) {
            if (response.surgical_event_id !== null) {
                expectedCount++;
            }
        }

        utilities.waitForElement(surgicalTabs.get(0), 'Surgical events tabs');

        browser.ignoreSynchronization = true;

        expect(surgicalTabs.count()).to.eventually.eql(expectedCount).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.When(/^I click on the Surgical Event Tab at index "(.+?)"$/, function (index, callback) {
        surgicalTabs.get(index).click().then(function () {
            browser.sleep(10);
        }).then(callback);
    });

    this.When(/^I click on the Surgical Event tab "(.+?)"$/, function (seid, callback) {
        browser.ignoreSynchronization = true;
        browser.sleep(5000);
        var cssSelec = 'li[heading="Surgical Event '+seid+'"] > a'
        var surgicalEventTab = element(by.css(cssSelec));
        surgicalEventTab.isPresent().then(function(isVis){
            // console.log(isVis);
            if(isVis){
                surgicalEventTab.click().then(function () {
                    browser.sleep(10);
                }, function(err){
                    console.log('Unable to click on the surgical event tab');
                });
            }
        }).then(callback);
    });

    this.Then(/^The Surgical Event Id match that of the backend$/, function (callback) {
        var response = patientPage.responseData['tissue_specimens']
        for (var i = 0; i < response.length; i++) {
            if (response[i].surgical_event_id !== null) {
                surgicalEventId = response[i].surgical_event_id;
                surgicalEventData = response[i];
                break;
            }
        }

        expect(patientPage.surgicalEventId.getText()).to.eventually.eql(surgicalEventId).notify(callback);
    });

    this.Then(/^I should see the "(.+?)" under surgical event tab$/, function (heading, callback) {
        var index = patientPage.expectedSurgicalSectionHeading.indexOf(heading);

        expect(patientPage.surgicalEventSectionHeading.get(index)
            .getText()).to.eventually.eql(heading).notify(callback);
    });

    this.Then(/^I should see the "(Event|Details)" Section under patient Surgical Events$/, function (section, callback) {
        var headerBox = patientPage.surgicalEventHeaderBoxLabels[section];
        var expectedHeaderBoxLabels = headerBox['labels'];
        // Getting access to the specific biopsy box
        var actualHeaderBox = patientPage.surgicalEventSummaryBoxList.get(headerBox['index']);
        // Getting to the lables in the above box
        var actualHeaderLabels = actualHeaderBox.all(by.css('.dl-horizontal>dt'));

        browser.ignoreSynchronization = true;
        // expect(actualHeaderBox.all(by.css('h4')).get(0).getText()).to.eventually.equal(section);
        for (var i = 0; i < expectedHeaderBoxLabels.length; i++) {
            expect(actualHeaderLabels.get(i).getText()).to.eventually.equal(expectedHeaderBoxLabels[i]);
        }
        expect(actualHeaderLabels.count()).to.eventually.equal(expectedHeaderBoxLabels.length).notify(callback);

    });

    this.Then(/^They match with the patient json for "([^"]*)" section$/, function (arg1, callback) {
        console.log("patientId " + patientPage.responseData);


        browser.sleep(50).then(callback);
    });

    this.Then(/^I see the Assay History Match with the database$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^The status of each molecularId is displayed$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });
};