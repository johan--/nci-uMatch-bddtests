'use strict'
var fs = require('fs');
var path = require('path');

var login = require('../../pages/loginPage');
var upload = require('../../pages/uploaderPage');
var wizard = require('../../pages/wizardPage')
var utilities = require('../../support/utilities');

module.exports = function() {
    this.World = require('../step_definitions/world').World;

    var data_folder = 'data_files'
//Given

    this.Given(/^I click on "([^"]*)" button in the wizard$/, function (buttonName, callback) {
        var buttonElement = returnButtonElement(buttonName);
        buttonElement.click().then(function(){
            browser.waitForAngular()
        }).then(callback);
    });

    this.Given(/^I fill in the Arm Data form section$/, function (callback) {
        wizard.ArmDataId.sendKeys('APECSC1621-UI_TEST');
        wizard.ArmDataGene.sendKeys('NTRK');
        wizard.ArmDataDrug.sendKeys('LOXO-101');
        wizard.ArmDataDrugId.sendKeys('788620')
        wizard.ArmDataPathwayName.sendKeys('Receptor tyrosine kinase');
        wizard.ArmDataDescription.sendKeys('LOXO-101 in  NTRK fusions');
        wizard.ArmDataStratumId.sendKeys('100');
        expect(wizard.ArmDataId.getAttribute('value')).to.eventually.eql('APECSC1621-UI_TEST');
        expect(wizard.ArmDataGene.getAttribute('value')).to.eventually.eql('NTRK');
        expect(wizard.ArmDataDrug.getAttribute('value')).to.eventually.eql('LOXO-101');
        expect(wizard.ArmDataDrugId.getAttribute('value')).to.eventually.eql('788620');
        expect(wizard.ArmDataPathwayName.getAttribute('value')).to.eventually.eql('Receptor tyrosine kinase');
        expect(wizard.ArmDataDescription.getAttribute('value')).to.eventually.eql('LOXO-101 in  NTRK fusions');
        expect(wizard.ArmDataStratumId.getAttribute('value')).to.eventually.eql('100').notify(callback);
    });

    this.Given(/^I fill in the Other Data form section$/, function (callback) {
        wizard.diseaseCodeType.sendKeys('ICD-O');
        wizard.diseaseCode.sendKeys('10058354');
        wizard.diseaseName.sendKeys('Bronchioloalveolar carcinoma');

        expect(wizard.diseaseCodeType.getAttribute('value')).to.eventually
            .eql('ICD-O');
        expect(wizard.diseaseCode.getAttribute('value')).to.eventually
            .eql('10058354');
        expect(wizard.diseaseName.getAttribute('value')).to.eventually
            .eql('Bronchioloalveolar carcinoma').notify(callback);
    });

    this.Given(/^I fill in the Exclusion\/Inclusion Varients form section$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
    });

    this.Given(/^I preload treatment arm "([^"]*)" and version "([^"]*)"$/, function (arg1, arg2, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I verify the Arm Data form section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I verify the Other Data form section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I verify the Exclusion\/Inclusion Varients form section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Given(/^I delete the "([^"]*)" field$/, function (arg1, callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Given(/^I land on the selection section$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

//When
    this.When(/^I select treatment arm "([^"]*)" from the choices$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.When(/^I select version "([^"]*)" from the version dropdown$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

//Then
    this.Then(/^I see the details I entered for confirmation$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I am on the "([^"]*)" section$/, function (paneName, callback) {
        var paneValue = {
            "Arm Data" : "arm_data",
            "Other Data" : "arm_disease_drug",
            "Exclusion/Inclusion Variants": "arm_inclusion_exclusion",
            "Confirm Treatment Arm": "arm_confirm"
        }
        var selectValue = paneValue[paneName];

        var paneElement = element(by.css('div.step-pane[data-name="'+ selectValue +'"]'));
        utilities.checkElementIncludesAttribute(paneElement, 'class', 'active').then(function(){
            expect(paneElement.element(by.css('.wizard-header')).getText())
                .to.eventually.eql(paneName);
        }).then(callback);
    });

    this.Then(/^I can see then new Treatment arm in the temporary table$/, function (callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^I see the field is required message under "([^"]*)" field$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    this.Then(/^A popup is seen displaying the message "([^"]*)"$/, function (arg1, callback) {
    // Write code here that turns the phrase above into concrete actions
    callback(null, 'pending');
    });

    function returnButtonElement(buttonName){
        var button = {
            "Create New Treatment Arm": wizard.createTreatmentArmButton,
            "Upload or Choose Treatment Arm": wizard.chooseTreatmentArmButton,
            "Validate Changes": wizard.validateChangesButton,
            "Next": wizard.nextButton,
            "Previous": wizard.prevButton
        }
        return button[buttonName];
    }
}
