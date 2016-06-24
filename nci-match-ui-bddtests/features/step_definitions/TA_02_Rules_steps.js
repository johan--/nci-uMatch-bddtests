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
        treatment_id = taPage.getTreatmentArmId();
        response = utilities.callTreatmentApi(treatment_id);
        response.get().then(function () {
            treatmentArmAPIDetails = utilities.getTreatmentArmIdDetails(response.entity());
            firstTreatmentArm = treatmentArmAPIDetails[0];
            utilities.clickElementArray(taPage.rulesSubTabLinks, elementIndex);
        });

        browser.sleep(50).then(callback);
    });

    this.Then(/I should see (Inclusionary|Exclusionary) (Drugs|Diseases) table/, function (inclusionType, tableType, callback) {
        var firstPart;
        var secondPart;
        var dataNode;
        var refData;        // Node to collect data from treatment arm api call.
        var repeaterString; // repeater string used to collect rows from the relevant table
        
        firstPart = inclusionType === 'Inclusionary' ? 'inclusion' : 'exclusion';
        secondPart = tableType === 'Diseases' ? 'diseases': 'drugs';

        dataNode = firstPart + '_' + secondPart;
        refData = firstTreatmentArm[dataNode]; // Reference data

        repeaterString = 'item in selectedVersion.' + inclusionType.toLocaleLowerCase() + tableType;

        if (refData !== undefined) {
            expect(element.all(by.repeater(repeaterString)).count()).to.eventually.equal(refData.length);
            tableType === 'Drugs' ? taPage.checkDrugsTable(refData, repeaterString) : taPage.checkDiseasesTable(refData, repeaterString);
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see that (.+) sub-tab is active$/, function(subTabName, callback){
        var elementIndex = taPage.expectedRulesSubTabs.indexOf(subTabName);
        var subTab = taPage.rulesSubTabPanels.get(elementIndex);
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
        // First getting the data for the variant from the treatment arm
        var data = taPage.generateArmDetailForVariant(firstTreatmentArm, variant, inclusionType);
        var tableType = inclusionType == 'Inclusion' ? taPage.inclusionTable : taPage.exclusionTable;

        switch(variant) {
            case 'SNV / MNV':
                taPage.checkSNVTable(data, tableType, inclusionType);
                break;
            case 'Indel':
                taPage.checkIndelTable(data, tableType, inclusionType);
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
