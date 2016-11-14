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
                'control_type': 'postive'
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
                'control_type': 'no_template'
            }
        }
    }



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
         elem.click().then(function(){
             browser.waitForAngular();
         }).then(callback);
    });

    this.When(/^I collect information on "([^"]*)" under "(MoCha|MD Andersson)"$/, function (subTabName, sectionName, callback) {
         var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';


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
};
