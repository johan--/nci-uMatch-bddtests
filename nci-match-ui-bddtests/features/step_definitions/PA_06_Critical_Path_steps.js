/**
 * Created by raseel.mohamed on 9/4/16
 */
'use strict';
var fs = require('fs');

var patientPage = require('../../pages/patientPage');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    this.World = require('../step_definitions/world').World;

    var variantReportLink;
    var assignmentReportLink;
    var assignmentReportPageLink
    var confirmedMoi;
    var confirmedAMoi;
    var currentAnalysisId;

    this.Given(/^I enter "([^"]*)" in the patient filter field$/, function (filterValue, callback) {
        patientPage.patientFilterTextBox.sendKeys(filterValue).then(function () {
            var firstPatient = patientPage.patientGridRows.get(0);
            expect(firstPatient.all(by.binding('item.patient_id')).get(0).getText())
                .to
                .eventually
                .eql(filterValue);
        });
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see and click the variant report link for "(.+?)"$/, function (analysisId, callback) {
        patientPage.variantAnalysisId = analysisId;
        var varRepString = 'li[ng-repeat="'+ patientPage.variantAndAssignmentPanelString + '"] a[href="#/patient/' + patientPage.patientId + '/variant_report?analysis_id=' + analysisId + '"]';
        variantReportLink = element(by.css(varRepString));

        expect(variantReportLink.isPresent()).to.eventually.eql(true).then(function(){
            browser.ignoreSynchronization = false;
            browser.sleep(2000).then(function(){
                variantReportLink.getLocation().then(function(location) {
                    browser.executeScript('window.scrollTo(' + (location.x + 50) + ', ' + (location.y + 50) + ')').then(function(){
                        variantReportLink.element(by.css('i')).click().then(function(){
                            browser.waitForAngular();
                        });
                    });
                });
            });
        }).then(callback);
    });

    this.When(/^I click on the variant report link$/, function (callback) {
        variantReportLink.element(by.css('i.fa.fa-file-text-o')).click().then(function () {
            browser.waitForAngular()
        }).then(callback);
    });

    this.Then(/^I should see the assignment report link for "(.+?)"$/, function (analysisId, callback) {
        patientPage.variantAnalysisId = analysisId;
        var assgnRepString = 'a[href^="#/patient/'+patientPage.patientId+'/variant_report?analysis_id='+analysisId + '&assignment_uuid="]';
        browser.ignoreSynchronization = true;
        assignmentReportLink = element(by.css('dd>' + assgnRepString));
        assignmentReportLink.getAttribute('href').then(function (test) {
            assignmentReportPageLink = test;
        });
        expect(assignmentReportLink.isPresent()).to.eventually.eql(true).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.When(/^I click on the Assignment Report tab "([^"]*)"$/, function (tab, callback) {
        browser.ignoreSynchronization = true;
        browser.sleep(500);
        var cssSelec = 'li[heading="'+tab+'"] > a'
        var assignmentReportTab = element(by.css(cssSelec));
        assignmentReportTab.isPresent().then(function(isVis){
            if(isVis){
                assignmentReportTab.click().then(function () {
                    browser.sleep(10);
                }, function(err){
                    console.log('Unable to click on the Assignment Report tab');
                });
            }
        }).then(callback);
    });

    this.When(/^I click on the assignment report link$/, function (callback) {
        browser.ignoreSynchronization = true;
        browser.executeScript('window.scrollTo(0,5000)').then(function () {
            assignmentReportLink.click().then(function () {
                browser.ignoreSynchronization = true;
                browser.waitForAngular();
            }).then(callback);
        });
    });

    this.When(/^I uncheck the variant of ordinal "([^"]*)"$/, function (ordinal, callback) {
        // ordinal begins at 1, so we have to make it zero based
        var index = parseInt(ordinal) - 1;
        var el = patientPage.variantConfirmButtonCLickList.get(index)
        browser.sleep(2000).then(function(){
            el.getLocation().then(function(location){
                console.log(location);
                browser.executeScript('window.scrollTo(0, ' + (location.y + 300) + ')').then(function(){
                    el.click().then(function(){
                        browser.waitForAngular();
                    });
                });
            });
        }).then(callback);
    });

    this.When(/^I note the ID of the variant at ordinal "([^"]*)"$/, function (ordinal, callback) {
        var index = parseInt(ordinal) - 1;
        patientPage.variantIdentifierList.get(index).getText().then(function (value) {
            patientPage.variantIdentifier = value;
        }).then(callback);
    });

    this.Then(/^I verify that the status of confirmation of that ID is "(confirmed|rejected)"$/, function (confirmed, callback) {
        var status = confirmed === 'confirmed';
        var data = patientPage.combineVariantData(patientPage.responseData);

        for (var idx = 0; idx < data.length; idx++) {
            if (data[idx]['identifier'] === patientPage.variantIdentifier) {
                expect(data[idx]['confirmed'].toString()).to.eql(status.toString());
                break;
            }
        }
        browser.sleep(59).then(callback);
    });

    this.Then(/^I see that all the variant check boxes are selected$/, function (callback) {
        //checking the property of all the checkboxes to make sure they are selected
        patientPage.variantConfirmButtonList.count().then(function (cnt) {
            for (var i = 0; i < cnt; i++) {
                (function (index) {
                    expect(patientPage.variantConfirmButtonList.get(index).isSelected()).to.eventually.eql(true);
                })(i);
            }
        }).then(callback);
    });

    this.Then(/^I "(should|should not)" see the confirmation modal pop up$/, function (seen, callback) {
        var status = seen === 'should';
        expect(patientPage.modalWindow.isPresent()).to.eventually.eql(status).notify(callback);
    });

    this.Then(/^I "(should( not)?)" see the VR confirmation modal pop up$/, function (seen, callback) {
        var status = seen === 'should';
        expect(patientPage.modalWindow.isPresent()).to.eventually.eql(status).then(callback);
    });

    this.Then(/^The variant at ordinal "([^"]*)" is not checked$/, function (ordinal, callback) {
        var index = ordinal - 1;
        expect(patientPage.variantConfirmButtonList.get(index).isSelected()).to.eventually.eql(false);
        browser.sleep(50).then(callback);
    });

    this.Then(/^The variant at ordinal "([^"]*)" is "(unchecked|checked)"$/, function (ordinal, checked, callback) {
        var index = ordinal - 1;
        if (checked === 'checked') {
            expect(patientPage.variantConfirmButtonList.get(index).getAttribute('checked'))
                .to
                .eventually
                .eql('true')
                .notify(callback);
        } else {
            expect(patientPage.variantConfirmButtonList.get(index).getAttribute('checked'))
                .to
                .eventually
                .eql(null)
                .notify(callback);
        }
    });

    this.When(/^I enter the comment "([^"]*)" in the modal text box$/, function (comment, callback) {
        patientPage.confirmChangeCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
    });

    this.When(/^I clear the text in the modal text box$/, function (callback) {
        patientPage.confirmChangeCommentField.clear();
        browser.sleep(50).then(callback);
    });

    this.When(/^I enter the comment "([^"]*)" in the VR modal text box$/, function (comment, callback) {
        patientPage.confirmVRCHangeCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see the comment column in the variant at ordinal "([^"]*)"$/, function (ordinal, callback) {
        var index = ordinal - 1;
        var expectedCommentLink = patientPage.gridElement.get(index).all(by.css(patientPage.commentLinkString));

        expect(expectedCommentLink.get(0).isPresent()).to.eventually.eql(true);
        browser.sleep(50).then(callback);
    });

    this.When(/^I click on the comment link at ordinal "([^"]*)"$/, function (ordinal, callback) {
        browser.ignoreSynchronization = false;
        browser.executeScript('window.scrollTo(0, 5000)').then(function () {
            var index = ordinal - 1;
            var expectedCommentLink = element.all(by.css(patientPage.commentLinkString)).get(index);
            browser.sleep(2000).then(function(){
                    expectedCommentLink.click().then(function () {
                    browser.waitForAngular();
                }).then(callback);
            }).then(callback);
        });
    });

    this.Then(/^I can see the "([^"]*)" in the modal text box$/, function (comment, callback) {
        console.log("comment--> " + comment)
        expect(patientPage.confirmChangeCommentField.getAttribute('value'))
            .to
            .eventually
            .eql(comment)
            .and
            .notify(callback)
    });

    this.When(/^I click on the "([^"]*)" button$/, function (buttonText, callback) {
        element(by.buttonText(buttonText)).click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I "(should( not)?)" see the "(.+?)" button on the VR page$/, function (seeOrNot, _arg1, buttonText, callback) {
        var elementDesc = buttonText === 'REJECT' ? patientPage.rejectReportButton : patientPage.confirmReportButton;
        var status = seeOrNot === 'should';
        expect(elementDesc.isPresent()).to.eventually.eql(status).then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I see the status of Report as "([^"]*)"$/, function (arg1, callback) {
        expect(patientPage.tissueReportStatus.getText()).to.eventually.eql("CONFIRMED").then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I go to the patient "([^"]*)" with variant report "([^"]*)"$/, function (patientId, variantReportId, callback) {
        var uri = '/#/patient/' + patientId + '/variant_report?analysis_id=' + variantReportId;
        patientPage.patientId = patientId;
        patientPage.variantAnalysisId = variantReportId;
        browser.sleep(500).then(function () {
            browser.get(uri).then(function () {
                browser.waitForAngular();
            });
        }).then(callback);
    });

    this.When(/^I go to the patient "([^"]*)" with assignment report "([^"]*)"$/, function (patientId, variantReportId, callback) {
        var uri = '/#/patient/' + patientId + '/variant_report?analysis_id=' + variantReportId + '&section=assignment';
        patientPage.patientId = patientId;
        patientPage.variantAnalysisId = variantReportId;

        browser.get(uri).then(function () {
            browser.waitForAngular();
        }).then(callback);

    });

    this.When(/^I get the link to "(.+?)" assignment report$/, function(assignmentId, callback){
        patientPage.variantAnalysisId = assignmentId;
        var partialLinkString = "#/patient/" + patientPage.patientId + "/variant_report?analysis_id=" + assignmentId + "&assignment_uuid="
        element.all(by.css('[href^="' + partialLinkString + '"]')).get(0).getAttribute('href').then(function(completeAssignmentLink){
            patientPage.completeAssignmentLink = completeAssignmentLink;
        }).then(callback);
    });

    this.When(/^I navigate to the Assignment Report$/, function(callback){
        browser.get(patientPage.completeAssignmentLink).then(callback)
    });

    this.When(/^I set the Analysis Id to be "(.+)"/, function (AnalysisId, callback) {
        patientPage.variantAnalysisId = AnalysisId;
        browser.sleep(50).then(callback);
    });

    this.When(/^I collect information about the patient variant report$/, function (callback) {
        var url = '/api/v1/patients/variant_reports/' + patientPage.variantAnalysisId;

        utilities.getRequestWithService('patient', url).then(function (response) {
            patientPage.responseData = response;
        }).then(callback);
    });

    this.When(/^I collect information about the assignment$/, function (callback) {
        var url = '/api/v1/patients/' + patientPage.patientId + '/analysis_report/' + patientPage.variantAnalysisId;

        utilities.getRequestWithService('patient', url).then(function(response){
            patientPage.responseData = response;
        }).then(callback);
    });

    this.Then(/^I can see the variant report page$/, function (callback) {
        var uri = 'patient/' + patientPage.patientId + '/variant_report?analysis_id=' + patientPage.variantAnalysisId;
        expect(browser.getCurrentUrl()).to.eventually.eql(browser.baseUrl + '/#/' + uri).notify(callback);
    });

    this.Then(/^I can see the assignment report page "([^"]*)"$/, function (assignmentTabTitle, callback) {
        browser.ignoreSynchronization = false;

        // var selectedTabCss = 'uib-tab nav-item ng-scope ng-isolate-scope active';
        var tabHeadingCss = 'li[heading="' + assignmentTabTitle + '"] > a';
        var tab = element(by.css(tabHeadingCss));
        var tabBody = element(by.id('assignment-report'));

        expect(tab.isDisplayed()).to.eventually.eql(true);
        expect(tabBody.isDisplayed()).to.eventually.eql(true).notify(callback);
    });

    this.Then(/^I see that Total MOIs match the number of MOIs on the page$/, function (callback) {
        patientPage.totalMois.getText().then(function (totalMOI) {
            expect(element.all(by.repeater('item in filtered')).count())
                .to
                .eventually
                .eql(parseInt(totalMOI));
        }).then(callback);
    });

    this.Then(/^I see that the Total aMOIs match the number of aMOIs on the page\.$/, function (callback) {
        patientPage.totalAMois.getText().then(function (totalAMOI) {
            expect(patientPage.totalAmoiRows.count()).to.eventually.eql(parseInt(totalAMOI));
        }).then(callback);
    });

    this.Then(/^I get the Total confirmed MOIs on the page$/, function (callback) {
        confirmedMoi = 0;
        element.all(by.repeater('item in filtered')).count().then(function (cnt) {
            for (var index = 0; index < cnt; index++) {
                patientPage.isConfirmedMoi(index).then(function (status) {
                    if (status) {
                        confirmedMoi++
                    }
                });
            }
        }).then(callback);
    });

    this.Then(/^The total number of confirmed MOI has "(decreased|increased)" by "(.+?)"$/, function (change, changedBy, callback) {
        var expectedVal;
        if (change === 'increased') {
            expectedVal = confirmedMoi + parseInt(changedBy);
        } else {
            expectedVal = confirmedMoi - parseInt(changedBy);
        }
        expect(patientPage.totalconfirmedMOIs.getText())
            .to
            .eventually
            .eql(expectedVal.toString())
            .notify(callback);
    });

    this.Then(/^I get the Total confirmed aMOIs on the page$/, function (callback) {
        confirmedAMoi = 0;
        var amoiIndex = [];
        element.all(by.repeater('item in $ctrl.gridOptions.data')).count().then(function (cnt) {
            for (var index = 0; index < cnt; index++) {
                patientPage.isAMoi(index, amoiIndex).then(function () {

                }).then(function () {
                    if (amoiIndex.length > 0) {
                        for (var i = 0; i < amoiIndex.length; i++) {
                            patientPage.isConfirmedMoi(amoiIndex[i]).then(function (status) {
                                if (status) {
                                    confirmedAMoi++
                                }
                            })
                        }
                    }
                });
            }
        }).then(callback);
    });

    this.Then(/^I see that the Total Confirmed MOIs match the number of MOIs on the page$/, function (callback) {
        expect(patientPage.totalconfirmedMOIs.getText())
            .to
            .eventually
            .eql(confirmedMoi.toString())
            .notify(callback);
    });

    this.Then(/^I see that the Total Confirmed aMOIs match the number of aMOIs on the page$/, function (callback) {
        expect(patientPage.totalconfirmedAMOIs.getText())
            .to
            .eventually
            .eql(confirmedAMoi.toString())
            .notify(callback);
    });

    this.Then(/^The variant report status is marked "([^"]*)"$/, function (reportStatus, callback) {
        expect(patientPage.variantReportStatus.get(0).getText())
            .to
            .eventually
            .include(reportStatus)
            .notify(callback);
    });

    this.Then(/^The checkboxes are disabled$/, function (callback) {
        expect(element.all(by.css('check-box-with-confirm button')).count()).to.eventually.be.above(0);
        element.all(by.css('check-box-with-confirm button')).count().then(function (cnt) {
            for (var i = 0; i < cnt; i++) {
                patientPage.expectEnabled(element.all(by.css('check-box-with-confirm button')), i, 'disabled')
            }
        }).then(callback)
    });

    this.Then(/^Total confirmed MOIs and aMOIs are now '(\d+)'$/, function (arg1, callback) {
        expect(patientPage.totalconfirmedMOIs.getText()).to.eventually.eql(arg1.toString());
        expect(patientPage.totalconfirmedAMOIs.getText()).to.eventually.eql(arg1.toString()).notify(callback);
    });

    this.Then(/^I see the confirmation message in the Patient activity feed as "(.+?)" for "(.+?)"$/, function (message, label, callback) {
        var timeline = patientPage.timelineList.get(0);
        var variantReportStatusString = '[ng-if^="timelineEvent.event_data.variant_report_status"]';
        var variantAnalysisIdString = 'span[ng-if^="timelineEvent.event_data.analysis_id"]';
        browser.sleep(3000);

        browser.ignoreSynchronization = true;
        expect(timeline.all(by.css(variantReportStatusString)).get(0).getText()).to.eventually.include(message);
        expect(timeline.all(by.css(variantAnalysisIdString)).get(0)
                .getText()).to.eventually.eql(label)
            .notify(callback);
    });

    this.Then(/^I see the confirmation message in the Dashboard activity feed as "(.+?)" for "(.+?)"$/, function (message, label, callback) {
        var timeline = patientPage.timelineList.get(0);
        var patientString = '[patient-id="timelineEvent.entity_id"]';
        var variantReportStatusString = '[ng-if^="timelineEvent.event_data.variant_report_status"]';
        var variantAnalysisIdString = 'span[ng-if^="timelineEvent.event_data.analysis_id"]';
        expect(timeline.all(by.css(patientString)).get(0).getText()).to.eventually.eql(patientPage.patientId);
        expect(timeline.all(by.css(variantReportStatusString)).get(0).getText()).to.eventually.include(message);
        expect(timeline.all(by.css(variantAnalysisIdString)).get(0)
                .getText()).to.eventually.eql(label)
            .notify(callback);
    });

    this.Then(/^I can see the top level details about assignment report$/, function (callback) {
        var moment = require('moment');
        var assignment = patientPage.responseData.assignments[0];

        var ltSideAssignmentValues = patientPage.assignmentSummaryBoxes.all(by.css('.ng-binding'));

        expect(ltSideAssignmentValues.get(0).getText()).to.eventually.eql(assignment.molecular_id);
        expect(ltSideAssignmentValues.get(1).getText()).to.eventually.eql(assignment.analysis_id);
        expect(ltSideAssignmentValues.get(2).getText()).to.eventually.include(assignment.status).notify(callback);
    });

    this.Then(/^I can see more new top level details about assignment report$/, function (callback) {
        var moment = require('moment');
        var assignment = patientPage.responseData.assignments[0];
        var dateConfirmed = utilities.dashifyIfEmpty(moment.utc(assignment.status_date).utc().format('LLL'));
        var dateGenerated = utilities.dashifyIfEmpty(moment.utc(assignment.assignment_date).utc().format('LLL'));
        var dateSentToCOG = utilities.dashifyIfEmpty(moment.utc(assignment.sent_to_cog_date).utc().format('LLL'));

        var ltSideAssignmentValues = patientPage.assignmentSummaryBoxes.all(by.css('.ng-binding'));

        expect(ltSideAssignmentValues.get(0).getText()).to.eventually.eql(assignment.molecular_id);
        expect(ltSideAssignmentValues.get(1).getText()).to.eventually.eql(assignment.analysis_id);
        expect(ltSideAssignmentValues.get(2).getText()).to.eventually.include(assignment.status);

        expect(ltSideAssignmentValues.get(5).getText()).to.eventually.include(dateConfirmed);

        expect(ltSideAssignmentValues.get(6).getText()).to.eventually.include(dateGenerated);
        expect(ltSideAssignmentValues.get(7).getText()).to.eventually.include(dateSentToCOG).notify(callback);

    });

    this.Then(/^I can see the selected Treatment arm id "([^"]*)" and stratum "([^"]*)" and version "([^"]*)" in a box with reason$/, function (taId, stratum, version, callback) {
        var expectedString = 'Selected Treatment Arm: ' + taId + '-' + stratum + ' (' + version + ')';
        expect(patientPage.selectedAssignmentBoxHeader.getText()).to.eventually.eql(expectedString);
        expect(patientPage.selectedAssignmentBoxText.getText())
            .to.eventually.eql(patientPage.responseData.patient.current_assignment.reason)
            .notify(callback);

    });

    this.Then(/^I can see the Assignment Logic section$/, function (callback) {
        expect(element.all(by.css('.panel-body h3')).get(4).getText())
            .to
            .eventually
            .eql('Assignment Logic')
            .notify(callback);
    });

    this.Then(/^I can see the selected treatment arm and the reason$/, function (callback) {
        var selectedTA = patientPage.responseData.patient.current_assignment;
        var taString = selectedTA.treatment_arm_id + ' (' + selectedTA.stratum_id + ', ' + selectedTA.version + ')'

        expect(patientPage.ruleNameList.get(0).getText()).to.eventually.include('SELECTED');
        expect(patientPage.ruleDetailsList.get(0).all(by.css('.content-cell')).get(0).getText())
            .to
            .eventually
            .eql(taString)
            .notify(callback);
    });

    this.Then(/^The Types of Logic is the same as the backend$/, function (callback) {
        var assignmentResults = patientPage.responseData.assignments[0].treatment_assignment_results;
        var reasons = Object.keys(assignmentResults);

        utilities.checkInclusiveElementArray(patientPage.ruleNameList, reasons);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I "([^"]*)" see the Assignment report "([^"]*)" button$/, function (status, buttonText, callback) {
        browser.sleep(500);
        var present = status === 'should';
        var elementDesc = patientPage.assignmentReportConfirmButton;
        expect(elementDesc.isPresent()).to.eventually.eql(present).notify(callback);
    });

    this.When(/^I click on the Assignment report "([^"]*)" button$/, function (buttonText, callback) {
        element(by.buttonText(buttonText)).click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I "(should|should not)" see the patient "([^"]*)" as "([^"]*)"$/, function (presence, field, value, callback) {
        var status = presence == 'should';
        var patientDetailArray = ['Patient ID', 'Patient', 'Status', 'Current Step', 'Treatment Arm Id', 'Stratum Id', 'Version']
        var index = patientDetailArray.indexOf(field)

        if (status === true) {
            expect(patientPage.patientSummaryTable.all(by.css('.ng-binding')).get(index).getText())
                .to
                .eventually
                .include(value)
                .notify(callback);
        } else {
            patientPage.patientSummaryTable.all(by.css('.ng-binding')).get(index).getText().then(function (text) {
                expect(text).to.not.eql(value);
            }).then(callback);
        }
    });

    this.When(/^I click the assignment report tab "(.+?)"$/, function (assignmentTabTitle, callback) {
        browser.ignoreSynchronization = true;
        browser.sleep(5000);
        var cssSelec = 'li[heading="' + assignmentTabTitle + '"] > a';
        var tab = element(by.css(cssSelec));
        tab.isPresent().then(function (isVisible) {
            if (isVisible) {
                tab.click().then(function () {
                    browser.sleep(10);
                }, function (err) {
                    console.log('Unable to click on the assignment report tab');
                });
            }
        }).then(callback);
    });
};
