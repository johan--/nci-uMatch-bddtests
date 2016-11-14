var CliaPage = function () {
    this.pageTitle = 'MATCHBox | CLIA Labs'

    this.mochaSectionButton = element(by.css('div.toolbar-row [ng-class="{\'active\' : (sitename==\'MoCha\')}"]'));
    this.mdaSectionButton   = element(by.css('div.toolbar-row [ng-class="{\'active\' : (sitename==\'MDACC\')}"]'));

    this.mochaPositiveGrid      = element(by.css('clia_positive_samples[site="MoCha"]'))
    this.mochaNoTemplateGrid    = element(by.css('clia_ntc_samples[site="MoCha"]'))
    this.mochaProficiencyGrid   = element(by.css('clia_pc_samples[site="MoCha"]'))
    this.mdaPositiveGrid        = element(by.css('clia_positive_samples[site="MDACC"]'))
    this.mdaNoTemplateGrid      = element(by.css('clia_ntc_samples[site="MDACC"]'))
    this.mdaProficiencyGrid     = element(by.css('clia_pc_samples[site="MDACC"]'))


};

module.exports = new CliaPage();