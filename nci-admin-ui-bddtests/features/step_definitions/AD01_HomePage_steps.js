'use strict'
var fs = require('fs');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
    var uploader = new upload();
	this.World = require('../step_definitions/world').World;
	this.Then(/^I can see the dashboard$/, function (callback) {
		browser.waitForAngular().then(function(){
			expect(browser.isElementPresent(uploader.uploadHeading)).to.eventually.eql(true);
		}).then(callback);
	});	

	this.Then(/^I can see that the upload section is active$/, function (callback) {
        var testElement = uploader.uploaderLink.element(by.xpath('../..'));
        utilities.checkElementIncludesAttribute(testElement, 'class', 'active').then(callback);
	});

	this.Then(/^I can see the TA upload section$/, function (callback) {
		expect(uploader.uploadSection.isPresent()).to.eventually.eql(true).notify(callback);
	});

	this.Then(/^I can see the top level menu buttons$/, function (callback) {
		expect(element(by.css('span[href="#/app/uploader"]')).getText()).to.eventually.eql('Uploader');
        expect(element(by.css('span[href="#/app/wizard"]')).getText()).to.eventually.eql('Wizard');
        expect(element(by.css('span[href="#/app/editor"]')).getText()).to.eventually.eql('Editor');
        expect(element(by.css('span[href="#/app/confirmation"]')).getText()).to.eventually.eql('Confirmation');
        expect(element(by.css('span[href="#/app/logger"')).getText()).to.eventually.eql('logLink').notify(callback);
    });

}
