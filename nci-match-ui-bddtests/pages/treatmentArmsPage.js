/**
 * Created by raseel.mohamed on 6/9/16
 */

var utils = require('../support/utilities');


var TreatmentArmsPage = function() {
    var treatment_id;
    //List of Elements on the Treatment Page
    //List of all the treatment arms on the treatment arms landing page.
    this.taTable = element(by.css('[dt-options="TreatmentArmsCtrl.dtOptions"]'));

    // HEader of the above table
    this.taTableHeaderArray = element.all(by.css('[dt-options="TreatmentArmsCtrl.dtOptions"] th[class^="sorting"]'));

    // List of all Patients Table Assigned to the selected treatment arm as seen on the treatment arms detailed page.
    this.patientTaTable = element(by.css('[dt-options="TaCtrl.dtOptions"]'));

    // Returns an array of all the rows in the treatment arm table.
    this.taTableData = element.all(by.css('[ng-repeat="treatmentArm in treatmentArmList"]'));

    // The labels within Left side box on the treatment arm  details page that shows the Name, Description etc.
    this.leftInfoBoxLabels = element.all(by.css('#left-info-box dt'));
    // The values of the labels within the left side box
    this.leftInfoBoxItems = element.all(by.css('#left-info-box dd'));
    // The drop down showing the versions of the treatment Arm
    this.versionDropDown = element(by.css('.wrap-dd-select.ng-isolate-scope'));

    // Download PDF
    this.downloadPDFButton = element(by.css('button[title="Export Variant Report to PDF"]'));
    //Download Excel
    this.downloadExcelButton = element(by.css('button[title="Export Variant Report to Excel"]'));

    // The labels right Left side box on the treatment arm  details page that shows the Gene, Patient Assigned etc.
    this.rightInfoBoxLabels = element.all(by.css('#right-info-box dt'));
    // The values of the labels within the right side box
    this.rightInfoBoxItems = element.all(by.css('#left-info-box dd'));

    // Three main tabs showing Analysis, Rules and History
    this.middleMainTabs = element.all(by.css('a[uib-tab-heading-transclude=""]'));
    // Seven tabs under the Rules main tab.
    this.rulesSubTabLinks = element.all(by.css('.panel-body .ng-isolate-scope>a'));
    // The panel for the seven tabs under the Rules. This is one higher than the rulesSubtab, but has the properties to look for
    this.rulesSubTabPanels = element.all(
        by.css('.panel-body [ng-class="[{active: active, disabled: disabled}, classes]"]'));

    // returns the element array that maps to the chart legends on the Analysis tab
    this.tableLegendArray = element.all(by.css('.ibox-content>div[style="float:left"]'));

    //Container for the patient Assignment Outcome
    this.patientPieChart = element(by.css('#patientPieChartContainer'));

    //Container for the Diseases Chart
    this.diseasePieChart = element(by.css('#diseasePieChartContainer'));

    //History tab subheading
    this.historyTabSubHeading = element(by.css('.panel-body>.table-hover th'));
    // History list of versions
    this.listOfVersions = element.all(by.css('.panel-body>.table-hover>tbody>tr>.ng-binding'));

    // Left info box
    this.taName = element.all(by.binding('taid'));
    this.taDescription = element(by.binding('information.description'));
    this.taStatus = element(by.binding('information.currentStatus'));
    this.taVersion = element(by.binding('dropdownModel[labelField]'));
    
    // Right info box
    this.taGene = element(by.binding('information.genes'));
    this.taPatientsAssigned = element(by.binding('information.patientsAssigned'));
    this.taDrug= element(by.binding('information.drug'));

    // Inclusion/exclusion button
    this.inclusionButton = element(by.css('.active>.ng-scope>.ibox label[ng-class="getInExclusionTypeClass(\'inclusion\')"]'));
    this.exclusionButton = element(by.css('.active>.ng-scope>.ibox label[ng-class="getInExclusionTypeClass(\'exclusion\')"]'));

    //Inclusion / Exclusion Active Table
    this.inclusionTable = element.all(
        by.css('.active>.panel-body>.ibox [ng-if="inExclusionType == \'inclusion\'"] .dataTables_wrapper>.row>.col-sm-12>table>tbody>tr.ng-valid'));
    this.exclusionTable = element.all(
        by.css('.active>.panel-body>.ibox [ng-if="inExclusionType == \'exclusion\'"] .dataTables_wrapper>.row>.col-sm-12>table>tbody>tr.ng-valid'));

    // Assay table elements
    this.assayColumn = element.all(by.binding('item.assay'));
    this.assayGeneName = element.all(by.binding('item.gene_name'));
    this.assayResult = element.all(by.binding('item.result'));
    this.assayVariantAssc = element.all(by.binding('item.variantAssociation'));
    this.assayLOE = element.all(by.binding('item.level_of_evidence'));
    this.assayTableRepeater = element.all(by.css('tr[ng-repeat="item in selectedVersion.nonSequencingAssays"]'));

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
    this.expectedLeftBoxLabels = ['Name', 'Description', 'Status', 'Version'];
    this.expectedRightBoxLabels = ['Gene(s)', 'Patients Assigned', 'Drug', 'Download'];
    this.expectedTableHeaders = [
        "Name",
        "Current Patients",
        "Former Patients",
        "Not Enrolled Patients",
        "Pending Arm Approval",
        "Status",
        "Date Open",
        "Date Suspended/Closed"
    ];
    this.expectedMainTabs = ['Analysis', 'Rules', 'History'];
    this.expectedRulesSubTabs =
        ['Drugs / Diseases', 'SNV / MNV', 'Indel', 'CNV', 'Gene Fusion', 'Non-Hotspot Rules', 'Non-Sequencing Assays'];


    /** This function returns the text that the name of the Treatment Arm in the row.
     * @params = tableElement [WebElement] Represents collection of rows
     * @params = rownum [Integer] Zero ordered integer representing the row in the table. 
     * returns string with  
     */
    this.returnTreatmentArmId = function(tableElement, rownum){
        var row = tableElement.get(rownum);
        return row.all(by.css('td>a[href^="#/treatment-arm"]')).getText().then(function(name){
            setTreatmentArmId(name[0]);
            return name[0];
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

    this.generateArmDetailForVariant = function (taArmJson, variantName, condition){
        var variant = getActualVariantName(variantName);
        var variant_report = taArmJson['variant_report'][variant];
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
        var repeaterValue = 'item in selectedVersion.snvs' + inclusionType;
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
        var rowList = element.all(by.repeater(repeaterValue));
        var med_id_string = getMedIdString(firstData['public_med_ids']);

        expect(rowList.count()).to.eventually.equal(data.length);

        // Locator Strings for columns
        var oncomineLoc= 'td:nth-of-type(1)'; //todo
        var geneLoc = '[ng-click="openGene(item.gene_name)"]';
        var functionLoc = 'td:nth-of-type(3)';
        var proteinLoc = 'td:nth-of-type(4)';
        var exonLoc = 'td:nth-of-type(5)';
        var proteinRegexLoc = 'td:nth-of-type(6)'; //todo
        var loeLoc = 'td:nth-of-type(7)';
        var litTableLoc = 'td:nth-of-type(8)';
        
        rowList.count().then(function (count) {
            if (count > 0){
                rowList.each(function (row, index) {
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

    this.checkDrugsTable = function(refData, repeaterString){
        // Grabbing the first data from the API response.
        var firstData = refData[0];
        var keymap = KeyMapConstant['drugs'];
        var rowList = element.all(by.repeater(repeaterString));

        var drugName = firstData[keymap['name']];
        var description = firstData[keymap['description']];
        var drugId = firstData[keymap['drug_id']];
        
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
                    row.all(by.binding('item.gene_name')).get(0).getText().then(function (gName) {
                    });
                    if (gName === assayGene){
                        utils.checkValueInTable(row.all(by.binding('item.gene_name')), assayGene);
                        utils.checkValueInTable(row.all(by.binding('item.result')), assayResult);
                        // utils.checkValueInTable(row.all(by.binding('item.description')), assayDescription);
                        utils.checkValueInTable(row.all(by.binding('item.level_of_evidence')), assayLOE);
                        utils.checkValueInTable(row.all(by.binding('item.variantAssociation')), assayVariant);
                        // utils.checkValueInTable(row.all(by.binding('item.gene_name')), assayColumn);
                    }

                })
            }

        })

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
            'SNV / MNV'         : 'single_nucleotide_variants',
            'Indel'             : 'indels',
            'CNV'               : 'copy_number_variants',
            'Non-Hotspot Rules' : 'non_hotspot_rules',
            'Gene Fusion'       : 'gene_fusions'
        };
        return variantMapping[variantName];
    }

    function setTreatmentArmId(ta_id){
        treatment_id = ta_id
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