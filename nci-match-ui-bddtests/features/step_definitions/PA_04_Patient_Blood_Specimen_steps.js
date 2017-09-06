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
    var variantReport;

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
        utilities.waitForElement(patientPage.bloodSpecimenTab, 'Blood Specimen Tab').then(function(presence){
            if(presence === true) {
                patientPage.bloodSpecimenTab.click().then(function(){
                    browser.sleep(200);
                });
            } else {
                expect("Blood Speciment Tab was not found").to.eql("Blood Speciment Tab was found");
            }
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

    this.Then(/^I should see the top level details of the blood variant report$/, function(callback){
        var leftSideDetails = patientPage.bloodVRDetails.get(0).all(by.css('dt'));
        var rightSideDetails = patientPage.bloodVRDetails.get(1).all(by.css('dt'));

        expect(leftSideDetails.count()).to.eventually.eql(patientPage.expectedBloodVRLeftColumn.length);
        expect(rightSideDetails.count()).to.eventually.eql(patientPage.expectedBloodVRRightColumn.length);
        leftSideDetails.getText().then(function(titleArray) {
            expect(titleArray).to.eql(patientPage.expectedBloodVRLeftColumn)
        });

        rightSideDetails.getText().then(function (titleArray) {
            expect(titleArray).to.eql(patientPage.expectedBloodVRRightColumn, 'Expected: ' + patientPage.expectedBloodVRRightColumn + ', Actual: ' + titleArray )
        }).then(callback);
    });

    this.Then(/^I should see the top level data maps to the back end call$/, function (callback) {
        var leftSideData = patientPage.bloodVRDetails.get(0).all(by.css('dd'));
        var rightSideData = patientPage.bloodVRDetails.get(1).all(by.css('dd'));

        var report = browser.responseData.variant_report;
        var moiAmoiCounts = utilities.getMoiCount(report);

        browser.sleep(50).then(function () {
            expect(leftSideData.get(0).getText()).to.eventually.eql(report.molecular_id);
            expect(leftSideData.get(1).getText()).to.eventually.eql(report.analysis_id);
            expect(leftSideData.get(2).getText()).to.eventually.eql(report.variant_report_type);
            expect(leftSideData.get(3).getText()).to.eventually.eql(report.clia_lab + " / " + report.ion_reporter_id);
            expect(leftSideData.get(4).getText()).to.eventually.eql(report.torrent_variant_caller_version);
            expect(leftSideData.get(6).getText()).to.eventually.eql(utilities.returnFormattedDate(report.variant_report_received_date) + ' GMT');
            expect(leftSideData.get(8).getText()).to.eventually.eql(report.status);

            expect(rightSideData.get(0).getText()).to.eventually.eql(report.cellularity);
            expect(rightSideData.get(1).getText()).to.eventually.eql(report.mapd);
            expect(rightSideData.get(2).getText()).to.eventually.eql(moiAmoiCounts.moi.toString());
            expect(rightSideData.get(3).getText()).to.eventually.eql(moiAmoiCounts.confirmedMoi.toString());
        }).then(callback)
    });

    this.Then(/^I collect information about the patient "(.+?)" with blood variant report "(.+?)"$/, function (patientId, reportId, callback) {
        var url = '/api/v1/patients/' + patientId + '/analysis_report/' + reportId;
        utilities.getRequestWithService('patient', url).then(function (response) {
            browser.responseData = response;
            variantReport = response.variant_report;
        }).then(callback)
    });

    this.Then(/^I can see the SNV table for Blood variant report$/, function (callback) {
        var tableHeadings = patientPage.bloodSNVTable.all(by.css('th'));
        expect(tableHeadings.getText()).to.eventually.eql(patientPage.expectedBloodSNVTableColumn).notify(callback);

    });

    this.Then(/^I can see the Gene Fusions table for Blood Variant Report$/, function (callback) {
        var tableHeadings = patientPage.bloodGeneTable.all(by.css('th'));
        expect(tableHeadings.getText()).to.eventually.eql(patientPage.expectedBloodGeneFusions).notify(callback);
    });

    this.Then(/^I can see that the SNV table for Blood variant report matches with the backend$/, function (callback) {
         var snv_data = variantReport.snv_indels;
         var snvTableRows = patientPage.bloodSNVTable.all(by.css('tbody tr'));

         snvTableRows.count().then(function(cnt){
             expect(cnt).to.eql(snv_data.length);
             for(var idx = 0 ; idx < cnt; idx ++){
                 var i = idx;
                 var snvTableData = snvTableRows.get(i).all(by.css('td'));
                 var resultData = snv_data[i];

                 utilities.expectValue(snvTableData.get(1), utilities.dashifyIfEmpty(resultData.comment), 'Comment');
                 utilities.expectValue(snvTableData.get(2), resultData.identifier, 'Identifier');
                 utilities.expectValue(snvTableData.get(3), utilities.dashifyIfEmpty(resultData.chromosome), "Chromosome");
                 utilities.expectValue(snvTableData.get(4), utilities.dashifyIfEmpty(resultData.position), 'Position');
                 utilities.expectValue(snvTableData.get(5), utilities.dashifyIfEmpty(resultData.ocp_reference), 'OCP Ref');
                 utilities.expectValue(snvTableData.get(6), utilities.dashifyIfEmpty(resultData.ocp_alternative), 'OCP, ALT');
                 utilities.expectValue(snvTableData.get(7), utilities.dashifyIfEmpty(parseFloat(resultData.allele_frequency).toFixed(3)), 'Allelle Freq');
                 utilities.expectValue(snvTableData.get(8), utilities.dashifyIfEmpty(parseInt(resultData.read_depth).toString()), 'Read Depth');
                 utilities.expectValue(snvTableData.get(9), utilities.dashifyIfEmpty(resultData.func_gene), 'Gene');
                 utilities.expectValue(snvTableData.get(10), utilities.dashifyIfEmpty(resultData.transcript), 'Transcript');
                 utilities.expectValue(snvTableData.get(11), utilities.dashifyIfEmpty(resultData.hgvs), 'HGVS');
                 utilities.expectValue(snvTableData.get(12), utilities.dashifyIfEmpty(resultData.protein), 'Protein');
                 utilities.expectValue(snvTableData.get(13), utilities.dashifyIfEmpty(resultData.exon), 'Exon');
                 utilities.expectValue(snvTableData.get(14), utilities.dashifyIfEmpty(resultData.oncomine_variant_class), 'OCV');
                 utilities.expectValue(snvTableData.get(15), utilities.dashifyIfEmpty(resultData.function), 'Function');
             }
         }).then(callback);
    });

    this.Then(/^I can see that the Gene table for Blood variant report matches with the backend$/, function (callback) {
        var geneData = variantReport.gene_fusions;
        var geneTableRows = patientPage.bloodGeneTable.all(by.css('tbody tr'));

        geneTableRows.count().then(function(cnt){
            expect(cnt).to.eql(geneData.length);
            for(var idx = 0 ; idx < cnt; idx ++){
                var i = idx;
                var geneTableData = geneTableRows.get(i).all(by.css('td'));
                var resultData = geneData[i];

                utilities.expectValue(geneTableData.get(1), utilities.dashifyIfEmpty(resultData.comment), 'Comment');
                utilities.expectValue(geneTableData.get(2), resultData.identifier, 'Identifier');
                utilities.expectValue(geneTableData.get(3), utilities.dashifyIfEmpty(resultData.partner_gene), 'GENE 1');
                utilities.expectValue(geneTableData.get(4), utilities.dashifyIfEmpty(resultData.driver_gene), 'GENE 2');
                utilities.expectValue(geneTableData.get(5), utilities.dashifyIfEmpty(parseInt(resultData.read_depth).toString()), 'Read Depth');
                utilities.expectValue(geneTableData.get(6), utilities.dashifyIfEmpty(resultData.annotation), 'Annotation');
            }
        }).then(callback);
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
