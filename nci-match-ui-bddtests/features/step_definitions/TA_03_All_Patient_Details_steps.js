/**
 * Created by raseel.mohamed on 6/13/16
 */

'use strict';
var fs = require('fs');

var taPage = require('../../pages/treatmentArmsPage');
// Helper Methods
var utilities = require('../../support/utilities');

module.exports = function () {

    this.World = require('../step_definitions/world').World;

    var treatment_id ;
    var treatmentArmAPIDetails;
    var firstTreatmentArm;


    this.When(/^I enter "([^"]*)" in the all patients data filter field$/, function (patient_id, callback) {
        taPage.allPatientDataFilter.sendKeys(patient_id).then(callback);
    });


    this.When(/^His status in the all patients table is "([^"]*)"$/, function (status, callback) {
        var row = taPage.allPatientDataRows.get(0);
        expect(row.element(by.binding('item.patient_status')).getText()).to.eventually.eql(status).notify(callback);
    });


    this.Then(/^I "([^"]*)" see the Data of Arm Generated$/, function (see_or_not, callback) {
        var state = see_or_not === 'should';
        var testElement = taPage.allPatientDataRows.get(0).element(by.css('td[ng-bind="item.date_off_arm | utc"]'));
        if (state === true ) {
            expect(testElement.getText())
                .to.eventually.match(/[A-Z,a-z]{3,} [0-9]{1,2}\, [0-9]{4} [0-9]{1,}:[0-9]{2} (AM|PM) GMT/)
                .notify(callback)
        } else {
            expect(testElement.getText())
                .to.eventually.eql('-').notify(callback);
        }
    });
};
