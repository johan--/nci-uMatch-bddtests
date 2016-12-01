/**
 * Created by raseel.mohamed on 11/9/16
 */

'use strict'
var fs = require('fs');
var moment = require('moment');

var utilities = require ('../../support/utilities');
var dash      = require ('../../pages/dashboardPage');
var clia      = require ('../../pages/CLIAPage');
var nodeCmd   = require ('node-cmd');
module.exports = function() {
    this.World = require ('../step_definitions/world').World;

    var tabNameMap = {
        'MoCha' : {
            'Positive Sample Controls': {
                'element': clia.mochaPositiveGrid,
                'control_type': 'positive',
                'url_type': 'positive_sample_control'
            },

            'No Template Control': {
                'element': clia.mochaNoTemplateGrid,
                'control_type': 'no_template',
                'url_type' : 'no_template_control'
            },
            'Proficiency And Competency' : {
                'element': clia.mochaProficiencyGrid,
                'control_type': 'proficiency_competency',
                'url_type': 'positive_sample_control'
            }
        },
        'MD Anderson' : {
            'Positive Sample Controls': {
                'element': clia.mdaPositiveGrid,
                'control_type': 'positive'
            },
            'No Template Control': {
                'element': clia.mdaNoTemplateGrid,
                'control_type': 'no_template'
            },
            'Proficiency And Competency' : {
                'element': clia.mdaProficiencyGrid,
                'control_type': 'proficiency_competency'
            }
        }
    };

    var controlType;


    this.Then(/^I can see the Clia Labs page$/, function (callback) {
        expect(browser.getTitle()).to.eventually.eql(clia.pageTitle);
        expect(browser.getCurrentUrl()).to.eventually.include('/#/clia-labs');
        expect(clia.mochaSectionButton.getText()).to.eventually.eql('MoCha');
        expect(clia.mdaSectionButton.getText()).to.eventually.eql('MoCha').notify(callback);
    });

    this.When(/^I click on the "(MoCha|MD Anderson)" section$/, function (sectionName, callback) {
        var elem = sectionName === 'MoCha' ? clia.mochaSectionButton : clia.mdaSectionButton;
        clia.site = sectionName;
        elem.click().then(function() {
            browser.waitForAngular();
        }).then(callback);
    });

    this.Then(/^I am on the "(MoCha|MD Anderson)" section$/, function (sectionName, callback) {
        var url = sectionName === 'MoCha' ? 'MoCha' : 'MDACC';
        expect(browser.getCurrentUrl()).to.eventually
            .include('clia-labs?site=' + url + '&type=positive')
            .notify(callback);
    });

    this.When(/^I click on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var elem = element(by.css('li[heading="' + subTabName + '"]'))

        // Setting the Control type here in anticipation of future needs.
        controlType = tabNameMap[sectionName][subTabName]['control_type'];
        clia.controlType  = controlType;
        clia.tableElement = tabNameMap[sectionName][subTabName]['element'];
        clia.urlType      = tabNameMap[sectionName][subTabName]['url_type']
        browser.executeScript('window.scrollTo(0, 650)').then(function () {
            browser.sleep(3000).then(function () {
                elem.click().then(function(){
                    browser.waitForAngular();
                })
            })

        }).then(callback);
    });

    this.When(/^I collect information on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + controlType;
        utilities.getRequestWithService('ion', url).then(function(response){
            clia.responseData = response
        }).then(callback);
    });

    this.When(/^I collect new information on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var site = sectionName === 'MoCha' ? 'mocha' : 'mdacc';
        var url  = '/api/v1/sample_controls?site=' + site + '&control_type=' + controlType;
        var request = utilities.callApi('ion', url);
        request.get().then(function() {
            clia.newResponseData =JSON.parse(request.entity());
        }).then(callback);
    });

    this.When(/^I click on Generate MSN button$/, function (callback) {
        var generateMSNProperty = element(by.css('form[ng-submit="generateMsn(\'' + controlType + '\')"]>input'));
        utilities.waitForElement(generateMSNProperty, 'Generate MSN button');
        generateMSNProperty.click().then(function () {
            browser.waitForAngular();
        }).then(callback);
    });

    this.When(/^I enter "([^"]*)" in the search field on "([^"]*)" under "(MoCha|MD Anderson)"$/, function (value, subTabName, sectionName, callback) {
        var parentElement = clia.tableElement;
        var searchElement = parentElement.element(by.css('input.input-sm.all-filter'));
        clia.molecularId = value;
        searchElement.sendKeys(value).then(function () {
            browser.waitForAngular()
        }).then(callback)
    });

    this.When(/^I collect information about the sample variant report$/, function (callback) {
        var url = '/api/v1/sample_controls/' + clia.molecularId;

        utilities.getRequestWithService('ion', url).then(function(response){
            clia.responseData = response
        }).then(callback);
    });

    this.When(/^I click on the sample control link$/, function (callback) {
        var parentElement = clia.tableElement;

        var firstRow = parentElement.all(by.css('[ng-repeat^="item in filtered"]')).get(0);
        firstRow.all(by.css('a')).get(0).click().then(function () {
            browser.waitForAngular()
        }).then(callback);
    });

    this.Then(/^I verify that "([^"]*)" under "(MoCha|MD Anderson)" is active$/, function (subTabName, sectionName, callback) {
         var elemToCheck = clia.tableElement;
         expect(elemToCheck.isPresent()).to.eventually.eql(true).notify(callback);
    });

    this.Then(/^I verify the headings for "([^"]*)" under "(MoCha|MD Anderson)"$/, function (subTabName, sectionName, callback) {
        var tableElement = clia.tableElement;
        var headings = tableElement.all(by.css('table>thead>tr>th'))

        expect(headings.getText()).to.eventually.eql(clia.expectedMsnTableHeading).notify(callback);
    });

    this.Then(/^a new Molecular Id is created under the "(MoCha|MD Anderson)"$/, function (sectionName, callback) {
        expect(clia.newResponseData.length).to.eql(clia.responseData.length + 1);
        browser.sleep(20).then(callback);
    });

    this.When(/^I upload variant report to S3 with the generated MSN$/, function (callback) {
        clia.bucketName = browser.baseUrl.match('localhost') ? 'pedmatch-dev' : 'pedmatch-int';
        clia.molecularId = clia.newMSNObject['molecular_id'];
        clia.analysisId = clia.molecularId + '_ANI';
        clia.S3Path = clia.molecularId + '/' + clia.analysisId;

        browser.sleep(50).then(function () {
            nodeCmd.get(
                `cd ../DataSetup/variant_file_templates 
                mkdir -p ${clia.S3Path} 
                cp -r ir_template/* ${clia.S3Path}
                aws s3 cp ${clia.molecularId}  s3://${clia.bucketName}/IR_UITEST/${clia.molecularId} --recursive --region us-east-1 `
                ,
                function(data){
                    console.log(data);
                    console.log('Copied data from ' + clia.molecularId + 'to S3 with bucket name' + clia.bucketName);
                }
            )
        }).then(callback);
    });

    this.When(/^I delete the variant reports uploaded to S3$/, function(callback){
       browser.sleep(50).then(function () {
           nodeCmd.get(
               `aws s3 rm ${clia.molecularId}  s3://${clia.bucketName}/IR_UITEST/${clia.molecularId} --recursive --region us-east-1 `
               ,
               function (data) {
                   console.log(data);
               }
           )
       }).then(callback)
    });

    this.When(/^I call the aliquot service with the generated MSN$/, function(callback){
        var path = 'IR_UITEST/' + clia.S3Path;
        var data = 	{
            "analysis_id": clia.analysisId,
            "site": "mocha",
            "ion_reporter_id": "IR_UITEST",
            "vcf_name": path + '/test1.vcf',
            "dna_bam_name": path + '/dna.bam',
            "cdna_bam_name": path + '/cdna.bam'
        };

        console.log(data);
        browser.sleep(50).then(function () {
            utilities.putApi('ion', '/api/v1/aliquot/' + clia.molecularId, data)
        }).then(callback)
    });

    this.Then(/^I see variant report details for the generated MSN$/, function (callback) {
        //Entering the new MSN generated in to the search field
        clia.tableElement.element(by.css('input')).sendKeys(clia.molecularId);
        browser.waitForAngular().then(function () {
            var firstRow = element.all(by.css('[ng-repeat^="item in filtered"]')).get(0)
            expect(firstRow.all(by.binding('item.molecular_id')).get(0).getText()).to.eventually.eql(clia.molecularId);
            expect(firstRow.all(by.css('a')).get(0).isPresent()).to.eventually.eql(true);
            expect(firstRow.all(by.css('a')).get(0).getText()).to.eventually.eql(clia.molecularId);
            expect(firstRow.all(by.css('a')).get(0).getAttribute('href')).to.include('molecular_id=' + clia.molecularId)
        }).then(callback)
    });

    this.When(/^I capture the new MSN created$/, function (callback) {
        var oldMolecularIds = [];
        var newMolecularIds = [];
        for (var i = 0; i < clia.responseData.length; i++) {
            oldMolecularIds.push(clia.responseData[i]["molecular_id"]);
        }
        for (var i = 0; i < clia.newResponseData.length; i++) {
            newMolecularIds.push(clia.newResponseData[i]["molecular_id"]);
        }
        clia.newMSNObject = clia.newResponseData.filter(function (item) {
            return oldMolecularIds.indexOf(item["molecular_id"]) < 0;
        })[0];

        console.log(clia.newMSNObject);
        browser.sleep(50).then(callback);
    });

    this.Then(/^I verify that I am on the sample control page for that molecularId$/, function (callback) {
        var expectedResult = '/?site=' + clia.site + '&type=' + clia.urlType + '&molecular_id=' + clia.molecularId
        expect(browser.getCurrentUrl()).to.eventually.include(expectedResult).notify(callback);
    });

    this.Then(/^I verify all the headings on the "(left|right)" hand side section under Positive Sample Control$/, function (side, callback) {
        var expectedHeaders = clia.expPositiveSampleHeaders[side];
        var index = side === 'left' ? 0 : 1;
        var actualHeadings  = clia.sampleDetailHeaders.get(index).all(by.css('dt'));
        browser.sleep(30).then(function () {
            utilities.checkElementArray(actualHeadings, expectedHeaders)
        }).then(callback);
    });

    this.Then(/^I verify all the headings on the "(left|right)" hand side section under "(No Template Control|Proficiency And Competency)"$/, function (side, header, callback) {
        var tableType = header === 'No Template Control' ? clia.expNonTempCrtlHeaders : clia.expProfAndCompCrtlHeaders
        var expectedHeaders = tableType[side];
        var index = side === 'left' ? 0 : 1;
        var actualHeadings  = clia.sampleDetailHeaders.get(index).all(by.css('dt'));
        browser.sleep(30).then(function () {
            utilities.checkElementArray(actualHeadings, expectedHeaders)
        }).then(callback);
    });

    this.Then(/^I verify all the values on the left hand side section under Positive Sample Control$/, function (callback) {
        expect(clia.sampleDetailMolecId.getText()).to.eventually.include(clia.responseData['molecular_id']);
        expect(clia.sampleDetailAnalysisId.getText()).to.eventually.include(clia.responseData['analysis_id']);
        expect(clia.sampleDetailLoadedDt.getText()).to.eventually.include(moment.utc(clia.responseData['date_molecular_id_created']).utc().format('LLL'));
        expect(clia.sampleDetailTorrentVer.getText()).to.eventually.include(clia.responseData['torrent_variant_caller_version']);
        expect(clia.sampleDetailPosCtrlVer.getText()).to.eventually.include(clia.responseData['positive_control_version']);
        expect(clia.sampleDetailRecvdDate.getText()).to.eventually.include(moment.utc(clia.responseData['date_variant_received']).utc().format('LLL'));
        expect(clia.sampleDetailStatus.getText()).to.eventually.include(clia.responseData['report_status']).notify(callback);
    });

    this.Then(/^I verify all the values on the left hand side section under "(No Template Control|Proficiency And Competency)"$/, function (headerType, callback) {
        expect(clia.sampleDetailMolecId.getText()).to.eventually.include(clia.responseData['molecular_id']);
        expect(clia.sampleDetailAnalysisId.getText()).to.eventually.include(clia.responseData['analysis_id']);
        expect(clia.sampleDetailTorrentVer.getText()).to.eventually.include(clia.responseData['torrent_variant_caller_version']);
        expect(clia.sampleDetailRecvdDate.getText()).to.eventually.include(moment.utc(clia.responseData['date_variant_received']).utc().format('LLL'));
        expect(clia.sampleDetailStatus.getText()).to.eventually.include(clia.responseData['report_status']).notify(callback);
    });

    this.Then(/^I verify all the values on the right hand side section under Positive Sample Control$/, function (callback) {
        expect(clia.sampleDetailCell.getText()).to.eventually.include(clia.responseData['cellularity']);
        expect(clia.sampleDetailMAPD.getText()).to.eventually.include(clia.responseData['mapd']);
        expect(clia.sampleDetailTotVariant.getText()).to.eventually.include(clia.responseData['total_variants']).notify(callback);
    });


    this.Then(/^I verify all the values on the right hand side section under "(No Template Control|Proficiency And Competency)"$/, function (headerType, callback) {
        expect(clia.sampleDetailCell.getText()).to.eventually.include(clia.responseData['cellularity']);
        expect(clia.sampleDetailMAPD.getText()).to.eventually.include(clia.responseData['mapd']);
        expect(clia.sampleDetailTotVariant.getText()).to.eventually.include(clia.responseData['total_variants']).notify(callback);
    });

    this.Then(/^I verify the presence of Positive controls and False positive variants table$/, function (callback) {
        expect(clia.sampleDetailTableHead.get(0).getText()).to.eventually.eql('Positive Controls');
        expect(clia.sampleDetailTableHead.get(1).getText()).to.eventually.eql('False Positive Variants').notify(callback);
    });

    this.When(/^I verify the presence of SNVs, CNVs and Gene Fusions Table$/, function (callback) {
        expect(clia.sampleDetailTableHead.get(0).getText()).to.eventually.eql('SNVs/MNVs/Indels');
        expect(clia.sampleDetailTableHead.get(1).getText()).to.eventually.eql('Copy Number Variants');
        expect(clia.sampleDetailTableHead.get(2).getText()).to.eventually.eql('Gene Fusions').notify(callback);
    });

    this.Then(/^I verify that valid IDs are links and invalid IDs are not in "(Positive Controls|False Positive Variants)" table$/, function (tableName, callback) {
        var presentIDList;
        if (tableName === 'Positive Controls') {
            presentIDList = clia.samplePositivePanel.all(by.css('[ng-if$="item.identifier"]'));
        } else {
            presentIDList = clia.sampleFalsePosPanel.all(by.css('cosmic-link[link-id="item.identifier"]'))
        }
        presentIDList.count().then(function (cnt) {
            for(var i = 0; i < cnt; i ++){
                utilities.checkCosmicLink(presentIDList.get(i))
            }
        }).then(callback)
    });

    this.Then(/^I verify the valid Ids are links in the SNVs\/MNVs\/Indels table under "(No Template Control|Proficiency And Competency)"$/, function (sectionName, callback) {
        var panel        = sectionName === 'No Template Control' ? clia.ntcSNVPanel : clia.proficiencySNVPanel;
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
        var panel   = sectionName === 'No Template Control' ? clia.ntcCNVPanel : clia.proficiencyCNVPanel;
        var idList  = panel.all(by.css('cosmic-link[link-id="item.identifier"]'));
        idList.count().then(function(cnt){
            for (var i = 0; i < cnt; i++){
                utilities.checkGeneLink(idList.get(i));
            }
        }).then(callback);
    });

    this.Then(/^I verify the valid Ids are links in the Gene Fusions table under "(No Template Control|Proficiency And Competency)"$/, function (sectionName, callback) {
        var panel   = sectionName === 'No Template Control' ? clia.ntcGeneFusionPanel : clia.proficiencyGFPanel
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
};
