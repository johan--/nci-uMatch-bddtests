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

    this.Then(/^I see that the "([^"]*)" button is "(disabled|enabled|visible|invisible)"$/, function (button, buttonState, callback) {
        var buttonElement = returnButtonElement[button]
        var isVisible = buttonState === 'enabled' || buttonState === 'disabled';
        var isAvailable = buttonState === 'enabled' || buttonState === 'visible';

        if (isVisible){
            expect(buttonElement.isEnabled()).to.eventually.eql(isAvailable).notify(callback);
        } else {
            expect(buttonElement.isPresent()).to.eventually.eql(isAvailable).notify(callback);
        }
         
    });



    // This is a collection of all the buttons in the applcation to be used to check the disabled, enabled feature. 
    var returnButtonElement = {
        "Choose a file": upload.chooseFileButton,
        "Upload File": upload.uploadFileButton,
        "Confirm upload to Treatment Arm": upload.confirmUploadButton 
    }
        

}
