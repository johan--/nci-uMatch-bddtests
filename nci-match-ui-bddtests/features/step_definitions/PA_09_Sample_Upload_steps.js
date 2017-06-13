/**
 * Created by Raseel Mohamed on Jan 31 2017
 */

'use strict';
var fs = require("fs");
var path = require("path");
var AWS = require ("aws-sdk");

var patientPage = require("../../pages/patientPage");

var utilities = require("../../support/utilities");

module.exports = function () {
    var templateFolder = '../DataSetup/variant_file_templates/templates_for_ui/'

    this.World = require('../step_definitions/world').World;

    this.When(/^I can see that some files have not been uploaded for the Surgical Event$/, function (callback) {
        // Here we are searching for no files at all attached to the specimen
        var analysisSection = patientPage.variantAndAssignmentPanel;
        expect(analysisSection.count()).to.eventually.eql(0).notify(callback);
    });

    this.Then(/^I can see the "([^"]*)" dialog$/, function (heading, callback) {
        var uploadDialog = patientPage.modalWindow.element(by.css('form[name=uploadForm] h3'));
        expect(uploadDialog.getText()).to.eventually.eql(heading).notify(callback);
    });

    this.Then(/^I select an Ion Reporter "([^"]*)"$/, function (ionReporter, callback) {
        var cssSelector = 'li[ng-repeat="item in ionReporters"] a';
        patientPage.selectSiteAndIRID.click().then(function () {
            utilities.selectFromDropDown(cssSelector, ionReporter);
        }).then(callback);
    });

    this.Then(/^I enter Analysis ID "([^"]*)"$/, function (analysisId, callback) {
        patientPage.upldDialogAnalysisId.clear();
        patientPage.upldDialogAnalysisId.sendKeys(analysisId);
        expect(patientPage.upldDialogAnalysisId.getAttribute('value')).to.eventually.eql(analysisId).notify(callback);
    });

    this.When(/^I make all elements visible$/, function(next){
        browser.executeAsyncScript(function(callback) {
            document.querySelectorAll('#vcfFile')[0]
                .style.display = 'inline';
            callback();
        }).then(function(callback){
            browser.executeAsyncScript(function(callback) {
                document.querySelectorAll('#dnaFile')[0]
                    .style.display = 'inline';
                callback();
            })
        }).then(function(callback){
            browser.executeAsyncScript(function(callback) {
                document.querySelectorAll('#rnaFile')[0]
                    .style.display = 'inline';
                callback();
            })
        }).then(next);

    })

    this.Then(/^I press "(.+?)" file button to upload "([^"]*)" file$/, function (buttonName, fileName, callback) {
        var buttonType = patientPage.uploadButtonsId[buttonName]
        var pathToFile = templateFolder + fileName;
        var absolutePath = path.resolve(pathToFile);

        element(by.css('input#' + buttonType + '[type="file"]')).sendKeys(absolutePath).then(function(){
            browser.sleep(2000);
        }).then(callback);
    });

    this.Then(/^I can only see "([^"]*)" type user$/, function(siteName, callback){
        var dropdownList = patientPage.selectSiteDropDownList
        dropdownList.getText().then(function(arrList){
            // console.log(arrList);
            for (var i = 1; i < arrList.length; i++) {  //starting from the second element onwards. The first is the buttonName
                expect(arrList[i]).to.include(siteName);
            }
        }).then(callback);
    });

    this.Then(/^I can see the "(.+?)" Sample File upload process has started$/, function (number, callback) {
        patientPage.downloadTracker.getLocation().then(function(location){
            browser.executeScript('window.scrollTo(' + location.x + ', ' + (location.y - 10) + ')').then(function(){
                expect(patientPage.downloadTracker.getText()).to.eventually.eql(number.toString())
            }).then(function () {
                browser.sleep(45000);
            });
        }).then(callback);
    });


    this.Then(/^I see the downloads in the timeline$/, function (callback) {
        var timeline = patientPage.timelineList;

        timeline.get(0).element(by.css('.timeline-title')).getText().then(function (firstMessage){
            if (firstMessage.includes('Sequence file uploaded')) {
                utilities.checkExpectation(timeline.get(1).element(by.css('.timeline-title')), '')
                timeline.get(1).element(by.css('.timeline-title')).getText().then(function (tst){
                    expect(tst).to.includes('Sequence file uploaded')
                });
                timeline.get(2).element(by.css('.timeline-title')).getText().then(function (tst){
                    expect(tst).to.includes('VCF file uploaded')
                });
            } else if (firstMessage.includes('TISSUE Variant Report received.')){
                expect(timeline.get(1).element(by.css('.timeline-title')).getText())
                    .to.eventually.includes('Sequence file uploaded');
                expect(timeline.get(2).element(by.css('.timeline-title')).getText())
                    .to.eventually.includes('Sequence file uploaded');
                expect(timeline.get(3).element(by.css('.timeline-title')).getText())
                    .to.eventually.includes('VCF file uploaded')
            }
        }).then(callback);
    });

    this.Then(/^I click on the Upload Progress in the toolbar$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
       });

    this.Then(/^I can see current uploads$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I can cancel the first upload in the list$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^The cancelled file is removed from the upload list$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I clear the file from S3 under reporter "([^"]*)", mol_id "([^"]*)", analysis_id "([^"]*)"$/, function(reporter, molecularId, analysisId, callback){
        var bucketName = process.env.UI_HOSTNAME.match('localhost') ? 'pedmatch-dev' : 'pedmatch-int'
        var folderName = reporter + '/' + molecularId + '/' + analysisId;
        patientPage.analysisId = analysisId;
        patientPage.molecularId = molecularId;

        console.log('Bucket Name: ' + bucketName );
        console.log('Folder Name: ' + folderName );

        var S3 = new AWS.S3({
            region: 'us-east-1',
            endpoint: 'https://s3.amazonaws.com',
            accessKeyId: process.env.AWS_ACCESS_KEY_ID,
            secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
            apiVersion: 'latest'
        });

        var params = {
            Bucket: bucketName, /* required */
            Delete: {
                Objects: [
                    {
                        Key: folderName + '/vcf_sample.zip'
                    },
                    {
                        Key: folderName + '/dna_sample.bam'
                    },
                    {
                        Key: folderName + '/rna_sample.bam'
                    },
                    {
                        Key: folderName + '/vcf_sample.vcf'
                    },
                    {
                        Key: folderName + '/vcf_sample.tsv'
                    },
                    {
                        Key: folderName + '/rna_sample.bai'
                    },
                    {
                        Key: folderName + '/dna_sample.bai'
                    },
                    {
                        Key: folderName + '/cdna_sample.bam'
                    },
                    {
                        Key: folderName + '/cdna_sample.bai'
                    }
                ]
            }
        };

        var deletePromise = S3.deleteObjects(params).promise();

        deletePromise.then(function(data){
            console.log("Deleting files in S3");
            return;
        }).catch(function(err){
            console.log(err);
            return;
        }).then(callback);
    })
};
