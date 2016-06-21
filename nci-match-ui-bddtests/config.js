/**
 * Created by raseel.mohamed on 6/3/16
 */

exports.config = {
    baseUrl: 'http://localhost:9000',

    seleniumAddress: 'http://localhost:4444/wd/hub',
    capabilities: {
        browserName: 'chrome',
        version: ''
    },
    // multiCapabilities: [{
    //     'browserName': 'firefox'
    // },{
    //     'browserName': 'chrome'
    // }],

    specs: [
        // Login Page
        'features/loginPage.feature',

        //Treatment Arm details page
        'features/TA_01_Analysis.feature',
        'features/TA_02_Rules.feature'
    ],

    framework: 'custom',
    frameworkPath: require.resolve('protractor-cucumber-framework'),
    cucumberOpts: {
        require: ['features/step_definitions/*.js',
                  'support/hooks.js' ],
        format: 'pretty'
    }
};