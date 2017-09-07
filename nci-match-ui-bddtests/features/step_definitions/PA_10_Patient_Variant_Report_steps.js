/**
 * Created by Rick Zakharov on 18 Jan 2017
 */
'use strict';
var fs = require('fs');

var patientPage = require('../../pages/patientPage');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    this.World = require('../step_definitions/world').World;

    function getColumn(arr, col) {
        return arr.map(function (row) { return row[col]; });
    }

    this.Then(/^I remember order of elements in column "([^"]*)" of the "([^"]*)" table$/, function (column, tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);
        var headers = table.element(by.tagName('thead')).all(by.tagName("th"));

        patientPage.unsortedColumnData = [];

        utilities.getDataByRepeater(table, 'item in filtered', function(tableData) {
            patientPage.unsortedColumnData = getColumn(tableData, column);
        })
        .then(callback);
    });

    this.Then(/^I click on "([^"]*)" column header of the "([^"]*)" table$/, function (column, tableTitle, callback) {
        var table = patientPage.tableByH3Title(tableTitle);
        var headers = table.element(by.tagName('thead')).all(by.tagName("th"));

        patientPage.sortedColumnData = [];
        headers.get(column).getLocation().then(function(location){
            browser.executeScript('window.scrollTo(0, '+ (location.y + 200) + ')').then(function() {
                headers.get(column).click().then(function() {
                    utilities.getDataByRepeater(table, 'item in filtered', function (tableData) {
                        patientPage.sortedColumnData = getColumn(tableData, column);
                    })
                });
            })
        }).then(callback);
    });

    this.Then(/^I should see the data in the column to be sorted properly$/, function (callback) {
        var expectedSortedData = patientPage.unsortedColumnData.sort().reverse();

        expect(expectedSortedData).to.deep.equal(patientPage.sortedColumnData);
        callback();
    });

    this.When(/^I click on the Surgical Event Id Link$/, function (callback) {
        patientPage.patientSurgicalEventId.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I click on the Molecular ID link$/, function (callback) {
        patientPage.patientMolecularId.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I should go to the surgical event page of the patient$/, function (callback) {
        var patientId = patientPage.patientId;
        var surgicalEventId = patientId + '_SEI1';
        var expectedUrl = browser.baseUrl + '/#/patient?patient_id=' + patientId + '&section=surgical_event&surgical_event_id=' + surgicalEventId;
        browser.ignoreSynchronization = true;
        utilities.checkElementIncludesAttribute(element(by.css('li[ng-repeat="specimenEvent in specimenEvents"]')), 'class', 'active');
        expect(browser.getCurrentUrl()).to.eventually.eql(expectedUrl).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I should go to the molecular id section of the surgical event page$/, function (callback) {
        var patientId = patientPage.patientId;
        var surgicalEventId = patientId + '_SEI1';
        var molecularId = patientId + '_MOI1';
        var expectedUrl = browser.baseUrl + '/#/patient?patient_id=' + patientId + '&section=molecular_id&molecular_id=' + molecularId + '#molecular_id_' + molecularId;
        browser.sleep(1500).then(function (){
            expect(browser.getCurrentUrl()).to.eventually.eql(expectedUrl);
        }).then(callback);
    });

    this.Then(/^I expect to see the Torrent Variant Caller Version as "([^"]*)"$/, function (torrent, callback) {
        expect(patientPage.torrentVersion.getText()).to.eventually.eql(torrent.toString()).notify(callback)
    });

    this.Then(/^I expect to see the Pool 1 Total as "([^"]*)"$/, function (total, callback) {
        var expectedTotal = browser.responseData.variant_report.oncomine_control_panel_summary.pool1Sum;
        expect(patientPage.pool1Total.getText()).to.eventually.eql(expectedTotal).notify(callback);
    });

    this.Then(/^I expect to see the Pool 2 Total as "([^"]*)"$/, function (total, callback) {
        var expectedTotal = browser.responseData.variant_report.oncomine_control_panel_summary.pool2Sum;
        expect(patientPage.pool2Total.getText()).to.eventually.eql(expectedTotal).notify(callback);
    });

    this.Then(/^I can see the "(.+?)" table heading$/, function(tableHeading, callback){
        var index = patientPage.expVarReportTables.indexOf(tableHeading);
        expect(patientPage.mainTabSubHeadingArray().get(index).getText())
            .to.eventually
            .eql(patientPage.expVarReportTables[index]).notify(callback)
    });

    this.Then(/^I can see the columns in "(.+?)" table$/, function(tableHeading, callback){
        var index = patientPage.expVarReportTables.indexOf(tableHeading);
        var expected;
        var actual = patientPage.mainTabSubHeadingArray().get(index).element(by.xpath('../..')).all(by.css('th'));
        switch (tableHeading){
            case 'SNVs/MNVs/Indels':
                expected = patientPage.expSNVTableHeadings;
                patientPage.actualTable = element(by.css('vr-filtered-snv-mnv-indel'));
                break;

            case 'Copy Number Variants':
                expected = patientPage.expCNVTableHeadings;
                patientPage.actualTable = element(by.css('vr-filtered-cnv'));
                break;

            case 'Gene Fusions':
                expected = patientPage.expGFTableHeadings;
                patientPage.actualTable = element(by.css('vr-filtered-gf'));
                break;
        };

        actual.getText().then(function(actualArr){
            expect(actualArr).to.eql(expected, "Expected: " + expected + "\nActual: " + actualArr);
        }).then(callback);
    });

    this.Then(/^I collect "(.+?)" data from the backend using using the first row of table as reference$/, function (tableType, callback) {
        patientPage.actualFirstRow = patientPage.actualTable.all(by.css('tbody tr[ng-repeat^="item in filtered"]')).get(0);
        patientPage.actualFirstRow.element(by.css('[link-id="item.identifier"]')).getText().then(function(identifier){
            var table = patientPage.responseData[tableType];
            for (var i = 0; i < table.length; i++){
                if(table[i].identifier === identifier){
                    patientPage.expectedData = table[i];
                    break;
                }
            }
        }).then(callback);
    });

    this.Then(/^I collect "(.+?)" variant data from the backend using using the first row of table as reference$/, function (tableType, callback) {
        patientPage.actualFirstRow = patientPage.actualTable.all(by.css('tbody tr[ng-repeat^="item in filtered"]')).get(0);
        patientPage.actualFirstRow.element(by.css('[link-id="item.identifier"]')).getText().then(function(identifier){
            var table = patientPage.responseData.variant_report[tableType];
            for (var i = 0; i < table.length; i++){
                if(table[i].identifier === identifier){
                    patientPage.expectedData = table[i];
                    break;
                }
            }
        }).then(callback);
    });

    this.Then(/^I verify the data in the SNV table$/, function (callback) {
        var firstRow = patientPage.actualFirstRow.all(by.css('td'));
        var expected = patientPage.expectedData;
        browser.sleep(50).then(function () {
            utilities.checkExpectation(firstRow.get(2), expected.identifier, 'Identifier Mismatch');
//            utilities.checkExpectation(firstRow.get(3), expected.identifier, 'Identifier Mismatch');
            utilities.checkExpectation(firstRow.get(4), expected.chromosome, 'Chromosome Mismatch');
            utilities.checkExpectation(firstRow.get(5), expected.position, 'Position Mismatch');
            utilities.checkExpectation(firstRow.get(6), expected.ocp_reference, 'Reference Mismatch');
            utilities.checkExpectation(firstRow.get(7), expected.ocp_alternative, 'Alternative Mismatch');
            utilities.checkExpectation(firstRow.get(8), utilities.round(expected.allele_frequency, 3), 'Allele Frequency Mismatch');
            utilities.checkExpectation(firstRow.get(9), utilities.integerize(expected.read_depth), 'Read Depth Mismatch');
            utilities.checkExpectation(firstRow.get(10), expected.func_gene, 'Gene Mismatch');
            utilities.checkExpectation(firstRow.get(11), expected.transcript, 'Transcript Mismatch');
            utilities.checkExpectation(firstRow.get(12), expected.hgvs, 'HGVS Mismatch');
            utilities.checkExpectation(firstRow.get(13), expected.protein, 'Protein Mismatch');
            utilities.checkExpectation(firstRow.get(14), expected.exon, 'Exon Mismatch');
            utilities.checkExpectation(firstRow.get(15), expected.oncomine_variant_class, 'Oncomine Mismatch');
            utilities.checkExpectation(firstRow.get(16), expected.function, 'Function Mismatch');
        }).then(callback);
    });

    this.Then(/^I verify the data in the CNV table$/, function (callback) {
        var firstRow = patientPage.actualFirstRow.all(by.css('td'));
        var expected = patientPage.expectedData;
        browser.sleep(50).then(function () {
            utilities.checkExpectation(firstRow.get(2), expected.identifier, 'Identifier Mismatch');
//            utilities.checkExpectation(firstRow.get(3), expected.identifier, 'Identifier Mismatch');
            utilities.checkExpectation(firstRow.get(4), expected.chromosome, 'Chromosome Mismatch');
            utilities.checkExpectation(firstRow.get(5), utilities.integerize(expected.raw_copy_number), 'Raw CN Mismatch');
            utilities.checkExpectation(firstRow.get(6), utilities.round(expected.confidence_interval_5_percent, 3), '5% Mismatch');
            utilities.checkExpectation(firstRow.get(7), expected.copy_number.toString(), 'CN Mismatch');
            utilities.checkExpectation(firstRow.get(8), utilities.round(expected.confidence_interval_95_percent, 3), '95% Mismatch');
        }).then(callback);
    });

    this.Then(/^I verify the data in the Gene Fusions table$/, function (callback) {
        var firstRow = patientPage.actualFirstRow.all(by.css('td'));
        var expected = patientPage.expectedData;
        browser.sleep(50).then(function () {
            utilities.checkExpectation(firstRow.get(2), expected.identifier, 'Identifier Mismatch');
//            utilities.checkExpectation(firstRow.get(3), expected.identifier, 'Identifier Mismatch');
            utilities.checkExpectation(firstRow.get(4), expected.partner_gene, 'Gene2 Mismatch');
            utilities.checkExpectation(firstRow.get(5), expected.driver_gene, 'Gene1  Mismatch');
            utilities.checkExpectation(firstRow.get(6), utilities.integerize(expected.read_depth), 'Read Depth Mismatch');
            utilities.checkExpectation(firstRow.get(7), expected.annotation, 'Annotation Mismatch');
        }).then(callback);
    });

    this.Then(/^I verify the data in the SNV table of QC Report$/, function (callback) {
        var firstRow = patientPage.actualFirstRow.all(by.css('td'));
        var expected = patientPage.expectedData;
        browser.sleep(50).then(function () {
            utilities.checkExpectation(firstRow.get(0), expected.identifier, 'Identifier Mismatch');
//            utilities.checkExpectation(firstRow.get(3), expected.identifier, 'Identifier Mismatch');
            utilities.checkExpectation(firstRow.get(1), expected.chromosome, 'Chromosome Mismatch');
            utilities.checkExpectation(firstRow.get(2), expected.position, 'Position Mismatch');
            utilities.checkExpectation(firstRow.get(3), expected.ocp_reference, 'Reference Mismatch');
            utilities.checkExpectation(firstRow.get(4), expected.ocp_alternative, 'Alternative Mismatch');
            utilities.checkExpectation(firstRow.get(5), expected.filter, 'Filter Mismatch');
            utilities.checkExpectation(firstRow.get(6), utilities.round(expected.allele_frequency, 3), 'Allele Frequency Mismatch');
            utilities.checkExpectation(firstRow.get(7), utilities.integerize(expected.read_depth), 'Read Depth Mismatch');
            utilities.checkExpectation(firstRow.get(8), expected.func_gene, 'Gene Mismatch');
            utilities.checkExpectation(firstRow.get(9), expected.transcript, 'Transcript Mismatch');
            utilities.checkExpectation(firstRow.get(10), expected.hgvs, 'HGVS Mismatch');
            utilities.checkExpectation(firstRow.get(11), expected.protein, 'Protein Mismatch');
            utilities.checkExpectation(firstRow.get(12), expected.exon, 'Exon Mismatch');
            utilities.checkExpectation(firstRow.get(13), expected.oncomine_variant_class, 'Oncomine Mismatch');
            utilities.checkExpectation(firstRow.get(14), expected.function, 'Function Mismatch');
        }).then(callback);
    });

    this.Then(/^I verify the data in the CNV table of QC Report$/, function (callback) {
        var firstRow = patientPage.actualFirstRow.all(by.css('td'));
        var expected = patientPage.expectedData;
        browser.sleep(50).then(function () {
            utilities.checkExpectation(firstRow.get(0), expected.identifier, 'Identifier Mismatch');
//            utilities.checkExpectation(firstRow.get(3), expected.identifier, 'Identifier Mismatch');
            utilities.checkExpectation(firstRow.get(1), expected.chromosome, 'Chromosome Mismatch');
            utilities.checkExpectation(firstRow.get(2), utilities.integerize(expected.raw_copy_number), 'Raw CN Mismatch');
            utilities.checkExpectation(firstRow.get(3), expected.filter, 'Filter Mismatch');
            utilities.checkExpectation(firstRow.get(4), utilities.round(expected.confidence_interval_5_percent, 3), '5% Mismatch');
            utilities.checkExpectation(firstRow.get(5), expected.copy_number.toString(), 'CN Mismatch');
            utilities.checkExpectation(firstRow.get(6), utilities.round(expected.confidence_interval_95_percent, 3), '95% Mismatch');
        }).then(callback);
    });

    this.Then(/^I verify the data in the Gene Fusions table of QC Report$/, function (callback) {
        var firstRow = patientPage.actualFirstRow.all(by.css('td'));
        var expected = patientPage.expectedData;
        browser.sleep(50).then(function () {
            utilities.checkExpectation(firstRow.get(0), expected.identifier, 'Identifier Mismatch');
            utilities.checkExpectation(firstRow.get(1), expected.filter, 'Filter Mismatch');
//            utilities.checkExpectation(firstRow.get(3), expected.identifier, 'Identifier Mismatch');
            utilities.checkExpectation(firstRow.get(2), expected.partner_gene, 'Gene2 Mismatch');
            utilities.checkExpectation(firstRow.get(3), expected.driver_gene, 'Gene1  Mismatch');
            utilities.checkExpectation(firstRow.get(4), utilities.dashifyIfEmpty(utilities.integerize(expected.read_depth)), 'Read Depth Mismatch');
            utilities.checkExpectation(firstRow.get(5), utilities.dashifyIfEmpty(expected.annotation), 'Annotation Mismatch');
        }).then(callback);
    });
    this.Then(/^I verify that all "(.+?)" are "(COSM|COSF|Gene)" Links$/, function (binding, linkType, callback) {
        var testElements = patientPage.actualTable.all(by.css('[link-id="item.' + binding + '"]'));
        if (linkType === 'COSM'){
            testElements.count().then(function (ct) {
                for(var i = 0; i < ct; i++){
                    utilities.checkCosmicLink(testElements.get(i));
                }
            }).then(callback);
        } else if (linkType === 'COSF'){
            testElements.count().then(function (ct) {
                for(var i = 0; i < ct; i++){
                    utilities.checkCOSFLink(testElements.get(i));
                }
            }).then(callback);
        } else if (linkType === 'Gene'){
            testElements.count().then(function (ct) {
                for(var i = 0; i < ct; i++){
                    utilities.checkGeneLink(testElements.get(i));
                }
            }).then(callback);
        }
    });

    this.Then(/^I can see the columns in "(.+?)" table for QC$/, function(tableHeading, callback){
        var index = patientPage.expVarReportTables.indexOf(tableHeading);
        var expected;
        var actual = patientPage.mainTabSubHeadingArray().get(index).element(by.xpath('../..')).all(by.css('th'));
        switch (tableHeading){
            case 'SNVs/MNVs/Indels':
                patientPage.actualTable = element(by.css('vr-qc-snv-mnv-indel'));
                expected = patientPage.expSNVTableHeadings;
                expected.splice(8, 0, 'Filter');
                break;

            case 'Copy Number Variants':
                patientPage.actualTable = element(by.css('vr-qc-cnv'));
                expected = patientPage.expCNVTableHeadings;
                expected.splice(6, 0, 'Filter');
                break;

            case 'Gene Fusions':
                patientPage.actualTable = element(by.css('vr-qc-gf'));
                expected = patientPage.expGFTableHeadings;
                expected.splice(4, 0, 'Filter');
                break;
        };
        // Removing the columns, confirm, Comment and aMOIS
        expected = expected.slice(2);
        expected.splice(1, 1);

        actual.getText().then(function(actualArr){
            expect(actualArr).to.eql(expected, "Expected: " + expected + "\nActual: " + actualArr);
        }).then(callback);
    });

    this.Then(/^I verify that "(.+?)" are proper cosmic links under "(.+?)"$/, function(identifier, variantType,  callback){
        var index = patientPage.expVarReportTables.indexOf(variantType);
        var body = patientPage.mainTabSubHeadingArray().get(index)
            .element(by.xpath('../..'))
            .element(by.css('tbody'));
        var elemArray = body.all(by.css('cosmic-link[link-id="item.' + identifier + '"]'));

        utilities.checkElementArrayisCosf(elemArray).then(callback)
    });


    this.Then(/^I verify that "(.+?)" is a proper Gene link under "(.+?)"$/, function(identifier, variantType, callback){
        var index = patientPage.expVarReportTables.indexOf(variantType);
        var body = patientPage.mainTabSubHeadingArray().get(index)
            .element(by.xpath('../..'))
            .element(by.css('tbody'));
        var elemArray = body.all(by.css('cosmic-link[link-id="item.' + identifier + '"]'));

        elemArray.count().then(function(cnt){
            if (cnt > 0) {
                utilities.checkElementArrayisGene(elemArray).then(callback);
            } else {
                browser.sleep(50).then(callback)
            }
        })
    });


// Template
//    this.Then(/^And I verify that "identifier" are proper cosmic links$/, function(){
//
//    });
};
