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

    this.Then(/^I can see the "([^"]*)" table$/, function (tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);

        expect(table.isPresent()).to.eventually.equal(true).notify(callback);
    });

    this.Then(/^I remember "([^"]*)" column order of the "([^"]*)" table$/, function (column, tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);
        var headers = table.element(by.tagName('thead')).all(by.tagName("th"));
        var rows = table.element(by.tagName('tbody')).all(by.tagName("tr"));

        headers.first().getText().then(function(text){
            console.log('hd text',text);
        }).then(callback);
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
