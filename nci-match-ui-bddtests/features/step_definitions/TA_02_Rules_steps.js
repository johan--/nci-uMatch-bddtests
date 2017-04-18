/**
 * Created by raseel.mohamed on 6/13/16
 */

'use strict';
var fs = require('fs');

var taPage = require('../../pages/treatmentArmsPage');
// Helper Methods
var utilities = require('../../support/utilities');

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

        utilities.getRequestWithService('treatment', inputDetails).then(function (responseBody) {
            treatmentArmAPIDetails = responseBody;
            firstTreatmentArm = treatmentArmAPIDetails[0];
            utilities.clickElementArray(taPage.rulesSubTabLinks, elementIndex);
        }).then(callback);
    });

    this.Then(/^I should see Exclusionary Drugs table$/, function (callback) {
        var firstPart;
        var refData;        // Node to collect data from treatment arm api call.

        refData = firstTreatmentArm['exclusion_drugs'];

        var testElement = element.all(by.css('#exclusionaryDrugs>table tr[ng-repeat^="item in filtered"]'));
        expect(testElement.count()).to.eventually.eql(refData.length).then(function () {
            browser.sleep(10);
        }).then(callback);
    });

    this.When(/^I get the index of the "(.+?)" value in "(.+?)" and "(.+?)"$/, function(columnName, subTabName, exclusionType, callback) {
        if (subTabName === "Non-Sequencing Assays") {
            taPage.testElement = element (by.css ('div#nonSequencingAssays'))
        } else {
            var suffix            = exclusionType === 'Inclusion' ? 'Incl' : 'Excl'
            var testElementString = taPage.getTablePrefix (subTabName) + suffix;
            console.log (testElementString);
            taPage.testElement = element (by.css ('div#' + testElementString));
        }

        var tableHeaders = taPage.testElement.all (by.css ('th'));
        tableHeaders.getText ().then (function (headerArray) {
            //Getting the index of the columnName
            taPage.columnIndex = headerArray.indexOf (columnName);

            // Getting access to each row
            taPage.dataRows = taPage.testElement.all (by.css ('tr[ng-repeat^="item in filtered |"]'))

            taPage.dataRows.count ().then (function (cnt) {
                taPage.rowCount = cnt;

            });
        }).then(callback);
    });


    this.Then(/^I see that the element with css "(.*)" is a "(.+?)" link$/, function(selector, type, callback){
        var elem = taPage.testElement.all(by.css(selector));
        browser.sleep(50).then(function () {
            // checking for element at index to be a link
            for (var i = 0; i < taPage.rowCount; i ++){
                if (type === 'Cosmic'){
                    utilities.checkCosmicLink(taPage.dataRows.get(i), taPage.columnIndex);
                } else if (type === 'Gene') {
                    utilities.checkGeneLink(elem.get(i));
                } else if (type === 'Cosf') {
                    utilities.checkCOSFLink(elem.get(i));
                }
            }
        }).then(callback);
    });


    this.Then(/I should see (Inclusionary|Exclusionary) Disease table/, function (inclusionType, callback) {
        var firstPart;
        var exclusion;
        var refData;        // Node to collect data from treatment arm api call.
        var repeaterString; // repeater string used to collect rows from the relevant table
        var expectedArray = [];
        // element.all(by.css('#exclusionaryDiseases>table tr[ng-repeat^="item in filtered"]')).get(0).getText()

        refData = firstTreatmentArm['diseases'];

        firstPart = inclusionType === 'Inclusionary' ? 'inclusionary' : 'exclusionary';
        repeaterString = '#' + firstPart + 'Diseases>table tr[ng-repeat^="item in filtered"]'

        exclusion = inclusionType !== 'Inclusionary';

        var exclusion_count = 0;

        for (var i = 0; i < refData.length; i++) {
            if (refData[i].exclusion === exclusion) {
                exclusion_count++;
                expectedArray.push(refData[i]);
            }
        }

        expect(element.all(by.css(repeaterString)).count()).
            to.eventually.eql(exclusion_count).notify(callback);
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
            browser.sleep(100)
        }).then(callback);
    });

    // Then section
    this.Then(/^I should see the sub-tabs under Rules$/, function (callback) {
        utilities.checkElementArray(taPage.rulesSubTabLinks, taPage.expectedRulesSubTabs);
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the (Inclusion|Exclusion) Variants table for (.+?)$/, function (inclusionType, variant, callback) {
        var data = [];
        var tableType;
        var actualTableHeadings;
        var expectedHeadings
        // First getting the data for the variant from the treatment arm
        data = taPage.generateArmDetailForVariant(firstTreatmentArm, variant, inclusionType);

        switch(variant) {
            case 'SNVs / MNVs / Indels':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedSNVs : taPage.actualHeadingExcludedSNVs
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedSNVs : taPage.expectedExcludedSNVs

                expect(actualTableHeadings.getText()).to.eventually.eql(expectedHeadings);

                tableType = inclusionType === 'Inclusion' ? taPage.inclusionsnvTable : taPage.exclusionsnvTable;
                taPage.checkSNVTable(data, tableType, inclusionType);
                break;
            case 'CNVs':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedCNVs : taPage.actualHeadingExcludedCNVs
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedCNVs : taPage.expectedExcludedCNVs

                expect(actualTableHeadings.getText()).to.eventually.eql(expectedHeadings);

                tableType = inclusionType === 'Inclusion' ? taPage.inclusioncnvTable : taPage.exclusioncnvTable;
                taPage.checkCNVTable(data, tableType, inclusionType);
                break;
            case 'Gene Fusions':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedGene : taPage.actualHeadingExcludedGene
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedGene : taPage.expectedExcludedGene

                expect(actualTableHeadings.getText()).to.eventually.eql(expectedHeadings);

                tableType = inclusionType === 'Inclusion' ? taPage.inclusionGeneTable : taPage.exclusionGeneTable;
                taPage.checkGeneFusionTable(data, tableType, inclusionType);
                break;
            case 'Non-Hotspot Rules':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedNHRs : taPage.actualHeadingExcludedNHRs
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedNHRs : taPage.expectedExcludedNHRs
                expect(actualTableHeadings.getText()).to.eventually.eql(expectedHeadings);

                tableType = inclusionType === 'Inclusion' ? taPage.inclusionNHRTable : taPage.exclusionNHRTable;
                taPage.checkNonHotspotRulesTable(data, tableType, inclusionType);
                break;
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the Non\-Sequencing Assays table$/, function (callback) {
        var data = firstTreatmentArm['assay_rules'];
        var repeater = taPage.assayTableRepeater;
        taPage.checkAssayResultsTable(data, repeater);
        browser.sleep(50).then(callback);
    });
};
