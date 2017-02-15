'use strict';
var fs = require('fs');

// Utility Methods
var utilities = require('../../support/utilities');
var dash = require('../../pages/dashboardPage');

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    var callList = {
        "patientStats"       : '/api/v1/patients/statistics',
        "pendingReportStats" : '/api/v1/patients/amois',
        "pendingItems"       : '/api/v1/patients/pending_items',
        "timeline"           : '/api/v1/patients/events?order=desc&num=10'
    };

    // This is all the listing under the patient statistics section on the top banner.
    var listings = dash.statisticsLabels;

    // This is the css identifier (name) for the sub tavbs in the Pending review section.
    var subTabLocator = dash.subTabLocator;

    var reportData;

    this.Then(/^I can see the Dashboard banner$/, function (callback) {
        utilities.waitForElement(dash.dashboardPanel, 'Sticky nav bar').then(function(presence){
            expect(dash.dashboardPanel.isPresent()).to.eventually.eql(true);
        }).then(callback);
    });

    this.Then(/^I can see all sub headings under the top Banner$/, function (callback) {
        var expectedHeadings = ['Patients Statistics', 'Sequenced & Confirmed Patients with aMOIs', 'Top 5 Treatment Arm Accrual'];
        browser.ignoreSynchronization = true;
        for (var i = 0; i < expectedHeadings.length; i++){
            expect(dash.summaryHeadings.get(i).getText()).to.eventually.eql(expectedHeadings[i]);
        };
        browser.sleep(50).then(callback);
    });


    this.Then(/^I can see the Registered Patients count$/, function(callback){
        // browser.ignoreSynchronization = true;
        expect(dash.registeredPatients.getText()).to.eventually.eql(dash.responseData.number_of_patients).then(function(){
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I can see the Patients with Confirmed Variants count$/, function(callback){
        browser.ignoreSynchronization = true;
        expect(dash.patientsWithCVR.getText()).to.eventually.eql(dash.responseData.number_of_patients_with_confirmed_variant_report).then(function(){
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I can see the Patients on Treatment Arms count$/, function(callback){
        browser.ignoreSynchronization = true;
        expect(dash.patientsOnTA.getText()).to.eventually.eql(dash.responseData.number_of_patients_on_treatment_arm).then(function(){
            browser.ignoreSynchronization = false;
        }).then(callback);
    });


    this.Then(/^I can see patients with Pending Tissue Variant Reports$/, function (callback) {
        browser.ignoreSynchronization = true;
        var pendingVRCount = dash.responseData.tissue_variant_reports.length.toString()
        browser.sleep(1000);
        expect(dash.pendingTVRCount.getText()).to.eventually.eql(pendingVRCount).then(function(){
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I can see patients with Pending Blood Specimens$/, function (callback) {
        expect(dash.pendingBVRCount.getText()).to.eventually.eql(dash.responseData.length.toString()).notify(callback);
    });

    this.Then(/^I can see patients with Pending Assignment Reports$/, function (callback) {
        var pendingAssignmentCount = dash.responseData.assignment_reports.length.toString();
        browser.ignoreSynchronization = true;
        expect(dash.pendingAssgnCount.getText()).to.eventually.eql(pendingAssignmentCount).then(function(){
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I can see the Patients Statistics Section$/, function (callback) {
        var expectedStatLabelArray = [
            'Registered Patients:', 'Patients with Confirmed Variant Report:',
            'Patients on Treatment:', 'Pending Tissue Variant Reports:',
            'Pending Assignment Reports:'
        ];
        // removed 'Pending Blood Specimens:', from the above array

        for (var i = 0; i < expectedStatLabelArray.length; i++){
            expect(listings.get(i).getText()).to.eventually.include(expectedStatLabelArray[i]);
        }
        browser.sleep(50).then(callback);
    });

    this.Then(/^I collect "(.+?)" data from backend$/, function(statsType, callback){
        var call = callList[statsType];

        utilities.getRequestWithService('patient', call).then(function(responseBody){
            dash.responseData = responseBody;
        }).then(callback);
    });

    this.Then(/^I can see Sequenced and confirmed patients data$/, function (callback) {
        try {
            browser.sleep(2000).then(function () {
                var amoiLegendList = dash.amoiLegendList;
                var expectedList = dash.responseData.amois;
                browser.ignoreSynchronization = true;
                expect(dash.amoiChart.isPresent()).to.eventually.eql(true);
                expect(amoiLegendList.get(0).getText()).to.eventually.include(expectedList[0] + ' patients');
                expect(amoiLegendList.get(1).getText()).to.eventually.include(expectedList[1] + ' patients');
                expect(amoiLegendList.get(2).getText()).to.eventually.include(expectedList[2] + ' patients');
                expect(amoiLegendList.get(3).getText()).to.eventually.include(expectedList[3] + ' patients');
                expect(amoiLegendList.get(4).getText()).to.eventually.include(expectedList[4] + ' patients');
                expect(amoiLegendList.get(5).getText()).to.eventually.include(expectedList[5] + ' patients');
            }).then(function () {
                browser.ignoreSynchronization = false;
            }).then(callback);
        }
        catch(e){
            console.log(e);
        }
    });

    this.Then(/^I can see the Treatment Arm Accrual chart data$/, function (callback) {
        try{
            var responseSize = Object.keys(dash.responseData.treatment_arm_accrual).length;
            browser.ignoreSynchronization = true;
            browser.sleep(2000).then(function () {
                if (responseSize > 0){
                    expect(dash.accrualChart.isPresent()).to.eventually.eql(true).then(function(){
                        browser.ignoreSynchronization = false;
                    }).then(callback);
                } else {
                    expect(dash.accrualChart.isPresent()).to.eventually.eql(false).then(function(){
                        browser.ignoreSynchronization = false;
                    }).then(callback);
                }
            })
        }
        catch(e) {
            console.log(e).then(callback);
        }
    });

    this.Then(/^I can see the Pending Review Section Heading$/, function (callback) {
        browser.ignoreSynchronization = true;
        var heading = element.all(by.css('.panel-container .ibox-title')).get(0);

        expect(heading.getText()).to.eventually.eql('Pending Review').then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I can see the pending "(.+?)" subtab$/, function (tabName, callback) {
        var tabElement = element(by.css('li[heading^="' + tabName + '"]'));
        browser.ignoreSynchronization = true;
        expect(tabElement.isPresent()).to.eventually.eql(true).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Given(/^I collect information for "(.+?)" Dashboard$/, function (report_type, callback) {
        var request = callList.pendingItems

        utilities.getRequestWithService('patient', request).then(function(responseBody){
            dash.responseData = responseBody;
        }).then(callback);
    });

    this.Then(/^Count of "(.+?)" table match with back end data$/, function (reportType, callback) {
        var pendingReportSections = reportType === "Assignment Reports" ? "assignment_reports" : "tissue_variant_reports"
        var count = dash.responseData[pendingReportSections].length;
        var subtabDataList = element.all(by.id(subTabLocator[reportType])).get(0).all(by.repeater('item in filtered'));
        browser.ignoreSynchronization = true;
        expect(subtabDataList.count()).to.eventually.eql(count).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I select "(.+?)" from the "(.+?)" drop down$/, function (optionValue, reportType, callback) {
        element(by.id(subTabLocator[reportType]))
            .element(by.model('paginationOptions.itemsPerPage'))
            .element(by.cssContainingText('option', optionValue))
            .click().
            then(function(){
                browser.sleep(50)
        }).then(callback);
    });

    this.When(/^I click on the "(.+)" sub\-tab$/, function (reportType, callback) {
        var pendingReviewArray = ['Tissue Variant Reports', 'Assignment Reports'];
        var index = pendingReviewArray.indexOf(reportType);
        var tabHeadingElement = element.all(by.css('li[heading]')).get(index).all(by.css('a')).get(0);

        browser.executeScript('window.scrollTo(0, 300)').then(function(){
            tabHeadingElement.click().then(function() {
                browser.waitForAngular();
                browser.ignoreSynchronization = false;
            })
        }).then(callback)
    });

    this.Then(/^The "(.+)" sub\-tab is active$/, function (reportType, callback) {
        var locator = 'li[heading^="' + reportType + '"]';
        browser.ignoreSynchronization = true;
        utilities.checkElementIncludesAttribute(element(by.css(locator)), "class", 'active').then(function(){
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Given(/^Appropriate Message is displayed for empty or filled pending "(.+)" reports$/, function (reportType, callback) {
        var count = dash.responseData.length;
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
            "Blood Specimens": dash.expectedBloodVRColumns,
            "Assignment Reports" : dash.expectedAssignmentColumns
        };

        var studyElement = element(by.id(subTabLocator[reportType])).all(by.css('th'));
        browser.ignoreSynchronization = true
        for(var i = 0; i < dashboardList[reportType].length; i++){
            expect(studyElement.get(i).getText()).to.eventually.eql(dashboardList[reportType][i]);
        };
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
        browser.ignoreSynchronization = true;
        expect(patient.getText()).to.eventually.eql(patientId).notify(callback);
    });

    this.When(/^I collect information on the timeline$/, function (callback) {
        var url = callList.timeline;
        utilities.getRequestWithService('patient', url).then(function (responseBody) {
            dash.responseData = responseBody;
        }).then(callback);
    });

    this.Then(/^I can see the Activity Feed section$/, function (callback) {
        var feedSection = element(by.css('div[ng-controller="ActivityController as activity"]'));
        var heading = feedSection.element(by.css('h3'));
        browser.ignoreSynchronization = true;
        expect(heading.getText()).to.eventually.eql('Activity Feed').then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I can see "(\d+)" entries in the section$/, function (counter, callback) {
        expect(dash.feedRepeaterList.count()).to.eventually.eql(parseInt(counter)).notify(callback);
    });

    this.Then(/^They match with the timeline response in order$/, function (callback) {
        browser.ignoreSynchronization = true;
        for (var i = 0; i < 10 ; i++) {
            var testPatientId = element.all(by.css('patient-title[text="timelineEvent.entity_id"] .ta-name')).get(i);
            var testMessage   = element.all(by.binding('::timelineEvent.event_message')).get(i);

            var patientId    = dash.responseData[i]['entity_id'];
            var expMessage    = dash.responseData[i]['event_message'];
            expect(testPatientId.getText()).to.eventually.eql(patientId);
            expect(testMessage.getText()).to.eventually.include(expMessage);
        };
        browser.sleep(50).then(callback);
    });

    this.When(/^I collect information on patients in limbo$/, function (callback) {
        var url = '/api/v1/patients/patient_limbos'
        utilities.getRequestWithService('patient', url).then(function (responseBody) {
            //console.log(responseBody);
            dash.responseData = responseBody;
        }).then(callback);
    });

    this.Then(/^I can see table of Patients Awaiting Further Action Or Information$/, function (callback) {
        browser.ignoreSynchronization = true;
        var heading = element.all(by.css('.panel-container .ibox-title')).get(1);
        var tableHeaders = element.all(by.css('#limboPatients th'))
        // Checking for table headings.
        utilities.checkElementArray(tableHeaders, dash.expectedLimboTableColumns);
        // Checking for the Section heading value
        expect(heading.getText()).to.eventually.eql('Patients Awaiting Further Action Or Information').notify(callback);
        browser.ignoreSynchronization = false;
    });

    this.Then(/^I can see a list of patients and the reasons why they are in limbo\.$/, function (callback) {
        browser.ignoreSynchronization = true;
        var dataListElement = dash.patientsInLimboList;

        var limboTableFilter = element(by.xpath('//input[@grid-id="limboPatients"]'));
        var curr_status = element.all(by.binding('item.current_status')).get(0);

        var message = element.all(by.repeater('id in vm.limboMessageIds'));
        //var message = element.all(by.xpath(".//*[@id='limboPatients']/table/tbody/tr[1]/td[4]/limbo-messages"));
        var days_pending = element.all(by.xpath(".//*[@id='limboPatients']/table/tbody/tr[1]/td[5]")).get(0);

        for (var i = 0; i < dash.responseData.length; i++){
            limboTableFilter.clear();
            limboTableFilter.sendKeys(dash.responseData[i]['patient_id']);
            browser.sleep(1000);
            var current_status = dash.responseData[i]['current_status'];
            expect(curr_status.getText()).to.eventually.eql(current_status);

            expect(days_pending.getText()).to.eventually.eql((dash.responseData[i]['days_pending']).toString());

            if ( i === 5 ){
                break;
            }
        };
        browser.ignoreSynchronization = false;
        browser.sleep(50).then(callback);
    });

    this.When(/^I search for "([^"]*)" in the limbo table search field$/, function (searchTerm, callback) {
        var limboTableSearchField = dash.limboTable.element(by.model('filterAll'));
        limboTableSearchField.sendKeys(searchTerm).then(function() {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I should see "([^"]*)" in the limbo table message$/, function (message, callback) {
         var firstRowInLimboTable = dash.limboTable.all(by.css('table tr')).get(0);
         var messageInFirstRow  = firstRowInLimboTable.all(by.repeater('id in vm.limboMessageIds'))
         var expectedMessageArray = message.split(", ");
         messageInFirstRow.getText().then(function(actualMessageArray){
                expect( expectedMessageArray ).to.include(message);
         }).then(callback);
    });
};
