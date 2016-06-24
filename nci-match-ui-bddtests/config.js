/**
 * Created by raseel.mohamed on 6/3/16
 */
var helper = require('./support/setup');

exports.config = {
    baseUrl: 'http://pedmatch.org',  //when developing tests use http://localhost:9000',

    seleniumAddress: 'http://localhost:4444/wd/hub',
    capabilities: {
        browserName: 'chrome',
        version: ''
    },

    // capabilities: {
    //     browserName: 'firefox',
    //     version: '',
    //     firefox_binary: '/Applications/Firefox.app/Contents/MacOS/firefox-bin'
    // },

    // This section to trigger the multicapabilities or running multiple browsers.
    // getMultiCapabilities : helper.getFireFoxProfile,
    // maxSessions : 2,

    specs: [
        // Login Page
        'features/loginPage.feature',

        //Treatment Arm details page
        'features/TA_01_Analysis.feature',
        'features/TA_02_Rules.feature'
    ],

    getPageTimeout: 10000,

    framework: 'custom',
    frameworkPath: require.resolve('protractor-cucumber-framework'),
    cucumberOpts: {
        require: ['support/env.js',
                  'features/step_definitions/*.js',
                  'support/hooks.js' ],
        format: 'pretty',
        format: 'json:results/result.json'

    },
    //resultsJsonOutputFile: <to find out> process.env['HOME'] + '/Desktop/report.json'
};