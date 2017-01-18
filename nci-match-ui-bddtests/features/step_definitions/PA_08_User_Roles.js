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

    this.When(/^The variant comment buttons are displayed$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });
    
    this.Then(/^I can click on the variant comment button$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I should see the variant comment dialog$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I "(should( not)?)" be able to edit the comment$/, function (shouldOrNot, callback) {
        var should = shouldOrNot === 'should';

        var variantElem = patientPage.variant('', '');
        if (should) {
        } else {
        }
  
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I "(should( not)?)" be able to click OK button$/, function (shouldOrNot, callback) {
        var should = shouldOrNot === 'should';

        var button = patientPage.button('OK');
        if (should) {
        } else {
        }

        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });
};
