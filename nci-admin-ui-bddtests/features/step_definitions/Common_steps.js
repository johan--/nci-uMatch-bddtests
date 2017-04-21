'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
    this.World = require('../step_definitions/world').World;

//Given

    this.Given(/^I click on "([^"]*)"$/, function (arg1, callback) {
         // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

//When

    this.When(/^I click on "(.+?)" button$/, function(buttonName, callback){
        var buttonElement = returnButtonElement[buttonName]
        buttonElement.click().then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I wait for "(\d*)" seconds$/, function (seconds, callback){
        browser.sleep(seconds *1000).then(callback);
    })

    this.When(/^I navigate to "(.+?)" page$/, function(page, callback){
        var pageName = page === 'Log' ? 'logger' : page.toLowerCase();
        browser.get('/#/app/' + pageName, 3000).then(function(){
            browser.waitForAngular();
        }).then(callback);
    });


//Then

    this.Then(/^I see that the "([^"]*)" button is "(disabled|enabled|visible|invisible)"$/, function (button, buttonState, callback) {
        var buttonElement = returnButtonElement[button]
        var isVisible = buttonState === 'enabled' || buttonState === 'disabled';
        var isAvailable = buttonState === 'enabled' || buttonState === 'visible';

        // protractr methods isEnabled() works only on input and a few other elements.
        // span, anchor tags fail isEnabled and gives the wrong value back
        if (isVisible){
            buttonElement.getAttribute('disabled').then(function (status){
                var enabled
                if ( status === null ) {
                    enabled = true
                } else {
                    enabled = !status
                }
                expect(enabled).to.eql(isAvailable)
            }).then(callback);
        } else {
            expect(buttonElement.isPresent()).to.eventually.eql(isAvailable).notify(callback);
        }
    });
    this.Then(/^I am taken to the "([^"]*)" page$/, function (page, callback) {
        var pageName = page === 'Log' ? 'logger' : page.toLowerCase();
        var expected = process.env.ADMIN_UI_HOSTNAME + '/#!/app/' + pageName
        expect(browser.getCurrentUrl()).to.eventually.eql(expected).notify(callback);
    });




    // This is a collection of all the buttons in the applcation to be used to check the disabled, enabled feature.
    var returnButtonElement = {
        "Upload a file": upload.chooseFileButton,
        "Upload File": upload.uploadFileButton,
        "Confirm upload to Treatment Arm": upload.confirmUploadButton
    }


}
