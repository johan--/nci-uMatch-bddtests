'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    var data_folder = 'data_files'

    this.Given(/^I select "([^"]*)" file for upload$/, function (fileName, callback) {
        var fileToUpload = `${data_folder}/${fileName}.xlsx`;
        var absolutePath = path.resolve(fileToUpload);
        var inputElement = upload.chooseFileButton
        
        inputElement.sendKeys(absolutePath).then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I expect to see the file "([^"]*)" in the upload section$/, function (fileName, callback) {
        expect(upload.uploadPanel.getAttribute('title')).to.eventually.eql(`${fileName}.xlsx`).notify(callback);
    });

    this.Then(/^I expect to see the "Upload File" button is (active|disabled)$/, function (buttonName, active, callback) {
        callback(null, 'pending');
        
    });

    this.When(/^I click on "(.+?)" button$/, function(buttonName, callback){
        upload.uploadFileButton.click().then(function(){
            browser.waitForAngular();
        }).then(callback);
    });


    this.Given(/^I click on "([^"]*)" label on Upload section$/, function (arg1, callback) {   
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I enter "([^"]*)" in the input$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^The files are uploaded to the temporary table$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.When(/^I click on the "([^"]*)" button on the Status section$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^I am taken to the "([^"]*)" page$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^I verify that there is\/are "([^"]*)" treatment arm\(s\) in the list$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^I collect the treatment arm details on row "([^"]*)"$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^I hit the "([^"]*)" button next to treatment arm on row "([^"]*)"$/, function (arg1, arg2, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^I call the Treatment Arm Api to verify the presence of the treatment arm$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^the files are uploaded to the temporary table$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });


    this.Then(/^I expect to see the file "([^"]*)" on S3 bucket$/, function (arg1, callback) {
             // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });
}
