/**
 * Created by raseel.mohamed on 9/4/16
 */
'use strict';
var fs = require('fs');

var patientPage = require('../../pages/patientPage');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    this.World = require('../step_definitions/world').World;

    this.Then(/^I scroll to the bottom of the page$/, function (callback) {
        browser.executeScript('window.scrollTo(0,5000)').then(callback);
    });    
};
