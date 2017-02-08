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

    this.Then(/^I remember "([^"]*)" column order of the "([^"]*)" table$/, function (column, tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);
        var headers = table.element(by.tagName('thead')).all(by.tagName("th"));

        // var rows = element.all(by.repeater('item in filtered'));
        
        var getCol = function (arr, col) {
            return arr.map(function (row) { return row[col]; });
        };
        
        utilities.getDataByRepeater(table, 'item in filtered', function(tableData) {
            console.log('col', getCol(tableData, column));
        })
        .then(callback);

        // var dataArray = [];
        // var rowData;
        
        // var getCol = function (arr, col) {
        //     return arr.map(function (row) { return row[col]; });
        // };

        // rows.each(function (row, rowIndex) {
        //     row.all(by.tagName('td')).each(function(c, colIndex){
        //         c.getText().then(function (t) {
        //             rowData = dataArray[rowIndex];
        //             if (!rowData) {
        //                 rowData = [];
        //                 dataArray[rowIndex] = rowData;
        //             }
        //             rowData[colIndex] = t;
        //         });
        //     });
        // })
        // .then(function() {
        //     patientPage.columnData = getCol(dataArray, column);
        // })
        // .then(callback);
    });

    this.Then(/^I click on "([^"]*)" column header of the "([^"]*)" table$/, function (column, tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);
        var headers = table.element(by.tagName('thead')).all(by.tagName("th"));
        headers.get(column).click().then(callback);
    });

    this.Then(/^I should see the data in the "([^"]*)" column to be re\-arranged$/, function (column, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });
};
