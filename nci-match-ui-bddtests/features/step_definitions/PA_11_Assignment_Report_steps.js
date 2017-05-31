'use strict';

var fs = require('fs');
var patientPage = require('../../pages/patientPage');
var utilities = require('../../support/utilities');

module.exports = function () {
    this.World = require('../step_definitions/world').World;

    var tabIndex;

    this.When(/^I go to the patient "([^"]*)" with surgical event "([^"]*)"$/, function (id, srgicalId, callback) {
        patientPage.patientId = id;
        patientPage.surgicalId = srgicalId;
        var uri = '/#/patient?patient_id=' + id + '&section=surgical_event&surgical_event_id=' + srgicalId;
        browser.sleep(500).then(function () {
            browser.get(uri, 1000).then(function () {
                browser.waitForAngular()
            });
        }).then(callback);
    });

    this.When(/^I get the count of Assignment reports for the Surgical Event$/, function (callback) {
        browser.waitForAngular().then(function () {
            patientPage.assignmentList.count().then(function(cnt){
                patientPage.assignmentCount = cnt;
            });
        }).then(callback);
    });

    this.When(/^I go to the Assignment Report on tab "([^"]*)"$/, function (tab, callback) {
        tabIndex = tab -1
        patientPage.assignmentTabList.get( tabIndex ).click().then(function () {
            browser.waitForAngular()
        }).then(callback)
    });

    this.Then(/^I see that the count of Assignment report tabs match that of count in the surgical event details$/, function (callback) {
        patientPage.assignmentTabList.count().then(function (cnt) {
            expect(cnt).to.eql(patientPage.assignmentCount, "Assignment Tab count mismatch")
        }).then(callback);
    });

    this.Then(/^I see that the Analysis Id is "([^"]*)"$/, function (analysisId, callback) {
        var elem = element(by.css('.active[ng-repeat="tab in tabset.tabs"]'))
            .element(by.binding('assignmentReport.analysis_id'));

        browser.waitForAngular().then(function () {
            utilities.checkExpectation(
                elem.getText(), analysisId, "Analysis Id Mismatch")
        }).then(callback);
    });

    this.Then(/^The comment on the Analysis Id is "([^"]*)"$/, function (comment, callback) {
        var elem = patientPage.commentInAssgnMntReport.get(tabIndex)

        browser.waitForAngular().then(function () {
            utilities.checkExpectation(
                elem.getText(), comment, "Comment Mismatch")
        }).then(callback);
    });

    this.Then(/^Tab "([^"]*)" "(does( not)?)" have a bell$/, function (tab, see_or_not, callback) {
        var present = see_or_not !== 'does not';
        var bell = patientPage.assignmentTabList
            .get(parseInt(tab))
            .element(by.css('i[ng-if="isLatestAssignmentReport(assignmentReport)"]'));
        browser.isElementPresent(bell).then(function(check){
            expect(check).to.eql(present);
        }).then(callback);
    });
};


