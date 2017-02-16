var utilities = require('../support/utilities');

var UploaderPage = function() {
	this.uploadHeading = element(by.css('h6.before-themeprimary'));
	this.checkStatusHeading = element(by.css('h6.before-themesecondary'));

	this.chooseAFileButton = element(by.css('div.qq-upload-button-selector>input[title="file input"]'));
}

module.exports = new UploaderPage();