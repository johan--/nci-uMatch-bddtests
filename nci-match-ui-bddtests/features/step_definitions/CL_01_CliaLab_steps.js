/**
 * Created by raseel.mohamed on 11/9/16
 */

'use strict'
var fs = require('fs');

var utilities = require ('../../support/utilities');
var dash      = require ('../../pages/dashboardPage');
var clia      = require ('../../pages/CLIAPage');

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
                'control_type': 'postive'
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

    this.When(/^I click on the "(MoCha|MD Andersson)" section$/, function (sectionName, callback) {
        var elem = sectionName === 'MoCha' ? clia.mochaSectionButton : clia.mdaSectionButton;
        elem.click().then(function() {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I am on the "(MoCha|MD Andersson)" section$/, function (sectionName, callback) {
        var url = sectionName === 'MoCha' ? 'MoCha' : 'MDACC';
        expect(browser.getCurrentUrl()).to.eventually
            .include('clia-labs?site=' + url + '&type=positive')
            .notify(callback);
    });

    this.When(/^I click on "([^"]*)" under "(MoCha|MD Andersson)"$/, function (subTabName, sectionName, callback) {
        var elem = element(by.css('li[heading="' + subTabName + '"]'))

        // Setting the Control type here in anticipation of future needs.
        controlType = tabNameMap[sectionName][subTabName]['control_type'];

        elem.click().then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I collect information on "([^"]*)" under "(MoCha|MD Andersson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + controlType;
        var request = utilities.callApi('ion', url);
        request.get().then(function() {
             clia.responseData =JSON.parse(request.entity());
        }).then(callback);
    });

    this.When(/^I collect new information on "([^"]*)" under "(MoCha|MD Andersson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + controlType;
        var request = utilities.callApi('ion', url);
        request.get().then(function() {
            clia.newResponseData =JSON.parse(request.entity());
        }).then(callback);
    });

    this.When(/^I click on Generate MSN button$/, function (callback) {
        var generateMSNProperty = element(by.css('form[ng-submit="generateMsn(\'' + controlType + '\')"]>input'));

        generateMSNProperty .click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I verify that "([^"]*)" under "(MoCha|MD Andersson)" is active$/, function (subTabName, sectionName, callback) {
         var elemToCheck = tabNameMap[sectionName][subTabName]['element'];
         expect(elemToCheck.isPresent()).to.eventually.eql(true).notify(callback);
    });

    this.Then(/^I verify the headings for "([^"]*)" under "(MoCha|MD Andersson)"$/, function (subTabName, sectionName, callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Then(/^I verify that the data retrieved is present for "([^"]*)" under "(MoCha|MD Andersson)"$/, function (arg1, arg2, callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Then(/^a new Molecular Id is created under the "(MoCha|MD Andersson)"$/, function (sectionName, callback) {
        console.log(clia.responseData.length);
        console.log(clia.newResponseData.length);
         expect(clia.newResponseData.length).to.eql(clia.responseData.length + 1);
        browser.sleep(50).then(callback)
    });

    this.When(/^I upload variant report to S3 with the generated MSN$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Then(/^I see variant report details for the generated MSN$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
       });
};
