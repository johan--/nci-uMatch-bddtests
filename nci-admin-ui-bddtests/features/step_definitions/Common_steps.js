'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    this.When(/^I navigate to "(.+?)" page$/, function(page, callback){
        var pageName = page === 'Log' ? 'logger' : page.toLowerCase();
        browser.get('/#/app/' + pageName, 3000).then(callback);
    });

    this.Then(/^I see that the "([^"]*)" button is "([^"]*)"$/, function (arg1, arg2, callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

       this.Then(/^I see that the "([^"]*)" link is "([^"]*)"$/, function (arg1, arg2, callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
       });    

}
