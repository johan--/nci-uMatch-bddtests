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

    this.When(/^The "(.+?)" button is "(disabled|enabled|visible|invisible)"$/, function (buttonText, buttonState, callback) {
        var button = element(by.buttonText(buttonText));
        var isVisible = buttonState === 'enabled' || buttonState === 'disabled';
        var isAvailable = buttonState === 'enabled' || buttonState === 'visible';

        if (isVisible){
            expect(button.isEnabled()).to.eventually.eql(isAvailable).notify(callback);
        } else {
            expect(button.isPresent()).to.eventually.eql(isAvailable).notify(callback);
        }
    });

    this.When (/^I turn off synchronization$/, function (callback) {
        browser.ignoreSynchronization = true;
        browser.sleep (50).then (callback);
    });

};
