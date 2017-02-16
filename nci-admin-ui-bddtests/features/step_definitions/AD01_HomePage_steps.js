'use strict'

var login = require('../../pages/loginPage');
var uploader = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
	this.World = require('../step_definitions/world').World;
	
	this.Given(/^I am a logged in user$/, function (callback) {
		var email = process.env.ADMIN_UI_AUTH0_USERNAME;
		var password = process.env.ADMIN_UI_AUTH0_PASSWORD;
        browser.sleep(50).then(function() {
        	login.goToLogin().then(function(){
        		login.loginProcess(email, password);	
        	});
        	
        }).then(callback);
    });

	this.Then(/^I can see the dashboard$/, function (callback) {
		expect(uploader.uploadHeading.isPresent()).to.eventually.eql(true).notify(callback);
	});	

	this.Then(/^I can see that the upload section is active$/, function (callback) {
		// Write code here that turns the phrase above into concrete actions
		callback(null, 'pending');
	});

	this.Then(/^I can see the TA upload section$/, function (callback) {
		// Write code here that turns the phrase above into concrete actions
		callback(null, 'pending');
	});

	this.Then(/^I can see the upload status section$/, function (callback) {
		// Write code here that turns the phrase above into concrete actions
		callback(null, 'pending');
	});

	this.Then(/^I can see the top level menu buttons$/, function (callback) {
		// Write code here that turns the phrase above into concrete actions
		callback(null, 'pending');
	});
}