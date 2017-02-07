/**
 * Created by hendrikssonm on 2/7/17.
 */
var CliaVariantReportPage = function () {
    this.pageTitle = 'MATCHBox | CLIA Labs'
    this.acceptNtcButton = element(by.css("button[ng-click=\"$ctrl.changeNtcStatusWithComment()\"]"));
    this.rejectPcButton = element(by.css("button[ng-click=\"$ctrl.changePcStatusWithComment()\"]"));
    this.confirmVRStatusCommentField   = element(by.css('input[id="cgPromptInput"]')); // THis is the confirmation modal for the complete VR rejection
};
module.exports = new CliaVariantReportPage();