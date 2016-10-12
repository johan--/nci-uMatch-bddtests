/**
 * Created by raseel.mohamed on 10/09/16
 */

var STPage = function () {

    this.title            = 'MATCHBox | Specimen Tracking';
    this.topHeaderInfoBox = element.all(by.css('.header-info-box'));
    this.shipmentsSection = element(by.css('.ibox-title-no-line-no-padding'));

    this.shipmentTableElement = element(by.id('specimenShipments'));
    this.shipmentTableHeaderList = [ 'Molecular ID', 'Slide Barcode', 'Surgical Event ID', 'Patient ID',
                                     'Collected Date', 'Received Date', 'Type', 'Shipped Date', 'Site',
                                     'Fedex Tracking', 'Pathology Status', 'Pathology Status Date' ]
};

module.exports = new STPage();
