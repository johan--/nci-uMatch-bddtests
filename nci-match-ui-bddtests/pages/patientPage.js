/**
 * Created by raseel.mohamed on 6/23/16
 */

var PatientPage = function () {
    var patientId;
    var patientData;
    var responseData;
    var variantReportId;

    // this.confirmedMoi;

    this.patientListTable = element(by.css('#patientGrid>table'));
    this.patientListHeaders = element.all(by.css('.sortable'));
    this.patientListRowElements = element.all(by.css('tr[ng-repeat^="item in filtered"]'));


    // Patient summary table information on the patient details page
    this.patientSummaryTable = element.all(by.css('.header-info-box.top-main-header-box')).get(0);
    // Expected Patient List Labels
    this.expectedPatientListHeaders = [
        'Patient ID',
        'Status',
        'Step Number',
        'Disease',
        'Treatment Arm',
        'Registration Date',
        'Status Date'
    ];
    // Patient Grid box
    this.patientGrid = element(by.id('patientGrid'))
    //Patient filter textbox
    this.patientFilterTextBox = this.patientGrid.all(by.model('filterAll'));
    // Patients in the grid
    this.patientGridRows      = this.patientGrid.all(by.repeater('item in filtered'));


    // Disease Summary table information on the patient details page.
    this.diseaseSummaryTable = element.all(by.css('.header-info-box.top-main-header-box')).get(1);
    //Patient details page main tabs
    this.actualMainTabs = element.all(by.binding('heading'));
    // This element gives access to the current active tab
    this.currentActiveTab = element(by.css('.active[ng-class="{active: tabset.active === tab.index}"]'));
    //This element captures the sub headings under all the Tabs.
    // Though it captures all the headings, only the active tab's headings are populated in the array
    this.mainTabSubHeadingArray = function() {return element.all(by.css('div.ibox-title.ibox-title-no-line-no-padding>h3'))};


    // *****************  Summary Tab  ********************//
    // Accessing the patient timeline
    this.patientTimelineElementArray = element.all(by.repeater('timelineEvent in data.timeline'));
    //Accessing the Treatment Arm History
    this.treatmentArmsHistoryElementArray = element.all(by.repeater('ta in data.ta_history'));

    // *****************  Surgical Event Tab  ********************//
    this.surgicalEventSectionHeading = element.all(by.css('div[ng-if="surgicalEvent"]>.ibox-title'));
    // Get all elements under the Surgical Event Panel
    this.surgicalEventPanel = element.all(by.css('div[ng-if="currentSurgicalEvent"]'));
    // This is the drop down button. Clicking this will give you access to the list of options.
    this.surgicalEventDropDownButton = element(by.binding('surgicalEventOption.text'));
    // List of Surgical Events from the drop down
    this.surgicalEventIdList = element.all(by.css('a[ng-click="onSurgicalEventSelected(item)"]'));
    // Access to the Summary boxes (Event and Pathology)
    this.surgicalEventSummaryBoxList = element.all(by.css('.biopsy-header-box'));
    // Expected Event and Pathology Labels
    this.biopsyHeaderBoxLabels = {
        'Event': {
            'index': 0,
            'labels': ['Surgical Event ID', 'Type', 'Collection Date', 'Received Date', 'Failure Date']
        },
        'Pathology': {
            'index': 1,
            'labels': ['Status', 'Received Date', 'Comment']
        }
    };

    // *****************  Surgical Event Tabs ********************//
    this.surgicalEventPanels = element.all(by.css('.specimen-event-panel'));
    this.surgicalEventId  = element(by.binding('surgicalEvent.surgical_event_id'));

    // *****************  Tissue Reports / Blood Specimens Tab  ********************//
    // This the master panel STRING for Tissue reports
    this.tissueMasterPanelString = 'div[ng-if="currentTissueVariantReport"]';
    // master panel string for Blood Specimens
    this.bloodMasterPanelString = 'div[ng-if="currentBloodVariantReport"]';
    //The String is the locator to get access to all the tables under the variant Report section namely, SNV, CNV and GeneFusion
    this.tissueTableString = 'div[ng-if="variantReportMode === \'FILTERED\'"]>.table-responsive';

    this.modalWindow = element(by.css('div.modal-content'));


    // the hash below gives you access to the repeater locator string for the table based on the type of variant
    this.tableTypeRepeaterString = {
        "SNVs/MNVs/Indels": "variant in currentTissueVariantReport.variants.snvs_and_indels",
        "Copy Number Variant(s)":"variant in currentTissueVariantReport.variants.copy_number_variants",
        "Gene Fusion(s)":"variant in currentTissueVariantReport.variants.gene_fusions"

    };

    // This the drop down for the surgical event under the Tissue Reports and blood variant.
    this.variantReportDropDown = element(by.binding('tissueVariantReportOption.text'));
    this.bloodVariantReportDropDown = element(by.binding('bloodVariantReportOption.text'));

    this.expectedSurgicalSectionHeading = ['Slide Shipments', 'Assay History', 'Specimen History']

    //These are the elements present in the summary boxes of tissue reports
    this.tissueSurgicalEventId     = element(by.binding('currentTissueVariantReport.surgical_event_id'));
    this.tissueAnalysisId          = element(by.binding('currentTissueVariantReport.analysis_id'));
    this.tissueMolecularId         = element(by.binding('currentTissueVariantReport.molecular_id'));
    this.tissueFileReceivedDate    = element(by.binding('currentTissueVariantReport.variant_report_received_date'));
    this.tissueReportStatus        = element(by.binding('currentTissueVariantReport.status'));
    this.tissueTotalVariants       = element(by.binding('currentTissueVariantReport.total_variants'));
    this.tissueTotalCellularity    = element(by.binding('currentTissueVariantReport.cellularity'));
    this.tissueTotalMois           = element(by.binding('currentTissueVariantReport.total_mois'));
    this.tissueTotalAMoisy         = element(by.binding('currentTissueVariantReport.total_amois'));
    this.tissueTotalConfirmedMois  = element(by.binding('currentTissueVariantReport.total_confirmed_mois'));
    this.tissueTotalConfirmedAMois = element(by.binding('currentTissueVariantReport.total_confirmed_amois'));

    this.variantConfirmButtonList      = element.all(by.css('input[type="checkbox"]')); // This is to check the properties
    this.variantConfirmButtonCLickList = element.all(by.css('button[ng-click="vm.confirm()"]')); // This is to perfom actions on the checkbox
    this.variantIdentifierList         = element.all(by.css('[link-id="item.identifier"]'));
    this.confirmChangeCommentField     = element(by.css('input[name="comment"]'));  // This is the confirmation modal for individual rejection
    this.confirmVRCHangeCommentField   = element(by.css('input[id="cgPromptInput"]')); // THis is the confirmation modal for the complete VR rejection
    this.gridElement                   = element.all(by.repeater('item in $ctrl.gridOptions.data')); // grid table for all the variants
    this.commentLinkString             = 'a[ng-click="$ctrl.editComment(item, $ctrl.isEditable )"]'; //the string to get to the comments in the grid

    this.rejectReportButton            = element(by.css('button[ng-click="rejectVariantReport(variantReport)"]'));
    this.confirmReportButton           = element(by.css('button[ng-click="confirmVariantReport(variantReport)"]'));

    this.assignmentReportConfirmButton = element(by.css('button[ng-click="confirmAssignmentReport(assignmentReport)"]'));
    // This is the assignment Report Section panel. You can get access to the other elements within this panel by using #all(by.<property>)
    this.assignmentReportSection = element.all(by.css("div[ng-if=\"variantReportMode!=='QC'\"]")).get(0);

    //These are the elements present in the summary boxes of Blood Specimens
    this.bloodAnalysisId        = element(by.binding('currentBloodVariantReport.analysis_id'));
    this.bloodMolecularId       = element(by.binding('currentBloodVariantReport.molecular_id'));
    this.bloodFileReceivedDate  = element(by.binding('currentBloodVariantReport.variant_report_received_date'));
    this.bloodReportStatus      = element(by.binding('currentBloodVariantReport.status'));
    this.bloodTotalVariants     = element(by.binding('currentBloodVariantReport.total_variants'));
    this.bloodTotalCellularity  = element(by.binding('currentBloodVariantReport.cellularity'));

    // This is the element found on the variant report page for a patient
    this.totalMois              =  element(by.binding('variantReport.total_mois'));
    this.totalAMois             = element(by.binding('variantReport.total_amois'));
    this.totalconfirmedMOIs     = element(by.binding('variantReport.total_confirmed_mois'));
    this.totalconfirmedAMOIs    = element(by.binding('variantReport.total_confirmed_amois'));
    this.variantReportStatus    = element.all(by.binding('variantReport.status'));

    // Elements found on Assignment Report TAB
    this.assignmentSummaryBoxes      = element.all(by.css('.assignment-header-box'));
    this.selectedAssignmentBoxHeader = element(by.css('div.panel-primary>div.panel-heading'));
    this.selectedAssignmentBoxText   = element(by.css('div.panel-primary>div.panel-body'));
    this.ruleNameList                = element.all(by.css('[ng-repeat-start="(ruleName, ruleDetails) in assignmentReport.treatment_assignment_results"]'));
    this.ruleDetailsList             = element.all(by.repeater('rule in ruleDetails'));





    // ****************** Expected values *******************//
    // Patient list table

    // Patient details page left hand side top summary
    this.expectedPatientSummaryLabels = [
        'Patient ID',
        'Patient',
        'Last Rejoin Scan Date',
        'Status',
        'Current Step',
        'Treatment Arm'
    ];
    // Patient details page right hand side top summary
    this.expectedDiseaseSummaryLabels = ['Disease Name', 'Disease Code Type', 'Disease Code', 'Prior Drugs'];

    this.expectedPatientMainTabs = [ 'Summary', 'Surgical Event', 'Blood Specimens', 'Documents'];

    this.expectedMainTabSubHeadings = [
        'Actions Needed', 'Patient Timeline',
        'Slide Shipments', 'Assay History', 'Specimen History',
        'SNVs/MNVs/Indels', 'Copy Number Variant(s)', 'Gene Fusion(s)',
        'SNVs/MNVs/Indels(s) ##', 'Copy Number Variant(s)', 'Gene Fusion(s)',
        'Patient Documents'
    ];

    // Expected Values in the Tissue Report Page.
    this.expVarReportTables = [ 'SNVs/MNVs/Indels', 'Copy Number Variant(s)', 'Gene Fusion(s)' ];
    this.expSNVTableHeadings = [ 'Confirm', 'Comment', 'ID', 'aMOI', 'Chrom', 'Position', 'CDS Ref', 'CDS Alt', 'OCP Ref',
        'OCP Alt', 'Strand', 'Allele Freq', 'Func Gene', 'Oncomine Variant Class', 'Exon', 'Function', 'HGVS', 'Read Depth ',
        'Transcript', 'Protein' ];
    this.expCNVTableHeadings = [ 'Confirm', 'Comment', 'ID', 'aMOI', 'Chrom', 'Raw CN', 'CN', 'CI 5%', 'CI 95%' ];
    this.expGFTableHeadings = [ 'Confirm', 'Comment', 'ID', 'aMOI', 'Gene 2', 'Gene 2 Count', 'Gene 1', 'Gene 1 Count', 'Annotation' ];

    //**************************** Timeline **********************//
    this.timelineList = element.all(by.repeater('timelineEvent in activity.data'));
    this.variantReportStatusString = '[ng-if="timelineEvent.event_data.variant_report_status"]';
    this.variantAnalysisIdString   = 'span[ng-if="timelineEvent.event_data.analysis_id"]';


    //**************************** Functions **********************//

    // For whatever zero based row that we want, get the patient Id for that row.
    this.returnPatientId = function (tableElement, indexCount) {
        return this.patientListRowElements.get(indexCount)
            .all(by.binding('item.patient_id'))
            .get(0).getText()
            .then(function (pId) {
                return pId;
            });
    };

    this.isConfirmedMoi = function(index) {
        var confirmButton = this.variantConfirmButtonList
        return confirmButton.get(index).getAttribute('checked').then(function (enabled) {
            if (enabled){
                return true;
            } else{
                return false;
            }
        })
    };

    this.isAMoi = function(index, amoiIndex) {
        var row = element.all(by.repeater('item in $ctrl.gridOptions.data')).get(index);
        return row.all(by.css('[treatment-arms="item.amois"]')).get(0).isPresent().then(function (presence) {
            if(presence){
                amoiIndex.push(index);
            }
            return amoiIndex;
        })
    };

    this.expectEnabled = function(checkBoxList, index, enabled, callback) {
        if(enabled === 'disabled'){
            expect(checkBoxList.get(index).getAttribute('disabled')).to.eventually.eql('true');
        } else {
            expect(checkBoxList.get(index).getAttribute('disabled')).to.eventually.eql(null);
        }
    }

    this.trimSurgicalEventId =  function(completeText){
      return completeText.replace('Surgical Event ', '').replace(/\|.+/, '').trim();
    };

    this.combineVariantData = function(response){
        var filteredList = [];
        var variantList = [ 'snv_indels', 'copy_number_variants', 'gene_fusions' ]
        for(variantType of variantList){
//            console.log(response[variantType])
            if(response[variantType].length > 0){
                for (index in response[variantType]){
                    filteredList.push(response[variantType][index])
                }
            }
        }
        return filteredList;
    };

    function setPatientId(id) {
        patientId = id;
    }

    this.setPatientData = function(data){
        patientData = data;
    };

    function getPatientData(){
        return patientData;
    };

    this.getPatientId = function () {
        return patientId;
    };

    this.checkPatientMainTabs = function() {
        //check for number of tabs
        expect(element(by.css('li.uib-tab.nav-item')).count()).to.eventually.equal()
    };
};

module.exports = new PatientPage();
