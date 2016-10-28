/**
 * Created by raseel.mohamed on 9/4/16
 */
'use strict';
var fs = require('fs');

var patientPage = require ('../../pages/patientPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    this.World = require ('../step_definitions/world').World;

    var variantReportLink;
    var confirmedMoi;
    var confirmedAMoi;
    var currentAnalysisId;


    this.Given (/^I enter "([^"]*)" in the patient filter field$/, function (filterValue, callback) {
        patientPage.patientFilterTextBox.sendKeys(filterValue).then(function () {
            var firstPatient = patientPage.patientGridRows.get(0);
            expect(firstPatient.all(by.binding('item.patient_id')).get(0).getText()).to.eventually.eql(filterValue);
        });
        browser.sleep(50).then(callback);
    });

    this.Then (/^I should see the variant report link for "(.+?)"$/, function (analysisId, callback) {
        patientPage.variantAnalysisId = analysisId;
        var varRepString = 'div[ng-if="surgicalEvent"] a[href="#/patient/' + patientPage.patientId + '/variant_report?analysis_id=' + analysisId;
        variantReportLink = element(by.css(varRepString))
        expect(variantReportLink.isPresent()).to.eventually.eql(true).notify(callback);
    });

    this.When(/^I should click on the variant report link$/, function (callback) {
       variantReportLink.click().then(callback);
    });

    this.Then(/^the variant table is updated for that variant to "([^"]*)"$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.When (/^I uncheck the variant of ordinal "([^"]*)"$/, function (ordinal, callback) {
        // ordinal begins at 1
        var index = parseInt(ordinal) - 1 ;
        patientPage.variantConfirmButtonCLickList.get(index).click().then(function () {
            browser.waitForAngular()
        }).then(callback);

    });

    this.Then(/^I see that all the variant check boxes are selected$/, function (callback) {
        //checking the property of all the checkboxes to make sure they are selected
        patientPage.variantConfirmButtonList.count().then(function (cnt) {
            for(var i = 0; i < cnt; i++){
                expect(patientPage.variantConfirmButtonList.get(i).isEnabled()).to.eventually.eql(true);
            }
        }).then(callback);
    });

    this.Then (/^I "(should( not)?)" see the confirmation modal pop up$/, function (seen, callback) {
        var status = seen === 'should';

        expect(patientPage.modalWindow.isPresent()).to.eventually.eql(status).then(callback);
    });

    this.Then (/^I "(should( not)?)" see the VR confirmation modal pop up$/, function (seen, callback) {
        var status = seen === 'should';
        expect(patientPage.modalWindow.isPresent()).to.eventually.eql(status).then(callback);
    });

    this.Then (/^The variant at ordinal "([^"]*)" is not checked$/, function (ordinal, callback) {
        var index  = ordinal - 1;
        expect(patientPage.variantConfirmButtonList.get(index).isSelected()).to.eventually.eql(false);
        browser.sleep(50).then(callback);
    });

    this.Then (/^The variant at ordinal "([^"]*)" is "(unchecked|checked)"$/, function (ordinal, checked, callback) {
        var index  = ordinal - 1;
        if(checked === 'checked'){
            expect(patientPage.variantConfirmButtonList.get(index).getAttribute('checked')).to.eventually.eql('true').notify(callback);
        }else {
            expect(patientPage.variantConfirmButtonList.get(index).getAttribute('checked')).to.eventually.eql(null).notify(callback);
        }

    });

    this.When (/^I enter the comment "([^"]*)" in the modal text box$/, function (comment, callback) {
        patientPage.confirmChangeCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
    });

    this.When (/^I clear the text in the modal text box$/, function (callback) {
        patientPage.confirmChangeCommentField.clear();
        browser.sleep(50).then(callback);
    });

    this.When (/^I enter the comment "([^"]*)" in the VR modal text box$/, function (comment, callback) {
        patientPage.confirmVRCHangeCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
    });

    this.Then (/^I can see the comment column in the variant at ordinal "([^"]*)"$/, function (ordinal, callback) {
        var index = ordinal - 1;
        var expectedCommentLink = patientPage.gridElement.get(index).all(by.css(patientPage.commentLinkString));

        expect(expectedCommentLink.get(0).isPresent()).to.eventually.eql(true);
        browser.sleep(50).then(callback);
    });

    this.When (/^I click on the comment link at ordinal "([^"]*)"$/, function (ordinal, callback) {
        var index = ordinal - 1;
        var expectedCommentLink = patientPage.gridElement.get(index).all(by.css(patientPage.commentLinkString));
        expectedCommentLink.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then (/^I can see the "([^"]*)" in the modal text box$/, function (comment, callback) {
        expect(patientPage.confirmChangeCommentField.getAttribute('value')).to.eventually.eql(comment).and.notify(callback)
    });

    this.When (/^I click on the "([^"]*)" button$/, function (buttonText, callback) {
        element(by.buttonText(buttonText)).click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then (/^I "(should( not)?)" see the "(.+?)" button on the VR page$/, function (seeOrNot, _arg1, buttonText, callback) {
        var elementDesc = buttonText === 'REJECT' ? patientPage.rejectReportButton : patientPage.confirmReportButton;
        var status = seeOrNot === 'should';

        expect(elementDesc.isPresent()).to.eventually.eql(status).then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When (/^The "(.+?)" button is "(disabled|enabled)"$/, function (buttonText, abled, callback) {
        var button = element(by.buttonText(buttonText));
        var status = abled === 'enabled' ? true : false;

        expect(button.isEnabled()).to.eventually.eql(status).notify(callback);
    });

    this.Then (/^I see the status of Report as "([^"]*)"$/, function (arg1, callback) {
        expect(patientPage.tissueReportStatus.getText()).to.eventually.eql("CONFIRMED").then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then (/^I can see the name of the commenter is present$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback.pending ();
    });

    this.When(/^I go to the patient "([^"]*)" with variant report "([^"]*)"$/, function (patientId, variantReportId, callback) {
        var uri                       = '/#/patient/' + patientId + '/variant_report?analysis_id=' + variantReportId;
        patientPage.patientId         = patientId;
        patientPage.variantAnalysisId = variantReportId;
        console.log(uri);
        browser.sleep(3000).then(function () {
            browser.get(uri).then(function () {
                browser.waitForAngular ();
            });
        }).then(callback);
    });

    this.Then(/^I can see the variant report page$/, function(callback) {
        var uri = 'patient/' + patientPage.patientId + '/variant_report?analysis_id=' + patientPage.variantAnalysisId;
        expect (browser.getCurrentUrl ()).to.eventually.eql (browser.baseUrl + '/#/' + uri).notify(callback);
    });

    this.Then(/^I see that Total MOIs match the number of MOIs on the page$/, function (callback) {
        patientPage.totalMois.getText().then(function (totalMOI) {
            expect(element.all(by.repeater('item in $ctrl.gridOptions.data')).count()).to.eventually.eql(parseInt(totalMOI));
        }).then(callback);
    });

    this.Then(/^I see that the Total aMOIs match the number of aMOIs on the page\.$/, function (callback) {
        patientPage.totalAMois.getText().then(function (totalAMOI) {
            expect(element.all(by.css('td>[treatment-arms="item.amois"]')).count()).to.eventually.eql(parseInt(totalAMOI));
        }).then(callback);
    });

    this.Then(/^I get the Total confirmed MOIs on the page$/, function (callback) {
        confirmedMoi = 0;
        element.all(by.repeater('item in $ctrl.gridOptions.data')).count().then(function (cnt) {
            for(var index = 0; index < cnt; index ++){
                patientPage.isConfirmedMoi(index).then(function (status) {
                    if (status) {
                        confirmedMoi++
                    }
                });
            };
        }).then(callback);
    });

    this.Then(/^The total number of confirmed MOI has "(decreased|increased)" by "(.+?)"$/, function (change, changedBy, callback) {
        var expectedVal;
        if(change === 'increased'){
            expectedVal = confirmedMoi + parseInt(changedBy);
        } else{
            expectedVal = confirmedMoi - parseInt(changedBy);
        }
        expect(patientPage.totalconfirmedMOIs.getText()).to.eventually.eql(expectedVal.toString()).notify(callback);
    });

    this.Then(/^I get the Total confirmed aMOIs on the page$/, function (callback) {
        confirmedAMoi = 0;
        var amoiIndex = []
        element.all(by.repeater('item in $ctrl.gridOptions.data')).count().then(function (cnt) {
            for(var index = 0; index < cnt; index ++){
                patientPage.isAMoi(index, amoiIndex).then(function () {

                }).then(function () {
                    if (amoiIndex.length > 0){
                        for(var i = 0; i < amoiIndex.length; i++){
                            patientPage.isConfirmedMoi(amoiIndex[i]).then(function (status) {
                                if(status){
                                    confirmedAMoi++
                                }
                            })
                        }
                    }
                });
            };
        }).then(callback);
    });

    this.Then(/^I see that the Total Confirmed MOIs match the number of MOIs on the page$/, function (callback) {
        expect(patientPage.totalconfirmedMOIs.getText()).to.eventually.eql(confirmedMoi.toString()).notify(callback);
    });

    this.Then(/^I see that the Total Confirmed aMOIs match the number of aMOIs on the page$/, function (callback) {
        expect(patientPage.totalconfirmedAMOIs.getText()).to.eventually.eql(confirmedAMoi.toString()).notify(callback);
    });

    this.Then(/^The variant report status is marked "([^"]*)"$/, function (reportStatus, callback) {
        expect(patientPage.variantReportStatus.get(0).getText()).to.eventually.include(reportStatus).notify(callback);
    });

    this.Then(/^The checkboxes are disabled$/, function (callback) {
        element.all(by.css('check-box-with-confirm button')).count().then(function (cnt) {
            for(var i = 0; i < cnt; i ++){
                console.log('element at index: ' + i);
                patientPage.expectEnabled(element.all(by.css('check-box-with-confirm button')), i, 'disabled')
            }
        }).then(callback)
    });

    this.Then(/^I see the confirmation message in the Patient activity feed$/, function (callback) {
        var timeline = patientPage.timelineList.get(0);
        var variantReportStatusString = '[ng-if="timelineEvent.event_data.variant_report_status"]';
        var variantAnalysisIdString   = 'span[ng-if="timelineEvent.event_data.analysis_id"]';

        timeline.all(by.css(variantAnalysisIdString)).getText().then(function (test) {
            console.log(test);
        });
        browser.ignoreSynchronization = true;
        expect(timeline.all(by.css(variantReportStatusString)).get(0).getText()).to.eventually.include('CONFIRMED');
        expect(timeline.all(by.css(variantAnalysisIdString)).get(0)
            .getText()).to.eventually.eql('Analysis ID: ' + patientPage.variantAnalysisId)
            .notify(callback);
    });

    this.Then(/^I see the confirmation message in the Dashboard activity feed$/, function (callback) {
        var timeline = patientPage.timelineList.get(0);
        var patientString = '[patient-id="timelineEvent.entity_id"]';
        var variantReportStatusString = '[ng-if="timelineEvent.event_data.variant_report_status"]';
        var variantAnalysisIdString   = 'span[ng-if="timelineEvent.event_data.analysis_id"]';
        browser.ignoreSynchronization = true;
        expect(timeline.all(by.css(patientString)).get(0).getText()).to.eventually.eql(patientPage.patientId);
        expect(timeline.all(by.css(variantReportStatusString)).get(0).getText()).to.eventually.include('CONFIRMED');
        expect(timeline.all(by.css(variantAnalysisIdString)).get(0)
            .getText()).to.eventually.eql('Analysis ID: ' + patientPage.variantAnalysisId)
            .notify(callback);
    });
};
