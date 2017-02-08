var CliaPage = function () {
    this.pageTitle = 'MATCHBox | CLIA Labs'

    this.mochaSectionButton = element(by.css('div.toolbar-row [ng-class="{\'active\' : (sitename==\'MoCha\')}"]'));
    this.mdaSectionButton   = element(by.css('div.toolbar-row [ng-class="{\'active\' : (sitename==\'MDACC\')}"]'));

    this.mochaPositiveGrid      = element(by.css('clia_positive_samples[site="MoCha"]'));
    this.mochaNoTemplateGrid    = element(by.css('clia_ntc_samples[site="MoCha"]'));
    this.mochaProficiencyGrid   = element(by.css('clia_pc_samples[site="MoCha"]'));
    this.mdaPositiveGrid        = element(by.css('clia_positive_samples[site="MDACC"]'));
    this.mdaNoTemplateGrid      = element(by.css('clia_ntc_samples[site="MDACC"]'));
    this.mdaProficiencyGrid     = element(by.css('clia_pc_samples[site="MDACC"]'));

    this.sampleDetailHeaders    = element.all(by.css('.header-info-box'));
    this.sampleDetailMolecId    = element(by.binding('data.molecular_id'));
    this.sampleDetailAnalysisId = element(by.binding('data.analysis_id'));
    this.sampleDetailLoadedDt   = element(by.binding('data.date_molecular_id_created'));
    this.sampleDetailTorrentVer = element(by.binding('data.torrent_variant_caller_version'));
    this.sampleDetailPosCtrlVer = element(by.binding('data.positive_control_version'));
    this.sampleDetailRecvdDate  = element(by.binding('data.date_variant_received'));
    this.sampleDetailStatus     = element(by.binding('data.report_status | dashify'));
    this.sampleDetailComments   = element(by.binding('data.comments'));
    this.sampleDetailTotVariant = element(by.binding('data.total_variants'));
    this.sampleDetailMAPD       = element(by.binding('data.mapd'));
    this.sampleDetailCell       = element(by.binding('data.cellularity'));

    this.confirmChangeCommentField     = element(by.css('input[name="comment"]'));  // This is the confirmation modal for individual rejection
    this.confirmVRStatusCommentField   = element(by.css('input[id="cgPromptInput"]')); // THis is the confirmation modal for the complete VR rejection

    this.sampleDetailTableHead  = element.all(by.css('.ibox-title.ibox-title-no-line-no-padding'));
    this.samplePositivePanel    = element(by.css('clia-vr-positive'));
    this.sampleFalsePosPanel    = element(by.css('clia-vr-false-positive'));
    this.ntcSNVPanel            = element(by.css('clia-vr-table-snv-mnv-indel'))
    this.ntcCNVPanel            = element(by.css('clia-vr-table-cnv'))
    this.ntcGeneFusionPanel     = element(by.css('clia-vr-table-gf'))
    this.proficiencySNVPanel    = element(by.css('clia-vr-table-snv-mnv-indel-with-check'))
    this.proficiencyCNVPanel    = element(by.css('clia-vr-table-cnv-with-check'))
    this.proficiencyGFPanel     = element(by.css('clia-vr-table-gf-with-check'))

    this.acceptNtcButton = element(by.css('button[ng-click="$ctrl.changeNtcStatusWithComment()"]'));
    this.rejectPcButton = element(by.css('button[ng-click="$ctrl.changePcStatusWithComment()"]'));
    this.confirmPncButton = element(by.css('button[ng-click="$ctrl.changePncStatusWithComment(\'PASSED\')"]'));
    this.confirmVRStatusCommentField = element(by.css('input[id="cgPromptInput"]')); // THis is the confirmation modal for the complete VR rejection

    // Expectation values
    this.expectedMsnTableHeading  = ['Molecular ID', 'Date Created', 'Date Received', 'Variant Reports', 'Status']
    this.expPositiveSampleHeaders = {
        'left': [
            'Molecular ID', 'Analysis ID', 'Ion Reporter ID', 'Positive Control Loaded Date',
            'Torrent Variant Caller Version', 'Positive Control Version', 'Status'
        ],
        'right': [
            'Total Variants', 'MAPD', 'Cellularity', 'File Received Date', 'Files'
        ]

    };

    this.expNonTempCrtlHeaders    = {
        'left': [
            'Molecular ID', 'Analysis ID', 'Ion Reporter ID',
            'Torrent Variant Caller Version', 'Status'
        ],
        'right': [
            'Total Variants', 'MAPD', 'Cellularity', 'File Received Date', 'Files'
        ]
    };

    this.expProfAndCompCrtlHeaders = {
        'left': [
            'Molecular ID', 'Analysis ID', 'Ion Reporter ID', 'Torrent Variant Caller Version',
            'Status'
        ],
        'right': [
            'Total Variants', 'MAPD', 'Cellularity', 'File Received Date', 'Files'
        ]
    };
};

module.exports = new CliaPage();
