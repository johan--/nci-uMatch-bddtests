/**
 * Created by: Raseel Mohamed
 * Date: 07/22/2016
 */

'use strict';

var fs = require ('fs');
var patientPage = require('../../pages/patientPage');
var utilities = require ('../../support/utilities');

module.exports = function() {
    var patientId;
    var surgicalEventId;

    this.World = require('../step_definitions/world');

    this.Then(/^I can see the Analysis ID details section$/, function (callback) {
        patientPage.bloodVariantReportDropDown.getText().then(function (text) {
            var detailsHash = splitBloodVariantReportDropDown(text);
            expect(patientPage.bloodAnalysisId.getText()).to.eventually.eql(detailsHash['analysisId']);
            expect(patientPage.bloodMolecularId.getText()).to.eventually.eql(detailsHash['molecularId']);
            expect(patientPage.bloodReportStatus.getText()).to.eventually.eql(detailsHash['status']);
        }).then(callback);
    });

    this.When(/^I click on the Filtered Button under "((Tissue|Blood Variant) Reports)" tab$/, function (tabName, callback) {
        var buttonElement = getFilteredQCButton('Filtered', tabName);
        buttonElement.click().then(function () {
            return browser.waitForAngular();
//            var assignmentHeading = element(by.css(patientPage.tissueTableString))
//            utilities.waitForElement(assignmentHeading, 'Table Element on Tissue/Blood');
//            return;
        }).then(callback);
    });

    this.When(/^I click on the QC Report Button under "((Tissue|Blood Variant) Reports)" tab$/, function (tabName, callback) {
        var buttonElement = getFilteredQCButton('QC', tabName);
        buttonElement.click().then(function () {
            return browser.waitForAngular();
//            var assignmentHeading = element(by.css(patientPage.tissueTableString))
//            utilities.waitForElement(assignmentHeading, 'Table Element on Tissue/Blood');
//            return;
        }).then(callback);
    });

    // buttonName: Filtered or QC Report
    // tabName: Tissue Report or Blood Variant Report
    this.Then(/^I see the "(Filtered|QC Report)" Button under "((Tissue|Blood Variant) Reports)" is selected$/, function (buttonName, tabName, callback) {
        var buttonElement = getFilteredQCButton(buttonName, tabName);
        utilities.checkElementIncludesAttribute(buttonElement, 'class', 'active');
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see SNVs, Indels, CNV, Gene Fusion Sections under "((Tissue|Blood Variant) Reports)" Filtered tab$/, function(tabName, callback) {
        var typeName = tabName === 'Tissue Reports' ?  'currentTissueVariantReport' : 'currentBloodVariantReport';
        var section_locators = element.all(by.css('[ng-if="' + typeName + '"] [ng-if="variantReportMode === \'FILTERED\'"] h3'));
        expect(section_locators.count()).to.eventually.eql(patientPage.expVarReportTables.length);
        expect(section_locators.getText()).to.eventually.eql(patientPage.expVarReportTables);
        browser.sleep(50).then(callback);
    });

    function splitTissueVariantReportDropDown(dropDownText){
        var returnValue = {};
        var textArray = dropDownText.split('|');
        returnValue["surgicalEvent"] = textArray[0].replace("Surgical Event", '').trim();
        returnValue['analysisId'] = textArray[1].replace("Analysis ID", '').trim();
        returnValue['molecularId'] = textArray[2].replace("Molecular ID", '').trim();
        returnValue['status'] = textArray[3].trim();
        return returnValue;
    };

    function splitBloodVariantReportDropDown(dropDownText) {
        var returnValue = {};
        var textArray = dropDownText.split('|');
        returnValue['analysisId'] = textArray[0].replace("Analysis ID", '').trim();
        returnValue['molecularId'] = textArray[1].replace("Molecular ID", '').trim();
        returnValue['status'] = textArray[2].trim();
        return returnValue;
    }

    function getFilteredQCButton(filtered, reportType){
        var buttonString = filtered === 'Filtered' ? 'FILTERED' : 'QC';
        var panelString = reportType === 'Tissue Reports' ? patientPage.tissueMasterPanelString : patientPage.bloodMasterPanelString;
        var css_locator = panelString + " [ng-class=\"getVariantReportModeClass('" + buttonString + "')\"]";
        return element(by.css(css_locator));
    }

    this.Then(/^I click the variant report link for "(.+?)"$/, function (analysisId, callback) {
        patientPage.variantAnalysisId = analysisId;
        var link = element.all(by.repeater('analysisAssignment in shipment.analyses'))
            .first()
            .all(by.tagName('a')).first();

        link.click().then(function(){
          browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^All the existing checkboxes are checked and disabled$/, function (callback) {
        var checkboxes = element.all(by.tagName('check-box-with-confirm'))
            .all(by.tagName('input'));

        checkboxes.each(function(checkBox){
            expect(checkBox.isEnabled()).to.eventually.equal(false);
        }).then(callback);
    });
};
