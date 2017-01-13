/**
 * Created by raseel.mohamed on 6/3/16
 */
var helper = require('./support/setup');

exports.config = {
    baseUrl: process.env.UI_HOSTNAME,  //when developing tests use http://localhost:9000',

    //seleniumAddress: 'http://localhost:4444/wd/hub',
//    chromeOnly: true,
//    directConnect: true,
    capabilities: {
        //browserName: 'firefox',
        //version: ''
        'browserName': 'phantomjs',
        'phantomjs.ghostdriver.cli.args': ['--loglevel=DEBUG']
    },
    restartBrowserBetweenTests: false,

    specs: [
        // Login Page
        'features/login_page.feature',

        // Critical
        'features/PA_06_Critical_Path.feature',

        // Patient details page
        'features/PA_01_Patient_List.feature',
        'features/PA_02_Patient_Summary.feature',
        'features/PA_03_Patient_SurgicalEvent.feature',
        'features/PA_04_Patient_Blood_Specimen.feature',
        'features/PA_05_Patient_Documents.feature',
        'features/SP_01_Specimen_Tracking.feature',
        'features/PA_08_User_Roles.feature',

        //Treatment Arm details page
        'features/TA_01_Analysis.feature',
        'features/TA_02_Rules.feature',

        // Dashboard page details page
        'features/HO_01_Dashboard.feature',

        // Clia Lab page
        'features/CL_01_CliaLab.feature',
        //Specimen Tracking page
        'features/SP_01_Specimen_Tracking.feature'
   ],

    getPageTimeout: 10000,
    params: {
        useAuth0 : true
    },


    onPrepare: function () {
      browser.manage().timeouts().setScriptTimeout(60000);
      browser.driver.manage().window().setSize(1600, 900);
    },

    framework: 'custom',
    frameworkPath: require.resolve('protractor-cucumber-framework'),
    cucumberOpts: {
        require: ['support/env.js',
                  'features/step_definitions/*.js',
                  'support/hooks.js' ],
        format: 'pretty',
        format: 'json:../results/output.json'

    }

    //resultsJsonOutputFile: <to find out> process.env['HOME'] + '/Desktop/report.json'

    // capabilities: {
    //     browserName: 'firefox',
    //     version: '',
    //     firefox_binary: '/Applications/Firefox.app/Contents/MacOS/firefox-bin'
    // },

    // This section to trigger the multicapabilities or running multiple browsers.
    // getMultiCapabilities : helper.getFireFoxProfile,
    // maxSessions : 2,

    // onPrepare: function () {
    //     global.isAngularSite = function(flag) {
    //         browser.ignoreSynchronization = !flag;
    //     }
    // },

};
