'use strict';
var fs = require('fs');

// Utility Methods
var utilities = require ('../../support/utilities');
var dash = require ('../../pages/dashboardPage');

module.exports = function() {
    this.World = require ('../step_definitions/world').World;

    var patientStats       = utilities.callApi('patient', '/patients/statistics');
    var pendingReportStats = utilities.callApi('patient', '/patients/sequencedAndConfirmedPatients');
    var pendingTissueVR    = utilities.callApi('patient', '/patients/variant_reports?status=PENDING&type=TISSUE');
    var pendingBloodVR     = utilities.callApi('patient', '/patients/variant_reports?status=PENDING&type=BLOOD');
    var pendingAssignment  = utilities.callApi('patient', '/patients/assignment_reports?status=PENDING');
    var timeline           = utilities.callApi('patient', '/patients/timeline');

    // This is all the listing under the patient statistics section on the top banner.
    var listings = dash.statisticsLabels;

    // This is the css identifier (name) for the sub tavbs in the Pending review section.
    var subTabLocator = dash.subTabLocator;

    var reportData;

    this.Then(/^I can see the Dashboard banner$/, function (callback) {
        expect(dash.dashboardPanel().isPresent()).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see all sub headings under the top Banner$/, function (callback) {
        var expectedHeadings = ['Patients Statistics', 'Sequenced & Confirmed Patients with aMOIs', 'Top 5 Treatment Arm Accrual'];
        for (var i = 0; i < expectedHeadings.length; i++){
            expect(dash.summaryHeadings.get(i).getText()).to.eventually.eql(expectedHeadings[i]);
        };
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see the Patients Statistics Section$/, function (callback) {
        var expectedStatLabelArray = [
            'Registered Patients:', 'Patients with Confirmed Variant Report:',
            'Patients on Treatment:', 'Pending Tissue Variant Reports:',
            'Pending Blood Variant Reports:', 'Pending Assignment Reports:'
        ];

        for (var i = 0; i < expectedStatLabelArray.length; i++){
            expect(listings.get(i).getText()).to.eventually.include(expectedStatLabelArray[i]);
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see Patients Statistics data$/, function (callback) {
        patientStats.then(function (stats) {
            var statsJson = JSON.parse(stats);
            expect(listings.get(0).getText()).to.eventually.include(statsJson.number_of_patients);
            expect(listings.get(1).getText()).to.eventually.include(statsJson.number_of_patients_with_confirmed_variant_report);
            expect(listings.get(2).getText()).to.eventually.include(statsJson.number_of_patients_on_treatment_arm);
        });

        pendingTissueVR.then(function (stats){
            expect(listings.get(3).getText()).to.eventually.include(JSON.parse(stats).length);
        });

        pendingBloodVR.then(function (stats){
            expect(listings.get(4).getText()).to.eventually.include(JSON.parse(stats).length);
        });

        pendingAssignment.then(function (stats){
            expect(listings.get(5).getText()).to.eventually.include(JSON.parse(stats).length);
        }).then(callback);
    });

    this.Then(/^I can see Sequenced and confirmed patients data$/, function (callback) {
        pendingReportStats.then(function (stats) {
            var statsJson = JSON.parse(stats);
            expect(element(by.binding('amoi_0')).getText()).to.eventually.eql(statsJson.patients_with_0_amois + ' patients');
            expect(element(by.binding('amoi_1')).getText()).to.eventually.eql(statsJson.patients_with_1_amois + ' patients');
            expect(element(by.binding('amoi_2')).getText()).to.eventually.eql(statsJson.patients_with_2_amois + ' patients');
            expect(element(by.binding('amoi_3')).getText()).to.eventually.eql(statsJson.patients_with_3_amois + ' patients');
            expect(element(by.binding('amoi_4')).getText()).to.eventually.eql(statsJson.patients_with_4_amois + ' patients');
            expect(element(by.binding('amoi_5')).getText()).to.eventually.eql(statsJson.patients_with_5_or_more_amois + ' patients');
        }).then(callback);
    });

    this.Then(/^I can see the Treatment Arm Accrual chart data$/, function (callback) {
        patientStats.then(function(stats){
            var statsJson = JSON.parse(stats);
            if(statsJson.treatment_arm_accrual.length > 0) {
                console.log(statsJson.treatment_arm_accrual);
            }
        }).then(callback);
    });

    this.Then(/^I can see the Pending Review Section Heading$/, function (callback) {
        var heading = element(by.css('.panel-container .ibox-title'));

        expect(heading.getText()).to.eventually.eql('Pending Review');
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see the pending "(.+)" subtab$/, function (tabName, callback) {
        var tabElement = element(by.linkText(tabName));
        expect(tabElement.isPresent()).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Given(/^I collect information for "(.+)" Dashboard$/, function (report_type, callback) {
        var dashboardList = {
          "Tissue Variant Reports": pendingTissueVR,
          "Blood Variant Reports": pendingBloodVR,
          "Assignment Reports" : pendingAssignment
        };
        var response = dashboardList[report_type];
        response.then(function (data) {
            reportData = JSON.parse(data);
        });
        browser.sleep(10).then(callback);
    });

    this.Then(/^Count of "(.+)" table match with back end data$/, function (reportType, callback) {
        var count = reportData.length;
        var subtabDataList = element.all(by.id(subTabLocator[reportType])).get(0).all(by.repeater('item in filtered'));

        expect(subtabDataList.count()).to.eventually.eql(count);
        browser.sleep(20).then(callback);
    });

    this.Then(/^I select "(.+)" from the "(.+)" drop down$/, function (optionValue, reportType, callback) {
        element(by.id(subTabLocator[reportType]))
            .element(by.model('paginationOptions.itemsPerPage'))
            .element(by.cssContainingText('option', optionValue))
            .click().
            then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I click on the "(.+)" sub\-tab$/, function (reportType, callback) {
        var tabHeadingElement = element(by.css('li[heading="' + reportType + '"]'));
        tabHeadingElement.click().then(function () {
           browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^The "(.+)" sub\-tab is active$/, function (reportType, callback) {
        var locator = 'li[heading="' + reportType + '"]';
        utilities.checkElementIncludesAttribute(element(by.css(locator)), "class", 'active').then(callback);
    });

    this.Given(/^Appropriate Message is displayed for empty or filled pending "(.+)" reports$/, function (reportType, callback) {
        var count = reportData.length;
        var gridType = reportType.replace(/\s/g, '').slice(0, -1);
        var cssString = '!pending' + gridType + 'GridOptions.data || !pending' + gridType + 'GridOptions.data.length';
        var studyElement = element(by.css('tr[ng-if="' + cssString + '"]'));

        if (count == 0) {
            expect(studyElement.isPresent()).to.eventually.be.true;
            expect(studyElement.getText()).to.eventually.eql('No pending ' + reportType);
        } else {
            expect(studyElement.isPresent()).to.eventually.be.false;
        }
        browser.sleep(10).then(callback);
    });

    this.Then(/^The "(.+)" data columns are seen$/, function (reportType, callback) {
        var dashboardList = {
            "Tissue Variant Reports": dash.expectedTissueVRColumns,
            "Blood Variant Reports": dash.expectedBloodVRColumns,
            "Assignment Reports" : dash.expectedAssignmentColumns
        };

        var studyElement = element.all(by.id(subTabLocator[reportType])).get(0).all(by.css('th'));

        for(var i = 0; i < dashboardList[reportType].length; i++){
            expect(studyElement.get(i).getText()).to.eventually.eql(dashboardList[reportType][i]);
        }
        browser.sleep(50).then(callback);
    });

    this.When(/^I enter "(.+?)" in the "(.+?)" filter textbox$/, function (searchText, reportType, callback) {
        var searchField = element(by.id(subTabLocator[reportType])).element(by.model('filterAll'));
        searchField.sendKeys(searchText);

        expect(searchField.getAttribute('value')).to.eventually.eql(searchText);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I see that only "(.+?)" row of "(.+?)" data is seen$/, function (counter, reportType, callback) {
        expect(element(by.id(subTabLocator[reportType])).all(by.repeater('item in filtered ')).count())
            .to.eventually.eql(parseInt(counter));
        browser.sleep(50).then(callback);
    });

    this.Then(/^The patient id "(.+?)" is displayed in "(.+?)" table$/, function (patientId, reportType, callback) {
        var patient = element(by.id(subTabLocator[reportType])).element(by.binding('item.patient_id'));
        expect(patient.getText()).to.eventually.eql(patientId);
        browser.sleep(50).then(callback);
    });

    this.When(/^I collect information on the timeline$/, function (callback) {
        timeline.then(function (response) {
            reportData = JSON.parse(response);
        }).then(callback);
    });

    this.Then(/^I can see the Activity Feed section$/, function (callback) {
        var feedSection = element(by.css('div[ng-controller="ActivityController as activity"]'));
        var heading = feedSection.element(by.css('h3'));
        expect(feedSection.isPresent()).to.eventually.be.true;
        expect(heading.getText()).to.eventually.eql('Activity Feed');
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see "(\d+)" entries in the section$/, function (counter, callback) {
        expect(dash.feedRepeaterList.count()).to.eventually.eql(parseInt(counter)).and.notify(callback);
    });

    this.Then(/^They match with the timeline response in order$/, function (callback) {
        for (var i = 0; i < 10 ; i++) {
            var testPatientId = element.all(by.css('patient-title[text="timelineEvent.entity_id"] .ta-name')).get(i);
            var testMessage   = element.all(by.binding('::timelineEvent.event_message')).get(i);

            var patientId    = reportData[i].entity_id;
            var expMessage    = reportData[i].event_message;
            expect(testPatientId.getText()).to.eventually.eql(patientId);
            expect(testMessage.getText()).to.eventually.eql(expMessage);
        };
        browser.sleep(50).then(callback);
    });
};
