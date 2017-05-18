/**
 * Created by raseel.mohamed on 10/09/16
 */

var STPage = function () {

    this.title            = 'MATCHBox | Specimen Tracking';
    this.topHeaderInfoBox = element.all(by.css('.header-info-box'));
    this.shipmentsSection = element(by.css('.ibox-title-no-line-no-padding'));

    this.specimenTableElement = element(by.id('specimenData'));
    this.cliaLAbTableElement  = element(by.id('tissueBloodShipmentData'));
    this.slideShipTableElement = element(by.id('slideShipmentData'))
    this.shipmentTableHeaderList = [ 'Molecular ID', 'Slide Barcode', 'Surgical Event ID', 'Patient ID',
                                     'Collected Date', 'Received Date', 'Type', 'Shipped Date', 'Site',
                                     'Fedex Tracking', 'Pathology Status', 'Pathology Status Date' ]
    this.searchField = element(by.css('input[grid-id="specimenData"]'));
    this.searchResultsSurgicalEventList = element.all(by.binding('item.surgical_event_id | dashify'));
    this.tableElementList = element.all(by.css('[ng-repeat-start="shipment in specimenEvent.specimen_shipments"]'));

    this.topLevelTabsList  = [ 'Specimens', 'CLIA Lab Shipments', 'Slide Shipments' ];
    this.topLvlTabElemList = element.all(by.css('ul.nav-tabs>li'));

    this.expectedSpecimensTableHeaders = [ 'Surgical Event ID', 'Patient ID', 'Collected Date', 'Received Date', 'Type' ];
    this.expectedCliaLabTableHeaders   = [ 'Molecular ID', 'Surgical Event ID', 'Patient ID', 'Type', 'Shipped Date', 'Site', 'Carrier', 'Tracking ID' ];
    this.expectedSlideShipmentHeaders = [ 'Slide Barcode', 'Surgical Event ID', 'Patient ID', 'Shipped Date', 'Site', 'Carrier', 'Tracking ID'];

};

module.exports = new STPage();
