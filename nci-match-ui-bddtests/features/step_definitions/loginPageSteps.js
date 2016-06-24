/**
 * Created by raseel.mohamed on 6/3/16
 */

'use strict';
var fs = require('fs');

var loginPageObj = require ('../../pages/loginPage');
var dashboardPageObj = require ('../../pages/dashboardPage');
// Helper Methods
var utilities = require ('../../support/utilities');


module.exports = function () {

    this.World = require ('../step_definitions/world').World;

    this.Given(/^I am on the login page$/, function(callback){
        loginPageObj.goToLoginPage();
        utilities.checkTitle(browser, loginPageObj.title);

        browser.sleep(50).then(callback);
    });

    this.Given(/^I am a logged in user$/, function(callback) {
        loginPageObj.goToLoginPage();

        var email = process.env.NCI_MATCH_USERID;
        var password = process.env.NCI_MATCH_PASSWORD;

        loginPageObj.login(email, password);
        
        utilities.waitForElement(dashboardPageObj.logoutLink, 'Logout link')

        browser.sleep(1000).then(callback);
    });
    
    this.When(/^I login with (valid|invalid) email and password/, function(validity, callback){
        var email;
        var password = process.env.NCI_MATCH_PASSWORD;
        
        if (validity == 'valid'){
            email = process.env.NCI_MATCH_USERID;
        } else {
            email = 'abc_xyz@nih.gov';
        }

        loginPageObj.login(email, password);

        browser.sleep(2000).then(callback);
    });

    this.When(/^I navigate to the (.+) page$/, function (pageName, callback) {
        dashboardPageObj.goToPageName(pageName);

        browser.sleep(50).then(callback);
    });

    this.Then(/^I should be able to the see Dashboard page$/, function (callback){
        var logoutLink = element(by.linkText('Log out'));
        utilities.waitForElement(dashboardPageObj.logoutLink, 'Logout Link');
        browser.sleep(5).then(function(){
            utilities.checkTitle(browser, dashboardPageObj.title).then(function () {

            });  //Checking for the title.
            dashboardPageObj.name().get(0).getText().then(function (text) {
                console.log(text);
            });

        } );

        browser.sleep(50).then(callback);
    });

    this.Then(/^I then logout$/, function (callback) {
        dashboardPageObj.logout();
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should be asked to enter the credentials again$/, function (callback) {
        var errorPanel = element(by.css('#a0-onestep.a0-errors'));

        utilities.waitForElement(errorPanel, 'Retry Login Window')
        utilities.checkPresence('.a0-top-header>.a0-error');
        browser.sleep(50).then(callback);
    });

    this.Then(/^I am redirected back to the login page$/, function (callback) {
        expect(browser.getCurrentUrl()).to.eventually.have.string('/#/auth/login');
        browser.sleep(50).then(callback);
    });
};
