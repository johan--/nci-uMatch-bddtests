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

    var currentTreatmentId;
    var currentStratumId;
    var treatmentArmAPIDetails;
    var firstTreatmentArm;

    // GIVEN Section

    // WHEN Section

    this.When(/^I click on one of the treatment arms$/, function (callback) {
        //Here the user is clicking on the first treatment arm present.
        expect(taTableData.count()).to.eventually.be.greaterThan(0);

        taPage.returnTreatmentArmId(taTableData, 0).then(function (taId) {
            currentTreatmentId = taPage.stripTreatmentArmId(taId);
            currentStratumId   = taPage.stripStratumId(taId);
            element(by.linkText(taId)).click().then(callback);
        });
    });

    this.Then(/^I collect backend information about the treatment arm$/, function () {
        var response;
        var inputDetails = currentTreatmentId + '/' + currentStratumId;
        response = utilities.callApiForDetails(inputDetails, 'treatmentArms');
        response.get().then(function () {
            treatmentArmAPIDetails = utilities.getJSONifiedDetails(response.entity());
            firstTreatmentArm = treatmentArmAPIDetails[0];
        })
    });

    this.When(/^I go to treatment arm with "(.+)" as the id and "(.+)" as stratum id$/, function (taId,stratem, callback) {
        var response;
        currentTreatmentId = taId;
        taPage.setTreatmentArmId(taId);
        var location =  'treatment-arm?name=' + taId + '&stratum=' + stratem;
        response = utilities.callApiForDetails(currentTreatmentId, 'treatmentArms');

        response.get().then(function () {
            treatmentArmAPIDetails = utilities.getJSONifiedDetails(response.entity());
            firstTreatmentArm = treatmentArmAPIDetails[0];
            browser.setLocation(location , 6000).then(function () {
                callback();
            }, function(err){
                console.log(browser.getCurrentUrl());
                console.log(err.toString());
            });
        })
    });

    this.When(/^I click on (.+) in the treatment arm table$/, function (taId, callback) {
        currentTreatmentId = taPage.stripTreatmentArmId(taId);
        element(by.linkText(taId)).click().then(callback);
    });

    this.When(/^I click on the download in PDF Format$/, function (callback) {
        expect(browser.isElementPresent(taPage.downloadPDFButton)).to.eventually.be.true;
        // todo: Insert Logic to download the file. Not working on the site when run locally
        // element(taPage.downloadPDFButton).click()
        browser.sleep(50).then(callback);
    });



    this.When(/^I click on the download in Excel Format$/, function (callback) {
        expect(browser.isElementPresent(taPage.downloadExcelButton)).to.eventually.be.true;
        // todo: Insert Logic to download the file. Not working on the site when run locally
        // element(taPage.downloadExcelButton).click()
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
        utilities.checkBreadcrumb("Dashboard / "+ breadcrumb + ' / ' + 'Treatment Arm ' + currentTreatmentId);
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
        expect(browser.getCurrentUrl()).to.eventually.include(browser.baseUrl + '/#/treatment-arm?name=' + currentTreatmentId);
        callback();
    });

    this.Then(/^I should see the Name Details$/, function (callback) {
        //todo: Make sure to check for the name as a combination of TA and stratem
        utilities.checkElementArray(taPage.leftInfoBoxLabels, taPage.expectedLeftBoxLabels);
        console.log(firstTreatmentArm);

        expect(taPage.taName.getText()).to.eventually.equal(firstTreatmentArm.name);
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
//        TODO: Fix the app to pull the number of patients from the api rather tha hard code it.
//        expect(taPage.taPatientsAssigned.getText()).to.eventually.equal(firstTreatmentArm.num_patients_assigned);
//        expect(taPage.taTotalPatientsAssigned.getText()).to.evetually.equal(firstTreatmentArm.num_patients_assigned_basic);
//        expect(taPage.taDrug.getText()).to.eventually.equal(drugName);

        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see three tabs related to the treatment arm$/, function (callback) {
        utilities.checkElementArray(taPage.middleMainTabs, taPage.expectedMainTabs);
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the drop down to select different versions of the treatment arm$/, function (callback) {
        expect(browser.isElementPresent(taPage.versionDropDownSelector)).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see (.+) Details Tab$/, function (tabName, callback) {
        var elementIndex = taPage.expectedMainTabs.indexOf(tabName);
        var elemPropertyArray = element.all(by.css('.wrapper>.tabs-container>.ng-isolate-scope>.nav-tabs>.ng-isolate-scope'));
        taPage.checkIfTabActive(elemPropertyArray, elementIndex);
        browser.sleep(50).then(callback);
    });


    this.Then(/^I should see the All Patients Data Table on the Treatment Arm$/, function (callback) {
        expect(browser.isElementPresent(taPage.patientTaTable)).to.eventually.be.true;
        browser.sleep(50).then(callback);
    });

    this.Then(/^I should see the All Patients Data on the Treatment Arm$/, function(callback){
        callback.pending();
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
        expect(taPage.historyTabSubHeading.getText()).to.eventually.equal('Version History');
        expect(taPage.listOfVersions.count()).to.eventually.be.above(0);
        browser.sleep(50).then(callback);
    });
};
