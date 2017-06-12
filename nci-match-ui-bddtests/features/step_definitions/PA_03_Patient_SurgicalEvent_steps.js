/**
 * Created by raseel.mohamed on 7/7/16
 */

'use strict';
var fs = require('fs');

var patientPage = require('../../pages/patientPage');
var moment = require('moment');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    var surgicalEventId = '';
    var surgicalEventData;
    var patientApi;
    var patientId
    var responseData;
    var surgicalTabs = element.all(by.css('li[ng-repeat="specimenEvent in specimenEvents"]'));

    this.World = require('../step_definitions/world').World;

    this.When(/^I select another from the drop down$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        browser.sleep(50).then(callback);
    });

    this.Then(/^I capture the current Surgical Event Id from the drop down$/, function (callback) {
        patientPage.surgicalEventDropDownButton.getText().then(function (completeSurgicalId) {
            surgicalEventId = patientPage.trimSurgicalEventId(completeSurgicalId);
        }).then(callback);
    });

    this.When(/^I collect the patient Id$/, function (callback) {
        browser.getCurrentUrl().then(function (url) {
            var startPos = url.indexOf('=') + 1;
            patientId = url.slice(startPos);
        }).then(callback);
    });

    this.When(/^I collect information about the patient$/, function (callback) {
        var url = '/api/v1/patients/' + patientPage.patientId;

        utilities.getRequestWithService('patient', url).then(function(response){
            patientPage.responseData = response
        }).then(callback);
    });

    this.When(/^I collect specimen information about the patient$/, function (callback) {
        var url = '/api/v1/patients/' + patientPage.patientId + '/specimen_events';
        utilities.getRequestWithService('patient', url).then(function(response){
            patientPage.responseData = response
        }).then(callback);
    });

    this.Then(/^I should see the same number of surgical event tabs$/, function (callback) {

        var response = patientPage.responseData['tissue_specimens'];
        var expectedCount = 0
        for (var i = 0; i < response.length; i++) {
            if (response.surgical_event_id !== null) {
                expectedCount++;
            }
        }

        utilities.waitForElement(surgicalTabs.get(0), 'Surgical events tabs');

        browser.ignoreSynchronization = true;

        expect(surgicalTabs.count()).to.eventually.eql(expectedCount).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I verify the data within the Slide shipment table$/, function (callback) {
        var slide_shipments = [];
        var slideShipmentList = patientPage.slideShipmentList;
        var response = patientPage.responseData.tissue_specimens[0];

        var compareSlideRow = function (tableRow, slideShipmentRow) {
            var dateString = utilities.returnFormattedDate(slideShipmentRow["shipped_date"])  + ' GMT';
            utilities.checkExpectation(tableRow.element(by.binding('slide.slide_barcode')), slideShipmentRow["slide_barcode"], "Slide Barcode Mismatch");
            utilities.checkExpectation(tableRow.element(by.binding('slide.carrier')), slideShipmentRow["carrier"], "Carrier Mismatch");
            utilities.checkExpectation(tableRow.element(by.css('tracking-link')), slideShipmentRow["tracking_id"], "Tracking Id Mismatch");
            utilities.checkExpectation(tableRow.element(by.binding('slide.shipped_date')), dateString, "Shipped Date Mismatch");
            expect(tableRow.element(by.css('tracking-link a')).isPresent()).to.eventually.eql(true);
        };

        for(var i = 0; i < response.specimen_shipments.length; i++){
            if (response.specimen_shipments[i].slide_barcode !== undefined){
                slide_shipments.push(response.specimen_shipments[i]);
            }
        }

        slideShipmentList.count().then(function (cnt) {
            for(var j= 0; j < cnt; j++){
                compareSlideRow(slideShipmentList.get(j), slide_shipments[j]);
            }
        }).then(callback);
    });

    this.Then(/^I verify the data within the Assay History table$/, function (callback) {
        var response = patientPage.responseData.tissue_specimens[0].assays;
        var assayTableList = patientPage.assayHistoryList;

        var compareAssayRow = function(tableRow, assayRow){
            var gene = assayRow.biomarker.slice(3, -1);
            var geneLink = tableRow.element(by.css('cosmic-link[link-id="assay.gene"]'));
            var assayResult = tableRow.element(by.exactBinding('assay.result'));
            var dateString = utilities.returnFormattedDate(assayRow['result_date']) + ' GMT';
            utilities.checkExpectation(tableRow.all(by.css('td')).get(1), 'IHC', 'Assay static message');
            utilities.checkExpectation(geneLink, gene, 'Gene value mismatch');
            utilities.checkGeneLink(geneLink);
            utilities.checkExpectation(tableRow.element(by.binding('assay.result_date')), dateString, 'Result Date Mismatch');
            utilities.checkExpectation(assayResult, assayRow['result'], 'Assay Result mismatch');
            utilities.checkColor(assayResult, assayRow['result']);
        };

        assayTableList.count().then(function(cnt){
            for(var i = 0; i < cnt; i++) {
                compareAssayRow(assayTableList.get(i), response[i]);
            }
        }).then(callback)

    });

    this.When(/^I click on the Surgical Event Tab at index "(.+?)"$/, function (index, callback) {
        surgicalTabs.get(index).click().then(function () {
            browser.sleep(10);
        }).then(callback);
    });

    this.When(/^I click on the Surgical Event tab "(.+?)"$/, function (seid, callback) {
        browser.ignoreSynchronization = true;
        browser.sleep(5000);
        var cssSelec = 'li[heading="Surgical Event '+seid+'"] > a'
        var surgicalEventTab = element(by.css(cssSelec));
        surgicalEventTab.isPresent().then(function(isVis){
            // console.log(isVis);
            if(isVis){
                surgicalEventTab.click().then(function () {
                    browser.sleep(10);
                }, function(err){
                    console.log('Unable to click on the surgical event tab');
                });
            }
        }).then(callback);
    });

    this.Then(/^The Surgical Event Id match that of the backend$/, function (callback) {
        var response = patientPage.responseData['tissue_specimens']
        for (var i = 0; i < response.length; i++) {
            if (response[i].surgical_event_id !== null) {
                surgicalEventId = response[i].surgical_event_id;
                surgicalEventData = response[i];
                break;
            }
        }

        expect(patientPage.surgicalEventId.getText()).to.eventually.eql('Surgical Event ' + surgicalEventId).notify(callback);
    });

    this.Then(/^I should see the "(.+?)" under surgical event tab$/, function (heading, callback) {
        var index = patientPage.expectedSurgicalSectionHeading.indexOf(heading);

        expect(patientPage.surgicalEventSectionHeading.get(index)
            .getText()).to.eventually.eql(heading).notify(callback);
    });

    this.Then(/^I should see the "(Event|Details)" Section under patient Surgical Events$/, function (section, callback) {
        var headerBox = patientPage.surgicalEventHeaderBoxLabels[section];
        var expectedHeaderBoxLabels = headerBox['labels'];
        // Getting access to the specific biopsy box
        var actualHeaderBox = patientPage.surgicalEventSummaryBoxList.get(headerBox['index']);
        // Getting to the lables in the above box
        var actualHeaderLabels = actualHeaderBox.all(by.css('.dl-horizontal>dt'));

        browser.ignoreSynchronization = true;
        // expect(actualHeaderBox.all(by.css('h4')).get(0).getText()).to.eventually.equal(section);
        for (var i = 0; i < expectedHeaderBoxLabels.length; i++) {
            expect(actualHeaderLabels.get(i).getText()).to.eventually.equal(expectedHeaderBoxLabels[i]);
        }
        expect(actualHeaderLabels.count()).to.eventually.equal(expectedHeaderBoxLabels.length).notify(callback);

    });

    this.Then(/^They match with the patient json for "([^"]*)" section$/, function (arg1, callback) {
        console.log("patientId " + patientPage.responseData);


        browser.sleep(50).then(callback);
    });

    this.Then(/^The status of each molecularId is displayed$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^I should see "([^"]*)" Assignments under the Molecular ID "([^"]*)"$/, function (assignmentCount, molecularId, callback) {
        var headingRow = element.all(by.repeater('shipment in specimenEvent.specimen_shipments'));
        var actualMolecularId = headingRow.get(0).all(by.binding('shipment.molecular_id')).get(0);
        var siblingRow = headingRow.get(0).all(by.xpath('..')).all(by.repeater(patientPage.variantAndAssignmentPanelString));
        var assignmentBox = element.all(by.css('[ng-repeat="assignment in analysis.assignments"]'))

        expect(actualMolecularId.getText()).to.eventually.eql(molecularId)
        expect(assignmentBox.count()).to.eventually.eql(parseInt(assignmentCount)).notify(callback)
    });
};
