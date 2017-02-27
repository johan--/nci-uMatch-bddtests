'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
	this.World = require('../step_definitions/world').World;
	this.Then(/^I can see the dashboard$/, function (callback) {
		browser.waitForAngular().then(function(){
			expect(browser.isElementPresent(upload.uploadHeading)).to.eventually.eql(true);
		}).then(callback);
	});	

	this.Then(/^I can see that the upload section is active$/, function (callback) {
        var testElement = upload.uploaderLink.element(by.xpath('../..'));
        utilities.checkElementIncludesAttribute(testElement, 'class', 'active').then(callback);
	});

	this.Then(/^I can see the TA upload section$/, function (callback) {
		expect(upload.uploadSection.isPresent()).to.eventually.eql(true).notify(callback);
	});

	this.Then(/^I can see the top level menu buttons$/, function (callback) {
		expect(upload.uploaderLink.getText()).to.eventually.eql('Uploader');
        expect(upload.wizardLink.getText()).to.eventually.eql('Wizard');
        expect(upload.editorLink.getText()).to.eventually.eql('Editor');
        expect(upload.confirmationLink.getText()).to.eventually.eql('Confirmation');
        expect(upload.logLink.getText()).to.eventually.eql('Log').notify(callback);
    });

}
