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
        expect(patientPage.pool1Total.getText()).to.eventually.eql(total).notify(callback);
    });

    this.Then(/^I expect to see the Pool 2 Total as "([^"]*)"$/, function (total, callback) {
        expect(patientPage.pool2Total.getText()).to.eventually.eql(total).notify(callback);
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
                break;

            case 'Copy Number Variants':
                expected = patientPage.expCNVTableHeadings;
                break;

            case 'Gene Fusions':
                expected = patientPage.expGFTableHeadings;
                break;
        };

        actual.getText().then(function(actualArr){
            expect(actualArr).to.eql(expected, "Expected: " + expected + "\nActual: " + actualArr);
        }).then(callback);
    });

    this.Then(/^I verify the "(.+?)" in the Gene Fusions table$/, function (columnName, callback) {
        var body = patientPage.mainTabSubHeadingArray().get(2).element(by.xpath('../..')).element(by.css('tbody'));
        var hashSection   = patientPage.responseData.gene_fusions;

        if (hashSection.length === 0){
            expect(body.getText()).to.eventually.eql('No Gene Fusions').notify(callback);
        } else {
            var expectedArray = [];
            for (var i = 0; i < hashSection.length; i++ ) {
                if ( hashSection[i][columnName] === null || hashSection[i][columnName] === undefined ) {
                    expectedArray.push('-');
                } else {
                    expectedArray.push(hashSection[i][columnName]);
                }
            }
            switch (columnName) {
                case 'identifier':
                    body.all(by.css('cosmic-link[link-id="item.identifier"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'driver_gene':
                    body.all(by.css('cosmic-link[link-id="item.driver_gene"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'partner_gene':
                    body.all(by.css('cosmic-link[link-id="item.partner_gene"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'read_depth':
                    body.all(by.css('[ng-bind="item.driver_read_count | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'annotation':
                    body.all(by.css('[ng-bind="item.annotation | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

            }
        }
    });

    this.Then(/^I verify the "(.+?)" in the Copy Number Variants table$/, function(columnName, callback){
        var body = patientPage.mainTabSubHeadingArray().get(1).element(by.xpath('../..')).element(by.css('tbody'));
        var hashSection   = patientPage.responseData.copy_number_variants;

        if (hashSection.length === 0){
            expect(body.getText()).to.eventually.eql('No Copy Number Variants').notify(callback);
        } else {
            var expectedArray = [];
            for (var i = 0; i < hashSection.length; i++ ) {
                if ( hashSection[i][columnName] === null || hashSection[i][columnName] === undefined ) {
                    expectedArray.push('-');
                } else {
                    expectedArray.push(hashSection[i][columnName]);
                }
            }
            switch (columnName) {
                case 'identifier':
                    body.all(by.css('cosmic-link[link-id="item.identifier"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'chromosome':
                    body.all(by.css('[ng-bind="item.chromosome | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'raw_copy_number':
                    body.all(by.css('[ng-bind="item.raw_copy_number | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'confidence_interval_5percent':
                    body.all(by.css('[ng-bind="item.confidence_interval_5percent | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'copy_number':
                    body.all(by.css('[ng-bind="item.copy_number | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'confidence_interval_95percent':
                    body.all(by.css('[ng-bind="item.confidence_interval_95percent | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;
            }
        }
    });

    this.Then(/^I verify the "(.+?)" in the SNVs\/MNVs\/Indels table$/, function(columnName, callback){
        var body = patientPage.mainTabSubHeadingArray().get(0).element(by.xpath('../..')).element(by.css('tbody'));
        var hashSection   = patientPage.responseData.snv_indels;

        if (hashSection.length > 0){
            expect(body.getText()).to.eventually.eql('No SNVs, MNVs or Indels').notify(callback);
        } else {
            var expectedArray = [];
            for (var i = 0; i < hashSection.length; i++ ) {
                if ( hashSection[i][columnName] === null || hashSection[i][columnName] === undefined ) {
                    expectedArray.push('-');
                } else {
                    expectedArray.push(hashSection[i][columnName]);
                }
            }
            switch (columnName) {
                case 'identifier':
                    body.all(by.css('cosmic-link[link-id="item.identifier"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'chromosome':
                    body.all(by.css('[ng-bind="item.chromosome | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'position':
                    body.all(by.css('[ng-bind="item.position | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'ocp_reference':
                    body.all(by.css('[ng-bind="item.ocp_reference | dashify"')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'ocp_alternative':
                    body.all(by.css('[ng-bind="item.ocp_alternative | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'allele_frequency':
                    body.all(by.css('[ng-bind="item.allele_frequency | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'read_depth':
                    body.all(by.css('[ng-bind="item.read_depth | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'func_gene':
                    body.all(by.css('cosmic-link[link-id="item.func_gene"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'transcript':
                    body.all(by.css('[ng-bind="item.transcript | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'hgvs':
                    body.all(by.css('[ng-bind="item.hgvs | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'protein':
                    body.all(by.css('[ng-bind="item.protein | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;
                case 'exon':
                    body.all(by.css('[ng-bind="item.exon | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'oncomine_variant_class':
                    body.all(by.css('[ng-bind="item.oncomine_variant_class | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

                case 'function':
                    body.all(by.css('[ng-bind="item.function | dashify"]')).getText().then(function(actualArr){
                        expect(actualArr.sort()).to.eql(expectedArray.sort());
                    }).then(callback);
                    break;

            }
        }
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
