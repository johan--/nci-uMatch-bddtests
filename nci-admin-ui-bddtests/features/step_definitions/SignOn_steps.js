/**
 * Created by raseel.mohamed on 6/3/16
 */

'use strict';
var fs = require('fs');

var login = require('../../pages/loginPage');
var utilities = require('../../support/utilities.js');

module.exports = function () {

    this.World = require('../step_definitions/world').World;

    this.Given(/^I am on the login page$/, function(callback){
        loginPage.goToLogin().then(function(){
            expect(browser.getCurrentUrl()).to.eventually.include('/#/login');
        }).then(callback);
    });


    this.When(/^I login with "((in)?valid)" email and password$/, function (validity, callback) {
        var email = validity === 'valid' ? process.env.ADMIN_UI_AUTH0_USERNAME : 'abc@xyz.com';
        var password = process.env.ADMIN_UI_AUTH0_PASSWORD

        loginPage.loginProcess(email, password);
        browser.sleep(50).then(callback);
    });

    this.Given(/^I am a logged in user$/, function (callback) {
        var email = process.env.ADMIN_UI_AUTH0_USERNAME;
        var password = process.env.ADMIN_UI_AUTH0_PASSWORD;
        browser.sleep(50).then(function() {
            login.goToLogin().then(function(){
                login.loginProcess(email, password);
            }).then(function(){
                browser.sleep(5000);
            }).then(function(){
                utilities.checkTitle(browser, 'MATCHBox | Admin Tool')
            })
        }).then(callback);
    });

    this.When(/^I logout$/, function(callback){
        var toasterElement = element(by.css('[ng-click="click(toaster)"]'));
        toasterElement.isPresent().then(function (presence) {
            if (presence === true ) {
                toasterElement.click().then(function () {
                    login.logout().then(function () {
                        browser.waitForAngular();
                    });
                }).then(callback);
            } else {
                login.logout().then(function () {
                    browser.waitForAngular();
                });

            }
        }).then(callback);
    });
};
