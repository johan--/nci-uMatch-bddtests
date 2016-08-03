/**
 * Created by raseel.mohamed on 6/23/16
 */

var PatientPage = function () {
    var patientId;
    var patientData;

    this.patientListTable = element(by.css('table[datatable="ng"]'));
    this.patientListHeaders = element.all(by.css('table[datatable="ng"] th[colspan="1"]'));
    this.patientListRowElements = element.all(by.repeater("patient in patientList"));


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
        'Off Trial Date'
    ];


    // Disease Summary table information on the patient details page.
    this.diseaseSummaryTable = element.all(by.css('.header-info-box.top-main-header-box')).get(1);
    //Patient details page main tabs
    this.actualMainTabs = element.all(by.css('li.uib-tab.nav-item'));
    // This element gives access to the current active tab
    this.currentActiveTab = element(by.css('.active[ng-class="{active: tabset.active === tab.index}"]'));
    //This element captures the sub headings under all the Tabs.
    // Though it captures all the headings, only the active tab's headings are populated in the array
    this.mainTabSubHeadingArray = element.all(by.css('.ibox-title.ibox-title-no-line>h3'));


    // *****************  Summary Tab  ********************//
    // Accessing the patient timeline
    this.patientTimelineElementArray = element.all(by.repeater('timelineEvent in data.timeline'));
    //Accessing the Treatment Arm History
    this.treatmentArmsHistoryElementArray = element.all(by.repeater('ta in data.ta_history'));

    // *****************  Surgical Event Tab  ********************//
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

    // *****************  Tissue Reports / Blood Variant Reports Tab  ********************//
    // This the master panel STRING for Tissue reports
    this.tissueMasterPanelString = 'div[ng-if="currentTissueVariantReport"]';
    // master panel string for blood variant reports
    this.bloodMasterPanelString = 'div[ng-if="currentBloodVariantReport"]';
    //The String is the locator to get access to all the tables under the variant Report section namely, SNV, CNV and GeneFusion
    this.tissueTableString = 'div[ng-if="variantReportMode === \'FILTERED\'"]>.table-responsive';

    // the hash below gives you access to the repeater locator string for the table based on the type of variant
    this.tableTypeRepeaterString = {
        "SNVs/MNVs/Indels": "variant in currentTissueVariantReport.variants.snvs_and_indels",
        "Copy Number Variant(s)":"variant in currentTissueVariantReport.variants.copy_number_variants",
        "Gene Fusion(s)":"variant in currentTissueVariantReport.variants.gene_fusions"

    };


    // This the drop down for the surgical event under the Tissue Reports and blood variant.
    this.variantReportDropDown = element(by.binding('tissueVariantReportOption.text'));
    this.bloodVariantReportDropDown = element(by.binding('bloodVariantReportOption.text'));

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

    // This is the assignment Report Section panel. You can get access to the other elements within this panel by using #all(by.<property>)
    this.assignmentReportSection = element.all(by.css("div[ng-if=\"variantReportMode!=='QC'\"]")).get(0);

    //These are the elements present in the summary boxes of blood variant reports
    this.bloodAnalysisId        = element(by.binding('currentBloodVariantReport.analysis_id'));
    this.bloodMolecularId       = element(by.binding('currentBloodVariantReport.molecular_id'));
    this.bloodFileReceivedDate  = element(by.binding('currentBloodVariantReport.variant_report_received_date'));
    this.bloodReportStatus      = element(by.binding('currentBloodVariantReport.status'));
    this.bloodTotalVariants     = element(by.binding('currentBloodVariantReport.total_variants'));
    this.bloodTotalCellularity  = element(by.binding('currentBloodVariantReport.cellularity'));


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

    this.expectedPatientMainTabs = [ 'Summary', 'Surgical Events', 'Tissue Reports', 'Blood Variant Reports', 'Documents'];

    this.expectedMainTabSubHeadings = ['Actions Needed', 'Treatment Arm History', 'Patient Timeline',
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



    //**************************** Functions **********************//

    // For whatever zero based row that we want, get the patient Id for that row.
    this.returnPatientId = function (tableElement, indexCount) {
        return this.patientListRowElements.get(indexCount)
            .all(by.binding('::patient.patient_id '))
            .get(0).getText()
            .then(function (patientId) {
                setPatientId(patientId);
                return patientId;
            });
    };

    this.trimSurgicalEventId =  function(completeText){
      return completeText.replace('Surgical Event ', '').replace(/\|.+/, '').trim();
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
