/**
 * Created by raseel.mohamed on 9/4/16
 */
'use strict';
var fs = require('fs');

var STPage = require ('../../pages/specimenTrackingPage');

// Utility Methods
var utilities = require ('../../support/utilities');

module.exports = function () {
    this.World = require ('../step_definitions/world').World;
    var shippingSection = STPage.topHeaderInfoBox.get(0);
    var trendAnalysis   = STPage.topHeaderInfoBox.get(1);
    var shipmentSection = STPage.shipmentsSection;
    var shipmentTable   = STPage.shipmentTableElement;
    var shippingJSONResponse;
    var expectedResponse;

    this.When(/^I collect information about shipment$/, function (callback) {
        shipmentDetails().then(function (responseJSON) {
            shippingJSONResponse = responseJSON;
        }).then(callback);
    });

    this.When(/^I enter "(.+?)" from response at index "(.+?)" in the search field$/, function (key, index, callback) {
        expectedResponse = shippingJSONResponse[index]
        var molecularId = expectedResponse[key];
        var filter = element.all(by.model('filterAll'));
        filter.sendKeys(molecularId).then(function () {
            browser.waitForAngular()
        }).then(callback);
    });

    this.Then(/^I see the Shipping Location section$/, function (callback) {
        expect(shippingSection.isPresent()).to.eventually.eql(true);
        expect(shippingSection.all(by.css('h3')).get(0).getText()).to.eventually.eql('Shipping Locations');
        browser.sleep(50).then(callback);
    });

    this.Then(/^I see the Trend Analysis section$/, function (callback) {
        expect(trendAnalysis.isPresent()).to.eventually.eql(true);
        expect(trendAnalysis.all(by.css('h3')).get(0).getText()).to.eventually.eql('Trend Analysis');
        browser.sleep(50).then(callback);
    });


    this.Then(/^I can see the Distribution of specimens between sites$/, function (callback) {
        shipmentBySite().then(function (details){
            var total = details.mda + details.mocha;
            var mdaPercentage = total === 0 ? 0 : details.mda * 100 / total;
            var mochaPercentage = total === 0 ? 0 : details.mocha * 100 /total;
            shippingSection.all(by.css('.m-xs.ng-binding')).get(0).getText().then(function (text) {
                expect(text).to.eql(details.mda.toString());
            });

            expect(shippingSection.all(by.css('.font-bold.no-margins.ng-binding')).get(0).getText()).to.eventually.eql(mdaPercentage + '%');

            expect(shippingSection.all(by.css('.m-xs.ng-binding')).get(1).getText()).to.eventually.eql(details.mocha.toString());
            expect(shippingSection.all(by.css('.font-bold.no-margins.ng-binding')).get(1).getText()).to.eventually.eql(mochaPercentage + '%');

            browser.sleep(50);
        }).then(callback);
    });

    this.Then(/^I can see the chart at index "(.+?)" is for "(.+?)"$/, function (index, siteName, callback) {
        var idx = parseInt(index);
        expect(shippingSection.all(by.css('a[ui-sref="clia-labs"]')).get(idx).getText()).to.eventually.eql(siteName).then(function () {
            browser.sleep(50);
        }).then(callback);
    });

    this.Then(/^I can see the Shipment table headers$/, function (callback) {
        var headers = shipmentTable.all(by.css('th.sortable'));
        var expectedHeader = STPage.shipmentTableHeaderList;

        for(var u = 0; u < expectedHeader.length; u++ ) {
            utilities.moveAndCheckElement(headers, u, expectedHeader[u])
        };
        browser.sleep(50).then(callback);

    });

    this.Then(/^I can see the Shipments table$/, function (callback) {
        expect(shipmentTable.element(by.css('.table-striped')).isPresent()).to.eventually.eql(true);
        expect(shipmentSection.element(by.css('h3')).getText()).to.eventually.eql('Shipments').then(function () {
            browser.sleep(50)
        }).then(callback);
    });

    this.Then(/^I can compare the details about shipment against the API$/, function (callback) {
        var moment = require('moment');
        var actualElementList = element.all(by.repeater('item in filtered')).get(0).all(by.css('td'));
        var elementList = [ 'molecular_id', 'slide_barcode', 'surgical_event_id', 'patient_id', 'collected_date',
                            'received_date', 'speciment_type', 'shipped_date', 'destination', 'tracking_id',
                            'pathology_status', 'pathology_status_date'
                          ];
        var expectedValue;

        for(var i = 0; i < elementList.length; i++){
            var elem = elementList[i];
            if (elem.match(/_date/)){
                expectedValue = expectedResponse[elem] === undefined ? utilities.dashifyIfEmpty(expectedResponse[elem]) : moment.utc(expectedResponse[elem]).utc().format('LLL') + ' GMT';
            } else {
                expectedValue = utilities.dashifyIfEmpty(expectedResponse[elementList[i]]);
            }
            utilities.moveAndCheckElement(actualElementList, i, expectedValue)
        }
        browser.sleep(50).then(callback);
    });


    function shipmentDetails() {
        var request = utilities.callApi('patient', '/api/v1/patients/shipments');
        return request.get().then(function () {
            return JSON.parse(request.entity());
        })
    }

    function shipmentBySite() {
        var request = utilities.callApi('patient', '/api/v1/patients/shipments');
        return request.get().then(function () {
            var details =  JSON.parse(request.entity());
            var mda = 0;
            var mocha = 0;
            for(var i = 0; i < details.length; i ++ ){
                if (details[i]['destination'] === 'MDA'){
                    mda ++;
                } else if(details[i]['destination'] === 'MOCHA') {
                    mocha ++;
                }
            }

            return {
                'mda': mda,
                'mocha': mocha
            };
        })
    }
};
