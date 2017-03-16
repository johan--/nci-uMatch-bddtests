'use strict'
var utilities = require('../support/utilities');

var UploaderPage = function(){
	this.uploadHeading = element(by.css('h6.before-themeprimary'));
	this.checkStatusHeading = element(by.css('h6.before-themesecondary'));

    this.uploaderLink       = element(by.css('span[href="#!/app/uploader"]'));
    this.wizardLink         = element(by.css('span[href="#!/app/wizard"]'));
    this.editorLink         = element(by.css('span[href="#!/app/editor"]'));
    this.confirmationLink   = element(by.css('span[href="#!/app/confirmation"]'));
    this.logLink            = element(by.css('span[href="#!/app/logger"'));

    this.chooseFileButton    = element(by.css('input[type="file"]'));
    this.uploadPanel        = element(by.css('span.qq-upload-file-selector'));

    this.uploadSection      = element(by.css('div.bordered-themeprimary+div[class="widget-body"] #uploader'));

    this.selectSpecificTA   = element(by.cssContainingText('label[ng-model="chosen_upload_type"]', 'Select Specific Treatment Arms'));
    this.selectAllTA        = element(by.cssContainingText('label[ng-model="chosen_upload_type"]', 'Select All Treatment Arms'));
    this.selectSpecificTAInput  = element(by.css('.panel-collapse.in.collapse input[id="form_input"]')); // This is the input window to enter the name of the specific TA
    this.uploadFileButton       = element(by.css('input[value="Upload File"]'));

    this.confirmUploadButton = element(by.cssContainingText('a.btn-active', 'Confirm upload to Treatment Arm'));
    

};

module.exports = new UploaderPage();
