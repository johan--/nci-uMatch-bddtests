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

    this.When(/^I scroll to the bottom of the page$/, function (callback) {
        browser.executeScript('window.scrollTo(0,3000)').then(function(){
            browser.sleep(500)
        }).then(callback);
    });

    this.When(/^I scroll to the top of the page$/, function (callback) {
        var top = element(by.css('.user-name'))
        top.getLocation().then(function(loc){
            console.log("loc: " + loc);
            browser.executeScript('window.scrollTo(' + loc.x + ',' + loc.y + ')')
        }).then(callback);
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

    this.When(/^The "(.+?)" link is "(disabled|enabled|visible|invisible)"$/, function (linkText, buttonState, callback) {
        var button = element(by.cssContainingText('.btn', linkText));
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

    this.Then(/^I can see the "([^"]*)" table$/, function (tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);

        expect(table.isPresent()).to.eventually.equal(true).notify(callback);
    });

    this.Then(/^I can click on the "([^"]*)" link$/, function(linkText, callback) {
        var button = element(by.cssContainingText('.btn', linkText));
        button.click()
            .then(function () { browser.sleep(1); })
            .then(callback);
    });

    this.Then(/^I can click on the "([^"]*)" button$/, function(buttonText, callback) {
        var button = element(by.buttonText(buttonText));
        button.click()
            .then(function () { browser.sleep(1); })
            .then(callback);
    });

    this.Then(/^I wait for "(.\d*?)" seconds$/, function (time, callback) {
        browser.sleep(time * 1000).then(callback)
    });
};
