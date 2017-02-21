'use strict'
var utilities = require('../support/utilities');

var UploaderPage = function(){
	this.uploadHeading = element(by.css('h6.before-themeprimary'));
	this.checkStatusHeading = element(by.css('h6.before-themesecondary'));

	this.chooseAFileButton = element(by.css('div.qq-upload-button-selector>input[title="file input"]'));

    this.uploaderLink       = element(by.css('span[href="#/app/uploader"]'));
    this.wizardLink         = element(by.css('span[href="#/app/wizard"]'));
    this.editorLink         = element(by.css('span[href="#/app/editor"]'));
    this.confirmationLink   = element(by.css('span[href="#/app/confirmation"]'));
    this.logLink            = element(by.css('span[href="#/app/logger"'));


    this.uploadSection      = element(by.css('div.bordered-themeprimary+div[class="widget-body"] #uploader'));
    

};

module.exports = UploaderPage;
