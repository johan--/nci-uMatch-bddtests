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

    var variantReportLink


    this.Given (/^I enter "([^"]*)" in the patient filter field$/, function (filterValue, callback) {
        patientPage.patientFilterTextBox.sendKeys(filterValue).then(function () {
            var firstPatient = patientPage.patientGridRows.get(0);
            expect(firstPatient.all(by.binding('item.patient_id')).get(0).getText()).to.eventually.eql(filterValue);
        });
        browser.sleep(50).then(callback);
    });

    this.Then (/^I should see the variant report link for "(.+?)"$/, function (analysisId, callback) {
        console.log(patientPage.responseData);
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
            console.log("This is the count: " + cnt);
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

    this.Then (/^The variant at ordinal "([^"]*)" is checked$/, function (ordinal, callback) {
        var index  = ordinal - 1;
        expect(patientPage.variantConfirmButtonList.get(index).isEnabled()).to.eventually.eql(true);
        browser.sleep(50).then(callback);
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

    this.When (/^The "(.+?)" button is disabled$/, function (buttonText, callback) {
        var button = element(by.buttonText(buttonText));
        browser.sleep(5000).then(function () {
            expect(button.isEnabled()).to.eventually.eql(false).then(callback);
        });


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
};