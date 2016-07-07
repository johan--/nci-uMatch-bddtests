/**
 * Created by raseel.mohamed on 6/9/16
 */

'use strict';
var fs = require('fs');

var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    this.World = require ('../step_definitions/world').World;

    // Given Section
    // When Section
    // Then Section
    this.Then(/^I should see patients table$/, function (callback) {
        expect(browser.isElementPresent(patientPage.patientListTable)).to.eventually.be.true;
        browser.sleep(5).then(callback);
    });

    this.Then(/^I should see the headings in the patient table$/, function (callback) {
        var headersList = patientPage.patientListHeaders;
        var expectedList = patientPage.expectedPatientListHeaders;
        // Checking individual headers against the expected ones and in order. 
        for(var i = 0; i < expectedList.length; i++) {
            expect(headersList.get(i).getText()).to.eventually.equal(expectedList[i]);
        }
        browser.sleep(5).then(callback);
    });

    this.Then(/^I should see data in the patient table$/, function (callback) {
        expect(element.all(by.repeater('patient in patientList')).count()).to.eventually.be.greaterThan(0);
        browser.sleep(5).then(callback);
    });
};
