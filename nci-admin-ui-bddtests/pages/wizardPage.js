var WizardPage = function() {
    this.pageTitle                  = browser.getTitle();

    // Left hand section showing navigation pane
    this.preLoadDataStep            = element(by.css('li[data-name="Preload Data"]'));
    this.armDataStep                = element(by.css('li[data-name="Arm Data"]'));
    this.diseaseDataStep            = element(by.css('li[data-name="Other Data"]'));
    this.exclusionDataStep          = element(by.css('li[data-name="Exclusion/Inclusion Variants"]'));
    this.confirmDataStep            = element(by.css('li[data-name="Confirm"]'));
    this.prevButton                 = element(by.css('button.btn-prev'));
    this.nextButton                 = element(by.css('button.btn-next'));
    this.validateChangesButton      = element(by.css('a.btn-active[data-toggle="tooltip"]'));

    //Right hand section showing preload secrtion
    this.chooseTreatmentArmButton   = element(by.css('a[ng-click="toggle_treatment_arm_selection()"]'));
    this.createTreatmentArmButton   = element(by.css('a[ng-click="create_new_treatment_arm()"]'));

}

module.exports = new WizardPage();
