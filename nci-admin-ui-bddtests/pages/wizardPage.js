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

    // Arm Data
    this.ArmDataId                  = element(by.model('treatment_arm.treatment_arm_id'));
    this.ArmDataGene                = element(by.model('treatment_arm.gene'));
    this.ArmDataDrug                = element(by.model('treatment_arm.target_name'));
    this.ArmDataDrugId              = element(by.model('treatment_arm.treatment_arm_drugs[0].drug_id'));
    this.ArmDataPathwayName         = element(by.model('treatment_arm.treatment_arm_drugs[0].pathway'));
    this.ArmDataDescription         = element(by.model('treatment_arm.description'));
    this.ArmDataStratumId           = element(by.model('treatment_arm.stratum_id'));

    // Other Data
    this.diseaseCodeType            = element(by.model('treatment_arm.diseases[0].disease_code_type'));
    this.diseaseCode                = element(by.model('treatment_arm.diseases[0].disease_code'));
    this.diseaseName                = element(by.model('treatment_arm.diseases[0].disease_name'))
}

module.exports = new WizardPage();
