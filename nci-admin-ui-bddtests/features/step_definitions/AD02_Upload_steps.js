'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var confirmation = require('../../pages/confirmationPage');
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

    this.When(/^I delete the file from the S3 bucket$/, function (callback) {
        var bucketName = browser.baseUrl.match('localhost') ? 'pedmatch-admintool-dev' : 'pedmatch-admintool-int'
        s3.deleteFileFromBucket(bucketName, upload.fileNameUploaded).then(callback);
    });

    this.When(/^I confirm the upload of the treatment arm$/, function(callback){
        // console.log("upload.indexOfElement: " + upload.indexOfElement);
        callback(null, 'pending');
    })

// Then
    this.Then(/^I expect to see the file "([^"]*)" on S3 bucket$/, function (fileName, callback) {
        var bucketName = browser.baseUrl.match('localhost') ? 'pedmatch-admintool-dev' : 'pedmatch-admintool-int'
        s3.isFilePresent(bucketName, fileName).then(function(result){
            upload.fileNameUploaded = result["Key"];
            expect(upload.fileNameUploaded).to.include(upload.fileName);
        }).then(callback);
    });

    this.Then(/^I expect to see the treatment arm "(.+?)" uploaded to the temporary table$/, function(taId, callback){
        dynamo.checkForRecord(taId, 'treatment_arm_pending').then(function(record){
            console.log(record);
            expect(record['Items'][0]['treatment_arm_id']['S']).to.eql(ta1);
        }).then(callback);
    });

    this.Then(/^The treatment arms are not uploaded to the temporary table$/, function (callback) {
        dynamo.checkForRecord(upload.treatmentArmId, 'treatment_arm_pending').then(function(record){
            expect(record['Count']).to.eql(0)
        }).then(callback);
    });


    this.Then(/^I expect to see the file "([^"]*)" in the upload section$/, function (fileName, callback) {
        expect(upload.uploadPanel.getAttribute('title')).to.eventually.eql(`${fileName}`).notify(callback);
    });

    this.Then(/^I verify that there is "([^"]*)" treatment arm in the list$/, function (taId, callback) {
        expect(confirmation.treatmentArmsIdList.getText()).to.eventually.include(taId).notify(callback);
    });

    this.Then(/^I collect the treatment arm details for "([^"]*)" on the page$/, function (taId, callback) {
        utilities.getIndexOfElement(confirmation.treatmentArmsIdList, taId).then(function(index){
            console.log('index of element: ' + index);
            upload.indexOfElement = index;
        }).then(callback);
    });

    this.Then(/^I hit the "([^"]*)" button next to treatment arm$/, function (buttonName, callback) {
        var elem = confirmation.taConfirmButtonList;
        console.log('upload.indexOfElement: ' + upload.indexOfElement);
        elem.get(upload.indexOfElement).click().then(function(){
            browser.sleep(50);
        }).then(callback);
    });

    this.Then(/^I call the Treatment Arm Api to verify the presence of the treatment arm "([^"]*)" and stratum "([^"]*)"$/, function (taId, stratumId, callback) {
        var baseUrl = browser.baseUrl;
        var base
        if (baseUrl.match('localhost')){
            base = baseUrl.substring(0, baseUrl.length - 4) + "10235";
        } else {
            base = process.env.UI_HOSTNAME
        };

        utilities.getTAsFromTreatmentArm(browser.idToken, base + `/api/v1/treatment_arms/${taId}/${stratumId}/` ).then(function(response){
            expect(response[0].treatment_arm_id).to.eql(taId);
        }).then(callback);
    });

    this.Then(/^I get the authorization token$/, function(callback){
        utilities.getIdToken().then(function(response){
            browser.idToken = response;
            console.log('browser.idToken: ' + browser.idToken);
        }).then(callback)
    });

    this.Then(/^the files are uploaded to the temporary table$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });
}
