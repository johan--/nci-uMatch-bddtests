/**
 * Created by Rick Zakharov on 18 Jan 2017
 */
'use strict';
var fs = require('fs');

var patientPage = require('../../pages/patientPage');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    this.World = require('../step_definitions/world').World;

    function getColumn(arr, col) {
        return arr.map(function (row) { return row[col]; });
    }

    this.Then(/^I remember order of elements in column "([^"]*)" of the "([^"]*)" table$/, function (column, tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);
        var headers = table.element(by.tagName('thead')).all(by.tagName("th"));
       
        patientPage.unsortedColumnData = [];

        utilities.getDataByRepeater(table, 'item in filtered', function(tableData) {
            patientPage.unsortedColumnData = getColumn(tableData, column);
        })
        .then(callback);
    });

    this.Then(/^I click on "([^"]*)" column header of the "([^"]*)" table$/, function (column, tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);
        var headers = table.element(by.tagName('thead')).all(by.tagName("th"));
        
        patientPage.sortedColumnData = [];

        headers.get(column).click().then(function() {
            utilities.getDataByRepeater(table, 'item in filtered', function (tableData) {
                patientPage.sortedColumnData = getColumn(tableData, column);
            }).then(callback);
        });
    });

    this.Then(/^I should see the data in the column to be sorted properly$/, function (callback) {
        var expectedSortedData = patientPage.unsortedColumnData.sort().reverse();

        expect(expectedSortedData).to.deep.equal(patientPage.sortedColumnData);
        
        callback();
    });

    this.When(/^I click on the Surgical Event Id Link$/, function (callback) {
        patientPage.patientSurgicalEventId.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I click on the Molecular ID link$/, function (callback) {
        patientPage.patientMolecularId.click().then(function () {
            browser.sleep(40);
        }).then(callback);
    });

    this.Then(/^I should go to the surgical event page of the patient$/, function (callback) {
        var patientId = patientPage.patientId;
        var surgicalEventId = patientId + '_SEI1';
        var expectedUrl = browser.baseUrl + '/#/patient?patient_id=' + patientId + '&section=surgical_event&surgical_event_id=' + surgicalEventId;
        browser.ignoreSynchronization = true;
        expect(browser.getCurrentUrl()).to.eventually.eql(expectedUrl).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I should go to the molecular id section of the surgical event page$/, function (callback) {
        var patientId = patientPage.patientId;
        var surgicalEventId = patientId + '_SEI1';
        var molecularId = patientId + '_MOI1';
        var expectedUrl = browser.baseUrl + '/#/patient?patient_id=' + patientId + '&section=molecular_id&molecular_id=' + molecularId;
        browser.ignoreSynchronization = true;
        expect(browser.getCurrentUrl()).to.eventually.eql(expectedUrl).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

};
