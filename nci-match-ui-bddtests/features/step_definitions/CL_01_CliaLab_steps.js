/**
 * Created by raseel.mohamed on 11/9/16
 */

'use strict'
var fs = require('fs');

var utilities = require ('../../support/utilities');
var dash      = require ('../../pages/dashboardPage');
var clia      = require ('../../pages/CLIAPage');
var nodeCmd   = require ('node-cmd');
module.exports = function() {
    this.World = require ('../step_definitions/world').World;

    var tabNameMap = {
        'MoCha' : {
            'Positive Sample Controls': {
                'element': clia.mochaPositiveGrid,
                'control_type': 'positive'
            },
            'No Template Control': {
                'element': clia.mochaNoTemplateGrid,
                'control_type': 'no_template'
            },
            'Proficiency And Competency' : {
                'element': clia.mochaProficiencyGrid,
                'control_type': 'proficiency_competency'
            }
        },
        'MD Anderson' : {
            'Positive Sample Controls': {
                'element': clia.mdaPositiveGrid,
                'control_type': 'positive'
            },
            'No Template Control': {
                'element': clia.mdaNoTemplateGrid,
                'control_type': 'no_template'
            },
            'Proficiency And Competency' : {
                'element': clia.mdaProficiencyGrid,
                'control_type': 'proficiency_competency'
            }
        }
    };

    var controlType;


    this.Then(/^I can see the Clia Labs page$/, function (callback) {
        expect(browser.getTitle()).to.eventually.eql(clia.pageTitle);
        expect(browser.getCurrentUrl()).to.eventually.include('/#/clia-labs');
        expect(clia.mochaSectionButton.getText()).to.eventually.eql('MoCha');
        expect(clia.mdaSectionButton.getText()).to.eventually.eql('MoCha').notify(callback);
    });

    this.When(/^I click on the "(MoCha|MD Anderson)" section$/, function (sectionName, callback) {
        var elem = sectionName === 'MoCha' ? clia.mochaSectionButton : clia.mdaSectionButton;
        elem.click().then(function() {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I am on the "(MoCha|MD Anderson)" section$/, function (sectionName, callback) {
        var url = sectionName === 'MoCha' ? 'MoCha' : 'MDACC';
        expect(browser.getCurrentUrl()).to.eventually
            .include('clia-labs?site=' + url + '&type=positive')
            .notify(callback);
    });

    this.When(/^I click on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var elem = element(by.css('li[heading="' + subTabName + '"]'))

        // Setting the Control type here in anticipation of future needs.
        controlType = tabNameMap[sectionName][subTabName]['control_type'];
        clia.tableElement = tabNameMap[sectionName][subTabName];

        elem.click().then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I collect information on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + controlType;
        var request = utilities.callApi('ion', url);
        request.get().then(function() {
             clia.responseData =JSON.parse(request.entity());
        }).then(callback);
    });

    this.When(/^I collect new information on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + controlType;
        var request = utilities.callApi('ion', url);
        request.get().then(function() {
            clia.newResponseData =JSON.parse(request.entity());
        }).then(callback);
    });

    this.When(/^I click on Generate MSN button$/, function (callback) {
        var generateMSNProperty = element(by.css('form[ng-submit="generateMsn(\'' + controlType + '\')"]>input'));
        utilities.waitForElement(generateMSNProperty, 'Generate MSN button');
        generateMSNProperty.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I verify that "([^"]*)" under "(MoCha|MD Anderson)" is active$/, function (subTabName, sectionName, callback) {
         var elemToCheck = tabNameMap[sectionName][subTabName]['element'];
         expect(elemToCheck.isPresent()).to.eventually.eql(true).notify(callback);
    });

    this.Then(/^I verify the headings for "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var tableElement = tabNameMap[sectionName][subTabName]['element'];
        var headings = tableElement.all(by.css('table>thead>tr>th'))

        expect(headings.getText()).to.eventually.eql(clia.expectedMsnTableHeading).notify(callback);
    });

    this.Then(/^I verify that the data retrieved is present for "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Then(/^a new Molecular Id is created under the "(MoCha|MD Anderson)"$/, function (sectionName, callback) {
        expect(clia.newResponseData.length).to.eql(clia.responseData.length + 1);
        browser.sleep(20).then(callback);
    });

    this.When(/^I upload variant report to S3 with the generated MSN$/, function (callback) {
        clia.bucketName = browser.baseUrl.match('localhost') ? 'pedmatch-dev' : 'pedmatch-int';
        clia.molecularId = clia.newMSNObject['molecular_id'];
        clia.analysisId = clia.molecularId + '_ANI';
        clia.S3Path = clia.molecularId + '/' + clia.analysisId;

        browser.sleep(50).then(function () {
            nodeCmd.get(
                `cd ../DataSetup/variant_file_templates 
                mkdir -p ${clia.S3Path} 
                cp -r ir_template/* ${clia.S3Path}
                aws s3 cp ${clia.molecularId}  s3://${clia.bucketName}/IR_UITEST/${clia.molecularId} --recursive --region us-east-1 `
                ,
                function(data){
                    console.log(data);
                    console.log('Copied data from ' + clia.molecularId + 'to S3 with bucket name' + clia.bucketName);
                }
            )
        }).then(callback);
    });

    this.When(/^I delete the variant reports uploaded to S3$/, function(callback){
       browser.sleep(50).then(function () {
           nodeCmd.get(
               `aws s3 rm ${clia.molecularId}  s3://${clia.bucketName}/IR_UITEST/${clia.molecularId} --recursive --region us-east-1 `
               ,
               function (data) {
                   console.log(data);
               }
           )
       }).then(callback)
    });

    this.When(/^I call the aliquot service with the generated MSN$/, function(callback){
        var path = 'IR_UITEST/' + clia.S3Path;
        var data = 	{
            "analysis_id": clia.analysisId,
            "site": "mocha",
            "ion_reporter_id": "IR_UITEST",
            "vcf_name": path + '/test1.vcf',
            "dna_bam_name": path + '/dna.bam',
            "cdna_bam_name": path + '/cdna.bam'
        };

        console.log(data);
        browser.sleep(50).then(function () {
            utilities.putApi('ion', '/api/v1/aliquot/' + clia.molecularId, data)
        }).then(callback)
    });

    this.Then(/^I see variant report details for the generated MSN$/, function (callback) {
        //Entering the new MSN generated in to the search field
        clia.tableElement['element'].element(by.css('input')).sendKeys(clia.molecularId);
        browser.waitForAngular().then(function () {
            var firstRow = element.all(by.css('[ng-repeat^="item in filtered"]')).get(0)
            expect(firstRow.all(by.binding('item.molecular_id')).get(0).getText()).to.eventually.eql(clia.molecularId);
            expect(firstRow.all(by.css('a')).get(0).isPresent()).to.eventually.eql(true);
            expect(firstRow.all(by.css('a')).get(0).getText()).to.eventually.eql(clia.molecularId);
        }).then(callback)
    });

    this.When(/^I capture the new MSN created$/, function (callback) {
        var oldMolecularIds = [];
        var newMolecularIds = [];
        for (var i = 0; i < clia.responseData.length; i++) {
            oldMolecularIds.push(clia.responseData[i]["molecular_id"]);
        }
        for (var i = 0; i < clia.newResponseData.length; i++) {
            newMolecularIds.push(clia.newResponseData[i]["molecular_id"]);
        }
        clia.newMSNObject = clia.newResponseData.filter(function (item) {
            return oldMolecularIds.indexOf(item["molecular_id"]) < 0;
        })[0];

        console.log(clia.newMSNObject);
        browser.sleep(50).then(callback);
    });
};
