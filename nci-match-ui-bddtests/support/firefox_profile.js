/**
 * This is the profile for Firefox
 * Created by: Raseel Mohamed
 * Date: 11/28/2016
 */

var FirefoxProfile = require('firefox-profile');
var downloadPath   = process.env.HOME + 'downloads';

exports.getFirefoxProfile = function () {
    var profile = new FirefoxProfile();
    profile.setPreference('browser.download.folderList', 2);
    profile.setPreference('browser.download.defaultFolder', downloadPath);
    profile.setPreference('browser.download.downloadDir', false);
    profile.setPreference('browser.download.panel.shown', false);
    profile.setPreference('browser.download.manager.showWhenStarting', false);
    profile.setPreference('browser.helperApps.neverAsk.openFile', 'Application/octet-stream');
    profile.setPreference('browser.helperApps.neverAsk.saveToDisk', 'Application/octet-stream');
    profile.encoded(function(encodedProfile){
        firefox_profile: encodedProfile
    })
};



