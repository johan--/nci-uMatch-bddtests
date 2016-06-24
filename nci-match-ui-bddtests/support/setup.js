/**
 Script created by: Raseel Mohamed
 email: raseel.mohamed@nih.gov
 date: 06/23/2016
 */

var FirefoxProfile = require ('firefox-profile');
var q = require ('q');

exports.getFireFoxProfile = function() {
    var deferred = q.defer();
    var firefoxProfile = new FirefoxProfile();
    var downloadPath = process.env.HOME + '/Downloads';


    firefoxProfile.setPreference('browser.download.folderList', 2);
    firefoxProfile.setPreference('browser.download.dir', downloadPath);
    firefoxProfile.setPreference('browser.download.manager.showWhenStarting', false);
    firefoxProfile.setPreference('browser. helperApps. neverAsk. openFile', 'Application/octet-stream');
    firefoxProfile.setPreference('browser.helperApps.neverAsk.saveToDisk', 'Application/octet-stream');
    firefoxProfile.encoded(function (encodedProfile) {
        var multiCapabilities = [
            {
                browserName: 'firefox',
                firefox_binary: '/Applications/Firefox.app/Contents/MacOS/firefox-bin',
                firefox_profile: encodedProfile
            },
            //{
            //    'browserName': 'safari',
            //    'browser.download.dir': "/Users/ramaniv/Downloads/MatchUITests/"
            //
            //},
            {
                'browserName': 'chrome',
                'chromeOptions': {
                    // Get rid of --ignore-certificate yellow warning
                    //args: ['--no-sandbox', '--test-type=browser'],
                    // Set download path and avoid prompting for download even though
                    // this is already the default on Chrome but for completeness
                    prefs: {
                        'download': {
                            'prompt_for_download': false,
                            'default_directory': downloadPath, //'/Users/ramaniv/Downloads/MatchUITests/',
                        }
                    }
                }
            }
        ];
        deferred.resolve(multiCapabilities);
    });
    return deferred.promise;
};
