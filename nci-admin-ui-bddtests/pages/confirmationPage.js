var ConfirmationPage = function() {
    this.treatmentArmsIdList = element.all(by.css('.treatment-arm-container>.treatment-arm.ng-binding'));
    this.versionList         = element.all(by.css('.status-container>.status.ng-binding'));

    this.taConfirmButtonList = element.all(by.css('button[ng-click="create_modal_dialog(treatment_arm.treatment_arm_id, treatment_arm.version)"]'));
    this.taRemoveFromList    = element.all(by.css('button[ng-click="remove_from_pending(treatment_arm.treatment_arm_id, treatment_arm.version)"]'));
    this.modalConfirmButton  = element(by.css('.modal-content>.modal-footer>.confirm-buttons>.btn-active'));
    this.modalCancelButton   = element(by.css('.modal-content>.modal-footer>.confirm-buttons>.btn-warning'));
};

module.exports = new ConfirmationPage();
