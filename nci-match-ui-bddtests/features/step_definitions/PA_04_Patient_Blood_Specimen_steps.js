/**
 * Created by: Raseel Mohamed
 * Date: 07/22/2016
 */

'use strict';

var fs = require ('fs');

var patientPage = require ('../../pages/patientPage');

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

    this.Then(/^I can see the "([^"]*)" table under "(.+)" tab$/, function (subSection, variantType, callback) {
        // todo: Get the values from the patient json before comparing with backend
        var index = patientPage.expVarReportTables.indexOf(subSection);
        var tableHeadings = {
            'SNVs/MNVs/Indels': patientPage.expSNVTableHeadings,
            'Copy Number Variant(s)': patientPage.expCNVTableHeadings,
            'Gene Fusion(s)': patientPage.expGFTableHeadings
        };
        var expectedHeadingsArray = tableHeadings[subSection];
        var variantString = variantType == 'Tissue Reports' ? patientPage.tissueMasterPanelString : patientPage.bloodMasterPanelString;
        var elementString = variantString + " .table-responsive";

        var tableElement = element.all(by.css(elementString));
        // This way we can compare the number of columns and their names together
        tableElement.get(index).all(by.css('th')).getText().then(function (headingArray) {
            expect(headingArray).to.eql(expectedHeadingsArray);
        });
        browser.sleep(50).then(callback);
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


    this.Then(/^I can see the Variant section$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I see the check box in the "([^"]*)" sub section$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I can see the Oncomine Control Panel Summary Details$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I do not see the check box in the "SNVs\/MNVs\/Indels sub section$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I do not see the check box in the "([^"]*)" sub section$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I do not see the check box in the "([^"]*)"n sub section$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
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
};
