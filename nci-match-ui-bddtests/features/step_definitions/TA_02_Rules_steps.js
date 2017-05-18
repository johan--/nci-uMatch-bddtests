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
        var inputDetails = '/api/v1/treatment_arms/' + taPage.currentTreatmentId + '/' + taPage.currentStratumId;

        utilities.getRequestWithService('treatment', inputDetails).then(function (responseBody) {
            treatmentArmAPIDetails = responseBody;
            firstTreatmentArm = treatmentArmAPIDetails[0];
            utilities.clickElementArray(taPage.rulesSubTabLinks, elementIndex);
        }).then(callback);
    });

    this.When(/^I get the index of the "(.+?)" value in "(.+?)" and "(.+?)"$/, function(columnName, subTabName, exclusionType, callback) {
        if (subTabName === "Non-Sequencing Assays") {
            taPage.testElement = element (by.css ('div#nonSequencingAssays'))
        } else {
            var suffix            = exclusionType === 'Inclusion' ? 'Incl' : 'Excl';
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

    this.When(/^I capture the "([^"]*)" column under "([^"]*)" Table with "(Inclusion|Exclusion)" type$/, function (columnName, variant, variantType, callback) {
        var idString; // Table id that will be used to get the individual columns
        var expectedHeadings;
        var columnIndex;
        switch(variant) {
            case 'SNVs / MNVs / Indels':
                idString = variantType === 'Inclusion' ? 'snvsMnvsIndelsIncl' : 'snvsMnvsIndelsExcl';
                expectedHeadings = variantType === 'Inclusion' ? taPage.expectedIncludedSNVs : taPage.expectedExcludedSNVs
                break;

             case 'CNVs':
                idString = variantType === 'Inclusion' ? 'cnvsIncl' : 'cnvsExcl';
                expectedHeadings = variantType === 'Inclusion' ? taPage.expectedIncludedCNVs : taPage.expectedExcludedCNVs
                break;
        }
        columnIndex = expectedHeadings.indexOf(columnName) + 1; // Incremeting by one because nth-of-type is not zero based index
        var columnValueList = element(by.id(idString)).all(by.css('tr[grid-item]>td:nth-of-type(' + columnIndex + ')'));
        columnValueList.getText().then(function(valueList){
            taPage.valueList = valueList;
        }).then(callback);
    });

    this.When(/^I enter "([^"]*)" in the "([^"]*)" search field$/, function (searchTerm, variantType, callback) {
        var tableString = getTableString(variantType);
        var input = element(by.css('input[grid-id="' + tableString + '"]'));
        input.sendKeys(searchTerm).then(callback);
    });


//Then Section
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

    this.Then(/^I see that the elements in the column "(.+?)" for table "(.+?)" and "(Inclusion|Exclusion)" is a gene$/, function (columnName, subTabName, inclusionType, callback) {
        var table;
        var elementArray;
        if (columnName.length > 0){
             switch (subTabName) {
                 case 'SNVs / MNVs / Indels':
                     table = inclusionType === 'Inclusion' ? taPage.inclusionsnvTable : taPage.exclusionsnvTable;
                     elementArray = table.all(by.css('cosmic-link[link-id="item.gene"]'));
                     utilities.checkElementArrayisGene(elementArray).then(callback);
                     break;

                 case 'CNVs':
                     table = inclusionType === 'Inclusion' ? taPage.inclusioncnvTable : taPage.exclusioncnvTable;
                     elementArray = table.all(by.css('cosmic-link[link-id="item.identifier"]'));
                     utilities.checkElementArrayisGene(elementArray).then(callback);
                     break;

                 case 'Non-Hotspot Rules':
                     table = inclusionType === 'Inclusion' ? taPage.inclusionNHRTable : taPage.exclusionNHRTable;
                     elementArray = table.all(by.css('cosmic-link[link-id="item.func_gene"]'));
                     utilities.checkElementArrayisGene(elementArray).then(callback);
                     break;

                 case 'Non-Sequencing Assays:' :
                     table = taPage.assayTableRepeater;
                     elementArray = table.all(by.css('cosmic-link[link-id="item.gene"]'));
                     utilities.checkElementArrayisGene(elementArray).then(callback);
                     break;

                 case 'Gene Fusions':
                     table = inclusionType === 'Inclusion' ? taPage.inclusionGeneTable : taPage.exclusionGeneTable;
                     elementArray = table.all(by.css('cosmic-link[link-id="item.identifier"]'));
                     utilities.checkElementArrayisCosf(elementArray).then(callback);
                     break;
             }

         } else {
             browser.sleep(50).then(callback)
         }
    });

    this.Then(/^I see that the elements in the column gene for table Non-Sequencing Assays is a gene$/, function (callback) {
        var table;
        var elementArray;
        table = taPage.assayTableRepeater;
        elementArray = table.all(by.css('cosmic-link[link-id="item.gene"]'));
        utilities.checkElementArrayisGene(elementArray).then(callback);
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

    this.Then(/^I should see the sub-tabs under Rules$/, function (callback) {
        utilities.checkElementArray(taPage.rulesSubTabLinks, taPage.expectedRulesSubTabs);
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the (Inclusion|Exclusion) Variants table for (.+?)$/, function (inclusionType, variant, callback) {
        var data = [];
        var tableType;
        var actualTableHeadings;
        var expectedHeadings;
        var expectedToolTips;
        // First getting the data for the variant from the treatment arm
        data = taPage.generateArmDetailForVariant(firstTreatmentArm, variant, inclusionType);

        switch(variant) {
            case 'SNVs / MNVs / Indels':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedSNVs : taPage.actualHeadingExcludedSNVs;
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedSNVs : taPage.expectedExcludedSNVs;
                expectedToolTips = inclusionType === 'Inclusion' ? taPage.expectedInclSNVToolTip : taPage.expectedExclSNVToolTip;

                actualTableHeadings.getText().then(function(actualArr){
                    expect(actualArr).to.eql(expectedHeadings, "Expected: " + expectedHeadings + '\nActual: ' + actualArr);
                });

                tableType = inclusionType === 'Inclusion' ? taPage.inclusionsnvTable : taPage.exclusionsnvTable;
                taPage.checkToolTips(actualTableHeadings, expectedToolTips);
                taPage.checkSNVTable(data, tableType, inclusionType);
                break;
            case 'CNVs':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedCNVs : taPage.actualHeadingExcludedCNVs;
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedCNVs : taPage.expectedExcludedCNVs;
                expectedToolTips = inclusionType === 'Inclusion' ? taPage.expectedInclCNVToolTip : taPage.expectedExclCNVToolTip;

                actualTableHeadings.getText().then(function(actualArr){
                    expect(actualArr).to.eql(expectedHeadings, "Expected: " + expectedHeadings + '\nActual: ' + actualArr);
                });

                tableType = inclusionType === 'Inclusion' ? taPage.inclusioncnvTable : taPage.exclusioncnvTable;
                taPage.checkToolTips(actualTableHeadings, expectedToolTips);
                taPage.checkCNVTable(data, tableType, inclusionType);
                break;
            case 'Gene Fusions':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedGene : taPage.actualHeadingExcludedGene;
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedGene : taPage.expectedExcludedGene;
                expectedToolTips = inclusionType === 'Inclusion' ? taPage.expectedInclGenToolTip : taPage.expectedExclGenToolTip;

                actualTableHeadings.getText().then(function(actualArr){
                    expect(actualArr).to.eql(expectedHeadings, "Expected: " + expectedHeadings + '\nActual: ' + actualArr);
                });

                tableType = inclusionType === 'Inclusion' ? taPage.inclusionGeneTable : taPage.exclusionGeneTable;
                taPage.checkToolTips(actualTableHeadings, expectedToolTips);
                taPage.checkGeneFusionTable(data, tableType, inclusionType);
                break;
            case 'Non-Hotspot Rules':
                actualTableHeadings = inclusionType === 'Inclusion' ? taPage.actualHeadingIncludedNHRs : taPage.actualHeadingExcludedNHRs;
                expectedHeadings = inclusionType === 'Inclusion' ? taPage.expectedIncludedNHRs : taPage.expectedExcludedNHRs;
                expectedToolTips = inclusionType === 'Inclusion' ? taPage.expectedInclNHRToolTip : taPage.expectedExclNHRToolTip;

                actualTableHeadings.getText().then(function(actualArr){
                    expect(actualArr).to.eql(expectedHeadings, "Expected: " + expectedHeadings + '\nActual: ' + actualArr);
                });

                tableType = inclusionType === 'Inclusion' ? taPage.inclusionNHRTable : taPage.exclusionNHRTable;
                taPage.checkToolTips(actualTableHeadings, expectedToolTips);
                taPage.checkNonHotspotRulesTable(data, tableType, inclusionType);
                break;
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the Non\-Sequencing Assays table$/, function (callback) {
        var data = firstTreatmentArm['assay_rules'];
        var repeater = taPage.assayTableRepeater;
        var actualTableHeadings = taPage.actualHeadingNonSequenceArray;
        var expectedHeadings = taPage.expectedNonSequenceArray;
        var expectedToopTips = taPage.expectedNonSeqArrToolTip;
        taPage.checkToolTips(actualTableHeadings, expectedToopTips);
        actualTableHeadings.getText().then(function(actualArr){
            expect(actualArr).to.eql(expectedHeadings, "Expected: " + expectedHeadings + '\nActual: ' + actualArr);
        });
        taPage.checkAssayResultsTable(data, repeater);
        browser.sleep(50).then(callback);
    });

    this.When(/^I verify that they are sorted numerically$/, function (callback) {
        var sortedArray = separateAndSort(taPage.valueList);
        browser.sleep(50).then(function(){
            for(var i = 0; i < sortedArray.length; i++){
                expect(i + " row " + taPage.valueList[i]).to.eql(i + " row " + sortedArray[i].toString())
            }
        }).then(callback);
    });

    this.Then(/^I should see "([^"]*)" in the retrieved row for "(.+?)"$/, function (searchTerm, variantType, callback) {
        var tableString = getTableString(variantType);
        var tableRows = element(by.id(tableString)).all(by.css('tbody tr'));
        expect(tableRows.count()).to.eventually.eql(1);
        expect(tableRows.get(0).getText()).to.eventually.include(searchTerm).notify(callback);
    });

    this.Then(/^I should not see any retrieved row for "(.+?)"$/, function(variantType, callback){
        var tableString = getTableString(variantType);
        var tableRows = element(by.id(tableString)).all(by.css('tbody tr'));
        expect(tableRows.count()).to.eventually.eql(0).notify(callback);
    });


    /**
     * Function to separate numbers from other alphabets, sort the individual
     * arrays and concat them together
     * @param  {Array} arr  - Array containing both numbers and alphabets
     * @return {Array} returnArray - One Array containing number that are sorted
     *                             numerically followed by pure string that is
     *                             sorted by string
     */
    function separateAndSort(arr){
        var numericArray = [];
        var stringArray = [];
        for(var i = 0; i < arr.length; i++){
            if (isNaN(arr[i])){
                stringArray.push(arr[i]);
            } else {
                numericArray.push(parseInt(arr[i]));
            }
        }

        numericArray = numericArray.sort(function(a,b) { return a - b });
        stringArray = stringArray.sort();

        var returnArray = numericArray.concat(stringArray);
        return returnArray;
    }

    function getTableString (variantTypeString) {
        switch (variantTypeString) {
            case 'SNVs / MNVs / Indels':
                return 'snvsMnvsIndelsIncl';
                break;

            case 'CNVs':
                return 'cnvsIncl';
                break;

            case 'Gene Fusions':
                return 'geneFusionsIncl';
                break;

            case 'Non-Hotspot Rules':
                return 'nonHotspotRulesIncl';
                break;

            case 'Non-Sequencing Assays':
                return 'nonSequencingAssays';
                break;
        }
    }
};
