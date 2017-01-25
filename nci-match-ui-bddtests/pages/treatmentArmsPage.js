/**
 * Created by raseel.mohamed on 6/9/16
 */

var utils = require('../support/utilities');


var TreatmentArmsPage = function() {
    var treatment_id;
    this.currentTreatmentId = '';
    this.currentStratumId = '';
    //List of Elements on the Treatment Page
    //List of all the treatment arms on the treatment arms landing page.
    this.taTable = element(by.id('treatmentArmGrid'));

    // HEader of the above table
    this.taTableHeaderArray = this.taTable.all(by.css('th'));

    // Patients Table That contains all the patient list Assigned to the selected treatment arm as seen on the treatment arms detailed page.
    this.allPatientsDataTable = element(by.css('#allPatientsData'));
    this.allPatientDataRows   = this.allPatientsDataTable.all(by.css('[ng-repeat^="item in filtered"]'));
    this.expecrtedPatientsDataTableHeaders = [
        'Patient ID', 'TA Version', 'Patient Assignment Status Outcome',
        'Variant Report', 'Assignment Report', 'Date Selected',
        'Date On Arm', 'Date Off Arm', 'Time On Arm', 'Step', 'Disease', 'Reason' ]

    // Returns an array of all the rows in the treatment arm table.
    this.taTableData = element.all(by.css('a[href^="#/treatment-arm?"]'));

    // The labels within Left side box on the treatment arm  details page that shows the Name, Description etc.
    this.leftInfoBoxLabels = element.all(by.css('#left-info-box dt'));
    // The values of the labels within the left side box
    this.leftInfoBoxItems = element.all(by.css('#left-info-box dd'));
    // The drop down showing the versions of the treatment Arm
    this.versionDropDownSelector = element(by.css('button#btn-append-to-body'));

    // Download PDF
    this.downloadPDFButton = element(by.css('button[title="Export Variant Report to PDF"]'));
    //Download Excel
    this.downloadExcelButton = element(by.css('button[title="Export Variant Report to Excel"]'));

    // The labels right Left side box on the treatment arm  details page that shows the Gene, Patient Assigned etc.
    this.rightInfoBoxLabels = element.all(by.css('#right-info-box dt'));
    // The values of the labels within the right side box
    this.rightInfoBoxItems = element.all(by.css('#right-info-box dd'));

    // Three main tabs showing Analysis, Rules and History
    this.middleMainTabs = element.all(by.css('a[uib-tab-heading-transclude=""]'));
    // Seven tabs under the Rules main tab.
    this.rulesSubTabLinks = element.all(by.css('.panel-body .ng-isolate-scope>a'));
    // The panel for the seven tabs under the Rules. This is one higher than the rulesSubtab, but has the properties to look for
    this.rulesSubTabPanels = element.all(
        by.css('.panel-body [ng-class="[{active: active, disabled: disabled}, classes]"]'));

    // returns the element array that maps to the chart legends on the Analysis tab
    this.patientLegendContainer = element(by.css('[ng-if="patientPieChartDataset.hasData"]'));
    this.diseaseLegendContainer = element(by.css('[ng-if="diseasePieChartDataset.hasData"]'));
    this.tableLegendArray = element.all(by.css('.ibox-content>div[style="float:left"]'));

    //Container for the patient Assignment Outcome
    this.patientPieChart = element(by.css('#patientPieChartContainer'));

    //Container for the Diseases Chart
    this.diseasePieChart = element(by.css('#diseasePieChartContainer'));

    //History tab subheading
    this.historyTabSubHeading = element(by.css('.tab-pane.active>.panel-body>.ibox-title'));
    // History list of versions
    this.listOfVersions = element.all(by.repeater('version in versionHistory'));

    // Left info box
    this.taName = element(by.binding('currentVersion.name'));
    this.taStratum = element(by.binding('currentVersion.stratum_id'));
    this.taDescription = element(by.binding('currentVersion.description'));
    this.taStatus = element(by.binding('currentVersion.treatment_arm_status'));
    this.taVersion = element.all(by.binding('currentVersion.version')).get(0);
    this.taVersionDropdownList = element.all(by.css('li[ng-repeat="item in versions"]')); // this is the version drop down

    // Right info box
    this.taGene = element(by.binding('currentVersion.gene'));
    this.taPatientsAssigned = element(by.binding('currentVersion.version_statistics.current_patients'));
    this.taTotalPatientsAssigned = element(by.binding('currentVersion.stratum_statistics.current_patients'));
    this.taDrug= element.all(by.repeater('drug in currentVersion.treatment_arm_drugs'));

    // Inclusion/exclusion button
    this.inclusionButton = element(by.css(".active>.ng-scope>.btn-group>.btn-group>label[ng-click=\"setInExclusionType('inclusion')\"]"));
    this.exclusionButton = element(by.css(".active>.ng-scope>.btn-group>.btn-group>label[ng-click=\"setInExclusionType('exclusion')\"]"));

    //Inclusion / Exclusion Active Table
    this.inclusionTable = element.all(
        by.css('.active>.panel-body>.ibox [ng-if="inExclusionType == \'inclusion\'"] .dataTables_wrapper>.row>.col-sm-12>table>tbody>tr.ng-valid'));
    this.exclusionTable = element.all(
        by.css('.active>.panel-body>.ibox [ng-if="inExclusionType == \'exclusion\'"] .dataTables_wrapper>.row>.col-sm-12>table>tbody>tr.ng-valid'));
    this.inclusionsnvTable = element.all(by.css('#snvsMnvsIndelsIncl tr[ng-repeat^="item in filtered"]'));
    this.exclusionsnvTable = element.all(by.css('#snvsMnvsIndelsExcl tr[ng-repeat^="item in filtered"]'));
    this.inclusionNHRTable = element.all(by.css('#nonHotspotRulesIncl tr[ng-repeat^="item in filtered"]'));
    this.exclusionNHRTable = element.all(by.css('#nonHotspotRulesExcl tr[ng-repeat^="item in filtered"]'));

    // Assay table elements
    this.assayTableRepeater = element.all(by.css('#nonSequencingAssays tr[ng-repeat^="item in filtered"]'));
    this.assayGene = element.all(by.binding('item.gene'));
    this.assayResult = element.all(by.binding('item.assay_result_status'));
    this.assayVariantAssc = element.all(by.binding('item.assay_variant'));
    this.assayLOE = element.all(by.binding('item.level_of_evidence'));

    // Key map for Drugs and Diseases values from the treatment arm api call
    var KeyMapConstant = {
        'drugs'    : {
            'name'      : 'name',
            'id'        : 'drug_id'
        },
        'diseases' : {
            'name'      : 'short_name',
            'medraCode' : 'medra_code',
            'id'        : '_id',
            'category'  : 'ctep_category'
        }
    };

    //List of Expected values
    this.expectedLeftBoxLabels = ['ID', 'Name', 'Stratum ID', 'Description', 'Status', 'Version'];
    this.expectedRightBoxLabels = ['Genes', 'Patients Assigned on Version', 'Total Patients Assigned', 'Drugs', 'Download'];
    this.expectedTableHeaders = [
        "Name",
        "Current Patients",
        "Former Patients",
        "Not Enrolled Patients",
        "Pending Arm Approval",
        "Status",
        "Date Opened",
        "Date Suspended/Closed"
    ];
    this.expectedMainTabs = ['Analysis', 'Rules', 'History'];
    this.expectedRulesSubTabs =
        ['Drugs / Diseases', 'SNVs / MNVs / Indels', 'CNVs', 'Gene Fusions', 'Non-Hotspot Rules', 'Non-Sequencing Assays'];


    /** This function returns the text that the name of the Treatment Arm in the row.
     * @params = tableElement [WebElement] Represents collection of rows
     * @params = rownum [Integer] Zero ordered integer representing the row in the table.
     * returns String [treatmentArm (startumID)]
     */
    this.returnTreatmentArmId = function(tableElement, rownum){
        var row = tableElement.get(rownum);
        return row.getText().then(function(name){
            return name;
        });
    };

    this.checkIfTabActive = function(elementArray, index) {
        elementArray.get(index).getAttribute('class').then(function (listOfClassAttrib){
            var attribArray = listOfClassAttrib.split(' ');
            // Get the last element of the array
            expect(attribArray[attribArray.length -1]).to.equal('active');
        });
    };

    this.getTreatmentArmId = function() {
        return treatment_id;
    };

    this.setTreatmentArmId = function (ta_id){
        treatment_id = ta_id
    };

    this.generateArmDetailForVariant = function (taArmJson, variantName, condition){
        var variant = getActualVariantName(variantName);
        var variant_report = taArmJson[variant];
        var result = [];
        var flag;
        if (condition == 'Inclusion') {
            flag = true;
        }else {
            flag = false;
        }

        for (var i = 0; i < variant_report.length; i ++) {
            if (variant_report[i]['inclusion'] == flag) {
                result.push(variant_report[i]);
            }
        }
        return result;
    };

    this.checkSNVTable = function(data, tableType, inclusionType) {
        expect(tableType.count()).to.eventually.equal(data.length);
        var firstData = data[0];
        var repeaterValue = 'item in currentVersion.snvs' + inclusionType;
        var rowList = element.all(by.repeater(repeaterValue));
        var med_id_string = getMedIdString(firstData['public_med_ids']);

        // Locator Strings for columns
        var idLoc = '[ng-click="openId(item.identifier)"]';
        var geneLoc = '[ng-click="openGene(item.gene_name)"]';
        var chrLoc = 'td:nth-of-type(3)';
        var posLoc = 'td:nth-of-type(4)';
        var referenceLoc = 'td:nth-of-type(5)';
        var alternateLoc = 'td:nth-of-type(6)';
        var proteinLoc = 'td:nth-of-type(7)';
        var loeLoc = 'td:nth-of-type(8)';
        var litTableLoc = 'td:nth-of-type(9)';

        // var id = element.all(by.binding('item.identifier'));
        // var gene = element.all(by.binding('item.gene_name'));
        // var chr = element.all(by.binding('item.chromosome'));
        // var pos = element.all(by.binding('item.position'));
        // // var ref = element.all(by.binding('item.reference'));
        // // var alt = element.all(by.binding('item.alternative'));
        // var protein = element.all(by.binding('item.description'));
        // var loe = element.all(by.binding('item.level_of_evidence'));
        //
        rowList.count().then(function (count){
            if (count > 0){
                rowList.each(function (row, index) {
                    row.all(by.css(idLoc)).get(0).getText().then(function(text){
                        if (text == firstData.identifier){
                            utils.checkValueInTable(row.all(by.css(geneLoc)), firstData['gene_name']);
                            utils.checkValueInTable(row.all(by.css(chrLoc)), firstData['chromosome']);
                            utils.checkValueInTable(row.all(by.css(posLoc)), firstData['position']);
                            utils.checkValueInTable(row.all(by.css(referenceLoc)), firstData['reference']);
                            utils.checkValueInTable(row.all(by.css(alternateLoc)), firstData['alternative']);
                            utils.checkValueInTable(row.all(by.css(proteinLoc)), firstData['description']);
                            utils.checkValueInTable(row.all(by.css(loeLoc)), firstData['level_of_evidence']);
                            utils.checkValueInTable(row.all(by.css(litTableLoc)), med_id_string);
                        }
                    });
                });
            }
        });
    };

    this.checkIndelTable = function(data, tableType, inclusionType){
        expect(tableType.count()).to.eventually.equal(data.length);
        var firstData = data[0];
        var repeaterValue = 'item in selectedVersion.indels' + inclusionType;
        var rowList = element.all(by.repeater(repeaterValue));
        var med_id_string = getMedIdString(firstData['public_med_ids']);

        // Locator strings for columns
        var idLoc = '[ng-click="openId(item.identifier)"]';
        var geneLoc = '[ng-click="openGene(item.gene_name)"]';
        var chrLoc = 'td:nth-of-type(3)';
        var posLoc = 'td:nth-of-type(4)';
        var referenceLoc = 'td:nth-of-type(5)';
        var alternateLoc = 'td:nth-of-type(6)';
        var proteinLoc = 'td:nth-of-type(7)';
        var loeLoc = 'td:nth-of-type(8)';
        var litTableLoc = 'td:nth-of-type(9)';

        rowList.count().then(function (count) {
            if (count > 0){
                rowList.each(function (row, index) {
                    row.all(by.css(idLoc)).get(0).getText().then(function(text){
                        if (text == firstData.identifier){
                            utils.checkValueInTable(row.all(by.css(geneLoc)), firstData['gene_name']);
                            utils.checkValueInTable(row.all(by.css(chrLoc)), firstData['chromosome']);
                            utils.checkValueInTable(row.all(by.css(posLoc)), firstData['position']);
                            utils.checkValueInTable(row.all(by.css(referenceLoc)), firstData['reference']);
                            utils.checkValueInTable(row.all(by.css(alternateLoc)), firstData['alternative']);
                            utils.checkValueInTable(row.all(by.css(proteinLoc)), firstData['description']);
                            utils.checkValueInTable(row.all(by.css(loeLoc)), firstData['level_of_evidence']);
                            utils.checkValueInTable(row.all(by.css(litTableLoc)), med_id_string);
                        }
                    });
                });
            }
        });
    };

    this.checkCNVTable = function(data, tableType, inclusionType){

        var firstData = data[0];
        var repeaterValue = 'item in selectedVersion.cnvs' + inclusionType;
        var rowList = element.all(by.repeater(repeaterValue));
        var med_id_string = getMedIdString(firstData['public_med_ids']);

        expect(rowList.count()).to.eventually.equal(data.length);
        // Locator strings for columns
        var geneLoc = '[ng-click="openGene(item.gene_name)"]';
        var chrLoc = 'td:nth-of-type(2)';
        var posLoc = 'td:nth-of-type(3)';
        var proteinLoc = 'td:nth-of-type(4)';
        var loeLoc = 'td:nth-of-type(5)';
        var litTableLoc = 'td:nth-of-type(6)';

        rowList.count().then(function (count) {
            if (count > 0){
                rowList.each(function (row, index) {
                    row.all(by.css(geneLoc)).get(0).getText().then(function(text){
                        if (text == firstData['gene_name']){
                            utils.checkValueInTable(row.all(by.css(geneLoc)), firstData['gene_name']);
                            utils.checkValueInTable(row.all(by.css(chrLoc)), firstData['chromosome']);
                            utils.checkValueInTable(row.all(by.css(posLoc)), firstData['position']);
                            utils.checkValueInTable(row.all(by.css(proteinLoc)), firstData['description']);
                            utils.checkValueInTable(row.all(by.css(loeLoc)), firstData['level_of_evidence']);
                            utils.checkValueInTable(row.all(by.css(litTableLoc)), med_id_string);
                        }
                    });
                });
            }
        });
    };

    this.checkGeneFusionTable = function (data, tableType, inclusionType){
        // expect(tableType.count()).to.eventually.equal(data.length);
        var firstData = data[0];
        var repeaterValue = 'item in selectedVersion.geneFusions' + inclusionType;
        var rowList = element.all(by.repeater(repeaterValue));
        var med_id_string = getMedIdString(firstData['public_med_ids']);

        expect(rowList.count()).to.eventually.equal(data.length);

        // Locator strings for columns
        var idLoc = '[ng-click="openId(item.identifier)"]';
        var geneLoc = '[ng-click="openGene(item.gene_name)"]';
        var loeLoc = 'td:nth-of-type(3)';
        var litTableLoc = 'td:nth-of-type(4)';

        rowList.count().then(function (count) {
            if (count > 0){
                rowList.each(function (row, index) {
                    row.all(by.css(idLoc)).get(0).getText().then(function(text){
                        if (text == firstData.identifier){
                            utils.checkValueInTable(row.all(by.css(geneLoc)), firstData['gene_name']);
                            utils.checkValueInTable(row.all(by.css(loeLoc)), firstData['level_of_evidence']);
                            utils.checkValueInTable(row.all(by.css(litTableLoc)), med_id_string);
                        }
                    });
                });
            }
        });
    };

    this.checkNonHotspotRulesTable = function(data, tableType, inclusionType){
        var firstData = data[0];
        var repeaterValue = 'item in selectedVersion.nhrs' + inclusionType;
        var med_id_string = getMedIdString(firstData['public_med_ids']);

        expect(tableType.count()).to.eventually.equal(data.length);

        // Locator Strings for columns
        var oncomineLoc= 'td:nth-of-type(1)'; //todo
        var geneLoc = '[ng-click="openGene(item.gene_name)"]';
        var functionLoc = 'td:nth-of-type(3)';
        var proteinLoc = 'td:nth-of-type(4)';
        var exonLoc = 'td:nth-of-type(5)';
        var proteinRegexLoc = 'td:nth-of-type(6)'; //todo
        var loeLoc = 'td:nth-of-type(7)';
        var litTableLoc = 'td:nth-of-type(8)';
        tableType.count().then(function (count) {
            if (count > 0){
                tableType.each(function (row, index) {
                    row.all(by.css(functionLoc)).get(0).getText().then(function(text){
                        if (text == firstData.function){
                            utils.checkValueInTable(row.all(by.css(oncomineLoc)), firstData['oncomine_variant_class'])
                            utils.checkValueInTable(row.all(by.css(geneLoc)), firstData['gene_name']);
                            utils.checkValueInTable(row.all(by.css(functionLoc)), firstData['function']);
                            utils.checkValueInTable(row.all(by.css(proteinLoc)), firstData['description']);
                            utils.checkValueInTable(row.all(by.css(exonLoc)), firstData['exon']);
                            utils.checkValueInTable(row.all(by.css(proteinRegexLoc)), firstData['proteinMatch']);
                            utils.checkValueInTable(row.all(by.css(loeLoc)), firstData['level_of_evidence']);
                            utils.checkValueInTable(row.all(by.css(litTableLoc)), med_id_string);
                        }
                    });
                });
            }
        });
    };


    /**
     * Check the drugs table.
     * @param refData - Array of data retrieved from the api call
     * @param repeaterString - The string that is used as the repeater for the table.
     */
    this.checkDrugsTable = function(refData, repeaterString){
        // Grabbing the first data from the API response.
        var firstData = refData[0];
        var keymap = KeyMapConstant['drugs'];
        var rowList = element.all(by.repeater(repeaterString));

        var drugName = firstData[keymap['name']];
        var description = firstData[keymap['description']];
        var drugId = firstData[keymap['id']];

        expect(rowList.count()).to.eventually.equal(refData.length);

        rowList.count().then(function (rowCount) {
            if ( rowCount > 0 ) {
                rowList.each(function (row, index) {
                    row.all(by.binding('item.name')).get(0).getText().then(function (name) {
                        if (name === drugName) {
                            utils.checkValueInTable(row.all(by.binding('item.name')), drugName);
                            utils.checkValueInTable(row.all(by.binding('item.id')), drugId);
                        }
                    })
                })
            }
        });
    };

    /**
     * Check the diseases table.
     * @param refData - Array of data retrieved from the api call
     * @param repeaterString - The string that is used as the repeater for the table.
     */
    this.checkDiseasesTable = function(refData, repeaterString){
        var ctepCategoryLoc = '.ng-binding:nth-of-type(1)';
        var ctepTermLoc = '.ng-binding:nth-of-type(2)';
        var medraCodeLoc = '.ng-binding:nth-of-type(3)';
        var rowList = element.all(by.repeater(repeaterString));
        var keymap = KeyMapConstant['diseases'];

        var ctepTermFromAPI = refData[0][keymap['name']];
        var ctepCategoryFromApi = refData[0][keymap['category']];
        var medraCodeFromApi = refData[0][keymap['medraCode']];
        var ctepId = refData[0][keymap.id];

        expect(rowList.count()).to.eventually.equal(refData.length);

        rowList.count().then(function (count) {
            if (count > 0){
                rowList.each(function (row, index){
                    row.all(by.css(ctepTermLoc)).get(0).getText().then(function (text){
                        if (text === ctepTermFromAPI){
                            utils.checkValueInTable(row.all(by.css(medraCodeLoc)), medraCodeFromApi);
                            utils.checkValueInTable(row.all(by.css(ctepCategoryLoc)), ctepCategoryFromApi);
                            utils.checkValueInTable(row.all(by.css(ctepCategoryLoc)), ctepCategoryFromApi);
                        };
                    });
                });
            }
        });
    };

    /**
     * This Function will receive the WebElement object depicting a row from the list and
     * return a hash of the treatment_arm and stratum
     * @param {WebElement} repeaterObject, the element whose text is needed
     * @param {int} index, a zero ordered index
     * @param {String} binding,  that is used to define the object
     *
     * @return {String} text of the string
     */
    this.retrieveTextByBinding = function(repeaterObject, index, binding){
        var deferred = protractor.promise.defer();
        repeaterObject.get(index).all(by.binding(binding)).get(0).getText().then(
            function retrieve(text) {
                deferred.fulfill(text);
            },
            function error(reason) {
                deferred.reject(reason)
            }
        );
        return deferred.promise;
    };

    this.checkAssayResultsTable = function (refData, repeater) {
        var firstData = refData[0];
        expect(repeater.count()).to.eventually.equal(refData.length);
        var assayResult = firstData['assay_result_status'];
        var assayDescription = firstData['description'];
        var assayGene = firstData['gene'];
        var assayLOE = firstData['level_of_evidence'];
        var assayVariant = firstData['assay_variant'];

        repeater.count().then(function (cnt) {
            if(cnt > 0) {
                repeater.each(function (row, index) {
                    row.all(by.css('cosmic-link[link-id="item.gene"]')).get(0).getText().then(function (gName) {
                        if (gName === assayGene){
                            utils.checkValueInTable(row.all(by.css('cosmic-link[link-id="item.gene"]')), assayGene);
                            utils.checkValueInTable(row.all(by.binding('item.assay_result_status')), assayResult);
                            // utils.checkValueInTable(row.all(by.binding('item.description')), assayDescription);
                            utils.checkValueInTable(row.all(by.binding('item.level_of_evidence')), assayLOE);
                            utils.checkValueInTable(row.all(by.binding('item.assay_variant')), assayVariant);
                            // utils.checkValueInTable(row.all(by.binding('item.gene_name')), assayColumn);
                        }
                    });
                })
            }
        })
    };

    this.getTablePrefix = function(tabName){
        var prefixMapping = {
            'SNVs / MNVs / Indels': 'snvsMnvsIndels',
            'CNVs': 'cnvs',
            'Gene Fusions': 'geneFusions',
            'Non-Hotspot Rules': 'nonHotspotRules'
        };
        return prefixMapping[tabName];
    };

    this.stripTreatmentArmId = function(completeId){
        return completeId.split(' ')[0];
    };

    this.stripStratumId = function(completeId){
        var startPos = completeId.indexOf('(') + 1;
        var endPos   = completeId.indexOf(')');
        return completeId.slice(startPos, endPos);
    };

    this.getTreatmentArmVersions = function(treatmentArm){
        var versionOrder;

        treatmentArm.forEach(function (elem, index) {
            versionOrder[index] = elem['version'];
        });
        return versionOrder
    };

    function getActualVariantName(variantName){
        var variantMapping = {
            'SNVs / MNVs / Indels' : 'snv_indels',
            'CNVs'                 : 'copy_number_variants',
            'Non-Hotspot Rules'    : 'non_hotspot_rules',
            'Gene Fusions'         : 'gene_fusions'
        };
        return variantMapping[variantName];
    }

    /**
     * Converts the array present in the treatment arm response JSON into a string where the elements are separated by
     * '\n'. if the value is undefined then 0 is returned. This is an anpnymous function.
     * @param data
     */
    function getMedIdString(data){
        if (data === undefined) {
            return 0;
        } else {
            return data.join('x').replace(/\s/g, '').replace(/x/g, '\n')
        }

    }
};

module.exports = new TreatmentArmsPage();
