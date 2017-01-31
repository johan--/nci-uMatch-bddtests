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
        var getRows = patientPage.tableRowArrayByH3Title(tableTitle);

        // console.log('tableTitle', tableTitle);

        getRows.getText().then(function(text){
            console.log('text',text);
        }).then(callback);

        // callback(null, 'pending');
    });

    this.Then(/^I remember "([^"]*)" column order$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });


    this.Then(/^I click on "([^"]*)" column$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I should see the data in the "([^"]*)" column to be re\-arranged$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });
};
