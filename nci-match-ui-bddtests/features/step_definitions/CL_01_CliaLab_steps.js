/**
 * Created by raseel.mohamed on 11/9/16
 */

'use strict';
var fs = require('fs');
var moment = require('moment');

var utilities = require('../../support/utilities');
var cliaPage      = require('../../pages/CLIAPage');
var patientPage = require('../../pages/patientPage');

var nodeCmd   = require('node-cmd');
module.exports = function() {
    this.World = require('../step_definitions/world').World;

    var tabNameMap = cliaPage.tabNameMapping;

    var controlType;


    this.Then(/^I can see the Clia Labs page$/, function (callback) {
        expect(browser.getTitle()).to.eventually.eql(cliaPage.pageTitle);
        expect(browser.getCurrentUrl()).to.eventually.include('/#/clia-labs');
        expect(cliaPage.mochaSectionButton.getText()).to.eventually.eql('MoCha');
        expect(cliaPage.mdaSectionButton.getText()).to.eventually.eql('MoCha').notify(callback);
    });

    this.When(/^I click on the "(MoCha|MD Anderson|Dartmouth)" section$/, function (sectionName, callback) {

        var elem = getSectionName(sectionName);
        cliaPage.siteName = sectionName;
        elem.click().then(function() {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I click on "([^"]*)" under "(MoCha|MD Anderson|Dartmouth)"$/, function (subTabName, sectionName, callback) {
        var elem = element(by.css('li[heading="' + subTabName + '"]'));
        elem.click ().then(function(){
            // Setting the Control type here in anticipation of future needs.
            cliaPage.siteName = sectionName === 'MoCha' ? 'MoCha' : 'MDACC';
            cliaPage.controlType  = tabNameMap[sectionName][subTabName].control_type;
            cliaPage.tableElement = tabNameMap[sectionName][subTabName].element;
            cliaPage.urlType      = tabNameMap[sectionName][subTabName].url_type;
            browser.waitForAngular();
            browser.ignoreSynchronization = false;
        }).then(callback);
    });

    this.When(/^I navigate to sample control "([^"]*)" of type "([^"]*)" under "(MoCha|MD Anderson)"$/, function (sampleId, subTabName, sectionName, callback) {
        cliaPage.siteName = sectionName === 'MoCha' ? 'mocha' : 'mda';
        cliaPage.tableElement   = tabNameMap[sectionName][subTabName]['element'];
        cliaPage.controlType    = tabNameMap[sectionName][subTabName].control_type;
        cliaPage.urlControlType = tabNameMap[sectionName][subTabName].url_control_type;
        cliaPage.urlType        = tabNameMap[sectionName][subTabName].url_type;
        cliaPage.molecularId    = sampleId;
        var location = '/#/clia-lab-report/' + cliaPage.urlControlType + '/?site='
                        + cliaPage.siteName + '&type=' + cliaPage.controlType + '&molecular_id=' + cliaPage.molecularId;

        browser.get(location, 6000).then(function(){
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I am on the "(MoCha|MD Anderson|Dartmouth)" section$/, function (sectionName, callback) {
        var url = getSectionUrl(sectionName);
        expect(browser.getCurrentUrl()).to.eventually
            .include('clia-labs?site=' + url + '&type=positive')
            .notify(callback);
    });

    this.When(/^I collect information on "([^"]*)" under "(MoCha|MD Anderson|Dartmouth)"$/, function (subTabName, sectionName, callback) {
        var site = getSectionUrl(sectionName);
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + cliaPage.controlType;
        utilities.getRequestWithService('ion', url).then(function(responseBody){
            cliaPage.responseData = responseBody;
        }).then(callback);
    });

    this.When(/^I collect new information on "([^"]*)" under "(MoCha|MD Anderson|Dartmouth)"$/, function (subTabName, sectionName, callback) {
        var site = getSectionUrl(sectionName);
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + cliaPage.controlType;
        utilities.getRequestWithService('ion', url).then(function(responseBody){
            cliaPage.newResponseData = responseBody;
        }).then(callback);
    });

    this.When(/^I collect information on the IR users for "(.+?)"$/, function (site, callback) {
        var url = '/api/v1/ion_reporters/healthcheck?site=' + site;
        utilities.getRequestWithService('ion', url).then(function(response){
            cliaPage.responseData = response;
        }).then(callback);
    });

    this.When(/^I click on Generate MSN button$/, function (callback) {
        var generateMSNProperty = element(by.css('button[ng-click="$ctrl.generateMsnRow(\'' + cliaPage.controlType + '\')"]'));
        utilities.waitForElement(generateMSNProperty, 'Generate MSN button');
        generateMSNProperty.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I enter "([^"]*)" in the search field on "([^"]*)" under "(MoCha|MD Anderson|Dartmouth)"$/, function (value, subTabName, sectionName, callback) {
        var parentElement = cliaPage.tableElement;
        var searchElement = parentElement.element(by.css('input.input-sm.all-filter'));
        cliaPage.molecularId = value;
        searchElement.sendKeys(value).then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I collect information about the sample variant report from aliquot$/, function (callback) {
        var url = '/api/v1/aliquot/' + cliaPage.molecularId;

        utilities.getRequestWithService('ion', url, { Authorization: browser.sysToken }).then(function(responseBody){
            cliaPage.responseData = responseBody;
        }).then(callback);
    });

    this.When(/^I click on the sample control link$/, function (callback) {
        var parentElement = cliaPage.tableElement;

        var firstRow = parentElement.all(by.css('[ng-repeat^="item in filtered"]')).get(0);
        firstRow.all(by.css('a')).get(0).click().then(function(){
            browser.sleep(10);
        }).then(callback);
    });

    this.When(/^I click on a random IR tab$/, function (callback) {
        var counter = cliaPage.responseData.length;
        var index = parseInt(Math.random() * counter);
        cliaPage.expectedIRdetails = cliaPage.responseData[index];

        console.log(cliaPage.expectedIRdetails);

        var irId = cliaPage.expectedIRdetails['ion_reporter_id'];
        element(by.css('li[ng-repeat="item in heartbeatList"][heading="' + irId + '"]')).click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I verify that "([^"]*)" under "(MoCha|MD Anderson|Dartmouth)" is active$/, function (subTabName, sectionName, callback) {
         var elemToCheck = element(by.css('li[heading="' + subTabName + '"]'));
         utilities.checkElementIncludesAttribute(elemToCheck, 'class', 'active').then(callback);
    });

    this.Then(/^I can see the details about the new IR and matches with the backend$/,function (callback) {
        //Checking if the tab is active
        var irId = cliaPage.expectedIRdetails['ion_reporter_id'];
        var el = element(by.css('li[ng-repeat="item in heartbeatList"][heading="' + irId + '"]'));
        var tab = element.all(by.css('[ng-controller="HeartbeatController as heartbeat"] .active li .pull-right'));
        utilities.checkElementIncludesAttribute(el, 'class', 'active').then(function () {
            var lastContact = utilities.returnFormattedDate(cliaPage.expectedIRdetails['last_contact']) + ' GMT';
            utilities.checkExpectation(tab.get(0) , cliaPage.expectedIRdetails['ip_address'], 'IP Mismatch');
            utilities.checkExpectation(tab.get(1), cliaPage.expectedIRdetails['internal_ip_address'], 'Internal IP Mismatch');
            utilities.checkExpectation(tab.get(2), cliaPage.expectedIRdetails['host_name'], 'Host Name Mismatch');
            tab.get(3).getText().then(function (status) {
                expect(status).to.include(cliaPage.expectedIRdetails['ir_status'].slice(0, -28), 'Status Mismatch');
            });
            utilities.checkExpectation(tab.get(4), cliaPage.expectedIRdetails['ion_reporter_version'], 'IR Version Mismatch');
            utilities.checkExpectation(tab.get(5), lastContact, 'Last Contact mismatch');
        }).then(callback);
    });

    this.Then(/^I verify the headings for "([^"]*)" under "(MoCha|MD Anderson|Dartmouth)"$/, function (subTabName, sectionName, callback) {
        var tableElement = cliaPage.tableElement;
        var headings = tableElement.all(by.css('table>thead>tr>th'));

        expect(headings.getText()).to.eventually.eql(cliaPage.expectedMsnTableHeading).notify(callback);
    });

    this.Then(/^a new Molecular Id is created under the "(MoCha|MD Anderson|Dartmouth)"$/, function (sectionName, callback) {
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
            );
        }).then(function(){
            browser.sleep(60);
        }).then(callback);
    });

    this.When(/^I delete the variant reports uploaded to S3$/, function(callback){
        var s3path = `s3://${cliaPage.bucketName}/IR_UITEST/${cliaPage.molecularId}/${cliaPage.molecularId}_ANI/${cliaPage.molecularId}`
        console.log(s3path)
       browser.sleep(50).then(function () {
           nodeCmd.get(
               `aws s3 rm  ${s3path}.json --region us-east-1 
                aws s3 rm  ${s3path}.tsv --region us-east-1 
                aws s3 rm  ${s3path}_dna.bai --region us-east-1 
                aws s3 rm  ${s3path}_rna.bai --region us-east-1 
               `
               ,
               function (data) {
                   console.log(data);
               }
           );
       }).then(callback);
    });

    this.When(/^I call the aliquot service with the generated MSN$/, function(callback){
        var path = 'IR_UITEST/' + cliaPage.S3Path;
        var data = 	{
            "analysis_id": cliaPage.analysisId,
            "site": "mocha",
            "ion_reporter_id": "IR_UITEST",
            "vcf_name": 'test1.vcf',
            "dna_bam_name": 'dna.bam',
            "cdna_bam_name": 'cdna.bam'
        };

        console.log ("browser.sysToken: " + browser.sysToken);

        utilities.putRequestWithService('ion', '/api/v1/aliquot/' + cliaPage.molecularId, data, { Authorization: browser.sysToken }).
            then(function(responseBody) {
                console.log(responseBody);
            }).then(callback);
    });

    this.Then(/^I see variant report details for the generated MSN$/, function (callback) {
        //Entering the new MSN generated in to the search field
        cliaPage.tableElement.element(by.css('input')).sendKeys(cliaPage.molecularId);
        browser.waitForAngular().then(function () {
            var firstRow = element.all(by.css('[ng-repeat^="item in filtered"]')).get(0);
            expect(firstRow.all(by.binding('item.molecular_id')).get(0).getText()).to.eventually.eql(cliaPage.molecularId);
            expect(firstRow.all(by.css('a')).get(0).isPresent()).to.eventually.eql(true);
            expect(firstRow.all(by.css('a')).get(0).getText()).to.eventually.eql(cliaPage.molecularId);
        }).then(callback);
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
        var expectedResult = cliaPage.urlControlType + '/?site=' + cliaPage.siteName + '&type=' + cliaPage.controlType + '&molecular_id=' + cliaPage.molecularId
        browser.waitForAngular().then(function(){
            expect(browser.getCurrentUrl()).to.eventually.include(expectedResult);
        }).then(callback);
    });

    this.Then(/^I verify all the headings on the "(left|right)" hand side section under Positive Sample Control$/, function (side, callback) {
        var expectedHeaders = cliaPage.expPositiveSampleHeaders[side];
        var index = side === 'left' ? 0 : 1;
        var actualHeadings  = cliaPage.sampleDetailHeaders.get(index).all(by.css('dt'));
        browser.sleep(30).then(function () {
            utilities.checkElementArray(actualHeadings, expectedHeaders);
        }).then(callback);
    });

    this.Then(/^I verify all the headings on the "(left|right)" hand side section under "(No Template Control|Proficiency And Competency)"$/, function (side, header, callback) {
        var tableType = header === 'No Template Control' ? cliaPage.expNonTempCrtlHeaders : cliaPage.expProfAndCompCrtlHeaders
        var expectedHeaders = tableType[side];
        var index = side === 'left' ? 0 : 1;
        var actualHeadings  = cliaPage.sampleDetailHeaders.get(index).all(by.css('dt'));
        browser.sleep(30).then(function () {
            utilities.checkElementArray(actualHeadings, expectedHeaders);
        }).then(callback);
    });

    this.Then(/^I verify all the values on the left hand side section under Positive Sample Control$/, function (callback) {
        expect(cliaPage.sampleDetailMolecId.getText()).to.eventually.include(cliaPage.responseData['molecular_id']);
        expect(cliaPage.sampleDetailAnalysisId.getText()).to.eventually.include(cliaPage.responseData['analysis_id']);
        expect(cliaPage.sampleDetailLoadedDt.getText()).to.eventually.include(moment.utc(cliaPage.responseData['date_molecular_id_created']).utc().format('LLL'));
        expect(cliaPage.sampleDetailTorrentVer.getText()).to.eventually.include(cliaPage.responseData['torrent_variant_caller_version']);
        expect(cliaPage.sampleDetailPosCtrlVer.getText()).to.eventually.include(cliaPage.responseData['positive_control_version']);
        expect(cliaPage.sampleDetailRecvdDate.getText()).to.eventually.include(moment.utc(cliaPage.responseData['date_variant_received']).utc().format('LLL'));
        expect(cliaPage.positiveDetailStatus.getText()).to.eventually.include(cliaPage.responseData['report_status']).notify(callback);
    });

    this.Then(/^I verify all the values on the left hand side section under "(No Template Control|Proficiency And Competency)"$/, function (headerType, callback) {
        expect(cliaPage.sampleDetailMolecId.getText()).to.eventually.include(cliaPage.responseData['molecular_id']);
        expect(cliaPage.sampleDetailAnalysisId.getText()).to.eventually.include(cliaPage.responseData['analysis_id']);
        expect(cliaPage.sampleDetailTorrentVer.getText()).to.eventually.include(cliaPage.responseData['torrent_variant_caller_version']);
        expect(cliaPage.sampleDetailRecvdDate.getText()).to.eventually.include(moment.utc(cliaPage.responseData['date_variant_received']).utc().format('LLL'));
        if (headerType === 'No Template Control'){
            expect(cliaPage.noTemplateDetailStatus.getText()).to.eventually.include(cliaPage.responseData['report_status']).notify(callback);
        } else {
            expect(cliaPage.profAndCompDetailStatus.getText()).to.eventually.include(cliaPage.responseData['report_status']).notify(callback);
        }

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
        expect(cliaPage.sampleDetailTableHead.get(1).getText()).to.eventually.eql('False Positive Variants');
        expect(cliaPage.samplePositivePanelTableColumn.getText()).to.eventually.eql(cliaPage.expectedPositiveControlsTableHeaders);
        expect(cliaPage.sampleFalsePosTableColumn.getText()).to.eventually.eql(cliaPage.expectedFalsePostiveVariantTableHEaders).notify(callback);
    });

    this.When(/^I verify the presence of SNVs, CNVs and Gene Fusions Table$/, function (callback) {
        expect(cliaPage.sampleDetailTableHead.get(0).getText()).to.eventually.eql('SNVs/MNVs/Indels');
        expect(cliaPage.sampleDetailTableHead.get(1).getText()).to.eventually.eql('Copy Number Variants');
        expect(cliaPage.sampleDetailTableHead.get(2).getText()).to.eventually.eql('Gene Fusions').notify(callback);
    });

    this.Then(/^I verify that valid IDs are links and invalid IDs are not in "(Positive Controls|False Positive Variants)" table$/, function (tableName, callback) {
        var presentIDList;
        if (tableName === 'Positive Controls') {
            presentIDList = cliaPage.samplePositivePanel.all(by.css('cosmic-link[link-id="item.identifier"]'));
        } else {
            presentIDList = cliaPage.sampleFalsePosPanel.all(by.css('cosmic-link[link-id="item.identifier"]'))
        }
        presentIDList.count().then(function (cnt) {
            for(var i = 0; i < cnt; i ++){
                utilities.checkCosmicLink(presentIDList.get(i))
            }
        }).then(callback)
    });

    this.Then(/^I verify that all Genes have a valid link in the "(Positive Controls|False Positive Variants)" table$/, function(tableName, callback){
        var presentIDList;
        if (tableName === 'Positive Controls') {
            presentIDList = cliaPage.samplePositivePanel.all(by.css('cosmic-link[link-id="item.gene"]'));
        } else {
            presentIDList = cliaPage.sampleFalsePosPanel.all(by.css('cosmic-link[link-id="item.gene"]'))
        }
        utilities.checkElementArrayisGene(presentIDList).then(callback);
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
        var location = '/#/clia-lab-report/no-template-sample-control/?site=' + cliaPage.siteName
            + '&type=no_template_control' + '&molecular_id=' + molecularId;
        browser.get(location, 6000).then(function () {browser.waitForAngular();}).then(callback);
    });

    this.Then(/^I click on clia report "([^"]*)" button$/, function (buttonText, callback) {
        browser.sleep(5000).then(function () {
            browser.waitForAngular().then(function () {

                element(by.buttonText('PASSED')).click();
                browser.sleep(2000);
                element(by.cssContainingText('.btn', 'PASSED')).click();
            });
        });
    });

    this.When(/^I click on the PASSED Button under "(No Template Control|Proficiency And Competency)"$/, function (tabName, callback) {
        var buttonElement = getStatusButton('PASSED', tabName);

        buttonElement.click().then(function () {
            browser.wait(EC.visbilityOf(element(by.className('modal fade ng-isolate-scope in'))), 5000);

        }).then(callback);
    });

    this.When(/^I call aliquot service with "([^"]*)" as the molecular id$/, function (molecularId , callback) {
        var analysisId = molecularId + '_ANI';
        var data =  {
            "analysis_id": analysisId,
            "site": "mocha",
            "ion_reporter_id": "IR_UITEST",
            "vcf_name": molecularId + '.vcf',
            "dna_bam_name": molecularId + '_dna.bam',
            "cdna_bam_name": molecularId + '_rna.bam'
        };

        utilities.putRequestWithService('ion', '/api/v1/aliquot/' + molecularId, data, { Authorization: browser.sysToken }).
            then(function(responseBody) {
                console.log(responseBody);
            }).then(callback);
    });

    this.When(/^I enter "(.+?)" in the search field for "(.+?)" under "(.+?)"$/, function(molecularId, tableType, site, callback){
        cliaPage.bucketName = browser.baseUrl.match('localhost') ? 'pedmatch-dev' : 'pedmatch-int';
        cliaPage.molecularId = molecularId;
        var input = cliaPage.tabNameMapping[site][tableType].searchElement
        input.sendKeys(molecularId);
        expect(input.getAttribute('value')).to.eventually.eql(molecularId).notify(callback);
    });

    this.Then(/^I "(should|should not)" see a variant report for "(.+?)" for "(.+?)" under "(.+?)"$/, function(presence, molecularId, tableType, site, callback){
        var tableElement = element.all(by.css('a[ng-show="item.analysis_id && item.report_status"]')).get(0);
        if (presence === "should") {
            expect(tableElement.all(by.css('i[title="Variant report"]')).get(0).isPresent()).to.eventually.eql(true).notify(callback);
        } else {
            expect(tableElement.element(by.xpath('..')).element(by.css('p')).getText()).to.eventually.eql('-').notify(callback);
        }
    });

    this.When(/^I clear the text in the modal text box$/, function (callback) {
        patientPage.confirmChangeCommentField.clear();
        browser.sleep(50).then(callback);
    });

    this.When(/^I enter the cliaPage report comment "([^"]*)" in the VR modal text box$/, function (comment, callback) {
        patientPage.confirmVRStatusCommentField.sendKeys(comment);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I verify the data present in False Positive Variants table$/,function(callback){
        var responseData = cliaPage.responseData.false_positive_variants;
        var tableRow = cliaPage.sampleFalsePosPanel.all(by.css('tbody>tr'));

        var compareTable = function(row, data){
            var identifier = row.element(by.css('cosmic-link[link-id="item.identifier"]'));
            var geneLink = row.element(by.css('cosmic-link[link-id="item.gene"]'));
            utilities.checkExpectation(identifier, data["identifier"], 'Identifier Mismatch');
            utilities.checkCosmicLink(identifier);
            utilities.checkExpectation(row.element(by.binding('item.position')), data["position"], 'Position Mismatch');
            utilities.checkExpectation(geneLink, data["gene"], 'Gene Mismatch');
            utilities.checkGeneLink(geneLink);
            utilities.checkExpectation(row.element(by.binding('item.variant_type')), data["variant_type"], 'Variant type Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.ocp_reference')), data["ocp_reference"], 'Reference Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.ocp_alternative')), data["ocp_alternative"], 'Alternative Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.hgvs')), data["hgvs"], 'HGVS Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.protein')), data["protein"], 'Protein Mismatch');


        }

        tableRow.count().then(function(cnt){
            for(var i = 0; i < cnt; i ++){
                compareTable(tableRow.get(i), responseData[i])
            }
        }).then(callback);

    });


    this.Then(/^I verify the data present in Positive Controls table$/,function(callback){
        var responseData = cliaPage.responseData.positive_variants;
        var tableRow = cliaPage.samplePositivePanel.all(by.css('tbody>tr'));

        var compareTable = function(row, data){
            var identifier = row.element(by.css('cosmic-link[link-id="item.identifier"]'));
            var geneLink = row.element(by.css('cosmic-link[link-id="item.gene"]'));
            utilities.checkExpectation(identifier, data["identifier"], 'Identifier Mismatch');
            utilities.checkCosmicLink(identifier);
            utilities.checkExpectation(row.element(by.binding('item.chromosome')), data["chromosome"], 'Chromosome Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.position')), data["position"], 'Position Mismatch');
            utilities.checkExpectation(geneLink, data["gene"], 'Gene Mismatch');
            utilities.checkGeneLink(geneLink);
            utilities.checkExpectation(row.element(by.binding('item.variant_type')), data["variant_type"], 'Variant type Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.ocp_reference')), data["ocp_reference"], 'Reference Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.ocp_alternative')), data["ocp_alternative"], 'Alternative Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.hgvs')), data["hgvs"], 'HGVS Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.protein')), data["protein"], 'Protein Mismatch');
            utilities.checkExpectation(row.element(by.binding('item.function')), data["function"], 'Function Mismatch');
        };

        tableRow.count().then(function(cnt){
            for(var i = 0; i < cnt; i ++){
                compareTable(tableRow.get(i), responseData[i])
            }
        }).then(callback);

    });

    this.When(/^I collect information about the QC report from aliquot$/, function (callback) {
        var url = '/api/v1/sample_controls/quality_control/' + cliaPage.molecularId;
        utilities.getRequestWithService('ion', url, { Authorization: browser.sysToken }).then(function(responseBody){
            cliaPage.responseData = responseBody;
        }).then(callback);
    });

    this.Then(/^I enter the first "(.+?)" from "(.+?)" in the "(.+?)" Table search$/, function (field, variant, variantName, callback) {
        cliaPage.searchValues = cliaPage.responseData[variant][0];
        var searchTerm = cliaPage.searchValues[field];
        var tableIndex = patientPage.expVarReportTables.indexOf(variantName);
        cliaPage.tableId = getTableId(tableIndex);
        console.log("Searching for: " + searchTerm);
        cliaPage.tableId.element(by.model('filterAll')).sendKeys(searchTerm).then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I verify the data in the SNV Table in QC report$/, function (callback) {
        var table = cliaPage.tableId;
        var expected = cliaPage.searchValues;
        browser.sleep(50).then(function () {
            var identifier = table.element(by.css('cosmic-link[link-id="item.identifier"]'));
            var func_gene = table.element(by.css('cosmic-link[link-id="item.func_gene"]'));
            utilities.checkExpectation(identifier, expected['identifier'], 'Identifier Mismatch');
            utilities.checkCosmicLink(identifier);
            utilities.checkExpectation(table.element(by.binding('item.chromosome')), expected['chromosome'], 'Chromosome Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.position')), expected['position'], 'Position Mismatch');
//            utilities.checkExpectation(table.element(by.css('long-string-handling[long-string="item.ocp_reference | dashify"]')), expected['ocp_reference'], 'Reference Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.ocp_alternative')), expected['ocp_alternative'], 'Alternative Mismatch');
//            utilities.checkExpectation(table.element(by.binding('item.allele_frequency')), expected['allele_frequency'], 'Allelle Mismatch');
            utilities.checkExpectation(func_gene, expected['func_gene'], 'Func Gene Mismatch');
            utilities.checkGeneLink(func_gene);
            utilities.checkExpectation(table.element(by.binding('item.oncomine_variant_class')), expected['oncomine_variant_class'], 'Oncomine Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.function')), expected['function'], 'Function Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.hgvs')), expected['hgvs'], 'HGVS Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.read_depth')), expected['read_depth'], 'Read Depth Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.transcript')), expected['transcript'], 'Transcript Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.protein')), expected['protein'], 'Protein Mismatch');
        }).then(callback);
    });

    this.Then(/^I verify the data in the CNV Table in QC report$/, function (callback) {
        var table = cliaPage.tableId;
        var expected = cliaPage.searchValues;
        browser.sleep(50).then(function () {
            var identifier = table.element(by.css('cosmic-link[link-id="item.identifier"]'));
            var func_gene = table.element(by.css('cosmic-link[link-id="item.func_gene"]'));
            utilities.checkExpectation(identifier, expected['identifier'], 'Identifier Mismatch');
            utilities.checkGeneLink(identifier);
            utilities.checkExpectation(table.element(by.binding('item.raw_copy_number')), utilities.integerize(expected['raw_copy_number']), 'Raw Copy Number Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.filter')), expected['filter'], 'Filter Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.copy_number')), utilities.integerize(expected['copy_number']), 'Copy Number Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.confidence_interval_5_percent')), utilities.round(expected['confidence_interval_5_percent'], 3), 'CI 5% Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.confidence_interval_95_percent')), utilities.round(expected['confidence_interval_95_percent'], 3), 'CI 95% Mismatch');
        }).then(callback);
    });


    this.Then(/^I verify the data in the Gene Fusions Table in QC report$/, function (callback) {
        var table = cliaPage.tableId;
        var expected = cliaPage.searchValues;
        browser.sleep(50).then(function () {
            var identifier = table.element(by.css('cosmic-link[link-id="item.identifier"]'));
            var func_gene = table.element(by.css('cosmic-link[link-id="item.func_gene"]'));
            var driver_gene = table.element(by.css('cosmic-link[link-id="item.driver_gene"]'));
            var partner_gene = table.element(by.css('cosmic-link[link-id="item.partner_gene"]'));
            utilities.checkExpectation(identifier, expected['identifier'], 'Identifier Mismatch');
            utilities.checkCOSFLink(identifier);
            utilities.checkExpectation(table.element(by.binding('item.filter')), expected['filter'], 'Filter Mismatch');
            utilities.checkExpectation(driver_gene, expected['driver_gene'], 'Driver Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.read_depth')), expected['read_depth'], 'Driver Count Mismatch');
            utilities.checkExpectation(partner_gene, expected['partner_gene'], 'Partner Mismatch');
            utilities.checkExpectation(table.element(by.binding('item.annotation')), expected['annotation'], 'Annotation Mismatch');
            utilities.checkGeneLink(driver_gene);
            utilities.checkGeneLink(partner_gene);
        }).then(callback);
    });

    this.Then(/^I can see the IR tabs$/, function (callback) {
        expect(cliaPage.irTabs.count()).to.eventually.eql(cliaPage.responseData.length).notify(callback);
    });



    // CLia related functions

    function getSectionName (sectionName){
        var section = {
            "MoCha": cliaPage.mochaSectionButton,
            "MD Anderson": cliaPage.mdaSectionButton,
            "Dartmouth": cliaPage.dartmouthSectionButton
        };
        return section[sectionName];
    }

    function getSectionUrl (sectionName) {
        var section = {
            "MoCha": 'mocha',
            "MD Anderson": 'mda',
            "Dartmouth": 'dartmouth'
        };
        return section[sectionName];
    }

    function getTableId (index) {
        var tables = [cliaPage.QCSNVPanel, cliaPage.QCCNVPanel, cliaPage.QCGeneFusionPanel];
        return tables[index];
    }
};
