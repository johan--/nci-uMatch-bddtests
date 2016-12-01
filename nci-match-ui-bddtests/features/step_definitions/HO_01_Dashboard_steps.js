'use strict';
var fs = require('fs');

// Utility Methods
var utilities = require ('../../support/utilities');
var dash = require ('../../pages/dashboardPage');

module.exports = function() {
    this.World = require ('../step_definitions/world').World;

    var callList = {
        "patientStats"       : '/api/v1/patients/statistics',
        "pendingReportStats" : '/api/v1/patients/amois',
        "pendingTissueVR"    : '/api/v1/patients/variant_reports?status=PENDING&variant_report_type=TISSUE',
        "pendingBloodVR"     : '/api/v1/patients/variant_reports?status=PENDING&variant_report_type=BLOOD',
        "pendingAssignment"  : '/api/v1/patients/assignments?status=PENDING',
        "timeline"           : '/api/v1/patients/events?order=desc&num=10'
    };

    var responseData = [];
    // This is all the listing under the patient statistics section on the top banner.
    var listings = dash.statisticsLabels;

    // This is the css identifier (name) for the sub tavbs in the Pending review section.
    var subTabLocator = dash.subTabLocator;

    var reportData;

    this.Then(/^I can see the Dashboard banner$/, function (callback) {
        browser.ignoreSynchronization = true;
        expect(dash.dashboardPanel.isPresent()).to.eventually.eql(true).notify(callback);

    });

    this.Then(/^I can see all sub headings under the top Banner$/, function (callback) {
        var expectedHeadings = ['Patients Statistics', 'Sequenced & Confirmed Patients with aMOIs', 'Top 5 Treatment Arm Accrual'];
        browser.ignoreSynchronization = true;
        for (var i = 0; i < expectedHeadings.length; i++){
            expect(dash.summaryHeadings.get(i).getText()).to.eventually.eql(expectedHeadings[i]);
        };
        browser.sleep(50).then(callback);
    });

    this.Then(/^I can see Patients Statistics data$/, function (callback) {
        expect(dash.registeredPatients.getText()).to.eventually.eql(responseData.number_of_patients);
        expect(dash.patientsWithCVR.getText()).to.eventually.eql(responseData.number_of_patients_with_confirmed_variant_report);
        expect(dash.patientsOnTA.getText()).to.eventually.eql(responseData.number_of_patients_on_treatment_arm);

        browser.sleep(20).then(callback);
    });

    this.Then(/^I can see patients with Pending Tissue Variant Reports$/, function (callback) {
        expect(dash.pendingTVRCount.getText()).to.eventually.eql(responseData.length.toString()).notify(callback);

    });

    this.Then(/^I can see patients with Pending Blood Specimens$/, function (callback) {
        expect(dash.pendingBVRCount.getText()).to.eventually.eql(responseData.length.toString()).notify(callback);
    });

    this.Then(/^I can see patients with Pending Assignment Reports$/, function (callback) {
        expect(dash.pendingAssgnCount.getText()).to.eventually.eql(responseData.length.toString()).notify(callback);
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
        try {
            var call = callList[statsType];
            call.get().then(function(){
                responseData = JSON.parse(call.entity());
            }).then(callback);
        }
        catch (e) {
            console.log(e);
        }
    });

    this.Then(/^I can see Sequenced and confirmed patients data$/, function (callback) {
        try {
//            browser.ignoreSynchronization = true;
            browser.sleep(1000).then(function () {
                var amoiLegendList = dash.amoiLegendList;
                var expectedList = responseData.amois;
                browser.sleep(2000).then(function () {
                    expect(dash.amoiChart.isPresent()).to.eventually.eql(true);
                    expect(amoiLegendList.get(0).getText()).to.eventually.include(expectedList[0] + ' patients');
                    expect(amoiLegendList.get(1).getText()).to.eventually.include(expectedList[1] + ' patients');
                    expect(amoiLegendList.get(2).getText()).to.eventually.include(expectedList[2] + ' patients');
                    expect(amoiLegendList.get(3).getText()).to.eventually.include(expectedList[3] + ' patients');
                    expect(amoiLegendList.get(4).getText()).to.eventually.include(expectedList[4] + ' patients');
                    expect(amoiLegendList.get(5).getText()).to.eventually.include(expectedList[5] + ' patients');
                });
            }).then(callback);
        }
        catch(e){
            console.log(e);
        }
    });

    this.Then(/^I can see the Treatment Arm Accrual chart data$/, function (callback) {
        try{
            var responseSize = Object.keys(responseData.treatment_arm_accrual).length;
            browser.sleep(2000).then(function () {
                if (responseSize > 0){
                    expect(dash.accrualChart.isPresent()).to.eventually.eql(true).notify(callback);
                } else {
                    expect(dash.accrualChart.isPresent()).to.eventually.eql(false).notify(callback);
                }
            })
        }
        catch(e) {
            console.log(e);
        }
    });

    this.Then(/^I can see the Pending Review Section Heading$/, function (callback) {
        browser.ignoreSynchronization = true;
        var heading = element(by.css('.panel-container .ibox-title'));

        expect(heading.getText()).to.eventually.eql('Pending Review').then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I can see the pending "(.+)" subtab$/, function (tabName, callback) {
        var tabElement = element(by.css('li[heading^="' + tabName + '"]'));
        browser.ignoreSynchronization = true;
        expect(tabElement.isPresent()).to.eventually.eql(true).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Given(/^I collect information for "(.+)" Dashboard$/, function (report_type, callback) {
        var dashboardList = {
          "Tissue Variant Reports": callList.pendingTissueVR,
          "Blood Specimens": callList.pendingBloodVR,
          "Assignment Reports" : callList.pendingAssignment
        };
        var request = dashboardList[report_type];
        request.get().then(function () {
            responseData = JSON.parse(request.entity());
        });
        browser.sleep(10).then(callback);
    });

    this.Then(/^Count of "(.+)" table match with back end data$/, function (reportType, callback) {
        var count = responseData.length;
        var subtabDataList = element.all(by.id(subTabLocator[reportType])).get(0).all(by.repeater('item in filtered'));
        browser.ignoreSynchronization = true;
        expect(subtabDataList.count()).to.eventually.eql(count).then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.Then(/^I select "(.+)" from the "(.+)" drop down$/, function (optionValue, reportType, callback) {
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
        var tabHeadingElement = element.all(by.binding('heading')).get(index);
        browser.ignoreSynchronization = true;
        tabHeadingElement.click().then(function () {
            browser.ignoreSynchronization = false;
        }).then(callback)
    });

    this.Then(/^The "(.+)" sub\-tab is active$/, function (reportType, callback) {
        var locator = 'li[heading="' + reportType + '"]';
        browser.sleep(1000).then(function () {
            utilities.checkElementIncludesAttribute(element(by.css(locator)), "class", 'active').then(callback);
        })
    });

    this.Given(/^Appropriate Message is displayed for empty or filled pending "(.+)" reports$/, function (reportType, callback) {
        var count = responseData.length;
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
        var call = callList.timeline
        call.get().then(function () {
            responseData = JSON.parse(call.entity());
        });
        browser.sleep(10).then(callback);
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

            var patientId    = responseData[i]['entity_id'];
            var expMessage    = responseData[i]['event_message'];
            expect(testPatientId.getText()).to.eventually.eql(patientId);
            expect(testMessage.getText()).to.eventually.include(expMessage);
        };
        browser.sleep(50).then(callback);
    });
};
