/**
 * Created by raseel.mohamed on 11/9/16
 */

'use strict'
var fs = require('fs');
var moment = require('moment');

var utilities = require ('../../support/utilities');
var dash      = require ('../../pages/dashboardPage');
var cliaPage      = require ('../../pages/CLIAPage');

var nodeCmd   = require ('node-cmd');
module.exports = function() {
    this.World = require ('../step_definitions/world').World;

    var tabNameMap = {
        'MoCha' : {
            'Positive Sample Controls': {
                'element': cliaPage.mochaPositiveGrid,
                'control_type': 'positive',
                'url_type': 'positive_sample_control'
            },

            'No Template Control': {
                'element': cliaPage.mochaNoTemplateGrid,
                'control_type': 'no_template',
                'url_type' : 'no_template_control'
            },
            'Proficiency And Competency' : {
                'element': cliaPage.mochaProficiencyGrid,
                'control_type': 'proficiency_competency',
                'url_type': 'positive_sample_control'
            }
        },
        'MD Anderson' : {
            'Positive Sample Controls': {
                'element': cliaPage.mdaPositiveGrid,
                'control_type': 'positive'
            },
            'No Template Control': {
                'element': cliaPage.mdaNoTemplateGrid,
                'control_type': 'no_template'
            },
            'Proficiency And Competency' : {
                'element': cliaPage.mdaProficiencyGrid,
                'control_type': 'proficiency_competency'
            }
        }
    };

    var controlType;


    this.Then(/^I can see the Clia Labs page$/, function (callback) {
        expect(browser.getTitle()).to.eventually.eql(cliaPage.pageTitle);
        expect(browser.getCurrentUrl()).to.eventually.include('/#/clia-labs');
        expect(cliaPage.mochaSectionButton.getText()).to.eventually.eql('MoCha');
        expect(cliaPage.mdaSectionButton.getText()).to.eventually.eql('MoCha').notify(callback);
    });

    this.When(/^I click on the "(MoCha|MD Anderson)" section$/, function (sectionName, callback) {

        console.log(sectionName)

        var elem = sectionName === 'MoCha' ? cliaPage.mochaSectionButton : cliaPage.mdaSectionButton;
        cliaPage.site = sectionName;
        elem.click().then(function() {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I click on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var elem = element(by.css('li[heading="' + subTabName + '"]'))
        element (by.css ('li[heading="' + subTabName + '"]')).click ().then(function(){
            // Setting the Control type here in anticipation of future needs.
            cliaPage.controlType = tabNameMap[sectionName][subTabName]['control_type'];
            cliaPage.tableElement = tabNameMap[sectionName][subTabName]['element'];
            cliaPage.urlType      = tabNameMap[sectionName][subTabName]['url_type']
            browser.waitForAngular();
            browser.ignoreSynchronization = false;    
        }).then(callback);
    });

    this.Then(/^I am on the "(MoCha|MD Anderson)" section$/, function (sectionName, callback) {
        var url = sectionName === 'MoCha' ? 'MoCha' : 'MDACC';
        expect(browser.getCurrentUrl()).to.eventually
            .include('clia-labs?site=' + url + '&type=positive')
            .notify(callback);
    });

    this.When(/^I collect information on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + cliaPage.controlType;
        var request = utilities.callApi('ion', '/api/v1/sample_controls');
        utilities.getRequestWithService('ion', url).then(function(responseBody){
            cliaPage.responseData = responseBody
        }).then(callback);
    });

    this.When(/^I collect new information on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + cliaPage.controlType;
        utilities.getRequestWithService('ion', url).then(function(responseBody){
            cliaPage.newResponseData = responseBody
        }).then(callback);
    });

    this.When(/^I click on Generate MSN button$/, function (callback) {
        var generateMSNProperty = element(by.css('form[ng-submit="generateMsn(\'' + cliaPage.controlType + '\')"]>input'));
        utilities.waitForElement(generateMSNProperty, 'Generate MSN button');
        generateMSNProperty.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I enter "([^"]*)" in the search field on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (value, subTabName, sectionName, callback) {
        var parentElement = cliaPage.tableElement;
        var searchElement = parentElement.element(by.css('input.input-sm.all-filter'));
        cliaPage.molecularId = value;
        searchElement.sendKeys(value).then(function () {
            browser.waitForAngular()
        }).then(callback)
    });

    this.When(/^I collect information about the sample variant report$/, function (callback) {
        var url = '/api/v1/sample_controls/' + cliaPage.molecularId;

        utilities.getRequestWithService('ion', url).then(function(responseBody){
            cliaPage.responseData = responseBody
        }).then(callback);
    });

    this.When(/^I click on the sample control link$/, function (callback) {
        var parentElement = cliaPage.tableElement;

        var firstRow = parentElement.all(by.css('[ng-repeat^="item in filtered"]')).get(0);
        firstRow.all(by.css('a')).get(0).click().then(function () {
            browser.waitForAngular()
        }).then(callback);
    });

    this.Then(/^I verify that "([^"]*)" under "(MoCha|MD Anderson)" is active$/, function (subTabName, sectionName, callback) {
         var elemToCheck = cliaPage.tableElement;
         expect(elemToCheck.isPresent()).to.eventually.eql(true).notify(callback);
    });

    this.Then(/^I verify the headings for "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var tableElement = cliaPage.tableElement;
        var headings = tableElement.all(by.css('table>thead>tr>th'))

        expect(headings.getText()).to.eventually.eql(cliaPage.expectedMsnTableHeading).notify(callback);
    });

    this.Then(/^a new Molecular Id is created under the "(MoCha|MD Anderson)"$/, function (sectionName, callback) {
        expect(cliaPage.newResponseData.length).to.eql(cliaPage.responseData.length + 1);
        browser.sleep(50).then(callback);
    });

    this.When(/^I upload variant report to S3 with the generated MSN$/, function (callback) {
        cliaPage.bucketName = browser.baseUrl.match('localhost') ? 'pedmatch-dev' : 'pedmatch-int';
        cliaPage.molecularId = cliaPage.newMSNObject['molecular_id'];
        cliaPage.analysisId = cliaPage.molecularId + '_ANI';
        cliaPage.S3Path = cliaPage.molecularId + '/' + cliaPage.analysisId;

        browser.sleep(50).then(function () {
            nodeCmd.get(
                `cd ../DataSetup/variant_file_templates 
                mkdir -p ${cliaPage.S3Path} 
                cp -r ir_template/* ${cliaPage.S3Path}
                aws s3 cp ${cliaPage.molecularId}  s3://${cliaPage.bucketName}/IR_UITEST/${cliaPage.molecularId} --recursive --region us-east-1 `
                ,
                function(data){
                    console.log(data);
                    console.log('Copied data from ' + cliaPage.molecularId + 'to S3 with bucket name' + cliaPage.bucketName);
                }
            )
        }).then(function(){
            browser.sleep(30)
        }).then(callback);
    });

    this.When(/^I delete the variant reports uploaded to S3$/, function(callback){
       browser.sleep(50).then(function () {
           nodeCmd.get(
               `aws s3 rm ${cliaPage.molecularId}  s3://${cliaPage.bucketName}/IR_UITEST/${cliaPage.molecularId} --recursive --region us-east-1 `
               ,
               function (data) {
                   console.log(data);
               }
           )
       }).then(callback)
    });

    this.When(/^I call the aliquot service with the generated MSN$/, function(callback){
        var path = 'IR_UITEST/' + cliaPage.S3Path;
        var data = 	{
            "analysis_id": cliaPage.analysisId,
            "site": "mocha",
            "ion_reporter_id": "IR_UITEST",
            "vcf_name": path + '/test1.vcf',
            "dna_bam_name": path + '/dna.bam',
            "cdna_bam_name": path + '/cdna.bam'
        };

        browser.sleep(50).then(function () {
            utilities.putApi('ion', '/api/v1/aliquot/' + cliaPage.molecularId, data)
        }).then(callback)
    });

    this.Then(/^I see variant report details for the generated MSN$/, function (callback) {
        //Entering the new MSN generated in to the search field
        cliaPage.tableElement.element(by.css('input')).sendKeys(cliaPage.molecularId);
        browser.waitForAngular().then(function () {
            var firstRow = element.all(by.css('[ng-repeat^="item in filtered"]')).get(0)
            expect(firstRow.all(by.binding('item.molecular_id')).get(0).getText()).to.eventually.eql(cliaPage.molecularId);
            expect(firstRow.all(by.css('a')).get(0).isPresent()).to.eventually.eql(true);
            expect(firstRow.all(by.css('a')).get(0).getText()).to.eventually.eql(cliaPage.molecularId);
//            expect(firstRow.all(by.css('a')).get(0).getAttribute('href')).to.include('molecular_id=' + cliaPage.molecularId)
        }).then(callback)
    });

    this.When(/^I capture the new MSN created$/, function (callback) {
        var oldMolecularIds = [];
        var newMolecularIds = [];
        for (var i = 0; i < cliaPage.responseData.length; i++) {
            oldMolecularIds.push(cliaPage.responseData[i]["molecular_id"]);
        }
        for (var i = 0; i < cliaPage.newResponseData.length; i++) {
            newMolecularIds.push(cliaPage.newResponseData[i]["molecular_id"]);
        }
        cliaPage.newMSNObject = cliaPage.newResponseData.filter(function (item) {
            return oldMolecularIds.indexOf(item["molecular_id"]) < 0;
        })[0];

        console.log("molecular_id: " + cliaPage.newMSNObject['molecular_id']);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I verify that I am on the sample control page for that molecularId$/, function (callback) {
        var expectedResult = '/?site=' + cliaPage.site + '&type=' + cliaPage.urlType + '&molecular_id=' + cliaPage.molecularId
        expect(browser.getCurrentUrl()).to.eventually.include(expectedResult).notify(callback);
    });

    this.Then(/^I verify all the headings on the "(left|right)" hand side section under Positive Sample Control$/, function (side, callback) {
        var expectedHeaders = cliaPage.expPositiveSampleHeaders[side];
        var index = side === 'left' ? 0 : 1;
        var actualHeadings  = cliaPage.sampleDetailHeaders.get(index).all(by.css('dt'));
        browser.sleep(30).then(function () {
            utilities.checkElementArray(actualHeadings, expectedHeaders)
        }).then(callback);
    });

    this.Then(/^I verify all the headings on the "(left|right)" hand side section under "(No Template Control|Proficiency And Competency)"$/, function (side, header, callback) {
        var tableType = header === 'No Template Control' ? cliaPage.expNonTempCrtlHeaders : cliaPage.expProfAndCompCrtlHeaders
        var expectedHeaders = tableType[side];
        var index = side === 'left' ? 0 : 1;
        var actualHeadings  = cliaPage.sampleDetailHeaders.get(index).all(by.css('dt'));
        browser.sleep(30).then(function () {
            utilities.checkElementArray(actualHeadings, expectedHeaders)
        }).then(callback);
    });

    this.Then(/^I verify all the values on the left hand side section under Positive Sample Control$/, function (callback) {
        expect(cliaPage.sampleDetailMolecId.getText()).to.eventually.include(cliaPage.responseData['molecular_id']);
        expect(cliaPage.sampleDetailAnalysisId.getText()).to.eventually.include(cliaPage.responseData['analysis_id']);
        expect(cliaPage.sampleDetailLoadedDt.getText()).to.eventually.include(moment.utc(cliaPage.responseData['date_molecular_id_created']).utc().format('LLL'));
        expect(cliaPage.sampleDetailTorrentVer.getText()).to.eventually.include(cliaPage.responseData['torrent_variant_caller_version']);
        expect(cliaPage.sampleDetailPosCtrlVer.getText()).to.eventually.include(cliaPage.responseData['positive_control_version']);
        expect(cliaPage.sampleDetailRecvdDate.getText()).to.eventually.include(moment.utc(cliaPage.responseData['date_variant_received']).utc().format('LLL'));
        expect(cliaPage.sampleDetailStatus.getText()).to.eventually.include(cliaPage.responseData['report_status']).notify(callback);
    });

    this.Then(/^I verify all the values on the left hand side section under "(No Template Control|Proficiency And Competency)"$/, function (headerType, callback) {
        expect(cliaPage.sampleDetailMolecId.getText()).to.eventually.include(cliaPage.responseData['molecular_id']);
        expect(cliaPage.sampleDetailAnalysisId.getText()).to.eventually.include(cliaPage.responseData['analysis_id']);
        expect(cliaPage.sampleDetailTorrentVer.getText()).to.eventually.include(cliaPage.responseData['torrent_variant_caller_version']);
        expect(cliaPage.sampleDetailRecvdDate.getText()).to.eventually.include(moment.utc(cliaPage.responseData['date_variant_received']).utc().format('LLL'));
        expect(cliaPage.sampleDetailStatus.getText()).to.eventually.include(cliaPage.responseData['report_status']).notify(callback);
    });

    this.Then(/^I verify all the values on the right hand side section under Positive Sample Control$/, function (callback) {
        expect(cliaPage.sampleDetailCell.getText()).to.eventually.include(cliaPage.responseData['cellularity']);
        expect(cliaPage.sampleDetailMAPD.getText()).to.eventually.include(cliaPage.responseData['mapd']);
        expect(cliaPage.sampleDetailTotVariant.getText()).to.eventually.include(cliaPage.responseData['total_variants']).notify(callback);
    });


    this.Then(/^I verify all the values on the right hand side section under "(No Template Control|Proficiency And Competency)"$/, function (headerType, callback) {
        expect(cliaPage.sampleDetailCell.getText()).to.eventually.include(cliaPage.responseData['cellularity']);
        expect(cliaPage.sampleDetailMAPD.getText()).to.eventually.include(cliaPage.responseData['mapd']);
        expect(cliaPage.sampleDetailTotVariant.getText()).to.eventually.include(cliaPage.responseData['total_variants']).notify(callback);
    });

    this.Then(/^I verify the presence of Positive controls and False positive variants table$/, function (callback) {
        expect(cliaPage.sampleDetailTableHead.get(0).getText()).to.eventually.eql('Positive Controls');
        expect(cliaPage.sampleDetailTableHead.get(1).getText()).to.eventually.eql('False Positive Variants').notify(callback);
    });

    this.When(/^I verify the presence of SNVs, CNVs and Gene Fusions Table$/, function (callback) {
        expect(cliaPage.sampleDetailTableHead.get(0).getText()).to.eventually.eql('SNVs/MNVs/Indels');
        expect(cliaPage.sampleDetailTableHead.get(1).getText()).to.eventually.eql('Copy Number Variants');
        expect(cliaPage.sampleDetailTableHead.get(2).getText()).to.eventually.eql('Gene Fusions').notify(callback);
    });

    this.Then(/^I verify that valid IDs are links and invalid IDs are not in "(Positive Controls|False Positive Variants)" table$/, function (tableName, callback) {
        var presentIDList;
        if (tableName === 'Positive Controls') {
            presentIDList = cliaPage.samplePositivePanel.all(by.css('[ng-if$="item.identifier"]'));
        } else {
            presentIDList = cliaPage.sampleFalsePosPanel.all(by.css('cosmic-link[link-id="item.identifier"]'))
        }
        presentIDList.count().then(function (cnt) {
            for(var i = 0; i < cnt; i ++){
                utilities.checkCosmicLink(presentIDList.get(i))
            }
        }).then(callback)
    });

    this.Then(/^I verify the valid Ids are links in the SNVs\/MNVs\/Indels table under "(No Template Control|Proficiency And Competency)"$/, function (sectionName, callback) {
        var panel        = sectionName === 'No Template Control' ? cliaPage.ntcSNVPanel : cliaPage.proficiencySNVPanel;
        var idList       = panel.all(by.css('cosmic-link[link-id="item.identifier"]'));
        var funcGeneList = panel.all(by.css('cosmic-link[link-id="item.func_gene"]'));
        idList.count().then(function(cnt){
            for (var i = 0; i < cnt; i++){
                utilities.checkCosmicLink(idList.get(i));
                utilities.checkGeneLink(funcGeneList.get(i));
            }
        }).then(callback);
    });

    this.Then(/^I verify the valid Ids are links in the Copy Number Variants table under "(No Template Control|Proficiency And Competency)"$/, function (sectionName, callback) {
        var panel   = sectionName === 'No Template Control' ? cliaPage.ntcCNVPanel : cliaPage.proficiencyCNVPanel;
        var idList  = panel.all(by.css('cosmic-link[link-id="item.identifier"]'));
        idList.count().then(function(cnt){
            for (var i = 0; i < cnt; i++){
                utilities.checkGeneLink(idList.get(i));
            }
        }).then(callback);
    });

    this.Then(/^I verify the valid Ids are links in the Gene Fusions table under "(No Template Control|Proficiency And Competency)"$/, function (sectionName, callback) {
        var panel   = sectionName === 'No Template Control' ? cliaPage.ntcGeneFusionPanel : cliaPage.proficiencyGFPanel
        var idList  = panel.all(by.css('cosmic-link[link-id="item.identifier"]'));
        var gene1List = panel.all(by.css('cosmic-link[link-id="item.driver_gene"]'));
        var gene2List = panel.all(by.css('cosmic-link[link-id="item.partner_gene"]'));
        idList.count().then(function(cnt){
            for (var i = 0; i < cnt; i++){
                utilities.checkCOSFLink(idList.get(i));
                utilities.checkGeneLink(gene1List.get(i));
                utilities.checkGeneLink(gene2List.get(i));
            }
        }).then(callback);
    });

    this.When(/^I go to clia variant report with "(.+)" as the molecular_id$/, function (molecularId, callback) {
        var location = '/#/clia-lab-report/no-template-sample-control/?site=' + cliaPage.site
            + '&type=no_template_control' + '&molecular_id=' + molecularId;
        browser.get(location, 6000).then(function () {browser.waitForAngular();}).then(callback);
    });

    // function getStatusButton(filtered, reportType){
        // var buttonString = filtered === 'Filtered' ? 'FILTERED' : 'QC';
        // var panelString = reportType === 'Tissue Reports' ? patientPage.tissueMasterPanelString : patientPage.bloodMasterPanelString;
        // var css_locator = panelString + " [ng-class=\"getVariantReportModeClass('" + buttonString + "')\"]";
        // return element(by.css(css_locator));
    // };

    this.Then(/^I click on clia report "([^"]*)" button$/, function (buttonText, callback) {
        browser.sleep(5000).then(function () {
            browser.waitForAngular().then(function () {

                element(by.buttonText('PASSED')).click();
                browser.sleep(2000);
                element(by.cssContainingText('.btn', 'PASSED')).click();
            });
        });

        // element(by.buttonText(buttonText)).click().then(function () {
        //     browser.waitForAngular();
        // }).then(callback);
    });

    this.When(/^I click on the PASSED Button under "(No Template Control|Proficiency And Competency)"$/, function (tabName, callback) {
        var buttonElement = getStatusButton('PASSED', tabName);

        buttonElement.click().then(function () {
            browser.wait(EC.visbilityOf(element(by.className('modal fade ng-isolate-scope in'))), 5000);


            // return browser.waitForAngular();
//            var assignmentHeading = element(by.css(patientPage.tissueTableString))
//            utilities.waitForElement(assignmentHeading, 'Table Element on Tissue/Blood');
//            return;
        }).then(callback);
    });

    // this.When(/^I enter the comment "([^"]*)" in the modal text box$/, function (comment, callback) {
    //     patientPage.confirmChangeCommentField.sendKeys(comment);
    //     browser.sleep(50).then(callback);
    // });

    this.When(/^I clear the text in the modal text box$/, function (callback) {
        patientPage.confirmChangeCommentField.clear();
        browser.sleep(50).then(callback);
    });

    this.When(/^I enter the cliaPage report comment "([^"]*)" in the VR modal text box$/, function (comment, callback) {
        patientPage.confirmVRStatusCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
    });

};
