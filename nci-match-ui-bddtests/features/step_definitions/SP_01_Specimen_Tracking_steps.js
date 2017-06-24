/**
 * Created by raseel.mohamed on 9/4/16
 */
'use strict';
var fs = require('fs');

var STPage = require('../../pages/specimenTrackingPage');

// Utility Methods
var utilities = require('../../support/utilities');

module.exports = function () {
    this.World          = require('../step_definitions/world').World;
    var shippingSection = STPage.topHeaderInfoBox.get (0);
    var trendAnalysis   = STPage.topHeaderInfoBox.get (1);
    var shipmentSection = STPage.shipmentsSection;
    var shipmentTable   = STPage.shipmentTableElement;
    var shippingJSONResponse;
    var expectedResponse;
    var actualSelectedArray;
    var patientId;
    var surgicalEventId;

    this.When (/^I collect information about shipment$/, function (callback) {
        utilities.getRequestWithService('patient', '/api/v1/patients/shipments').then(function (responseBody) {
            shippingJSONResponse = responseBody
        }).then (callback);
    });

    this.When (/^I enter "(.+?)" from response at index "(.+?)" in the search field$/, function (key, index, callback) {
        expectedResponse = shippingJSONResponse[ index ];
        console.log (expectedResponse);
        var molecularId = expectedResponse[ key ];
        var filter      = element.all (by.model ('filterAll'));
        filter.sendKeys (molecularId).then (function () {
            browser.waitForAngular ()
        }).then (callback);
    });

    this.When(/^I enter the first available "(.+?)" in the search table$/, function (key, callback) {
        for (var i = 0; i < shippingJSONResponse.length; i++ ){
            if (shippingJSONResponse[i][key] !== undefined ){
                expectedResponse = shippingJSONResponse [i];
                break;
            }
        }
        var keyValue = expectedResponse[ key ];
        var filter      = element.all (by.model ('filterAll'));
        filter.sendKeys (keyValue).then (function () {
            browser.waitForAngular ()
        }).then (callback);
    });

    this.When(/^I enter "(.+?)" as Patient Id in the search field for tracking table$/, function (searchString, callback) {
        patientId = searchString;
        STPage.searchField.sendKeys(searchString).then(function () {
            browser.sleep(500)
        }).then(callback);
    });

    this.Then (/^I see the Shipping Location section$/, function (callback) {
        expect (shippingSection.isPresent ()).to.eventually.eql (true);
        expect (shippingSection.all (by.css ('h3')).get (0).getText ()).to.eventually.eql ('Shipping Locations');
        browser.sleep (50).then (callback);
    });

    this.Then (/^I see the Trend Analysis section$/, function (callback) {
        expect (trendAnalysis.isPresent ()).to.eventually.eql (true);
        expect (trendAnalysis.all (by.css ('h3')).get (0).getText ()).to.eventually.eql ('Trend Analysis');
        browser.sleep (50).then (callback);
    });

    this.Then (/^I can see the Distribution of specimens between sites$/, function (callback) {
        shipmentBySite ().then (function (details) {
            console.log (details);
            var total           = details.mda + details.mocha;
            var mdaPercentage   = total === 0 ? 0 : Math.round (details.mda * 100 / total);
            var mochaPercentage = total === 0 ? 0 : Math.round (details.mocha * 100 / total);
            console.log ('mdaPercentage: ' + mdaPercentage);
            console.log ('mochaPercentage: ' + mochaPercentage)
            expect (shippingSection.all (by.css ('.font-bold.no-margins.ng-binding')).get (0).getText ())
                .to
                .eventually
                .eql (mdaPercentage + '%');

            expect (shippingSection.all (by.css ('.font-bold.no-margins.ng-binding')).get (1).getText ())
                .to
                .eventually
                .eql (mochaPercentage + '%');

            expect (shippingSection.all (by.css ('.m-xs.ng-binding')).get (0).getText ())
                .to
                .eventually
                .eql (details.mda.toString ());

            expect (shippingSection.all (by.css ('.m-xs.ng-binding')).get (1).getText ())
                .to
                .eventually
                .eql (details.mocha.toString ());

            browser.sleep (500);
        }).then (callback);
    });

    this.Then (/^I can see the chart at index "(.+?)" is for "(.+?)"$/, function (index, siteName, callback) {
        var idx = parseInt (index);
        expect (shippingSection.all (by.css ('a[ui-sref="clia-labs"]')).get (idx).getText ())
            .to
            .eventually
            .eql (siteName)
            .notify (callback);
    });

    this.Then (/^I can see the Shipment table headers$/, function (callback) {
        var headers        = shipmentTable.all (by.css ('th.sortable'));
        var expectedHeader = STPage.shipmentTableHeaderList;

        browser.driver.manage().window().maximize()

        for (var u = 0; u < expectedHeader.length; u++) {
            utilities.moveAndCheckElement (headers, u, expectedHeader[ u ])
        }

        browser.sleep (50).then (callback);
    });

    this.Then (/^I can see the Shipments table$/, function (callback) {
        expect (shipmentTable.element (by.css ('.table-striped')).isPresent ())
            .to
            .eventually
            .eql (true)
            .notify (callback);
    });

    this.Then (/^I can see the Shipment Table Heading$/, function (callback) {
        expect (shipmentSection.element (by.css ('h3')).getText ()).to.eventually.eql ('Shipments').notify (callback);
    });

    this.Then (/^I can compare the details about shipment against the API$/, function (callback) {
        var moment            = require('moment');
        var actualElementList = element.all (by.repeater ('item in filtered')).get (0).all (by.css ('td'));
        var elementList       = [ 'molecular_id', 'slide_barcode', 'surgical_event_id', 'patient_id', 'collected_date',
            'received_date', 'speciment_type', 'shipped_date', 'destination', 'tracking_id',
            'pathology_status', 'pathology_status_date'
        ];
        var expectedValue;

        for (var i = 0; i < elementList.length; i++) {
            var elem = elementList[ i ];
            if (elem.match (/_date/)) {
                expectedValue = expectedResponse[ elem ] === undefined ? utilities.dashifyIfEmpty (expectedResponse[ elem ]) : moment.utc (expectedResponse[ elem ])
                    .utc ()
                    .format ('LLL') + ' GMT';
            } else {
                expectedValue = utilities.dashifyIfEmpty (expectedResponse[ elem ]);
            }
            utilities.moveAndCheckElement (actualElementList, i, expectedValue)
        }
        browser.sleep (50).then (callback);
    });

    this.Then(/^I expect to see "(.+?)" rows in the tracking table$/, function (count, callback) {
        expect(STPage.tableElementList.count()).to.eventually.eql(parseInt(count)).notify(callback);
    });

    this.When(/^I click on the surgical event in the row "([^"]*)"$/, function (rowNum, callback) {
        STPage.searchResultsSurgicalEventList.get(rowNum - 1).click().then(function(){
            browser.waitForAngular();
        }).then(callback)
    });

    this.Then(/^I verify that I am taken directly to "([^"]*)" page$/, function (arg1, callback) {
        surgicalEventId = arg1;
        var expectedString = 'patient_id=' + patientId + '&section=surgical_event&surgical_event_id=' + surgicalEventId;
        expect(browser.getCurrentUrl()).to.eventually.include(expectedString).notify(callback);
    });

    this.Then(/^I verify that surgical event tab is active$/, function(callback){
        var subTabName = "Surgical Event " + surgicalEventId;
        var subTabElement = element.all(by.css('li[ng-repeat="specimenEvent in specimenEvents"]')).get(0)
        expect(subTabElement.getText()).to.eventually.include(surgicalEventId);
        utilities.checkElementIncludesAttribute(subTabElement, 'class', 'active');
        browser.sleep(50).then(callback);
    })

    this.Then(/^I expect to see "(.+?)" rows with patient id of "(.+?)" for the specimens$/, function (cont, patientId, callback) {
        STPage.tableElementList.all(by.binding('item.patient_id')).filter(function (elem, index) {
            return(elem.getText().then(function (text) {
                return text === patientId
            }))
        }).then(function(arra){
            actualSelectedArray = arra;
            expect(arra.length).to.eql(parseInt(cont))
        }).then(callback);
    });

    this.Then(/^I expect to see "(.+?)" rows with surgical ids of "([^"]*)" for both specimens$/, function (cnt, surgicalId, callback) {
        STPage.tableElementList.all(by.css('[ng-bind^="item.surgical_event_id"]')).filter(function (elem, index) {
            return (elem.getText().then(function (text) {

                return text === surgicalId
            }))
        }).then(function(arra){
            actualSelectedArray = arra;
            expect(arra.length).to.eql(parseInt(cnt))
        }).then(callback);
    });

    this.Then(/^I expect to see Molecular Ids of "([^"]*)" in the table\.$/, function (molecularIds, callback) {
        var elementList = STPage.tableElementList.all(by.binding('item.molecular_id'))
        var molecularIdList = molecularIds.split(',')

        browser.waitForAngular().then(function() {
            utilities.checkIfElementListInExpectedArray(elementList, molecularIdList);
        }).then(callback);

    });

    this.Then(/^I can see Specimens, CLIA Lab and Slide Shipment tabs$/, function (callback) {
         STPage.topLvlTabElemList.getText().then(function(list){
            expect(list).to.eql(STPage.topLevelTabsList);
         }).then(callback);
    });

    this.When(/^I click on "([^"]*)" tab$/, function (tabName, callback) {
        var linkIndex = STPage.topLevelTabsList.indexOf(tabName);
        STPage.topLvlTabElemList.get(linkIndex).click().then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^the "([^"]*)" tab becomes active$/, function (tabName, callback) {
        var linkIndex = STPage.topLevelTabsList.indexOf(tabName)
        expect(STPage.topLvlTabElemList.get(linkIndex).getAttribute('class')).to.eventually.include('active').notify(callback);
    });

    this.Then(/^I can see the "(.+?)" table columns$/, function ( tableType, callback) {
        var expectedArray;
        switch (tableType){
            case 'Specimens':
                expectedArray   = STPage.expectedSpecimensTableHeaders;
                STPage.actualTable     = STPage.specimenTableElement;
                break;

            case 'CLIA Lab Shipments':
                expectedArray   = STPage.expectedCliaLabTableHeaders;
                STPage.actualTable     = STPage.cliaLAbTableElement;
                break;

            case 'Slide Shipments':
                expectedArray   = STPage.expectedSlideShipmentHeaders;
                STPage.actualTable     = STPage.slideShipTableElement;
                break;
        }
        STPage.actualTable.all(by.css('thead th')).getText().then(function(headers){
            expect(headers).to.eql(expectedArray, 'Expected: ' + expectedArray + '\nActual: ' + headers)
        }).then(callback);
    });

    this.When(/^I collect information on specimens used for shipments$/, function (callback) {
        var uri = '/api/v1/patients/specimens';
        utilities.getRequestWithService('patient', uri).then(function (response) {
            STPage.responseData = response;
        }).then(callback);
    });

    this.When(/^I collect information on shipment used for shipments$/, function (callback) {
        var uri = '/api/v1/patients/shipments';
        utilities.getRequestWithService('patient', uri).then(function (response) {
            STPage.responseData = response;
        }).then(callback);
    });

    this.Then(/^I search for "(.+?)" in the search field$/, function (query, callback) {
        var searchElement = STPage.actualTable.element(by.css('input'));
        searchElement.clear().then(function(){
            searchElement.sendKeys(query).then(function () {
                browser.waitForAngular().then(function () {
                    STPage.actualTable.all(by.css('tbody tr')).getText().then(function (app) {
                    });
                    expect(STPage.actualTable.all(by.css('tbody tr')).count()).to.eventually.eql(1)
                })
            })
        }).then(callback);
    });

    this.When(/^I sort and separate the slide from tissue$/, function () {
        var actualArr = {
            "TISSUE_DNA_AND_CDNA": [],
            "SLIDE": [],
            "BLOOD_DNA": []
            };

        for(var i = 0; i < STPage.responseData.length; i++){
            actualArr[STPage.responseData[i]["shipment_type"]].push(STPage.responseData[i])
        }
        STPage.actualArr = actualArr;
    });

    this.Then(/^I see the total number displayed matches with the response length$/, function (callback) {
        var message = STPage.actualTable.element(by.css('[ng-if="vm.tableInfo.totalItems === vm.tableGridInfo.data.length"]'))
        var expectedCount = STPage.responseData.length;
        message.getText().then(function(msg){
            expect(msg).to.eql('Total ' + expectedCount + ' items.', 'Count Mismatch')
        }).then(callback);
    });

    this.Then(/^I see the total number displayed matches with the response length for "(DNA|SLIDE)"$/, function (shipment_type, callback) {
        var count;
        if (shipment_type === 'DNA'){
            count = STPage.actualArr.TISSUE_DNA_AND_CDNA.length + STPage.actualArr.BLOOD_DNA.length
        } else {
            count = STPage.actualArr.SLIDE.length
        }
        var message = STPage.actualTable.element(by.css('[ng-if="vm.tableInfo.totalItems === vm.tableGridInfo.data.length"]'))
        message.getText().then(function(msg){
            expect(msg).to.eql('Total ' + count + ' items.', 'Count Mismatch')
        }).then(callback);
    });

    this.Then(/^I see that the row matches with specimens data of the backend for "(.+?)"$/, function (query, callback) {
        var hashSection;
        var data = STPage.responseData;
        var singleRow = STPage.actualTable.all(by.css('tbody td'));
        for (var i = 0; i < data.length; i++) {
            if (data[i].patient_id === query){
                hashSection = data[i];
                break
            }
        }
        if (hashSection !== undefined) {
            var collectedDate = utilities.returnFormattedDate(hashSection.collected_date) + ' GMT';
            var received_date = utilities.returnFormattedDate(hashSection.received_date) + ' GMT';
            browser.sleep(40).then(function () {
                utilities.checkExpectation(singleRow.get(0).getText(), hashSection.surgical_event_id, 'Surgical Event Id Mismatch');
                utilities.checkExpectation(singleRow.get(1).getText(), hashSection.patient_id, 'Patient Id Mismatch');
                utilities.checkExpectation(singleRow.get(2).getText(), collectedDate, 'Collected Date Mismatch');
                utilities.checkExpectation(singleRow.get(3).getText(), received_date, 'Received Date Mismatch');
                utilities.checkExpectation(singleRow.get(4).getText(), hashSection.specimen_type, 'Surgical Event Id Mismatch');
            }).then(callback);

        } else {
            expect(singleRow.count()).to.eventually.eql(0).notify(callback);
        }
    });

    this.Then(/^I see that the row matches with Clia Lab data of the backend for "(.+?)"$/, function (query, callback) {
        var hashSection;
        var data = STPage.actualArr.TISSUE_DNA_AND_CDNA;
        var singleRow = STPage.actualTable.all(by.css('tbody td'));
        for (var i = 0; i < data.length; i++) {
            if (data[i].patient_id === query){
                hashSection = data[i];
                break
            }
        }
        if (hashSection !== undefined) {
            var shippedDate = utilities.returnFormattedDate(hashSection.shipped_date) + ' GMT';
            browser.sleep(40).then(function () {
                utilities.checkExpectation(singleRow.get(0).getText(), hashSection.molecular_id, 'Molecular Id Mismatch');
                utilities.checkExpectation(singleRow.get(1).getText(), hashSection.surgical_event_id, 'Surgical Event_id Mismatch');
                utilities.checkExpectation(singleRow.get(2).getText(), hashSection.patient_id, 'Patient Id Mismatch');
                utilities.checkExpectation(singleRow.get(3).getText(), hashSection.shipment_type, 'Type Mismatch');
                utilities.checkExpectation(singleRow.get(4).getText(), shippedDate, 'Shipped Date Mismatch');
                utilities.checkExpectation(singleRow.get(5).getText(), hashSection.destination, 'Site Mismatch');
                utilities.checkExpectation(singleRow.get(6).getText(), hashSection.carrier, 'Carrier Mismatch');
                utilities.checkExpectation(singleRow.get(7).getText(), hashSection.tracking_id, 'Treacking Mismatch');
            }).then(callback);

        } else {
            expect(singleRow.count()).to.eventually.eql(0).notify(callback);
        }
    });

    this.Then(/^I see that the row matches with Slides data of the backend for "(.+?)"$/, function (query, callback) {
        var hashSection;
        var data = STPage.responseData;
        var singleRow = STPage.actualTable.all(by.css('tbody td'));
        for (var i = 0; i < data.length; i++) {
            if (data[i].patient_id === query){
                hashSection = data[i];
                break
            }
        }
        if (hashSection !== undefined) {
            var shippedDate = utilities.returnFormattedDate(hashSection.shipped_date) + ' GMT';
            browser.sleep(40).then(function () {
                utilities.checkExpectation(singleRow.get(0).getText(), hashSection.slide_barcode, 'Slide Barcode Mismatch');
                utilities.checkExpectation(singleRow.get(1).getText(), hashSection.surgical_event_id, 'Surgical Event_id Mismatch');
                utilities.checkExpectation(singleRow.get(2).getText(), hashSection.patient_id, 'Patient Id Mismatch');
                utilities.checkExpectation(singleRow.get(3).getText(), shippedDate, 'Shipped Date Mismatch');
                utilities.checkExpectation(singleRow.get(4).getText(), hashSection.destination, 'Site Mismatch');
                utilities.checkExpectation(singleRow.get(5).getText(), hashSection.carrier, 'Carrier Mismatch');
                utilities.checkExpectation(singleRow.get(6).getText(), hashSection.tracking_id, 'Treacking Mismatch');
            }).then(callback);

        } else {
            expect(singleRow.count()).to.eventually.eql(0).notify(callback);
        }
    });

    function shipmentBySite () {
        utilities.getRequestWithService('patient', '/api/v1/patients/shipments').then(function (responseBody) {
            var details = responseBody;
            var mda     = 0;
            var mocha   = 0;
            for (var i = 0; i < details.length; i++) {
                if (details[ i ][ 'destination' ] === 'MDA') {
                    mda++;
                } else if (details[ i ][ 'destination' ] === 'MoCha') {
                    mocha++;
                }
            }

            return {
                'mda'   : mda,
                'mocha' : mocha
            };
        });
    }
};
