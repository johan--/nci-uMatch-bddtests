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
        expect(subTabElement.getText()).to.eventually.eql(surgicalEventId);
        utilities.checkElementIncludesAttribute(subTab, 'class', 'active');
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
