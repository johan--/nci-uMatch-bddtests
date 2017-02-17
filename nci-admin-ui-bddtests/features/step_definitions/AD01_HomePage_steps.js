'use strict'

var login = require('../../pages/loginPage');
var uploader = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
	this.World = require('../step_definitions/world').World;
	
	this.Then(/^I can see the dashboard$/, function (callback) {
		browser.sleep(5000).then(function(){	
			expect(browser.isElementPresent(uploader.uploadHeading)).to.eventually.eql(true);
		}).then(callback);
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