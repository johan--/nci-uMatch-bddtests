var CliaPage = function () {
    this.pageTitle = 'MATCHBox | CLIA Labs';

    //This section contains elements related to the tables and the search field
    this.searchPositiveSampleControl = element(by.css('clia_positive_samples input.form-control'));
    this.searchNoTemplateControl     = element(by.css('clia_ntc_samples input.form-control'));
    this.searchProficiencyCompetency = element(by.css('clia_pc_samples input.form-control'));

    this.searchTableMolecularId   = element.all(by.binding('item.molecular_id | dashify'));
    this.searchTableDateCreated   = element.all(by.binding('item.date_molecular_id_created | utc'));
    this.searchTableDateReceived  = element.all(by.binding('item.date_variant_received | utc'));
    this.searchTableVariantReport = element.all(by.css('a[ng-show="item.analysis_id && item.report_status"]'));
    this.searchTableStatus        = element.all(by.binding('item.report_status | msnstatus'));
    this.searchList               = element.all(by.css('tr[ng-repeat^="item in filtered"]'));

    this.mochaPositiveGrid      = element(by.css('clia_positive_samples[site="mocha"]'));
    this.mochaNoTemplateGrid    = element(by.css('clia_ntc_samples[site="mocha"]'));
    this.mochaProficiencyGrid   = element(by.css('clia_pc_samples[site="mocha"]'));
    this.mdaPositiveGrid        = element(by.css('clia_positive_samples[site="mda"]'));
    this.mdaNoTemplateGrid      = element(by.css('clia_ntc_samples[site="mda"]'));
    this.mdaProficiencyGrid     = element(by.css('clia_pc_samples[site="mda"]'));
    this.dtmPositiveGrid        = element(by.css('clia_positive_samples[site="dartmouth"]'));
    this.dtmNoTemplateGrid      = element(by.css('clia_ntc_samples[site="dartmouth"]'));
    this.dtmProficiencyGrid     = element(by.css('clia_pc_samples[site="dartmouth"]'));

    // These buttons take you to the individual mocha or mda sections.
    this.mochaSectionButton = element(by.cssContainingText('label[ng-click="setActiveTab(key,value)"]', 'MoCha'));
    this.mdaSectionButton   = element(by.cssContainingText('label[ng-click="setActiveTab(key,value)"]', 'MD Anderson'));
    this.dartmouthSectionButton = element(by.cssContainingText('label[ng-click="setActiveTab(key,value)"]', 'Dartmouth'));

    this.sampleDetailHeaders    = element.all(by.css('.header-info-box'));
    this.sampleDetailMolecId    = element(by.binding('data.molecular_id'));
    this.sampleDetailAnalysisId = element(by.binding('data.analysis_id'));
    this.sampleDetailLoadedDt   = element(by.binding('data.date_molecular_id_created'));
    this.sampleDetailTorrentVer = element(by.binding('data.torrent_variant_caller_version'));
    this.sampleDetailPosCtrlVer = element(by.binding('data.positive_control_version'));
    this.sampleDetailRecvdDate  = element(by.binding('data.date_variant_received'));
    this.positiveDetailStatus   = element.all(by.css('.header-info-box.clia-lab-vr-pc-header-box')).get(0).all(by.css('dd')).get(6);
    this.noTemplateDetailStatus = element.all(by.css('.header-info-box.clia-lab-vr-ntc-header-box')).get(0).all(by.css('dd')).get(4);
    this.profAndCompDetailStatus = element.all(by.css('.header-info-box.clia-lab-vr-pc-header-box')).get(0).all(by.css('dd')).get(4);

    this.sampleDetailComments   = element(by.binding('data.comments'));
    this.sampleDetailTotVariant = element(by.binding('data.total_variants'));
    this.sampleDetailMAPD       = element(by.binding('data.mapd'));
    this.sampleDetailCell       = element(by.binding('data.cellularity'));
    this.dateReceived           = element(by.binding('data.date_variant_received'));
    this.pool1Sum               = element(by.binding('oncomine_control_panel_summary.pool1Sum'));
    this.pool2Sum               = element(by.binding('oncomine_control_panel_summary.pool2Sum'));

    this.confirmChangeCommentField     = element(by.css('input[name="comment"]'));  // This is the confirmation modal for individual rejection
    this.confirmVRStatusCommentField   = element(by.css('input[id="cgPromptInput"]')); // THis is the confirmation modal for the complete VR rejection

    this.sampleDetailTableHead  = element.all(by.css('.ibox-title.ibox-title-no-line-no-padding'));
    this.samplePositivePanelTableColumn = element.all(by.css('#cliaVrTablePositive[grid-options="pendinPositiveGridOptions"] th'));
    this.sampleFalsePosTableColumn = element.all(by.css('#cliaVrTablePositive[grid-actions="pendinFalsePositiveGridActions"] th'));
    this.samplePositivePanel    = element(by.css('#cliaVrTablePositive[grid-options="pendinPositiveGridOptions"]'));
    this.sampleFalsePosPanel    = element(by.css('#cliaVrTablePositive[grid-actions="pendinFalsePositiveGridActions"]'));
    this.ntcSNVPanel            = element(by.css('clia-vr-table-snv-mnv-indel'));
    this.ntcCNVPanel            = element(by.css('clia-vr-table-cnv'));
    this.ntcGeneFusionPanel     = element(by.css('clia-vr-table-gf'));
    this.proficiencySNVPanel    = element(by.css('clia-vr-table-snv-mnv-indel-with-check'));
    this.proficiencyCNVPanel    = element(by.css('clia-vr-table-cnv-with-check'));
    this.proficiencyGFPanel     = element(by.css('clia-vr-table-gf-with-check'));

    this.QCSNVPanel             = element(by.id('cliaQcReportSnvMnvInd'));
    this.QCCNVPanel             = element(by.id('cliaQcReportCnv'));
    this.QCGeneFusionPanel      = element(by.id('cliaQcReportGeneFusion'));

    // this.infoPanel     = element(by.css('div.header-info-box clia-lab-vr-pc-header-box'))
    this.infoPanel = element.all(by.css('div.clia-lab-vr-pc-header-box'));

    // IR PAnel
    this.irTabs = element.all(by.css('li[ng-repeat="item in heartbeatList"]'));
    this.irIPAddress = element(by.binding('item.ip_address'));
    this.irIPInternalAddress = element(by.binding('item.internal_ip_address'));
    this.irHostName = element(by.binding('item.host_name'));
    this.irStatus = element(by.binding('item.ir_status'));
    this.irVersion = element(by.binding('item.ion_reporter_version'));
    this.irLastContact = element(by.binding('item.last_contact'));

    this.acceptNtcButton = element(by.css('button[ng-click="changeNtcStatusWithComment(\'PASSED\')"]'));
    this.rejectPcButton = element(by.css('button[ng-click="changePcStatusWithComment(\'FAILED\')"]'));
    this.confirmPncButton = element(by.css('button[ng-click="changePncStatusWithComment(\'PASSED\')"]'));
    this.statusCancelButton = element(by.css('button[ng-click="buttonClicked(button)"]'));
    this.confirmVRStatusCommentField = element(by.css('input[id="cgPromptInput"]')); // THis is the confirmation modal for the complete VR rejection

    // Expectation values
    this.expectedMsnTableHeading  = ['Molecular ID', 'Date Created', 'Date Received', 'Variant Reports', 'Status']
    this.expPositiveSampleHeaders = {
        'left': [
            'Molecular ID', 'Analysis ID', 'Ion Reporter ID', 'Positive Control Loaded Date',
            'Torrent Variant Caller Version', 'Positive Control Version', 'Status'
        ],
        'right': [
            'Total Variants', 'MAPD', 'Mapped Read', 'Pool 1 Total', 'Pool 2 Total',
            'Cellularity', 'File Received Date', 'Files'
        ]

    };

    this.expNonTempCrtlHeaders    = {
        'left': [
            'Molecular ID', 'Analysis ID', 'Ion Reporter ID',
            'Torrent Variant Caller Version', 'Status'
        ],
        'right': [
            'Total Variants', 'MAPD', 'Mapped Read', 'Pool 1 Total', 'Pool 2 Total', 'Cellularity', 'File Received Date', 'Files'
        ]
    };

    this.expProfAndCompCrtlHeaders = {
        'left': [
            'Molecular ID', 'Analysis ID', 'Ion Reporter ID', 'Torrent Variant Caller Version',
            'Status'
        ],
        'right': [
            'Total Variants', 'MAPD', 'Mapped Read', 'Pool 1 Total', 'Pool 2 Total', 'Cellularity', 'File Received Date', 'Files'
        ]
    };

    this.expectedPositiveControlsTableHeaders = ['', 'ID', 'Chrom', 'Position', 'Gene', 'Variant Type', 'Ref', 'Alternative', 'HGVS', 'Protein', 'Function']

    this.expectedFalsePostiveVariantTableHEaders = ['ID', 'Position', 'Gene', 'Variant Type', 'Ref', 'Alternative', 'HGVS', 'Protein']

    this.tabNameMapping = {
        'MoCha' : {
            'Positive Sample Controls': {
                'element': this.mochaPositiveGrid,
                'control_type': 'positive',
                'url_control_type': 'positive-control',
                'url_type': 'positive_sample_control',
                'searchElement': this.searchPositiveSampleControl
            },

            'No Template Control': {
                'element': this.mochaNoTemplateGrid,
                'control_type': 'no_template',
                'url_control_type': 'no-template-sample-control',
                'url_type' : 'no_template_control',
                'searchElement': this.searchNoTemplateControl
            },
            'Proficiency And Competency' : {
                'element': this.mochaProficiencyGrid,
                'control_type': 'proficiency_competency',
                'url_control_type': 'proficiency-competency-sample-control',
                'url_type': 'positive_sample_control',
                'searchElement': this.searchProficiencyCompetency
            }
        },
        'MD Anderson' : {
            'Positive Sample Controls': {
                'element': this.mdaPositiveGrid,
                'control_type': 'positive',
                'url_control_type': 'positive-control',
                'url_type': 'positive_sample_control',
                'searchElement': this.searchPositiveSampleControl
            },
            'No Template Control': {
                'element': this.mdaNoTemplateGrid,
                'control_type': 'no_template',
                'url_control_type': 'no-template-sample-control',
                'url_type' : 'no_template_control',
                'searchElement': this.searchNoTemplateControl
            },
            'Proficiency And Competency' : {
                'element': this.mdaProficiencyGrid,
                'control_type': 'proficiency_competency',
                'url_control_type': 'proficiency-competency-sample-control',
                'url_type': 'positive_sample_control',
                'searchElement': this.searchProficiencyCompetency
            }
        },
        'Dartmouth': {
            'Positive Sample Controls': {
                'element': this.dtmPositiveGrid,
                'control_type': 'positive',
                'url_control_type': 'positive-control',
                'url_type': 'positive_sample_control',
                'searchElement': this.searchPositiveSampleControl
            },
            'No Template Control': {
                'element': this.dtmNoTemplateGrid,
                'control_type': 'no_template',
                'url_control_type': 'no-template-sample-control',
                'url_type' : 'no_template_control',
                'searchElement': this.searchNoTemplateControl
            },
            'Proficiency And Competency' : {
                'element': this.dtmProficiencyGrid,
                'control_type': 'proficiency_competency',
                'url_control_type': 'proficiency-competency-sample-control',
                'url_type': 'positive_sample_control',
                'searchElement': this.searchProficiencyCompetency
            }
        }
    };
};

module.exports = new CliaPage();
