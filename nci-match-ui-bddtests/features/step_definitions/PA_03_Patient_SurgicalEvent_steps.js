/**
 * Created by raseel.mohamed on 7/7/16
 */

'use strict';
var fs = require('fs');

var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    var surgicalEventId;
    var patientApi;

    this.World = require('../step_definitions/world').World;


    this.When(/^I select another  from the drop down$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        browser.sleep(50).then(callback);
    });

    this.Then(/^I capture the current Surgical Event Id$/, function (callback) {
        element(by.binding('surgicalEventOption.text')).getText().then(function (surgicalId) {
            console.log(surgicalId);
            surgicalEventId = surgicalId.replace('Surgical Event ', '').replace(/\|.+/, '').trim();
            console.log(surgicalEventId);
        }).then(callback);
    });

    this.Then(/^I should see the "(Event|Pathology)" Section under patient Surgical Events$/, function (section, callback) {
        var headerBox = patientPage.biopsyHeaderBoxLabels[section];
        var expectedHeaderBoxLabels = headerBox['labels'];
        // Getting access to the specific biopsy box
        var actualHeaderBox = patientPage.surgicalEventSummaryBoxList.get(headerBox['index']);
        // Getting to the lables in the above box
        var actualHeaderLabels = actualHeaderBox.all(by.css('.dl-horizontal>dt'));

        expect(actualHeaderBox.all(by.css('h4')).get(0).getText()).to.eventually.equal(section);
        expect(actualHeaderLabels.count()).to.eventually.equal(expectedHeaderBoxLabels.length);
        for( var i = 0; i < expectedHeaderBoxLabels.length; i++){
            expect(actualHeaderLabels.get(i).getText()).to.eventually.equal(expectedHeaderBoxLabels[i]);
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the Surgical Events drop down button$/, function (callback) {

        expect(patientPage.surgicalEventDropDownButton.isPresent()).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Then(/^I see that the Event Section match with the one in the drop down$/, function (callback) {
        expect(element(by.binding('currentSurgicalEvent.surgical_event_id')).getText()).to.eventually.eql(surgicalEventId + 'a');
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the "((Assay|Specimen) History)" Sub Section under Surgical Event$/, function (subSection, callback) {
        var repeaterString;

        var specimenData;
        //todo: write code that will compare the front end data under the seuSection against the back end api call
        for (var i = 0; i < patientApi['specimen_history'].length; i++){
            if (patientApi['specimen_history'][i]['surgical_event_id'] === surgicalEventId){
                specimenData = patientApi['specimen_history'][i];
            }
        }

        var assayHistory = specimenData['assays'];
        var specimenHistory = specimenData['specimen_shipments'];

        var panel = patientPage.surgicalEventPanel;

        if (subSection === 'Assay History'){
            expect(panel.get(0).all(by.css('h3').getText())).to.eventually.equal(subSection);

            // repeaterString = 'assay in currentSurgicalEvent.assays';
            // expect(element.all(by.repeater(repeaterString)).count()).to.eventually.equal(assay_history.length);
            // var expectedFirstAssay = assay_history[0];
            // var actualFirstAssay;
            //

        } else {
            expect(panel.get(1).all(by.css('h3').getText())).to.eventually.equal(subSection);
        }

    });

    this.Then(/^I see the Assay History Match with the database$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });

    this.Then(/^The status of each molecularId is displayed$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending();
    });
};