var ConfirmationPage = function() {
    this.treatmentArmsIdList = element.all(by.css('.treatment-arm-container>.treatment-arm.ng-binding'));
    this.versionList         = element.all(by.css('.status-container>.status.ng-binding'));

    this.taConfirmButtonList = element.all(by.cssContainingText('button.btn-info', 'Confirm Upload'))
    this.modalConfirmButton  = element(by.css('.modal-content>.modal-footer>.confirm-buttons>.btn-active'));
}

module.exports = new ConfirmationPage();