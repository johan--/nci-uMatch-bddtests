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
};
