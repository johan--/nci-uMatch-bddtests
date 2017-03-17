'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var utilities = require('../../support/utilities');
var s3 = require('../../support/S3_helper');
var dynamo = require('../../support/dynamo_helper')

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    var data_folder = 'data_files';
//Given
    this.Given(/^I select "([^"]*)" file for upload$/, function (fileName, callback) {
        upload.fileName = fileName;
        var fileToUpload = `${data_folder}/${fileName}`; // Enter the extension in the feature. 
        var absolutePath = path.resolve(fileToUpload);
        var inputElement = upload.chooseFileButton
        
        inputElement.sendKeys(absolutePath).then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.Given(/^I click on "([^"]*)" label on Upload section$/, function (uploadButtonName, callback) {  
        if (uploadButtonName === 'Select Specific Treatment Arms'){
            upload.selectSpecificTA.click().then(function(){
                expect(upload.selectSpecificTAInput.isPresent()).to.eventually.eql(true)
            }).then(callback);
        } else if (uploadButtonName === 'Select All Treatment Arms'){
            upload.selectAllTA.click().then(function(){
                browser.waitForAngular();
            }).then(callback)
        }
    });

    this.Given(/^I enter "([^"]*)" in the input$/, function (ta_name, callback) {
        upload.treatmentArmId = ta_name;
        upload.selectSpecificTAInput.sendKeys(ta_name).then(callback);
    });

//When
    
    this.When(/^I delete the file from the S3 bucket "([^"]*)"$/, function (bucketName, callback) {
        var fileName = upload.fileNameUploaded;
        s3.deleteFileFromBucket(bucketName, fileName).then(callback);     
    });

// Then
    this.Then(/^I expect to see the file "([^"]*)" on S3 bucket "([^"]*)"$/, function (fileName, bucketName, callback) {
        s3.isFilePresent(bucketName, fileName).then(function(result){
            upload.fileNameUploaded = result["Key"];
            expect(upload.fileNameUploaded).to.include(upload.fileName);    
        }).then(callback);
    });


    this.Then(/^The treatment arms are uploaded to the temporary table$/, function (callback) {
        dynamo.checkForRecord(upload.treatmentArmId, 'treatment_arm_pending').then(function(record){

            console.log('record: ' + record[Items]);
            expect(record[Items].length).to.be.greaterThan(0)
            expect(record[Items].first['treatment_arm_id']).to.eql(upload.treatmentArmId)
        }).then(callback);
    });


    this.Then(/^I expect to see the file "([^"]*)" in the upload section$/, function (fileName, callback) {
        expect(upload.uploadPanel.getAttribute('title')).to.eventually.eql(`${fileName}`).notify(callback);
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
}
