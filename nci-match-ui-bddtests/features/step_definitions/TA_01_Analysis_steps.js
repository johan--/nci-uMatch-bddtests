/**
 * Created by raseel.mohamed on 6/9/16
 */

'use strict';
var fs = require('fs');

var taPage = require('../../pages/treatmentArmsPage');
// Helper Methods
var utilities = require ('../../support/utilities');

module.exports = function () {

    this.World = require ('../step_definitions/world').World;

    var taTable = taPage.taTable;
    var taTableHeaderArray = taPage.taTableHeaderArray;
    var taTableData = taPage.taTableData;
    var expectedTableHeaders = taPage.expectedTableHeaders;

    var treatment_id;
    var treatmentArmAPIDetails;
    var firstTreatmentArm;

    // GIVEN Section

    // WHEN Section

    this.When(/^I click on one of the treatment arms$/, function (callback) {
        //Here the user is clicking on the first treatment arm present.
        var response;
        taPage.returnTreatmentArmId(taTableData, 0).then(function (treatmentArmId) {
            treatment_id = treatmentArmId;
            response = utilities.callApiForDetails(treatment_id, 'treatmentArms');
            response.get().then(function (){
                treatmentArmAPIDetails = utilities.getTreatmentArmIdDetails(response.entity());
                firstTreatmentArm = treatmentArmAPIDetails[0];
                element(by.linkText(treatment_id)).click().then(function() {
                    callback();
                });
            });
        });
    });

    this.When(/^I click on (.+) in the treatment arm table$/, function (ta_id, callback) {
        var response;
        treatment_id = ta_id;
        response = utilities.callApiForDetails(treatment_id, 'treatmentArms');

        response.get().then(function(){
            treatmentArmAPIDetails = utilities.getTreatmentArmIdDetails(response.entity());
            firstTreatmentArm = treatmentArmAPIDetails[0];
            element(by.linkText(treatment_id)).click().then(function () {
                callback();
            })
        });
    });

    this.When(/^I click on the download in PDF Format$/, function (callback) {
        expect(browser.isElementPresent(taPage.downloadPDFButton)).to.eventually.be.true;
        //
        // element(taPage.downloadPDFButton).click()
        //  Insert Logic to download the file. Not working on the site when run locally
        //
        browser.sleep(50).then(callback);
    });



    this.When(/^I click on the download in Excel Format$/, function (callback) {
        expect(browser.isElementPresent(taPage.downloadExcelButton)).to.eventually.be.true;
        //
        // element(taPage.downloadExcelButton).click()
        //  Insert Logic to download the file. Not working on the site when run locally
        //
        browser.sleep(50).then(callback);
    });


    this.When(/^I select the (.+) Main Tab$/, function (tabName, callback) {
        var elementArray = taPage.expectedMainTabs;
        var elementIndex = elementArray.indexOf(tabName);
        utilities.clickElementArray(taPage.middleMainTabs, elementIndex);
        browser.sleep(50).then(callback);
    });

    //THEN Section
    this.Then(/^I should see the (.+) Title$/, function (title, callback) {
        browser.sleep(1000).then(function () {
            expect(element(by.tagName('h2')).getText()).to.eventually.equal(title);
        });
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the (.+) breadcrumb$/, function (breadcrumb, callback) {
        utilities.checkBreadcrumb("Dashboard / "+ breadcrumb);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see detailed (.+) breadcrumb$/, function (breadcrumb, callback) {
        utilities.checkBreadcrumb("Dashboard / "+ breadcrumb + ' / ' + 'Treatment Arm ' + treatment_id);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see treatment\-arms table$/, function (callback) {
        expect(browser.isElementPresent(taTable)).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the headings in the table$/, function (callback) {
        utilities.checkTableHeaders(taTableHeaderArray, expectedTableHeaders);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see data in the table$/, function (callback) {
        expect(taTableData.count()).to.eventually.be.greaterThan(0);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the treatment\-arms detail dashboard$/, function (callback) {
        expect(browser.getCurrentUrl()).to.eventually.equal(browser.baseUrl + '/#/treatment-arm/' + treatment_id);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the Name Details$/, function (callback) {
        utilities.checkElementArray(taPage.leftInfoBoxLabels, taPage.expectedLeftBoxLabels);

        expect(taPage.taName.get(1).getText()).to.eventually.equal(firstTreatmentArm.name);
        expect(taPage.taDescription.getText()).to.eventually.equal(firstTreatmentArm.description);
        expect(taPage.taStatus.getText()).to.eventually.equal(firstTreatmentArm.treatment_arm_status);
        expect(taPage.taVersion.getText()).to.eventually.equal(firstTreatmentArm.version);
        
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the Gene Details$/, function (callback) {
        utilities.checkElementArray(taPage.rightInfoBoxLabels, taPage.expectedRightBoxLabels);
        var drugDetails = firstTreatmentArm.treatment_arm_drugs[0];
        var drugName = drugDetails['name'] + ' (' + drugDetails['drug_id'] + ')';

        expect(taPage.taGene.getText()).to.eventually.equal(firstTreatmentArm.gene);
        // TODO: Fix the app to pull the number of patients from the api rather tha hard code it.
        //expect(taPage.taPatientsAssigned.getText()).to.eventually.equal(firstTreatmentArm.num_patients_assigned);
        expect(taPage.taDrug.getText()).to.eventually.equal(drugName);

        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see three tabs related to the treatment arm$/, function (callback) {
        utilities.checkElementArray(taPage.middleMainTabs, taPage.expectedMainTabs);
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the drop down to select different versions of the treatment arm$/, function (callback) {
        expect(browser.isElementPresent(taPage.versionDropDown)).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see (.+) Details Tab$/, function (tabName, callback) {
        var elementIndex = taPage.expectedMainTabs.indexOf(tabName);
        var elemPropertyArray = element.all(by.css('.wrapper>.tabs-container>.ng-isolate-scope>.nav-tabs>.ng-isolate-scope'));
        taPage.checkIfTabActive(elemPropertyArray, elementIndex);
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the All Patients Data on the Treatment Arm$/, function (callback) {
        expect(browser.isElementPresent(taPage.patientTaTable)).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should sort by different columns$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I can see the legend for the charts$/, function(callback) {
        expect(taPage.tableLegendArray.count()).to.eventually.equal(2);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see Patient Assignment Outcome chart$/, function (callback) {
        expect(browser.isElementPresent(taPage.patientPieChart)).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see Diseases Represented chart$/, function (callback) {
        expect(browser.isElementPresent(taPage.diseasePieChart)).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });


    this.Then(/^I download the file locally in PDF format$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I download the file locally in Excel format$/, function (callback) {
        // Write code here that turns the phrase above into concrete actions
        callback(null, 'pending');
    });

    this.Then(/^I should see the different versions of the Treatment Arm$/, function (callback) {
        expect(taPage.historyTabSubHeading.getText()).to.eventually.equal('Version');
        expect(taPage.listOfVersions.count()).to.eventually.be.above(0);
        browser.sleep(50).then(callback);
    });
};
