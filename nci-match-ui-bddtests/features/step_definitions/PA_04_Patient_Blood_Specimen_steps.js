/**
 * Created by: Raseel Mohamed
 * Date: 07/22/2016
 */

'use strict';

var fs = require('fs');
var patientPage = require('../../pages/patientPage');
var utilities = require('../../support/utilities');

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
        }).then(callback);
    });

    this.When(/^I click on the QC Report Button under "((Tissue|Blood Variant) Reports)" tab$/, function (tabName, callback) {
        var buttonElement = getFilteredQCButton('QC', tabName);
        buttonElement.click().then(function () {
            return browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I click on the Blood Specimens tab$/, function (callback) {
        browser.waitForAngular().then(function (){
            patientPage.bloodSpecimenTab.click().then(function(){
                browser.waitForAngular();
            });
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

    this.Then(/^All the existing checkboxes are checked and disabled$/, function (callback) {
        var checkboxes = element.all(by.tagName('check-box-with-confirm'))
            .all(by.tagName('input'));

        checkboxes.each(function(checkBox){
            expect(checkBox.isEnabled()).to.eventually.equal(false);
        }).then(callback);
    });

    this.Then(/^I can see the "(Blood (Specimens|Shipments))" section$/, function (arg1, callback) {
        var index = arg1 === 'Blood Specimens' ? 0 : 1 ;
        var elem = patientPage.bloodMasterPanel.all(by.css('div>h3')).get(index);
        expect(elem.getText()).to.eventually.eql(arg1).then(function(){
            browser.sleep(50)
        }).then(callback);
    });

    this.Then(/^I can see the Blood Specimens table columns$/, function (callback) {
        var elem = patientPage.bloodMasterPanel.all(by.css('table')).get(0).all(by.css('th'));
        var expectedArray = patientPage.expectedBloodSpecimensColumns;
        elem.getText().then(function(textArray){
            expect(textArray).to.eql(expectedArray);
        }).then(callback);
    });

    this.Then(/^I can see the Blood Shipments table columns$/, function (callback) {
        var elem = patientPage.bloodMasterPanel.all(by.css('table')).get(1).all(by.css('th'));
        var expectedArray = patientPage.expectedBloodShipmentsColumns;
        elem.getText().then(function(textArray){
            expect(textArray).to.eql(expectedArray);
        }).then(callback);
    });

    this.When(/^I collect information about blood shipments for the patient "([^"]*)"$/, function (arg1, callback) {
        var url = '/api/v1/patients/UI_SP01_MultiBdSpecimens/specimen_events';
        utilities.getRequestWithService('patient', url).then(function(response){
            patientPage.specimens = response;
        }).then(callback);
    });

    this.Then(/^I should see "(\d*)" messages of "([^"]*)" on the front page$/, function (number, message, callback) {
        var listOfTitles = element.all(by.css('p.timeline-title'));
        // listOfTitles.getText().then(function(text){console.log(text)});
        var count = 0
        listOfTitles.getText().then(function(titleArray){
            for(var i = 0; i < titleArray.length ; i++){
                if (titleArray[i].includes(message)) {
                    count++;
                }
            }
            expect(count.toString()).to.eql(number);
        }).then(callback);
    });

    this.When(/^I should see entries under the Blood Specimens table match with the backend$/, function (callback) {
        var elem = patientPage.bloodSpecimenEntries
        expect(elem.count()).to.eventually.eql(patientPage.specimens.blood_specimens.specimens.length).notify(callback)
    });


    this.When(/^I should see entries under the Blood Shipments table match with the backend$/, function (callback) {
        var elem = patientPage.bloodShipmentEntries
        expect(elem.count()).to.eventually.eql(patientPage.specimens.blood_specimens.specimen_shipments.length).notify(callback);
    });

    this.When(/^I verify one entry in the Blood Specimens table with the backend$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });


    this.When(/^I verify one entry in the Blood Shipments table with the backend$/, function (callback) {
          // Write code here that turns the phrase above into concrete actions
          callback(null, 'pending');
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
