/**
 * Created by raseel.mohamed on 6/13/16
 */

'use strict';
var fs = require('fs');

var taPage = require('../../pages/treatmentArmsPage');
// Helper Methods
var utilities = require ('../../support/utilities');

module.exports = function () {

    this.World = require('../step_definitions/world').World;

    var treatment_id ;
    var treatmentArmAPIDetails;
    var firstTreatmentArm;

    // When section
    this.When(/^I select the (.+) sub-tab$/, function(subTabName, callback){
        var elementIndex = taPage.expectedRulesSubTabs.indexOf(subTabName);
        var response;
        var inputDetails = '/api/v1/treatment_arms/' + taPage.currentTreatmentId + '/' + taPage.currentStratumId;

        response = utilities.callApi('treatment', inputDetails);
        response.get().then(function () {
            treatmentArmAPIDetails = utilities.getJSONifiedDetails(response.entity());
            firstTreatmentArm = treatmentArmAPIDetails[0];
            utilities.clickElementArray(taPage.rulesSubTabLinks, elementIndex);
        }).then(callback);
    });

    this.Then(/I should see Exclusionary Drugs table/, function (callback) {
        var firstPart;
        var refData;        // Node to collect data from treatment arm api call.

        refData = firstTreatmentArm['exclusion_drugs'];

        var testElement = element(by.css('#exclusionaryDrugs+table tr[ng-repeat^="item in filtered"]'));
        expect(testElement.count()).to.eventually.eql(refData.length).then(callback);
    });

    this.Then(/I should see (Inclusionary|Exclusionary) Diseases table/, function (inclusionType, callback) {
        var firstPart;
        var exclusion;
        var refData;        // Node to collect data from treatment arm api call.
        var repeaterString; // repeater string used to collect rows from the relevant table
        var expectedArray = [];
        element.all(by.css('#exclusionaryDiseases+table tr[ng-repeat^="item in filtered"]')).get(0).getText()

        refData = firstTreatmentArm['diseases'];

        firstPart = inclusionType === 'Inclusionary' ? 'inclusionary' : 'exclusionary';
        repeaterString = '#' + firstPart + 'Diseases+table tr[ng-repeat^="item in filtered"]'

        exclusion = inclusionType === 'Inclusionary' ? false : true;

        var exclusion_count = 0;

        for (var i = 0; i < refData.length; i++) {
            if (refData[i].exclusion === exclusion) {
                exclusion_count++;
                expectedArray.push(refData[i]);
            }
        }

        expect(element(by.css(repeaterString)).count()).to.eventually.eql(exclusion_count).then(callback);

    });

    this.Then(/^I should see that (.+) sub-tab is active$/, function(subTabName, callback){
        var subTab = element(by.css('li[heading="' + subTabName + '"]'));
        utilities.checkElementIncludesAttribute(subTab, 'class', 'active');
        browser.sleep(50).then(callback);
    });

    this.When(/^I select the (.+) button$/, function(type, callback){
        var buttonType;
        if (type == 'Inclusion') {
            buttonType = taPage.inclusionButton;
        } else if (type == 'Exclusion') {
            buttonType = taPage.exclusionButton;
        } else {
            console.log("Invalid button type entered");
            return;
        }

        buttonType.click().then(function () {
            callback();
        });
    });

    // Then section
    this.Then(/^I should see the sub-tabs under Rules$/, function (callback) {
        utilities.checkElementArray(taPage.rulesSubTabLinks, taPage.expectedRulesSubTabs);
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the (.+) Variants table for (.+)$/, function (inclusionType, variant, callback) {
        var data = [];
        // First getting the data for the variant from the treatment arm
        data = taPage.generateArmDetailForVariant(firstTreatmentArm, variant, inclusionType);

        var tableType = inclusionType == 'Inclusion' ? taPage.inclusionTable : taPage.exclusionTable;

        switch(variant) {
            case 'SNVs / MNVs / Indels':
                taPage.checkSNVTable(data, tableType, inclusionType);
                break;
            case 'CNV':
                taPage.checkCNVTable(data, tableType, inclusionType);
                break;
            case 'Gene Fusion':
                taPage.checkGeneFusionTable(data, tableType, inclusionType);
                break;
            case 'Non-Hotspot Rules':
                taPage.checkNonHotspotRulesTable(data, tableType, inclusionType);
                break;
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the Non\-Sequencing Assays table$/, function (callback) {
        var data = firstTreatmentArm['assay_results'];
        var repeater = taPage.assayTableRepeater;
        taPage.checkAssayResultsTable(data, repeater);
        callback(null, 'pending');
    });
};
